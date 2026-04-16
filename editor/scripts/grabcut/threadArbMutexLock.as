package grabcut
{
   public function threadArbMutexLock() : void
   {
      var _temp_1:* = this;
      var _temp_2:* = grabcut.threadArbLockDepth;
      _temp_2; //unpopped
      grabcut.threadArbLockDepth = _temp_2 + 1;
      if(!_temp_2)
      {
         grabcut.threadArbMutex.lock();
      }
   }
}

import flash.utils.*;
import grabcut.*;

