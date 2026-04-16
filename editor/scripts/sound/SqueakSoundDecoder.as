package sound
{
   import flash.utils.*;
   
   public class SqueakSoundDecoder
   {
      
      private static var stepSizeTable:Array = [7,8,9,10,11,12,13,14,16,17,19,21,23,25,28,31,34,37,41,45,50,55,60,66,73,80,88,97,107,118,130,143,157,173,190,209,230,253,279,307,337,371,408,449,494,544,598,658,724,796,876,963,1060,1166,1282,1411,1552,1707,1878,2066,2272,2499,2749,3024,3327,3660,4026,4428,4871,5358,5894,6484,7132,7845,8630,9493,10442,11487,12635,13899,15289,16818,18500,20350,22385,24623,27086,29794,32767];
      
      private var bitsPerSample:int;
      
      private var currentByte:int;
      
      private var bitPosition:int;
      
      private var indexTable:Array;
      
      private var signMask:int;
      
      private var valueMask:int;
      
      private var valueHighBit:int;
      
      public function SqueakSoundDecoder(param1:int)
      {
         super();
         this.bitsPerSample = param1;
         switch(param1)
         {
            case 2:
               this.indexTable = [-1,2,-1,2];
               break;
            case 3:
               this.indexTable = [-1,-1,2,4,-1,-1,2,4];
               break;
            case 4:
               this.indexTable = [-1,-1,-1,-1,2,4,6,8,-1,-1,-1,-1,2,4,6,8];
               break;
            case 5:
               this.indexTable = [-1,-1,-1,-1,-1,-1,-1,-1,1,2,4,6,8,10,13,16,-1,-1,-1,-1,-1,-1,-1,-1,1,2,4,6,8,10,13,16];
         }
         this.signMask = 1 << param1 - 1;
         this.valueMask = this.signMask - 1;
         this.valueHighBit = this.signMask >> 1;
      }
      
      public function decode(param1:ByteArray) : ByteArray
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.endian = Endian.LITTLE_ENDIAN;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         param1.position = 0;
         while(true)
         {
            _loc5_ = this.nextCode(param1);
            if(_loc5_ < 0)
            {
               break;
            }
            _loc6_ = int(stepSizeTable[_loc4_]);
            _loc7_ = 0;
            _loc8_ = this.valueHighBit;
            while(_loc8_ > 0)
            {
               if((_loc5_ & _loc8_) != 0)
               {
                  _loc7_ += _loc6_;
               }
               _loc6_ >>= 1;
               _loc8_ >>= 1;
            }
            _loc7_ += _loc6_;
            _loc3_ += (_loc5_ & this.signMask) != 0 ? -_loc7_ : _loc7_;
            _loc4_ += this.indexTable[_loc5_];
            if(_loc4_ < 0)
            {
               _loc4_ = 0;
            }
            if(_loc4_ > 88)
            {
               _loc4_ = 88;
            }
            if(_loc3_ > 32767)
            {
               _loc3_ = 32767;
            }
            if(_loc3_ < -32768)
            {
               _loc3_ = -32768;
            }
            _loc2_.writeShort(_loc3_);
         }
         _loc2_.position = 0;
         return _loc2_;
      }
      
      private function nextCode(param1:ByteArray) : int
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = this.bitsPerSample;
         while(true)
         {
            _loc4_ = _loc3_ - this.bitPosition;
            _loc2_ += _loc4_ < 0 ? this.currentByte >> -_loc4_ : this.currentByte << _loc4_;
            if(_loc4_ <= 0)
            {
               break;
            }
            _loc3_ -= this.bitPosition;
            if(param1.bytesAvailable <= 0)
            {
               this.currentByte = 0;
               this.bitPosition = 0;
               return -1;
            }
            this.currentByte = param1.readUnsignedByte();
            this.bitPosition = 8;
         }
         this.bitPosition -= _loc3_;
         this.currentByte &= 255 >> 8 - this.bitPosition;
         return _loc2_;
      }
   }
}

