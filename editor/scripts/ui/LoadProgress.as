package ui
{
   import assets.Resources;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.filters.DropShadowFilter;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import translation.Translator;
   
   public class LoadProgress extends Sprite
   {
      
      private const titleFormat:TextFormat = new TextFormat(CSS.font,18,CSS.textColor);
      
      private const infoFormat:TextFormat = new TextFormat(CSS.font,12,CSS.textColor);
      
      private const grooveColor:int = 12172221;
      
      private var bkg:Shape;
      
      private var titleField:TextField;
      
      private var infoField:TextField;
      
      private var groove:Shape;
      
      private var progressBar:Shape;
      
      public function LoadProgress()
      {
         super();
         this.addBackground(310,120);
         addChild(this.titleField = Resources.makeLabel("",this.titleFormat,20,this.bkg.height - 61));
         addChild(this.infoField = Resources.makeLabel("",this.infoFormat,20,this.bkg.height - 35));
         addChild(this.groove = new Shape());
         addChild(this.progressBar = new Shape());
         this.groove.x = this.progressBar.x = 30;
         this.groove.y = this.progressBar.y = 25;
         this.drawBar(this.groove.graphics,this.grooveColor,250,22);
      }
      
      public function getTitle() : String
      {
         return this.titleField.text;
      }
      
      public function setTitle(param1:String) : void
      {
         this.titleField.text = Translator.map(param1);
         this.titleField.x = (this.bkg.width - this.titleField.textWidth) / 2;
         this.infoField.text = "";
      }
      
      public function setInfo(param1:String) : void
      {
         this.infoField.text = Translator.map(param1);
         this.infoField.x = (this.bkg.width - this.infoField.textWidth) / 2;
      }
      
      public function setProgress(param1:Number) : void
      {
         this.drawBar(this.progressBar.graphics,CSS.overColor,Math.floor(this.groove.width * param1),this.groove.height);
      }
      
      private function addBackground(param1:int, param2:int) : void
      {
         addChild(this.bkg = new Shape());
         var _loc3_:Graphics = this.bkg.graphics;
         _loc3_.clear();
         _loc3_.lineStyle(1,CSS.borderColor,1,true);
         _loc3_.beginFill(16777215);
         _loc3_.drawRoundRect(0,0,param1,param2,24,24);
         _loc3_.endFill();
         var _loc4_:DropShadowFilter = new DropShadowFilter();
         _loc4_.blurX = _loc4_.blurY = 8;
         _loc4_.distance = 5;
         _loc4_.alpha = 0.75;
         _loc4_.color = 3355443;
         this.bkg.filters = [_loc4_];
      }
      
      private function drawBar(param1:Graphics, param2:uint, param3:int, param4:int) : void
      {
         var _loc5_:int = param4 / 2;
         param1.clear();
         param1.beginFill(param2);
         param1.drawRoundRect(0,0,param3,param4,_loc5_,_loc5_);
         param1.endFill();
      }
   }
}

