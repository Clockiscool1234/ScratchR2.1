package util
{
   import flash.utils.ByteArray;
   import flash.utils.Endian;
   
   public class ZipIO
   {
      
      private static var crcTable:Array = makeCrcTable();
      
      private const Version:int = 10;
      
      private const FileEntryID:uint = 67324752;
      
      private const DirEntryID:uint = 33639248;
      
      private const EndID:uint = 101010256;
      
      private var buf:ByteArray;
      
      private var entries:Array = [];
      
      private var writtenFiles:Object = new Object();
      
      public function ZipIO()
      {
         super();
      }
      
      private static function makeCrcTable() : Array
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc1_:Array = new Array(256);
         var _loc2_:int = 0;
         while(_loc2_ < 256)
         {
            _loc3_ = uint(_loc2_);
            _loc4_ = 0;
            while(_loc4_ < 8)
            {
               if((_loc3_ & 1) != 0)
               {
                  _loc3_ = uint(0xEDB88320 ^ _loc3_ >>> 1);
               }
               else
               {
                  _loc3_ >>>= 1;
               }
               _loc4_++;
            }
            _loc1_[_loc2_] = _loc3_;
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function read(param1:ByteArray) : Array
      {
         var _loc2_:int = 0;
         var _loc5_:Entry = null;
         this.buf = param1;
         this.buf.endian = Endian.LITTLE_ENDIAN;
         this.entries = [];
         this.scanForEndRecord();
         var _loc3_:int = this.readEndRecord();
         _loc2_ = 0;
         while(_loc2_ < _loc3_)
         {
            this.entries.push(this.readDirEntry());
            _loc2_++;
         }
         var _loc4_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < this.entries.length)
         {
            _loc5_ = this.entries[_loc2_];
            this.readFile(_loc5_);
            _loc4_.push([_loc5_.name,_loc5_.data]);
            _loc2_++;
         }
         return _loc4_;
      }
      
      public function recover(param1:ByteArray) : Array
      {
         var i:int;
         var e:Entry = null;
         var data:ByteArray = param1;
         var result:Array = [];
         this.buf = data;
         this.buf.endian = Endian.LITTLE_ENDIAN;
         i = 0;
         while(i < this.buf.length - 4)
         {
            if(this.buf[i] == 80)
            {
               this.buf.position = i;
               if(this.buf.readUnsignedInt() == this.FileEntryID)
               {
                  e = new Entry();
                  e.offset = i;
                  try
                  {
                     this.readFile(e,true);
                  }
                  catch(e:*)
                  {
                     e = null;
                  }
                  if(e)
                  {
                     result.push([e.name,e.data]);
                  }
               }
            }
            i++;
         }
         return result;
      }
      
      private function readFile(param1:Entry, param2:Boolean = false) : void
      {
         this.buf.position = param1.offset;
         if(this.buf.readUnsignedInt() != this.FileEntryID)
         {
            throw Error("zip: bad local file header");
         }
         var _loc3_:int = int(this.buf.readUnsignedShort());
         var _loc4_:int = int(this.buf.readUnsignedShort());
         var _loc5_:int = int(this.buf.readUnsignedShort());
         var _loc6_:uint = this.buf.readUnsignedInt();
         var _loc7_:uint = this.buf.readUnsignedInt();
         var _loc8_:uint = this.buf.readUnsignedInt();
         var _loc9_:uint = this.buf.readUnsignedInt();
         var _loc10_:int = int(this.buf.readUnsignedShort());
         var _loc11_:int = int(this.buf.readUnsignedShort());
         var _loc12_:String = this.buf.readUTFBytes(_loc10_);
         var _loc13_:ByteArray = new ByteArray();
         if(_loc11_ > 0)
         {
            this.buf.readBytes(_loc13_,0,_loc11_);
         }
         if((_loc4_ & 1) != 0)
         {
            throw Error("cannot read encrypted zip files");
         }
         if(_loc5_ != 0 && _loc5_ != 8)
         {
            throw Error("Cannot handle zip compression method " + _loc5_);
         }
         if(!param2 && (_loc4_ & 8) != 0)
         {
            _loc8_ = param1.compressedSize;
            _loc9_ = param1.size;
            _loc7_ = param1.crc;
         }
         param1.name = _loc12_;
         param1.data = new ByteArray();
         if(_loc8_ > 0)
         {
            this.buf.readBytes(param1.data,0,_loc8_);
         }
         if(_loc5_ == 8)
         {
            param1.data.inflate();
         }
         if(param1.data.length != _loc9_)
         {
            throw Error("Bad uncompressed size");
         }
         if(_loc7_ != this.computeCRC(param1.data))
         {
            throw Error("Bad CRC");
         }
      }
      
      private function readDirEntry() : Entry
      {
         if(this.buf.readUnsignedInt() != this.DirEntryID)
         {
            throw Error("zip: bad central directory entry");
         }
         var _loc1_:int = int(this.buf.readUnsignedShort());
         var _loc2_:int = int(this.buf.readUnsignedShort());
         var _loc3_:int = int(this.buf.readUnsignedShort());
         var _loc4_:int = int(this.buf.readUnsignedShort());
         var _loc5_:uint = this.buf.readUnsignedInt();
         var _loc6_:uint = this.buf.readUnsignedInt();
         var _loc7_:uint = this.buf.readUnsignedInt();
         var _loc8_:uint = this.buf.readUnsignedInt();
         var _loc9_:int = int(this.buf.readUnsignedShort());
         var _loc10_:int = int(this.buf.readUnsignedShort());
         var _loc11_:int = int(this.buf.readUnsignedShort());
         var _loc12_:int = int(this.buf.readUnsignedShort());
         var _loc13_:int = int(this.buf.readUnsignedShort());
         var _loc14_:uint = this.buf.readUnsignedInt();
         var _loc15_:uint = this.buf.readUnsignedInt();
         var _loc16_:String = this.buf.readUTFBytes(_loc9_);
         var _loc17_:ByteArray = new ByteArray();
         if(_loc10_ > 0)
         {
            this.buf.readBytes(_loc17_,0,_loc10_);
         }
         var _loc18_:String = this.buf.readUTFBytes(_loc11_);
         var _loc19_:Entry = new Entry();
         _loc19_.name = _loc16_;
         _loc19_.time = _loc5_;
         _loc19_.offset = _loc15_;
         _loc19_.size = _loc8_;
         _loc19_.compressedSize = _loc7_;
         _loc19_.crc = _loc6_;
         return _loc19_;
      }
      
      private function readEndRecord() : int
      {
         if(this.buf.readUnsignedInt() != this.EndID)
         {
            throw Error("zip: bad zip end record");
         }
         var _loc1_:int = int(this.buf.readUnsignedShort());
         var _loc2_:int = int(this.buf.readUnsignedShort());
         var _loc3_:int = int(this.buf.readUnsignedShort());
         var _loc4_:int = int(this.buf.readUnsignedShort());
         var _loc5_:uint = this.buf.readUnsignedInt();
         var _loc6_:uint = this.buf.readUnsignedInt();
         var _loc7_:String = this.buf.readUTF();
         if(_loc1_ != _loc2_ || _loc3_ != _loc4_)
         {
            throw Error("cannot read multiple disk zip files");
         }
         this.buf.position = _loc6_;
         return _loc4_;
      }
      
      private function scanForEndRecord() : void
      {
         var _loc1_:* = int(this.buf.length - 4);
         while(_loc1_ >= 0)
         {
            if(this.buf[_loc1_] == 80)
            {
               this.buf.position = _loc1_;
               if(this.buf.readUnsignedInt() == this.EndID)
               {
                  this.buf.position = _loc1_;
                  return;
               }
            }
            _loc1_--;
         }
         throw new Error("Could not find zip directory; bad zip file?");
      }
      
      public function startWrite() : void
      {
         this.buf = new ByteArray();
         this.buf.endian = Endian.LITTLE_ENDIAN;
         this.entries = [];
         this.writtenFiles = new Object();
      }
      
      public function write(param1:String, param2:*, param3:Boolean = false) : void
      {
         if(this.writtenFiles[param1] != undefined)
         {
            throw new Error("duplicate file name: " + param1);
         }
         this.writtenFiles[param1] = true;
         var _loc4_:Entry = new Entry();
         _loc4_.name = param1;
         _loc4_.time = this.dosTime(new Date().time);
         _loc4_.offset = this.buf.position;
         _loc4_.compressionMethod = 0;
         _loc4_.data = new ByteArray();
         if(param2 is String)
         {
            _loc4_.data.writeUTFBytes(String(param2));
         }
         else
         {
            _loc4_.data.writeBytes(param2);
         }
         _loc4_.size = _loc4_.data.length;
         _loc4_.crc = this.computeCRC(_loc4_.data);
         if(param3)
         {
            _loc4_.compressionMethod = 8;
            _loc4_.data.deflate();
         }
         _loc4_.compressedSize = _loc4_.data.length;
         this.entries.push(_loc4_);
         this.writeFileHeader(_loc4_);
         this.buf.writeBytes(_loc4_.data);
      }
      
      public function endWrite() : ByteArray
      {
         if(this.entries.length < 1)
         {
            throw new Error("A zip file must have at least one entry");
         }
         var _loc1_:uint = this.buf.position;
         var _loc2_:int = 0;
         while(_loc2_ < this.entries.length)
         {
            this.writeDirectoryEntry(this.entries[_loc2_]);
            _loc2_++;
         }
         this.writeEndRecord(_loc1_,this.buf.position - _loc1_);
         this.buf.position = 0;
         return this.buf;
      }
      
      private function writeFileHeader(param1:Entry) : void
      {
         this.buf.writeUnsignedInt(this.FileEntryID);
         this.buf.writeShort(this.Version);
         this.buf.writeShort(0);
         this.buf.writeShort(param1.compressionMethod);
         this.buf.writeUnsignedInt(param1.time);
         this.buf.writeUnsignedInt(param1.crc);
         this.buf.writeUnsignedInt(param1.compressedSize);
         this.buf.writeUnsignedInt(param1.size);
         this.buf.writeShort(param1.name.length);
         this.buf.writeShort(0);
         this.buf.writeUTFBytes(param1.name);
      }
      
      private function writeDirectoryEntry(param1:Entry) : void
      {
         this.buf.writeUnsignedInt(this.DirEntryID);
         this.buf.writeShort(this.Version);
         this.buf.writeShort(this.Version);
         this.buf.writeShort(0);
         this.buf.writeShort(param1.compressionMethod);
         this.buf.writeUnsignedInt(param1.time);
         this.buf.writeUnsignedInt(param1.crc);
         this.buf.writeUnsignedInt(param1.compressedSize);
         this.buf.writeUnsignedInt(param1.size);
         this.buf.writeShort(param1.name.length);
         this.buf.writeShort(0);
         this.buf.writeShort(0);
         this.buf.writeShort(0);
         this.buf.writeShort(0);
         this.buf.writeUnsignedInt(0);
         this.buf.writeUnsignedInt(param1.offset);
         this.buf.writeUTFBytes(param1.name);
      }
      
      private function writeEndRecord(param1:uint, param2:uint) : void
      {
         this.buf.writeUnsignedInt(this.EndID);
         this.buf.writeShort(0);
         this.buf.writeShort(0);
         this.buf.writeShort(this.entries.length);
         this.buf.writeShort(this.entries.length);
         this.buf.writeUnsignedInt(param2);
         this.buf.writeUnsignedInt(param1);
         this.buf.writeUTF("");
      }
      
      public function dosTime(param1:Number) : uint
      {
         var _loc2_:Date = new Date(param1);
         return (_loc2_.fullYear - 1980 & 0x7F) << 25 | _loc2_.month + 1 << 21 | _loc2_.day << 16 | _loc2_.hours << 11 | _loc2_.minutes << 5 | _loc2_.seconds >> 1;
      }
      
      private function computeCRC(param1:ByteArray) : uint
      {
         var _loc2_:uint = 0;
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 4294967295;
         while(--_loc3_ >= 0)
         {
            _loc4_ = uint(crcTable[(_loc4_ ^ param1[_loc2_++]) & 0xFF] ^ _loc4_ >>> 8);
         }
         return ~_loc4_ & 0xFFFFFFFF;
      }
   }
}

import flash.utils.ByteArray;

class Entry
{
   
   public var name:String;
   
   public var time:uint;
   
   public var offset:uint;
   
   public var compressionMethod:int;
   
   public var size:uint;
   
   public var compressedSize:uint;
   
   public var data:ByteArray;
   
   public var crc:uint;
   
   public function Entry()
   {
      super();
   }
}
