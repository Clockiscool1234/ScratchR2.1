package uiwidgets
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class Button extends Sprite
   {
      
      private var labelOrIcon:DisplayObject;
      
      private var color:* = CSS.titleBarColors;
      
      private var minWidth:int = 50;
      
      private var paddingX:Number = 5.5;
      
      private var compact:Boolean;
      
      private var action:Function;
      
      private var eventAction:Function;
      
      private var tipName:String;
      
      public function Button(param1:String, param2:Function = null, param3:Boolean = false, param4:String = null)
      {
         super();
         this.action = param2;
         this.compact = param3;
         this.tipName = param4;
         this.addLabel(param1);
         mouseChildren = false;
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.setColor(CSS.titleBarColors);
      }
      
      public function setLabel(param1:String) : void
      {
         if(this.labelOrIcon is TextField)
         {
            TextField(this.labelOrIcon).text = param1;
            this.setMinWidthHeight(0,0);
         }
         else
         {
            if(this.labelOrIcon != null && this.labelOrIcon.parent != null)
            {
               this.labelOrIcon.parent.removeChild(this.labelOrIcon);
            }
            this.addLabel(param1);
         }
      }
      
      public function setIcon(param1:DisplayObject) : void
      {
         if(this.labelOrIcon != null && this.labelOrIcon.parent != null)
         {
            this.labelOrIcon.parent.removeChild(this.labelOrIcon);
         }
         this.labelOrIcon = param1;
         if(param1 != null)
         {
            addChild(this.labelOrIcon);
         }
         this.setMinWidthHeight(0,0);
      }
      
      public function setWidth(param1:int) : void
      {
         this.paddingX = (param1 - this.labelOrIcon.width) / 2;
         this.setMinWidthHeight(5,5);
      }
      
      public function setMinWidthHeight(param1:int, param2:int) : void
      {
         var _loc3_:Matrix = null;
         if(this.labelOrIcon != null)
         {
            if(this.labelOrIcon is TextField)
            {
               param1 = Math.max(this.minWidth,this.labelOrIcon.width + this.paddingX * 2);
               param2 = this.compact ? 20 : 25;
            }
            else
            {
               param1 = Math.max(this.minWidth,this.labelOrIcon.width + 12);
               param2 = Math.max(param2,this.labelOrIcon.height + 11);
            }
            this.labelOrIcon.x = (param1 - this.labelOrIcon.width) / 2;
            this.labelOrIcon.y = (param2 - this.labelOrIcon.height) / 2;
         }
         graphics.clear();
         graphics.lineStyle(0.5,CSS.borderColor,1,true);
         if(this.color is Array)
         {
            _loc3_ = new Matrix();
            _loc3_.createGradientBox(param1,param2,Math.PI / 2,0,0);
            graphics.beginGradientFill(GradientType.LINEAR,CSS.titleBarColors,[100,100],[0,255],_loc3_);
         }
         else
         {
            graphics.beginFill(this.color);
         }
         graphics.drawRoundRect(0,0,param1,param2,12);
         graphics.endFill();
      }
      
      public function setEventAction(param1:Function) : Function
      {
         var _loc2_:Function = this.eventAction;
         this.eventAction = param1;
         return _loc2_;
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         this.setColor(CSS.overColor);
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         this.setColor(CSS.titleBarColors);
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         Menu.removeMenusFrom(stage);
      }
      
      private function mouseUp(param1:MouseEvent) : void
      {
         if(this.action != null)
         {
            this.action();
         }
         if(this.eventAction != null)
         {
            this.eventAction(param1);
         }
         param1.stopImmediatePropagation();
      }
      
      public function handleTool(param1:String, param2:MouseEvent) : void
      {
         if(param1 == "help" && Boolean(this.tipName))
         {
            Scratch.app.showTip(this.tipName);
         }
      }
      
      private function setColor(param1:*) : void
      {
         this.color = param1;
         if(this.labelOrIcon is TextField)
         {
            (this.labelOrIcon as TextField).textColor = param1 == CSS.overColor ? uint(CSS.white) : uint(CSS.buttonLabelColor);
         }
         this.setMinWidthHeight(5,5);
      }
      
      private function addLabel(param1:String) : void
      {
         var _loc2_:TextField = new TextField();
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.selectable = false;
         _loc2_.background = false;
         _loc2_.defaultTextFormat = CSS.normalTextFormat;
         _loc2_.textColor = CSS.buttonLabelColor;
         _loc2_.text = param1;
         this.labelOrIcon = _loc2_;
         this.setMinWidthHeight(0,0);
         addChild(_loc2_);
      }
   }
}

