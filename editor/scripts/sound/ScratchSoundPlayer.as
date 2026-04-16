package sound
{
   import flash.events.*;
   import flash.media.*;
   import flash.utils.*;
   import scratch.ScratchSound;
   import util.CachedTimer;
   
   public class ScratchSoundPlayer
   {
      
      public static var activeSounds:Array = [];
      
      public var scratchSound:ScratchSound;
      
      public var dataBytes:ByteArray;
      
      public var readPosition:int;
      
      protected var soundData:ByteArray;
      
      protected var startOffset:int;
      
      protected var endOffset:int;
      
      protected var stepSize:Number;
      
      private var adpcmBlockSize:int;
      
      protected var bytePosition:int;
      
      public var soundChannel:SoundChannel;
      
      private var lastBufferTime:uint;
      
      public var client:*;
      
      public var volume:Number = 1;
      
      public var savedVolume:Number;
      
      private var lastClientVolume:Number;
      
      protected var getSample:Function;
      
      private var fraction:Number = 0;
      
      private var thisSample:int;
      
      private var nextSample:int;
      
      private const indexTable:Array;
      
      private const stepTable:Array;
      
      private var sample:int = 0;
      
      private var index:int = 0;
      
      private var lastByte:int = -1;
      
      public function ScratchSoundPlayer(param1:ByteArray)
      {
         var info:* = undefined;
         var wavFileData:ByteArray = param1;
         this.indexTable = [-1,-1,-1,-1,2,4,6,8,-1,-1,-1,-1,2,4,6,8];
         this.stepTable = [7,8,9,10,11,12,13,14,16,17,19,21,23,25,28,31,34,37,41,45,50,55,60,66,73,80,88,97,107,118,130,143,157,173,190,209,230,253,279,307,337,371,408,449,494,544,598,658,724,796,876,963,1060,1166,1282,1411,1552,1707,1878,2066,2272,2499,2749,3024,3327,3660,4026,4428,4871,5358,5894,6484,7132,7845,8630,9493,10442,11487,12635,13899,15289,16818,18500,20350,22385,24623,27086,29794,32767];
         super();
         this.readPosition = 0;
         this.getSample = this.getSample16Uncompressed;
         if(wavFileData != null)
         {
            try
            {
               info = WAVFile.decode(wavFileData);
               this.soundData = wavFileData;
               this.startOffset = info.sampleDataStart;
               this.endOffset = this.startOffset + info.sampleDataSize;
               this.stepSize = info.samplesPerSecond / 44100;
               if(info.encoding == 17)
               {
                  this.adpcmBlockSize = info.adpcmBlockSize;
                  this.getSample = this.getSampleADPCM;
               }
               else
               {
                  if(info.bitsPerSample == 8)
                  {
                     this.getSample = this.getSample8Uncompressed;
                  }
                  if(info.bitsPerSample == 16)
                  {
                     this.getSample = this.getSample16Uncompressed;
                  }
               }
            }
            catch(e:*)
            {
               Scratch.app.logException(e);
            }
         }
      }
      
      public static function stopAllSounds() : void
      {
         var _loc2_:ScratchSoundPlayer = null;
         var _loc1_:Array = activeSounds;
         activeSounds = [];
         for each(_loc2_ in _loc1_)
         {
            _loc2_.stopPlaying();
         }
      }
      
      public function isPlaying(param1:ByteArray = null) : Boolean
      {
         return activeSounds.indexOf(this) > -1 && (!param1 || this.soundData == param1);
      }
      
      public function atEnd() : Boolean
      {
         return this.soundChannel == null;
      }
      
      public function stopPlaying() : void
      {
         var _loc2_:SoundChannel = null;
         if(this.soundChannel != null)
         {
            _loc2_ = this.soundChannel;
            this.soundChannel = null;
            _loc2_.stop();
            _loc2_.dispatchEvent(new Event(Event.SOUND_COMPLETE));
         }
         var _loc1_:int = activeSounds.indexOf(this);
         if(_loc1_ >= 0)
         {
            activeSounds.splice(_loc1_,1);
         }
         this.dataBytes = null;
      }
      
      public function startPlaying(param1:Function = null) : void
      {
         this.readPosition = 0;
         this.dataBytes = new ByteArray();
         this.dataBytes.position = 0;
         this.stopIfAlreadyPlaying();
         activeSounds.push(this);
         this.bytePosition = this.startOffset;
         this.nextSample = this.getSample();
         var _loc2_:Sound = new Sound();
         _loc2_.addEventListener(SampleDataEvent.SAMPLE_DATA,this.writeSampleData);
         this.soundChannel = _loc2_.play();
         if(this.soundChannel)
         {
            if(param1 != null)
            {
               this.soundChannel.addEventListener(Event.SOUND_COMPLETE,param1);
            }
         }
         else
         {
            this.stopPlaying();
            if(param1 != null)
            {
               param1();
            }
         }
      }
      
      protected function stopIfAlreadyPlaying() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         if(this.scratchSound == null)
         {
            return;
         }
         _loc2_ = 0;
         while(_loc2_ < activeSounds.length)
         {
            if(activeSounds[_loc2_].scratchSound == this.scratchSound)
            {
               activeSounds[_loc2_].stopPlaying();
               _loc1_ = true;
            }
            _loc2_++;
         }
         if(_loc1_)
         {
            _loc3_ = [];
            _loc2_ = 0;
            while(_loc2_ < activeSounds.length)
            {
               if(!activeSounds[_loc2_].atEnd())
               {
                  _loc3_.push(activeSounds[_loc2_]);
               }
               _loc2_++;
            }
            activeSounds = _loc3_;
         }
      }
      
      protected function noteFinished() : void
      {
         this.bytePosition = this.endOffset;
      }
      
      private function writeSampleData(param1:SampleDataEvent) : void
      {
         var _loc2_:int = 0;
         var _loc4_:Number = NaN;
         if(this.lastBufferTime != 0 && CachedTimer.getCachedTimer() - this.lastBufferTime > 230)
         {
            this.soundChannel = null;
            this.stopPlaying();
            return;
         }
         this.updateVolume();
         var _loc3_:ByteArray = param1.data;
         _loc2_ = 0;
         while(_loc2_ < 4096)
         {
            _loc4_ = this.interpolatedSample();
            _loc3_.writeFloat(_loc4_);
            _loc3_.writeFloat(_loc4_);
            _loc2_++;
         }
         this.dataBytes.writeBytes(_loc3_);
         if(this.bytePosition >= this.endOffset && this.lastBufferTime == 0)
         {
            this.lastBufferTime = CachedTimer.getCachedTimer();
         }
      }
      
      protected function interpolatedSample() : Number
      {
         this.fraction += this.stepSize;
         while(this.fraction >= 1)
         {
            this.thisSample = this.nextSample;
            this.nextSample = this.getSample();
            --this.fraction;
         }
         var _loc1_:int = this.fraction == 0 ? this.thisSample : int(this.thisSample + this.fraction * (this.nextSample - this.thisSample));
         return this.volume * _loc1_ / 32768;
      }
      
      private function getSample16Uncompressed() : int
      {
         var _loc1_:int = 0;
         if(this.bytePosition <= this.endOffset - 2)
         {
            _loc1_ = (this.soundData[this.bytePosition + 1] << 8) + this.soundData[this.bytePosition];
            if(_loc1_ > 32767)
            {
               _loc1_ -= 65536;
            }
            this.bytePosition += 2;
         }
         else
         {
            this.bytePosition = this.endOffset;
         }
         return _loc1_;
      }
      
      private function getSample8Uncompressed() : int
      {
         if(this.bytePosition >= this.endOffset)
         {
            return 0;
         }
         return this.soundData[this.bytePosition++] - 128 << 8;
      }
      
      public function updateVolume() : void
      {
         if(this.client == null)
         {
            this.volume = 1;
            return;
         }
         if(this.client.volume == this.lastClientVolume)
         {
            return;
         }
         this.volume = Math.max(0,Math.min(this.client.volume / 100,1));
         this.lastClientVolume = this.client.volume;
      }
      
      private function getSampleADPCM() : int
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if((this.bytePosition - this.startOffset) % this.adpcmBlockSize == 0 && this.lastByte < 0)
         {
            if(this.bytePosition > this.endOffset - 4)
            {
               return 0;
            }
            this.sample = (this.soundData[this.bytePosition + 1] << 8) + this.soundData[this.bytePosition];
            if(this.sample > 32767)
            {
               this.sample -= 65536;
            }
            this.index = this.soundData[this.bytePosition + 2];
            this.bytePosition += 4;
            if(this.index > 88)
            {
               this.index = 88;
            }
            this.lastByte = -1;
            return this.sample;
         }
         if(this.lastByte < 0)
         {
            if(this.bytePosition >= this.endOffset)
            {
               return 0;
            }
            this.lastByte = this.soundData[this.bytePosition++];
            _loc2_ = this.lastByte & 0x0F;
         }
         else
         {
            _loc2_ = this.lastByte >> 4 & 0x0F;
            this.lastByte = -1;
         }
         _loc1_ = int(this.stepTable[this.index]);
         _loc3_ = 0;
         if(_loc2_ & 4)
         {
            _loc3_ += _loc1_;
         }
         if(_loc2_ & 2)
         {
            _loc3_ += _loc1_ >> 1;
         }
         if(_loc2_ & 1)
         {
            _loc3_ += _loc1_ >> 2;
         }
         _loc3_ += _loc1_ >> 3;
         this.index += this.indexTable[_loc2_];
         if(this.index > 88)
         {
            this.index = 88;
         }
         if(this.index < 0)
         {
            this.index = 0;
         }
         this.sample += _loc2_ & 8 ? -_loc3_ : _loc3_;
         if(this.sample > 32767)
         {
            this.sample = 32767;
         }
         if(this.sample < -32768)
         {
            this.sample = -32768;
         }
         return this.sample;
      }
   }
}

