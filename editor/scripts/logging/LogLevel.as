package logging
{
   public class LogLevel
   {
      
      public static const ERROR:String = "err";
      
      public static const WARNING:String = "wrn";
      
      public static const TRACK:String = "trk";
      
      public static const INFO:String = "inf";
      
      public static const DEBUG:String = "dbg";
      
      public static const LEVEL:Array = [ERROR,WARNING,TRACK,INFO,DEBUG];
      
      public function LogLevel()
      {
         super();
      }
   }
}

