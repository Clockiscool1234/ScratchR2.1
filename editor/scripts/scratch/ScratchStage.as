package scratch
{
   import assets.Resources;
   import blocks.Block;
   import by.blooddy.crypto.MD5;
   import by.blooddy.crypto.image.PNG24Encoder;
   import by.blooddy.crypto.image.PNGFilter;
   import filters.FilterPack;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.media.*;
   import flash.net.FileReference;
   import flash.system.Capabilities;
   import flash.text.*;
   import flash.utils.ByteArray;
   import translation.Translator;
   import uiwidgets.Menu;
   import util.*;
   import watchers.*;
   
   public class ScratchStage extends ScratchObj
   {
      
      private static var camera:Camera;
      
      public var info:Object = new Object();
      
      public var tempoBPM:Number = 60;
      
      public var penActivity:Boolean;
      
      public var newPenStrokes:Shape;
      
      public var penLayer:Bitmap;
      
      public var penLayerPNG:ByteArray;
      
      public var penLayerID:int = -1;
      
      public var penLayerMD5:String;
      
      private var bg:Shape;
      
      private var overlay:Shape;
      
      private var counter:TextField;
      
      private var arrowImage:DisplayObject;
      
      private var arrowText:TextField;
      
      public var videoImage:Bitmap;
      
      private var video:Video;
      
      private var videoAlpha:Number = 0.5;
      
      private var flipVideo:Boolean = true;
      
      public var xScroll:Number = 0;
      
      public var yScroll:Number = 0;
      
      private var stampBounds:Rectangle = new Rectangle();
      
      private var cachedBM:BitmapData;
      
      private var cachedBitmapIsCurrent:Boolean;
      
      public function ScratchStage()
      {
         super();
         objName = "Stage";
         isStage = true;
         scrollRect = new Rectangle(0,0,STAGEW,STAGEH);
         cacheAsBitmap = true;
         filterPack = new FilterPack(this);
         this.addWhiteBG();
         img = new Sprite();
         img.addChild(new Bitmap(new BitmapData(1,1)));
         img.cacheAsBitmap = true;
         addChild(img);
         this.addPenLayer();
         this.initMedia();
         showCostume(0);
      }
      
      public function setTempo(param1:Number) : void
      {
         this.tempoBPM = Math.max(20,Math.min(param1,500));
      }
      
      public function countdown(param1:int = -1) : void
      {
         if(this.overlay)
         {
            removeChild(this.overlay);
            removeChild(this.counter);
            removeChild(this.arrowImage);
            removeChild(this.arrowText);
            if(param1 == 0)
            {
               this.overlay = null;
               return;
            }
         }
         else if(param1 < 0)
         {
            return;
         }
         this.overlay = new Shape();
         this.overlay.graphics.beginFill(CSS.overColor,0.75);
         this.overlay.graphics.drawRect(0,0,STAGEW,STAGEH);
         addChild(this.overlay);
         if(param1 > 0)
         {
            addChild(this.counter = this.makeLabel(param1.toString(),80));
         }
         else
         {
            addChild(this.counter);
         }
         addChild(this.arrowText = this.makeLabel("To stop recording, click the square",14));
         this.arrowImage = Resources.createBmp("stopArrow");
         this.arrowImage.x = 6;
         this.arrowImage.y = 335;
         addChild(this.arrowImage);
         this.counter.x = (STAGEW - this.counter.width) / 2;
         this.counter.y = (STAGEH - this.counter.height) / 2;
         this.arrowText.x = 28;
         this.arrowText.y = 328;
      }
      
      private function makeLabel(param1:String, param2:int) : TextField
      {
         var _loc3_:TextField = new TextField();
         _loc3_.selectable = false;
         _loc3_.defaultTextFormat = new TextFormat(CSS.font,param2,16777215,true);
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.text = Translator.map(param1);
         return _loc3_;
      }
      
      public function objNamed(param1:String) : ScratchObj
      {
         if("_stage_" == param1 || objName == param1)
         {
            return this;
         }
         return this.spriteNamed(param1);
      }
      
      public function spriteNamed(param1:String) : ScratchSprite
      {
         var _loc2_:ScratchSprite = null;
         var _loc3_:Scratch = null;
         for each(_loc2_ in this.sprites())
         {
            if(_loc2_.objName == param1 && !_loc2_.isClone)
            {
               return _loc2_;
            }
         }
         _loc3_ = Scratch.app;
         if(_loc3_ != null && _loc3_.gh.carriedObj is ScratchSprite)
         {
            _loc2_ = ScratchSprite(_loc3_.gh.carriedObj);
            if(_loc2_.objName == param1 && !_loc2_.isClone)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function spritesAndClonesNamed(param1:String) : Array
      {
         var _loc5_:* = undefined;
         var _loc6_:ScratchSprite = null;
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc5_ = getChildAt(_loc3_);
            if(_loc5_ is ScratchSprite && _loc5_.objName == param1)
            {
               _loc2_.push(_loc5_);
            }
            _loc3_++;
         }
         var _loc4_:Scratch = parent as Scratch;
         if(_loc4_ != null)
         {
            _loc6_ = _loc4_.gh.carriedObj as ScratchSprite;
            if(Boolean(_loc6_) && _loc6_.objName == param1)
            {
               _loc2_.push(_loc6_);
            }
         }
         return _loc2_;
      }
      
      public function unusedSpriteName(param1:String) : String
      {
         var _loc3_:ScratchSprite = null;
         var _loc4_:String = null;
         var _loc2_:Array = ["_mouse_","_stage_","_edge_","_myself_","_random_"];
         for each(_loc3_ in this.sprites())
         {
            _loc2_.push(_loc3_.objName.toLowerCase());
         }
         _loc4_ = param1.toLowerCase();
         if(_loc2_.indexOf(_loc4_) < 0)
         {
            return param1;
         }
         _loc4_ = withoutTrailingDigits(_loc4_);
         var _loc5_:int = 2;
         while(_loc2_.indexOf(_loc4_ + _loc5_) >= 0)
         {
            _loc5_++;
         }
         return withoutTrailingDigits(param1) + _loc5_;
      }
      
      override public function hasName(param1:String) : Boolean
      {
         var _loc2_:ScratchSprite = null;
         for each(_loc2_ in this.sprites())
         {
            if(_loc2_.ownsVar(param1) || _loc2_.ownsList(param1))
            {
               return true;
            }
         }
         return ownsVar(param1) || ownsList(param1);
      }
      
      private function initMedia() : void
      {
         costumes.push(ScratchCostume.emptyBitmapCostume(Translator.map("backdrop1"),true));
         sounds.push(new ScratchSound(Translator.map("pop"),new Pop()));
         sounds[0].prepareToSave();
      }
      
      private function addWhiteBG() : void
      {
         this.bg = new Shape();
         this.bg.graphics.beginFill(16777215);
         this.bg.graphics.drawRect(0,0,STAGEW,STAGEH);
         addChild(this.bg);
      }
      
      private function addPenLayer() : void
      {
         this.newPenStrokes = new Shape();
         var _loc1_:BitmapData = new BitmapData(STAGEW,STAGEH,true,0);
         this.penLayer = new Bitmap(_loc1_);
         addChild(this.penLayer);
      }
      
      public function baseW() : Number
      {
         return this.bg.width;
      }
      
      public function baseH() : Number
      {
         return this.bg.height;
      }
      
      public function scratchMouseX() : int
      {
         return Math.max(-240,Math.min(mouseX - STAGEW / 2,240));
      }
      
      public function scratchMouseY() : int
      {
         return -Math.max(-180,Math.min(mouseY - STAGEH / 2,180));
      }
      
      override public function allObjects() : Array
      {
         var _loc1_:Array = this.sprites();
         _loc1_.push(this);
         return _loc1_;
      }
      
      public function sprites() : Array
      {
         var _loc3_:* = undefined;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ is ScratchSprite && !_loc3_.isClone)
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function deleteClones() : void
      {
         var _loc3_:ScratchSprite = null;
         var _loc4_:* = undefined;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc4_ = getChildAt(_loc2_);
            if(_loc4_ is ScratchSprite && Boolean(_loc4_.isClone))
            {
               if(Boolean(_loc4_.bubble) && Boolean(_loc4_.bubble.parent))
               {
                  _loc4_.bubble.parent.removeChild(_loc4_.bubble);
               }
               _loc1_.push(_loc4_);
            }
            _loc2_++;
         }
         for each(_loc3_ in _loc1_)
         {
            removeChild(_loc3_);
         }
      }
      
      public function watchers() : Array
      {
         var _loc4_:* = undefined;
         var _loc1_:Array = [];
         var _loc2_:Sprite = this.getUILayer();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            _loc4_ = _loc2_.getChildAt(_loc3_);
            if(_loc4_ is Watcher || _loc4_ is ListWatcher)
            {
               _loc1_.push(_loc4_);
            }
            _loc3_++;
         }
         return _loc1_;
      }
      
      public function removeObsoleteWatchers() : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Watcher = null;
         var _loc6_:ListWatcher = null;
         var _loc1_:Array = [];
         var _loc2_:Sprite = this.getUILayer();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            _loc5_ = _loc2_.getChildAt(_loc3_) as Watcher;
            if(Boolean(_loc5_) && Boolean(!_loc5_.target.isStage) && _loc5_.target.parent != this)
            {
               _loc1_.push(_loc5_);
            }
            _loc6_ = _loc2_.getChildAt(_loc3_) as ListWatcher;
            if(Boolean(_loc6_) && Boolean(!_loc6_.target.isStage) && _loc6_.target.parent != this)
            {
               _loc1_.push(_loc6_);
            }
            _loc3_++;
         }
         for each(_loc4_ in _loc1_)
         {
            _loc2_.removeChild(_loc4_);
         }
      }
      
      public function menu(param1:MouseEvent) : Menu
      {
         var _loc2_:Menu = new Menu();
         _loc2_.addItem("save picture of stage",this.saveScreenshot);
         return _loc2_;
      }
      
      public function saveScreenData() : BitmapData
      {
         var _loc2_:ScratchSprite = null;
         var _loc3_:Number = NaN;
         var _loc1_:BitmapData = new BitmapData(STAGEW,STAGEH,false);
         if(this.videoImage)
         {
            this.videoImage.visible = false;
         }
         if(Scratch.app.isIn3D)
         {
            Scratch.app.render3D.getRender(_loc1_);
         }
         else
         {
            _loc1_.draw(this);
         }
         if(Scratch.app != null && Scratch.app.gh.carriedObj is ScratchSprite)
         {
            _loc2_ = ScratchSprite(Scratch.app.gh.carriedObj);
            _loc3_ = 1;
            if(Scratch.app.stageIsContracted)
            {
               _loc3_ = 2;
            }
            if(!Scratch.app.editMode)
            {
               _loc3_ = 1 / Scratch.app.presentationScale;
            }
            _loc1_.draw(_loc2_,new Matrix(_loc2_.scaleX * _loc3_,0,0,_loc2_.scaleY * _loc3_,_loc2_.scratchX + STAGEW / 2,-_loc2_.scratchY + STAGEH / 2));
         }
         if(this.videoImage)
         {
            this.videoImage.visible = true;
         }
         return _loc1_;
      }
      
      private function saveScreenshot() : void
      {
         var _loc1_:BitmapData = new BitmapData(STAGEW,STAGEH,true,0);
         _loc1_.draw(this);
         var _loc2_:ByteArray = PNG24Encoder.encode(_loc1_,PNGFilter.PAETH);
         var _loc3_:FileReference = new FileReference();
         _loc3_.save(_loc2_,"stage.png");
      }
      
      public function scrollAlign(param1:String) : void
      {
         var _loc2_:DisplayObject = currentCostume().displayObj();
         var _loc3_:int = Math.max(_loc2_.width,STAGEW);
         var _loc4_:int = Math.max(_loc2_.height,STAGEH);
         switch(param1)
         {
            case "top-left":
               this.xScroll = 0;
               this.yScroll = _loc4_ - STAGEH;
               break;
            case "top-right":
               this.xScroll = _loc3_ - STAGEW;
               this.yScroll = _loc4_ - STAGEH;
               break;
            case "middle":
               this.xScroll = Math.floor((_loc3_ - STAGEW) / 2);
               this.yScroll = Math.floor((_loc4_ - STAGEH) / 2);
               break;
            case "bottom-left":
               this.xScroll = 0;
               this.yScroll = 0;
               break;
            case "bottom-right":
               this.xScroll = _loc3_ - STAGEW;
               this.yScroll = 0;
         }
         this.updateImage();
      }
      
      public function scrollRight(param1:Number) : void
      {
         this.xScroll += param1;
         this.updateImage();
      }
      
      public function scrollUp(param1:Number) : void
      {
         this.yScroll += param1;
         this.updateImage();
      }
      
      public function getUILayer() : Sprite
      {
         if(Scratch.app.isIn3D)
         {
            return Scratch.app.render3D.getUIContainer();
         }
         return this;
      }
      
      override protected function updateImage() : void
      {
         var _loc4_:BitmapData = null;
         var _loc6_:Matrix = null;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         super.updateImage();
         if(Scratch.app.isIn3D)
         {
            Scratch.app.render3D.getUIContainer().transform.matrix = transform.matrix.clone();
         }
      }
      
      public function step(param1:ScratchRuntime) : void
      {
         var _loc4_:Matrix = null;
         var _loc5_:DisplayObject = null;
         if(this.videoImage != null)
         {
            if(this.flipVideo)
            {
               _loc4_ = new Matrix();
               _loc4_.scale(-1,1);
               _loc4_.translate(this.video.width,0);
               this.videoImage.bitmapData.draw(this.video,_loc4_);
            }
            else
            {
               this.videoImage.bitmapData.draw(this.video);
            }
            if(Scratch.app.isIn3D)
            {
               Scratch.app.render3D.updateRender(this.videoImage);
            }
         }
         this.cachedBitmapIsCurrent = false;
         var _loc2_:Sprite = this.getUILayer();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            _loc5_ = _loc2_.getChildAt(_loc3_);
            if(_loc5_.visible == true)
            {
               if(_loc5_ is Watcher)
               {
                  Watcher(_loc5_).step(param1);
               }
               if(_loc5_ is ListWatcher)
               {
                  ListWatcher(_loc5_).step();
               }
            }
            _loc3_++;
         }
      }
      
      public function stampSprite(param1:ScratchSprite, param2:Number) : void
      {
         var penBM:BitmapData = null;
         var m:Matrix = null;
         var bmd:BitmapData = null;
         var childCenter:Point = null;
         var s:ScratchSprite = param1;
         var stampAlpha:Number = param2;
         var stamp2d:Function = function():void
         {
            var _loc1_:Boolean = s.visible;
            s.visible = true;
            commitPenStrokes();
            m.rotate(Math.PI * s.rotation / 180);
            m.scale(s.scaleX,s.scaleY);
            m.translate(s.x,s.y);
            var _loc2_:Number = s.filterPack.getFilterSetting("ghost");
            s.filterPack.setFilter("ghost",0);
            s.applyFilters();
            penBM.draw(s,m,new ColorTransform(1,1,1,stampAlpha));
            s.filterPack.setFilter("ghost",_loc2_);
            s.applyFilters();
            s.visible = _loc1_;
         };
         if(s == null)
         {
            return;
         }
         penBM = this.penLayer.bitmapData;
         m = new Matrix();
         if(Scratch.app.isIn3D)
         {
            bmd = this.getBitmapOfSprite(s,this.stampBounds);
            if(!bmd)
            {
               return;
            }
            childCenter = this.stampBounds.topLeft;
            this.commitPenStrokes();
            m.translate(childCenter.x * s.scaleX,childCenter.y * s.scaleY);
            m.rotate(Math.PI * s.rotation / 180);
            m.translate(s.x,s.y);
            penBM.draw(bmd,m,new ColorTransform(1,1,1,stampAlpha),null,null,s.rotation % 90 != 0);
            Scratch.app.render3D.updateRender(this.penLayer);
         }
         else
         {
            stamp2d();
         }
      }
      
      public function getBitmapOfSprite(param1:ScratchSprite, param2:Rectangle, param3:Boolean = false) : BitmapData
      {
         var _loc4_:Rectangle = param1.currentCostume().bitmap ? param1.img.getChildAt(0).getBounds(param1) : param1.getVisibleBounds(param1);
         param2.width = _loc4_.width;
         param2.height = _loc4_.height;
         param2.x = _loc4_.x;
         param2.y = _loc4_.y;
         if(!Scratch.app.render3D || param1.width < 1 || param1.height < 1)
         {
            return null;
         }
         var _loc5_:Number = param1.filterPack.getFilterSetting("ghost");
         var _loc6_:Number = param1.filterPack.getFilterSetting("brightness");
         param1.filterPack.setFilter("ghost",0);
         param1.filterPack.setFilter("brightness",0);
         param1.updateEffectsFor3D();
         var _loc7_:BitmapData = Scratch.app.render3D.getRenderedChild(param1,_loc4_.width * param1.scaleX,_loc4_.height * param1.scaleY,param3);
         param1.filterPack.setFilter("ghost",_loc5_);
         param1.filterPack.setFilter("brightness",_loc6_);
         param1.updateEffectsFor3D();
         return _loc7_;
      }
      
      public function setVideoState(param1:String) : void
      {
         if("off" == param1)
         {
            if(this.video)
            {
               this.video.attachCamera(null);
            }
            if(Boolean(this.videoImage) && Boolean(this.videoImage.parent))
            {
               this.videoImage.parent.removeChild(this.videoImage);
            }
            this.video = null;
            this.videoImage = null;
            return;
         }
         Scratch.app.libraryPart.showVideoButton();
         this.flipVideo = "on" == param1;
         if(camera == null)
         {
            camera = Camera.getCamera();
            if(!camera)
            {
               return;
            }
            camera.setMode(640,480,30);
         }
         if(this.video == null)
         {
            this.video = new Video(480,360);
            this.video.attachCamera(camera);
            this.videoImage = new Bitmap(new BitmapData(this.video.width,this.video.height,false));
            this.videoImage.alpha = this.videoAlpha;
            this.updateSpriteEffects(this.videoImage,{"ghost":100 * (1 - this.videoAlpha)});
            addChildAt(this.videoImage,getChildIndex(this.penLayer) + 1);
         }
      }
      
      public function setVideoTransparency(param1:Number) : void
      {
         this.videoAlpha = 1 - Math.max(0,Math.min(param1 / 100,1));
         if(this.videoImage)
         {
            this.videoImage.alpha = this.videoAlpha;
            this.updateSpriteEffects(this.videoImage,{"ghost":param1});
         }
      }
      
      public function isVideoOn() : Boolean
      {
         return this.videoImage != null;
      }
      
      public function clearPenStrokes() : void
      {
         var _loc1_:BitmapData = this.penLayer.bitmapData;
         _loc1_.fillRect(_loc1_.rect,0);
         this.newPenStrokes.graphics.clear();
         this.penActivity = false;
         if(Scratch.app.isIn3D)
         {
            Scratch.app.render3D.updateRender(this.penLayer);
         }
      }
      
      public function commitPenStrokes() : void
      {
         if(!this.penActivity)
         {
            return;
         }
         this.penLayer.bitmapData.draw(this.newPenStrokes);
         this.newPenStrokes.graphics.clear();
         this.penActivity = false;
         if(Scratch.app.isIn3D)
         {
            Scratch.app.render3D.updateRender(this.penLayer);
         }
      }
      
      private function updateCachedBitmap() : void
      {
         if(this.cachedBitmapIsCurrent)
         {
            return;
         }
         if(!this.cachedBM)
         {
            this.cachedBM = new BitmapData(STAGEW,STAGEH,false);
         }
         this.cachedBM.fillRect(this.cachedBM.rect,15790208);
         this.cachedBM.draw(img);
         if(this.penLayer)
         {
            this.cachedBM.draw(this.penLayer);
         }
         if(this.videoImage)
         {
            this.cachedBM.draw(this.videoImage);
         }
         this.cachedBitmapIsCurrent = true;
      }
      
      public function bitmapWithoutSprite(param1:ScratchSprite) : BitmapData
      {
         var _loc6_:ScratchSprite = null;
         var _loc7_:ColorTransform = null;
         var _loc2_:Rectangle = param1.bounds();
         var _loc3_:BitmapData = new BitmapData(_loc2_.width,_loc2_.height,false);
         if(!this.cachedBitmapIsCurrent)
         {
            this.updateCachedBitmap();
         }
         var _loc4_:Matrix = new Matrix();
         _loc4_.translate(-Math.floor(_loc2_.x),-Math.floor(_loc2_.y));
         _loc3_.draw(this.cachedBM,_loc4_);
         var _loc5_:int = 0;
         while(_loc5_ < this.numChildren)
         {
            _loc6_ = this.getChildAt(_loc5_) as ScratchSprite;
            if(Boolean(_loc6_ && _loc6_ != param1) && Boolean(_loc6_.visible) && _loc6_.bounds().intersects(_loc2_))
            {
               _loc4_.identity();
               _loc4_.translate(_loc6_.img.x,_loc6_.img.y);
               _loc4_.rotate(Math.PI * _loc6_.rotation / 180);
               _loc4_.scale(_loc6_.scaleX,_loc6_.scaleY);
               _loc4_.translate(_loc6_.x - _loc2_.x,_loc6_.y - _loc2_.y);
               _loc4_.tx = Math.floor(_loc4_.tx);
               _loc4_.ty = Math.floor(_loc4_.ty);
               _loc7_ = _loc6_.img.alpha == 1 ? null : new ColorTransform(1,1,1,_loc6_.img.alpha);
               _loc3_.draw(_loc6_.img,_loc4_,_loc7_);
            }
            _loc5_++;
         }
         return _loc3_;
      }
      
      public function updateSpriteEffects(param1:DisplayObject, param2:Object) : void
      {
         if(Scratch.app.isIn3D)
         {
            Scratch.app.render3D.updateFilters(param1,param2);
         }
      }
      
      public function getBitmapWithoutSpriteFilteredByColor(param1:ScratchSprite, param2:int) : BitmapData
      {
         var _loc3_:BitmapData = null;
         this.commitPenStrokes();
         var _loc4_:uint = 16316656;
         if(Scratch.app.isIn3D)
         {
            _loc3_ = Scratch.app.render3D.getOtherRenderedChildren(param1,1);
         }
         else
         {
            _loc3_ = this.bitmapWithoutSprite(param1);
         }
         var _loc5_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height,true,0);
         _loc5_.threshold(_loc3_,_loc3_.rect,_loc3_.rect.topLeft,"==",param2,4278190080,_loc4_);
         return _loc5_;
      }
      
      private function getNumberAsHexString(param1:uint, param2:uint = 1, param3:Boolean = true) : String
      {
         var _loc4_:String = param1.toString(16).toUpperCase();
         while(param2 > _loc4_.length)
         {
            _loc4_ = "0" + _loc4_;
         }
         if(param3)
         {
            _loc4_ = "0x" + _loc4_;
         }
         return _loc4_;
      }
      
      public function updateRender(param1:DisplayObject, param2:String = null, param3:Object = null) : void
      {
         if(Scratch.app.isIn3D)
         {
            Scratch.app.render3D.updateRender(param1,param2,param3);
         }
      }
      
      public function projectThumbnailPNG() : ByteArray
      {
         var _loc1_:BitmapData = new BitmapData(STAGEW,STAGEH,false);
         if(this.videoImage)
         {
            this.videoImage.visible = false;
         }
         if(Scratch.app.isIn3D)
         {
            Scratch.app.render3D.getRender(_loc1_);
         }
         else
         {
            _loc1_.draw(this);
         }
         if(this.videoImage)
         {
            this.videoImage.visible = true;
         }
         return PNG24Encoder.encode(_loc1_);
      }
      
      public function savePenLayer() : void
      {
         this.penLayerID = -1;
         this.penLayerPNG = PNG24Encoder.encode(this.penLayer.bitmapData,PNGFilter.PAETH);
         this.penLayerMD5 = MD5.hashBytes(this.penLayerPNG) + ".png";
      }
      
      public function clearPenLayer() : void
      {
         this.penLayerPNG = null;
         this.penLayerMD5 = null;
      }
      
      public function isEmpty() : Boolean
      {
         var _loc2_:ScratchObj = null;
         var _loc3_:ScratchCostume = null;
         var _loc4_:ScratchSound = null;
         var _loc1_:Array = ["510da64cf172d53750dffd23fbf73563.png","b82f959ab7fa28a70b06c8162b7fef83.svg","df0e59dcdea889efae55eb77902edc1c.svg","83a9787d4cb6f3b7632b4ddfebf74367.wav","f9a1c175dbe2e5dee472858dd30d16bb.svg","6e8bd9ae68fdb02b7e1e3df656a75635.svg","0aa976d536ad6667ce05f9f2174ceb3d.svg","790f7842ea100f71b34e5b9a5bfbcaa1.svg","c969115cb6a3b75470f8897fbda5c9c9.svg"];
         if(this.sprites().length > 1)
         {
            return false;
         }
         if(this.scriptCount() > 0)
         {
            return false;
         }
         for each(_loc2_ in this.allObjects())
         {
            if(_loc2_.variables.length > 0)
            {
               return false;
            }
            if(_loc2_.lists.length > 0)
            {
               return false;
            }
            for each(_loc3_ in _loc2_.costumes)
            {
               if(_loc1_.indexOf(_loc3_.baseLayerMD5) < 0)
               {
                  return false;
               }
            }
            for each(_loc4_ in _loc2_.sounds)
            {
               if(_loc1_.indexOf(_loc4_.md5) < 0)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public function updateInfo() : void
      {
         var extensionsToSave:Array = null;
         this.info.scriptCount = this.scriptCount();
         this.info.spriteCount = this.spriteCount();
         this.info.flashVersion = Capabilities.version;
         if(Scratch.app.projectID != "")
         {
            this.info.projectID = Scratch.app.projectID;
         }
         this.info.videoOn = this.isVideoOn();
         this.info.swfVersion = Scratch.versionString;
         delete this.info.loadInProgress;
         if(Scratch.app.loadInProgress)
         {
            this.info.loadInProgress = true;
         }
         if(this == Scratch.app.stagePane)
         {
            extensionsToSave = Scratch.app.extensionManager.extensionsToSave();
            if(extensionsToSave.length == 0)
            {
               delete this.info.savedExtensions;
            }
            else
            {
               this.info.savedExtensions = extensionsToSave;
            }
         }
         delete this.info.userAgent;
         if(Scratch.app.isOffline)
         {
            this.info.userAgent = "Scratch 2.0 Offline Editor";
         }
         else if(Scratch.app.jsEnabled)
         {
            Scratch.app.externalCall("window.navigator.userAgent.toString",function(param1:String):void
            {
               if(param1)
               {
                  info.userAgent = param1;
               }
            });
         }
      }
      
      public function updateListWatchers() : void
      {
         var _loc2_:DisplayObject = null;
         var _loc1_:int = 0;
         while(_loc1_ < numChildren)
         {
            _loc2_ = getChildAt(_loc1_);
            if(_loc2_ is ListWatcher)
            {
               ListWatcher(_loc2_).updateContents();
            }
            _loc1_++;
         }
      }
      
      public function scriptCount() : int
      {
         var _loc1_:int = 0;
         var _loc2_:ScratchObj = null;
         var _loc3_:* = undefined;
         for each(_loc2_ in this.allObjects())
         {
            for each(_loc3_ in _loc2_.scripts)
            {
               if(_loc3_ is Block && Boolean(_loc3_.isHat))
               {
                  _loc1_++;
               }
            }
         }
         return _loc1_;
      }
      
      public function spriteCount() : int
      {
         return this.sprites().length;
      }
      
      public function handleDrop(param1:*) : Boolean
      {
         var _loc2_:Point = null;
         if(param1 is ScratchSprite || param1 is Watcher || param1 is ListWatcher)
         {
            if(scaleX != 1)
            {
               param1.scaleX = param1.scaleY = param1.scaleX / scaleX;
            }
            _loc2_ = globalToLocal(new Point(param1.x,param1.y));
            param1.x = _loc2_.x;
            param1.y = _loc2_.y;
            if(param1.parent)
            {
               param1.parent.removeChild(param1);
            }
            addChild(param1);
            if(param1 is ScratchSprite)
            {
               (param1 as ScratchSprite).updateCostume();
               param1.setScratchXY(_loc2_.x - 240,180 - _loc2_.y);
               Scratch.app.selectSprite(param1);
               param1.setScratchXY(_loc2_.x - 240,180 - _loc2_.y);
               (param1 as ScratchObj).applyFilters();
            }
            if(!(param1 is ScratchSprite) || Scratch.app.editMode)
            {
               Scratch.app.setSaveNeeded();
            }
            return true;
         }
         Scratch.app.setSaveNeeded();
         return false;
      }
      
      override public function writeJSON(param1:util.JSON) : void
      {
         var _loc5_:DisplayObject = null;
         super.writeJSON(param1);
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc5_ = getChildAt(_loc3_);
            if(_loc5_ is ScratchSprite && !ScratchSprite(_loc5_).isClone || _loc5_ is Watcher || _loc5_ is ListWatcher)
            {
               _loc2_.push(_loc5_);
            }
            _loc3_++;
         }
         var _loc4_:Sprite = this.getUILayer();
         if(_loc4_ != this)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc4_.numChildren)
            {
               _loc5_ = _loc4_.getChildAt(_loc3_);
               if(_loc5_ is ScratchSprite && !ScratchSprite(_loc5_).isClone || _loc5_ is Watcher || _loc5_ is ListWatcher)
               {
                  _loc2_.push(_loc5_);
               }
               _loc3_++;
            }
         }
         param1.writeKeyValue("penLayerMD5",this.penLayerMD5);
         param1.writeKeyValue("penLayerID",this.penLayerID);
         param1.writeKeyValue("tempoBPM",this.tempoBPM);
         param1.writeKeyValue("videoAlpha",this.videoAlpha);
         param1.writeKeyValue("children",_loc2_);
         param1.writeKeyValue("info",this.info);
      }
      
      override public function readJSON(param1:Object) : void
      {
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:Object = null;
         var _loc6_:ScratchObj = null;
         var _loc7_:ScratchSprite = null;
         var _loc8_:Watcher = null;
         var _loc9_:Array = null;
         super.readJSON(param1);
         this.penLayerMD5 = param1.penLayerMD5;
         this.tempoBPM = param1.tempoBPM;
         if(param1.videoAlpha)
         {
            this.videoAlpha = param1.videoAlpha;
         }
         _loc2_ = param1.children;
         this.info = param1.info;
         var _loc5_:Object = new Object();
         _loc5_[objName] = this;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_.objName != undefined)
            {
               _loc7_ = new ScratchSprite();
               _loc7_.readJSON(_loc4_);
               _loc5_[_loc7_.objName] = _loc7_;
               _loc2_[_loc3_] = _loc7_;
            }
            _loc3_++;
         }
         _loc3_ = 0;
         for(; _loc3_ < _loc2_.length; _loc3_++)
         {
            _loc4_ = _loc2_[_loc3_];
            if(_loc4_ is ScratchSprite)
            {
               addChild(ScratchSprite(_loc4_));
            }
            else if(_loc4_.sliderMin != undefined)
            {
               _loc4_.target = _loc5_[_loc4_.target];
               if(_loc4_.target)
               {
                  if(Boolean(_loc4_.cmd == "senseVideoMotion") && Boolean(_loc4_.param) && Boolean(_loc4_.param.indexOf(",")))
                  {
                     _loc9_ = _loc4_.param.split(",");
                     if(_loc9_[1] == "this sprite")
                     {
                        continue;
                     }
                     _loc4_.param = _loc9_[0];
                  }
                  _loc8_ = new Watcher();
                  _loc8_.readJSON(_loc4_);
                  addChild(_loc8_);
               }
            }
         }
         for each(_loc6_ in this.allObjects())
         {
            _loc6_.instantiateFromJSON(this);
         }
      }
      
      override public function getSummary() : String
      {
         var _loc2_:ScratchSprite = null;
         var _loc1_:String = super.getSummary();
         for each(_loc2_ in this.sprites())
         {
            _loc1_ += "\n\n" + _loc2_.getSummary();
         }
         return _loc1_;
      }
   }
}

