package com.hangunsworld.util
{
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class BMPFunctions
   {
      
      public function BMPFunctions()
      {
         super();
      }
      
      public static function floodFill(param1:BitmapData, param2:uint, param3:uint, param4:uint, param5:uint = 0, param6:Boolean = false) : BitmapData
      {
         var _loc8_:uint = 0;
         var _loc9_:uint = 0;
         var _loc10_:BitmapData = null;
         var _loc11_:uint = 0;
         var _loc12_:Rectangle = null;
         var _loc13_:Point = null;
         var _loc14_:uint = 0;
         var _loc15_:int = 0;
         param2 = Math.min(param1.width - 1,param2);
         param3 = Math.min(param1.height - 1,param3);
         param5 = Math.max(0,Math.min(255,param5));
         var _loc7_:uint = param1.getPixel32(param2,param3);
         if(param6)
         {
            _loc8_ = uint(param1.width);
            _loc9_ = uint(param1.height);
            _loc10_ = new BitmapData(_loc8_,_loc9_,false,0);
            _loc10_.lock();
            _loc11_ = 0;
            while(_loc11_ < _loc8_)
            {
               _loc14_ = 0;
               while(_loc14_ < _loc9_)
               {
                  _loc15_ = BMPFunctions.getColorDifference32(_loc7_,param1.getPixel32(_loc11_,_loc14_));
                  if(_loc15_ <= param5)
                  {
                     _loc10_.setPixel(_loc11_,_loc14_,3355443);
                  }
                  _loc14_++;
               }
               _loc11_++;
            }
            _loc10_.unlock();
            _loc10_.floodFill(param2,param3,16777215);
            _loc12_ = new Rectangle(0,0,_loc8_,_loc9_);
            _loc13_ = new Point(0,0);
            _loc10_.threshold(_loc10_,_loc12_,_loc13_,"<",4284900966,4278190080);
            _loc12_ = _loc10_.getColorBoundsRect(4294967295,4294967295);
            param2 = _loc12_.x;
            param3 = _loc12_.y;
            _loc8_ = param2 + _loc12_.width;
            _loc9_ = param3 + _loc12_.height;
            param1.lock();
            _loc11_ = param2;
            while(_loc11_ < _loc8_)
            {
               _loc14_ = param3;
               while(_loc14_ < _loc9_)
               {
                  if(_loc10_.getPixel(_loc11_,_loc14_) == 16777215)
                  {
                     param1.setPixel32(_loc11_,_loc14_,param4);
                  }
                  _loc14_++;
               }
               _loc11_++;
            }
            param1.unlock();
         }
         else
         {
            BMPFunctions.replaceColor(param1,_loc7_,param4,param5);
         }
         return param1;
      }
      
      public static function replaceColor(param1:BitmapData, param2:uint, param3:uint, param4:uint = 0) : BitmapData
      {
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         param4 = Math.max(0,Math.min(255,param4));
         param1.lock();
         var _loc5_:uint = uint(param1.width);
         var _loc6_:uint = uint(param1.height);
         var _loc7_:uint = 0;
         while(_loc7_ < _loc5_)
         {
            _loc8_ = 0;
            while(_loc8_ < _loc6_)
            {
               _loc9_ = BMPFunctions.getColorDifference32(param2,param1.getPixel32(_loc7_,_loc8_));
               if(_loc9_ <= param4)
               {
                  param1.setPixel32(_loc7_,_loc8_,param3);
               }
               _loc8_++;
            }
            _loc7_++;
         }
         param1.unlock();
         return param1;
      }
      
      public static function getColorDifference(param1:uint, param2:uint) : int
      {
         var _loc3_:int = (param1 & 0xFF0000) >>> 16;
         var _loc4_:int = (param1 & 0xFF00) >>> 8;
         var _loc5_:int = param1 & 0xFF;
         var _loc6_:int = (param2 & 0xFF0000) >>> 16;
         var _loc7_:int = (param2 & 0xFF00) >>> 8;
         var _loc8_:int = param2 & 0xFF;
         var _loc9_:int = Math.pow(_loc3_ - _loc6_,2);
         var _loc10_:int = Math.pow(_loc4_ - _loc7_,2);
         var _loc11_:int = Math.pow(_loc5_ - _loc8_,2);
         var _loc12_:int = Math.sqrt(_loc9_ + _loc10_ + _loc11_);
         return int(Math.floor(_loc12_ / 441 * 255));
      }
      
      public static function getColorDifference32(param1:uint, param2:uint) : int
      {
         var _loc3_:int = (param1 & 0xFF000000) >>> 24;
         var _loc4_:int = (param1 & 0xFF0000) >>> 16;
         var _loc5_:int = (param1 & 0xFF00) >>> 8;
         var _loc6_:int = param1 & 0xFF;
         var _loc7_:int = (param2 & 0xFF000000) >>> 24;
         var _loc8_:int = (param2 & 0xFF0000) >>> 16;
         var _loc9_:int = (param2 & 0xFF00) >>> 8;
         var _loc10_:int = param2 & 0xFF;
         var _loc11_:int = Math.pow(_loc3_ - _loc7_,2);
         var _loc12_:int = Math.pow(_loc4_ - _loc8_,2);
         var _loc13_:int = Math.pow(_loc5_ - _loc9_,2);
         var _loc14_:int = Math.pow(_loc6_ - _loc10_,2);
         var _loc15_:int = Math.sqrt(_loc11_ + _loc12_ + _loc13_ + _loc14_);
         return int(Math.floor(_loc15_ / 510 * 255));
      }
      
      public static function addWatermark(param1:BitmapData, param2:BitmapData, param3:uint = 0, param4:uint = 0, param5:Number = 1, param6:uint = 0, param7:Number = 1) : BitmapData
      {
         param6 = Math.min(360,param6);
         param7 = Math.min(1,Math.max(0,param7));
         var _loc8_:BitmapData = new BitmapData(param2.width + param3,param2.height + param3,true,0);
         var _loc9_:Rectangle = new Rectangle(0,0,param2.width,param2.height);
         var _loc10_:Point = new Point(0,0);
         _loc8_.copyPixels(param2,_loc9_,_loc10_);
         var _loc11_:Sprite = new Sprite();
         var _loc12_:Sprite = new Sprite();
         var _loc13_:Matrix = new Matrix();
         _loc13_.translate(param4,param4);
         _loc13_.rotate(param6 / 180 * Math.PI);
         _loc13_.scale(param5,param5);
         _loc12_.graphics.beginBitmapFill(_loc8_,_loc13_,true,true);
         _loc12_.graphics.drawRect(0,0,param1.width,param1.height);
         _loc12_.graphics.endFill();
         _loc11_.addChild(_loc12_);
         _loc12_.alpha = param7;
         param1.draw(_loc11_);
         _loc12_.graphics.clear();
         _loc11_.removeChild(_loc12_);
         return param1;
      }
   }
}

