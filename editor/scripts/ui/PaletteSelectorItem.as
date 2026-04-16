package ui
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   
   public class PaletteSelectorItem extends Sprite
   {
      
      public var categoryID:int;
      
      public var label:TextField;
      
      public var isSelected:Boolean;
      
      private var color:uint;
      
      public function PaletteSelectorItem(param1:int, param2:String, param3:uint)
      {
         super();
         this.categoryID = param1;
         this.addLabel(param2);
         this.color = param3;
         this.setSelected(false);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOut);
         addEventListener(MouseEvent.CLICK,this.mouseUp);
      }
      
      private function addLabel(param1:String) : void
      {
         this.label = new TextField();
         this.label.autoSize = TextFieldAutoSize.LEFT;
         this.label.selectable = false;
         this.label.text = param1;
         addChild(this.label);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         var _loc2_:int = 100;
         var _loc3_:int = this.label.height + 2;
         var _loc4_:int = 8;
         var _loc5_:int = 7;
         this.isSelected = param1;
         var _loc6_:TextFormat = new TextFormat(CSS.font,12,this.isSelected ? CSS.white : CSS.offColor,this.isSelected);
         this.label.setTextFormat(_loc6_);
         this.label.x = 17;
         this.label.y = 1;
         var _loc7_:Graphics = this.graphics;
         _loc7_.clear();
         _loc7_.beginFill(65280,0);
         _loc7_.drawRect(0,0,_loc2_,_loc3_);
         _loc7_.endFill();
         _loc7_.beginFill(this.color);
         _loc7_.drawRect(_loc4_,1,this.isSelected ? _loc2_ - _loc4_ - 1 : _loc5_,_loc3_ - 2);
         _loc7_.endFill();
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         this.label.textColor = this.isSelected ? uint(CSS.white) : uint(CSS.buttonLabelOverColor);
      }
      
      private function mouseOut(param1:MouseEvent) : void
      {
         this.label.textColor = this.isSelected ? uint(CSS.white) : uint(CSS.offColor);
      }
      
      private function mouseUp(param1:MouseEvent) : void
      {
         if(parent is PaletteSelector)
         {
            PaletteSelector(parent).select(this.categoryID,param1.shiftKey);
         }
      }
   }
}

