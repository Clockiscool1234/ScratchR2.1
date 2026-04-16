package grabcut
{
   public function ptr2funInit() : *
   {
      var _loc1_:Vector.<Function> = null;
      if(typeof ptr2fun != "undefined" && ptr2fun == null && grabcut.ptr2fun_init is Array)
      {
         var _temp_3:* = new Vector.<Function>();
         _temp_3.push.apply(null,grabcut.ptr2fun_init);
         grabcut.ptr2fun_init.length = 0;
         grabcut.ptr2fun_init = _temp_3;
      }
      return grabcut.ptr2fun_init;
   }
}

import flash.utils.*;
import grabcut.*;

const §6§:*;
