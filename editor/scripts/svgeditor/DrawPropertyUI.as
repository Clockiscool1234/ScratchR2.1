package svgeditor
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import svgeditor.tools.BitmapBackgroundTool;
   import translation.Translator;
   import ui.parts.UIPart;
   import uiwidgets.*;
   
   public class DrawPropertyUI extends Sprite
   {
      
      public static const ONCHANGE:String = "onchange";
      
      public static const ONCOLORCHANGE:String = "oncolorchange";
      
      public static const ONFONTCHANGE:String = "onfontchange";
      
      private var editor:ImageEdit;
      
      private var currentValues:DrawProperties;
      
      private var disableEvents:Boolean;
      
      private var strokeWidthDisplay:Shape;
      
      private var strokeWidthSlider:Slider;
      
      private var strokeSmoothnessSlider:Slider;
      
      private var smoothStrokeBtn:Button;
      
      private var eraserStrokeDisplay:Sprite;
      
      private var eraserStrokeMode:Boolean;
      
      private var fillUI:Sprite;
      
      private var fillBtnSolid:IconButton;
      
      private var fillBtnHorizontal:IconButton;
      
      private var fillBtnVertical:IconButton;
      
      private var fillBtnRadial:IconButton;
      
      private var fontLabel:TextField;
      
      private var fontMenuButton:IconButton;
      
      private var shapeUI:Sprite;
      
      private var shapeBtnFill:IconButton;
      
      private var shapeBtnHollow:IconButton;
      
      private var isEllipse:Boolean;
      
      private var smoothnessUI:Sprite;
      
      private var segmentationUI:Sprite;
      
      private var colorPicker:ColorPicker;
      
      private var bg:Shape;
      
      private var zoomButtons:Sprite;
      
      private var modeLabel:TextField;
      
      private var modeButton:Button;
      
      private var sizeLabel:TextField;
      
      private var sizeReadout:TextField;
      
      private var zoomReadout:TextField;
      
      public var w:int;
      
      public var h:int;
      
      public function DrawPropertyUI(param1:ImageEdit)
      {
         super();
         this.editor = param1;
         this.currentValues = new DrawProperties();
         this.disableEvents = false;
         this.eraserStrokeMode = false;
         addChild(this.bg = new Shape());
         addChild(this.colorPicker = new ColorPicker(param1,this));
         this.makeShapeUI();
         this.makeStrokeUI();
         this.makeFillUI();
         this.makeFontUI();
         this.makeSmoothnessUI();
         this.makeZoomButtons();
         this.makeModeLabelAndButton();
         this.makeSegmentationUI();
         this.makeReadouts();
         addEventListener(ONCHANGE,this.updateStrokeWidthDisplay);
         this.updateStrokeWidthDisplay();
      }
      
      public static function strings() : Array
      {
         return ["Smooth","Set Costume Center","Font:","Bitmap Mode","Vector Mode","Convert to bitmap","Convert to vector","Line width","Eraser width"];
      }
      
      public function setWidthHeight(param1:int, param2:int, param3:int = 0, param4:int = 0) : void
      {
         this.w = param1;
         this.h = param2;
         var _loc5_:Graphics = this.bg.graphics;
         _loc5_.clear();
         _loc5_.lineStyle(1,CSS.borderColor);
         _loc5_.beginFill(16185078);
         _loc5_.drawRect(param3,param4,param1 - 1,param2);
         this.fixLayout(param1,param2,param3,param4);
      }
      
      private function fixLayout(param1:int, param2:int, param3:int = 0, param4:int = 0) : void
      {
         this.colorPicker.x = param3 + 105 + Math.max(0,Math.floor((param1 - 390) / 2));
         this.colorPicker.y = param4 + 6;
         this.zoomButtons.x = param3 + param1 - this.zoomButtons.width - 5;
         this.zoomButtons.y = param4 + 5;
         var _loc5_:int = param3 + param1 - 5 - Math.max(this.modeLabel.width,this.modeButton.width) / 2;
         this.modeLabel.x = _loc5_ - this.modeLabel.width / 2;
         this.modeLabel.y = param4 + param2 - 47;
         this.modeButton.x = _loc5_ - this.modeButton.width / 2;
         this.modeButton.y = this.modeLabel.y + 22;
         this.updateZoomReadout();
      }
      
      public function get settings() : DrawProperties
      {
         return this.currentValues;
      }
      
      public function set settings(param1:DrawProperties) : void
      {
         this.currentValues = param1;
         this.colorPicker.pickColor();
         this.strokeWidthSlider.value = this.eraserStrokeMode ? param1.eraserWidth : param1.strokeWidth;
         this.updateStrokeWidthDisplay();
      }
      
      public function getStrokeSmoothness() : Number
      {
         return this.strokeSmoothnessSlider.value;
      }
      
      public function updateUI(param1:DrawProperties) : void
      {
         this.disableEvents = true;
         this.settings = param1;
         this.disableEvents = false;
      }
      
      public function updateZoomReadout() : void
      {
         var _loc1_:int = Math.floor(100 * this.editor.getZoomAndScroll()[0]);
         this.zoomReadout.text = _loc1_ + "%";
         this.zoomReadout.x = this.zoomButtons.x + (this.zoomButtons.width - this.zoomReadout.textWidth) / 2;
         this.zoomReadout.y = this.zoomButtons.y + this.zoomButtons.height + 3;
      }
      
      public function setCurrentColor(param1:uint, param2:Number) : void
      {
         this.colorPicker.setCurrentColor(param1,param2);
      }
      
      public function toggleFillUI(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:IconButton = null;
         this.fillUI.visible = param1;
         this.eraserStrokeDisplay.visible = !param1 && this.eraserStrokeMode;
         this.strokeWidthDisplay.visible = !param1 && !this.eraserStrokeMode;
         this.strokeWidthSlider.visible = !param1;
         if(param1)
         {
            this.updateFillUI();
            _loc2_ = 0;
            while(_loc2_ < this.fillUI.numChildren)
            {
               if(this.fillUI.getChildAt(_loc2_) is IconButton)
               {
                  _loc3_ = this.fillUI.getChildAt(_loc2_) as IconButton;
                  _loc3_.setOn(_loc3_.name == this.settings.fillType);
               }
               _loc2_++;
            }
         }
      }
      
      public function toggleShapeUI(param1:Boolean, param2:Boolean = false) : void
      {
         this.shapeUI.visible = param1;
         this.isEllipse = param2;
         this.updateShapeUI();
         this.shapeBtnFill.setOn(this.currentValues.filledShape);
         this.shapeBtnHollow.setOn(!this.currentValues.filledShape);
      }
      
      public function toggleSegmentationUI(param1:Boolean, param2:BitmapBackgroundTool) : void
      {
         if(Boolean(param2) && param1)
         {
            param2.removeEventListener(BitmapBackgroundTool.UPDATE_REQUIRED,this.updateSegmentationUI);
            param2.addEventListener(BitmapBackgroundTool.UPDATE_REQUIRED,this.updateSegmentationUI,false,0,true);
         }
         if(Boolean(param2) && !param1)
         {
            param2.removeEventListener(BitmapBackgroundTool.UPDATE_REQUIRED,this.updateSegmentationUI);
         }
         this.segmentationUI.visible = param1;
         this.colorPicker.visible = !param1;
      }
      
      public function showSmoothnessUI(param1:Boolean, param2:Boolean = true) : void
      {
         this.smoothnessUI.visible = param1;
         if(param1)
         {
            this.smoothStrokeBtn.visible = !param2;
         }
      }
      
      public function showColorUI(param1:Boolean) : void
      {
         this.colorPicker.visible = param1;
      }
      
      public function showStrokeUI(param1:Boolean, param2:Boolean) : void
      {
         this.eraserStrokeDisplay.visible = param2;
         this.eraserStrokeMode = param2;
         this.strokeWidthDisplay.visible = param1;
         this.strokeWidthSlider.visible = param1 || param2;
         this.disableEvents = true;
         SimpleTooltips.add(this.strokeWidthSlider.parent,{
            "text":(param2 ? "Eraser width" : "Line width"),
            "direction":"top"
         });
         this.strokeWidthSlider.value = param2 ? this.currentValues.eraserWidth : this.currentValues.strokeWidth;
         this.disableEvents = false;
         this.updateStrokeWidthDisplay();
      }
      
      public function sendChangeEvent() : void
      {
         if(!this.disableEvents)
         {
            dispatchEvent(new Event(ONCHANGE));
         }
         if(this.fillUI.visible)
         {
            this.updateFillUI();
         }
         if(this.shapeUI.visible)
         {
            this.updateShapeUI();
         }
      }
      
      public function onColorChange() : void
      {
         this.sendChangeEvent();
         dispatchEvent(new Event(ONCOLORCHANGE));
      }
      
      private function makeFillUI() : void
      {
         this.fillUI = new Sprite();
         this.fillBtnSolid = new IconButton(this.setFillStyle,null,null,true);
         this.fillBtnSolid.name = "solid";
         this.fillBtnSolid.setOn(true);
         this.fillUI.addChild(this.fillBtnSolid);
         this.fillBtnHorizontal = new IconButton(this.setFillStyle,null,null,true);
         this.fillBtnHorizontal.name = "linearHorizontal";
         this.fillBtnHorizontal.x = 42;
         this.fillUI.addChild(this.fillBtnHorizontal);
         this.fillBtnVertical = new IconButton(this.setFillStyle,null,null,true);
         this.fillBtnVertical.name = "linearVertical";
         this.fillBtnVertical.y = 31;
         this.fillUI.addChild(this.fillBtnVertical);
         this.fillBtnRadial = new IconButton(this.setFillStyle,null,null,true);
         this.fillBtnRadial.name = "radial";
         this.fillBtnRadial.x = 42;
         this.fillBtnRadial.y = 31;
         this.fillUI.addChild(this.fillBtnRadial);
         this.fillUI.x = 15;
         this.fillUI.y = 15;
         this.fillUI.visible = false;
         this.updateFillUI();
         addChild(this.fillUI);
      }
      
      private function updateFillUI() : void
      {
         this.fillBtnSolid.setImage(this.makeFillIcon("solid",true),this.makeFillIcon("solid",false));
         this.fillBtnHorizontal.setImage(this.makeFillIcon("linearHorizontal",true),this.makeFillIcon("linearHorizontal",false));
         this.fillBtnVertical.setImage(this.makeFillIcon("linearVertical",true),this.makeFillIcon("linearVertical",false));
         this.fillBtnRadial.setImage(this.makeFillIcon("radial",true),this.makeFillIcon("radial",false));
      }
      
      private function makeFillIcon(param1:String, param2:Boolean) : Sprite
      {
         var _loc3_:Point = new Point(37,25);
         var _loc4_:int = 29;
         var _loc5_:int = 17;
         var _loc6_:Array = [this.currentValues.color,this.currentValues.secondColor];
         if(this.currentValues.alpha < 1)
         {
            _loc6_[0] = 16777215;
         }
         if(this.currentValues.secondAlpha < 1)
         {
            _loc6_[1] = 16777215;
         }
         var _loc7_:Shape = new Shape();
         var _loc8_:Matrix = new Matrix();
         var _loc9_:Graphics = _loc7_.graphics;
         switch(param1)
         {
            case "linearHorizontal":
               _loc8_.createGradientBox(_loc4_,_loc5_,0,0,0);
               _loc9_.beginGradientFill(GradientType.LINEAR,_loc6_,[1,1],[0,255],_loc8_);
               break;
            case "linearVertical":
               _loc8_.createGradientBox(_loc4_,_loc5_,Math.PI / 2,0,0);
               _loc9_.beginGradientFill(GradientType.LINEAR,_loc6_,[1,1],[0,255],_loc8_);
               break;
            case "radial":
               _loc8_.createGradientBox(_loc4_,_loc5_);
               _loc9_.beginGradientFill(GradientType.RADIAL,_loc6_,[1,1],[0,255],_loc8_);
               break;
            case "hollow":
               _loc9_.lineStyle(4,_loc6_[0]);
            case "solid":
            default:
               _loc9_.beginFill(_loc6_[0]);
         }
         _loc9_.drawRect(0,0,_loc4_,_loc5_);
         return ImageEdit.buttonFrame(_loc7_,param2,_loc3_);
      }
      
      private function makeFontUI() : void
      {
         var fontMenu:Function = null;
         var fontSelected:Function = null;
         fontMenu = function():void
         {
            var _loc1_:Menu = new Menu(fontSelected);
            _loc1_.itemHeight = 20;
            _loc1_.addItem("Donegal");
            _loc1_.addItem("Gloria");
            _loc1_.addItem("Helvetica");
            _loc1_.addItem("Marker");
            _loc1_.addItem("Mystery");
            _loc1_.addItem("Scratch");
            _loc1_.showOnStage(Scratch.app.stage);
         };
         fontSelected = function(param1:String):void
         {
            updateFontUI(param1);
            currentValues.fontName = param1;
            if(!disableEvents)
            {
               dispatchEvent(new Event(ONFONTCHANGE));
            }
         };
         var fmt:TextFormat = new TextFormat(CSS.font,14,CSS.textColor,true);
         addChild(this.fontLabel = Resources.makeLabel(Translator.map("Font:"),fmt,8,8));
         addChild(this.fontMenuButton = UIPart.makeMenuButton("Hevetica",fontMenu,true,CSS.textColor));
         this.fontMenuButton.x = 12;
         this.fontMenuButton.y = 30;
      }
      
      public function showFontUI(param1:Boolean) : void
      {
         this.fontLabel.visible = param1;
         this.fontMenuButton.visible = param1;
         if(param1)
         {
            this.updateFontUI(this.currentValues.fontName);
         }
      }
      
      public function updateFontUI(param1:String) : void
      {
         var _loc2_:Sprite = UIPart.makeButtonLabel(param1,CSS.buttonLabelOverColor,true);
         var _loc3_:Sprite = UIPart.makeButtonLabel(param1,CSS.textColor,true);
         this.fontMenuButton.setImage(_loc2_,_loc3_);
         this.currentValues.fontName = param1;
      }
      
      public function updateTranslation() : void
      {
         this.fontLabel.text = Translator.map("Font:");
         this.smoothStrokeBtn.setLabel(Translator.map("Smooth"));
         this.modeLabel.text = Translator.map(this.editor is SVGEdit ? "Vector Mode" : "Bitmap Mode");
         this.modeButton.setLabel(Translator.map(this.editor is SVGEdit ? "Convert to bitmap" : "Convert to vector"));
         SimpleTooltips.add(this.strokeWidthSlider.parent,{
            "text":(this.eraserStrokeMode ? "Eraser width" : "Line width"),
            "direction":"top"
         });
         this.fixLayout(this.w,this.h);
      }
      
      private function makeShapeUI() : void
      {
         this.shapeUI = new Sprite();
         this.shapeBtnFill = new IconButton(this.setShapeStyle,null,null,true);
         this.shapeBtnFill.x = 40;
         this.shapeBtnFill.name = "filled";
         this.shapeUI.addChild(this.shapeBtnFill);
         this.shapeBtnHollow = new IconButton(this.setShapeStyle,null,null,true);
         this.shapeBtnHollow.name = "hollow";
         this.shapeBtnHollow.setOn(true);
         this.shapeUI.addChild(this.shapeBtnHollow);
         this.shapeUI.x = 15;
         this.shapeUI.y = 15;
         this.shapeUI.visible = false;
         this.updateShapeUI();
         addChild(this.shapeUI);
      }
      
      private function updateShapeUI(param1:* = null) : void
      {
         this.shapeBtnFill.setImage(this.makeShapeIcon("solid",true),this.makeShapeIcon("solid",false));
         this.shapeBtnHollow.setImage(this.makeShapeIcon("hollow",true),this.makeShapeIcon("hollow",false));
      }
      
      private function makeShapeIcon(param1:String, param2:Boolean) : Sprite
      {
         var _loc3_:Point = new Point(37,25);
         var _loc4_:int = 29;
         var _loc5_:int = 17;
         var _loc6_:int = 3;
         var _loc7_:Shape = new Shape();
         var _loc8_:Graphics = _loc7_.graphics;
         if("hollow" == param1)
         {
            _loc8_.lineStyle(_loc6_,this.currentValues.color);
         }
         else
         {
            _loc8_.beginFill(this.currentValues.color);
         }
         var _loc9_:Number = "hollow" == param1 ? _loc6_ / 2 : 0;
         if(this.isEllipse)
         {
            _loc8_.drawEllipse(_loc9_,_loc9_,_loc4_,_loc5_);
         }
         else
         {
            _loc8_.drawRect(_loc9_,_loc9_,_loc4_,_loc5_);
         }
         return ImageEdit.buttonFrame(_loc7_,param2,_loc3_);
      }
      
      private function setShapeStyle(param1:IconButton) : void
      {
         this.currentValues.filledShape = param1.name == "filled";
         if(!this.currentValues.filledShape && this.currentValues.strokeWidth == 0)
         {
            this.currentValues.strokeWidth = 2;
         }
      }
      
      private function setFillStyle(param1:IconButton) : void
      {
         this.currentValues.fillType = param1.name;
      }
      
      private function makeSmoothnessUI() : void
      {
         var smoothStroke:Function = null;
         var updateSmoothness:Function = null;
         smoothStroke = function():void
         {
            (editor as SVGEdit).smoothStroke();
         };
         updateSmoothness = function(param1:Number):void
         {
            currentValues.smoothness = param1;
         };
         this.smoothnessUI = new Sprite();
         this.smoothnessUI.x = 10;
         this.smoothnessUI.y = 10;
         this.smoothnessUI.visible = false;
         this.smoothStrokeBtn = new Button(Translator.map("Smooth"),smoothStroke);
         this.smoothStrokeBtn.x = 22;
         this.smoothnessUI.addChild(this.smoothStrokeBtn);
         this.strokeSmoothnessSlider = new Slider(100,6,updateSmoothness);
         this.strokeSmoothnessSlider.min = 0.1;
         this.strokeSmoothnessSlider.max = 40;
         this.strokeSmoothnessSlider.value = 1;
         this.strokeSmoothnessSlider.y = 25;
         this.strokeSmoothnessSlider.visible = false;
         this.smoothnessUI.addChild(this.strokeSmoothnessSlider);
         addChild(this.smoothnessUI);
      }
      
      private function makeSegmentationUI() : void
      {
         var segmentationLabel:TextField = null;
         var segmentationHelpLabel:TextField = null;
         var segmentationHelpBtn:IconButton = null;
         var showTip:Function = null;
         showTip = function(param1:IconButton):void
         {
            editor.app.showTip("magicwand");
         };
         this.segmentationUI = new Sprite();
         this.segmentationUI.visible = false;
         segmentationLabel = Resources.makeLabel("Magic Wand - Remove background from a photo",CSS.titleFormat,10,10);
         this.segmentationUI.addChild(segmentationLabel);
         segmentationHelpLabel = Resources.makeLabel("Find out more",CSS.projectInfoFormat,5,5);
         segmentationHelpLabel.x = segmentationLabel.x;
         segmentationHelpLabel.y = this.height / 2 - segmentationHelpLabel.height / 2;
         this.segmentationUI.addChild(segmentationHelpLabel);
         segmentationHelpBtn = new IconButton(showTip,"moreInfo");
         segmentationHelpBtn.isMomentary = true;
         segmentationHelpBtn.x = segmentationHelpLabel.x + segmentationHelpLabel.width + 2;
         segmentationHelpBtn.y = segmentationHelpLabel.y + segmentationHelpLabel.height / 2 - segmentationHelpBtn.height / 2;
         this.segmentationUI.addChild(segmentationHelpBtn);
         addChild(this.segmentationUI);
      }
      
      private function makeStrokeUI() : void
      {
         var r:Rectangle;
         var updateStrokeWidth:Function = null;
         updateStrokeWidth = function(param1:Number):void
         {
            if(eraserStrokeMode)
            {
               currentValues.eraserWidth = param1;
            }
            else
            {
               currentValues.strokeWidth = param1;
            }
            updateStrokeWidthDisplay();
            sendChangeEvent();
         };
         var ttBg:Sprite = new Sprite();
         addChild(ttBg);
         this.strokeWidthSlider = new Slider(85,6,updateStrokeWidth);
         this.strokeWidthSlider.min = 0.1;
         this.strokeWidthSlider.max = 15;
         this.strokeWidthSlider.value = 2;
         this.strokeWidthSlider.x = 10;
         this.strokeWidthSlider.y = 90;
         ttBg.addChild(this.strokeWidthSlider);
         this.strokeWidthDisplay = new Shape();
         this.strokeWidthDisplay.x = this.strokeWidthSlider.x + 10;
         this.strokeWidthDisplay.y = 65;
         ttBg.addChild(this.strokeWidthDisplay);
         this.eraserStrokeDisplay = new Sprite();
         this.eraserStrokeDisplay.visible = false;
         this.eraserStrokeDisplay.x = this.strokeWidthDisplay.x - 7;
         this.eraserStrokeDisplay.y = this.strokeWidthDisplay.y - 20;
         ttBg.addChild(this.eraserStrokeDisplay);
         this.updateStrokeWidthDisplay();
         r = ttBg.getBounds(ttBg);
         ttBg.graphics.beginFill(16711680,0);
         ttBg.graphics.drawRect(r.x,r.y,r.width,r.height);
         ttBg.graphics.endFill();
      }
      
      private function updateSegmentationUI(param1:Event = null) : void
      {
         if(Boolean(this.editor) && Boolean(this.editor.imagesPart))
         {
            this.editor.imagesPart.refreshUndoButtons();
         }
      }
      
      private function updateStrokeWidthDisplay(param1:* = null) : void
      {
         var _loc3_:Graphics = null;
         var _loc4_:Matrix = null;
         var _loc2_:Number = this.eraserStrokeMode ? this.currentValues.eraserWidth : this.currentValues.strokeWidth;
         if(this.editor is BitmapEdit)
         {
            if(19 == _loc2_)
            {
               _loc2_ = 17;
            }
            if(29 == _loc2_)
            {
               _loc2_ = 20;
            }
            else if(47 == _loc2_)
            {
               _loc2_ = 25;
            }
            else if(75 == _loc2_)
            {
               _loc2_ = 30;
            }
            else
            {
               _loc2_ += 1;
            }
         }
         if(this.eraserStrokeMode)
         {
            _loc3_ = this.eraserStrokeDisplay.graphics;
            _loc3_.clear();
            _loc3_.lineStyle(1,0,1);
            _loc4_ = new Matrix();
            _loc4_.scale(0.25,0.25);
            _loc3_.beginBitmapFill(Resources.createBmp("canvasGrid").bitmapData,_loc4_);
            _loc3_.drawCircle(40,0,_loc2_);
            _loc3_.endFill();
         }
         else
         {
            _loc3_ = this.strokeWidthDisplay.graphics;
            _loc3_.clear();
            _loc3_.lineStyle(_loc2_,this.currentValues.color,this.currentValues.alpha);
            _loc3_.moveTo(0,0);
            _loc3_.lineTo(65,0);
            this.strokeWidthDisplay.filters = this.currentValues.alpha == 0 ? [new GlowFilter(2663898)] : [];
         }
         this.updateStrokeReadout();
      }
      
      private function updateStrokeReadout() : void
      {
      }
      
      private function makeZoomButtons() : void
      {
         var _loc3_:String = null;
         var _loc4_:IconButton = null;
         addChild(this.zoomButtons = new Sprite());
         var _loc1_:Array = ["zoomOut","noZoom","zoomIn"];
         var _loc2_:int = 0;
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = new IconButton(this.editor.handleImmediateTool,Resources.createBmp(_loc3_ + "On"),Resources.createBmp(_loc3_ + "Off"),false);
            _loc4_.isRadioButton = true;
            _loc4_.name = name;
            _loc4_.x = _loc2_;
            _loc2_ += _loc4_.width;
            this.editor.registerToolButton(_loc3_,_loc4_);
            this.zoomButtons.addChild(_loc4_);
         }
      }
      
      private function makeModeLabelAndButton() : void
      {
         var convertToBitmap:Function = null;
         var convertToVector:Function = null;
         convertToBitmap = function():void
         {
            editor.imagesPart.convertToBitmap();
         };
         convertToVector = function():void
         {
            editor.imagesPart.convertToVector();
         };
         this.modeLabel = Resources.makeLabel(Translator.map(this.editor is SVGEdit ? "Vector Mode" : "Bitmap Mode"),CSS.titleFormat,0,71);
         addChild(this.modeLabel);
         this.modeButton = this.editor is SVGEdit ? new Button(Translator.map("Convert to bitmap"),convertToBitmap,true) : new Button(Translator.map("Convert to vector"),convertToVector,true);
         addChild(this.modeButton);
      }
      
      private function makeReadouts() : void
      {
         addChild(this.sizeLabel = Resources.makeLabel("",CSS.normalTextFormat,0,0));
         addChild(this.sizeReadout = Resources.makeLabel("",CSS.normalTextFormat,0,0));
         addChild(this.zoomReadout = Resources.makeLabel("",CSS.normalTextFormat,0,0));
      }
   }
}

