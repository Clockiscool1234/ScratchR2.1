package leelib.util.flvEncoder
{
   import flash.display.BitmapData;
   import flash.errors.IllegalOperationError;
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   import flash.utils.getQualifiedClassName;
   
   public class FlvEncoder
   {
      
      public static const SAMPLERATE_11KHZ:uint = 11025;
      
      public static const SAMPLERATE_22KHZ:uint = 22050;
      
      public static const SAMPLERATE_44KHZ:uint = 44100;
      
      public static const BLOCK_WIDTH:int = 32;
      
      public static const BLOCK_HEIGHT:int = 32;
      
      protected var _frameRate:Number;
      
      protected var _bytes:IByteable;
      
      private var _duration:Number;
      
      private var _durationPos:int;
      
      private var _hasVideo:Boolean;
      
      private var _frameWidth:int;
      
      private var _frameHeight:int;
      
      private var _hasAudio:Boolean;
      
      private var _sampleRate:uint;
      
      private var _is16Bit:Boolean;
      
      private var _isStereo:Boolean;
      
      private var _isAudioInputFloats:Boolean;
      
      private var _videoPayloadMaker:IVideoPayload;
      
      private var _soundPropertiesByte:uint;
      
      private var _audioFrameSize:uint;
      
      private var _lastTagSize:uint = 0;
      
      private var _frameNum:int = 0;
      
      private var _isStarted:Boolean;
      
      public function FlvEncoder(param1:Number)
      {
         super();
         var _loc2_:String = getQualifiedClassName(this);
         _loc2_ = _loc2_.substr(_loc2_.indexOf("::") + 2);
         if(_loc2_ == "FlvEncoder")
         {
            throw new IllegalOperationError("FlvEncoder must be instantiated thru a subclass (eg, ByteArrayFlvEncoder or FileStreamFlvEncoder)");
         }
         this._frameRate = param1;
         this.makeBytes();
      }
      
      public static function floatsToSignedShorts(param1:ByteArray) : ByteArray
      {
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.endian = Endian.LITTLE_ENDIAN;
         param1.position = 0;
         var _loc3_:int = param1.length / 4;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1.readFloat();
            _loc6_ = _loc5_ * 32768;
            _loc2_.writeShort(_loc6_);
            _loc4_++;
         }
         return _loc2_;
      }
      
      public static function byteArrayIndexOf(param1:ByteArray, param2:ByteArray) : int
      {
         var _loc3_:int = int(param1.position);
         var _loc4_:int = int(param2.position);
         var _loc5_:int = param1.length - param2.length;
         var _loc6_:int = 0;
         while(_loc6_ <= _loc5_)
         {
            if(byteArrayEqualsAt(param1,param2,_loc6_))
            {
               param1.position = _loc3_;
               param2.position = _loc4_;
               return _loc6_;
            }
            _loc6_++;
         }
         param1.position = _loc3_;
         param2.position = _loc4_;
         return -1;
      }
      
      public static function byteArrayEqualsAt(param1:ByteArray, param2:ByteArray, param3:int) : Boolean
      {
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         if(param3 + param2.length > param1.length)
         {
            return false;
         }
         param1.position = param3;
         param2.position = 0;
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc5_ = param1.readByte();
            _loc6_ = param2.readByte();
            if(_loc5_ != _loc6_)
            {
               return false;
            }
            _loc4_++;
         }
         return true;
      }
      
      public static function writeUI24(param1:*, param2:uint) : void
      {
         var _loc3_:int = param2 >> 16;
         var _loc4_:int = param2 >> 8 & 0xFF;
         var _loc5_:int = param2 & 0xFF;
         param1.writeByte(_loc3_);
         param1.writeByte(_loc4_);
         param1.writeByte(_loc5_);
      }
      
      public static function writeUI16(param1:*, param2:uint) : void
      {
         param1.writeByte(param2 >> 8);
         param1.writeByte(param2 & 0xFF);
      }
      
      public static function writeUI4_12(param1:*, param2:uint, param3:uint) : void
      {
         var _loc4_:int = param2 << 4;
         var _loc5_:int = param3 >> 8;
         var _loc6_:int = _loc4_ + _loc5_;
         var _loc7_:int = param3 & 0xFF;
         param1.writeByte(_loc6_);
         param1.writeByte(_loc7_);
      }
      
      protected function makeBytes() : void
      {
      }
      
      public function setVideoProperties(param1:int, param2:int, param3:Class = null) : void
      {
         if(this._isStarted)
         {
            throw new Error("setVideoProperties() must be called before begin()");
         }
         if(!param3)
         {
            this._videoPayloadMaker = new VideoPayloadMaker();
         }
         else
         {
            this._videoPayloadMaker = new param3();
            if(!this._videoPayloadMaker || !(this._videoPayloadMaker is IVideoPayload))
            {
               throw new Error("$customVideoPayloadMakerClass is not of type IVideoPayload");
            }
         }
         this._videoPayloadMaker.init(param1,param2);
         this._frameWidth = param1;
         this._frameHeight = param2;
         this._hasVideo = true;
      }
      
      public function setAudioProperties(param1:uint = 0, param2:Boolean = true, param3:Boolean = false, param4:Boolean = true) : void
      {
         if(this._isStarted)
         {
            throw new Error("setAudioProperties() must be called before begin()");
         }
         if(param1 != SAMPLERATE_44KHZ && param1 != SAMPLERATE_22KHZ && param1 != SAMPLERATE_11KHZ)
         {
            throw new Error("Invalid samplerate value. Use supplied constants (eg, SAMPLERATE_11KHZ)");
         }
         this._sampleRate = param1;
         this._is16Bit = param2;
         this._isStereo = param3;
         this._isAudioInputFloats = param4;
         var _loc5_:Number = this._sampleRate * (this._isStereo ? 2 : 1) * (this._is16Bit ? 2 : 1);
         _loc5_ /= this._frameRate;
         if(this._isAudioInputFloats)
         {
            _loc5_ *= 2;
         }
         this._audioFrameSize = int(_loc5_);
         this._soundPropertiesByte = this.makeSoundPropertiesByte();
         this._hasAudio = true;
      }
      
      public function start() : void
      {
         if(this._isStarted)
         {
            throw new Error("begin() has already been called");
         }
         if(this._hasVideo == false && this._hasAudio == false)
         {
            throw new Error("setVideoProperties() and/or setAudioProperties() must be called first");
         }
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeBytes(this.makeHeader());
         _loc1_.writeUnsignedInt(this._lastTagSize);
         _loc1_.writeBytes(this.makeMetaDataTag());
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes("duration");
         this._durationPos = byteArrayIndexOf(_loc1_,_loc2_) + _loc2_.length + 1;
         this._bytes.writeBytes(_loc1_);
      }
      
      public function addFrame(param1:BitmapData, param2:ByteArray) : void
      {
         var _loc3_:ByteArray = null;
         if(!this._bytes)
         {
            throw new Error("start() must be called first");
         }
         if(!this._hasVideo && Boolean(param1))
         {
            throw new Error("Expecting null for argument 1 because video properties were not defined via setVideoProperties()");
         }
         if(!this._hasAudio && Boolean(param2))
         {
            throw new Error("Expecting null for argument 2 because audio properties were not defined via setAudioProperties()");
         }
         if(this._hasVideo && !param1)
         {
            throw new Error("Expecting value for argument 1");
         }
         if(this._hasAudio && !param2)
         {
            throw new Error("Expecting value for argument 2");
         }
         if(param1)
         {
            this._bytes.writeUnsignedInt(this._lastTagSize);
            this.writeVideoTagTo(this._bytes,param1);
         }
         if(param2)
         {
            this._bytes.writeUnsignedInt(this._lastTagSize);
            _loc3_ = this._isAudioInputFloats ? floatsToSignedShorts(param2) : param2;
            this.writeAudioTagTo(this._bytes,_loc3_);
         }
         ++this._frameNum;
      }
      
      public function updateDurationMetadata() : void
      {
         this._bytes.pos = this._durationPos;
         this._bytes.writeDouble(this._frameNum / this._frameRate);
         this._bytes.pos = this._bytes.len;
      }
      
      protected function get bytes() : IByteable
      {
         return this._bytes;
      }
      
      public function get frameRate() : Number
      {
         return this._frameRate;
      }
      
      public function kill() : void
      {
         this._videoPayloadMaker.kill();
         this._bytes = null;
         this._videoPayloadMaker = null;
      }
      
      public function get audioFrameSize() : uint
      {
         return this._audioFrameSize;
      }
      
      public function get frameWidth() : uint
      {
         return this._frameWidth;
      }
      
      public function get frameHeight() : uint
      {
         return this._frameHeight;
      }
      
      private function makeHeader() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(70);
         _loc1_.writeByte(76);
         _loc1_.writeByte(86);
         _loc1_.writeByte(1);
         var _loc2_:uint = 0;
         if(this._hasVideo)
         {
            _loc2_ += 1;
         }
         if(this._hasAudio)
         {
            _loc2_ += 4;
         }
         _loc1_.writeByte(_loc2_);
         _loc1_.writeUnsignedInt(9);
         return _loc1_;
      }
      
      private function makeMetaDataTag() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         var _loc2_:ByteArray = this.makeMetaData();
         _loc1_.writeByte(18);
         writeUI24(_loc1_,_loc2_.length);
         writeUI24(_loc1_,0);
         _loc1_.writeByte(0);
         writeUI24(_loc1_,0);
         _loc1_.writeBytes(_loc2_);
         this._lastTagSize = _loc1_.length;
         return _loc1_;
      }
      
      private function makeMetaData() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeByte(2);
         writeUI16(_loc1_,"onMetaData".length);
         _loc1_.writeUTFBytes("onMetaData");
         _loc1_.writeByte(8);
         _loc1_.writeUnsignedInt(7);
         writeUI16(_loc1_,"duration".length);
         _loc1_.writeUTFBytes("duration");
         _loc1_.writeByte(0);
         _loc1_.writeDouble(0);
         writeUI16(_loc1_,"width".length);
         _loc1_.writeUTFBytes("width");
         _loc1_.writeByte(0);
         _loc1_.writeDouble(this._frameWidth);
         writeUI16(_loc1_,"height".length);
         _loc1_.writeUTFBytes("height");
         _loc1_.writeByte(0);
         _loc1_.writeDouble(this._frameHeight);
         writeUI16(_loc1_,"framerate".length);
         _loc1_.writeUTFBytes("framerate");
         _loc1_.writeByte(0);
         _loc1_.writeDouble(this._frameRate);
         writeUI16(_loc1_,"videocodecid".length);
         _loc1_.writeUTFBytes("videocodecid");
         _loc1_.writeByte(0);
         _loc1_.writeDouble(3);
         writeUI16(_loc1_,"canSeekToEnd".length);
         _loc1_.writeUTFBytes("canSeekToEnd");
         _loc1_.writeByte(1);
         _loc1_.writeByte(int(true));
         var _loc2_:String = "FlvEncoder v0.9 Lee Felarca";
         writeUI16(_loc1_,"metadatacreator".length);
         _loc1_.writeUTFBytes("metadatacreator");
         _loc1_.writeByte(2);
         writeUI16(_loc1_,_loc2_.length);
         _loc1_.writeUTFBytes(_loc2_);
         writeUI24(_loc1_,9);
         return _loc1_;
      }
      
      private function writeVideoTagTo(param1:IByteable, param2:BitmapData) : void
      {
         var _loc3_:int = param1.pos;
         var _loc4_:ByteArray = this._videoPayloadMaker.make(param2);
         var _loc5_:uint = uint(1000 / this._frameRate * this._frameNum);
         param1.writeByte(9);
         writeUI24(param1,_loc4_.length);
         writeUI24(param1,_loc5_);
         param1.writeByte(0);
         writeUI24(param1,0);
         param1.writeBytes(_loc4_);
         this._lastTagSize = param1.pos - _loc3_;
         _loc4_.length = 0;
         _loc4_ = null;
      }
      
      private function writeAudioTagTo(param1:IByteable, param2:ByteArray) : void
      {
         var _loc3_:int = param1.pos;
         param1.writeByte(8);
         writeUI24(param1,param2.length + 1);
         var _loc4_:uint = uint(1000 / this._frameRate * this._frameNum);
         writeUI24(param1,_loc4_);
         param1.writeByte(0);
         writeUI24(param1,0);
         param1.writeByte(this._soundPropertiesByte);
         param1.writeBytes(param2);
         this._lastTagSize = param1.pos - _loc3_;
      }
      
      private function makeSoundPropertiesByte() : uint
      {
         var _loc1_:uint = 0;
         var _loc2_:int = 0;
         _loc1_ = uint(3 << 4);
         switch(this._sampleRate)
         {
            case SAMPLERATE_11KHZ:
               _loc2_ = 1;
               break;
            case SAMPLERATE_22KHZ:
               _loc2_ = 2;
               break;
            case SAMPLERATE_44KHZ:
               _loc2_ = 3;
         }
         _loc1_ += _loc2_ << 2;
         _loc2_ = this._is16Bit ? 1 : 0;
         _loc1_ += _loc2_ << 1;
         _loc2_ = this._isStereo ? 1 : 0;
         return uint(_loc1_ + (_loc2_ << 0));
      }
   }
}

