package grabcut
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F_setResult() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc4_:int = 0;
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
      _loc1_ = li32(_loc3_ + 16);
      si32(_loc1_,_loc3_ - 20);
      si32(0,grabcut._objectColors);
      si32(153,grabcut._objectColors + 4);
      si32(0,grabcut._objectColors + 8);
      si32(0,grabcut._objectColors + 12);
      si32(255,grabcut._objectColors + 16);
      si32(0,grabcut._objectColors + 20);
      si32(204,grabcut._objectColors + 24);
      si32(255,grabcut._objectColors + 24);
      si32(0,grabcut._objectColors + 32);
      si32(255,grabcut._objectColors + 36);
      si32(255,grabcut._objectColors + 40);
      si32(0,grabcut._objectColors + 44);
      si32(255,grabcut._objectColors + 48);
      si32(204,grabcut._objectColors + 52);
      si32(0,grabcut._objectColors + 56);
      si32(255,grabcut._objectColors + 60);
      si32(153,grabcut._objectColors + 64);
      si32(153,grabcut._objectColors + 68);
      si32(204,grabcut._objectColors + 72);
      si32(0,grabcut._objectColors + 76);
      si32(51,grabcut._objectColors + 80);
      si32(255,grabcut._objectColors + 84);
      si32(51,grabcut._objectColors + 88);
      si32(204,grabcut._objectColors + 92);
      si32(153,grabcut._objectColors + 96);
      si32(51,grabcut._objectColors + 100);
      si32(1,grabcut._objectColors + 104);
      si32(153,grabcut._objectColors + 108);
      si32(0,grabcut._objectColors + 112);
      si32(153,grabcut._objectColors + 116);
      si32(0,grabcut._objectColors + 120);
      si32(0,grabcut._objectColors + 124);
      si32(153,grabcut._objectColors + 128);
      si32(0,grabcut._objectColors + 132);
      si32(255,grabcut._objectColors + 136);
      si32(152,grabcut._objectColors + 140);
      si32(0,grabcut._objectColors + 144);
      si32(204,grabcut._objectColors + 148);
      si32(255,grabcut._objectColors + 152);
      si32(153,grabcut._objectColors + 156);
      si32(153,grabcut._objectColors + 160);
      si32(0,grabcut._objectColors + 164);
      si32(0,_loc3_ - 28);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 12);
         var _loc5_:int = li32(_loc3_ - 28);
         if(_loc5_ >= _loc1_)
         {
            break;
         }
         si32(0,_loc3_ - 32);
         while(true)
         {
            _loc5_ = li32(_loc3_ - 16);
            _loc1_ = li32(_loc3_ - 32);
            if(_loc1_ >= _loc5_)
            {
               break;
            }
            var _temp_3:* = li32(_loc3_ - 16);
            _loc5_ = int(li32(_loc3_ - 28) * _temp_3) + li32(_loc3_ - 32);
            si32(_loc5_,_loc3_ - 36);
            var _temp_5:* = li32(_loc3_ - 4);
            _loc2_ -= 16;
            si32(0,_loc2_ + 8);
            si32(_loc5_,_loc2_ + 4);
            si32(_temp_5,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIiiiE12what_segmentEiNS0_8termtypeE();
            _loc2_ += 16;
            si32(eax,_loc3_ - 40);
            var _temp_8:* = li32(_loc3_ - 4);
            var _temp_7:* = li32(_loc3_ - 36);
            _loc2_ -= 16;
            si32(0,_loc2_ + 8);
            si32(_temp_7,_loc2_ + 4);
            si32(_temp_8,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIiiiE12what_segmentEiNS0_8termtypeE();
            _loc2_ += 16;
            var _temp_10:* = eax;
            _loc4_ = 1;
            if(_temp_10 != 0)
            {
               _loc4_ = 0;
            }
            _loc1_ = _loc4_ & 1;
            si8(_loc1_,_loc3_ - 21);
            if(_loc1_ != 0)
            {
               var _temp_12:* = li32(_loc3_ - 36) << 2;
               var _temp_17:* = int((_loc5_ = li32(_loc3_ - 8)) + _temp_12);
               var _temp_14:* = int((_loc5_ = li32(_loc3_ - 20)) * 12);
               _loc5_ = grabcut._objectColors + _temp_14;
               _loc5_ = li32(_loc5_);
               si8(_loc5_,_temp_17);
               var _temp_22:* = int((li32(_loc3_ - 36) << 2) + li32(_loc3_ - 8));
               var _temp_19:* = int((_loc5_ = li32(_loc3_ - 20)) * 12);
               _loc5_ = grabcut._objectColors + _temp_19;
               _loc5_ = li32(_loc5_ + 4);
               si8(_loc5_,_temp_22 + 1);
               var _temp_27:* = int((li32(_loc3_ - 36) << 2) + li32(_loc3_ - 8));
               var _temp_24:* = int((_loc5_ = li32(_loc3_ - 20)) * 12);
               _loc5_ = grabcut._objectColors + _temp_24;
               _loc5_ = li32(_loc5_ + 8);
               si8(_loc5_,_temp_27 + 2);
               var _temp_28:* = int((li32(_loc3_ - 36) << 2) + li32(_loc3_ - 8));
               si8(-103,_temp_28 + 3);
            }
            else
            {
               var _temp_30:* = li32(_loc3_ - 36) << 2;
               var _temp_31:* = int((_loc5_ = li32(_loc3_ - 8)) + _temp_30);
               si8(0,_temp_31);
               var _temp_32:* = int((li32(_loc3_ - 36) << 2) + li32(_loc3_ - 8));
               si8(0,_temp_32 + 1);
               var _temp_33:* = int((li32(_loc3_ - 36) << 2) + li32(_loc3_ - 8));
               si8(0,_temp_33 + 2);
               var _temp_34:* = int((li32(_loc3_ - 36) << 2) + li32(_loc3_ - 8));
               si8(0,_temp_34 + 3);
            }
            _loc1_ = li32(_loc3_ - 32);
            _loc1_ += 1;
            si32(_loc1_,_loc3_ - 32);
         }
         si32(int(li32(_loc3_ - 28) + 1),_loc3_ - 28);
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

