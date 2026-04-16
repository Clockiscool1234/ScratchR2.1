package grabcut
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F__ZSt24__uninitialized_copy_auxIPiS0_ET0_T_S2_S1_St11__true_type() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc5_:int = 0;
      var _loc4_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 32;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      _loc1_ = li32(_loc3_ + 8);
      si32(_loc1_,_loc3_ - 12);
      _loc1_ = li8(_loc3_ + 12);
      si8(_loc1_,_loc3_ - 16);
      _loc1_ = li32(_loc3_ - 4);
      _loc5_ = li32(_loc3_ - 8);
      _loc4_ = li32(_loc3_ - 12);
      _loc2_ -= 16;
      si32(_loc4_,_loc2_ + 8);
      si32(_loc5_,_loc2_ + 4);
      si32(_loc1_,_loc2_);
      ESP = _loc2_;
      F__ZSt4copyIPiS0_ET0_T_S2_S1_();
      _loc2_ += 16;
      _loc1_ = eax;
      si32(_loc1_,_loc3_ - 24);
      si32(_loc1_,_loc3_ - 20);
      _loc1_ = li32(_loc3_ - 20);
      eax = _loc1_;
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

