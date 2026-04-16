package ui.parts
{
   import flash.display.Bitmap;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import scratch.ScratchObj;
   import scratch.ScratchSprite;
   import ui.BlockPalette;
   import ui.PaletteSelector;
   import uiwidgets.IndicatorLight;
   import uiwidgets.ScriptsPane;
   import uiwidgets.ScrollFrame;
   import uiwidgets.ZoomWidget;
   import util.CachedTimer;
   
   public class ScriptsPart extends UIPart
   {
      
      private var shape:Shape;
      
      private var selector:PaletteSelector;
      
      private var spriteWatermark:Bitmap;
      
      protected var paletteFrame:ScrollFrame;
      
      protected var scriptsFrame:ScrollFrame;
      
      private var zoomWidget:ZoomWidget;
      
      private const readoutLabelFormat:TextFormat = new TextFormat(CSS.font,12,CSS.textColor,true);
      
      private const readoutFormat:TextFormat = new TextFormat(CSS.font,12,CSS.textColor);
      
      private var xyDisplay:Sprite;
      
      private var xLabel:TextField;
      
      private var yLabel:TextField;
      
      private var xReadout:TextField;
      
      private var yReadout:TextField;
      
      private var lastX:int = -10000000;
      
      private var lastY:int = -10000000;
      
      private var lastUpdateTime:uint;
      
      public function ScriptsPart(param1:Scratch)
      {
         super();
         this.app = param1;
         addChild(this.shape = new Shape());
         addChild(this.spriteWatermark = new Bitmap());
         this.addXYDisplay();
         addChild(this.selector = new PaletteSelector(param1));
         var _loc2_:BlockPalette = new BlockPalette();
         _loc2_.color = CSS.tabColor;
         this.paletteFrame = new ScrollFrame();
         this.paletteFrame.allowHorizontalScrollbar = false;
         this.paletteFrame.setContents(_loc2_);
         addChild(this.paletteFrame);
         param1.palette = _loc2_;
         param1.scriptsPane = this.addScriptsPane();
         addChild(this.zoomWidget = new ZoomWidget(param1.scriptsPane));
      }
      
      protected function addScriptsPane() : ScriptsPane
      {
         var _loc1_:ScriptsPane = new ScriptsPane(app);
         this.scriptsFrame = new ScrollFrame();
         this.scriptsFrame.setContents(_loc1_);
         addChild(this.scriptsFrame);
         return _loc1_;
      }
      
      public function resetCategory() : void
      {
         if(Scratch.app.isExtensionDevMode)
         {
            this.selector.select(Specs.myBlocksCategory);
         }
         else
         {
            this.selector.select(Specs.motionCategory);
         }
      }
      
      public function updatePalette() : void
      {
         this.selector.updateTranslation();
         this.selector.select(this.selector.selectedCategory);
      }
      
      public function updateSpriteWatermark() : void
      {
         var _loc1_:ScratchObj = app.viewedObj();
         if(Boolean(_loc1_) && !_loc1_.isStage)
         {
            this.spriteWatermark.bitmapData = _loc1_.currentCostume().thumbnail(40,40,false);
         }
         else
         {
            this.spriteWatermark.bitmapData = null;
         }
      }
      
      public function step() : void
      {
         var _loc2_:ScratchSprite = null;
         var _loc1_:ScratchObj = app.viewedObj();
         if(!_loc1_ || _loc1_.isStage)
         {
            if(this.xyDisplay.visible)
            {
               this.xyDisplay.visible = false;
            }
         }
         else
         {
            if(!this.xyDisplay.visible)
            {
               this.xyDisplay.visible = true;
            }
            _loc2_ = _loc1_ as ScratchSprite;
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.scratchX != this.lastX)
            {
               this.lastX = _loc2_.scratchX;
               this.xReadout.text = String(this.lastX);
            }
            if(_loc2_.scratchY != this.lastY)
            {
               this.lastY = _loc2_.scratchY;
               this.yReadout.text = String(this.lastY);
            }
         }
         this.updateExtensionIndicators();
      }
      
      private function updateExtensionIndicators() : void
      {
         var _loc2_:IndicatorLight = null;
         if(CachedTimer.getCachedTimer() - this.lastUpdateTime < 500)
         {
            return;
         }
         var _loc1_:int = 0;
         while(_loc1_ < app.palette.numChildren)
         {
            _loc2_ = app.palette.getChildAt(_loc1_) as IndicatorLight;
            if(_loc2_)
            {
               app.extensionManager.updateIndicator(_loc2_,_loc2_.target);
            }
            _loc1_++;
         }
         this.lastUpdateTime = CachedTimer.getCachedTimer();
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.w = param1;
         this.h = param2;
         this.fixlayout();
         this.redraw();
      }
      
      private function fixlayout() : void
      {
         if(!app.isMicroworld)
         {
            this.selector.x = 1;
            this.selector.y = 5;
            this.paletteFrame.x = this.selector.x;
            this.paletteFrame.y = this.selector.y + this.selector.height + 2;
            this.paletteFrame.setWidthHeight(this.selector.width + 1,h - this.paletteFrame.y - 2);
            this.scriptsFrame.x = this.selector.x + this.selector.width + 2;
            this.scriptsFrame.y = this.selector.y + 1;
            this.zoomWidget.x = w - this.zoomWidget.width - 15;
            this.zoomWidget.y = h - this.zoomWidget.height - 15;
         }
         else
         {
            this.scriptsFrame.x = 1;
            this.scriptsFrame.y = 1;
            this.selector.visible = false;
            this.paletteFrame.visible = false;
            this.zoomWidget.visible = false;
         }
         this.scriptsFrame.setWidthHeight(w - this.scriptsFrame.x - 5,h - this.scriptsFrame.y - 5);
         this.spriteWatermark.x = w - 60;
         this.spriteWatermark.y = this.scriptsFrame.y + 10;
         this.xyDisplay.x = this.spriteWatermark.x + 1;
         this.xyDisplay.y = this.spriteWatermark.y + 43;
      }
      
      private function redraw() : void
      {
         var _loc1_:int = this.paletteFrame.visibleW();
         var _loc2_:int = this.paletteFrame.visibleH();
         var _loc3_:int = this.scriptsFrame.visibleW();
         var _loc4_:int = this.scriptsFrame.visibleH();
         var _loc5_:Graphics = this.shape.graphics;
         _loc5_.clear();
         _loc5_.lineStyle(1,CSS.borderColor,1,true);
         _loc5_.beginFill(CSS.tabColor);
         _loc5_.drawRect(0,0,w,h);
         _loc5_.endFill();
         var _loc6_:int = this.selector.y + this.selector.height;
         var _loc7_:int = CSS.borderColor - 1315860;
         var _loc8_:int = 15921906;
         if(!app.isMicroworld)
         {
            _loc5_.lineStyle(1,_loc7_,1,true);
            this.hLine(_loc5_,this.paletteFrame.x + 8,_loc6_,_loc1_ - 20);
            _loc5_.lineStyle(1,_loc8_,1,true);
            this.hLine(_loc5_,this.paletteFrame.x + 8,_loc6_ + 1,_loc1_ - 20);
         }
         _loc5_.lineStyle(1,_loc7_,1,true);
         _loc5_.drawRect(this.scriptsFrame.x - 1,this.scriptsFrame.y - 1,_loc3_ + 1,_loc4_ + 1);
      }
      
      private function hLine(param1:Graphics, param2:int, param3:int, param4:int) : void
      {
         param1.moveTo(param2,param3);
         param1.lineTo(param2 + param4,param3);
      }
      
      private function addXYDisplay() : void
      {
         this.xyDisplay = new Sprite();
         this.xyDisplay.addChild(this.xLabel = makeLabel("x:",this.readoutLabelFormat,0,0));
         this.xyDisplay.addChild(this.xReadout = makeLabel("-888",this.readoutFormat,15,0));
         this.xyDisplay.addChild(this.yLabel = makeLabel("y:",this.readoutLabelFormat,0,13));
         this.xyDisplay.addChild(this.yReadout = makeLabel("-888",this.readoutFormat,15,13));
         addChild(this.xyDisplay);
      }
   }
}

