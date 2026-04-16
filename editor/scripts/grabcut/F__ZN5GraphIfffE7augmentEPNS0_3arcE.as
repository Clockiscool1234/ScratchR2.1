package grabcut
{
   import avm2.intrinsics.memory.lf32;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.sf32;
   import avm2.intrinsics.memory.si32;
   
   public function F__ZN5GraphIfffE7augmentEPNS0_3arcE() : void
   {
      var _temp_1:* = this;
      var _loc4_:int = 0;
      var _loc3_:int = 0;
      var _loc1_:Number = NaN;
      var _loc8_:Number = NaN;
      var _loc12_:int = 0;
      var _loc11_:int = 0;
      var _loc9_:int = 0;
      var _loc6_:int = 0;
      var _loc2_:int = ESP;
      _loc4_ = _loc2_;
      _loc2_ -= 32;
      _loc3_ = li32(_loc4_);
      si32(_loc3_,_loc4_ - 4);
      _loc3_ = li32(_loc4_ + 4);
      si32(_loc3_,_loc4_ - 8);
      _loc1_ = lf32(_loc3_ + 12);
      sf32(_loc1_,_loc4_ - 20);
      _loc3_ = li32(_loc4_ - 8);
      _loc3_ = li32(_loc3_ + 8);
      _loc3_ = li32(_loc3_);
      si32(_loc3_,_loc4_ - 12);
      while(true)
      {
         _loc3_ = li32(_loc4_ - 12);
         _loc3_ = li32(_loc3_ + 4);
         si32(_loc3_,_loc4_ - 16);
         if(_loc3_ == 1)
         {
            break;
         }
         var _loc7_:Number = lf32(li32(li32(_loc4_ - 16) + 8) + 12);
         var _loc5_:Number = lf32(_loc4_ - 20);
         if(!(_loc7_ >= _loc5_ | _loc7_ != _loc7_ | _loc5_ != _loc5_))
         {
            sf32(lf32(li32(li32(_loc4_ - 16) + 8) + 12),_loc4_ - 20);
         }
         _loc3_ = li32(_loc4_ - 16);
         _loc3_ = li32(_loc3_);
         si32(_loc3_,_loc4_ - 12);
      }
      _loc7_ = lf32(li32(_loc4_ - 12) + 24);
      _loc5_ = lf32(_loc4_ - 20);
      if(!(_loc7_ >= _loc5_ | _loc7_ != _loc7_ | _loc5_ != _loc5_))
      {
         sf32(lf32(li32(_loc4_ - 12) + 24),_loc4_ - 20);
      }
      _loc3_ = li32(_loc4_ - 8);
      _loc3_ = li32(_loc3_);
      si32(_loc3_,_loc4_ - 12);
      while(true)
      {
         _loc3_ = li32(_loc4_ - 12);
         _loc3_ = li32(_loc3_ + 4);
         si32(_loc3_,_loc4_ - 16);
         if(_loc3_ == 1)
         {
            break;
         }
         _loc5_ = lf32(li32(_loc4_ - 16) + 12);
         _loc7_ = lf32(_loc4_ - 20);
         if(!(_loc5_ >= _loc7_ | _loc5_ != _loc5_ | _loc7_ != _loc7_))
         {
            sf32(lf32(li32(_loc4_ - 16) + 12),_loc4_ - 20);
         }
         _loc3_ = li32(_loc4_ - 16);
         _loc3_ = li32(_loc3_);
         si32(_loc3_,_loc4_ - 12);
      }
      _loc5_ = lf32(li32(_loc4_ - 12) + 24);
      _loc5_ = _loc5_ = -_loc5_;
      _loc7_ = lf32(_loc4_ - 20);
      if(!(_loc5_ >= _loc7_ | _loc5_ != _loc5_ | _loc7_ != _loc7_))
      {
         _loc5_ = lf32(li32(_loc4_ - 12) + 24);
         _loc5_ = -_loc5_;
         sf32(_loc5_,_loc4_ - 20);
      }
      _loc3_ = li32(_loc4_ - 8);
      _loc3_ = li32(_loc3_ + 8);
      _loc7_ = lf32(_loc3_ + 12);
      var _loc10_:Number = lf32(_loc4_ - 20);
      _loc7_ += _loc10_;
      sf32(_loc7_,_loc3_ + 12);
      _loc3_ = li32(_loc4_ - 8);
      _loc10_ = lf32(_loc3_ + 12);
      _loc7_ = lf32(_loc4_ - 20);
      _loc7_ = _loc10_ - _loc7_;
      sf32(_loc7_,_loc3_ + 12);
      _loc3_ = li32(_loc4_ - 8);
      _loc3_ = li32(_loc3_ + 8);
      _loc3_ = li32(_loc3_);
      si32(_loc3_,_loc4_ - 12);
      while(true)
      {
         _loc3_ = li32(_loc4_ - 12);
         _loc3_ = li32(_loc3_ + 4);
         si32(_loc3_,_loc4_ - 16);
         if(_loc3_ == 1)
         {
            break;
         }
         _loc3_ = li32(_loc4_ - 16);
         _loc7_ = lf32(_loc3_ + 12) + lf32(_loc4_ - 20);
         sf32(_loc7_,_loc3_ + 12);
         _loc3_ = li32(li32(_loc4_ - 16) + 8);
         _loc7_ = lf32(_loc3_ + 12) - lf32(_loc4_ - 20);
         sf32(_loc7_,_loc3_ + 12);
         _loc5_ = 0;
         var _loc13_:int = li32(_loc4_ - 16);
         _loc13_ = li32(_loc13_ + 8);
         _loc7_ = lf32(_loc13_ + 12);
         _loc12_ = 1;
         if(!(_loc7_ != _loc5_ | _loc7_ != _loc7_ | _loc5_ != _loc5_))
         {
            _loc12_ = 0;
         }
         _loc3_ = _loc12_ & 1;
         if(_loc3_ == 0)
         {
            var _temp_13:* = li32(_loc4_ - 4);
            var _temp_12:* = li32(_loc4_ - 12);
            _loc2_ -= 16;
            si32(_temp_12,_loc2_ + 4);
            si32(_temp_13,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIfffE16set_orphan_frontEPNS0_4nodeE();
            _loc2_ += 16;
         }
         _loc3_ = li32(_loc4_ - 16);
         _loc3_ = li32(_loc3_);
         si32(_loc3_,_loc4_ - 12);
      }
      _loc3_ = li32(_loc4_ - 12);
      _loc7_ = lf32(_loc3_ + 24) - lf32(_loc4_ - 20);
      sf32(_loc7_,_loc3_ + 24);
      _loc8_ = 0;
      _loc5_ = lf32(li32(_loc4_ - 12) + 24);
      _loc11_ = 1;
      if(!(_loc5_ != _loc8_ | _loc5_ != _loc5_ | _loc8_ != _loc8_))
      {
         _loc11_ = 0;
      }
      _loc3_ = _loc11_ & 1;
      if(_loc3_ == 0)
      {
         var _temp_17:* = li32(_loc4_ - 4);
         var _temp_16:* = li32(_loc4_ - 12);
         _loc2_ -= 16;
         si32(_temp_16,_loc2_ + 4);
         si32(_temp_17,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIfffE16set_orphan_frontEPNS0_4nodeE();
         _loc2_ += 16;
      }
      _loc3_ = li32(_loc4_ - 8);
      _loc3_ = li32(_loc3_);
      si32(_loc3_,_loc4_ - 12);
      while(true)
      {
         _loc3_ = li32(_loc4_ - 12);
         _loc3_ = li32(_loc3_ + 4);
         si32(_loc3_,_loc4_ - 16);
         if(_loc3_ == 1)
         {
            break;
         }
         _loc3_ = li32(li32(_loc4_ - 16) + 8);
         _loc7_ = lf32(_loc3_ + 12) + lf32(_loc4_ - 20);
         sf32(_loc7_,_loc3_ + 12);
         _loc3_ = li32(_loc4_ - 16);
         _loc7_ = lf32(_loc3_ + 12) - lf32(_loc4_ - 20);
         sf32(_loc7_,_loc3_ + 12);
         _loc5_ = lf32(li32(_loc4_ - 16) + 12);
         _loc9_ = 1;
         if(!(_loc5_ != _loc8_ | _loc5_ != _loc5_ | _loc8_ != _loc8_))
         {
            _loc9_ = 0;
         }
         _loc3_ = _loc9_ & 1;
         if(_loc3_ == 0)
         {
            var _temp_22:* = li32(_loc4_ - 4);
            var _temp_21:* = li32(_loc4_ - 12);
            _loc2_ -= 16;
            si32(_temp_21,_loc2_ + 4);
            si32(_temp_22,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIfffE16set_orphan_frontEPNS0_4nodeE();
            _loc2_ += 16;
         }
         _loc3_ = li32(_loc4_ - 16);
         _loc3_ = li32(_loc3_);
         si32(_loc3_,_loc4_ - 12);
      }
      _loc3_ = li32(_loc4_ - 12);
      _loc7_ = lf32(_loc3_ + 24) + lf32(_loc4_ - 20);
      sf32(_loc7_,_loc3_ + 24);
      _loc5_ = lf32(li32(_loc4_ - 12) + 24);
      _loc6_ = 1;
      if(!(_loc5_ != _loc8_ | _loc5_ != _loc5_ | _loc8_ != _loc8_))
      {
         _loc6_ = 0;
      }
      _loc3_ = _loc6_ & 1;
      if(_loc3_ == 0)
      {
         var _temp_26:* = li32(_loc4_ - 4);
         var _temp_25:* = li32(_loc4_ - 12);
         _loc2_ -= 16;
         si32(_temp_25,_loc2_ + 4);
         si32(_temp_26,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIfffE16set_orphan_frontEPNS0_4nodeE();
         _loc2_ += 16;
      }
      _loc3_ = li32(_loc4_ - 4);
      _loc10_ = lf32(_loc3_ + 36);
      _loc7_ = lf32(_loc4_ - 20);
      _loc7_ = _loc10_ + _loc7_;
      sf32(_loc7_,_loc3_ + 36);
      _loc2_ = _loc4_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

