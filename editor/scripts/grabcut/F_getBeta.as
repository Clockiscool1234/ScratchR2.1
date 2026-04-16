package grabcut
{
   import avm2.intrinsics.memory.lf32;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.sf32;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F_getBeta() : void
   {
      var _temp_1:* = this;
      var _loc4_:int = 0;
      var _loc2_:int = 0;
      var _loc3_:int = ESP;
      _loc4_ = _loc3_;
      _loc3_ -= 80;
      _loc2_ = li32(_loc4_);
      si32(_loc2_,_loc4_ - 4);
      _loc2_ = li32(_loc4_ + 4);
      si32(_loc2_,_loc4_ - 8);
      _loc2_ = li32(_loc4_ + 8);
      si32(_loc2_,_loc4_ - 12);
      si32(0,_loc4_ - 44);
      si32(0,_loc4_ - 60);
      while(true)
      {
         var _loc11_:int = li32(_loc4_ - 8);
         _loc2_ = li32(_loc4_ - 60);
         if(_loc2_ >= _loc11_)
         {
            break;
         }
         si32(0,_loc4_ - 64);
         while(true)
         {
            _loc11_ = li32(_loc4_ - 12);
            _loc2_ = li32(_loc4_ - 64);
            if(_loc2_ >= _loc11_)
            {
               break;
            }
            var _temp_2:* = li32(_loc4_ - 12);
            si32(int(int(li32(_loc4_ - 60) * _temp_2) + li32(_loc4_ - 64)),_loc4_ - 68);
            var _temp_7:* = li32(_loc4_ - 4);
            var _temp_6:* = li32(_loc4_ - 8);
            var _temp_5:* = li32(_loc4_ - 12);
            var _temp_4:* = li32(_loc4_ - 60);
            var _temp_3:* = li32(_loc4_ - 64);
            _loc3_ -= 32;
            si32(_temp_3,_loc3_ + 16);
            si32(_temp_4,_loc3_ + 12);
            si32(_temp_5,_loc3_ + 8);
            si32(_temp_6,_loc3_ + 4);
            si32(_temp_7,_loc3_);
            ESP = _loc3_;
            F_getPixel();
            _loc3_ += 32;
            si32(eax,_loc4_ - 40);
            si8(li8(_loc4_ - 40),_loc4_ - 48);
            _loc11_ = _loc4_ - 48;
            var _temp_12:* = _loc11_ | 1;
            _loc2_ = _loc4_ - 40;
            var _loc9_:int = _loc2_ | 1;
            _loc9_ = li8(_loc9_);
            si8(_loc9_,_temp_12);
            var _temp_15:* = _loc11_ | 2;
            si8(_loc9_ = li8(_loc9_ = _loc2_ | 2),_temp_15);
            var _temp_16:* = _loc11_ | 3;
            si8(li8(_loc2_ | 3),_temp_16);
            if(int(li32(_loc4_ - 12) + -1) > li32(_loc4_ - 64))
            {
               var _temp_22:* = li32(_loc4_ - 4);
               var _temp_21:* = li32(_loc4_ - 8);
               var _temp_20:* = li32(_loc4_ - 12);
               var _temp_19:* = li32(_loc4_ - 60);
               var _temp_17:* = li32(_loc4_ - 64);
               _loc3_ -= 32;
               var _loc10_:int = _temp_17 + 1;
               si32(_loc10_,_loc3_ + 16);
               si32(_temp_19,_loc3_ + 12);
               si32(_temp_20,_loc3_ + 8);
               si32(_temp_21,_loc3_ + 4);
               si32(_temp_22,_loc3_);
               ESP = _loc3_;
               F_getPixel();
               _loc3_ += 32;
               si32(eax,_loc4_ - 32);
               si8(li8(_loc4_ - 32),_loc4_ - 56);
               _loc11_ = _loc4_ - 56;
               var _temp_27:* = _loc11_ | 1;
               _loc2_ = _loc4_ - 32;
               _loc9_ = _loc2_ | 1;
               _loc9_ = li8(_loc9_);
               si8(_loc9_,_temp_27);
               var _temp_30:* = _loc11_ | 2;
               si8(_loc9_ = li8(_loc9_ = _loc2_ | 2),_temp_30);
               var _temp_31:* = _loc11_ | 3;
               si8(li8(_loc2_ | 3),_temp_31);
               var _temp_33:* = li32(_loc4_ - 48);
               var _temp_32:* = li32(_loc4_ - 56);
               _loc3_ -= 16;
               si32(_temp_32,_loc3_ + 4);
               si32(_temp_33,_loc3_);
               ESP = _loc3_;
               F_colorDist();
               _loc3_ += 16;
               si32(int(eax + li32(_loc4_ - 44)),_loc4_ - 44);
            }
            _loc2_ = li32(_loc4_ - 8);
            _loc11_ = _loc2_ + -1;
            _loc2_ = li32(_loc4_ - 60);
            if(_loc11_ > _loc2_)
            {
               var _temp_40:* = li32(_loc4_ - 4);
               var _temp_39:* = li32(_loc4_ - 8);
               var _temp_38:* = li32(_loc4_ - 12);
               var _temp_36:* = li32(_loc4_ - 60);
               var _temp_35:* = li32(_loc4_ - 64);
               _loc3_ -= 32;
               si32(_temp_35,_loc3_ + 16);
               _loc9_ = _temp_36 + 1;
               si32(_loc9_,_loc3_ + 12);
               si32(_temp_38,_loc3_ + 8);
               si32(_temp_39,_loc3_ + 4);
               si32(_temp_40,_loc3_);
               ESP = _loc3_;
               F_getPixel();
               _loc3_ += 32;
               si32(eax,_loc4_ - 24);
               si8(li8(_loc4_ - 24),_loc4_ - 56);
               _loc11_ = _loc4_ - 56;
               var _temp_45:* = _loc11_ | 1;
               _loc2_ = _loc4_ - 24;
               _loc9_ = _loc2_ | 1;
               _loc9_ = li8(_loc9_);
               si8(_loc9_,_temp_45);
               var _temp_48:* = _loc11_ | 2;
               si8(_loc9_ = li8(_loc9_ = _loc2_ | 2),_temp_48);
               var _temp_49:* = _loc11_ | 3;
               si8(li8(_loc2_ | 3),_temp_49);
               var _temp_51:* = li32(_loc4_ - 48);
               var _temp_50:* = li32(_loc4_ - 56);
               _loc3_ -= 16;
               si32(_temp_50,_loc3_ + 4);
               si32(_temp_51,_loc3_);
               ESP = _loc3_;
               F_colorDist();
               _loc3_ += 16;
               si32(int(eax + li32(_loc4_ - 44)),_loc4_ - 44);
            }
            _loc2_ = li32(_loc4_ - 64);
            _loc2_ += 1;
            si32(_loc2_,_loc4_ - 64);
         }
         si32(int(li32(_loc4_ - 60) + 1),_loc4_ - 60);
      }
      var _loc6_:Number = li32(_loc4_ - 12);
      var _loc5_:Number = _loc11_ = li32(_loc4_ - 8);
      var _loc8_:Number = _loc5_ + _loc5_;
      _loc8_ = _loc8_ * _loc6_;
      _loc5_ = _loc8_ - _loc5_;
      var _temp_60:* = _loc5_ - _loc6_;
      _loc5_ = _loc11_ = li32(_loc4_ - 44);
      _loc6_ = _temp_60 / (_loc5_ + _loc5_);
      var _temp_62:* = _loc6_;
      sf32(_temp_62,_loc4_ - 20);
      sf32(_temp_62,_loc4_ - 16);
      st0 = lf32(_loc4_ - 16);
      _loc3_ = _loc4_;
      ESP = _loc3_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

