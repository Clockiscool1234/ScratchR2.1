package util
{
   public class Color
   {
      
      public function Color()
      {
         super();
      }
      
      public static function fromHSV(param1:Number, param2:Number, param3:Number) : int
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         param1 %= 360;
         if(param1 < 0)
         {
            param1 += 360;
         }
         param2 = Math.max(0,Math.min(param2,1));
         param3 = Math.max(0,Math.min(param3,1));
         var _loc7_:Number = Math.floor(param1 / 60);
         var _loc8_:Number = param1 / 60 - _loc7_;
         var _loc9_:Number = param3 * (1 - param2);
         var _loc10_:Number = param3 * (1 - param2 * _loc8_);
         var _loc11_:Number = param3 * (1 - param2 * (1 - _loc8_));
         if(_loc7_ == 0)
         {
            _loc4_ = param3;
            _loc5_ = _loc11_;
            _loc6_ = _loc9_;
         }
         else if(_loc7_ == 1)
         {
            _loc4_ = _loc10_;
            _loc5_ = param3;
            _loc6_ = _loc9_;
         }
         else if(_loc7_ == 2)
         {
            _loc4_ = _loc9_;
            _loc5_ = param3;
            _loc6_ = _loc11_;
         }
         else if(_loc7_ == 3)
         {
            _loc4_ = _loc9_;
            _loc5_ = _loc10_;
            _loc6_ = param3;
         }
         else if(_loc7_ == 4)
         {
            _loc4_ = _loc11_;
            _loc5_ = _loc9_;
            _loc6_ = param3;
         }
         else if(_loc7_ == 5)
         {
            _loc4_ = param3;
            _loc5_ = _loc9_;
            _loc6_ = _loc10_;
         }
         _loc4_ = Math.floor(_loc4_ * 255);
         _loc5_ = Math.floor(_loc5_ * 255);
         _loc6_ = Math.floor(_loc6_ * 255);
         return _loc4_ << 16 | _loc5_ << 8 | _loc6_;
      }
      
      public static function rgb2hsv(param1:Number) : Array
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = (param1 >> 16 & 0xFF) / 255;
         var _loc9_:Number = (param1 >> 8 & 0xFF) / 255;
         var _loc10_:Number = (param1 & 0xFF) / 255;
         _loc5_ = Math.min(Math.min(_loc8_,_loc9_),_loc10_);
         _loc4_ = Math.max(Math.max(_loc8_,_loc9_),_loc10_);
         if(_loc5_ == _loc4_)
         {
            return [0,0,_loc4_];
         }
         _loc6_ = _loc8_ == _loc5_ ? _loc9_ - _loc10_ : (_loc9_ == _loc5_ ? _loc10_ - _loc8_ : _loc8_ - _loc9_);
         _loc7_ = _loc8_ == _loc5_ ? 3 : (_loc9_ == _loc5_ ? 5 : 1);
         _loc2_ = (_loc7_ - _loc6_ / (_loc4_ - _loc5_)) * 60 % 360;
         _loc3_ = (_loc4_ - _loc5_) / _loc4_;
         return [_loc2_,_loc3_,_loc4_];
      }
      
      public static function scaleBrightness(param1:Number, param2:Number) : int
      {
         var _loc3_:Array = rgb2hsv(param1);
         var _loc4_:Number = Math.max(0,Math.min(param2 * _loc3_[2],1));
         return fromHSV(_loc3_[0],_loc3_[1],_loc4_);
      }
      
      public static function mixRGB(param1:int, param2:int, param3:Number) : int
      {
         if(param3 <= 0)
         {
            return param1;
         }
         if(param3 >= 1)
         {
            return param2;
         }
         var _loc4_:int = param1 >> 16 & 0xFF;
         var _loc5_:int = param1 >> 8 & 0xFF;
         var _loc6_:int = param1 & 0xFF;
         var _loc7_:int = param2 >> 16 & 0xFF;
         var _loc8_:int = param2 >> 8 & 0xFF;
         var _loc9_:int = param2 & 0xFF;
         var _loc10_:int = param3 * _loc7_ + (1 - param3) * _loc4_ & 0xFF;
         var _loc11_:int = param3 * _loc8_ + (1 - param3) * _loc5_ & 0xFF;
         var _loc12_:int = param3 * _loc9_ + (1 - param3) * _loc6_ & 0xFF;
         return _loc10_ << 16 | _loc11_ << 8 | _loc12_;
      }
      
      public static function random() : int
      {
         var _loc1_:Number = 360 * Math.random();
         var _loc2_:Number = 0.7 + 0.3 * Math.random();
         var _loc3_:Number = 0.6 + 0.4 * Math.random();
         return fromHSV(_loc1_,_loc2_,_loc3_);
      }
   }
}

