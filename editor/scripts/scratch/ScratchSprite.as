package scratch
{
   import filters.FilterPack;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.FileReference;
   import flash.utils.*;
   import interpreter.Variable;
   import logging.LogLevel;
   import translation.Translator;
   import uiwidgets.Menu;
   import util.*;
   import watchers.ListWatcher;
   
   public class ScratchSprite extends ScratchObj
   {
      
      private static var stageRect:Rectangle = new Rectangle(0,0,480,360);
      
      private static var emptyRect:Rectangle = new Rectangle(0,0,0,0);
      
      private static var edgeBox:Rectangle = new Rectangle(0,0,480,360);
      
      public var scratchX:Number;
      
      public var scratchY:Number;
      
      public var direction:Number = 90;
      
      public var rotationStyle:String = "normal";
      
      public var isDraggable:Boolean = false;
      
      public var indexInLibrary:int;
      
      public var bubble:TalkBubble;
      
      public var penIsDown:Boolean;
      
      public var penWidth:Number = 1;
      
      public var penHue:Number = 120;
      
      public var penShade:Number = 50;
      
      public var penColorCache:Number = 255;
      
      private var cachedBitmap:BitmapData;
      
      private var cachedBounds:Rectangle;
      
      public var localMotionAmount:int = -2;
      
      public var localMotionDirection:int = -2;
      
      public var localFrameNum:int;
      
      public var spriteInfo:Object = {};
      
      private var geomShape:Shape;
      
      public function ScratchSprite(param1:String = null)
      {
         super();
         objName = Scratch.app.stagePane.unusedSpriteName(param1 || Translator.map("Sprite1"));
         filterPack = new FilterPack(this);
         this.initMedia();
         img = new Sprite();
         img.cacheAsBitmap = true;
         addChild(img);
         this.geomShape = new Shape();
         this.geomShape.visible = false;
         img.addChild(this.geomShape);
         showCostume(0);
         this.setScratchXY(0,0);
      }
      
      private function initMedia() : void
      {
         var _loc1_:BitmapData = new BitmapData(4,4,true,8421504);
         costumes.push(new ScratchCostume(Translator.map("costume1"),_loc1_));
         sounds.push(new ScratchSound(Translator.map("pop"),new Pop()));
         sounds[0].prepareToSave();
      }
      
      public function setInitialCostume(param1:ScratchCostume) : void
      {
         costumes = [param1];
         showCostume(0);
      }
      
      public function setRotationStyle(param1:String) : void
      {
         var _loc2_:Number = this.direction;
         this.setDirection(90);
         if("all around" == param1)
         {
            this.rotationStyle = "normal";
         }
         if("left-right" == param1)
         {
            this.rotationStyle = "leftRight";
         }
         if("don\'t rotate" == param1)
         {
            this.rotationStyle = "none";
         }
         this.setDirection(_loc2_);
      }
      
      public function duplicate() : ScratchSprite
      {
         var _loc1_:ScratchSprite = new ScratchSprite();
         _loc1_.initFrom(this,false);
         return _loc1_;
      }
      
      public function initFrom(param1:ScratchSprite, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:ScratchCostume = null;
         var _loc5_:Variable = null;
         var _loc6_:ListWatcher = null;
         var _loc7_:ListWatcher = null;
         _loc3_ = 0;
         while(_loc3_ < param1.variables.length)
         {
            _loc5_ = param1.variables[_loc3_];
            variables.push(new Variable(_loc5_.name,_loc5_.value));
            _loc3_++;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.lists.length)
         {
            _loc6_ = param1.lists[_loc3_];
            lists.push(_loc7_ = new ListWatcher(_loc6_.listName,_loc6_.contents.concat(),param1));
            _loc7_.visible = false;
            _loc3_++;
         }
         if(param2)
         {
            scripts = param1.scripts;
            sounds = param1.sounds;
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < param1.scripts.length)
            {
               scripts.push(param1.scripts[_loc3_].duplicate(param2));
               _loc3_++;
            }
            sounds = param1.sounds.concat();
         }
         costumes = [];
         for each(_loc4_ in param1.costumes)
         {
            costumes.push(_loc4_.duplicate());
         }
         currentCostumeIndex = param1.currentCostumeIndex;
         objName = param1.objName;
         volume = param1.volume;
         instrument = param1.instrument;
         filterPack = param1.filterPack.duplicateFor(this);
         visible = param1.visible;
         this.scratchX = param1.scratchX;
         this.scratchY = param1.scratchY;
         this.direction = param1.direction;
         this.rotationStyle = param1.rotationStyle;
         isClone = param2;
         this.isDraggable = param1.isDraggable;
         this.indexInLibrary = 100000;
         this.penIsDown = param1.penIsDown;
         this.penWidth = param1.penWidth;
         this.penHue = param1.penHue;
         this.penShade = param1.penShade;
         this.penColorCache = param1.penColorCache;
         showCostume(param1.currentCostumeIndex);
         this.setDirection(param1.direction);
         this.setScratchXY(param1.scratchX,param1.scratchY);
         this.setSize(param1.getSize());
         applyFilters();
      }
      
      override protected function updateImage() : void
      {
         if(this.geomShape.parent)
         {
            img.removeChild(this.geomShape);
         }
         super.updateImage();
         if(this.bubble)
         {
            this.updateBubble();
         }
      }
      
      public function setScratchXY(param1:Number, param2:Number) : void
      {
         this.scratchX = isFinite(param1) ? param1 : (param1 > 0 ? 1000000 : -1000000);
         this.scratchY = isFinite(param2) ? param2 : (param2 > 0 ? 1000000 : -1000000);
         x = 240 + Math.round(this.scratchX);
         y = 180 - Math.round(this.scratchY);
         this.updateBubble();
      }
      
      public function keepOnStage() : void
      {
         var _loc1_:Rectangle = null;
         if(width == 0 && height == 0)
         {
            emptyRect.x = x;
            emptyRect.y = y;
            _loc1_ = emptyRect;
         }
         else
         {
            _loc1_ = this.geomShape.getRect(parent);
            if(_loc1_.width == 0 || _loc1_.height == 0)
            {
               _loc1_.x = x;
               _loc1_.y = y;
            }
            _loc1_.inflate(3,3);
         }
         if(stageRect.containsRect(_loc1_))
         {
            return;
         }
         var _loc2_:int = Math.min(18,Math.min(_loc1_.width,_loc1_.height) / 2);
         edgeBox.x = edgeBox.y = _loc2_;
         _loc2_ += _loc2_;
         edgeBox.width = 480 - _loc2_;
         edgeBox.height = 360 - _loc2_;
         if(_loc1_.intersects(edgeBox))
         {
            return;
         }
         if(_loc1_.right < edgeBox.left)
         {
            this.scratchX = Math.ceil(this.scratchX + (edgeBox.left - _loc1_.right));
         }
         if(_loc1_.left > edgeBox.right)
         {
            this.scratchX = Math.floor(this.scratchX + (edgeBox.right - _loc1_.left));
         }
         if(_loc1_.bottom < edgeBox.top)
         {
            this.scratchY = Math.floor(this.scratchY + (_loc1_.bottom - edgeBox.top));
         }
         if(_loc1_.top > edgeBox.bottom)
         {
            this.scratchY = Math.ceil(this.scratchY + (_loc1_.top - edgeBox.bottom));
         }
         this.setScratchXY(this.scratchX,this.scratchY);
      }
      
      public function setDirection(param1:Number) : void
      {
         if(param1 * 0 != 0)
         {
            return;
         }
         var _loc2_:Boolean = this.isCostumeFlipped();
         param1 %= 360;
         if(param1 < 0)
         {
            param1 += 360;
         }
         this.direction = param1 > 180 ? param1 - 360 : param1;
         if("normal" == this.rotationStyle)
         {
            rotation = (this.direction - 90) % 360;
         }
         else
         {
            rotation = 0;
            if("none" == this.rotationStyle && !_loc2_)
            {
               return;
            }
            if("leftRight" == this.rotationStyle && this.isCostumeFlipped() == _loc2_)
            {
               return;
            }
         }
         if(!Scratch.app.isIn3D)
         {
            this.updateImage();
         }
         this.adjustForRotationCenter();
         if(_loc2_ != this.isCostumeFlipped())
         {
            updateRenderDetails(1);
         }
      }
      
      override protected function adjustForRotationCenter() : void
      {
         super.adjustForRotationCenter();
         this.geomShape.scaleX = img.getChildAt(0).scaleX;
      }
      
      public function getSize() : Number
      {
         return 100 * scaleX;
      }
      
      public function setSize(param1:Number) : void
      {
         var _loc2_:int = img.width;
         var _loc3_:int = img.height;
         var _loc4_:Number = Math.min(1,Math.max(5 / _loc2_,5 / _loc3_));
         var _loc5_:Number = Math.min(1.5 * 480 / _loc2_,1.5 * 360 / _loc3_);
         scaleX = scaleY = Math.max(_loc4_,Math.min(param1 / 100,_loc5_));
         this.clearCachedBitmap();
         this.updateBubble();
      }
      
      public function setPenSize(param1:Number) : void
      {
         this.penWidth = Math.max(1,Math.min(Math.round(param1),255));
      }
      
      public function setPenColor(param1:Number) : void
      {
         var _loc2_:Array = Color.rgb2hsv(param1);
         this.penHue = 200 * _loc2_[0] / 360;
         this.penShade = 50 * _loc2_[2];
         this.penColorCache = param1;
      }
      
      public function setPenHue(param1:Number) : void
      {
         this.penHue = param1 % 200;
         if(this.penHue < 0)
         {
            this.penHue += 200;
         }
         this.updateCachedPenColor();
      }
      
      public function setPenShade(param1:Number) : void
      {
         this.penShade = param1 % 200;
         if(this.penShade < 0)
         {
            this.penShade += 200;
         }
         this.updateCachedPenColor();
      }
      
      private function updateCachedPenColor() : void
      {
         var _loc1_:int = Color.fromHSV(this.penHue * 180 / 100,1,1);
         var _loc2_:Number = this.penShade > 100 ? 200 - this.penShade : this.penShade;
         if(_loc2_ < 50)
         {
            this.penColorCache = Color.mixRGB(0,_loc1_,(10 + _loc2_) / 60);
         }
         else
         {
            this.penColorCache = Color.mixRGB(_loc1_,16777215,(_loc2_ - 50) / 60);
         }
      }
      
      public function isCostumeFlipped() : Boolean
      {
         return this.rotationStyle == "leftRight" && this.direction < 0;
      }
      
      override public function clearCachedBitmap() : void
      {
         var _loc1_:DisplayObject = null;
         super.clearCachedBitmap();
         this.cachedBitmap = null;
         this.cachedBounds = null;
         if(!this.geomShape.parent)
         {
            this.geomShape.graphics.copyFrom(currentCostume().getShape().graphics);
            _loc1_ = img.getChildAt(0);
            this.geomShape.scaleX = _loc1_.scaleX;
            this.geomShape.scaleY = _loc1_.scaleY;
            this.geomShape.x = _loc1_.x;
            this.geomShape.y = _loc1_.y;
            this.geomShape.rotation = _loc1_.rotation;
            img.addChild(this.geomShape);
         }
      }
      
      override public function hitTestPoint(param1:Number, param2:Number, param3:Boolean = true) : Boolean
      {
         if(!visible || img.transform.colorTransform.alphaMultiplier == 0)
         {
            return false;
         }
         var _loc4_:Point = parent.globalToLocal(new Point(param1,param2));
         var _loc5_:Rectangle = this.bounds();
         if(!_loc5_.containsPoint(_loc4_))
         {
            return false;
         }
         return param3 ? this.bitmap(true).hitTest(_loc5_.topLeft,1,_loc4_) : true;
      }
      
      override public function getBounds(param1:DisplayObject) : Rectangle
      {
         return getChildAt(0).getBounds(param1);
      }
      
      public function bounds() : Rectangle
      {
         if(this.cachedBounds == null)
         {
            this.bitmap();
         }
         var _loc1_:Rectangle = this.cachedBounds.clone();
         _loc1_.offset(x,y);
         return _loc1_;
      }
      
      public function bitmap(param1:Boolean = false) : BitmapData
      {
         var b:Rectangle;
         var cropR:Rectangle;
         var m:Matrix = null;
         var r:Rectangle = null;
         var self:ScratchSprite = null;
         var oldGhost:Number = NaN;
         var bm:BitmapData = null;
         var cropped:BitmapData = null;
         var forTest:Boolean = param1;
         var bitmap2d:Function = function():Boolean
         {
            if(r.width == 0 || r.height == 0)
            {
               cachedBitmap = new BitmapData(1,1,true,0);
               cachedBounds = cachedBitmap.rect;
               return true;
            }
            var _loc1_:ColorTransform = img.transform.colorTransform;
            img.transform.colorTransform = new ColorTransform(1,1,1,1,_loc1_.redOffset,_loc1_.greenOffset,_loc1_.blueOffset,0);
            cachedBitmap = new BitmapData(Math.max(int(r.width),1),Math.max(int(r.height),1),true,0);
            m.translate(-r.left,-r.top);
            cachedBitmap.draw(self,m);
            img.transform.colorTransform = _loc1_;
            return false;
         };
         if(this.cachedBitmap != null && (!forTest || !Scratch.app.isIn3D))
         {
            return this.cachedBitmap;
         }
         m = new Matrix();
         m.rotate(Math.PI * rotation / 180);
         m.scale(scaleX,scaleY);
         b = !Scratch.app.render3D || Boolean(currentCostume().bitmap) ? img.getChildAt(0).getBounds(this) : this.getVisibleBounds(this);
         r = this.transformedBounds(b,m);
         self = this;
         if(Scratch.app.isIn3D)
         {
            oldGhost = filterPack.getFilterSetting("ghost");
            filterPack.setFilter("ghost",0);
            updateEffectsFor3D();
            bm = Scratch.app.render3D.getRenderedChild(this,b.width * scaleX,b.height * scaleY);
            filterPack.setFilter("ghost",oldGhost);
            updateEffectsFor3D();
            if(rotation != 0)
            {
               m = new Matrix();
               m.rotate(Math.PI * rotation / 180);
               b = this.transformedBounds(bm.rect,m);
               this.cachedBitmap = new BitmapData(Math.max(int(b.width),1),Math.max(int(b.height),1),true,0);
               m.translate(-b.left,-b.top);
               this.cachedBitmap.draw(bm,m);
            }
            else
            {
               this.cachedBitmap = bm;
            }
         }
         else if(bitmap2d())
         {
            return this.cachedBitmap;
         }
         this.cachedBounds = this.cachedBitmap.rect;
         cropR = this.cachedBitmap.getColorBoundsRect(4278190080,0,false);
         if(cropR.width > 0 && cropR.height > 0)
         {
            cropped = new BitmapData(Math.max(int(cropR.width),1),Math.max(int(cropR.height),1),true,0);
            cropped.copyPixels(this.cachedBitmap,cropR,new Point(0,0));
            this.cachedBitmap = cropped;
            this.cachedBounds = cropR;
         }
         this.cachedBounds.offset(r.x,r.y);
         return this.cachedBitmap;
      }
      
      private function transformedBounds(param1:Rectangle, param2:Matrix) : Rectangle
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc3_:Point = param2.transformPoint(param1.topLeft);
         var _loc4_:Point = param2.transformPoint(new Point(param1.right,param1.top));
         var _loc5_:Point = param2.transformPoint(new Point(param1.left,param1.bottom));
         var _loc6_:Point = param2.transformPoint(param1.bottomRight);
         _loc7_ = Math.min(_loc3_.x,_loc4_.x,_loc5_.x,_loc6_.x);
         _loc9_ = Math.min(_loc3_.y,_loc4_.y,_loc5_.y,_loc6_.y);
         _loc8_ = Math.max(_loc3_.x,_loc4_.x,_loc5_.x,_loc6_.x);
         _loc10_ = Math.max(_loc3_.y,_loc4_.y,_loc5_.y,_loc6_.y);
         return new Rectangle(_loc7_,_loc9_,_loc8_ - _loc7_,_loc10_ - _loc9_);
      }
      
      override public function defaultArgsFor(param1:String, param2:Array) : Array
      {
         var _loc3_:ScratchStage = null;
         if("gotoX:y:" == param1)
         {
            return [Math.round(this.scratchX),Math.round(this.scratchY)];
         }
         if("glideSecs:toX:y:elapsed:from:" == param1)
         {
            return [1,Math.round(this.scratchX),Math.round(this.scratchY)];
         }
         if("setSizeTo:" == param1)
         {
            return [Math.round(this.getSize() * 10) / 10];
         }
         if(["startScene","startSceneAndWait","whenSceneStarts"].indexOf(param1) > -1)
         {
            _loc3_ = parent as ScratchStage;
            if(_loc3_)
            {
               return [_loc3_.costumes[_loc3_.costumes.length - 1].costumeName];
            }
         }
         if("senseVideoMotion" == param1)
         {
            return ["motion","this sprite"];
         }
         return super.defaultArgsFor(param1,param2);
      }
      
      public function objToGrab(param1:MouseEvent) : ScratchSprite
      {
         return this;
      }
      
      public function menu(param1:MouseEvent) : Menu
      {
         var _loc2_:Menu = new Menu();
         _loc2_.addItem("info",this.showDetails);
         _loc2_.addLine();
         _loc2_.addItem("duplicate",this.duplicateSprite);
         _loc2_.addItem("delete",this.deleteSprite);
         _loc2_.addLine();
         _loc2_.addItem("save to local file",this.saveToLocalFile);
         return _loc2_;
      }
      
      public function handleTool(param1:String, param2:MouseEvent) : void
      {
         if(param1 == "copy")
         {
            this.duplicateSprite(true);
         }
         if(param1 == "cut")
         {
            this.deleteSprite();
         }
         if(param1 == "grow")
         {
            this.growSprite();
         }
         if(param1 == "shrink")
         {
            this.shrinkSprite();
         }
         if(param1 == "help")
         {
            Scratch.app.showTip("scratchUI");
         }
      }
      
      private function growSprite() : void
      {
         this.setSize(this.getSize() + 5);
         Scratch.app.updatePalette();
      }
      
      private function shrinkSprite() : void
      {
         this.setSize(this.getSize() - 5);
         Scratch.app.updatePalette();
      }
      
      public function duplicateSprite(param1:Boolean = false) : void
      {
         var _loc3_:Scratch = null;
         var _loc2_:ScratchSprite = this.duplicate();
         _loc2_.objName = this.unusedSpriteName(objName);
         if(!param1)
         {
            _loc2_.setScratchXY(int(Math.random() * 400) - 200,int(Math.random() * 300) - 150);
         }
         if(parent != null)
         {
            parent.addChild(_loc2_);
            _loc3_ = root as Scratch;
            if(_loc3_)
            {
               _loc3_.setSaveNeeded();
               _loc3_.updateSpriteLibrary();
               if(param1)
               {
                  _loc3_.gh.grabOnMouseUp(_loc2_);
               }
            }
         }
      }
      
      public function showDetails() : void
      {
         var _loc1_:Scratch = Scratch.app;
         _loc1_.selectSprite(this);
         _loc1_.libraryPart.showSpriteDetails(true);
      }
      
      public function unusedSpriteName(param1:String) : String
      {
         var _loc2_:ScratchStage = parent as ScratchStage;
         return _loc2_ ? _loc2_.unusedSpriteName(param1) : param1;
      }
      
      public function deleteSprite() : void
      {
         var _loc1_:Scratch = null;
         var _loc2_:Array = null;
         var _loc3_:ScratchSprite = null;
         var _loc4_:ScratchSprite = null;
         if(parent != null)
         {
            _loc1_ = Scratch.app;
            _loc1_.runtime.recordForUndelete(this,this.scratchX,this.scratchY,0,_loc1_.stagePane);
            this.hideBubble();
            if(!Scratch.app.isIn3D)
            {
               parent.visible = false;
               parent.visible = true;
            }
            parent.removeChild(this);
            if(_loc1_)
            {
               _loc1_.stagePane.removeObsoleteWatchers();
               _loc2_ = _loc1_.stagePane.sprites();
               if(_loc2_.length > 0)
               {
                  _loc2_.sortOn("indexInLibrary");
                  _loc3_ = _loc2_[0];
                  for each(_loc4_ in _loc2_)
                  {
                     if(_loc4_.indexInLibrary > this.indexInLibrary)
                     {
                        break;
                     }
                     _loc3_ = _loc4_;
                  }
                  _loc1_.selectSprite(_loc3_);
               }
               else
               {
                  _loc1_.selectSprite(_loc1_.stagePane);
               }
               _loc1_.setSaveNeeded();
               _loc1_.updateSpriteLibrary();
            }
         }
      }
      
      private function saveToLocalFile() : void
      {
         var success:Function = null;
         var file:FileReference = null;
         success = function():void
         {
            Scratch.app.log(LogLevel.INFO,"sprite saved to file",{"filename":file.name});
         };
         var zipData:ByteArray = new ProjectIO(Scratch.app).encodeSpriteAsZipFile(this.copyToShare());
         var defaultName:String = objName + ".sprite2";
         file = new FileReference();
         file.addEventListener(Event.COMPLETE,success);
         file.save(zipData,defaultName);
      }
      
      public function copyToShare() : ScratchSprite
      {
         var _loc1_:ScratchSprite = new ScratchSprite();
         _loc1_.initFrom(this,false);
         _loc1_.setScratchXY(0,0);
         _loc1_.visible = true;
         return _loc1_;
      }
      
      public function showBubble(param1:*, param2:String, param3:Object, param4:Boolean = false) : void
      {
         this.hideBubble();
         if(param1 == null)
         {
            param1 = "NULL";
         }
         if(param1 is Number)
         {
            if(Math.abs(param1) >= 0.01 && int(param1) != param1)
            {
               param1 = param1.toFixed(2);
            }
            else
            {
               param1 = param1.toString();
            }
         }
         if(!(param1 is String))
         {
            param1 = param1.toString();
         }
         if(param1.length == 0)
         {
            return;
         }
         this.bubble = new TalkBubble(param1,param2,param4 ? "ask" : "say",param3);
         parent.addChild(this.bubble);
         this.updateBubble();
      }
      
      public function hideBubble() : void
      {
         if(this.bubble == null)
         {
            return;
         }
         this.bubble.parent.removeChild(this.bubble);
         this.bubble = null;
      }
      
      public function updateBubble() : void
      {
         if(this.bubble == null)
         {
            return;
         }
         if(this.bubble.visible != visible)
         {
            this.bubble.visible = visible;
         }
         if(!visible)
         {
            return;
         }
         var _loc1_:int = 3;
         var _loc2_:int = _loc1_;
         var _loc3_:int = STAGEW - _loc1_;
         var _loc4_:int = STAGEH;
         var _loc5_:Rectangle = this.bubbleRect();
         var _loc6_:Boolean = this.bubble.pointsLeft;
         if(_loc6_ && _loc5_.x + _loc5_.width + this.bubble.width > _loc3_)
         {
            _loc6_ = false;
         }
         if(!_loc6_ && _loc5_.x - this.bubble.width < 0)
         {
            _loc6_ = true;
         }
         if(_loc6_)
         {
            this.bubble.setDirection("left");
            this.bubble.x = _loc5_.x + _loc5_.width;
         }
         else
         {
            this.bubble.setDirection("right");
            this.bubble.x = _loc5_.x - this.bubble.width;
         }
         if(this.bubble.x + this.bubble.width > _loc3_)
         {
            this.bubble.x = _loc3_ - this.bubble.width;
         }
         if(this.bubble.x < _loc2_)
         {
            this.bubble.x = _loc2_;
         }
         this.bubble.y = Math.max(_loc5_.y - this.bubble.height,_loc1_);
         if(this.bubble.y + this.bubble.height > _loc4_)
         {
            this.bubble.y = _loc4_ - this.bubble.height;
         }
      }
      
      private function bubbleRect() : Rectangle
      {
         var _loc1_:BitmapData = this.bitmap();
         var _loc2_:int = 8;
         var _loc3_:Point = Scratch.app.stagePane.globalToLocal(localToGlobal(new Point(0,0)));
         if(this.cachedBounds == null)
         {
            this.bitmap();
         }
         var _loc4_:Rectangle = this.cachedBounds.clone();
         _loc4_.offset(_loc3_.x,_loc3_.y);
         var _loc5_:BitmapData = new BitmapData(_loc1_.width,_loc2_,true,0);
         _loc5_.copyPixels(_loc1_,_loc1_.rect,new Point(0,0));
         var _loc6_:Rectangle = _loc5_.getColorBoundsRect(4278190080,0,false);
         if(_loc6_.width == 0 || _loc6_.height == 0)
         {
            return _loc4_;
         }
         return new Rectangle(_loc4_.x + _loc6_.x,_loc4_.y,_loc6_.width,10);
      }
      
      override public function writeJSON(param1:util.JSON) : void
      {
         super.writeJSON(param1);
         param1.writeKeyValue("scratchX",this.scratchX);
         param1.writeKeyValue("scratchY",this.scratchY);
         param1.writeKeyValue("scale",scaleX);
         param1.writeKeyValue("direction",this.direction);
         param1.writeKeyValue("rotationStyle",this.rotationStyle);
         param1.writeKeyValue("isDraggable",this.isDraggable);
         param1.writeKeyValue("indexInLibrary",this.indexInLibrary);
         param1.writeKeyValue("visible",visible);
         param1.writeKeyValue("spriteInfo",this.spriteInfo);
      }
      
      override public function readJSON(param1:Object) : void
      {
         super.readJSON(param1);
         this.scratchX = param1.scratchX;
         this.scratchY = param1.scratchY;
         scaleX = scaleY = param1.scale;
         this.direction = param1.direction;
         this.rotationStyle = param1.rotationStyle;
         this.isDraggable = param1.isDraggable;
         this.indexInLibrary = param1.indexInLibrary;
         visible = param1.visible;
         this.spriteInfo = param1.spriteInfo ? param1.spriteInfo : {};
         this.setScratchXY(this.scratchX,this.scratchY);
      }
      
      public function getVisibleBounds(param1:DisplayObject) : Rectangle
      {
         var _loc3_:Number = NaN;
         if(param1 == this)
         {
            _loc3_ = rotation;
            rotation = 0;
         }
         if(!this.geomShape.parent)
         {
            img.addChild(this.geomShape);
            this.geomShape.x = img.getChildAt(0).x;
            this.geomShape.scaleX = img.getChildAt(0).scaleX;
         }
         var _loc2_:Rectangle = this.geomShape.getRect(param1);
         if(param1 == this)
         {
            rotation = _loc3_;
            _loc2_.inflate(2,2);
            _loc2_.offset(-1,-1);
         }
         return _loc2_;
      }
      
      public function prepareToDrag() : void
      {
         applyFilters(true);
      }
      
      override public function stopDrag() : void
      {
         super.stopDrag();
         applyFilters();
      }
   }
}

