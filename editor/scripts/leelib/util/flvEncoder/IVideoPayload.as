package leelib.util.flvEncoder
{
   import flash.display.BitmapData;
   import flash.utils.ByteArray;
   
   public interface IVideoPayload
   {
      
      function init(param1:int, param2:int) : void;
      
      function make(param1:BitmapData) : ByteArray;
      
      function kill() : void;
   }
}

