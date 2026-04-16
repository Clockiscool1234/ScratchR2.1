package grabcut
{
   public function threadArbMutexUnlock() : void
   {
      var _temp_1:* = this;
      var _loc1_:Number = grabcut.threadArbLockDepth - 1;
      _loc1_; //unpopped
      grabcut.threadArbLockDepth = _loc1_;
      if(!_temp_4)
      {
         grabcut.threadArbMutex.unlock();
      }
   }
}

import flash.utils.*;
import grabcut.*;

