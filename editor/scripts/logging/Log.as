package logging
{
   import flash.system.Capabilities;
   import util.JSON;
   
   public class Log
   {
      
      public var echoToJS:Boolean = true;
      
      public const logBuffer:Vector.<LogEntry> = new Vector.<LogEntry>(0);
      
      private var fixedBuffer:Boolean;
      
      private var nextIndex:uint;
      
      public function Log(param1:uint)
      {
         super();
         this.fixedBuffer = param1 > 0;
         if(this.fixedBuffer)
         {
            this.logBuffer.length = param1;
         }
         this.nextIndex = 0;
      }
      
      public function log(param1:String, param2:String, param3:Object = null) : LogEntry
      {
         var entry:LogEntry = null;
         var entryString:String = null;
         var extraString:String = null;
         var severity:String = param1;
         var messageKey:String = param2;
         var extraData:Object = param3;
         var getEntryString:Function = function():String
         {
            return entryString || (entryString = entry.toString());
         };
         var getExtraString:Function = function():String
         {
            if(!extraString)
            {
               try
               {
                  extraString = util.JSON.stringify(extraData);
               }
               catch(e:*)
               {
                  extraString = "<extraData stringify failed>";
               }
            }
            return extraString;
         };
         entry = this.logBuffer[this.nextIndex];
         if(entry)
         {
            entry.setAll(severity,messageKey,extraData);
         }
         else
         {
            entry = new LogEntry(severity,messageKey,extraData);
            this.logBuffer[this.nextIndex] = entry;
         }
         ++this.nextIndex;
         if(this.fixedBuffer)
         {
            this.nextIndex %= this.logBuffer.length;
         }
         if(Capabilities.isDebugger)
         {
         }
         if(Scratch.app.jsEnabled)
         {
            if(this.echoToJS)
            {
               if(extraData)
               {
                  Scratch.app.externalCall("console.log",null,getEntryString(),extraData);
               }
               else
               {
                  Scratch.app.externalCall("console.log",null,getEntryString());
               }
            }
            if(LogLevel.TRACK == severity)
            {
               Scratch.app.externalCall("JStrackEvent",null,messageKey,extraData ? getExtraString() : null);
            }
         }
         return entry;
      }
      
      public function report(param1:String = "dbg") : Object
      {
         var _loc7_:LogEntry = null;
         var _loc2_:int = LogLevel.LEVEL.indexOf(param1);
         var _loc3_:uint = this.fixedBuffer ? this.nextIndex : 0;
         var _loc4_:uint = this.logBuffer.length;
         var _loc5_:Array = [];
         var _loc6_:uint = 0;
         while(_loc6_ < _loc4_)
         {
            _loc7_ = this.logBuffer[(_loc3_ + _loc6_) % _loc4_];
            if(Boolean(_loc7_) && _loc7_.severity <= _loc2_)
            {
               _loc5_.push(_loc7_.toString());
               if(_loc7_.extraData)
               {
                  _loc5_.push(_loc7_.extraData);
               }
            }
            _loc6_++;
         }
         return _loc5_;
      }
   }
}

