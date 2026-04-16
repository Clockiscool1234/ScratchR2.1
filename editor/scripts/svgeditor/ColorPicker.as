package svgeditor
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.utils.Dictionary;
   import uiwidgets.*;
   import util.Color;
   
   public class ColorPicker extends Sprite
   {
      
      private var editor:ImageEdit;
      
      private var drawPropsUI:DrawPropertyUI;
      
      private var gradientMode:Boolean;
      
      private var palette:Sprite;
      
      private var wheelSelector:Shape;
      
      private var hsvColorPicker:Sprite;
      
      private var paletteSwitchButton:Sprite;
      
      private var primaryColorSwatch:Sprite;
      
      private var secondaryColorSwatch:Sprite;
      
      private var paletteDict:Dictionary;
      
      private var paletteReverseDict:Dictionary;
      
      private var selectedColor:Sprite;
      
      private var transparentColor:Sprite;
      
      private const swatchSize:int = 25;
      
      private const paletteSwatchW:int = 12;
      
      private const paletteSwatchH:int = 12;
      
      public function ColorPicker(param1:ImageEdit, param2:DrawPropertyUI)
      {
         super();
         this.editor = param1;
         this.drawPropsUI = param2;
         this.makeColorSwatches();
         this.makeEyeDropperButton();
         this.makeColorPalette();
         this.makeColorWheel();
         this.makePaletteSwitchButton();
         this.pickColor();
      }
      
      public static function strings() : Array
      {
         return ["Pick up color"];
      }
      
      private function makeEyeDropperButton() : void
      {
         var selectEyedropper:Function = null;
         var ib:IconButton = null;
         selectEyedropper = function(param1:IconButton):void
         {
            editor.setToolMode(param1.name);
            if(Boolean(param1) && Boolean(param1.lastEvent))
            {
               param1.lastEvent.stopPropagation();
            }
         };
         ib = new IconButton(selectEyedropper,ImageEdit.makeToolButton("eyedropper",true),ImageEdit.makeToolButton("eyedropper",false),true);
         this.editor.registerToolButton("eyedropper",ib);
         ib.x = this.primaryColorSwatch.x + 163;
         ib.y = 0;
         addChild(ib);
         SimpleTooltips.add(ib,{
            "text":"Pick up color",
            "direction":"top"
         });
      }
      
      private function makePaletteSwitchButton() : void
      {
         this.paletteSwitchButton = new Sprite();
         var _loc1_:Sprite = new Sprite();
         var _loc2_:Bitmap = Resources.createBmp("rainbowButton");
         _loc1_.addChild(_loc2_);
         this.paletteSwitchButton.addChild(_loc1_);
         _loc1_ = new Sprite();
         _loc2_ = Resources.createBmp("swatchButton");
         _loc1_.visible = false;
         _loc1_.addChild(_loc2_);
         this.paletteSwitchButton.addChild(_loc1_);
         this.paletteSwitchButton.addEventListener(MouseEvent.CLICK,this.switchPalettes);
         this.paletteSwitchButton.x = this.primaryColorSwatch.x;
         this.paletteSwitchButton.y = 64;
         addChild(this.paletteSwitchButton);
      }
      
      private function switchPalettes(param1:MouseEvent) : void
      {
         this.palette.visible = !this.palette.visible;
         this.hsvColorPicker.visible = !this.palette.visible;
         this.paletteSwitchButton.getChildAt(0).visible = this.palette.visible;
         this.paletteSwitchButton.getChildAt(1).visible = !this.palette.visible;
         if(this.hsvColorPicker.visible)
         {
         }
         SimpleTooltips.hideAll();
      }
      
      private function makeColorSwatches() : void
      {
         var swapColors:Function = null;
         swapColors = function(param1:*):void
         {
            var _loc2_:DrawProperties = drawPropsUI.settings;
            var _loc3_:int = int(_loc2_.rawColor);
            _loc2_.rawColor = _loc2_.rawSecondColor;
            _loc2_.rawSecondColor = _loc3_;
            drawPropsUI.onColorChange();
            updateSwatches();
         };
         this.primaryColorSwatch = new Sprite();
         this.primaryColorSwatch.x = 0;
         this.primaryColorSwatch.y = 1;
         this.secondaryColorSwatch = new Sprite();
         this.secondaryColorSwatch.x = this.primaryColorSwatch.x + 11;
         this.secondaryColorSwatch.y = this.primaryColorSwatch.y + 11;
         addChild(this.secondaryColorSwatch);
         addChild(this.primaryColorSwatch);
         this.primaryColorSwatch.addEventListener(MouseEvent.MOUSE_DOWN,swapColors);
         this.secondaryColorSwatch.addEventListener(MouseEvent.MOUSE_DOWN,swapColors);
         this.updateSwatches();
      }
      
      public function setGradientMode(param1:Boolean) : void
      {
         this.gradientMode = param1;
      }
      
      public function pickColor() : void
      {
         var _loc3_:uint = 0;
         var _loc1_:Sprite = null;
         var _loc2_:Number = this.drawPropsUI.settings.alpha;
         if(_loc2_ == 0)
         {
            _loc1_ = this.transparentColor;
         }
         else
         {
            _loc3_ = this.drawPropsUI.settings.color;
            _loc1_ = this.paletteReverseDict[_loc3_];
         }
         this.updateSwatches();
         if(this.selectedColor)
         {
            this.drawColorSelector(this.selectedColor);
         }
         if(_loc1_)
         {
            this.drawColorSelector(_loc1_,true);
         }
         this.selectedColor = _loc1_;
      }
      
      private function pickWheelColor() : void
      {
         var _loc1_:Array = Color.rgb2hsv(this.drawPropsUI.settings.color);
         var _loc2_:Bitmap = this.hsvColorPicker.getChildAt(0) as Bitmap;
         this.setColorByHSVPos(new Point((_loc2_.bitmapData.width - 1) * _loc1_[0] / 360,(_loc2_.bitmapData.height - 1) * _loc1_[1]),false);
         (this.hsvColorPicker.getChildAt(1) as Slider).value = _loc1_[2];
         this.setHSVBrightness(_loc1_[2],false);
      }
      
      private function updateSwatches() : void
      {
         var _loc1_:DrawProperties = this.drawPropsUI.settings;
         this.drawSwatch(this.primaryColorSwatch.graphics,_loc1_.color,_loc1_.alpha);
         this.drawSwatch(this.secondaryColorSwatch.graphics,_loc1_.secondColor,_loc1_.secondAlpha);
      }
      
      private function drawSwatch(param1:Graphics, param2:uint, param3:Number) : void
      {
         var _loc5_:int = 0;
         var _loc4_:int = 6;
         param1.clear();
         param1.lineStyle();
         if(param3 == 0)
         {
            param2 = 16777215;
         }
         param1.beginFill(param2);
         param1.drawRoundRect(0,0,this.swatchSize,this.swatchSize,_loc4_,_loc4_);
         param1.endFill();
         if(param3 == 0)
         {
            _loc5_ = this.swatchSize - 2;
            param1.lineStyle(2,16711680);
            param1.moveTo(_loc5_,2);
            param1.lineTo(2,_loc5_);
         }
         param1.lineStyle(2,13421772,0.8,true);
         param1.drawRoundRect(0,0,this.swatchSize,this.swatchSize,_loc4_,_loc4_);
      }
      
      public function setCurrentColor(param1:uint, param2:Number, param3:Boolean = true) : void
      {
         var _loc4_:uint = uint(param2 * 255 << 24 | param1);
         this.drawPropsUI.settings.color = _loc4_;
         this.updateSwatches();
         if(param3)
         {
            this.pickColor();
            if(this.hsvColorPicker.visible)
            {
               this.pickWheelColor();
            }
         }
      }
      
      private function setColor(param1:MouseEvent) : void
      {
         var _loc2_:uint = 0;
         var _loc3_:Number = 1;
         if(param1.target != this.transparentColor)
         {
            _loc2_ = uint(this.paletteDict[param1.target]);
         }
         else
         {
            _loc3_ = 0;
         }
         this.setCurrentColor(_loc2_,_loc3_);
         this.drawPropsUI.onColorChange();
      }
      
      private function makeColorWheel() : void
      {
         this.makeHSVColorPicker(96,94);
         addChild(this.hsvColorPicker);
         this.hsvColorPicker.x = this.primaryColorSwatch.getRect(this).right + 20;
         this.wheelSelector = new Shape();
         this.wheelSelector.graphics.lineStyle(2);
         this.wheelSelector.graphics.drawCircle(0,0,5);
         this.wheelSelector.x = 30;
         this.wheelSelector.y = 30;
         this.hsvColorPicker.addChild(this.wheelSelector);
         this.hsvColorPicker.addEventListener(MouseEvent.MOUSE_DOWN,this.setWheelColor);
         this.hsvColorPicker.visible = false;
      }
      
      private function makeHSVColorPicker(param1:int, param2:int) : void
      {
         var _loc7_:uint = 0;
         this.hsvColorPicker = new Sprite();
         var _loc3_:Number = 360 / param1;
         var _loc4_:BitmapData = new BitmapData(param1,param2,false);
         var _loc5_:uint = 0;
         while(_loc5_ < param1)
         {
            _loc7_ = 0;
            while(_loc7_ < param2)
            {
               _loc4_.setPixel(_loc5_,_loc7_,Color.fromHSV(_loc5_ * _loc3_,_loc7_ / param2,1));
               _loc7_++;
            }
            _loc5_++;
         }
         this.hsvColorPicker.addChild(new Bitmap(_loc4_));
         var _loc6_:Slider = new Slider(6,param2,this.setHSVBrightness);
         _loc6_.slotColor = 2105376;
         _loc6_.slotColor2 = 13684944;
         _loc6_.setWidthHeight(6,param2);
         _loc6_.value = 1;
         _loc6_.x = param1 + 5;
         _loc6_.y = 0;
         this.hsvColorPicker.addChild(_loc6_);
      }
      
      private function setHSVBrightness(param1:Number, param2:Boolean = true) : void
      {
         this.hsvColorPicker.getChildAt(0).transform.colorTransform = new ColorTransform(param1,param1,param1);
         this.setColorByHSVPos(new Point(this.wheelSelector.x,this.wheelSelector.y),param2);
      }
      
      private function setWheelColor(param1:MouseEvent) : void
      {
         if(param1.type == MouseEvent.MOUSE_DOWN)
         {
            stage.addEventListener(MouseEvent.MOUSE_MOVE,this.setWheelColor);
            stage.addEventListener(MouseEvent.MOUSE_UP,this.setWheelColor);
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.setWheelColor);
            stage.removeEventListener(MouseEvent.MOUSE_UP,this.setWheelColor);
         }
         if(param1.type != MouseEvent.MOUSE_UP)
         {
            this.setColorByHSVPos(new Point(this.hsvColorPicker.mouseX,this.hsvColorPicker.mouseY));
         }
      }
      
      private function setColorByHSVPos(param1:Point, param2:Boolean = true) : void
      {
         var _loc4_:BitmapData = null;
         var _loc5_:Matrix = null;
         var _loc3_:Boolean = this.hsvColorPicker.getChildAt(0).getBounds(this.hsvColorPicker).contains(param1.x,param1.y);
         if(_loc3_)
         {
            this.wheelSelector.visible = true;
            this.wheelSelector.x = param1.x;
            this.wheelSelector.y = param1.y;
            if(param2)
            {
               _loc4_ = new BitmapData(1,1,true,0);
               _loc5_ = new Matrix();
               _loc5_.translate(-param1.x,-param1.y);
               _loc4_.draw(this.hsvColorPicker,_loc5_);
               this.setCurrentColor(_loc4_.getPixel32(0,0),1,false);
               this.drawPropsUI.onColorChange();
            }
         }
      }
      
      private function makeColorPalette() : void
      {
         var _loc3_:uint = 0;
         var _loc4_:Sprite = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         addChild(this.palette = new Sprite());
         this.paletteDict = new Dictionary();
         this.paletteReverseDict = new Dictionary();
         var _loc1_:uint = this.primaryColorSwatch.getRect(this).right + 20;
         var _loc2_:Array = [0,0.4,0.5,0.7,0.8,0.9,1];
         var _loc5_:uint = this.paletteSwatchW + 2;
         _loc3_ = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = this.makeColorSelector(Color.fromHSV(0,0,_loc2_[_loc3_]));
            _loc4_.x = _loc3_ * _loc5_ + _loc1_;
            _loc4_.y = 0;
            this.palette.addChild(_loc4_);
            _loc3_++;
         }
         _loc4_ = this.makeColorSelector(16777215,true);
         _loc4_.x = _loc3_ * _loc5_ + _loc1_;
         this.palette.addChild(_loc4_);
         _loc3_++;
         var _loc6_:Array = [0,35,60,140,180,225,270,315];
         var _loc7_:int = this.paletteSwatchH + 2;
         var _loc8_:Number = _loc7_;
         for each(_loc10_ in [0.2,0.4,1])
         {
            for each(_loc9_ in _loc6_)
            {
               _loc4_ = this.makeColorSelector(Color.fromHSV(_loc9_,_loc10_,1));
               _loc4_.x = _loc3_ % _loc6_.length * _loc5_ + _loc1_;
               _loc4_.y = _loc8_;
               this.palette.addChild(_loc4_);
               _loc3_++;
            }
            _loc8_ += _loc7_;
         }
         for each(_loc11_ in [0.8,0.6,0.4])
         {
            for each(_loc9_ in _loc6_)
            {
               _loc4_ = this.makeColorSelector(Color.fromHSV(_loc9_,1,_loc11_));
               _loc4_.x = _loc3_ % _loc6_.length * _loc5_ + _loc1_;
               _loc4_.y = _loc8_;
               this.palette.addChild(_loc4_);
               _loc3_++;
            }
            _loc8_ += _loc7_;
         }
      }
      
      private function makeColorSelector(param1:uint, param2:Boolean = false) : Sprite
      {
         var _loc3_:Sprite = new Sprite();
         if(!param2)
         {
            this.paletteDict[_loc3_] = param1;
            this.paletteReverseDict[param1] = _loc3_;
         }
         else
         {
            this.transparentColor = _loc3_;
         }
         _loc3_.addEventListener(MouseEvent.MOUSE_DOWN,this.setColor);
         this.drawColorSelector(_loc3_);
         return _loc3_;
      }
      
      private function drawColorSelector(param1:Sprite, param2:Boolean = false) : void
      {
         param2 = false;
         var _loc3_:Graphics = param1.graphics;
         var _loc4_:uint = param1 == this.transparentColor ? 16777215 : uint(this.paletteDict[param1]);
         var _loc5_:Array = [0,0,this.paletteSwatchW,this.paletteSwatchH];
         _loc3_.clear();
         if(param1 == this.transparentColor)
         {
            _loc3_.lineStyle(2,16711680);
            _loc3_.moveTo(this.paletteSwatchW - 1,1);
            _loc3_.lineTo(1,this.paletteSwatchH - 1);
         }
         if(param2)
         {
            _loc3_.lineStyle(2,0,1);
         }
         else
         {
            _loc3_.lineStyle(0,0,0);
         }
         if(param1 == this.transparentColor)
         {
            _loc3_.beginFill(0,0);
         }
         else
         {
            _loc3_.beginFill(_loc4_);
         }
         _loc3_.drawRect.apply(_loc3_,_loc5_);
         _loc3_.endFill();
         param1.filters = param2 ? [new GlowFilter(16777215,1,5,5)] : [];
         if(param2)
         {
            this.palette.setChildIndex(param1,0);
         }
      }
   }
}

