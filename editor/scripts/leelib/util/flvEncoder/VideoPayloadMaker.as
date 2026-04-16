package leelib.util.flvEncoder
{
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class VideoPayloadMaker implements IVideoPayload
   {
      
      public function VideoPayloadMaker()
      {
         super();
      }
      
      public function make(param1:BitmapData) : ByteArray
      {
         var _loc11_:int = 0;
         var _loc12_:uint = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc15_:uint = 0;
         var _loc16_:int = 0;
         var _loc17_:int = 0;
         var _loc18_:* = 0;
         var _loc19_:int = 0;
         var _loc20_:uint = 0;
         var _loc2_:int = param1.width;
         var _loc3_:int = param1.height;
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeByte(19);
         FlvEncoder.writeUI4_12(_loc4_,int(FlvEncoder.BLOCK_WIDTH / 16) - 1,_loc2_);
         FlvEncoder.writeUI4_12(_loc4_,int(FlvEncoder.BLOCK_HEIGHT / 16) - 1,_loc3_);
         var _loc5_:int = int(_loc3_ / FlvEncoder.BLOCK_HEIGHT);
         var _loc6_:int = _loc3_ % FlvEncoder.BLOCK_HEIGHT;
         if(_loc6_ > 0)
         {
            _loc5_ += 1;
         }
         var _loc7_:int = int(_loc2_ / FlvEncoder.BLOCK_WIDTH);
         var _loc8_:int = _loc2_ % FlvEncoder.BLOCK_WIDTH;
         if(_loc8_ > 0)
         {
            _loc7_ += 1;
         }
         var _loc9_:ByteArray = new ByteArray();
         _loc9_.endian = Endian.LITTLE_ENDIAN;
         var _loc10_:int = 0;
         while(_loc10_ < _loc5_)
         {
            _loc11_ = 0;
            while(_loc11_ < _loc7_)
            {
               _loc12_ = _loc11_ * FlvEncoder.BLOCK_WIDTH;
               _loc13_ = _loc8_ > 0 && _loc11_ + 1 == _loc7_ ? _loc8_ : FlvEncoder.BLOCK_WIDTH;
               _loc14_ = _loc12_ + _loc13_;
               _loc15_ = _loc3_ - _loc10_ * FlvEncoder.BLOCK_HEIGHT;
               _loc16_ = _loc6_ > 0 && _loc10_ + 1 == _loc5_ ? _loc6_ : FlvEncoder.BLOCK_HEIGHT;
               _loc17_ = _loc15_ - _loc16_;
               _loc9_.length = 0;
               _loc18_ = int(_loc15_ - 1);
               while(_loc18_ >= _loc17_)
               {
                  _loc19_ = int(_loc12_);
                  while(_loc19_ < _loc14_)
                  {
                     _loc20_ = param1.getPixel(_loc19_,_loc18_);
                     _loc9_.writeByte(_loc20_ & 0xFF);
                     _loc9_.writeShort(_loc20_ >> 8);
                     _loc19_++;
                  }
                  _loc18_--;
               }
               _loc9_.compress();
               FlvEncoder.writeUI16(_loc4_,_loc9_.length);
               _loc4_.writeBytes(_loc9_);
               _loc11_++;
            }
            _loc10_++;
         }
         _loc9_.length = 0;
         _loc9_ = null;
         return _loc4_;
      }
      
      public function init(param1:int, param2:int) : void
      {
      }
      
      public function kill() : void
      {
      }
   }
}

