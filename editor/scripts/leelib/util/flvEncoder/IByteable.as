package leelib.util.flvEncoder
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public interface IByteable extends IDataInput, IDataOutput
   {
      
      function get pos() : Number;
      
      function set pos(param1:Number) : void;
      
      function get len() : Number;
      
      function kill() : void;
   }
}

