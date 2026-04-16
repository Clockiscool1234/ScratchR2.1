package util
{
   import flash.display.Graphics;
   
   public class DrawPath
   {
      
      public function DrawPath()
      {
         super();
      }
      
      public static function drawPath(param1:Array, param2:Graphics) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc3_:Number = 0;
         var _loc4_:Number = 0;
         _loc5_ = 0;
         _loc6_ = 0;
         for each(_loc7_ in param1)
         {
            switch(_loc7_[0].toLowerCase())
            {
               case "m":
                  _loc3_ = Number(_loc7_[1]);
                  _loc4_ = Number(_loc7_[2]);
                  param2.moveTo(_loc5_ = _loc3_,_loc6_ = _loc4_);
                  break;
               case "l":
                  param2.lineTo(_loc5_ = _loc5_ + _loc7_[1],_loc6_ = _loc6_ + _loc7_[2]);
                  break;
               case "h":
                  param2.lineTo(_loc5_ = _loc5_ + _loc7_[1],_loc6_);
                  break;
               case "v":
                  param2.lineTo(_loc5_,_loc6_ = _loc6_ + _loc7_[1]);
                  break;
               case "c":
                  _loc8_ = _loc5_ + _loc7_[1];
                  _loc9_ = _loc6_ + _loc7_[2];
                  _loc10_ = _loc5_ + _loc7_[3];
                  _loc11_ = _loc6_ + _loc7_[4];
                  param2.curveTo(_loc8_,_loc9_,_loc10_,_loc11_);
                  _loc5_ += _loc7_[3];
                  _loc6_ += _loc7_[4];
                  break;
               case "z":
                  param2.lineTo(_loc5_ = _loc3_,_loc6_ = _loc4_);
            }
         }
      }
   }
}

