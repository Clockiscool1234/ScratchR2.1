package grabcut
{
   public function sbrk(param1:int, param2:int) : int
   {
      var size:int;
      var align:int;
      var curLen:int;
      var result:int;
      var newLen:int;
      var casLen:int;
      var _temp_1:* = this;
      casLen = 0;
      size = param1;
      align = param2;
      curLen = int(grabcut.ram_init.length);
      result = curLen + align - 1 & -align;
      newLen = result + size;
      if(grabcut.workerClass)
      {
         while(true)
         {
            try
            {
               casLen = int(grabcut.ram_init.atomicCompareAndSwapLength(curLen,newLen));
            }
            catch(e:*)
            {
               var _temp_2:* = this;
               var _temp_3:* = e;
               if(grabcut.throwWhenOutOfMemory)
               {
                  throw e;
               }
               return -1;
            }
            if(casLen == curLen)
            {
               break;
            }
            curLen = casLen;
            result = curLen + align - 1 & -align;
            newLen = result + size;
         }
      }
      else
      {
         try
         {
            grabcut.ram_init.length = newLen;
         }
         catch(e:*)
         {
            var _temp_5:* = this;
            var _temp_6:* = e;
            if(grabcut.throwWhenOutOfMemory)
            {
               throw e;
            }
            return -1;
         }
      }
      return result;
   }
}

import flash.utils.*;
import grabcut.*;

