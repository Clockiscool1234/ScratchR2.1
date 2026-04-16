package render3d
{
   import com.adobe.utils.*;
   import filters.FilterPack;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.display.Stage3D;
   import flash.display.StageQuality;
   import flash.display3D.*;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Vector3D;
   import flash.system.Capabilities;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import flash.utils.Endian;
   
   public class DisplayObjectContainerIn3D extends Sprite
   {
      
      public static var texSizeMax:int = 2048;
      
      public static var texSize:int = 1024;
      
      public static var maxTextures:uint = 15;
      
      private static const FX_PIXELATE:String = "pixelate";
      
      private static const FX_COLOR:String = "color";
      
      private static const FX_FISHEYE:String = "fisheye";
      
      private static const FX_WHIRL:String = "whirl";
      
      private static const FX_MOSAIC:String = "mosaic";
      
      private static const FX_BRIGHTNESS:String = "brightness";
      
      private static const FX_GHOST:String = "ghost";
      
      private static const effectNames:Array = [FX_PIXELATE,FX_COLOR,FX_FISHEYE,FX_WHIRL,FX_MOSAIC,FX_BRIGHTNESS,FX_GHOST];
      
      private static var isIOS:Boolean = Capabilities.os.indexOf("iPhone") != -1;
      
      private static var originPt:Point = new Point();
      
      private static const maxScale:uint = 4;
      
      private static var noTrans:ColorTransform = new ColorTransform();
      
      private static var sRawData:Vector.<Number> = new <Number>[1,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1];
      
      private var contextRequested:Boolean = false;
      
      private var __context:Context3D;
      
      private var indexBuffer:IndexBuffer3D;
      
      private var vertexBuffer:VertexBuffer3D;
      
      private var currentShader:Program3D;
      
      private var shaderCache:Object;
      
      private var vertexShaderCode:String;
      
      private var fragmentShaderCode:String;
      
      private var fragmentShaderAssembler:AGALMacroAssembler;
      
      private var vertexShaderAssembler:AGALMacroAssembler;
      
      private var spriteBitmaps:Dictionary;
      
      private var spriteRenderOpts:Dictionary;
      
      private var bitmapsByID:Object;
      
      private var textures:Array;
      
      private var testBMs:Array;
      
      private var textureIndexByID:Object;
      
      private var penPacked:Boolean;
      
      private var indexData:ByteArray = new ByteArray();
      
      private var vertexData:ByteArray = new ByteArray();
      
      private var projMatrix:Matrix3D;
      
      private var textureCount:int;
      
      private var childrenChanged:Boolean;
      
      private var unrenderedChildren:Dictionary;
      
      private var stampsByID:Object;
      
      private var uiContainer:StageUIContainer;
      
      private var scratchStage:Sprite;
      
      private var stagePenLayer:DisplayObject;
      
      private var stage3D:Stage3D;
      
      private var pixelateAll:Boolean;
      
      private var statusCallback:Function;
      
      private var appScale:Number = 1;
      
      private var scissorRect:Rectangle;
      
      private var childrenDrawn:int = 0;
      
      private var tlPoint:Point;
      
      private var boundsDict:Dictionary = new Dictionary();
      
      private var drawMatrix:Matrix3D = new Matrix3D();
      
      private var currentTexture:ScratchTextureBitmap = null;
      
      private var currentTextureFilter:String = null;
      
      private var matrixScratchpad:Vector.<Number> = new Vector.<Number>(16,true);
      
      private const DegreesToRadians:Number = -0.017453292519943295;
      
      private var currentBlendFactor:String;
      
      public var debugTexture:Boolean = false;
      
      private var emptyStamp:BitmapData = new BitmapData(1,1,true,0);
      
      private var cachedOtherRenderBitmaps:Dictionary;
      
      private var FC:Vector.<Vector.<Number>> = Vector.<Vector.<Number>>([Vector.<Number>([1,2,0,0.5]),Vector.<Number>([Math.PI,180,60,120]),Vector.<Number>([240,3,4,5]),Vector.<Number>([6,0.11,0.09,0.001]),Vector.<Number>([360,0,0,0]),Vector.<Number>([0,0,0,0]),Vector.<Number>([0,0,0,0]),Vector.<Number>([0,0,0,0])]);
      
      private var availableEffectRegisters:Array = ["fc6.xxxx","fc6.yyyy","fc6.zzzz","fc6.wwww","fc7.xxxx","fc7.yyyy","fc7.zzzz","fc7.wwww"];
      
      private var vertexShaderParts:Array = [];
      
      private var fragmentShaderParts:Array = [];
      
      private var callbackCalled:Boolean;
      
      public function DisplayObjectContainerIn3D()
      {
         super();
         if(effectNames.length != FilterPack.filterNames.length)
         {
            Scratch.app.logMessage("Effect list mismatch",{
               "effectNames":effectNames,
               "filterPack":FilterPack.filterNames
            });
         }
         this.uiContainer = new StageUIContainer();
         this.uiContainer.graphics.lineStyle(1);
         this.spriteBitmaps = new Dictionary();
         this.spriteRenderOpts = new Dictionary();
         this.shaderCache = {};
         this.fragmentShaderAssembler = new AGALMacroAssembler();
         this.vertexShaderAssembler = new AGALMacroAssembler();
         this.bitmapsByID = {};
         this.textureIndexByID = {};
         this.textures = [];
         this.cachedOtherRenderBitmaps = new Dictionary();
         this.penPacked = false;
         this.testBMs = [];
         this.textureCount = 0;
         this.childrenChanged = false;
         this.pixelateAll = false;
         this.unrenderedChildren = new Dictionary();
         this.stampsByID = {};
         this.loadShaders();
         this.makeBufferData();
      }
      
      private static function calculateShaderID(param1:Object) : int
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:String = null;
         var _loc2_:int = 0;
         if(param1)
         {
            _loc3_ = int(effectNames.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = effectNames[_loc4_];
               _loc2_ = _loc2_ << 1 | (param1[_loc5_] ? 1 : 0);
               _loc4_++;
            }
         }
         return _loc2_;
      }
      
      public function setStatusCallback(param1:Function) : void
      {
         this.statusCallback = param1;
      }
      
      public function setStage(param1:Sprite, param2:DisplayObject) : void
      {
         var _loc3_:int = 0;
         if(this.scratchStage)
         {
            this.scratchStage.removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
            this.scratchStage.removeEventListener(Event.ADDED,this.childAdded);
            this.scratchStage.removeEventListener(Event.REMOVED,this.childRemoved);
            this.scratchStage.removeEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage);
            this.scratchStage.removeEventListener(Event.ENTER_FRAME,this.onRender);
            if(this.scratchStage.stage)
            {
               this.scratchStage.stage.removeEventListener(Event.RESIZE,this.onStageResize);
            }
            this.scratchStage.cacheAsBitmap = true;
            (this.scratchStage as Object).img.cacheAsBitmap = true;
            this.scratchStage.visible = true;
            while(this.uiContainer.numChildren)
            {
               this.scratchStage.addChild(this.uiContainer.getChildAt(0));
            }
            _loc3_ = 0;
            while(_loc3_ < this.textures.length)
            {
               this.textures[_loc3_].disposeTexture();
               _loc3_++;
            }
            this.textures.length = 0;
            this.spriteBitmaps = new Dictionary();
            this.spriteRenderOpts = new Dictionary();
            this.boundsDict = new Dictionary();
            this.cachedOtherRenderBitmaps = new Dictionary();
            this.stampsByID = {};
            this.cleanUpUnusedBitmaps();
         }
         this.scratchStage = param1;
         this.stagePenLayer = param2;
         if(this.scratchStage)
         {
            this.scratchStage.addEventListener(Event.ADDED_TO_STAGE,this.addedToStage,false,0,true);
            this.scratchStage.addEventListener(Event.ADDED,this.childAdded,false,0,true);
            this.scratchStage.addEventListener(Event.REMOVED,this.childRemoved,false,0,true);
            this.scratchStage.addEventListener(Event.REMOVED_FROM_STAGE,this.removedFromStage,false,0,true);
            this.scratchStage.addEventListener(Event.ENTER_FRAME,this.onRender,false,0,true);
            if(this.scratchStage.stage)
            {
               this.scratchStage.stage.addEventListener(Event.RESIZE,this.onStageResize,false,0,true);
            }
            if(this.__context)
            {
               this.scratchStage.visible = false;
            }
            this.scratchStage.cacheAsBitmap = false;
            (this.scratchStage as Object).img.cacheAsBitmap = true;
         }
         else
         {
            this.stage3D.removeEventListener(Event.CONTEXT3D_CREATE,this.context3DCreated);
         }
      }
      
      private function addedToStage(param1:Event = null) : void
      {
         var _loc3_:DisplayObject = null;
         if(Boolean(param1) && param1.target != this.scratchStage)
         {
            return;
         }
         this.scratchStage.parent.addChildAt(this.uiContainer,this.scratchStage.parent.getChildIndex(this.scratchStage) + 1);
         var _loc2_:uint = 0;
         while(_loc2_ < this.scratchStage.numChildren)
         {
            _loc3_ = this.scratchStage.getChildAt(_loc2_);
            if(this.isUI(_loc3_))
            {
               this.uiContainer.addChild(_loc3_);
               _loc2_--;
            }
            else if(!("img" in _loc3_))
            {
               this.boundsDict[_loc3_] = _loc3_.getBounds(_loc3_);
            }
            _loc2_++;
         }
         this.uiContainer.transform.matrix = this.scratchStage.transform.matrix.clone();
         this.uiContainer.scrollRect = this.scratchStage.scrollRect;
         this.scratchStage.stage.addEventListener(Event.RESIZE,this.onStageResize,false,0,true);
         this.penPacked = false;
         if(!this.__context)
         {
            this.stage3D = this.scratchStage.stage.stage3Ds[0];
            this.callbackCalled = false;
            this.requestContext3D();
         }
         else
         {
            this.setRenderView();
         }
         this.tlPoint = this.scratchStage.localToGlobal(originPt);
      }
      
      private function removedFromStage(param1:Event) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:int = 0;
         if(param1.target != this.scratchStage)
         {
            return;
         }
         this.uiContainer.parent.removeChild(this.uiContainer);
         if(Boolean(this.testBMs) && Boolean(this.testBMs.length))
         {
            _loc4_ = 0;
            while(_loc4_ < this.testBMs.length)
            {
               this.scratchStage.stage.removeChild(this.testBMs[_loc4_]);
               _loc4_++;
            }
            this.testBMs = [];
         }
         for(_loc2_ in this.bitmapsByID)
         {
            if(this.bitmapsByID[_loc2_] is ChildRender)
            {
               this.bitmapsByID[_loc2_].dispose();
            }
         }
         this.bitmapsByID = {};
         for(_loc3_ in this.cachedOtherRenderBitmaps)
         {
            this.cachedOtherRenderBitmaps[_loc3_].dispose();
         }
         this.cachedOtherRenderBitmaps = new Dictionary();
         this.scratchStage.stage.removeEventListener(Event.RESIZE,this.onStageResize);
         this.onContextLoss(param1);
         if(this.__context)
         {
            this.__context.dispose();
            this.__context = null;
         }
      }
      
      public function onStageResize(param1:Event = null) : void
      {
         this.scissorRect = null;
         if(this.scratchStage)
         {
            if(this.scratchStage.parent)
            {
               this.appScale = this.scratchStage.stage.scaleX * this.scratchStage.root.scaleX * this.scratchStage.scaleX;
            }
            if(this.uiContainer)
            {
               this.uiContainer.transform.matrix = this.scratchStage.transform.matrix.clone();
            }
         }
         this.setRenderView();
      }
      
      public function setRenderView() : void
      {
         var _loc1_:Point = this.scratchStage.localToGlobal(originPt);
         this.stage3D.x = _loc1_.x;
         this.stage3D.y = _loc1_.y;
         var _loc2_:uint = Math.ceil(480 * this.appScale);
         var _loc3_:uint = Math.ceil(360 * this.appScale);
         var _loc4_:Rectangle = new Rectangle(0,0,_loc2_,_loc3_);
         if(Boolean(this.stage3D.context3D) && (!this.scissorRect || !this.scissorRect.equals(_loc4_)))
         {
            this.scissorRect = _loc4_;
            this.projMatrix = this.createOrthographicProjectionMatrix(480,360,0,0);
            this.stage3D.context3D.setScissorRectangle(this.scissorRect);
            this.stage3D.context3D.configureBackBuffer(_loc2_,_loc3_,0,false,true);
            this.childrenChanged = true;
         }
      }
      
      private function childAdded(param1:Event) : void
      {
         if(param1.target.parent != this.scratchStage)
         {
            return;
         }
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(this.isUI(_loc2_))
         {
            this.uiContainer.addChild(_loc2_);
            return;
         }
         this.childrenChanged = true;
         if(!("img" in _loc2_))
         {
            this.boundsDict[_loc2_] = _loc2_.getBounds(_loc2_);
         }
      }
      
      private function isUI(param1:DisplayObject) : Boolean
      {
         return "target" in param1 || "answer" in param1 || "pointsLeft" in param1;
      }
      
      private function childRemoved(param1:Event) : void
      {
         if(param1.target.parent != this.scratchStage)
         {
            return;
         }
         this.childrenChanged = true;
         var _loc2_:String = this.spriteBitmaps[param1.target];
         if(_loc2_)
         {
            delete this.spriteBitmaps[param1.target];
         }
         if(this.cachedOtherRenderBitmaps[param1.target])
         {
            this.cachedOtherRenderBitmaps[param1.target].dispose();
            delete this.cachedOtherRenderBitmaps[param1.target];
         }
         if(this.boundsDict[param1.target])
         {
            delete this.boundsDict[param1.target];
         }
         var _loc3_:DisplayObject = param1.target as DisplayObject;
         if(_loc3_)
         {
            this.updateFilters(_loc3_,null);
            delete this.spriteRenderOpts[_loc3_];
         }
      }
      
      private function makeBufferData() : void
      {
         this.indexData.clear();
         this.indexData.endian = Endian.LITTLE_ENDIAN;
         this.indexData.position = 0;
         this.indexData.writeShort(0);
         this.indexData.writeShort(1);
         this.indexData.writeShort(2);
         this.indexData.writeShort(2);
         this.indexData.writeShort(3);
         this.indexData.writeShort(0);
         this.vertexData.clear();
         this.vertexData.endian = Endian.LITTLE_ENDIAN;
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(1);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(1);
         this.vertexData.writeFloat(1);
         this.vertexData.writeFloat(1);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(1);
         this.vertexData.writeFloat(1);
         this.vertexData.writeFloat(1);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(0);
         this.vertexData.writeFloat(1);
         this.vertexData.writeFloat(0);
      }
      
      private function checkBuffers() : Boolean
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.__context)
         {
            if(this.indexBuffer == null)
            {
               _loc1_ = 6;
               this.indexBuffer = this.__context.createIndexBuffer(_loc1_);
               this.indexBuffer.uploadFromByteArray(this.indexData,0,0,_loc1_);
            }
            if(this.vertexBuffer == null)
            {
               _loc2_ = 4;
               _loc3_ = 5;
               this.vertexBuffer = this.__context.createVertexBuffer(_loc2_,_loc3_);
               this.vertexBuffer.uploadFromByteArray(this.vertexData,0,0,_loc2_);
               this.uploadConstantValues();
            }
            return true;
         }
         this.indexBuffer = null;
         this.vertexBuffer = null;
         return false;
      }
      
      private function draw() : void
      {
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:uint = 0;
         var _loc1_:Boolean = false;
         var _loc2_:uint = uint(this.scratchStage.numChildren);
         this.checkBuffers();
         if(this.childrenChanged)
         {
            if(this.debugTexture)
            {
               this.uiContainer.graphics.clear();
               this.uiContainer.graphics.lineStyle(2,16764108);
            }
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.scratchStage.getChildAt(_loc3_);
               if(_loc4_.visible)
               {
                  _loc1_ = this.checkChildRender(_loc4_) || _loc1_;
               }
               _loc3_++;
            }
         }
         else
         {
            for(_loc6_ in this.unrenderedChildren)
            {
               if((_loc6_ as DisplayObject).visible)
               {
                  _loc1_ = this.checkChildRender(_loc6_ as DisplayObject) || _loc1_;
               }
            }
         }
         if(_loc1_)
         {
            this.packTextureBitmaps();
         }
         this.__context.clear(1,1,1,1);
         if(this.childrenChanged)
         {
            this.vertexData.position = 0;
            this.childrenDrawn = 0;
            this.setBlendFactors(true);
            _loc7_ = 0;
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = this.scratchStage.getChildAt(_loc3_);
               if(!_loc4_.visible)
               {
                  _loc7_++;
               }
               else if(this.drawChild(_loc4_))
               {
                  ++this.childrenDrawn;
               }
               _loc3_++;
            }
         }
         for(_loc5_ in this.unrenderedChildren)
         {
            delete this.unrenderedChildren[_loc5_];
         }
      }
      
      private function drawChild(param1:DisplayObject) : Boolean
      {
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:ScratchTextureBitmap = null;
         var _loc2_:Rectangle = this.boundsDict[param1];
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:String = this.spriteBitmaps[param1];
         var _loc4_:Object = this.spriteRenderOpts[param1];
         var _loc5_:Number = _loc2_.width * param1.scaleX;
         if(_loc4_)
         {
            _loc6_ = _loc4_.effects;
            _loc7_ = int(_loc4_.shaderID);
            if(_loc7_ < 0)
            {
               _loc7_ = int(_loc4_.shaderID = calculateShaderID(_loc6_));
            }
         }
         else
         {
            _loc6_ = null;
            _loc7_ = 0;
         }
         this.switchShaders(_loc7_);
         _loc8_ = int(this.textureIndexByID[_loc3_]);
         _loc9_ = this.textures[_loc8_];
         var _loc10_:Rectangle = _loc9_.getRect(_loc3_);
         var _loc11_:Boolean = this.pixelateAll || _loc4_ && param1.rotation % 90 == 0 && (this.closeTo(_loc5_,_loc10_.width) || _loc4_.bitmap != null);
         this.setTexture(_loc9_,_loc11_);
         this.setMatrix(param1,_loc2_);
         this.setFC5(_loc10_,_loc4_,_loc9_);
         var _loc12_:int = this.calculateEffects(param1,_loc2_,_loc10_,_loc4_,_loc6_);
         this.setEffectConstants(_loc12_);
         this.drawTriangles();
         return true;
      }
      
      private function setTexture(param1:ScratchTextureBitmap, param2:Boolean) : void
      {
         if(param1 != this.currentTexture)
         {
            this.__context.setTextureAt(0,param1.getTexture(this.__context));
            this.currentTexture = param1;
         }
         var _loc3_:String = param2 ? Context3DTextureFilter.NEAREST : Context3DTextureFilter.LINEAR;
         if(this.currentTextureFilter != _loc3_)
         {
            this.__context.setSamplerStateAt(0,Context3DWrapMode.CLAMP,_loc3_,Context3DMipFilter.MIPNONE);
            this.currentTextureFilter = _loc3_;
         }
      }
      
      private function setMatrix(param1:DisplayObject, param2:Rectangle) : void
      {
         var _loc3_:Number = param1.scaleX;
         var _loc4_:Number = param1.rotation * this.DegreesToRadians;
         var _loc5_:Number = param2.top;
         var _loc6_:Number = param2.left;
         var _loc7_:Number = param2.width;
         var _loc8_:Number = param2.height;
         var _loc9_:Number = Math.cos(_loc4_) * _loc3_;
         var _loc10_:Number = Math.sin(_loc4_) * _loc3_;
         this.matrixScratchpad[0] = _loc7_ * _loc9_;
         this.matrixScratchpad[1] = _loc7_ * -_loc10_;
         this.matrixScratchpad[4] = _loc8_ * _loc10_;
         this.matrixScratchpad[5] = _loc8_ * _loc9_;
         this.matrixScratchpad[10] = 1;
         this.matrixScratchpad[12] = param1.x + _loc5_ * _loc10_ + _loc6_ * _loc9_;
         this.matrixScratchpad[13] = param1.y + _loc5_ * _loc9_ - _loc6_ * _loc10_;
         this.matrixScratchpad[15] = 1;
         this.drawMatrix.rawData = this.matrixScratchpad;
         this.drawMatrix.append(this.projMatrix);
         this.__context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,0,this.drawMatrix,true);
      }
      
      private function setFC5(param1:Rectangle, param2:Object, param3:ScratchTextureBitmap) : void
      {
         var _loc8_:Number = NaN;
         var _loc4_:Number = param1.left / param3.width;
         var _loc5_:Number = param1.right / param3.width;
         var _loc6_:Number = param1.top / param3.height;
         var _loc7_:Number = param1.bottom / param3.height;
         if(Boolean(param2) && Boolean(param2.costumeFlipped))
         {
            _loc8_ = _loc5_;
            _loc5_ = _loc4_;
            _loc4_ = _loc8_;
         }
         this.FC[5][0] = _loc4_;
         this.FC[5][1] = _loc6_;
         this.FC[5][2] = _loc5_ - _loc4_;
         this.FC[5][3] = _loc7_ - _loc6_;
      }
      
      private function calculateEffects(param1:DisplayObject, param2:Rectangle, param3:Rectangle, param4:Object, param5:Object) : int
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc6_:* = int(4 * 6 + 0);
         if(param5)
         {
            _loc7_ = param1.scaleX;
            _loc8_ = param2.width * _loc7_;
            _loc9_ = param2.height * _loc7_;
            _loc10_ = "isStage" in param1 && Boolean(param1["isStage"]) ? 1 : this.appScale;
            _loc11_ = _loc8_ * _loc10_;
            _loc12_ = _loc9_ * _loc10_;
            _loc13_ = Number(param5[FX_PIXELATE]);
            if(_loc13_)
            {
               _loc14_ = Math.abs(_loc13_ * _loc7_) / 10 + 1;
               _loc15_ = _loc14_ > 1 ? _loc14_ / param3.width : -1;
               _loc16_ = _loc14_ > 1 ? _loc14_ / param3.height : -1;
               if(_loc14_ > 1)
               {
                  _loc15_ *= param3.width / _loc11_;
                  _loc16_ *= param3.height / _loc12_;
               }
               this.FC[_loc6_ >> 2][_loc6_++ & 3] = _loc15_;
               this.FC[_loc6_ >> 2][_loc6_++ & 3] = _loc16_;
               this.FC[4][1] = _loc15_ / 2;
               this.FC[4][2] = _loc16_ / 2;
            }
            _loc13_ = Number(param5[FX_COLOR]);
            if(_loc13_)
            {
               this.FC[_loc6_ >> 2][_loc6_++ & 3] = 360 * _loc13_ / 200 % 360;
            }
            _loc13_ = Number(param5[FX_FISHEYE]);
            if(_loc13_)
            {
               this.FC[_loc6_ >> 2][_loc6_++ & 3] = Math.max(0,(_loc13_ + 100) / 100);
            }
            _loc13_ = Number(param5[FX_WHIRL]);
            if(_loc13_)
            {
               this.FC[_loc6_ >> 2][_loc6_++ & 3] = Math.PI * _loc13_ / 180;
            }
            _loc13_ = Number(param5[FX_MOSAIC]);
            if(_loc13_)
            {
               _loc13_ = Math.round((Math.abs(_loc13_) + 10) / 10);
               this.FC[_loc6_ >> 2][_loc6_++ & 3] = Math.floor(Math.max(1,Math.min(_loc13_,Math.min(_loc11_,_loc12_))));
            }
            _loc13_ = Number(param5[FX_BRIGHTNESS]);
            if(_loc13_)
            {
               this.FC[_loc6_ >> 2][_loc6_++ & 3] = Math.max(-100,Math.min(_loc13_,100)) / 100;
            }
            _loc13_ = Number(param5[FX_GHOST]);
            if(_loc13_)
            {
               this.FC[_loc6_ >> 2][_loc6_++ & 3] = 1 - Math.max(0,Math.min(_loc13_,100)) / 100;
            }
         }
         return _loc6_;
      }
      
      private function setEffectConstants(param1:int) : void
      {
         param1 = param1 + 3 >> 2;
         var _loc2_:int = 4;
         while(_loc2_ < param1)
         {
            this.__context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,_loc2_,this.FC[_loc2_]);
            _loc2_++;
         }
      }
      
      private function uploadConstantValues() : void
      {
         this.__context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,0,this.FC[0]);
         this.__context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,1,this.FC[1]);
         this.__context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,2,this.FC[2]);
         this.__context.setProgramConstantsFromVector(Context3DProgramType.FRAGMENT,3,this.FC[3]);
         this.__context.setVertexBufferAt(0,this.vertexBuffer,0,Context3DVertexBufferFormat.FLOAT_3);
         this.__context.setVertexBufferAt(1,this.vertexBuffer,3,Context3DVertexBufferFormat.FLOAT_2);
      }
      
      private function setBlendFactors(param1:Boolean) : void
      {
         var _loc2_:String = param1 ? Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA : Context3DBlendFactor.ZERO;
         if(_loc2_ == this.currentBlendFactor)
         {
            return;
         }
         this.__context.setBlendFactors(Context3DBlendFactor.ONE,_loc2_);
         this.currentBlendFactor = _loc2_;
      }
      
      private function drawTriangles() : void
      {
         this.__context.drawTriangles(this.indexBuffer,0,2);
      }
      
      private function cleanUpUnusedBitmaps() : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc1_:Array = [];
         for(_loc2_ in this.bitmapsByID)
         {
            _loc3_ = _loc2_ as String;
            _loc4_ = false;
            for(_loc5_ in this.spriteBitmaps)
            {
               if(this.spriteBitmaps[_loc5_] == _loc3_)
               {
                  _loc4_ = true;
                  break;
               }
            }
            if(!_loc4_)
            {
               if(this.bitmapsByID[_loc3_] is ChildRender)
               {
                  this.bitmapsByID[_loc3_].dispose();
               }
               _loc1_.push(_loc3_);
            }
         }
         for each(_loc3_ in _loc1_)
         {
            delete this.bitmapsByID[_loc3_];
         }
      }
      
      public function updateRender(param1:DisplayObject, param2:String = null, param3:Object = null) : void
      {
         var _loc5_:Object = null;
         var _loc6_:String = null;
         var _loc4_:Boolean = false;
         if(Boolean(param2) && this.spriteBitmaps[param1] != param2)
         {
            this.spriteBitmaps[param1] = param2;
            _loc4_ = true;
            this.unrenderedChildren[param1] = !this.bitmapsByID[param2];
         }
         if(param3)
         {
            _loc5_ = this.spriteRenderOpts[param1] || (this.spriteRenderOpts[param1] = {});
            if(param3.bounds)
            {
               this.boundsDict[param1] = Boolean(param3.raw_bounds) && Boolean(param3.bitmap) ? param3.raw_bounds : param3.bounds;
            }
            for(_loc6_ in param3)
            {
               _loc5_[_loc6_] = param3[_loc6_];
            }
         }
         if(param1 is Bitmap)
         {
            this.unrenderedChildren[param1] = true;
         }
      }
      
      public function updateCostume(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:Rectangle = param2.getBounds(param2);
         var _loc4_:Object = param2 as Object;
         var _loc5_:Shape = _loc4_.getShape();
         var _loc6_:Rectangle = _loc5_.getBounds(_loc5_);
         var _loc7_:Point = _loc6_.topLeft.subtract(_loc3_.topLeft);
      }
      
      public function updateFilters(param1:DisplayObject, param2:Object) : void
      {
         var _loc3_:Object = this.spriteRenderOpts[param1] || (this.spriteRenderOpts[param1] = {});
         _loc3_.effects = param2 || {};
         _loc3_.shaderID = -1;
      }
      
      private function checkChildRender(param1:DisplayObject) : Boolean
      {
         var _loc11_:uint = 0;
         var _loc25_:ScratchTextureBitmap = null;
         var _loc2_:String = this.spriteBitmaps[param1];
         if(!_loc2_)
         {
            if("img" in param1)
            {
               return false;
            }
            _loc2_ = this.spriteBitmaps[param1] = "bm" + Math.random();
         }
         var _loc3_:Object = this.spriteRenderOpts[param1];
         var _loc4_:Rectangle = this.boundsDict[param1] || (this.boundsDict[param1] = _loc3_.bounds);
         var _loc5_:Number = _loc4_.width * param1.scaleX * Math.min(maxScale,this.appScale * this.scratchStage.stage.contentsScaleFactor);
         var _loc6_:Number = _loc4_.height * param1.scaleY * Math.min(maxScale,this.appScale * this.scratchStage.stage.contentsScaleFactor);
         var _loc7_:Object = null;
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         var _loc10_:Number = 0;
         var _loc12_:Number = 1;
         var _loc13_:Boolean = false;
         if(_loc3_)
         {
            _loc7_ = _loc3_.effects;
            if(_loc3_.bitmap != null)
            {
               _loc13_ = !this.bitmapsByID[_loc2_];
               this.bitmapsByID[_loc2_] = _loc3_.bitmap;
               return _loc13_ || Boolean(this.unrenderedChildren[param1]);
            }
            if(Boolean(_loc7_) && FX_MOSAIC in _loc7_)
            {
               _loc8_ = _loc3_.isStage ? 1 : this.appScale;
               _loc9_ = _loc5_ * _loc8_;
               _loc10_ = _loc6_ * _loc8_;
               _loc11_ = Math.round((Math.abs(_loc7_[FX_MOSAIC]) + 10) / 10);
               _loc11_ = Math.max(1,Math.min(_loc11_,Math.min(_loc9_,_loc10_)));
               _loc12_ = 1 / _loc11_;
            }
         }
         if(param1 is Bitmap)
         {
            _loc13_ = !this.bitmapsByID[_loc2_];
            this.bitmapsByID[_loc2_] = (param1 as Bitmap).bitmapData;
            if(Boolean(this.unrenderedChildren[param1]) && this.textureIndexByID.hasOwnProperty(_loc2_))
            {
               _loc25_ = this.textures[this.textureIndexByID[_loc2_]];
               _loc25_.updateBitmap(_loc2_,this.bitmapsByID[_loc2_]);
            }
            return _loc13_;
         }
         this.scratchStage.visible = true;
         var _loc14_:Number = _loc5_ * _loc12_;
         var _loc15_:Number = _loc6_ * _loc12_;
         var _loc16_:BitmapData = this.bitmapsByID[_loc2_];
         if(_loc16_)
         {
            if((_loc2_.indexOf("bm") != 0 || !this.unrenderedChildren[param1]) && this.closeTo(_loc16_.width,_loc14_) && this.closeTo(_loc16_.height,_loc15_))
            {
               this.scratchStage.visible = false;
               return false;
            }
            if(_loc16_ is ChildRender)
            {
               if((_loc16_ as ChildRender).needsResize(_loc14_,_loc15_))
               {
                  _loc16_.dispose();
                  _loc16_ = null;
               }
               else
               {
                  if(!(_loc16_ as ChildRender).needsRender(param1,_loc14_,_loc15_,this.stagePenLayer))
                  {
                     this.scratchStage.visible = false;
                     return false;
                  }
                  (_loc16_ as ChildRender).reset(param1,this.stagePenLayer);
                  if("clearCachedBitmap" in param1)
                  {
                     (param1 as Object).clearCachedBitmap();
                  }
               }
            }
         }
         var _loc17_:Boolean = Boolean(_loc3_) && Boolean(_loc3_.costumeFlipped);
         if(_loc17_)
         {
            (param1 as Object).setRotationStyle("don\'t rotate");
            _loc4_ = (param1 as Object).getVisibleBounds(param1);
         }
         var _loc18_:Number = Math.max(1,_loc14_);
         var _loc19_:Number = Math.max(1,_loc15_);
         var _loc20_:Boolean = !!_loc16_;
         if(!_loc16_)
         {
            _loc16_ = new ChildRender(_loc18_,_loc19_,param1,this.stagePenLayer,_loc4_);
         }
         else
         {
            _loc16_.fillRect(_loc16_.rect,0);
         }
         if(_loc16_ is ChildRender)
         {
            _loc12_ *= (_loc16_ as ChildRender).scale;
         }
         var _loc21_:Matrix = new Matrix(1,0,0,1,-_loc4_.x,-_loc4_.y);
         if(_loc16_ is ChildRender && (_loc16_ as ChildRender).isPartial())
         {
            _loc21_.translate(-(_loc16_ as ChildRender).inner_x * _loc4_.width,-(_loc16_ as ChildRender).inner_y * _loc4_.height);
         }
         _loc21_.scale(param1.scaleX * _loc12_ * Math.min(maxScale,this.appScale * this.scratchStage.stage.contentsScaleFactor),param1.scaleY * _loc12_ * Math.min(maxScale,this.appScale * this.scratchStage.stage.contentsScaleFactor));
         var _loc22_:Number = param1.alpha;
         param1.alpha = 1;
         var _loc23_:ColorTransform = null;
         if("img" in param1)
         {
            _loc23_ = (param1 as Object).img.transform.colorTransform;
            (param1 as Object).img.transform.colorTransform = noTrans;
         }
         var _loc24_:Boolean = param1.visible;
         param1.visible = false;
         param1.visible = true;
         _loc16_.drawWithQuality(param1,_loc21_,null,null,null,false,StageQuality.BEST);
         param1.visible = _loc24_;
         param1.alpha = _loc22_;
         if("img" in param1)
         {
            (param1 as Object).img.transform.colorTransform = _loc23_;
         }
         if(_loc17_)
         {
            (param1 as Object).setRotationStyle("left-right");
         }
         this.scratchStage.visible = false;
         if(_loc20_ && this.textureIndexByID.hasOwnProperty(_loc2_))
         {
            this.textures[this.textureIndexByID[_loc2_]].updateBitmap(_loc2_,_loc16_);
         }
         this.bitmapsByID[_loc2_] = _loc16_;
         this.unrenderedChildren[param1] = false;
         return !_loc20_;
      }
      
      private function closeTo(param1:Number, param2:Number) : Boolean
      {
         return Math.abs(param1 - param2) < 2;
      }
      
      public function spriteIsLarge(param1:DisplayObject) : Boolean
      {
         var _loc2_:String = this.spriteBitmaps[param1];
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:ChildRender = this.bitmapsByID[_loc2_];
         return Boolean(_loc3_) && _loc3_.isPartial();
      }
      
      private function toggleTextureDebug(param1:KeyboardEvent) : void
      {
         if(param1.ctrlKey && param1.charCode == 108)
         {
            this.debugTexture = !this.debugTexture;
         }
      }
      
      private function packTextureBitmaps() : void
      {
         var _loc5_:Object = null;
         var _loc6_:Object = null;
         var _loc7_:int = 0;
         var _loc8_:Object = null;
         var _loc9_:int = 0;
         var _loc10_:ScratchTextureBitmap = null;
         var _loc11_:Array = null;
         var _loc12_:int = 0;
         var _loc13_:Number = NaN;
         var _loc14_:Bitmap = null;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Rectangle = null;
         var _loc1_:String = this.spriteBitmaps[this.stagePenLayer];
         if(this.textures.length < 1)
         {
            this.textures.push(new ScratchTextureBitmap(512,512));
         }
         if(!this.penPacked && _loc1_ != null)
         {
            _loc5_ = {};
            _loc5_[_loc1_] = this.bitmapsByID[_loc1_];
            (this.textures[0] as ScratchTextureBitmap).packBitmaps(_loc5_);
            this.textureIndexByID[_loc1_] = 0;
            this.penPacked = true;
         }
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:uint = uint(texSize);
         while(true)
         {
            _loc6_ = {};
            _loc7_ = 0;
            for(_loc8_ in this.bitmapsByID)
            {
               if(_loc8_ != _loc1_)
               {
                  _loc6_[_loc8_] = this.bitmapsByID[_loc8_];
                  _loc7_++;
               }
            }
            _loc9_ = 1;
            while(_loc9_ < maxTextures && _loc7_ > 0)
            {
               if(_loc9_ >= this.textures.length)
               {
                  this.textures.push(new ScratchTextureBitmap(_loc4_,_loc4_));
               }
               _loc10_ = this.textures[_loc9_];
               _loc11_ = _loc10_.packBitmaps(_loc6_);
               _loc12_ = 0;
               while(_loc12_ < _loc11_.length)
               {
                  this.textureIndexByID[_loc11_[_loc12_]] = _loc9_;
                  delete _loc6_[_loc11_[_loc12_]];
                  _loc12_++;
               }
               _loc7_ -= _loc11_.length;
               _loc9_++;
            }
            if(_loc7_ <= 0)
            {
               break;
            }
            if(!_loc2_)
            {
               this.cleanUpUnusedBitmaps();
               _loc2_ = true;
            }
            else
            {
               if(_loc3_)
               {
                  this.statusCallback(false);
                  throw Error("Unable to fit all bitmaps into the textures!");
               }
               _loc9_ = 1;
               while(_loc9_ < this.textures.length)
               {
                  this.textures[_loc9_].disposeTexture();
                  this.textures[_loc9_].dispose();
                  this.textures[_loc9_] = null;
                  _loc9_++;
               }
               this.textures.length = 1;
               _loc4_ <<= 1;
               if(_loc4_ >= texSizeMax)
               {
                  _loc3_ = true;
                  _loc4_ = uint(texSizeMax);
               }
            }
         }
         if(this.debugTexture)
         {
            _loc13_ = 0;
            _loc9_ = 0;
            while(_loc9_ < this.textures.length)
            {
               _loc10_ = this.textures[_loc9_];
               if(_loc9_ >= this.testBMs.length)
               {
                  this.testBMs.push(new Bitmap(_loc10_));
               }
               _loc14_ = this.testBMs[_loc9_];
               _loc14_.scaleX = _loc14_.scaleY = 0.5;
               _loc14_.x = 380 + _loc13_;
               _loc15_ = _loc14_.scaleX;
               _loc16_ = _loc14_.x * this.scratchStage.root.scaleX;
               _loc14_.bitmapData = _loc10_;
               this.scratchStage.stage.addChild(_loc14_);
               for(_loc8_ in this.bitmapsByID)
               {
                  if(_loc9_ == this.textureIndexByID[_loc8_])
                  {
                     _loc17_ = _loc10_.getRect(_loc8_ as String).clone();
                  }
               }
               _loc13_ += _loc14_.width;
               _loc9_++;
            }
         }
         this.currentTexture = null;
      }
      
      public function onRender(param1:Event) : void
      {
         var _loc2_:Object = null;
         if(!this.scratchStage)
         {
            return;
         }
         if(this.scratchStage.stage.stage3Ds[0] == null || this.__context == null || this.__context.driverInfo == "Disposed")
         {
            if(this.__context)
            {
               this.__context.dispose();
            }
            this.__context = null;
            this.onContextLoss();
            return;
         }
         this.draw();
         this.__context.present();
         for(_loc2_ in this.cachedOtherRenderBitmaps)
         {
            this.cachedOtherRenderBitmaps[_loc2_].inner_x = Number.NaN;
         }
      }
      
      public function getRender(param1:BitmapData) : void
      {
         if(this.scratchStage.stage.stage3Ds[0] == null || this.__context == null || this.__context.driverInfo == "Disposed")
         {
            return;
         }
         if(!this.indexBuffer)
         {
            this.checkBuffers();
         }
         this.__context.configureBackBuffer(param1.width,param1.height,0,false);
         this.draw();
         this.__context.drawToBitmapData(param1);
         param1.draw(this.uiContainer);
         this.scissorRect = null;
         this.setRenderView();
      }
      
      public function getRenderedChild(param1:DisplayObject, param2:Number, param3:Number, param4:Boolean = false) : BitmapData
      {
         var _loc19_:Boolean = false;
         var _loc20_:Object = null;
         var _loc21_:String = null;
         if(param1.parent != this.scratchStage || !this.__context)
         {
            return this.emptyStamp;
         }
         if(Boolean(!this.spriteBitmaps[param1]) || Boolean(this.unrenderedChildren[param1]) || !this.bitmapsByID[this.spriteBitmaps[param1]])
         {
            if(this.checkChildRender(param1))
            {
               this.packTextureBitmaps();
               this.checkBuffers();
            }
         }
         var _loc5_:Object = this.spriteRenderOpts[param1];
         var _loc6_:Object = _loc5_ ? _loc5_.effects : null;
         var _loc7_:String = this.spriteBitmaps[param1];
         var _loc8_:int = Math.ceil(Math.round(param2 * 100) / 100);
         var _loc9_:int = Math.ceil(Math.round(param3 * 100) / 100);
         if(_loc8_ < 1 || _loc9_ < 1)
         {
            return this.emptyStamp;
         }
         if(Boolean(this.stampsByID[_loc7_]) && !param4)
         {
            _loc19_ = this.stampsByID[_loc7_].width != _loc8_ || this.stampsByID[_loc7_].height != _loc9_;
            if(!_loc19_)
            {
               _loc20_ = this.stampsByID[_loc7_].effects;
               if(_loc20_)
               {
                  for(_loc21_ in _loc20_)
                  {
                     if(_loc21_ != FX_GHOST)
                     {
                        if(!(_loc20_[_loc21_] == 0 && !_loc6_))
                        {
                           if(!_loc6_ || _loc20_[_loc21_] != _loc6_[_loc21_])
                           {
                              _loc19_ = true;
                              break;
                           }
                        }
                     }
                  }
               }
               else
               {
                  for(_loc21_ in _loc6_)
                  {
                     if(_loc21_ != FX_GHOST)
                     {
                        if(_loc6_[_loc21_] != 0)
                        {
                           _loc19_ = true;
                           break;
                        }
                     }
                  }
               }
            }
            if(!_loc19_)
            {
               return this.stampsByID[_loc7_];
            }
         }
         var _loc10_:BitmapData = new SpriteStamp(_loc8_,_loc9_,_loc6_);
         var _loc11_:Number = param1.rotation;
         param1.rotation = 0;
         var _loc12_:Number = param1.scaleX;
         var _loc13_:Number = param1.scaleY;
         var _loc14_:Rectangle = this.boundsDict[param1];
         var _loc15_:Number = this.appScale * this.scratchStage.stage.contentsScaleFactor;
         var _loc16_:Boolean = isIOS || (_loc10_.width > this.scissorRect.width || _loc10_.height > this.scissorRect.height);
         if(_loc16_)
         {
            this.projMatrix = this.createOrthographicProjectionMatrix(_loc10_.width,_loc10_.height,0,0);
            this.__context.configureBackBuffer(Math.max(32,_loc10_.width),Math.max(32,_loc10_.height),0,false);
            _loc15_ = 1;
         }
         param1.scaleX = param2 / Math.floor(_loc14_.width * _loc15_);
         param1.scaleY = param3 / Math.floor(_loc14_.height * _loc15_);
         var _loc17_:Number = param1.x;
         var _loc18_:Number = param1.y;
         param1.x = -_loc14_.x * param1.scaleX;
         param1.y = -_loc14_.y * param1.scaleY;
         this.__context.clear(0,0,0,0);
         this.__context.setScissorRectangle(new Rectangle(0,0,_loc10_.width + 1,_loc10_.height + 1));
         this.setBlendFactors(false);
         this.drawChild(param1);
         this.__context.drawToBitmapData(_loc10_);
         param1.x = _loc17_;
         param1.y = _loc18_;
         param1.scaleX = _loc12_;
         param1.scaleY = _loc13_;
         param1.rotation = _loc11_;
         if(_loc16_)
         {
            this.scissorRect = null;
            this.setupContext3D();
         }
         else
         {
            this.__context.setScissorRectangle(this.scissorRect);
         }
         if(!param4)
         {
            this.stampsByID[_loc7_] = _loc10_;
         }
         return _loc10_;
      }
      
      public function getOtherRenderedChildren(param1:DisplayObject, param2:Number) : BitmapData
      {
         if(param1.parent != this.scratchStage)
         {
            return null;
         }
         var _loc3_:Rectangle = this.boundsDict[param1];
         var _loc4_:uint = Math.ceil(_loc3_.width * param1.scaleX * param2);
         var _loc5_:uint = Math.ceil(_loc3_.height * param1.scaleY * param2);
         var _loc6_:ChildRender = this.cachedOtherRenderBitmaps[param1];
         if(Boolean(_loc6_) && Boolean(_loc6_.width == _loc4_) && _loc6_.height == _loc5_)
         {
            if(_loc6_.inner_x == param1.x && _loc6_.inner_y == param1.y && _loc6_.inner_w == param1.rotation)
            {
               return _loc6_;
            }
            _loc6_.fillRect(_loc6_.rect,0);
         }
         else
         {
            if(_loc6_)
            {
               _loc6_.dispose();
            }
            _loc6_ = this.cachedOtherRenderBitmaps[param1] = new ChildRender(_loc4_,_loc5_,param1,this.stagePenLayer,_loc3_);
         }
         var _loc7_:Boolean = param1.visible;
         var _loc8_:Number = param1.rotation;
         var _loc9_:Point = _loc3_.topLeft;
         var _loc10_:Number = this.appScale;
         var _loc11_:Number = this.appScale;
         _loc9_.x *= param1.scaleX;
         _loc9_.y *= param1.scaleY;
         var _loc12_:Matrix3D = this.projMatrix.clone();
         this.projMatrix.prependScale(param2 / _loc10_,param2 / _loc11_,1);
         this.projMatrix.prependTranslation(-_loc9_.x,-_loc9_.y,0);
         this.projMatrix.prependRotation(-_loc8_,Vector3D.Z_AXIS);
         this.projMatrix.prependTranslation(-param1.x,-param1.y,0);
         param1.visible = false;
         this.pixelateAll = true;
         this.__context.setScissorRectangle(_loc6_.rect);
         this.draw();
         this.pixelateAll = false;
         param1.visible = _loc7_;
         this.projMatrix = _loc12_;
         this.__context.drawToBitmapData(_loc6_);
         this.__context.setScissorRectangle(this.scissorRect);
         _loc6_.inner_x = param1.x;
         _loc6_.inner_y = param1.y;
         _loc6_.inner_w = param1.rotation;
         return _loc6_;
      }
      
      private function setupContext3D(param1:Event = null) : void
      {
         if(!this.__context)
         {
            this.requestContext3D();
            return;
         }
         this.onStageResize();
         this.__context.setDepthTest(false,Context3DCompareMode.ALWAYS);
         this.__context.enableErrorChecking = false;
         this.tlPoint = this.scratchStage.localToGlobal(originPt);
      }
      
      private function loadShaders() : void
      {
         var getUTF:Function = function(param1:ByteArray):String
         {
            return param1.readUTFBytes(param1.length);
         };
         var VertexShader:Class = DisplayObjectContainerIn3D_VertexShader;
         var FragmentShader:Class = DisplayObjectContainerIn3D_FragmentShader;
         this.vertexShaderCode = getUTF(new VertexShader());
         this.fragmentShaderCode = getUTF(new FragmentShader());
      }
      
      private function switchShaders(param1:int) : void
      {
         var _loc2_:Program3D = this.shaderCache[param1];
         if(!_loc2_)
         {
            this.shaderCache[param1] = _loc2_ = this.buildShader(param1);
         }
         if(this.currentShader != _loc2_)
         {
            this.currentShader = _loc2_;
            this.__context.setProgram(this.currentShader);
         }
      }
      
      private function buildShader(param1:int) : Program3D
      {
         var _loc8_:String = null;
         var _loc9_:Boolean = false;
         this.vertexShaderParts.length = 0;
         this.fragmentShaderParts.length = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = int(effectNames.length);
         while(_loc3_ < _loc4_)
         {
            _loc8_ = effectNames[_loc3_];
            _loc9_ = (param1 & 1 << _loc4_ - _loc3_ - 1) != 0;
            this.fragmentShaderParts.push(["#define ENABLE_",_loc8_," ",int(_loc9_)].join(""));
            if(_loc9_)
            {
               if(_loc8_ == FX_PIXELATE)
               {
                  this.fragmentShaderParts.push("alias fc6.xyxy, FX_" + _loc8_);
                  this.fragmentShaderParts.push("alias fc4.yzyz, FX_" + _loc8_ + "_half");
                  _loc2_++;
               }
               else
               {
                  this.fragmentShaderParts.push(["alias ",this.availableEffectRegisters[_loc2_],", FX_",_loc8_].join(""));
               }
               _loc2_++;
            }
            _loc3_++;
         }
         this.vertexShaderParts.push(this.vertexShaderCode);
         this.fragmentShaderParts.push(this.fragmentShaderCode);
         var _loc5_:String = this.vertexShaderParts.join("\n");
         var _loc6_:String = this.fragmentShaderParts.join("\n");
         this.vertexShaderAssembler.assemble(Context3DProgramType.VERTEX,_loc5_);
         if(this.vertexShaderAssembler.error.length > 0)
         {
            Scratch.app.logMessage("Error building vertex shader: " + this.vertexShaderAssembler.error);
         }
         this.fragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT,_loc6_);
         if(this.fragmentShaderAssembler.error.length > 0)
         {
            Scratch.app.logMessage("Error building fragment shader: " + this.fragmentShaderAssembler.error);
         }
         var _loc7_:Program3D = this.__context.createProgram();
         _loc7_.upload(this.vertexShaderAssembler.agalcode,this.fragmentShaderAssembler.agalcode);
         return _loc7_;
      }
      
      private function context3DCreated(param1:Event) : void
      {
         if(!this.contextRequested)
         {
            this.onContextLoss(param1);
         }
         this.contextRequested = false;
         if(!this.scratchStage)
         {
            this.__context = null;
            (param1.currentTarget as Stage3D).context3D.dispose();
            return;
         }
         this.scratchStage.visible = false;
         this.__context = (param1.currentTarget as Stage3D).context3D;
         if(this.__context.driverInfo.toLowerCase().indexOf("software") > -1)
         {
            if(!this.callbackCalled)
            {
               this.callbackCalled = true;
               this.statusCallback(false);
            }
            this.setStage(null,null);
            return;
         }
         this.setupContext3D();
         if(this.scratchStage.visible)
         {
            this.scratchStage.visible = false;
         }
         if(!this.callbackCalled)
         {
            this.callbackCalled = true;
            this.statusCallback(true);
         }
      }
      
      private function requestContext3D() : void
      {
         if(this.contextRequested || !this.stage3D)
         {
            return;
         }
         this.stage3D.addEventListener(Event.CONTEXT3D_CREATE,this.context3DCreated,false,0,true);
         this.stage3D.addEventListener(ErrorEvent.ERROR,this.onStage3DError,false,0,true);
         this.stage3D.requestContext3D(Context3DRenderMode.AUTO,Context3DProfile.BASELINE);
         this.contextRequested = true;
      }
      
      private function onStage3DError(param1:Event) : void
      {
         this.scratchStage.visible = true;
         if(!this.callbackCalled)
         {
            this.callbackCalled = true;
            this.statusCallback(false);
         }
         this.setStage(null,null);
      }
      
      private function onContextLoss(param1:Event = null) : void
      {
         var _loc2_:Object = null;
         var _loc3_:int = 0;
         var _loc4_:String = null;
         for each(_loc2_ in this.shaderCache)
         {
            _loc2_.dispose();
         }
         this.shaderCache = {};
         this.currentShader = null;
         this.currentTexture = null;
         this.currentBlendFactor = null;
         this.currentTextureFilter = null;
         _loc3_ = 0;
         while(_loc3_ < this.textures.length)
         {
            (this.textures[_loc3_] as ScratchTextureBitmap).disposeTexture();
            _loc3_++;
         }
         if(this.vertexBuffer)
         {
            this.vertexBuffer.dispose();
            this.vertexBuffer = null;
         }
         if(this.indexBuffer)
         {
            this.indexBuffer.dispose();
            this.indexBuffer = null;
         }
         for(_loc4_ in this.bitmapsByID)
         {
            if(this.bitmapsByID[_loc4_] is ChildRender)
            {
               this.bitmapsByID[_loc4_].dispose();
            }
         }
         this.bitmapsByID = {};
         for(_loc4_ in this.stampsByID)
         {
            this.stampsByID[_loc4_].dispose();
         }
         this.stampsByID = {};
         this.scissorRect = null;
         if(!param1)
         {
            this.requestContext3D();
         }
      }
      
      private function createOrthographicProjectionMatrix(param1:Number, param2:Number, param3:Number, param4:Number) : Matrix3D
      {
         var _loc5_:Matrix3D = new Matrix3D();
         sRawData[0] = 2 / param1;
         sRawData[1] = 0;
         sRawData[4] = 0;
         sRawData[5] = -2 / param2;
         sRawData[12] = -(2 * param3 + param1) / param1;
         sRawData[13] = (2 * param4 + param2) / param2;
         _loc5_.copyRawDataFrom(sRawData);
         return _loc5_;
      }
      
      public function getUIContainer() : Sprite
      {
         return this.uiContainer;
      }
   }
}

import flash.utils.getQualifiedClassName;

final class Dbg
{
   
   public function Dbg()
   {
      super();
   }
   
   public static function printObj(param1:*) : String
   {
      var memoryHash:String = null;
      var obj:* = param1;
      try
      {
         FakeClass(obj);
      }
      catch(e:Error)
      {
         memoryHash = String(e).replace(/.*([@|\$].*?) to .*$/gi,"$1");
      }
      return getQualifiedClassName(obj) + memoryHash;
   }
}

final class FakeClass
{
   
   public function FakeClass()
   {
      super();
   }
}
