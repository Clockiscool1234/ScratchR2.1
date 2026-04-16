include "grabcut/ptr2funInit.as";
include "grabcut/threadArbMutexLock.as";
include "grabcut/threadArbMutexUnlock.as";
include "grabcut/threadArbCondsNotify.as";
include "grabcut/threadArbCondWait.as";
include "grabcut/yield.as";
include "grabcut/newThread.as";
include "grabcut/sbrk.as";

import flash.utils.*;
import grabcut.*;

§__force_ordering_ns_383148cf-17ca-476c-b777-a717eaf48f6f§;
if(!grabcut.ptr2fun_init.length)
{
   grabcut.ptr2fun_init[0] = function():void
   {
      throw new Error("null function pointer called");
   };
   grabcut.ptr2fun_init.length = 1;
}
var _temp_13:* = this;
grabcut.ram_init;
_temp_13;
grabcut.ram_init.endian = Endian.LITTLE_ENDIAN;
if(grabcut.ram_init.length < grabcut.domainClass.MIN_DOMAIN_MEMORY_LENGTH)
{
   grabcut.ram_init.length = grabcut.domainClass.MIN_DOMAIN_MEMORY_LENGTH;
}
grabcut.domainClass.currentDomain.domainMemory = grabcut.ram_init;

