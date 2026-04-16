package logging
{
   import util.CachedTimer;
   
   public class LogEntry
   {
      
      private static const tempDate:Date = new Date();
      
      private static const timerOffset:Number = new Date().time - CachedTimer.getFreshTimer();
      
      public var timeStamp:Number;
      
      public var severity:int;
      
      public var messageKey:String;
      
      public var extraData:Object;
      
      public function LogEntry(param1:String, param2:String, param3:Object = null)
      {
         super();
         this.setAll(param1,param2,param3);
      }
      
      public static function getCurrentTime() : Number
      {
         return CachedTimer.getCachedTimer() + timerOffset;
      }
      
      public function setAll(param1:String, param2:String, param3:Object = null) : void
      {
         this.timeStamp = getCurrentTime();
         this.severity = LogLevel.LEVEL.indexOf(param1);
         this.messageKey = param2;
         this.extraData = param3;
      }
      
      private function makeTimeStampString() : String
      {
         tempDate.time = this.timeStamp;
         return tempDate.toLocaleTimeString();
      }
      
      public function toString() : String
      {
         return [this.makeTimeStampString(),LogLevel.LEVEL[this.severity],this.messageKey].join(" | ");
      }
   }
}

