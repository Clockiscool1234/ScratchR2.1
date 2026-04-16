package util
{
   import flash.utils.ByteArray;
   
   public class Base64Encoder
   {
      
      private static var alphabet:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
      
      public function Base64Encoder()
      {
         super();
      }
      
      public static function encodeString(param1:String) : String
      {
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(param1);
         return encode(_loc2_);
      }
      
      public static function encode(param1:ByteArray) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "";
         param1.position = 0;
         while(param1.bytesAvailable > 2)
         {
            _loc3_ = param1.readUnsignedByte() << 16 | param1.readUnsignedByte() << 8 | param1.readUnsignedByte();
            _loc2_ += alphabet.charAt(_loc3_ >> 18 & 0x3F);
            _loc2_ += alphabet.charAt(_loc3_ >> 12 & 0x3F);
            _loc2_ += alphabet.charAt(_loc3_ >> 6 & 0x3F);
            _loc2_ += alphabet.charAt(_loc3_ & 0x3F);
         }
         if(param1.bytesAvailable == 2)
         {
            _loc3_ = param1.readUnsignedByte() << 16 | param1.readUnsignedByte() << 8;
            _loc2_ += alphabet.charAt(_loc3_ >> 18 & 0x3F);
            _loc2_ += alphabet.charAt(_loc3_ >> 12 & 0x3F);
            _loc2_ += alphabet.charAt(_loc3_ >> 6 & 0x3F);
            _loc2_ += "=";
         }
         if(param1.bytesAvailable == 1)
         {
            _loc3_ = param1.readUnsignedByte() << 16;
            _loc2_ += alphabet.charAt(_loc3_ >> 18 & 0x3F);
            _loc2_ += alphabet.charAt(_loc3_ >> 12 & 0x3F);
            _loc2_ += "==";
         }
         return _loc2_;
      }
      
      public static function decode(param1:String) : ByteArray
      {
         var _loc6_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         while(_loc5_ < param1.length)
         {
            _loc6_ = alphabet.indexOf(param1.charAt(_loc5_));
            if(_loc6_ >= 0)
            {
               _loc3_ = (_loc3_ << 6) + _loc6_;
               _loc4_++;
            }
            if(_loc4_ == 4)
            {
               _loc2_.writeByte(_loc3_ >> 16 & 0xFF);
               _loc2_.writeByte(_loc3_ >> 8 & 0xFF);
               _loc2_.writeByte(_loc3_ & 0xFF);
               _loc3_ = 0;
               _loc4_ = 0;
            }
            _loc5_++;
         }
         if(_loc4_ > 0)
         {
            _loc3_ <<= (4 - _loc4_) * 6;
            _loc2_.writeByte(_loc3_ >> 16 & 0xFF);
            if(_loc4_ > 1)
            {
               _loc2_.writeByte(_loc3_ >> 8 & 0xFF);
            }
            if(_loc4_ > 2)
            {
               _loc2_.writeByte(_loc3_ & 0xFF);
            }
         }
         _loc2_.position = 0;
         return _loc2_;
      }
   }
}

