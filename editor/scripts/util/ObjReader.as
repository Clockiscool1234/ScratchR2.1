package util
{
   import blocks.BlockArg;
   import flash.display.BitmapData;
   import flash.errors.IOError;
   import flash.geom.Rectangle;
   import flash.utils.*;
   import scratch.*;
   import sound.*;
   import watchers.*;
   
   public class ObjReader
   {
      
      private const OBJ_REF:int = 99;
      
      private var s:IDataInput;
      
      private var objTable:Array = [];
      
      private const defaultOneBitColorMap:Vector.<uint> = Vector.<uint>([4294967295,4278190080]);
      
      private const defaultColorMap:Vector.<uint> = Vector.<uint>([0,4278190080,4294967295,4286611584,4294901760,4278255360,4278190335,4278255615,4294967040,4294902015,4280295456,4282400832,4284506208,4288651167,4290756543,4292861919,4278716424,4279242768,4279769112,4280821800,4281348144,4281874488,4282927176,4283453520,4283979864,4285032552,4285558896,4286085240,4287072135,4287598479,4288124823,4289177511,4289703855,4290230199,4291282887,4291809231,4292335575,4293388263,4293914607,4294440951,4278190080,4278203136,4278216192,4278229248,4278242304,4278255360,4278190131,4278203187,4278216243,4278229299,4278242355,4278255411,4278190182,4278203238,4278216294,4278229350,4278242406,4278255462,4278190233,4278203289,4278216345,4278229401,4278242457,4278255513,4278190284,4278203340,4278216396,4278229452,4278242508,4278255564,4278190335,4278203391,4278216447,4278229503,4278242559,4278255615,4281532416,4281545472,4281558528,4281571584,4281584640,4281597696,4281532467,4281545523,4281558579,4281571635,4281584691
      ,4281597747,4281532518,4281545574,4281558630,4281571686,4281584742,4281597798,4281532569,4281545625,4281558681,4281571737,4281584793,4281597849,4281532620,4281545676,4281558732,4281571788,4281584844,4281597900,4281532671,4281545727,4281558783,4281571839,4281584895,4281597951,4284874752,4284887808,4284900864,4284913920,4284926976,4284940032,4284874803,4284887859,4284900915,4284913971,4284927027,4284940083,4284874854,4284887910,4284900966,4284914022,4284927078,4284940134,4284874905,4284887961,4284901017,4284914073,4284927129,4284940185,4284874956,4284888012,4284901068,4284914124,4284927180,4284940236,4284875007,4284888063,4284901119,4284914175,4284927231,4284940287,4288217088,4288230144,4288243200,4288256256,4288269312,4288282368,4288217139,4288230195,4288243251,4288256307,4288269363,4288282419,4288217190,4288230246,4288243302,4288256358,4288269414,4288282470,4288217241,4288230297,4288243353,4288256409,4288269465,4288282521,4288217292,4288230348,4288243404,4288256460,4288269516,4288282572
      ,4288217343,4288230399,4288243455,4288256511,4288269567,4288282623,4291559424,4291572480,4291585536,4291598592,4291611648,4291624704,4291559475,4291572531,4291585587,4291598643,4291611699,4291624755,4291559526,4291572582,4291585638,4291598694,4291611750,4291624806,4291559577,4291572633,4291585689,4291598745,4291611801,4291624857,4291559628,4291572684,4291585740,4291598796,4291611852,4291624908,4291559679,4291572735,4291585791,4291598847,4291611903,4291624959,4294901760,4294914816,4294927872,4294940928,4294953984,4294967040,4294901811,4294914867,4294927923,4294940979,4294954035,4294967091,4294901862,4294914918,4294927974,4294941030,4294954086,4294967142,4294901913,4294914969,4294928025,4294941081,4294954137,4294967193,4294901964,4294915020,4294928076,4294941132,4294954188,4294967244,4294902015,4294915071,4294928127,4294941183,4294954239,4294967295]);
      
      public function ObjReader(param1:IDataInput)
      {
         super();
         this.s = param1;
      }
      
      public static function isOldProject(param1:ByteArray) : Boolean
      {
         if(param1.length < 10)
         {
            return false;
         }
         param1.position = 0;
         var _loc2_:String = param1.readUTFBytes(10);
         param1.position = 0;
         return "ScratchV01" == _loc2_ || "ScratchV02" == _loc2_;
      }
      
      public function readInfo() : Object
      {
         var _loc1_:String = this.s.readMultiByte(10,"macintosh");
         if(_loc1_ != "ScratchV01" && _loc1_ != "ScratchV02")
         {
            throw new IOError("Not a valid Scratch file");
         }
         var _loc2_:int = this.s.readInt();
         this.readObjTable();
         var _loc3_:Object = new Object();
         var _loc4_:Array = this.objTable[0][0];
         var _loc5_:int = 0;
         while(_loc5_ < _loc4_.length - 1)
         {
            _loc3_[_loc4_[_loc5_]] = _loc4_[_loc5_ + 1];
            _loc5_ += 2;
         }
         return _loc3_;
      }
      
      public function readObjTable() : Array
      {
         var _loc1_:String = null;
         if(this.s.readMultiByte(4,"macintosh") != "ObjS" || this.s.readByte() != 1)
         {
            throw new IOError();
         }
         if(this.s.readMultiByte(4,"macintosh") != "Stch" || this.s.readByte() != 1)
         {
            throw new IOError();
         }
         this.objTable = [];
         var _loc2_:int = this.s.readInt();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            this.objTable[_loc3_] = this.readObj();
            _loc3_++;
         }
         this.decodeSqueakImages();
         this.instantiateScratchObjects();
         this.fixReferences();
         this.initWatchers();
         this.initListWatchers();
         this.initCostumes();
         this.initSounds();
         return this.objTable;
      }
      
      private function readObj() : Array
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc1_:Array = [];
         var _loc2_:int = int(this.s.readUnsignedByte());
         if(_loc2_ < this.OBJ_REF)
         {
            _loc1_[0] = this.readFixedFormat(_loc2_);
            _loc1_[1] = _loc2_;
         }
         else
         {
            _loc3_ = int(this.s.readUnsignedByte());
            _loc4_ = int(this.s.readUnsignedByte());
            _loc1_[0] = null;
            _loc1_[1] = _loc2_;
            _loc1_[2] = _loc3_;
            _loc5_ = 3;
            while(_loc5_ < 3 + _loc4_)
            {
               _loc1_[_loc5_] = this.readField();
               _loc5_++;
            }
         }
         return _loc1_;
      }
      
      private function readField() : Object
      {
         var _loc2_:int = 0;
         var _loc1_:int = int(this.s.readUnsignedByte());
         if(_loc1_ == this.OBJ_REF)
         {
            _loc2_ = this.s.readUnsignedByte() << 16;
            _loc2_ += this.s.readUnsignedByte() << 8;
            _loc2_ += this.s.readUnsignedByte();
            return new Ref(_loc2_);
         }
         return this.readFixedFormat(_loc1_);
      }
      
      private function readFixedFormat(param1:int) : Object
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:Array = null;
         var _loc4_:ByteArray = new ByteArray();
         switch(param1)
         {
            case 1:
               return null;
            case 2:
               return true;
            case 3:
               return false;
            case 4:
               return this.s.readInt();
            case 5:
               return this.s.readShort();
            case 6:
            case 7:
               _loc6_ = 0;
               _loc7_ = 1;
               _loc2_ = this.s.readShort();
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc6_ += _loc7_ * this.s.readUnsignedByte();
                  _loc7_ *= 256;
                  _loc3_++;
               }
               return _loc6_;
            case 8:
               _loc6_ = this.s.readDouble();
               if(_loc6_ is int)
               {
                  _loc6_ += BlockArg.epsilon;
               }
               return _loc6_;
            case 9:
            case 10:
               _loc2_ = this.s.readInt();
               return this.s.readMultiByte(_loc2_,"macintosh");
            case 11:
               _loc2_ = this.s.readInt();
               if(_loc2_ > 0)
               {
                  this.s.readBytes(_loc4_,0,_loc2_);
               }
               return _loc4_;
            case 12:
               _loc2_ = this.s.readInt();
               if(_loc2_ > 0)
               {
                  this.s.readBytes(_loc4_,0,2 * _loc2_);
               }
               return _loc4_;
            case 13:
               _loc2_ = this.s.readInt();
               _loc5_ = new Array(_loc2_);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc5_[_loc3_] = this.s.readUnsignedInt();
                  _loc3_++;
               }
               return _loc5_;
            case 14:
               _loc2_ = this.s.readInt();
               return this.s.readMultiByte(_loc2_,"utf-8");
            case 20:
            case 21:
            case 22:
            case 23:
               _loc2_ = this.s.readInt();
               _loc5_ = new Array(_loc2_);
               _loc3_ = 0;
               while(_loc3_ < _loc2_)
               {
                  _loc5_[_loc3_] = this.readField();
                  _loc3_++;
               }
               return _loc5_;
            case 24:
            case 25:
               _loc2_ = this.s.readInt();
               _loc5_ = new Array(2 * _loc2_);
               _loc3_ = 0;
               while(_loc3_ < 2 * _loc2_)
               {
                  _loc5_[_loc3_] = this.readField();
                  _loc3_++;
               }
               return _loc5_;
            case 30:
            case 31:
               _loc8_ = this.s.readInt();
               _loc9_ = param1 == 31 ? int(this.s.readUnsignedByte()) : 255;
               _loc10_ = _loc8_ >> 22 & 0xFF;
               _loc11_ = _loc8_ >> 12 & 0xFF;
               _loc12_ = _loc8_ >> 2 & 0xFF;
               return _loc9_ << 24 | _loc10_ << 16 | _loc11_ << 8 | _loc12_;
            case 32:
               _loc5_ = new Array(2);
               _loc5_[0] = this.readField();
               _loc5_[1] = this.readField();
               return _loc5_;
            case 33:
               _loc5_ = new Array(4);
               _loc5_[0] = this.readField();
               _loc5_[1] = this.readField();
               _loc5_[2] = this.readField();
               _loc5_[3] = this.readField();
               return _loc5_;
            case 34:
            case 35:
               _loc13_ = new Array();
               _loc3_ = 0;
               while(_loc3_ < 5)
               {
                  _loc13_[_loc3_] = this.readField();
                  _loc3_++;
               }
               if(param1 == 35)
               {
                  _loc13_[5] = this.readField();
               }
               return _loc13_;
            default:
               throw new IOError("Unknown fixed-format class " + param1);
         }
      }
      
      private function instantiateScratchObjects() : void
      {
         var _loc2_:int = 0;
         var _loc1_:int = 0;
         while(_loc1_ < this.objTable.length)
         {
            _loc2_ = int(this.objTable[_loc1_][1]);
            if(_loc2_ == 124)
            {
               this.objTable[_loc1_][0] = new ScratchSprite();
            }
            if(_loc2_ == 125)
            {
               this.objTable[_loc1_][0] = new ScratchStage();
            }
            if(_loc2_ == 155)
            {
               this.objTable[_loc1_][0] = new Watcher();
            }
            if(_loc2_ == 162)
            {
               this.objTable[_loc1_][0] = new ScratchCostume("uninitialized",null);
            }
            if(_loc2_ == 164)
            {
               this.objTable[_loc1_][0] = new ScratchSound("uninitialized",null);
            }
            if(_loc2_ == 175)
            {
               this.objTable[_loc1_][0] = new ListWatcher();
            }
            _loc1_++;
         }
      }
      
      private function decodeSqueakImages() : void
      {
         var _loc2_:int = 0;
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Rectangle = null;
         var _loc8_:Vector.<uint> = null;
         var _loc9_:BitmapData = null;
         var _loc10_:Vector.<uint> = null;
         var _loc11_:Array = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.objTable.length)
         {
            _loc2_ = int(this.objTable[_loc1_][1]);
            if(_loc2_ == 34 || _loc2_ == 35)
            {
               _loc3_ = this.objTable[_loc1_][0];
               _loc4_ = int(_loc3_[0]);
               _loc5_ = int(_loc3_[1]);
               _loc6_ = int(_loc3_[2]);
               _loc7_ = new Rectangle(0,0,_loc4_,_loc5_);
               _loc8_ = this.decodePixels(this.objTable[_loc3_[4].index][0],_loc6_ == 32);
               _loc9_ = new BitmapData(_loc4_,_loc5_);
               if(_loc6_ <= 8)
               {
                  _loc10_ = _loc6_ == 1 ? this.defaultOneBitColorMap : this.defaultColorMap;
                  if(_loc3_[5] != null)
                  {
                     _loc11_ = this.objTable[_loc3_[5].index][0];
                     _loc10_ = this.buildCustomColormap(_loc6_,_loc11_);
                  }
                  _loc9_.setVector(_loc7_,this.unpackPixels(_loc8_,_loc4_,_loc5_,_loc6_,_loc10_));
               }
               if(_loc6_ == 16)
               {
                  _loc9_.setVector(_loc7_,this.raster16to32(_loc8_,_loc4_,_loc5_));
               }
               if(_loc6_ == 32)
               {
                  _loc9_.setVector(_loc7_,_loc8_);
               }
               this.objTable[_loc1_][0] = _loc9_;
            }
            _loc1_++;
         }
      }
      
      private function fixReferences() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = undefined;
         var _loc5_:Array = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.objTable.length)
         {
            _loc2_ = int(this.objTable[_loc1_][1]);
            if(_loc2_ >= 20 && _loc2_ <= 29)
            {
               _loc5_ = this.objTable[_loc1_][0];
               _loc3_ = 0;
               while(_loc3_ < _loc5_.length)
               {
                  _loc4_ = _loc5_[_loc3_];
                  if(_loc4_ is Ref)
                  {
                     _loc5_[_loc3_] = this.deRef(_loc4_);
                  }
                  _loc3_++;
               }
            }
            if(_loc2_ > this.OBJ_REF)
            {
               _loc3_ = 3;
               while(_loc3_ < this.objTable[_loc1_].length)
               {
                  _loc4_ = this.objTable[_loc1_][_loc3_];
                  if(_loc4_ is Ref)
                  {
                     this.objTable[_loc1_][_loc3_] = this.deRef(_loc4_);
                  }
                  _loc3_++;
               }
            }
            _loc1_++;
         }
      }
      
      private function deRef(param1:*) : Object
      {
         var _loc2_:Array = this.objTable[Ref(param1).index];
         return _loc2_[0] == null ? _loc2_ : _loc2_[0];
      }
      
      private function initCostumes() : void
      {
         var _loc1_:Array = null;
         var _loc2_:ScratchCostume = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:Array = null;
         for each(_loc1_ in this.objTable)
         {
            if(_loc1_[1] == 162)
            {
               _loc2_ = _loc1_[0];
               _loc2_.costumeName = _loc1_[3];
               _loc2_.bitmap = _loc1_[4];
               _loc2_.rotationCenterX = _loc1_[5][0];
               _loc2_.rotationCenterY = _loc1_[5][1];
               _loc3_ = _loc1_[6];
               if(_loc3_ != null && _loc3_.length >= 15)
               {
                  _loc4_ = _loc3_[14];
                  _loc2_.text = "";
                  _loc5_ = 0;
                  while(_loc5_ < _loc4_.length)
                  {
                     _loc2_.text += _loc4_[_loc5_];
                     _loc5_++;
                  }
                  _loc6_ = _loc3_[3];
                  _loc2_.textRect = new Rectangle(_loc6_[0],_loc6_[1],_loc6_[2],_loc6_[3]);
                  _loc2_.textColor = _loc3_[12];
                  _loc2_.fontName = _loc3_[11][0];
                  _loc2_.fontSize = _loc3_[11][1];
               }
               if(_loc1_[7] != null)
               {
                  _loc2_.baseLayerData = _loc1_[7];
                  _loc2_.bitmap = null;
               }
               else
               {
                  _loc2_.baseLayerBitmap = _loc2_.bitmap;
               }
               if(_loc1_[8] != null)
               {
                  _loc2_.bitmap = _loc2_.oldComposite = _loc1_[8];
               }
            }
         }
      }
      
      private function initWatchers() : void
      {
         var _loc1_:Array = null;
         var _loc2_:Watcher = null;
         var _loc3_:int = 0;
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:* = undefined;
         var _loc9_:* = undefined;
         var _loc10_:String = null;
         var _loc11_:String = null;
         var _loc12_:int = 0;
         var _loc13_:* = undefined;
         var _loc14_:Array = null;
         var _loc15_:int = 0;
         for each(_loc1_ in this.objTable)
         {
            if(_loc1_[1] == 155)
            {
               _loc2_ = _loc1_[0];
               _loc3_ = int(_loc1_[2]);
               _loc4_ = _loc1_[3];
               _loc5_ = _loc1_[16];
               _loc6_ = _loc1_[17];
               _loc7_ = _loc1_[18];
               _loc8_ = _loc6_[11];
               _loc9_ = _loc6_[13];
               _loc10_ = _loc6_[14];
               _loc11_ = _loc6_[16];
               _loc12_ = int(_loc7_[6]);
               _loc2_.initWatcher(_loc9_,_loc10_,_loc11_,_loc12_);
               _loc2_.x = _loc4_[0];
               _loc2_.y = _loc4_[1];
               if(_loc3_ > 3)
               {
                  _loc2_.setSliderMinMax(_loc1_[23],_loc1_[24],_loc8_);
               }
               _loc13_ = _loc1_[19];
               _loc14_ = _loc7_[3];
               if(_loc13_ == null)
               {
                  _loc15_ = _loc14_[3] - _loc14_[1] <= 14 ? 1 : 2;
               }
               else
               {
                  _loc15_ = 3;
               }
               _loc2_.setMode(_loc15_);
            }
         }
      }
      
      private function initListWatchers() : void
      {
         var _loc1_:Array = null;
         var _loc2_:ListWatcher = null;
         var _loc3_:Array = null;
         for each(_loc1_ in this.objTable)
         {
            if(_loc1_[1] == 175)
            {
               _loc2_ = _loc1_[0];
               _loc3_ = _loc1_[3];
               if(_loc1_[4] == null)
               {
                  _loc2_.x = _loc2_.y = 5;
               }
               else
               {
                  _loc2_.x = _loc3_[0] + 1;
                  _loc2_.y = _loc3_[1] + 1;
               }
               _loc2_.setWidthHeight(_loc3_[2] - _loc3_[0] - 2,_loc3_[3] - _loc3_[1] - 2);
               _loc2_.listName = _loc1_[11];
               _loc2_.contents = _loc1_[12];
               _loc2_.target = _loc1_[13];
            }
         }
      }
      
      private function initSounds() : void
      {
         var _loc2_:ByteArray = null;
         var _loc3_:Array = null;
         var _loc4_:ScratchSound = null;
         var _loc5_:Array = null;
         var _loc1_:Dictionary = new Dictionary();
         for each(_loc3_ in this.objTable)
         {
            if(_loc3_[1] == 164)
            {
               _loc4_ = _loc3_[0];
               _loc4_.soundName = _loc3_[3];
               if(_loc3_[9] == null)
               {
                  _loc5_ = _loc3_[4];
                  _loc2_ = _loc5_[6];
                  _loc4_.format = "";
                  _loc4_.rate = _loc5_[7];
                  _loc4_.bitsPerSample = 16;
                  _loc4_.sampleCount = _loc2_.length / 2;
                  if(_loc1_[_loc2_] != null)
                  {
                     _loc4_.soundData = _loc1_[_loc2_];
                  }
                  else
                  {
                     _loc4_.soundData = WAVFile.encode(this.reverseBytes(_loc2_),_loc4_.sampleCount,_loc4_.rate,false);
                     _loc1_[_loc2_] = _loc4_.soundData;
                  }
               }
               else
               {
                  _loc2_ = _loc3_[9];
                  _loc4_.format = "squeak";
                  _loc4_.rate = _loc3_[7];
                  _loc4_.bitsPerSample = _loc3_[8];
                  _loc4_.sampleCount = Math.floor(8 * _loc2_.length / _loc4_.bitsPerSample);
                  _loc4_.soundData = _loc2_;
               }
            }
         }
      }
      
      private function reverseBytes(param1:ByteArray) : ByteArray
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = param1.length - 1;
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc2_.writeByte(param1[_loc4_ + 1]);
            _loc2_.writeByte(param1[_loc4_]);
            _loc4_ += 2;
         }
         _loc2_.endian = Endian.LITTLE_ENDIAN;
         return _loc2_;
      }
      
      private function decodePixels(param1:Object, param2:Boolean) : Vector.<uint>
      {
         var _loc3_:Vector.<uint> = null;
         var _loc4_:* = 0;
         var _loc5_:uint = 0;
         var _loc8_:uint = 0;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         if(param1 is Array)
         {
            _loc3_ = Vector.<uint>(param1);
            if(param2)
            {
               _loc4_ = 0;
               while(_loc4_ < _loc3_.length)
               {
                  _loc5_ = _loc3_[_loc4_];
                  if(_loc5_ != 0)
                  {
                     _loc3_[_loc4_] = 0xFF000000 | _loc5_;
                  }
                  _loc4_++;
               }
            }
            return _loc3_;
         }
         var _loc6_:ByteArray = ByteArray(param1);
         var _loc7_:uint = this.decodeInt(_loc6_);
         _loc3_ = new Vector.<uint>(_loc7_);
         _loc4_ = 0;
         while(_loc6_.bytesAvailable > 0 && _loc4_ < _loc7_)
         {
            _loc8_ = this.decodeInt(_loc6_);
            _loc9_ = _loc8_ >> 2;
            _loc10_ = _loc8_ & 3;
            switch(_loc10_)
            {
               case 0:
                  _loc4_ += _loc9_;
                  break;
               case 1:
                  _loc5_ = _loc6_.readUnsignedByte();
                  _loc5_ = uint(_loc5_ << 24 | _loc5_ << 16 | _loc5_ << 8 | _loc5_);
                  if(param2 && _loc5_ != 0)
                  {
                     _loc5_ |= 4278190080;
                  }
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_)
                  {
                     _loc3_[_loc4_++] = _loc5_;
                     _loc11_++;
                  }
                  break;
               case 2:
                  _loc5_ = uint(_loc6_.readInt());
                  if(param2 && _loc5_ != 0)
                  {
                     _loc5_ |= 4278190080;
                  }
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_)
                  {
                     _loc3_[_loc4_++] = _loc5_;
                     _loc11_++;
                  }
                  break;
               case 3:
                  _loc11_ = 0;
                  while(_loc11_ < _loc9_)
                  {
                     _loc5_ = uint(_loc6_.readUnsignedByte() << 24);
                     _loc5_ |= _loc6_.readUnsignedByte() << 16;
                     _loc5_ |= _loc6_.readUnsignedByte() << 8;
                     _loc5_ |= _loc6_.readUnsignedByte();
                     if(param2 && _loc5_ != 0)
                     {
                        _loc5_ |= 4278190080;
                     }
                     _loc3_[_loc4_++] = _loc5_;
                     _loc11_++;
                  }
            }
         }
         return _loc3_;
      }
      
      private function decodeInt(param1:ByteArray) : uint
      {
         var _loc2_:int = int(param1.readUnsignedByte());
         if(_loc2_ <= 223)
         {
            return _loc2_;
         }
         if(_loc2_ <= 254)
         {
            return (_loc2_ - 224) * 256 + param1.readUnsignedByte();
         }
         return param1.readUnsignedInt();
      }
      
      private function unpackPixels(param1:Vector.<uint>, param2:int, param3:int, param4:int, param5:Vector.<uint>) : Vector.<uint>
      {
         var _loc12_:* = 0;
         var _loc13_:uint = 0;
         var _loc14_:int = 0;
         var _loc15_:int = 0;
         var _loc6_:Vector.<uint> = new Vector.<uint>(param2 * param3);
         var _loc7_:int = param1.length / param3;
         var _loc8_:int = (1 << param4) - 1;
         var _loc9_:int = 32 / param4;
         var _loc10_:* = 0;
         var _loc11_:int = 0;
         while(_loc11_ < param3)
         {
            _loc12_ = int(_loc11_ * _loc7_);
            _loc14_ = -1;
            _loc15_ = 0;
            while(_loc15_ < param2)
            {
               if(_loc14_ < 0)
               {
                  _loc14_ = param4 * (_loc9_ - 1);
                  _loc13_ = param1[_loc12_++];
               }
               _loc6_[_loc10_++] = param5[_loc13_ >> _loc14_ & _loc8_];
               _loc14_ -= param4;
               _loc15_++;
            }
            _loc11_++;
         }
         return _loc6_;
      }
      
      private function raster16to32(param1:Vector.<uint>, param2:int, param3:int) : Vector.<uint>
      {
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         var _loc7_:int = 0;
         var _loc8_:* = 0;
         var _loc9_:* = 0;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         var _loc4_:Vector.<uint> = new Vector.<uint>(2 * param1.length);
         var _loc10_:int = 0;
         while(_loc10_ < param3)
         {
            _loc5_ = -1;
            _loc11_ = 0;
            while(_loc11_ < param2)
            {
               if(_loc5_ < 0)
               {
                  _loc5_ = 16;
                  _loc6_ = param1[_loc8_++];
               }
               _loc7_ = _loc6_ >> _loc5_ & 0xFFFF;
               if(_loc7_ != 0)
               {
                  _loc12_ = _loc7_ >> 7 & 0xF8;
                  _loc13_ = _loc7_ >> 2 & 0xF8;
                  _loc14_ = _loc7_ << 3 & 0xF8;
                  _loc7_ = 0xFF000000 | _loc12_ << 16 | _loc13_ << 8 | _loc14_;
               }
               _loc4_[_loc9_++] = _loc7_;
               _loc5_ -= 16;
               _loc11_++;
            }
            _loc10_++;
         }
         return _loc4_;
      }
      
      private function buildCustomColormap(param1:int, param2:Array) : Vector.<uint>
      {
         var _loc3_:Vector.<uint> = new Vector.<uint>(1 << param1);
         var _loc4_:int = 0;
         while(_loc4_ < param2.length)
         {
            _loc3_[_loc4_] = this.objTable[param2[_loc4_].index][0];
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function classIDToName(param1:int) : String
      {
         if(param1 == 9)
         {
            return "String";
         }
         if(param1 == 10)
         {
            return "Symbol";
         }
         if(param1 == 11)
         {
            return "ByteArray";
         }
         if(param1 == 12)
         {
            return "SoundBuffer";
         }
         if(param1 == 13)
         {
            return "Bitmap";
         }
         if(param1 == 14)
         {
            return "UTF8";
         }
         if(param1 == 20)
         {
            return "Array";
         }
         if(param1 == 21)
         {
            return "OrderedCollection";
         }
         if(param1 == 22)
         {
            return "Set";
         }
         if(param1 == 23)
         {
            return "IdentitySet";
         }
         if(param1 == 24)
         {
            return "Dictionary";
         }
         if(param1 == 25)
         {
            return "IdentityDictionary";
         }
         if(param1 == 30)
         {
            return "Color";
         }
         if(param1 == 31)
         {
            return "ColorAlpha";
         }
         if(param1 == 32)
         {
            return "Point";
         }
         if(param1 == 33)
         {
            return "Rectangle";
         }
         if(param1 == 34)
         {
            return "Form";
         }
         if(param1 == 35)
         {
            return "ColorForm";
         }
         if(param1 == 100)
         {
            return "Morph";
         }
         if(param1 == 104)
         {
            return "Alignment";
         }
         if(param1 == 105)
         {
            return "String";
         }
         if(param1 == 106)
         {
            return "UpdatingString";
         }
         if(param1 == 109)
         {
            return "SampledSound";
         }
         if(param1 == 110)
         {
            return "ImageMorph";
         }
         if(param1 == 124)
         {
            return "Sprite";
         }
         if(param1 == 125)
         {
            return "Stage";
         }
         if(param1 == 155)
         {
            return "Watcher";
         }
         if(param1 == 162)
         {
            return "ImageMedia";
         }
         if(param1 == 164)
         {
            return "SoundMedia";
         }
         if(param1 == 171)
         {
            return "MultilineString";
         }
         if(param1 == 173)
         {
            return "WatcherReadoutFrame";
         }
         if(param1 == 174)
         {
            return "WatcherSlider";
         }
         if(param1 == 175)
         {
            return "ListWatcher";
         }
         return "Unknown(" + param1 + ")";
      }
   }
}

class Ref
{
   
   internal var index:int;
   
   public function Ref(param1:int)
   {
      super();
      this.index = param1 - 1;
   }
   
   internal function toString() : String
   {
      return "Ref(" + this.index + ")";
   }
}
