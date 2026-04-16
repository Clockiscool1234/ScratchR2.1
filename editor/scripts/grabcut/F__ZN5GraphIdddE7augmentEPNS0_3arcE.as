package grabcut
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.sf64;
   import avm2.intrinsics.memory.si32;
   
   public function F__ZN5GraphIdddE7augmentEPNS0_3arcE() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc11_:int = 0;
      var _loc8_:int = 0;
      var _loc7_:int = 0;
      var _loc5_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 32;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      var _loc6_:Number = lf64(_loc1_ + 16);
      sf64(_loc6_,_loc3_ - 24);
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
         var _loc4_:Number = lf64(li32(li32(_loc3_ - 16) + 8) + 16);
         _loc6_ = lf64(_loc3_ - 24);
         if(!(_loc4_ >= _loc6_ | _loc4_ != _loc4_ | _loc6_ != _loc6_))
         {
            _loc6_ = lf64(li32(li32(_loc3_ - 16) + 8) + 16);
            sf64(_loc6_,_loc3_ - 24);
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_);
         si32(_loc1_,_loc3_ - 12);
      }
      _loc6_ = lf64(li32(_loc3_ - 12) + 24);
      _loc4_ = lf64(_loc3_ - 24);
      if(!(_loc6_ >= _loc4_ | _loc6_ != _loc6_ | _loc4_ != _loc4_))
      {
         _loc6_ = lf64(li32(_loc3_ - 12) + 24);
         sf64(_loc6_,_loc3_ - 24);
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
         _loc4_ = lf64(li32(_loc3_ - 16) + 16);
         _loc6_ = lf64(_loc3_ - 24);
         if(!(_loc4_ >= _loc6_ | _loc4_ != _loc4_ | _loc6_ != _loc6_))
         {
            _loc6_ = lf64(li32(_loc3_ - 16) + 16);
            sf64(_loc6_,_loc3_ - 24);
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_);
         si32(_loc1_,_loc3_ - 12);
      }
      _loc6_ = lf64(li32(_loc3_ - 12) + 24);
      _loc6_ = -_loc6_;
      _loc4_ = lf64(_loc3_ - 24);
      if(!(_loc6_ >= _loc4_ | _loc6_ != _loc6_ | _loc4_ != _loc4_))
      {
         _loc6_ = lf64(li32(_loc3_ - 12) + 24);
         _loc6_ = -_loc6_;
         sf64(_loc6_,_loc3_ - 24);
      }
      _loc1_ = li32(_loc3_ - 8);
      _loc1_ = li32(_loc1_ + 8);
      _loc4_ = lf64(_loc1_ + 16);
      var _loc9_:Number = lf64(_loc3_ - 24);
      _loc4_ += _loc9_;
      sf64(_loc4_,_loc1_ + 16);
      _loc1_ = li32(_loc3_ - 8);
      _loc9_ = lf64(_loc1_ + 16);
      _loc4_ = lf64(_loc3_ - 24);
      _loc4_ = _loc9_ - _loc4_;
      sf64(_loc4_,_loc1_ + 16);
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
         _loc4_ = lf64(_loc1_ + 16) + lf64(_loc3_ - 24);
         sf64(_loc4_,_loc1_ + 16);
         _loc1_ = li32(li32(_loc3_ - 16) + 8);
         _loc4_ = lf64(_loc1_ + 16) - lf64(_loc3_ - 24);
         sf64(_loc4_,_loc1_ + 16);
         _loc6_ = lf64(li32(li32(_loc3_ - 16) + 8) + 16);
         _loc11_ = 1;
         if(!(_loc6_ != 0 | _loc6_ != _loc6_ | false))
         {
            _loc11_ = 0;
         }
         _loc1_ = _loc11_ & 1;
         if(_loc1_ == 0)
         {
            var _temp_14:* = li32(_loc3_ - 4);
            var _temp_13:* = li32(_loc3_ - 12);
            _loc2_ -= 16;
            si32(_temp_13,_loc2_ + 4);
            si32(_temp_14,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIdddE16set_orphan_frontEPNS0_4nodeE();
            _loc2_ += 16;
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_);
         si32(_loc1_,_loc3_ - 12);
      }
      _loc1_ = li32(_loc3_ - 12);
      _loc4_ = lf64(_loc1_ + 24) - lf64(_loc3_ - 24);
      sf64(_loc4_,_loc1_ + 24);
      _loc6_ = lf64(li32(_loc3_ - 12) + 24);
      _loc8_ = 1;
      if(!(_loc6_ != 0 | _loc6_ != _loc6_ | false))
      {
         _loc8_ = 0;
      }
      _loc1_ = _loc8_ & 1;
      if(_loc1_ == 0)
      {
         var _temp_18:* = li32(_loc3_ - 4);
         var _temp_17:* = li32(_loc3_ - 12);
         _loc2_ -= 16;
         si32(_temp_17,_loc2_ + 4);
         si32(_temp_18,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIdddE16set_orphan_frontEPNS0_4nodeE();
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
         _loc4_ = lf64(_loc1_ + 16) + lf64(_loc3_ - 24);
         sf64(_loc4_,_loc1_ + 16);
         _loc1_ = li32(_loc3_ - 16);
         _loc4_ = lf64(_loc1_ + 16) - lf64(_loc3_ - 24);
         sf64(_loc4_,_loc1_ + 16);
         _loc6_ = lf64(li32(_loc3_ - 16) + 16);
         _loc7_ = 1;
         if(!(_loc6_ != 0 | _loc6_ != _loc6_ | false))
         {
            _loc7_ = 0;
         }
         _loc1_ = _loc7_ & 1;
         if(_loc1_ == 0)
         {
            var _temp_23:* = li32(_loc3_ - 4);
            var _temp_22:* = li32(_loc3_ - 12);
            _loc2_ -= 16;
            si32(_temp_22,_loc2_ + 4);
            si32(_temp_23,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIdddE16set_orphan_frontEPNS0_4nodeE();
            _loc2_ += 16;
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_);
         si32(_loc1_,_loc3_ - 12);
      }
      _loc1_ = li32(_loc3_ - 12);
      _loc4_ = lf64(_loc1_ + 24) + lf64(_loc3_ - 24);
      sf64(_loc4_,_loc1_ + 24);
      _loc6_ = lf64(li32(_loc3_ - 12) + 24);
      _loc5_ = 1;
      if(!(_loc6_ != 0 | _loc6_ != _loc6_ | false))
      {
         _loc5_ = 0;
      }
      _loc1_ = _loc5_ & 1;
      if(_loc1_ == 0)
      {
         var _temp_27:* = li32(_loc3_ - 4);
         var _temp_26:* = li32(_loc3_ - 12);
         _loc2_ -= 16;
         si32(_temp_26,_loc2_ + 4);
         si32(_temp_27,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIdddE16set_orphan_frontEPNS0_4nodeE();
         _loc2_ += 16;
      }
      _loc1_ = li32(_loc3_ - 4);
      _loc4_ = lf64(_loc1_ + 40);
      _loc9_ = lf64(_loc3_ - 24);
      _loc4_ += _loc9_;
      sf64(_loc4_,_loc1_ + 40);
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

