package uiwidgets
{
   import assets.Resources;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.text.TextField;
   import translation.Translator;
   
   public class VariableSettings extends Sprite
   {
      
      public var isLocal:Boolean;
      
      public var isList:Boolean;
      
      private var isStage:Boolean;
      
      protected var globalButton:IconButton;
      
      private var globalLabel:TextField;
      
      protected var localButton:IconButton;
      
      protected var localLabel:TextField;
      
      public function VariableSettings(param1:Boolean, param2:Boolean)
      {
         super();
         this.isList = param1;
         this.isStage = param2;
         this.addLabels();
         this.addButtons();
         this.fixLayout();
         this.updateButtons();
      }
      
      public static function strings() : Array
      {
         return ["For this sprite only","For all sprites","list","variable"];
      }
      
      protected function addLabels() : void
      {
         addChild(this.localLabel = Resources.makeLabel(Translator.map("For this sprite only"),CSS.normalTextFormat));
         addChild(this.globalLabel = Resources.makeLabel(Translator.map("For all sprites"),CSS.normalTextFormat));
      }
      
      protected function addButtons() : void
      {
         var setLocal:Function = null;
         var setGlobal:Function = null;
         setLocal = function(param1:IconButton):void
         {
            isLocal = true;
            updateButtons();
         };
         setGlobal = function(param1:IconButton):void
         {
            isLocal = false;
            updateButtons();
         };
         addChild(this.localButton = new IconButton(setLocal,null));
         addChild(this.globalButton = new IconButton(setGlobal,null));
      }
      
      protected function updateButtons() : void
      {
         this.localButton.setOn(this.isLocal);
         this.localButton.setDisabled(false,0.2);
         this.localLabel.alpha = 1;
         this.globalButton.setOn(!this.isLocal);
      }
      
      protected function fixLayout() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         _loc1_ = 0;
         _loc2_ = 10;
         this.globalButton.x = _loc1_;
         this.globalButton.y = _loc2_ + 3;
         this.globalLabel.x = _loc1_ = _loc1_ + 16;
         this.globalLabel.y = _loc2_;
         _loc1_ += this.globalLabel.textWidth + 20;
         this.localButton.x = _loc1_;
         this.localButton.y = _loc2_ + 3;
         this.localLabel.x = _loc1_ = _loc1_ + 16;
         this.localLabel.y = _loc2_;
         _loc1_ = 15;
         if(this.isStage)
         {
            this.localButton.visible = false;
            this.localLabel.visible = false;
            this.globalButton.x = _loc1_;
            this.globalLabel.x = _loc1_ + 16;
         }
      }
      
      protected function drawLine() : void
      {
         var _loc1_:int = 36;
         var _loc2_:int = getRect(this).width;
         if(this.isStage)
         {
            _loc2_ += 10;
         }
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         _loc3_.beginFill(13684944);
         _loc3_.drawRect(0,_loc1_,_loc2_,1);
         _loc3_.beginFill(9474192);
         _loc3_.drawRect(0,_loc1_ + 1,_loc2_,1);
         _loc3_.endFill();
      }
   }
}

