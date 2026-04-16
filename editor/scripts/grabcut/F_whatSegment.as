package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F_whatSegment() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc7_:int = 0;
      var _loc6_:int = 0;
      var _loc5_:int = 0;
      var _loc4_:int = 0;
      var _loc8_:int = 0;
      var _loc1_:int = 0;
      var _loc9_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 48;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      _loc1_ = li32(_loc3_ + 8);
      si32(_loc1_,_loc3_ - 12);
      _loc1_ = li32(_loc3_ + 12);
      si32(_loc1_,_loc3_ - 16);
      _loc9_ = li32(_loc3_ + 16);
      si32(_loc9_,_loc3_ - 20);
      _loc8_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc3_ - 8);
      _loc7_ = li32(_loc3_ - 12);
      _loc6_ = li32(_loc3_ - 16);
      _loc2_ -= 32;
      si32(_loc9_,_loc2_ + 16);
      si32(_loc6_,_loc2_ + 12);
      si32(_loc7_,_loc2_ + 8);
      si32(_loc1_,_loc2_ + 4);
      si32(_loc8_,_loc2_);
      ESP = _loc2_;
      F_getPixel();
      _loc2_ += 32;
      _loc1_ = eax;
      si32(_loc1_,_loc3_ - 32);
      _loc1_ = li8(_loc3_ - 32);
      si8(_loc1_,_loc3_ - 40);
      _loc8_ = _loc3_ - 40;
      _loc5_ = _loc8_ | 1;
      _loc1_ = _loc3_ - 32;
      _loc9_ = _loc1_ | 1;
      _loc9_ = li8(_loc9_);
      si8(_loc9_,_loc5_);
      _loc4_ = _loc8_ | 2;
      _loc9_ = _loc1_ | 2;
      _loc9_ = li8(_loc9_);
      si8(_loc9_,_loc4_);
      _loc8_ |= 3;
      _loc1_ |= 3;
      _loc1_ = li8(_loc1_);
      si8(_loc1_,_loc8_);
      _loc1_ = li8(_loc4_);
      if(_loc1_ == 255)
      {
         si32(0,_loc3_ - 28);
      }
      else if(li8(_loc3_ - 40) == 255)
      {
         si32(1,_loc3_ - 28);
      }
      else
      {
         var _temp_9:* = li8(_loc5_);
         if(int(int(li8(_loc3_ - 40) + _temp_9) + li8(_loc4_)) != 0)
         {
            var _temp_11:* = li8(_loc5_);
            var _temp_10:* = li8(_loc4_);
            _loc1_ = li8(_loc3_ - 40);
            _loc2_ -= 16;
            si32(_temp_10,_loc2_ + 12);
            si32(_temp_11,_loc2_ + 8);
            si32(_loc1_,_loc2_ + 4);
            si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.L__2E_str,_loc2_);
            ESP = _loc2_;
            F_printf();
            _loc2_ += 16;
            si32(-1,_loc3_ - 28);
         }
         else
         {
            si32(-1,_loc3_ - 28);
         }
      }
      _loc1_ = li32(_loc3_ - 28);
      si32(_loc1_,_loc3_ - 24);
      _loc1_ = li32(_loc3_ - 24);
      eax = _loc1_;
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

