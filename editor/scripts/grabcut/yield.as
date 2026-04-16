package grabcut
{
   public function yield(param1:int = 1) : void
   {
      var _temp_1:* = this;
      var _loc2_:* = undefined;
      if(!grabcut.yieldCond)
      {
         _loc2_ = new mutexClass();
         _loc2_.lock();
         grabcut.yieldCond = new conditionClass(_loc2_);
      }
      grabcut.yieldCond.wait(param1);
   }
}

import flash.utils.*;
import grabcut.*;

