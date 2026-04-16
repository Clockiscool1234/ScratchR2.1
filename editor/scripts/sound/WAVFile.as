package sound
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import logging.LogLevel;
   
   public class WAVFile
   {
      
      private static const stepTable:Array = [7,8,9,10,11,12,13,14,16,17,19,21,23,25,28,31,34,37,41,45,50,55,60,66,73,80,88,97,107,118,130,143,157,173,190,209,230,253,279,307,337,371,408,449,494,544,598,658,724,796,876,963,1060,1166,1282,1411,1552,1707,1878,2066,2272,2499,2749,3024,3327,3660,4026,4428,4871,5358,5894,6484,7132,7845,8630,9493,10442,11487,12635,13899,15289,16818,18500,20350,22385,24623,27086,29794,32767];
      
      private static const indexTable:Array = [-1,-1,-1,-1,2,4,6,8,-1,-1,-1,-1,2,4,6,8];
      
      public function WAVFile()
      {
         super();
      }
      
      public static function empty() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeShort(0);
         return encode(_loc1_,1,22050,false);
      }
      
      public static function encode(param1:ByteArray, param2:int, param3:int, param4:Boolean) : ByteArray
      {
         var _loc5_:ByteArray = new ByteArray();
         _loc5_.endian = Endian.LITTLE_ENDIAN;
         if(param4)
         {
            writeCompressed(param3,imaCompress(param1,512),param2,512,_loc5_);
         }
         else
         {
            writeUncompressed(param3,param1,_loc5_);
         }
         _loc5_.position = 0;
         return _loc5_;
      }
      
      public static function decode(param1:ByteArray) : Object
      {
         var _loc7_:uint = 0;
         var _loc8_:int = 0;
         var _loc9_:ByteArray = null;
         var _loc2_:Object = new Object();
         param1.endian = Endian.LITTLE_ENDIAN;
         param1.position = 0;
         if(param1.readUTFBytes(4) != "RIFF")
         {
            throw Error("WAVFile: bad file header");
         }
         var _loc3_:int = param1.readInt();
         if(param1.length != _loc3_ + 8)
         {
         }
         if(param1.readUTFBytes(4) != "WAVE")
         {
            throw Error("WAVFile: not a WAVE file");
         }
         var _loc4_:ByteArray = extractChunk("fmt ",param1);
         if(_loc4_.length < 16)
         {
            throw Error("WAVFile: format chunk is too small");
         }
         var _loc5_:uint = _loc4_.readUnsignedShort();
         _loc2_.encoding = _loc5_;
         _loc2_.channels = _loc4_.readUnsignedShort();
         _loc2_.samplesPerSecond = _loc4_.readUnsignedInt();
         _loc2_.bytesPerSecond = _loc4_.readUnsignedInt();
         _loc2_.blockAlignment = _loc4_.readUnsignedShort();
         _loc2_.bitsPerSample = _loc4_.readUnsignedShort();
         if(_loc4_.length >= 18 && _loc5_ == 65534)
         {
            _loc7_ = _loc4_.readUnsignedShort();
            if(_loc7_ == 22)
            {
               _loc2_.validBitsPerSample = _loc4_.readUnsignedShort();
               _loc2_.channelMask = _loc4_.readUnsignedInt();
               _loc2_.encoding = _loc5_ = _loc4_.readUnsignedShort();
            }
         }
         var _loc6_:Array = dataChunkStartAndSize(param1);
         if(_loc6_ == null)
         {
            _loc6_ = [0,0];
         }
         _loc2_.sampleDataStart = _loc6_[0];
         _loc2_.sampleDataSize = _loc6_[1];
         if(_loc5_ == 1)
         {
            if(!(_loc2_.bitsPerSample == 8 || _loc2_.bitsPerSample == 16))
            {
               throw Error("WAVFile: can only handle 8-bit or 16-bit uncompressed PCM data");
            }
            _loc2_.sampleCount = _loc2_.bitsPerSample == 8 ? _loc2_.sampleDataSize : _loc2_.sampleDataSize / 2;
         }
         else if(_loc5_ == 3)
         {
            _loc2_.sampleCount = Math.floor(_loc2_.sampleDataSize / (_loc2_.bitsPerSample >>> 3));
            param1.position = _loc2_.sampleDataStart;
         }
         else if(_loc5_ == 17)
         {
            if(_loc4_.length < 20)
            {
               throw Error("WAVFile: adpcm format chunk is too small");
            }
            if(_loc2_.channels != 1)
            {
               throw Error("WAVFile: adpcm supports only one channel (monophonic)");
            }
            _loc4_.position += 2;
            _loc8_ = int(_loc4_.readUnsignedShort());
            _loc2_.adpcmBlockSize = (_loc8_ - 1) / 2 + 4;
            _loc9_ = extractChunk("fact",param1);
            if(_loc9_ != null && _loc9_.length == 4)
            {
               _loc2_.sampleCount = _loc9_.readUnsignedInt();
            }
            else
            {
               _loc2_.sampleCount = 2 * _loc2_.sampleDataSize;
            }
         }
         else
         {
            if(_loc5_ != 85)
            {
               throw Error("WAVFile: unknown encoding " + _loc5_);
            }
            _loc9_ = extractChunk("fact",param1);
            if(_loc9_ != null && _loc9_.length == 4)
            {
               _loc2_.sampleCount = _loc9_.readUnsignedInt();
            }
         }
         return _loc2_;
      }
      
      public static function extractSamples(param1:ByteArray) : Vector.<int>
      {
         var result:Vector.<int> = null;
         var info:Object = null;
         var i:int = 0;
         var v:int = 0;
         var f:Number = NaN;
         var samples:ByteArray = null;
         var waveData:ByteArray = param1;
         result = new Vector.<int>();
         try
         {
            info = WAVFile.decode(waveData);
         }
         catch(e:*)
         {
            Scratch.app.log(LogLevel.WARNING,"Error extracting samples from WAV file",{"error":e});
            result.push(0);
            return result;
         }
         if(info.encoding == 1)
         {
            waveData.position = info.sampleDataStart;
            i = 0;
            while(i < info.sampleCount)
            {
               v = info.bitsPerSample == 8 ? waveData.readUnsignedByte() - 128 << 8 : waveData.readShort();
               result.push(v);
               i++;
            }
         }
         else if(info.encoding == 3)
         {
            waveData.position = info.sampleDataStart;
            i = 0;
            while(i < info.sampleCount)
            {
               f = info.bitsPerSample == 32 ? waveData.readFloat() : waveData.readDouble();
               if(f > 1)
               {
                  f = 1;
               }
               if(f < -1)
               {
                  f = -1;
               }
               v = f * 32767;
               result.push(v);
               i++;
            }
         }
         else if(info.encoding == 17)
         {
            samples = imaDecompress(extractChunk("data",waveData),info.adpcmBlockSize);
            samples.position = 0;
            while(samples.bytesAvailable >= 2)
            {
               result.push(samples.readShort());
            }
         }
         return result;
      }
      
      private static function extractChunk(param1:String, param2:ByteArray) : ByteArray
      {
         var _loc3_:String = null;
         var _loc4_:int = 0;
         var _loc5_:ByteArray = null;
         param2.position = 12;
         while(param2.bytesAvailable > 8)
         {
            _loc3_ = param2.readUTFBytes(4);
            _loc4_ = int(param2.readUnsignedInt());
            if(_loc3_ == param1)
            {
               if(_loc4_ > param2.bytesAvailable)
               {
                  return null;
               }
               _loc5_ = new ByteArray();
               _loc5_.endian = Endian.LITTLE_ENDIAN;
               param2.readBytes(_loc5_,0,_loc4_);
               _loc5_.position = 0;
               return _loc5_;
            }
            param2.position += _loc4_;
         }
         return new ByteArray();
      }
      
      private static function dataChunkStartAndSize(param1:ByteArray) : Array
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         param1.position = 12;
         while(param1.bytesAvailable >= 8)
         {
            _loc2_ = param1.readUTFBytes(4);
            _loc3_ = int(param1.readUnsignedInt());
            if(_loc2_ == "data")
            {
               if(_loc3_ > param1.bytesAvailable)
               {
                  return null;
               }
               return [param1.position,_loc3_];
            }
            param1.position += _loc3_;
         }
         return null;
      }
      
      private static function writeUncompressed(param1:int, param2:ByteArray, param3:ByteArray) : void
      {
         var _loc4_:int = param2.length / 2;
         param3.writeUTFBytes("RIFF");
         param3.writeInt(2 * _loc4_ + 36);
         param3.writeUTFBytes("WAVE");
         param3.writeUTFBytes("fmt ");
         param3.writeInt(16);
         param3.writeShort(1);
         param3.writeShort(1);
         param3.writeInt(param1);
         param3.writeInt(param1 * 2);
         param3.writeShort(2);
         param3.writeShort(16);
         param3.writeUTFBytes("data");
         param3.writeInt(2 * _loc4_);
         param3.writeBytes(param2);
      }
      
      private static function writeCompressed(param1:int, param2:ByteArray, param3:int, param4:int, param5:ByteArray) : void
      {
         param5.writeUTFBytes("RIFF");
         param5.writeInt(param2.length + 52);
         param5.writeUTFBytes("WAVE");
         param5.writeUTFBytes("fmt ");
         param5.writeInt(20);
         param5.writeShort(17);
         param5.writeShort(1);
         param5.writeInt(param1);
         var _loc6_:int = 2 * (param4 - 4) + 1;
         var _loc7_:int = Math.floor(2 * param4 / _loc6_ * (param1 / 2));
         param5.writeInt(_loc7_);
         param5.writeShort(param4);
         param5.writeShort(4);
         param5.writeShort(2);
         param5.writeShort(_loc6_);
         param5.writeUTFBytes("fact");
         param5.writeInt(4);
         param5.writeInt(param3);
         param5.writeUTFBytes("data");
         param5.writeInt(param2.length);
         param5.writeBytes(param2);
      }
      
      private static function imaCompress(param1:ByteArray, param2:int) : ByteArray
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc5_:int = 0;
         var _loc10_:int = -1;
         var _loc11_:int = param1.length - 2;
         var _loc12_:ByteArray = new ByteArray();
         _loc12_.endian = Endian.LITTLE_ENDIAN;
         var _loc13_:int = 2 * (param2 - 4) + 1;
         var _loc14_:int = Math.floor((param1.length / 2 + _loc13_ - 1) / _loc13_);
         var _loc15_:* = int(_loc13_ * _loc14_);
         param1.position = 0;
         while(_loc15_-- > 0)
         {
            _loc3_ = param1.position <= _loc11_ ? param1.readShort() : 0;
            if(_loc12_.position % param2 == 0)
            {
               _loc12_.writeShort(_loc3_);
               _loc12_.writeByte(_loc5_);
               _loc12_.writeByte(0);
               _loc4_ = _loc3_;
            }
            else
            {
               _loc8_ = _loc3_ - _loc4_;
               _loc6_ = int(stepTable[_loc5_]);
               _loc7_ = _loc9_ = 0;
               if(_loc8_ < 0)
               {
                  _loc7_ = 8;
                  _loc8_ = -_loc8_;
               }
               if(_loc8_ >= _loc6_)
               {
                  _loc7_ |= 4;
                  _loc8_ -= _loc6_;
                  _loc9_ += _loc6_;
               }
               _loc6_ >>= 1;
               if(_loc8_ >= _loc6_)
               {
                  _loc7_ |= 2;
                  _loc8_ -= _loc6_;
                  _loc9_ += _loc6_;
               }
               _loc6_ >>= 1;
               if(_loc8_ >= _loc6_)
               {
                  _loc7_ |= 1;
                  _loc8_ -= _loc6_;
                  _loc9_ += _loc6_;
               }
               _loc9_ += _loc6_ >> 1;
               if(_loc10_ < 0)
               {
                  _loc10_ = _loc7_;
               }
               else
               {
                  _loc12_.writeByte(_loc7_ << 4 | _loc10_);
                  _loc10_ = -1;
               }
               _loc4_ += _loc7_ & 8 ? -_loc9_ : _loc9_;
               if(_loc4_ > 32767)
               {
                  _loc4_ = 32767;
               }
               if(_loc4_ < -32768)
               {
                  _loc4_ = -32768;
               }
               _loc5_ += indexTable[_loc7_];
               if(_loc5_ > 88)
               {
                  _loc5_ = 88;
               }
               if(_loc5_ < 0)
               {
                  _loc5_ = 0;
               }
            }
         }
         if(_loc10_ >= 0)
         {
            _loc12_.writeByte(_loc10_);
         }
         _loc12_.position = 0;
         return _loc12_;
      }
      
      private static function imaDecompress(param1:ByteArray, param2:int) : ByteArray
      {
         var _loc3_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc4_:int = 0;
         var _loc8_:int = -1;
         var _loc9_:ByteArray = new ByteArray();
         _loc9_.endian = Endian.LITTLE_ENDIAN;
         if(!param1)
         {
            return _loc9_;
         }
         param1.position = 0;
         while(true)
         {
            if(param1.position % param2 == 0 && _loc8_ < 0)
            {
               if(param1.bytesAvailable == 0)
               {
                  break;
               }
               _loc3_ = param1.readShort();
               _loc4_ = int(param1.readUnsignedByte());
               ++param1.position;
               if(_loc4_ > 88)
               {
                  _loc4_ = 88;
               }
               _loc9_.writeShort(_loc3_);
            }
            else
            {
               if(_loc8_ < 0)
               {
                  if(param1.bytesAvailable == 0)
                  {
                     break;
                  }
                  _loc8_ = int(param1.readUnsignedByte());
                  _loc6_ = _loc8_ & 0x0F;
               }
               else
               {
                  _loc6_ = _loc8_ >> 4 & 0x0F;
                  _loc8_ = -1;
               }
               _loc5_ = int(stepTable[_loc4_]);
               _loc7_ = 0;
               if(_loc6_ & 4)
               {
                  _loc7_ += _loc5_;
               }
               if(_loc6_ & 2)
               {
                  _loc7_ += _loc5_ >> 1;
               }
               if(_loc6_ & 1)
               {
                  _loc7_ += _loc5_ >> 2;
               }
               _loc7_ += _loc5_ >> 3;
               _loc4_ += indexTable[_loc6_];
               if(_loc4_ > 88)
               {
                  _loc4_ = 88;
               }
               if(_loc4_ < 0)
               {
                  _loc4_ = 0;
               }
               _loc3_ += _loc6_ & 8 ? -_loc7_ : _loc7_;
               if(_loc3_ > 32767)
               {
                  _loc3_ = 32767;
               }
               if(_loc3_ < -32768)
               {
                  _loc3_ = -32768;
               }
               _loc9_.writeShort(_loc3_);
            }
         }
         _loc9_.position = 0;
         return _loc9_;
      }
   }
}

