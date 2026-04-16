package scratch
{
   import assets.Resources;
   import flash.display.Bitmap;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filters.BevelFilter;
   import flash.filters.BitmapFilterType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   
   public class AskPrompter extends Sprite
   {
      
      private const fontSize:int = 13;
      
      private const outlineColor:int = 4894174;
      
      private const inputFieldColor:int = 15921906;
      
      private var app:Scratch;
      
      private var input:TextField;
      
      private var doneButton:Bitmap;
      
      public function AskPrompter(param1:String, param2:Scratch)
      {
         super();
         this.app = param2;
         var _loc3_:int = 449;
         var _loc4_:int = param1 == "" ? 34 : 51;
         this.addBackground(_loc3_,_loc4_);
         this.addDoneButton(_loc3_,_loc4_);
         this.addPrompt(param1);
         this.addInputField(_loc4_);
         x = 10;
         y = 340 - height;
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(KeyboardEvent.KEY_DOWN,this.keyDown);
      }
      
      public function grabKeyboardFocus() : void
      {
         if(stage)
         {
            stage.focus = this.input;
         }
      }
      
      public function answer() : String
      {
         return this.input.text;
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         if(this.doneButton.hitTestPoint(param1.stageX,param1.stageY))
         {
            this.app.runtime.hideAskPrompt(this);
            param1.stopImmediatePropagation();
         }
      }
      
      private function keyDown(param1:KeyboardEvent) : void
      {
         if(param1.charCode == 13)
         {
            this.app.runtime.hideAskPrompt(this);
         }
      }
      
      private function addBackground(param1:int, param2:int) : void
      {
         var _loc3_:Shape = new Shape();
         _loc3_.graphics.lineStyle(3,this.outlineColor,1,true);
         _loc3_.graphics.beginFill(16777215);
         _loc3_.graphics.drawRoundRect(0,0,param1,param2,13);
         _loc3_.graphics.endFill();
         addChild(_loc3_);
      }
      
      private function addDoneButton(param1:int, param2:int) : void
      {
         this.doneButton = Resources.createBmp("promptCheckButton");
         this.doneButton.x = param1 - 26;
         this.doneButton.y = param2 - 26;
         addChild(this.doneButton);
      }
      
      private function addPrompt(param1:String) : void
      {
         var _loc2_:TextField = null;
         if(param1 == "")
         {
            return;
         }
         _loc2_ = new TextField();
         _loc2_.defaultTextFormat = new TextFormat(CSS.font,this.fontSize - 1,0,true);
         _loc2_.selectable = false;
         _loc2_.text = param1;
         _loc2_.width = 430;
         _loc2_.height = this.fontSize + 5;
         _loc2_.x = 9;
         _loc2_.y = 2;
         addChild(_loc2_);
      }
      
      private function addInputField(param1:int) : void
      {
         this.input = new TextField();
         this.input.defaultTextFormat = new TextFormat(CSS.font,this.fontSize,0,false);
         this.input.type = TextFieldType.INPUT;
         this.input.background = true;
         this.input.backgroundColor = this.inputFieldColor;
         this.input.width = 410;
         this.input.height = 20;
         var _loc2_:BevelFilter = new BevelFilter();
         _loc2_.angle = 225;
         _loc2_.shadowAlpha = 0.6;
         _loc2_.distance = 3;
         _loc2_.strength = 0.4;
         _loc2_.blurX = _loc2_.blurY = 0;
         _loc2_.type = BitmapFilterType.OUTER;
         this.input.filters = [_loc2_];
         this.input.x = 9;
         this.input.y = param1 - (this.input.height + 5);
         addChild(this.input);
      }
   }
}

