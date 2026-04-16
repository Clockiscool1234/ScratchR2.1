package sound
{
   import flash.utils.ByteArray;
   
   public class SqueakSoundPlayer extends ScratchSoundPlayer
   {
      
      private static const stepSizeTable:Array = [7,8,9,10,11,12,13,14,16,17,19,21,23,25,28,31,34,37,41,45,50,55,60,66,73,80,88,97,107,118,130,143,157,173,190,209,230,253,279,307,337,371,408,449,494,544,598,658,724,796,876,963,1060,1166,1282,1411,1552,1707,1878,2066,2272,2499,2749,3024,3327,3660,4026,4428,4871,5358,5894,6484,7132,7845,8630,9493,10442,11487,12635,13899,15289,16818,18500,20350,22385,24623,27086,29794,32767];
      
      private var bitsPerSample:int;
      
      private var currentByte:int;
      
      private var bitPosition:int;
      
      private var indexTable:Array;
      
      private var deltaSignMask:int;
      
      private var deltaValueMask:int;
      
      private var deltaValueHighBit:int;
      
      private var predicted:int;
      
      private var index:int;
      
      public function SqueakSoundPlayer(param1:ByteArray, param2:int, param3:Number)
      {
         super(null);
         this.soundData = param1;
         this.bitsPerSample = param2;
         stepSize = param3 / 44100;
         startOffset = 0;
         endOffset = param1.length;
         getSample = this.getSqueakSample;
         switch(param2)
         {
            case 2:
               this.indexTable = [-1,2];
               break;
            case 3:
               this.indexTable = [-1,-1,2,4];
               break;
            case 4:
               this.indexTable = [-1,-1,-1,-1,2,4,6,8];
               break;
            case 5:
               this.indexTable = [-1,-1,-1,-1,-1,-1,-1,-1,1,2,4,6,8,10,13,16];
         }
         this.deltaSignMask = 1 << param2 - 1;
         this.deltaValueMask = this.deltaSignMask - 1;
         this.deltaValueHighBit = this.deltaSignMask >> 1;
      }
      
      private function getSqueakSample() : int
      {
         if(bytePosition >= soundData.length)
         {
            return 0;
         }
         var _loc1_:int = this.nextBits();
         var _loc2_:int = int(stepSizeTable[this.index]);
         var _loc3_:int = 0;
         var _loc4_:int = this.deltaValueHighBit;
         while(_loc4_ > 0)
         {
            if((_loc1_ & _loc4_) != 0)
            {
               _loc3_ += _loc2_;
            }
            _loc2_ >>= 1;
            _loc4_ >>= 1;
         }
         _loc3_ += _loc2_;
         this.predicted += (_loc1_ & this.deltaSignMask) != 0 ? -_loc3_ : _loc3_;
         this.index += this.indexTable[_loc1_ & this.deltaValueMask];
         if(this.index < 0)
         {
            this.index = 0;
         }
         if(this.index > 88)
         {
            this.index = 88;
         }
         if(this.predicted > 32767)
         {
            this.predicted = 32767;
         }
         if(this.predicted < -32768)
         {
            this.predicted = -32768;
         }
         return this.predicted;
      }
      
      private function nextBits() : int
      {
         var _loc3_:int = 0;
         var _loc1_:int = 0;
         var _loc2_:int = this.bitsPerSample;
         while(true)
         {
            _loc3_ = _loc2_ - this.bitPosition;
            _loc1_ += _loc3_ < 0 ? this.currentByte >> -_loc3_ : this.currentByte << _loc3_;
            if(_loc3_ <= 0)
            {
               this.bitPosition -= _loc2_;
               this.currentByte &= 255 >> 8 - this.bitPosition;
               break;
            }
            _loc2_ -= this.bitPosition;
            if(bytePosition >= soundData.length)
            {
               this.currentByte = 0;
               this.bitPosition = 0;
               break;
            }
            this.currentByte = soundData[bytePosition++];
            this.bitPosition = 8;
         }
         return _loc1_;
      }
   }
}

