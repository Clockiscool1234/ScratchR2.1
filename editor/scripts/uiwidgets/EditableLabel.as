package uiwidgets
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.filters.BevelFilter;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class EditableLabel extends Sprite
   {
      
      private const defaultFormat:TextFormat = new TextFormat(CSS.font,13,9606295);
      
      private const bgColor:int = 16777215;
      
      private const frameColor:int = 10922155;
      
      public var tf:TextField;
      
      private var bezel:Shape;
      
      private var dynamicBezel:Boolean;
      
      private var textChanged:Function;
      
      public function EditableLabel(param1:Function, param2:TextFormat = null)
      {
         super();
         this.textChanged = param1;
         this.bezel = new Shape();
         addChild(this.bezel);
         this.addFilter();
         if(param2 == null)
         {
            param2 = this.defaultFormat;
         }
         this.addTextField(param2);
         this.setWidth(100);
      }
      
      public function setWidth(param1:int) : void
      {
         if(this.tf.text.length == 0)
         {
            this.tf.text = " ";
         }
         var _loc2_:int = this.tf.textHeight + 5;
         var _loc3_:Graphics = this.bezel.graphics;
         _loc3_.clear();
         _loc3_.lineStyle(0.5,this.frameColor,1,true);
         _loc3_.beginFill(this.bgColor);
         _loc3_.drawRoundRect(0,0,param1,_loc2_,7,7);
         _loc3_.endFill();
         this.tf.width = param1 - 3;
         this.tf.height = _loc2_ - 1;
      }
      
      public function contents() : String
      {
         return this.tf.text;
      }
      
      public function setContents(param1:String) : void
      {
         this.tf.text = param1;
      }
      
      public function setEditable(param1:Boolean) : void
      {
         this.tf.type = param1 ? TextFieldType.INPUT : TextFieldType.DYNAMIC;
         this.tf.selectable = param1;
         this.bezel.visible = param1;
      }
      
      public function useDynamicBezel(param1:Boolean) : void
      {
         this.dynamicBezel = param1;
         this.bezel.visible = !this.dynamicBezel;
      }
      
      private function focusChange(param1:FocusEvent) : void
      {
         if(this.dynamicBezel)
         {
            this.bezel.visible = root.stage.focus == this.tf && this.tf.type == TextFieldType.INPUT;
         }
         if(param1.type == FocusEvent.FOCUS_OUT && this.textChanged != null)
         {
            this.textChanged();
         }
      }
      
      private function keystroke(param1:KeyboardEvent) : void
      {
         var _loc2_:int = int(param1.charCode);
         if(_loc2_ == 10 || _loc2_ == 13)
         {
            stage.focus = null;
            param1.stopPropagation();
         }
      }
      
      private function addTextField(param1:TextFormat) : void
      {
         this.tf = new TextField();
         this.tf.defaultTextFormat = param1;
         this.tf.type = TextFieldType.INPUT;
         var _loc2_:Boolean = false;
         if(_loc2_)
         {
            this.tf.background = true;
            this.tf.backgroundColor = 10526975;
         }
         this.tf.x = 2;
         this.tf.y = 1;
         this.tf.addEventListener(FocusEvent.FOCUS_IN,this.focusChange);
         this.tf.addEventListener(FocusEvent.FOCUS_OUT,this.focusChange);
         this.tf.addEventListener(KeyboardEvent.KEY_DOWN,this.keystroke);
         addChild(this.tf);
      }
      
      private function addFilter() : void
      {
         var _loc1_:BevelFilter = new BevelFilter();
         _loc1_.angle = 225;
         _loc1_.shadowAlpha = 0.5;
         _loc1_.distance = 2;
         _loc1_.strength = 0.5;
         _loc1_.blurX = _loc1_.blurY = 2;
         this.bezel.filters = [_loc1_];
      }
   }
}

