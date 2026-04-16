package scratch
{
   import by.blooddy.crypto.MD5;
   import flash.utils.*;
   import logging.LogLevel;
   import sound.*;
   import sound.mp3.MP3Loader;
   import util.*;
   
   public class ScratchSound
   {
      
      public var soundName:String = "";
      
      public var soundID:int;
      
      public var format:String = "";
      
      public var rate:int = 44100;
      
      public var sampleCount:int;
      
      public var sampleDataStart:int;
      
      public var bitsPerSample:int;
      
      public var editorData:Object;
      
      public var channels:uint = 1;
      
      private const WasEdited:int = -10;
      
      private var __md5:String;
      
      private var __soundData:ByteArray;
      
      public function ScratchSound(param1:String, param2:ByteArray)
      {
         var info:Object = null;
         var extraData:Object = null;
         var error:Error = null;
         var name:String = param1;
         var sndData:ByteArray = param2;
         this.__soundData = new ByteArray();
         super();
         this.soundName = name;
         this.soundID = this.WasEdited;
         if(sndData != null)
         {
            try
            {
               info = WAVFile.decode(sndData);
               if([1,3,17].indexOf(info.encoding) == -1)
               {
                  throw Error("Unsupported WAV format");
               }
               this.soundData = sndData;
               if(info.encoding == 17)
               {
                  this.format = "adpcm";
               }
               else if(info.encoding == 3)
               {
                  this.format = "float";
               }
               this.rate = info.samplesPerSecond;
               this.sampleCount = info.sampleCount;
               this.bitsPerSample = info.bitsPerSample;
               this.channels = info.channels;
               this.sampleDataStart = info.sampleDataStart;
               this.reduceSizeIfNeeded(info.channels);
            }
            catch(e:*)
            {
               extraData = {
                  "exception":e,
                  "info":info
               };
               if(e is Error)
               {
                  error = e as Error;
                  Scratch.app.log(LogLevel.WARNING,"Error while constructing sound:" + e.message,extraData);
               }
               else
               {
                  Scratch.app.log(LogLevel.WARNING,"Unknown error while constructing sound",extraData);
               }
               setSamples(new Vector.<int>(0),22050);
            }
         }
      }
      
      private static function stereoToMono(param1:Vector.<int>, param2:Boolean) : Vector.<int>
      {
         var _loc3_:Vector.<int> = new Vector.<int>();
         var _loc4_:int = param2 ? 4 : 2;
         var _loc5_:int = 0;
         var _loc6_:int = param1.length - 1;
         while(_loc5_ < _loc6_)
         {
            _loc3_.push((param1[_loc5_] + param1[_loc5_ + 1]) / 2);
            _loc5_ += _loc4_;
         }
         return _loc3_;
      }
      
      private static function downsample(param1:Vector.<int>) : Vector.<int>
      {
         var _loc2_:Vector.<int> = new Vector.<int>();
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_.push(param1[_loc3_]);
            _loc3_ += 2;
         }
         return _loc2_;
      }
      
      public static function isWAV(param1:ByteArray) : Boolean
      {
         if(param1.length < 12)
         {
            return false;
         }
         param1.position = 0;
         if(param1.readUTFBytes(4) != "RIFF")
         {
            return false;
         }
         param1.readInt();
         return param1.readUTFBytes(4) == "WAVE";
      }
      
      public function get soundData() : ByteArray
      {
         return this.__soundData;
      }
      
      public function set soundData(param1:ByteArray) : void
      {
         this.__soundData = param1;
         this.__md5 = null;
      }
      
      public function get md5() : String
      {
         if(!this.__md5)
         {
            this.__md5 = MD5.hashBytes(this.soundData) + ".wav";
         }
         return this.__md5;
      }
      
      private function reduceSizeIfNeeded(param1:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Vector.<int> = null;
         var _loc2_:int = 30 * 44100;
         if(this.rate > 32000 || param1 == 2 || this.format == "float")
         {
            _loc3_ = this.rate > 32000 ? int(this.rate / 2) : this.rate;
            _loc4_ = WAVFile.extractSamples(this.soundData);
            if(this.rate > 32000 || param1 == 2)
            {
               _loc4_ = param1 == 2 ? stereoToMono(_loc4_,_loc3_ < this.rate) : downsample(_loc4_);
            }
            this.setSamples(_loc4_,_loc3_,true);
         }
         else if(this.soundData.length > _loc2_ && "" == this.format)
         {
            this.setSamples(WAVFile.extractSamples(this.soundData),this.rate,true);
         }
      }
      
      public function setSamples(param1:Vector.<int>, param2:int, param3:Boolean = false) : void
      {
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.endian = Endian.LITTLE_ENDIAN;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc4_.writeShort(param1[_loc5_]);
            _loc5_++;
         }
         if(param1.length == 0)
         {
            _loc4_.writeShort(0);
         }
         this.soundID = this.WasEdited;
         this.soundData = WAVFile.encode(_loc4_,param1.length,param2,param3);
         this.format = param3 ? "adpcm" : "";
         this.rate = param2;
         this.sampleCount = param1.length;
      }
      
      public function convertMP3IfNeeded() : void
      {
         var whenDone:Function = null;
         whenDone = function(param1:ScratchSound):void
         {
            Scratch.app.log(LogLevel.INFO,"Converting MP3 to WAV",{"soundName":soundName});
            soundData = param1.soundData;
            format = param1.format;
            rate = param1.rate;
            sampleCount = param1.sampleCount;
         };
         if(this.format == "mp3")
         {
            if(this.soundData)
            {
               MP3Loader.convertToScratchSound("",this.soundData,whenDone);
            }
            else
            {
               Scratch.app.log(LogLevel.WARNING,"No sound data to convert from MP3. Setting empty sound.");
               this.setSamples(new Vector.<int>(),22050);
            }
         }
      }
      
      public function sndplayer() : ScratchSoundPlayer
      {
         var _loc1_:ScratchSoundPlayer = null;
         if(this.format == "squeak")
         {
            _loc1_ = new SqueakSoundPlayer(this.soundData,this.bitsPerSample,this.rate);
         }
         else if(this.format == "" || this.format == "adpcm" || this.format == "float")
         {
            _loc1_ = new ScratchSoundPlayer(this.soundData);
         }
         else
         {
            _loc1_ = new ScratchSoundPlayer(WAVFile.empty());
         }
         _loc1_.scratchSound = this;
         return _loc1_;
      }
      
      public function duplicate() : ScratchSound
      {
         var _loc1_:ScratchSound = new ScratchSound(this.soundName,null);
         _loc1_.setSamples(this.getSamples(),this.rate,this.format == "adpcm");
         return _loc1_;
      }
      
      public function getSamples() : Vector.<int>
      {
         if(this.format == "squeak")
         {
            this.prepareToSave();
         }
         if(this.format == "" || this.format == "adpcm")
         {
            return WAVFile.extractSamples(this.soundData);
         }
         Scratch.app.log(LogLevel.WARNING,"Unknown sound format in getSamples. Returning empty sound.",{"format":this.format});
         return new Vector.<int>(0);
      }
      
      public function getLengthInMsec() : Number
      {
         return 1000 * this.sampleCount / this.rate;
      }
      
      public function toString() : String
      {
         var _loc1_:Number = Math.ceil(this.getLengthInMsec() / 1000);
         var _loc2_:String = "ScratchSound(" + _loc1_ + " secs, " + this.rate;
         if(this.format != "")
         {
            _loc2_ += " " + this.format;
         }
         return _loc2_ + ")";
      }
      
      public function prepareToSave() : void
      {
         var _loc1_:ByteArray = null;
         if(this.format == "squeak")
         {
            _loc1_ = new SqueakSoundDecoder(this.bitsPerSample).decode(this.soundData);
            if(_loc1_.length == 0)
            {
               _loc1_.writeShort(0);
            }
            Scratch.app.log(LogLevel.INFO,"Converting squeak sound to WAV ADPCM",{
               "oldSampleCount":this.sampleCount,
               "newSampleCount":_loc1_.length / 2
            });
            this.sampleCount = _loc1_.length / 2;
            this.soundData = WAVFile.encode(_loc1_,this.sampleCount,this.rate,true);
            this.format = "adpcm";
            this.bitsPerSample = 4;
         }
         this.reduceSizeIfNeeded(1);
         this.soundID = -1;
      }
      
      public function writeJSON(param1:util.JSON) : void
      {
         param1.writeKeyValue("soundName",this.soundName);
         param1.writeKeyValue("soundID",this.soundID);
         param1.writeKeyValue("md5",this.md5);
         param1.writeKeyValue("sampleCount",this.sampleCount);
         param1.writeKeyValue("rate",this.rate);
         param1.writeKeyValue("format",this.format);
      }
      
      public function readJSON(param1:Object) : void
      {
         this.soundName = param1.soundName;
         this.soundID = param1.soundID;
         this.__md5 = param1.md5;
         this.sampleCount = param1.sampleCount;
         this.rate = param1.rate;
         this.format = param1.format;
      }
   }
}

