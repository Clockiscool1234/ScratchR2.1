package util
{
   public class Transition
   {
      
      private static var activeTransitions:Array = [];
      
      private var interpolate:Function;
      
      private var setValue:Function;
      
      private var startValue:*;
      
      private var endValue:*;
      
      private var delta:*;
      
      private var whenDone:Function;
      
      private var startMSecs:uint;
      
      private var duration:uint;
      
      public function Transition(param1:Function, param2:Function, param3:*, param4:*, param5:Number, param6:Function)
      {
         var _loc7_:int = 0;
         super();
         this.interpolate = param1;
         this.setValue = param2;
         this.startValue = param3;
         this.endValue = param4;
         this.whenDone = param6;
         if(param3 is Array)
         {
            this.delta = [];
            _loc7_ = 0;
            while(_loc7_ < param3.length)
            {
               this.delta.push(param4[_loc7_] - param3[_loc7_]);
               _loc7_++;
            }
         }
         else
         {
            this.delta = param4 - param3;
         }
         this.startMSecs = CachedTimer.getCachedTimer();
         this.duration = 1000 * param5;
      }
      
      public static function linear(param1:Function, param2:*, param3:*, param4:Number, param5:Function = null) : void
      {
         activeTransitions.push(new Transition(linearFunc,param1,param2,param3,param4,param5));
      }
      
      public static function quadratic(param1:Function, param2:*, param3:*, param4:Number, param5:Function = null) : void
      {
         activeTransitions.push(new Transition(quadraticFunc,param1,param2,param3,param4,param5));
      }
      
      public static function cubic(param1:Function, param2:*, param3:*, param4:Number, param5:Function = null) : void
      {
         activeTransitions.push(new Transition(cubicFunc,param1,param2,param3,param4,param5));
      }
      
      public static function step(param1:*) : void
      {
         var _loc4_:Transition = null;
         if(activeTransitions.length == 0)
         {
            return;
         }
         var _loc2_:uint = uint(CachedTimer.getCachedTimer());
         var _loc3_:Array = [];
         for each(_loc4_ in activeTransitions)
         {
            if(_loc4_.apply(_loc2_))
            {
               _loc3_.push(_loc4_);
            }
         }
         activeTransitions = _loc3_;
      }
      
      private static function linearFunc(param1:Number) : Number
      {
         return param1;
      }
      
      private static function quadraticFunc(param1:Number) : Number
      {
         return param1 * param1;
      }
      
      private static function cubicFunc(param1:Number) : Number
      {
         return param1 * param1 * param1;
      }
      
      private function apply(param1:uint) : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc2_:int = param1 - this.startMSecs;
         if(_loc2_ < 50)
         {
            this.setValue(this.startValue);
            return true;
         }
         var _loc3_:Number = (param1 - this.startMSecs) / this.duration;
         if(_loc3_ > 1)
         {
            this.setValue(this.endValue);
            if(this.whenDone != null)
            {
               this.whenDone();
            }
            return false;
         }
         if(this.startValue is Array)
         {
            _loc4_ = [];
            _loc5_ = 0;
            while(_loc5_ < this.startValue.length)
            {
               _loc4_.push(this.startValue[_loc5_] + this.delta[_loc5_] * (1 - this.interpolate(1 - _loc3_)));
               _loc5_++;
            }
            this.setValue(_loc4_);
         }
         else
         {
            this.setValue(this.startValue + this.delta * (1 - this.interpolate(1 - _loc3_)));
         }
         return true;
      }
   }
}

