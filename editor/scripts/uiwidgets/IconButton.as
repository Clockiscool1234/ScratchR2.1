package uiwidgets
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.*;
   
   public class IconButton extends Sprite
   {
      
      public var clickFunction:Function;
      
      public var isRadioButton:Boolean;
      
      public var isMomentary:Boolean;
      
      public var lastEvent:MouseEvent;
      
      public var clientData:*;
      
      private var buttonIsOn:Boolean;
      
      private var mouseIsOver:Boolean;
      
      private var onImage:DisplayObject;
      
      private var offImage:DisplayObject;
      
      public function IconButton(param1:Function, param2:*, param3:DisplayObject = null, param4:Boolean = false)
      {
         super();
         this.clickFunction = param1;
         this.isRadioButton = param4;
         this.useDefaultImages();
         this.setImage(param2,param3);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         mouseChildren = false;
      }
      
      public function actOnMouseUp() : void
      {
         removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseDown);
      }
      
      public function disableMouseover() : void
      {
         removeEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         removeEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
      }
      
      public function setImage(param1:*, param2:DisplayObject = null) : void
      {
         var _loc3_:String = null;
         if(param1 is String)
         {
            _loc3_ = param1;
            this.onImage = Resources.createBmp(_loc3_ + "On");
            this.offImage = Resources.createBmp(_loc3_ + "Off");
         }
         else if(param1 is DisplayObject)
         {
            this.onImage = param1 as DisplayObject;
            this.offImage = param2 == null ? this.onImage : param2;
         }
         this.redraw();
      }
      
      public function turnOff() : void
      {
         if(!this.buttonIsOn)
         {
            return;
         }
         this.buttonIsOn = false;
         this.redraw();
      }
      
      public function turnOn() : void
      {
         if(this.buttonIsOn)
         {
            return;
         }
         this.buttonIsOn = true;
         this.redraw();
      }
      
      public function setOn(param1:Boolean) : void
      {
         if(param1)
         {
            this.turnOn();
         }
         else
         {
            this.turnOff();
         }
      }
      
      public function isOn() : Boolean
      {
         return this.buttonIsOn;
      }
      
      public function right() : int
      {
         return x + width;
      }
      
      public function bottom() : int
      {
         return y + height;
      }
      
      public function isDisabled() : Boolean
      {
         return alpha < 1;
      }
      
      public function setDisabled(param1:Boolean, param2:Number = 0, param3:DisplayObject = null) : void
      {
         alpha = param1 ? param2 : 1;
         if(param1)
         {
            this.mouseIsOver = false;
            this.turnOff();
         }
         if(param3)
         {
            this.offImage = param3;
            this.redraw();
         }
         mouseEnabled = !param1;
      }
      
      public function setLabel(param1:String, param2:int, param3:int, param4:Boolean = false) : void
      {
         this.setImage(this.makeLabelSprite(param1,param3,param4),this.makeLabelSprite(param1,param2,param4));
         this.isMomentary = true;
      }
      
      private function makeLabelSprite(param1:String, param2:int, param3:Boolean) : Sprite
      {
         var _loc4_:TextField = Resources.makeLabel(param1,CSS.topBarButtonFormat);
         _loc4_.textColor = param2;
         var _loc5_:Sprite = new Sprite();
         _loc5_.addChild(_loc4_);
         if(param3)
         {
            _loc5_.addChild(this.menuArrow(_loc4_.textWidth + 6,6,param2));
         }
         return _loc5_;
      }
      
      private function menuArrow(param1:int, param2:int, param3:int) : Shape
      {
         var _loc4_:Shape = new Shape();
         var _loc5_:Graphics = _loc4_.graphics;
         _loc5_.beginFill(param3);
         _loc5_.lineTo(8,0);
         _loc5_.lineTo(4,6);
         _loc5_.lineTo(0,0);
         _loc5_.endFill();
         _loc4_.x = param1;
         _loc4_.y = param2;
         return _loc4_;
      }
      
      private function redraw() : void
      {
         var _loc1_:DisplayObject = this.buttonIsOn ? this.onImage : this.offImage;
         if(this.mouseIsOver && !this.buttonIsOn)
         {
            _loc1_ = this.onImage;
         }
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         addChild(_loc1_);
         graphics.clear();
         graphics.beginFill(160,0);
         graphics.drawRect(0,0,Math.max(10,_loc1_.width),Math.max(10,_loc1_.height));
         graphics.endFill();
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         if(this.isDisabled())
         {
            return;
         }
         if(CursorTool.tool == "help")
         {
            return;
         }
         if(this.isRadioButton)
         {
            if(this.buttonIsOn)
            {
               return;
            }
            this.turnOffOtherRadioButtons();
         }
         this.buttonIsOn = !this.buttonIsOn;
         this.redraw();
         if(this.clickFunction != null)
         {
            this.lastEvent = param1;
            this.clickFunction(this);
            this.lastEvent = null;
         }
         if(this.isMomentary)
         {
            this.buttonIsOn = false;
         }
         else
         {
            this.mouseIsOver = false;
         }
         this.redraw();
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         if(!this.isDisabled())
         {
            this.mouseIsOver = true;
            this.redraw();
         }
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         if(!this.isDisabled())
         {
            this.mouseIsOver = false;
            this.redraw();
         }
      }
      
      private function turnOffOtherRadioButtons() : void
      {
         var _loc2_:* = undefined;
         if(parent == null)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < parent.numChildren)
         {
            _loc2_ = parent.getChildAt(_loc1_);
            if(Boolean(_loc2_ is IconButton) && Boolean(_loc2_.isRadioButton) && _loc2_ != this)
            {
               _loc2_.turnOff();
            }
            _loc1_++;
         }
      }
      
      private function useDefaultImages() : void
      {
         var _loc1_:int = 3618615;
         this.offImage = new Sprite();
         var _loc2_:Graphics = Sprite(this.offImage).graphics;
         _loc2_.lineStyle(1,_loc1_);
         _loc2_.beginFill(0,0);
         _loc2_.drawCircle(6,6,6);
         this.onImage = new Sprite();
         _loc2_ = Sprite(this.onImage).graphics;
         _loc2_.lineStyle(1,_loc1_);
         _loc2_.beginFill(0,0);
         _loc2_.drawCircle(6,6,6);
         _loc2_.beginFill(_loc1_);
         _loc2_.drawCircle(6,6,4);
         _loc2_.endFill();
      }
   }
}

