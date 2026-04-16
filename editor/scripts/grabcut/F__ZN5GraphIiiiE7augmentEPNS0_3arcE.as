package grabcut
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   
   public function F__ZN5GraphIiiiE7augmentEPNS0_3arcE() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 32;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      _loc1_ = li32(_loc1_ + 12);
      si32(_loc1_,_loc3_ - 20);
      _loc1_ = li32(_loc3_ - 8);
      _loc1_ = li32(_loc1_ + 8);
      _loc1_ = li32(_loc1_);
      si32(_loc1_,_loc3_ - 12);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 12);
         _loc1_ = li32(_loc1_ + 4);
         si32(_loc1_,_loc3_ - 16);
         if(_loc1_ == 1)
         {
            break;
         }
         if(li32(li32(li32(_loc3_ - 16) + 8) + 12) < li32(_loc3_ - 20))
         {
            si32(li32(li32(li32(_loc3_ - 16) + 8) + 12),_loc3_ - 20);
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_);
         si32(_loc1_,_loc3_ - 12);
      }
      if(li32(li32(_loc3_ - 12) + 24) < li32(_loc3_ - 20))
      {
         si32(li32(li32(_loc3_ - 12) + 24),_loc3_ - 20);
      }
      _loc1_ = li32(_loc3_ - 8);
      _loc1_ = li32(_loc1_);
      si32(_loc1_,_loc3_ - 12);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 12);
         _loc1_ = li32(_loc1_ + 4);
         si32(_loc1_,_loc3_ - 16);
         if(_loc1_ == 1)
         {
            break;
         }
         if(li32(li32(_loc3_ - 16) + 12) < li32(_loc3_ - 20))
         {
            si32(li32(li32(_loc3_ - 16) + 12),_loc3_ - 20);
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_);
         si32(_loc1_,_loc3_ - 12);
      }
      var _temp_2:* = li32(li32(_loc3_ - 12) + 24);
      if(int(0 - _temp_2) < li32(_loc3_ - 20))
      {
         var _temp_3:* = li32(li32(_loc3_ - 12) + 24);
         si32(int(0 - _temp_3),_loc3_ - 20);
      }
      _loc1_ = li32(_loc3_ - 8);
      _loc1_ = li32(_loc1_ + 8);
      var _loc5_:int = li32(_loc1_ + 12);
      var _loc4_:int = li32(_loc3_ - 20);
      _loc5_ += _loc4_;
      si32(_loc5_,_loc1_ + 12);
      _loc1_ = li32(_loc3_ - 8);
      _loc4_ = li32(_loc1_ + 12);
      _loc5_ = li32(_loc3_ - 20);
      _loc5_ = _loc4_ - _loc5_;
      si32(_loc5_,_loc1_ + 12);
      _loc1_ = li32(_loc3_ - 8);
      _loc1_ = li32(_loc1_ + 8);
      _loc1_ = li32(_loc1_);
      si32(_loc1_,_loc3_ - 12);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 12);
         _loc1_ = li32(_loc1_ + 4);
         si32(_loc1_,_loc3_ - 16);
         if(_loc1_ == 1)
         {
            break;
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc5_ = li32(_loc1_ + 12) + li32(_loc3_ - 20);
         si32(_loc5_,_loc1_ + 12);
         _loc1_ = li32(li32(_loc3_ - 16) + 8);
         _loc5_ = li32(_loc1_ + 12) - li32(_loc3_ - 20);
         si32(_loc5_,_loc1_ + 12);
         if(li32(li32(li32(_loc3_ - 16) + 8) + 12) == 0)
         {
            var _temp_9:* = li32(_loc3_ - 4);
            var _temp_8:* = li32(_loc3_ - 12);
            _loc2_ -= 16;
            si32(_temp_8,_loc2_ + 4);
            si32(_temp_9,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIiiiE16set_orphan_frontEPNS0_4nodeE();
            _loc2_ += 16;
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_);
         si32(_loc1_,_loc3_ - 12);
      }
      _loc1_ = li32(_loc3_ - 12);
      _loc5_ = li32(_loc1_ + 24) - li32(_loc3_ - 20);
      si32(_loc5_,_loc1_ + 24);
      if(li32(li32(_loc3_ - 12) + 24) == 0)
      {
         var _temp_13:* = li32(_loc3_ - 4);
         var _temp_12:* = li32(_loc3_ - 12);
         _loc2_ -= 16;
         si32(_temp_12,_loc2_ + 4);
         si32(_temp_13,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIiiiE16set_orphan_frontEPNS0_4nodeE();
         _loc2_ += 16;
      }
      _loc1_ = li32(_loc3_ - 8);
      _loc1_ = li32(_loc1_);
      si32(_loc1_,_loc3_ - 12);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 12);
         _loc1_ = li32(_loc1_ + 4);
         si32(_loc1_,_loc3_ - 16);
         if(_loc1_ == 1)
         {
            break;
         }
         _loc1_ = li32(li32(_loc3_ - 16) + 8);
         _loc5_ = li32(_loc1_ + 12) + li32(_loc3_ - 20);
         si32(_loc5_,_loc1_ + 12);
         _loc1_ = li32(_loc3_ - 16);
         _loc5_ = li32(_loc1_ + 12) - li32(_loc3_ - 20);
         si32(_loc5_,_loc1_ + 12);
         if(li32(li32(_loc3_ - 16) + 12) == 0)
         {
            var _temp_18:* = li32(_loc3_ - 4);
            var _temp_17:* = li32(_loc3_ - 12);
            _loc2_ -= 16;
            si32(_temp_17,_loc2_ + 4);
            si32(_temp_18,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIiiiE16set_orphan_frontEPNS0_4nodeE();
            _loc2_ += 16;
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_);
         si32(_loc1_,_loc3_ - 12);
      }
      _loc1_ = li32(_loc3_ - 12);
      _loc5_ = li32(_loc1_ + 24) + li32(_loc3_ - 20);
      si32(_loc5_,_loc1_ + 24);
      if(li32(li32(_loc3_ - 12) + 24) == 0)
      {
         var _temp_22:* = li32(_loc3_ - 4);
         var _temp_21:* = li32(_loc3_ - 12);
         _loc2_ -= 16;
         si32(_temp_21,_loc2_ + 4);
         si32(_temp_22,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIiiiE16set_orphan_frontEPNS0_4nodeE();
         _loc2_ += 16;
      }
      _loc1_ = li32(_loc3_ - 4);
      _loc5_ = li32(_loc1_ + 36);
      _loc4_ = li32(_loc3_ - 20);
      _loc5_ += _loc4_;
      si32(_loc5_,_loc1_ + 36);
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

