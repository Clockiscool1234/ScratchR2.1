package leelib.util.flvEncoder
{
   import flash.utils.ByteArray;
   
   public class ByteableByteArray extends ByteArray implements IByteable
   {
      
      public function ByteableByteArray()
      {
         super();
      }
      
      public function get canPosition() : Boolean
      {
         return true;
      }
      
      public function get pos() : Number
      {
         return this.position;
      }
      
      public function set pos(param1:Number) : void
      {
         this.position = uint(param1);
      }
      
      public function get len() : Number
      {
         return this.length;
      }
      
      public function set len(param1:Number) : void
      {
         this.length = uint(param1);
      }
      
      public function kill() : void
      {
         this.length = 0;
      }
   }
}

