package ui.parts
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import scratch.*;
   import translation.Translator;
   import uiwidgets.*;
   import util.DragClient;
   
   public class SpriteInfoPart extends UIPart implements DragClient
   {
      
      private const readoutLabelFormat:TextFormat = new TextFormat(CSS.font,12,10922155,true);
      
      private const readoutFormat:TextFormat = new TextFormat(CSS.font,12,10922155);
      
      private var shape:Shape;
      
      private var closeButton:IconButton;
      
      private var thumbnail:Bitmap;
      
      private var spriteName:EditableLabel;
      
      private var xReadoutLabel:TextField;
      
      private var yReadoutLabel:TextField;
      
      private var xReadout:TextField;
      
      private var yReadout:TextField;
      
      private var dirLabel:TextField;
      
      private var dirReadout:TextField;
      
      private var dirWheel:Sprite;
      
      private var rotationStyleLabel:TextField;
      
      private var rotationStyleButtons:Array;
      
      private var draggableLabel:TextField;
      
      private var draggableButton:IconButton;
      
      private var showSpriteLabel:TextField;
      
      private var showSpriteButton:IconButton;
      
      private var lastX:Number;
      
      private var lastY:Number;
      
      private var lastDirection:Number;
      
      private var lastRotationStyle:String;
      
      private var lastSrcImg:DisplayObject;
      
      public function SpriteInfoPart(param1:Scratch)
      {
         super();
         this.app = param1;
         this.shape = new Shape();
         addChild(this.shape);
         this.addParts();
         this.updateTranslation();
      }
      
      public static function strings() : Array
      {
         return ["direction:","rotation style:","can drag in player:","show:"];
      }
      
      public function updateTranslation() : void
      {
         this.dirLabel.text = Translator.map("direction:");
         this.rotationStyleLabel.text = Translator.map("rotation style:");
         this.draggableLabel.text = Translator.map("can drag in player:");
         this.showSpriteLabel.text = Translator.map("show:");
         if(app.viewedObj())
         {
            this.refresh();
         }
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.w = param1;
         this.h = param2;
         var _loc3_:Graphics = this.shape.graphics;
         _loc3_.clear();
         _loc3_.beginFill(CSS.white);
         _loc3_.drawRect(0,0,param1,param2);
         _loc3_.endFill();
      }
      
      public function step() : void
      {
         this.updateSpriteInfo();
      }
      
      public function refresh() : void
      {
         this.spriteName.setContents(app.viewedObj().objName);
         this.updateSpriteInfo();
         if(app.stageIsContracted)
         {
            this.layoutCompact();
         }
         else
         {
            this.layoutFullsize();
         }
      }
      
      private function addParts() : void
      {
         var _loc1_:IconButton = null;
         addChild(this.closeButton = new IconButton(this.closeSpriteInfo,"backarrow"));
         this.closeButton.isMomentary = true;
         addChild(this.spriteName = new EditableLabel(this.nameChanged));
         this.spriteName.setWidth(200);
         addChild(this.thumbnail = new Bitmap());
         addChild(this.xReadoutLabel = makeLabel("x:",this.readoutLabelFormat));
         addChild(this.xReadout = makeLabel("-888",this.readoutFormat));
         addChild(this.yReadoutLabel = makeLabel("y:",this.readoutLabelFormat));
         addChild(this.yReadout = makeLabel("-888",this.readoutFormat));
         addChild(this.dirLabel = makeLabel("",this.readoutLabelFormat));
         addChild(this.dirWheel = new Sprite());
         this.dirWheel.addEventListener(MouseEvent.MOUSE_DOWN,this.dirMouseDown);
         addChild(this.dirReadout = makeLabel("-179",this.readoutFormat));
         addChild(this.rotationStyleLabel = makeLabel("",this.readoutLabelFormat));
         this.rotationStyleButtons = [new IconButton(this.rotate360,"rotate360",null,true),new IconButton(this.rotateFlip,"flip",null,true),new IconButton(this.rotateNone,"norotation",null,true)];
         for each(_loc1_ in this.rotationStyleButtons)
         {
            addChild(_loc1_);
         }
         addChild(this.draggableLabel = makeLabel("",this.readoutLabelFormat));
         addChild(this.draggableButton = new IconButton(this.toggleLock,"checkbox"));
         this.draggableButton.disableMouseover();
         addChild(this.showSpriteLabel = makeLabel("",this.readoutLabelFormat));
         addChild(this.showSpriteButton = new IconButton(this.toggleShowSprite,"checkbox"));
         this.showSpriteButton.disableMouseover();
      }
      
      private function layoutFullsize() : void
      {
         var _loc2_:int = 0;
         this.dirLabel.visible = true;
         this.rotationStyleLabel.visible = true;
         this.closeButton.x = 5;
         this.closeButton.y = 5;
         this.thumbnail.x = 40;
         this.thumbnail.y = 8;
         var _loc1_:int = 150;
         this.spriteName.setWidth(228);
         this.spriteName.x = _loc1_;
         this.spriteName.y = 5;
         _loc2_ = this.spriteName.y + this.spriteName.height + 9;
         this.xReadoutLabel.x = _loc1_;
         this.xReadoutLabel.y = _loc2_;
         this.xReadout.x = this.xReadoutLabel.x + 15;
         this.xReadout.y = _loc2_;
         this.yReadoutLabel.x = _loc1_ + 47;
         this.yReadoutLabel.y = _loc2_;
         this.yReadout.x = this.yReadoutLabel.x + 15;
         this.yReadout.y = _loc2_;
         this.dirWheel.x = w - 38;
         this.dirWheel.y = _loc2_ + 8;
         this.dirReadout.x = this.dirWheel.x - 47;
         this.dirReadout.y = _loc2_;
         this.dirLabel.x = this.dirReadout.x - this.dirLabel.textWidth - 5;
         this.dirLabel.y = _loc2_;
         _loc2_ += 22;
         this.rotationStyleLabel.x = _loc1_;
         this.rotationStyleLabel.y = _loc2_;
         var _loc3_:int = this.rotationStyleLabel.x + this.rotationStyleLabel.width + 5;
         this.rotationStyleButtons[0].x = _loc3_;
         this.rotationStyleButtons[1].x = _loc3_ + 28;
         this.rotationStyleButtons[2].x = _loc3_ + 55;
         this.rotationStyleButtons[0].y = this.rotationStyleButtons[1].y = this.rotationStyleButtons[2].y = _loc2_;
         _loc2_ += 22;
         this.draggableLabel.x = _loc1_;
         this.draggableLabel.y = _loc2_;
         this.draggableButton.x = this.draggableLabel.x + this.draggableLabel.textWidth + 10;
         this.draggableButton.y = _loc2_ + 4;
         _loc2_ += 22;
         this.showSpriteLabel.x = _loc1_;
         this.showSpriteLabel.y = _loc2_;
         this.showSpriteButton.x = this.showSpriteLabel.x + this.showSpriteLabel.textWidth + 10;
         this.showSpriteButton.y = _loc2_ + 4;
      }
      
      private function layoutCompact() : void
      {
         var _loc2_:int = 0;
         this.dirLabel.visible = false;
         this.rotationStyleLabel.visible = false;
         this.closeButton.x = 5;
         this.closeButton.y = 5;
         this.spriteName.setWidth(130);
         this.spriteName.x = 28;
         this.spriteName.y = 5;
         var _loc1_:int = 6;
         this.thumbnail.x = (w - this.thumbnail.width) / 2 + 3;
         this.thumbnail.y = this.spriteName.y + this.spriteName.height + 10;
         _loc2_ = 125;
         this.xReadoutLabel.x = _loc1_;
         this.xReadoutLabel.y = _loc2_;
         this.xReadout.x = _loc1_ + 15;
         this.xReadout.y = _loc2_;
         this.yReadoutLabel.x = _loc1_ + 47;
         this.yReadoutLabel.y = _loc2_;
         this.yReadout.x = this.yReadoutLabel.x + 15;
         this.yReadout.y = _loc2_;
         this.dirWheel.x = w - 18;
         this.dirWheel.y = _loc2_ + 8;
         this.dirReadout.x = this.dirWheel.x - 47;
         this.dirReadout.y = _loc2_;
         _loc2_ += 22;
         this.rotationStyleButtons[0].x = _loc1_;
         this.rotationStyleButtons[1].x = _loc1_ + 33;
         this.rotationStyleButtons[2].x = _loc1_ + 64;
         this.rotationStyleButtons[0].y = this.rotationStyleButtons[1].y = this.rotationStyleButtons[2].y = _loc2_;
         _loc2_ += 22;
         this.draggableLabel.x = _loc1_;
         this.draggableLabel.y = _loc2_;
         this.draggableButton.x = this.draggableLabel.x + this.draggableLabel.textWidth + 10;
         this.draggableButton.y = _loc2_ + 4;
         _loc2_ += 22;
         this.showSpriteLabel.x = _loc1_;
         this.showSpriteLabel.y = _loc2_;
         this.showSpriteButton.x = this.showSpriteLabel.x + this.showSpriteLabel.textWidth + 10;
         this.showSpriteButton.y = _loc2_ + 4;
      }
      
      private function closeSpriteInfo(param1:*) : void
      {
         var _loc2_:LibraryPart = parent as LibraryPart;
         if(_loc2_)
         {
            _loc2_.showSpriteDetails(false);
         }
      }
      
      private function rotate360(param1:*) : void
      {
         var _loc2_:ScratchSprite = app.viewedObj() as ScratchSprite;
         _loc2_.rotationStyle = "normal";
         _loc2_.setDirection(_loc2_.direction);
         app.setSaveNeeded();
      }
      
      private function rotateFlip(param1:*) : void
      {
         var _loc2_:ScratchSprite = app.viewedObj() as ScratchSprite;
         var _loc3_:Number = _loc2_.direction;
         _loc2_.setDirection(90);
         _loc2_.rotationStyle = "leftRight";
         _loc2_.setDirection(_loc3_);
         app.setSaveNeeded();
      }
      
      private function rotateNone(param1:*) : void
      {
         var _loc2_:ScratchSprite = app.viewedObj() as ScratchSprite;
         var _loc3_:Number = _loc2_.direction;
         _loc2_.setDirection(90);
         _loc2_.rotationStyle = "none";
         _loc2_.setDirection(_loc3_);
         app.setSaveNeeded();
      }
      
      private function toggleLock(param1:IconButton) : void
      {
         var _loc2_:ScratchSprite = ScratchSprite(app.viewedObj());
         if(_loc2_)
         {
            _loc2_.isDraggable = param1.isOn();
            app.setSaveNeeded();
         }
      }
      
      private function toggleShowSprite(param1:IconButton) : void
      {
         var _loc2_:ScratchSprite = ScratchSprite(app.viewedObj());
         if(_loc2_)
         {
            _loc2_.visible = !_loc2_.visible;
            _loc2_.updateBubble();
            param1.setOn(_loc2_.visible);
            app.setSaveNeeded();
         }
      }
      
      private function updateSpriteInfo() : void
      {
         var _loc1_:ScratchSprite = app.viewedObj() as ScratchSprite;
         if(_loc1_ == null)
         {
            return;
         }
         this.updateThumbnail();
         if(_loc1_.scratchX != this.lastX)
         {
            this.xReadout.text = String(Math.round(_loc1_.scratchX));
            this.lastX = _loc1_.scratchX;
         }
         if(_loc1_.scratchY != this.lastY)
         {
            this.yReadout.text = String(Math.round(_loc1_.scratchY));
            this.lastY = _loc1_.scratchY;
         }
         if(_loc1_.direction != this.lastDirection)
         {
            this.dirReadout.text = String(Math.round(_loc1_.direction)) + "°";
            this.drawDirWheel(_loc1_.direction);
            this.lastDirection = _loc1_.direction;
         }
         if(_loc1_.rotationStyle != this.lastRotationStyle)
         {
            this.updateRotationStyle();
            this.lastRotationStyle = _loc1_.rotationStyle;
         }
         this.draggableButton.setOn(_loc1_.isDraggable);
         this.showSpriteButton.setOn(_loc1_.visible);
      }
      
      private function drawDirWheel(param1:Number) : void
      {
         var _loc2_:Number = 2 * Math.PI / 360;
         var _loc3_:Number = 11;
         var _loc4_:Graphics = this.dirWheel.graphics;
         _loc4_.clear();
         _loc4_.beginFill(255,0);
         _loc4_.drawCircle(0,0,_loc3_ + 5);
         _loc4_.endFill();
         _loc4_.lineStyle(2,13684944,1,true);
         _loc4_.drawCircle(0,0,_loc3_ - 3);
         _loc4_.lineStyle(3,24704,1,true);
         _loc4_.moveTo(0,0);
         var _loc5_:Number = _loc3_ * Math.sin(_loc2_ * (180 - param1));
         var _loc6_:Number = _loc3_ * Math.cos(_loc2_ * (180 - param1));
         _loc4_.lineTo(_loc5_,_loc6_);
      }
      
      private function nameChanged() : void
      {
         app.runtime.renameSprite(this.spriteName.contents());
         this.spriteName.setContents(app.viewedObj().objName);
      }
      
      public function updateThumbnail() : void
      {
         var _loc1_:ScratchObj = app.viewedObj();
         if(_loc1_ == null)
         {
            return;
         }
         if(_loc1_.img.numChildren == 0)
         {
            return;
         }
         var _loc2_:DisplayObject = _loc1_.img.getChildAt(0);
         if(_loc2_ == this.lastSrcImg)
         {
            return;
         }
         var _loc3_:ScratchCostume = _loc1_.currentCostume();
         this.thumbnail.bitmapData = _loc3_.thumbnail(80,80,_loc1_.isStage);
         this.lastSrcImg = _loc2_;
      }
      
      private function updateRotationStyle() : void
      {
         var _loc3_:IconButton = null;
         var _loc1_:ScratchSprite = app.viewedObj() as ScratchSprite;
         if(_loc1_ == null)
         {
            return;
         }
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_) as IconButton;
            if(_loc3_)
            {
               if(_loc3_.clickFunction == this.rotate360)
               {
                  _loc3_.setOn(_loc1_.rotationStyle == "normal");
               }
               if(_loc3_.clickFunction == this.rotateFlip)
               {
                  _loc3_.setOn(_loc1_.rotationStyle == "leftRight");
               }
               if(_loc3_.clickFunction == this.rotateNone)
               {
                  _loc3_.setOn(_loc1_.rotationStyle == "none");
               }
            }
            _loc2_++;
         }
      }
      
      private function dirMouseDown(param1:MouseEvent) : void
      {
         app.gh.setDragClient(this,param1);
      }
      
      public function dragBegin(param1:MouseEvent) : void
      {
         this.dragMove(param1);
      }
      
      public function dragEnd(param1:MouseEvent) : void
      {
         this.dragMove(param1);
      }
      
      public function dragMove(param1:MouseEvent) : void
      {
         var _loc2_:ScratchSprite = app.viewedObj() as ScratchSprite;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:Point = this.dirWheel.localToGlobal(new Point(0,0));
         var _loc4_:int = param1.stageX - _loc3_.x;
         var _loc5_:int = param1.stageY - _loc3_.y;
         if(_loc4_ == 0 && _loc5_ == 0)
         {
            return;
         }
         var _loc6_:Number = 90 + 180 / Math.PI * Math.atan2(_loc5_,_loc4_);
         _loc2_.setDirection(_loc6_);
      }
   }
}

