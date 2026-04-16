package ui.parts
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import translation.Translator;
   import uiwidgets.IconButton;
   import util.DrawPath;
   
   public class UIPart extends Sprite
   {
      
      protected static const cornerRadius:int = 8;
      
      public var app:Scratch;
      
      public var w:int;
      
      public var h:int;
      
      public function UIPart()
      {
         super();
      }
      
      public static function makeLabel(param1:String, param2:TextFormat, param3:int = 0, param4:int = 0) : TextField
      {
         var _loc5_:TextField = new TextField();
         _loc5_.autoSize = TextFieldAutoSize.LEFT;
         _loc5_.selectable = false;
         _loc5_.defaultTextFormat = param2;
         _loc5_.text = param1;
         _loc5_.x = param3;
         _loc5_.y = param4;
         return _loc5_;
      }
      
      public static function drawTopBar(param1:Graphics, param2:Array, param3:Array, param4:int, param5:int, param6:int = -1) : void
      {
         if(param6 < 0)
         {
            param6 = CSS.borderColor;
         }
         param1.clear();
         drawBoxBkgGradientShape(param1,Math.PI / 2,param2,[0,255],param3,param4,param5);
         param1.lineStyle(0.5,param6,1,true);
         DrawPath.drawPath(param3,param1);
      }
      
      protected static function drawSelected(param1:Graphics, param2:Array, param3:Array, param4:int, param5:int) : void
      {
         param1.clear();
         drawBoxBkgGradientShape(param1,Math.PI / 2,param2,[220,255],param3,param4,param5);
         param1.lineStyle(0.5,CSS.borderColor,1,true);
         DrawPath.drawPath(param3,param1);
      }
      
      protected static function drawBoxBkgGradientShape(param1:Graphics, param2:Number, param3:Array, param4:Array, param5:Array, param6:Number, param7:Number) : void
      {
         var _loc8_:Matrix = new Matrix();
         _loc8_.createGradientBox(param6,param7,param2,0,0);
         param1.beginGradientFill(GradientType.LINEAR,param3,[100,100],param4,_loc8_);
         DrawPath.drawPath(param5,param1);
         param1.endFill();
      }
      
      public static function getTopBarPath(param1:int, param2:int) : Array
      {
         return [["m",0,param2],["v",-param2 + cornerRadius],["c",0,-cornerRadius,cornerRadius,-cornerRadius],["h",param1 - cornerRadius * 2],["c",cornerRadius,0,cornerRadius,cornerRadius],["v",param2 - cornerRadius]];
      }
      
      public static function makeMenuButton(param1:String, param2:Function, param3:Boolean = false, param4:int = 16777215) : IconButton
      {
         var _loc5_:Sprite = makeButtonLabel(Translator.map(param1),CSS.buttonLabelOverColor,param3);
         var _loc6_:Sprite = makeButtonLabel(Translator.map(param1),param4,param3);
         var _loc7_:IconButton = new IconButton(param2,_loc5_,_loc6_);
         _loc7_.isMomentary = true;
         return _loc7_;
      }
      
      public static function makeButtonLabel(param1:String, param2:int, param3:Boolean) : Sprite
      {
         var _loc4_:TextField = makeLabel(param1,CSS.topBarButtonFormat);
         _loc4_.textColor = param2;
         var _loc5_:Sprite = new Sprite();
         _loc5_.addChild(_loc4_);
         if(param3)
         {
            _loc5_.addChild(menuArrow(_loc4_.textWidth + 5,6,param2));
         }
         return _loc5_;
      }
      
      private static function menuArrow(param1:int, param2:int, param3:int) : Shape
      {
         var _loc4_:Shape = new Shape();
         var _loc5_:Graphics = _loc4_.graphics;
         _loc5_.beginFill(param3);
         _loc5_.lineTo(8,0);
         _loc5_.lineTo(4,6);
         _loc5_.lineTo(0,0);
         _loc5_.endFill();
         _loc4_.x = param1;
         _loc4_.y = param2;
         return _loc4_;
      }
      
      public function right() : int
      {
         return x + this.w;
      }
      
      public function bottom() : int
      {
         return y + this.h;
      }
      
      private function curve(param1:Graphics, param2:int, param3:int, param4:int, param5:int, param6:Number = 0.42) : void
      {
         var _loc7_:Number = (param2 + param4) / 2;
         var _loc8_:Number = (param3 + param5) / 2;
         var _loc9_:Number = _loc7_ + param6 * (param5 - param3);
         var _loc10_:Number = _loc8_ - param6 * (param4 - param2);
         param1.curveTo(_loc9_,_loc10_,param4,param5);
      }
   }
}

