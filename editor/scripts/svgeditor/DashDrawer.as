package svgeditor
{
   import flash.display.BitmapData;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class DashDrawer
   {
      
      private static var lineBitmaps:Object = new Object();
      
      public function DashDrawer()
      {
         super();
         throw new Error("Static Class - Use the static methods!");
      }
      
      public static function drawBox(param1:Graphics, param2:Rectangle, param3:int, param4:int) : void
      {
         var _loc5_:BitmapData = getDashBitmap(param3,param4);
         param1.beginBitmapFill(_loc5_);
         param1.moveTo(param2.left,param2.top);
         param1.lineTo(param2.right,param2.top);
         param1.lineTo(param2.right,param2.top + 1);
         param1.lineTo(param2.left,param2.top + 1);
         param1.endFill();
         param1.beginBitmapFill(_loc5_);
         param1.moveTo(param2.left,param2.bottom);
         param1.lineTo(param2.right,param2.bottom);
         param1.lineTo(param2.right,param2.bottom + 1);
         param1.lineTo(param2.left,param2.bottom + 1);
         param1.endFill();
         var _loc6_:Matrix = new Matrix();
         _loc6_.rotate(Math.PI / 2);
         param1.beginBitmapFill(_loc5_,_loc6_);
         param1.moveTo(param2.left,param2.top);
         param1.lineTo(param2.left + 1,param2.top);
         param1.lineTo(param2.left + 1,param2.bottom);
         param1.lineTo(param2.left,param2.bottom);
         param1.endFill();
         param1.beginBitmapFill(_loc5_,_loc6_);
         param1.moveTo(param2.right,param2.top);
         param1.lineTo(param2.right + 1,param2.top);
         param1.lineTo(param2.right + 1,param2.bottom);
         param1.lineTo(param2.right,param2.bottom);
         param1.endFill();
      }
      
      public static function drawLine(param1:Graphics, param2:Point, param3:Point, param4:int, param5:int) : void
      {
         var _loc6_:BitmapData = getDashBitmap(param4,param5);
         var _loc7_:Matrix = new Matrix();
         var _loc8_:Point = param3.subtract(param2);
         _loc7_.rotate(Math.atan2(_loc8_.y,_loc8_.x));
         _loc8_.x = 0;
         _loc8_.y = 1;
         _loc8_ = _loc7_.transformPoint(_loc8_);
         param1.beginBitmapFill(_loc6_,_loc7_);
         param1.moveTo(param2.x,param2.y);
         param1.lineTo(param3.x,param3.y);
         param1.lineTo(param3.x + _loc8_.x,param3.y + _loc8_.y);
         param1.lineTo(param2.x + _loc8_.x,param2.y + _loc8_.y);
         param1.endFill();
      }
      
      public static function drawPoly(param1:Graphics, param2:Array, param3:int, param4:int) : void
      {
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc5_:BitmapData = getDashBitmap(param3,param4);
         var _loc6_:int = 0;
         while(_loc6_ < param2.length)
         {
            _loc7_ = param2[_loc6_];
            if(_loc6_ < param2.length - 1)
            {
               _loc8_ = param2[_loc6_ + 1];
            }
            else
            {
               _loc8_ = param2[0];
            }
            drawLine(param1,_loc7_,_loc8_,param3,param4);
            _loc6_++;
         }
      }
      
      public static function getDashBitmap(param1:int, param2:int) : BitmapData
      {
         var _loc3_:String = param1 + " " + param2;
         var _loc4_:BitmapData = lineBitmaps[_loc3_];
         if(_loc4_ == null)
         {
            _loc4_ = lineBitmaps[_loc3_] = generateDashBitmap(param1,param2);
         }
         return _loc4_;
      }
      
      private static function generateDashBitmap(param1:int, param2:int) : BitmapData
      {
         var _loc3_:Sprite = new Sprite();
         _loc3_.graphics.clear();
         _loc3_.graphics.lineStyle(2,param2,1,true);
         _loc3_.graphics.moveTo(0,0);
         _loc3_.graphics.lineTo(param1,0);
         var _loc4_:BitmapData = new BitmapData(param1 * 2,1,true,0);
         _loc4_.draw(_loc3_);
         return _loc4_;
      }
   }
}

