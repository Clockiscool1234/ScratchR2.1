package grabcut
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F__ZN5GraphIiiiE19add_to_changed_listEPNS0_4nodeE() : void
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
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 44);
      if(_loc1_ != 0)
      {
         if((li8(li32(_loc3_ - 8) + 20) >>> 2 & 1) == 0)
         {
            var _temp_2:* = li32(li32(_loc3_ - 4) + 44);
            _loc2_ -= 16;
            si32(1,_loc2_ + 4);
            si32(_temp_2,_loc2_);
            ESP = _loc2_;
            F__ZN5BlockIiE3NewEi();
            _loc2_ += 16;
            _loc1_ = eax;
            si32(_loc1_,_loc3_ - 12);
            var _loc5_:int = li32(_loc3_ - 4);
            var _temp_6:* = li32(_loc5_);
            _loc5_ = (_loc5_ = li32(_loc3_ - 8)) - _temp_6;
            _loc5_ = _loc5_ / 28;
            si32(_loc5_,_loc1_);
            _loc1_ = li32(_loc3_ - 8);
            _loc5_ = li8(_loc1_ + 20);
            _loc5_ = _loc5_ | 4;
            si8(_loc5_,_loc1_ + 20);
         }
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

