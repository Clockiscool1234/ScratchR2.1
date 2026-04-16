package sound.mp3
{
   import flash.utils.*;
   
   public class MP3FileReader
   {
      
      private const versionTable:Array = [2.5,-1,2,1];
      
      private const layerTable:Array = [-1,3,2,1];
      
      private const samplingRateTable:Array = [44100,48000,32000];
      
      private const bitRateTable1:Array = [-1,32,40,48,56,64,80,96,112,128,160,192,224,256,320,-1];
      
      private const bitRateTable2:Array = [-1,8,16,24,32,40,48,56,64,80,96,112,128,144,160,-1];
      
      public var mp3Data:ByteArray;
      
      private var currentPosition:int;
      
      private var firstHeader:int;
      
      private var version:Number;
      
      private var layer:int;
      
      private var samplingRate:int;
      
      private var channels:int;
      
      private var bitRateTable:Array;
      
      private var bitRateMultiplier:int;
      
      public function MP3FileReader(param1:ByteArray)
      {
         super();
         this.mp3Data = param1;
         this.mp3Data.position = 0;
         this.skipInitialTags();
         this.findFirstFrame();
         this.currentPosition = this.mp3Data.position;
      }
      
      public function swfFormatByte() : int
      {
         var _loc1_:int = 4 - 44100 / this.samplingRate;
         return (2 << 4) + (_loc1_ << 2) + (1 << 1) + (this.channels - 1);
      }
      
      public function appendFrame(param1:ByteArray) : int
      {
         this.mp3Data.position = this.currentPosition;
         if(this.mp3Data.bytesAvailable < 4)
         {
            return 0;
         }
         var _loc2_:uint = uint(this.mp3Data.readInt());
         if(!this.checkHeader(_loc2_))
         {
            return 0;
         }
         var _loc3_:int = this.getFrameSize(_loc2_);
         if(this.currentPosition + _loc3_ > this.mp3Data.length)
         {
            return 0;
         }
         param1.writeBytes(this.mp3Data,this.currentPosition,_loc3_);
         this.currentPosition += _loc3_;
         return _loc3_;
      }
      
      public function getInfo() : Object
      {
         var _loc2_:int = 0;
         var _loc3_:uint = 0;
         var _loc1_:String = this.mp3Data.endian;
         this.mp3Data.endian = Endian.BIG_ENDIAN;
         this.mp3Data.position = 0;
         this.skipInitialTags();
         this.findFirstFrame();
         while(this.mp3Data.bytesAvailable > 4)
         {
            _loc3_ = uint(this.mp3Data.readInt());
            if(!this.checkHeader(_loc3_))
            {
               break;
            }
            _loc2_++;
            this.mp3Data.position += this.getFrameSize(_loc3_) - 4;
         }
         if(_loc2_ == 0)
         {
            this.samplingRate = this.channels = this.version = 0;
         }
         this.mp3Data.endian = _loc1_;
         return {
            "samplingRate":this.samplingRate,
            "channels":this.channels,
            "sampleCount":_loc2_ * (this.version == 1 ? 1152 : 576),
            "mpegVersion":this.version
         };
      }
      
      private function skipInitialTags() : void
      {
         var _loc1_:int = 0;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         while(this.mp3Data.bytesAvailable > 10)
         {
            _loc1_ = int(this.mp3Data.position);
            _loc2_ = this.mp3Data.readUTFBytes(3);
            if(_loc2_ == "ID3")
            {
               this.mp3Data.position += 3;
               _loc3_ = this.mp3Data.readByte();
               _loc4_ = this.mp3Data.readByte();
               _loc5_ = this.mp3Data.readByte();
               _loc6_ = this.mp3Data.readByte();
               if((_loc6_ | _loc5_ | _loc4_ | _loc3_) & 0x80)
               {
                  this.mp3Data.position = _loc1_;
                  return;
               }
               _loc7_ = (_loc3_ << 21) + (_loc4_ << 14) + (_loc5_ << 7) + _loc6_;
               this.mp3Data.position += _loc7_;
            }
            else
            {
               if(_loc2_ != "TAG")
               {
                  this.mp3Data.position = _loc1_;
                  return;
               }
               this.mp3Data.position += 125;
            }
         }
      }
      
      private function findFirstFrame() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         while(this.mp3Data.bytesAvailable > 4)
         {
            _loc1_ = this.mp3Data.readByte() & 0xFF;
            if(_loc1_ == 255)
            {
               --this.mp3Data.position;
               _loc2_ = int(this.mp3Data.position);
               _loc3_ = this.mp3Data.readInt();
               if(this.isValidHeader(_loc3_))
               {
                  _loc4_ = this.getFrameSize(_loc3_);
                  if(_loc4_ > 0 && this.mp3Data.position + _loc4_ + 4 < this.mp3Data.length)
                  {
                     this.mp3Data.position = _loc2_ + this.getFrameSize(_loc3_);
                     if(this.isValidHeader(this.mp3Data.readInt()))
                     {
                        this.firstHeader = _loc3_;
                        this.parseHeader(this.firstHeader);
                        this.mp3Data.position = _loc2_;
                        return;
                     }
                  }
               }
               this.mp3Data.position = _loc2_ + 1;
            }
         }
      }
      
      private function checkHeader(param1:int) : Boolean
      {
         return ((param1 ^ this.firstHeader) & 0xFFFF0C0C) == 0;
      }
      
      private function parseHeader(param1:int) : void
      {
         this.version = this.versionTable[this.getVersionIndex(param1)];
         this.layer = this.layerTable[this.getLayerIndex(param1)];
         this.channels = this.getModeIndex(param1) > 2 ? 1 : 2;
         this.samplingRate = this.samplingRateTable[this.getRateIndex(param1)];
         if(this.version == 2)
         {
            this.samplingRate /= 2;
         }
         if(this.version == 2.5)
         {
            this.samplingRate /= 4;
         }
         this.bitRateTable = this.version == 1 ? this.bitRateTable1 : this.bitRateTable2;
         this.bitRateMultiplier = this.version == 1 ? 144000 : 72000;
      }
      
      private function getFrameSize(param1:int) : int
      {
         if(!this.firstHeader)
         {
            this.parseHeader(param1);
         }
         var _loc2_:int = int(this.bitRateTable[this.getBitrateIndex(param1)]);
         var _loc3_:int = this.bitRateMultiplier * _loc2_ / this.samplingRate;
         return _loc3_ + this.getPaddingBit(param1);
      }
      
      private function isValidHeader(param1:int) : Boolean
      {
         return this.getFrameSync(param1) == 2047 && this.getVersionIndex(param1) != 1 && this.getLayerIndex(param1) == 1 && this.getBitrateIndex(param1) != 0 && this.getBitrateIndex(param1) != 15 && this.getRateIndex(param1) != 3 && this.getEmphasisIndex(param1) != 2;
      }
      
      private function getFrameSync(param1:int) : int
      {
         return param1 >> 21 & 0x07FF;
      }
      
      private function getVersionIndex(param1:int) : int
      {
         return param1 >> 19 & 3;
      }
      
      private function getLayerIndex(param1:int) : int
      {
         return param1 >> 17 & 3;
      }
      
      private function getCRCFlag(param1:int) : int
      {
         return param1 >> 16 & 1;
      }
      
      private function getBitrateIndex(param1:int) : int
      {
         return param1 >> 12 & 0x0F;
      }
      
      private function getRateIndex(param1:int) : int
      {
         return param1 >> 10 & 3;
      }
      
      private function getPaddingBit(param1:int) : int
      {
         return param1 >> 9 & 1;
      }
      
      private function getModeIndex(param1:int) : int
      {
         return param1 >> 6 & 3;
      }
      
      private function getEmphasisIndex(param1:int) : int
      {
         return param1 & 3;
      }
   }
}

