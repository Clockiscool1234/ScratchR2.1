package grabcut
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public function F__ZN5GraphIfffE10set_activeEPNS0_4nodeE() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 8;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      _loc1_ = li32(_loc1_ + 8);
      if(_loc1_ == 0)
      {
         if(li32(li32(_loc3_ - 4) + 60) != 0)
         {
            var _temp_3:* = li32(li32(_loc3_ - 4) + 60);
            var _loc4_:int;
            si32(_loc4_ = li32(_loc3_ - 8),_temp_3 + 8);
         }
         else
         {
            si32(li32(_loc3_ - 8),li32(_loc3_ - 4) + 52);
         }
         _loc1_ = li32(_loc3_ - 8);
         _loc4_ = li32(_loc3_ - 4);
         si32(_loc1_,_loc4_ + 60);
         _loc1_ = li32(_loc3_ - 8);
         si32(_loc1_,_loc1_ + 8);
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

