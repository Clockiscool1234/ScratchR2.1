package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F__ZN9__gnu_cxx13new_allocatorIiE8allocateEjPKv() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc4_:int = 0;
      var _loc1_:int = 0;
      var _loc5_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 32;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      _loc1_ = li32(_loc3_ + 8);
      si32(_loc1_,_loc3_ - 12);
      _loc1_ = li32(_loc3_ - 4);
      _loc2_ -= 16;
      si32(_loc1_,_loc2_);
      ESP = _loc2_;
      F__ZNK9__gnu_cxx13new_allocatorIiE8max_sizeEv();
      _loc5_ = 1;
      _loc2_ += 16;
      _loc1_ = eax;
      _loc4_ = li32(_loc3_ - 8);
      if(uint(_loc1_) >= uint(_loc4_))
      {
         _loc5_ = 0;
      }
      _loc1_ = _loc5_ & 1;
      si8(_loc1_,_loc3_ - 21);
      if(_loc1_ != 0)
      {
         ESP = _loc2_;
         F__ZSt17__throw_bad_allocv();
      }
      _loc1_ = li32(_loc3_ - 8);
      _loc2_ -= 16;
      _loc1_ <<= 2;
      si32(_loc1_,_loc2_);
      ESP = _loc2_;
      F__Znwj();
      _loc2_ += 16;
      _loc1_ = eax;
      si32(_loc1_,_loc3_ - 20);
      si32(_loc1_,_loc3_ - 16);
      _loc1_ = li32(_loc3_ - 16);
      eax = _loc1_;
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

