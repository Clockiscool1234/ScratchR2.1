package ui.parts
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import translation.Translator;
   import uiwidgets.IconButton;
   
   public class TabsPart extends UIPart
   {
      
      private var scriptsTab:IconButton;
      
      private var imagesTab:IconButton;
      
      private var soundsTab:IconButton;
      
      public function TabsPart(param1:Scratch)
      {
         var selectScripts:Function = null;
         var selectImages:Function = null;
         var selectSounds:Function = null;
         var app:Scratch = param1;
         super();
         selectScripts = function(param1:IconButton):void
         {
            app.setTab("scripts");
         };
         selectImages = function(param1:IconButton):void
         {
            app.setTab("images");
         };
         selectSounds = function(param1:IconButton):void
         {
            app.setTab("sounds");
         };
         this.app = app;
         this.scriptsTab = this.makeTab("Scripts",selectScripts);
         this.imagesTab = this.makeTab("Images",selectImages);
         this.soundsTab = this.makeTab("Sounds",selectSounds);
         addChild(this.scriptsTab);
         addChild(this.imagesTab);
         addChild(this.soundsTab);
         this.scriptsTab.turnOn();
      }
      
      public static function strings() : Array
      {
         return ["Scripts","Costumes","Backdrops","Sounds"];
      }
      
      public function refresh() : void
      {
         var _loc1_:String = app.viewedObj() != null && app.viewedObj().isStage ? "Backdrops" : "Costumes";
         this.imagesTab.setImage(this.makeTabImg(_loc1_,true),this.makeTabImg(_loc1_,false));
         this.fixLayout();
      }
      
      public function selectTab(param1:String) : void
      {
         this.scriptsTab.turnOff();
         this.imagesTab.turnOff();
         this.soundsTab.turnOff();
         if(param1 == "scripts")
         {
            this.scriptsTab.turnOn();
         }
         if(param1 == "images")
         {
            this.imagesTab.turnOn();
         }
         if(param1 == "sounds")
         {
            this.soundsTab.turnOn();
         }
      }
      
      public function fixLayout() : void
      {
         this.scriptsTab.x = 0;
         this.scriptsTab.y = 0;
         this.imagesTab.x = this.scriptsTab.x + this.scriptsTab.width + 1;
         this.imagesTab.y = 0;
         this.soundsTab.x = this.imagesTab.x + this.imagesTab.width + 1;
         this.soundsTab.y = 0;
         this.w = this.soundsTab.x + this.soundsTab.width;
         this.h = this.scriptsTab.height;
      }
      
      public function updateTranslation() : void
      {
         this.scriptsTab.setImage(this.makeTabImg("Scripts",true),this.makeTabImg("Scripts",false));
         this.soundsTab.setImage(this.makeTabImg("Sounds",true),this.makeTabImg("Sounds",false));
         this.refresh();
      }
      
      private function makeTab(param1:String, param2:Function) : IconButton
      {
         return new IconButton(param2,this.makeTabImg(param1,true),this.makeTabImg(param1,false),true);
      }
      
      private function makeTabImg(param1:String, param2:Boolean) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         var _loc4_:TextField = new TextField();
         _loc4_.defaultTextFormat = new TextFormat(CSS.font,12,param2 ? CSS.onColor : CSS.offColor,false);
         _loc4_.text = Translator.map(param1);
         _loc4_.width = _loc4_.textWidth + 5;
         _loc4_.height = _loc4_.textHeight + 5;
         _loc4_.x = 10;
         _loc4_.y = 4;
         _loc3_.addChild(_loc4_);
         var _loc5_:Graphics = _loc3_.graphics;
         var _loc6_:int = _loc4_.width + 20;
         var _loc7_:int = 28;
         var _loc8_:int = 9;
         if(param2)
         {
            drawTopBar(_loc5_,CSS.titleBarColors,getTopBarPath(_loc6_,_loc7_),_loc6_,_loc7_);
         }
         else
         {
            drawSelected(_loc5_,[15921906,13750995],getTopBarPath(_loc6_,_loc7_),_loc6_,_loc7_);
         }
         return _loc3_;
      }
   }
}

