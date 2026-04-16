package leelib.util.flvEncoder
{
   import flash.utils.ByteArray;
   
   public class ByteArrayFlvEncoder extends FlvEncoder
   {
      
      public function ByteArrayFlvEncoder(param1:Number)
      {
         super(param1);
      }
      
      public function get byteArray() : ByteArray
      {
         return _bytes as ByteArray;
      }
      
      override public function kill() : void
      {
         super.kill();
      }
      
      override protected function makeBytes() : void
      {
         _bytes = new ByteableByteArray();
      }
   }
}

