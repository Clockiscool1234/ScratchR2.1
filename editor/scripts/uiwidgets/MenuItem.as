package uiwidgets
{
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.*;
   import scratch.BlockMenus;
   import translation.Translator;
   import util.Color;
   
   public class MenuItem extends Sprite
   {
      
      private const leftMargin:int = 22;
      
      private const rightMargin:int = 10;
      
      private const checkmarkColor:int = 15790320;
      
      private var menu:Menu;
      
      private var label:TextField;
      
      private var checkmark:Shape;
      
      private var selection:*;
      
      private var base:Shape;
      
      private var w:int;
      
      private var h:int;
      
      public function MenuItem(param1:Menu, param2:*, param3:*, param4:Boolean)
      {
         super();
         this.menu = param1;
         this.selection = param3 == null ? param2 : param3;
         addChild(this.base = new Shape());
         if(param2 == Menu.line)
         {
            return;
         }
         this.addCheckmark();
         this.addLabel(String(param2),param4);
         this.setBaseColor(param1.color);
         if(param4)
         {
            addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
            addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
            addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         }
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.w = param1;
         this.h = 1;
         if(this.label)
         {
            this.h = Math.max(this.label.height,param2);
            this.label.y = Math.max(0,(this.h - this.label.height) / 2);
         }
         this.setBaseColor(this.menu.color);
      }
      
      public function isLine() : Boolean
      {
         return !this.label;
      }
      
      public function getLabel() : String
      {
         return this.label ? this.label.text : "";
      }
      
      public function showCheckmark(param1:Boolean) : void
      {
         if(this.checkmark)
         {
            this.checkmark.visible = param1;
         }
      }
      
      public function translate(param1:String) : void
      {
         if(Boolean(this.label) && BlockMenus.shouldTranslateItemForMenu(this.label.text,param1))
         {
            this.label.text = Translator.map(this.label.text);
         }
      }
      
      private function addCheckmark() : void
      {
         this.checkmark = new Shape();
         this.drawCheckmark(this.checkmarkColor);
         this.checkmark.x = 6;
         this.checkmark.y = 8;
         this.checkmark.visible = true;
         addChild(this.checkmark);
      }
      
      private function drawCheckmark(param1:int) : void
      {
         var _loc2_:Graphics = this.checkmark.graphics;
         _loc2_.clear();
         _loc2_.beginFill(param1);
         _loc2_.moveTo(0,6);
         _loc2_.lineTo(5,12);
         _loc2_.lineTo(12.5,0.5);
         _loc2_.lineTo(12,0);
         _loc2_.lineTo(5,9);
         _loc2_.lineTo(0,5.5);
         _loc2_.endFill();
      }
      
      private function addLabel(param1:String, param2:Boolean) : void
      {
         this.label = new TextField();
         this.label.autoSize = TextFieldAutoSize.LEFT;
         this.label.selectable = false;
         this.label.defaultTextFormat = new TextFormat(CSS.font,CSS.menuFontSize,CSS.white);
         this.label.text = param1;
         this.label.x = this.leftMargin;
         this.label.y = 0;
         this.label.alpha = param2 ? 1 : 0.5;
         this.w = this.label.width + this.leftMargin + this.rightMargin;
         this.h = Math.max(this.label.height,this.menu.itemHeight);
         addChild(this.label);
         this.setBaseColor(this.menu.color);
      }
      
      private function setHighlight(param1:Boolean) : void
      {
         this.setBaseColor(param1 ? this.selectedColorFrom(this.menu.color) : this.menu.color);
         this.label.textColor = param1 ? uint(this.colorWithBrightness(this.menu.color,0.3)) : uint(CSS.white);
         if(this.checkmark.visible)
         {
            this.drawCheckmark(param1 ? this.colorWithBrightness(this.menu.color,0.5) : this.checkmarkColor);
         }
      }
      
      private function setBaseColor(param1:int) : void
      {
         var _loc2_:Graphics = this.base.graphics;
         _loc2_.clear();
         if(this.label)
         {
            _loc2_.beginFill(param1);
            _loc2_.drawRect(0,0,this.w,this.h);
            _loc2_.endFill();
         }
         else
         {
            _loc2_.beginFill(this.colorWithBrightness(this.menu.color,0.5));
            this.base.graphics.drawRect(0,0,this.w,1);
            _loc2_.endFill();
         }
      }
      
      private function selectedColorFrom(param1:Number) : int
      {
         var _loc2_:Array = Color.rgb2hsv(param1);
         var _loc3_:Number = Number(_loc2_[1]);
         var _loc4_:Number = 0.9;
         if(_loc3_ > 0.5)
         {
            _loc3_ = 0.3;
            _loc4_ = 1;
         }
         return Color.fromHSV(_loc2_[0],_loc3_,_loc4_);
      }
      
      private function colorWithBrightness(param1:Number, param2:Number) : int
      {
         var _loc3_:Array = Color.rgb2hsv(param1);
         return Color.fromHSV(_loc3_[0],_loc3_[1],param2);
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         this.setHighlight(true);
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         this.setHighlight(false);
      }
      
      private function mouseUp(param1:MouseEvent) : void
      {
         this.menu.selected(this.selection);
      }
   }
}

