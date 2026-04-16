package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;
   
   public function F__ZN6DBlockIN5GraphIsiiE7nodeptrEE3NewEv() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 32;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 8);
      if(_loc1_ == 0)
      {
         si32(li32(li32(_loc3_ - 4) + 4),_loc3_ - 24);
         var _temp_2:* = li32(li32(_loc3_ - 4)) << 3 | 4;
         si32(_temp_2,_loc3_ - 16);
         _loc2_ -= 16;
         si32(_temp_2,_loc2_);
         ESP = _loc2_;
         F__Znaj();
         _loc2_ += 16;
         si32(eax,li32(_loc3_ - 4) + 4);
         if(li32(li32(_loc3_ - 4) + 4) == 0)
         {
            if(li32(li32(_loc3_ - 4) + 12) != 0)
            {
               var _loc4_:int = li32(li32(_loc3_ - 4) + 12);
               _loc2_ -= 16;
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str19,_loc2_);
               ESP = _loc2_;
               ptr2fun[_loc4_]();
               _loc2_ += 16;
            }
            _loc2_ -= 16;
            si32(1,_loc2_);
            ESP = _loc2_;
            F_exit();
            _loc2_ += 16;
         }
         _loc1_ = li32(_loc3_ - 4);
         var _loc5_:int = li32(_loc1_ + 4);
         _loc5_ = _loc5_ + 4;
         si32(_loc5_,_loc1_ + 8);
         _loc1_ = li32(_loc3_ - 4);
         _loc1_ = li32(_loc1_ + 8);
         si32(_loc1_,_loc3_ - 20);
         while(true)
         {
            _loc5_ = li32(_loc3_ - 4);
            _loc1_ = li32(_loc5_ + 8);
            _loc5_ = li32(_loc5_);
            _loc5_ = _loc5_ << 3;
            _loc1_ += _loc5_;
            _loc1_ += -8;
            _loc5_ = li32(_loc3_ - 20);
            if(uint(_loc1_) <= uint(_loc5_))
            {
               break;
            }
            _loc5_ = li32(_loc3_ - 20);
            si32(int(_loc5_ + 8),_loc5_);
            si32(int(li32(_loc3_ - 20) + 8),_loc3_ - 20);
         }
         var _temp_12:* = li32(_loc3_ - 20);
         si32(0,_temp_12);
         var _temp_13:* = li32(li32(_loc3_ - 4) + 4);
         si32(li32(_loc3_ - 24),_temp_13);
      }
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 8);
      si32(_loc1_,_loc3_ - 20);
      _loc5_ = li32(_loc1_);
      _loc1_ = li32(_loc3_ - 4);
      si32(_loc5_,_loc1_ + 8);
      _loc1_ = li32(_loc3_ - 20);
      si32(_loc1_,_loc3_ - 12);
      si32(_loc1_,_loc3_ - 8);
      _loc1_ = li32(_loc3_ - 8);
      eax = _loc1_;
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

