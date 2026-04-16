package grabcut
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public function F__ZN5GraphIiiiE15set_orphan_rearEPNS0_4nodeE() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 16;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      si32(2,_loc1_ + 4);
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 28);
      _loc2_ -= 16;
      si32(_loc1_,_loc2_);
      ESP = _loc2_;
      F__ZN6DBlockIN5GraphIiiiE7nodeptrEE3NewEv();
      _loc2_ += 16;
      _loc1_ = eax;
      si32(_loc1_,_loc3_ - 12);
      var _loc4_:int = li32(_loc3_ - 8);
      si32(_loc4_,_loc1_);
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 68);
      if(_loc1_ != 0)
      {
         var _temp_5:* = li32(li32(_loc3_ - 4) + 68);
         si32(_loc4_ = li32(_loc3_ - 12),_temp_5 + 4);
      }
      else
      {
         si32(li32(_loc3_ - 12),li32(_loc3_ - 4) + 64);
      }
      _loc1_ = li32(_loc3_ - 12);
      _loc4_ = li32(_loc3_ - 4);
      si32(_loc1_,_loc4_ + 68);
      _loc1_ = li32(_loc3_ - 12);
      si32(0,_loc1_ + 4);
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

