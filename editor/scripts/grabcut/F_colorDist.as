package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F_colorDist() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc6_:int = 0;
      var _loc1_:int = 0;
      var _loc8_:int = 0;
      var _loc7_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 48;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 8);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 16);
      _loc8_ = li8(_loc3_ - 16);
      _loc1_ = li8(_loc3_ - 8);
      _loc2_ -= 16;
      si32(1073741824,_loc2_ + 12);
      si32(0,_loc2_ + 8);
      _loc1_ -= _loc8_;
      var _loc5_:Number = _loc1_;
      sf64(_loc5_,_loc2_);
      ESP = _loc2_;
      F_pow();
      _loc2_ += 16;
      _loc1_ = _loc5_ = st0;
      si32(_loc1_,_loc3_ - 28);
      _loc8_ = _loc3_ - 16;
      _loc1_ = _loc8_ | 1;
      _loc7_ = li8(_loc1_);
      _loc1_ = _loc3_ - 8;
      _loc6_ = _loc1_ | 1;
      _loc6_ = li8(_loc6_);
      _loc2_ -= 16;
      si32(1073741824,_loc2_ + 12);
      si32(0,_loc2_ + 8);
      var _loc4_:Number = _loc7_ = _loc6_ - _loc7_;
      sf64(_loc4_,_loc2_);
      ESP = _loc2_;
      F_pow();
      _loc2_ += 16;
      _loc7_ = _loc4_ = st0;
      si32(_loc7_,_loc3_ - 32);
      _loc8_ |= 2;
      _loc8_ = li8(_loc8_);
      _loc1_ |= 2;
      _loc1_ = li8(_loc1_);
      _loc2_ -= 16;
      si32(1073741824,_loc2_ + 12);
      si32(0,_loc2_ + 8);
      _loc1_ -= _loc8_;
      _loc5_ = _loc1_;
      sf64(_loc5_,_loc2_);
      ESP = _loc2_;
      F_pow();
      _loc2_ += 16;
      _loc1_ = _loc5_ = st0;
      si32(_loc1_,_loc3_ - 36);
      _loc8_ = li32(_loc3_ - 32);
      _loc7_ = li32(_loc3_ - 28);
      _loc8_ = _loc7_ + _loc8_;
      _loc1_ = _loc8_ + _loc1_;
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

