package watchers
{
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import uiwidgets.ResizeableFrame;
   
   public class WatcherReadout extends Sprite
   {
      
      private var smallFont:TextFormat = new TextFormat(CSS.font,10,16777215,true);
      
      private var largeFont:TextFormat = new TextFormat(CSS.font,15,16777215,true);
      
      private var frame:ResizeableFrame;
      
      private var tf:TextField;
      
      private var isLarge:Boolean;
      
      public function WatcherReadout()
      {
         super();
         this.frame = new ResizeableFrame(16777215,Specs.variableColor,8,true);
         addChild(this.frame);
         this.addTextField();
         this.beLarge(false);
      }
      
      public function getColor() : int
      {
         return this.frame.getColor();
      }
      
      public function setColor(param1:int) : void
      {
         this.frame.setColor(param1);
      }
      
      public function get contents() : String
      {
         return this.tf.text;
      }
      
      public function setContents(param1:String) : void
      {
         if(param1 == this.tf.text)
         {
            return;
         }
         this.tf.text = param1;
         this.fixLayout();
      }
      
      public function beLarge(param1:Boolean) : void
      {
         this.isLarge = param1;
         var _loc2_:TextFormat = this.isLarge ? this.largeFont : this.smallFont;
         _loc2_.align = TextFormatAlign.CENTER;
         this.tf.defaultTextFormat = _loc2_;
         this.tf.setTextFormat(_loc2_);
         this.fixLayout();
      }
      
      private function fixLayout() : void
      {
         var _loc1_:int = this.isLarge ? 48 : 40;
         var _loc2_:int = this.isLarge ? 20 : 14;
         var _loc3_:int = this.isLarge ? 12 : 5;
         _loc1_ = Math.max(_loc1_,this.tf.textWidth + _loc3_);
         this.tf.width = _loc1_;
         this.tf.height = _loc2_;
         this.tf.y = this.isLarge ? 0 : -1;
         if(_loc1_ != this.frame.w || _loc2_ != this.frame.h)
         {
            this.frame.setWidthHeight(_loc1_,_loc2_);
         }
      }
      
      private function addTextField() : void
      {
         this.tf = new TextField();
         this.tf.type = "dynamic";
         this.tf.selectable = false;
         addChild(this.tf);
      }
   }
}

