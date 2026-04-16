package grabcut
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F__ZN5GraphIdddE12maxflow_initEv() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc5_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 16;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      si32(0,_loc1_ + 64);
      _loc5_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc5_ + 64);
      si32(_loc1_,_loc5_ + 56);
      _loc1_ = li32(_loc3_ - 4);
      si32(0,_loc1_ + 68);
      _loc5_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc5_ + 68);
      si32(_loc1_,_loc5_ + 60);
      _loc1_ = li32(_loc3_ - 4);
      si32(0,_loc1_ + 72);
      _loc1_ = li32(_loc3_ - 4);
      si32(0,_loc1_ + 80);
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_);
      si32(_loc1_,_loc3_ - 8);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 4);
         _loc5_ = li32(_loc1_ + 4);
         _loc1_ = li32(_loc3_ - 8);
         if(uint(_loc5_) <= uint(_loc1_))
         {
            break;
         }
         var _temp_4:* = li32(_loc3_ - 8);
         si32(0,_temp_4 + 8);
         _loc1_ = li32(_loc3_ - 8);
         _loc5_ = li8(_loc1_ + 20);
         _loc5_ = _loc5_ & 0xFD;
         si8(_loc5_,_loc1_ + 20);
         _loc1_ = li32(_loc3_ - 8);
         _loc5_ = li8(_loc1_ + 20);
         _loc5_ = _loc5_ & 0xFB;
         si8(_loc5_,_loc1_ + 20);
         si32(li32(li32(_loc3_ - 4) + 80),li32(_loc3_ - 8) + 12);
         var _loc4_:Number = lf64(li32(_loc3_ - 8) + 24);
         if(!(_loc4_ <= 0 | _loc4_ != _loc4_ | false))
         {
            _loc1_ = li32(_loc3_ - 8);
            _loc5_ = li8(_loc1_ + 20);
            _loc5_ = _loc5_ & 0xFE;
            si8(_loc5_,_loc1_ + 20);
            var _temp_12:* = li32(_loc3_ - 8);
            si32(1,_temp_12 + 4);
            var _temp_14:* = li32(_loc3_ - 4);
            var _temp_13:* = li32(_loc3_ - 8);
            _loc2_ -= 16;
            si32(_temp_13,_loc2_ + 4);
            si32(_temp_14,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIdddE10set_activeEPNS0_4nodeE();
            _loc2_ += 16;
            var _temp_16:* = li32(_loc3_ - 8);
            si32(1,_temp_16 + 16);
         }
         else
         {
            _loc4_ = lf64(li32(_loc3_ - 8) + 24);
            if(!(_loc4_ >= 0 | _loc4_ != _loc4_ | false))
            {
               _loc1_ = li32(_loc3_ - 8);
               _loc5_ = li8(_loc1_ + 20);
               _loc5_ = _loc5_ | 1;
               si8(_loc5_,_loc1_ + 20);
               var _temp_20:* = li32(_loc3_ - 8);
               si32(1,_temp_20 + 4);
               var _temp_22:* = li32(_loc3_ - 4);
               var _temp_21:* = li32(_loc3_ - 8);
               _loc2_ -= 16;
               si32(_temp_21,_loc2_ + 4);
               si32(_temp_22,_loc2_);
               ESP = _loc2_;
               F__ZN5GraphIdddE10set_activeEPNS0_4nodeE();
               _loc2_ += 16;
               var _temp_24:* = li32(_loc3_ - 8);
               si32(1,_temp_24 + 16);
            }
            else
            {
               var _temp_25:* = li32(_loc3_ - 8);
               si32(0,_temp_25 + 4);
            }
         }
         _loc1_ = li32(_loc3_ - 8);
         _loc1_ += 32;
         si32(_loc1_,_loc3_ - 8);
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

