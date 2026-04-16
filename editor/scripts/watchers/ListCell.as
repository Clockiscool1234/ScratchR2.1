package watchers
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   import uiwidgets.IconButton;
   import uiwidgets.ResizeableFrame;
   import util.Color;
   
   public class ListCell extends Sprite
   {
      
      private static var normalColor:int = Specs.listColor;
      
      private static var focusedColor:int = Color.mixRGB(Color.scaleBrightness(Specs.listColor,2),15658734,0.6);
      
      private const format:TextFormat = new TextFormat(CSS.font,11,16777215,true);
      
      public var tf:TextField;
      
      private var frame:ResizeableFrame;
      
      private var deleteButton:IconButton;
      
      private var deleteItem:Function;
      
      public function ListCell(param1:String, param2:int, param3:Function, param4:Function, param5:Function)
      {
         super();
         this.frame = new ResizeableFrame(16777215,normalColor,6,true);
         addChild(this.frame);
         this.addTextField(param3,param4);
         this.tf.text = param1;
         this.deleteButton = new IconButton(param5,"deleteItem");
         this.setWidth(param2);
      }
      
      public function setText(param1:String, param2:int = 0) : void
      {
         this.tf.text = param1;
         this.setWidth(param2 > 0 ? param2 : this.frame.w);
         this.removeDeleteButton();
      }
      
      public function setEditable(param1:Boolean) : void
      {
         this.tf.type = param1 ? "input" : "dynamic";
      }
      
      public function setWidth(param1:int) : void
      {
         var _loc2_:int = 0;
         this.tf.width = Math.max(param1,15);
         _loc2_ = Math.max(this.tf.textHeight + 7,20);
         this.frame.setWidthHeight(this.tf.width,_loc2_);
         this.deleteButton.x = this.tf.width - this.deleteButton.width - 3;
         this.deleteButton.y = (_loc2_ - this.deleteButton.height) / 2;
      }
      
      private function addTextField(param1:Function, param2:Function) : void
      {
         this.tf = new TextField();
         this.tf.type = "input";
         this.tf.wordWrap = true;
         this.tf.autoSize = TextFieldAutoSize.LEFT;
         this.tf.defaultTextFormat = this.format;
         this.tf.x = 3;
         this.tf.y = 1;
         this.tf.tabEnabled = false;
         this.tf.tabIndex = 1;
         this.tf.addEventListener(Event.CHANGE,param1);
         this.tf.addEventListener(KeyboardEvent.KEY_DOWN,param2);
         this.tf.addEventListener(FocusEvent.FOCUS_IN,this.focusChange);
         this.tf.addEventListener(FocusEvent.FOCUS_OUT,this.focusChange);
         addChild(this.tf);
      }
      
      public function select() : void
      {
         stage.focus = this.tf;
         this.tf.setSelection(0,this.tf.text.length);
         if(this.tf.type == "input")
         {
            this.addDeleteButton();
         }
      }
      
      private function focusChange(param1:FocusEvent) : void
      {
         var _loc2_:Boolean = param1.type == FocusEvent.FOCUS_IN && this.tf.type == "input";
         this.frame.setColor(_loc2_ ? focusedColor : normalColor);
         this.tf.textColor = _loc2_ ? 0 : 16777215;
         setTimeout(_loc2_ ? this.addDeleteButton : this.removeDeleteButton,1);
      }
      
      private function removeDeleteButton() : void
      {
         if(this.deleteButton.parent)
         {
            removeChild(this.deleteButton);
         }
      }
      
      private function addDeleteButton() : void
      {
         addChild(this.deleteButton);
         this.deleteButton.turnOff();
      }
   }
}

