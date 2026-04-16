package grabcut
{
   internal class PtrLink
   {
      
      public const ptr:int = 0;
      
      public var next:PtrLink;
      
      public function PtrLink(param1:int)
      {
         super();
         this.ptr = param1;
      }
   }
}

import flash.utils.*;
import grabcut.*;
import grabcut.kernel.*;
import grabcut.vfs.*;

