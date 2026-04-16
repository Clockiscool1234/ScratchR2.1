package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F_addBackgroundRect() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc10_:int = 0;
      var _loc7_:int = 0;
      var _loc6_:int = 0;
      var _loc5_:int = 0;
      var _loc4_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 64;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      _loc1_ = li32(_loc3_ + 8);
      si32(_loc1_,_loc3_ - 12);
      si32(1,_loc3_ - 24);
      _loc1_ = li32(_loc3_ - 12);
      si32(_loc1_,_loc3_ - 28);
      _loc1_ = li32(_loc3_ - 8);
      si32(_loc1_,_loc3_ - 32);
      si32(0,_loc3_ - 36);
      si32(0,_loc3_ - 40);
      si32(0,_loc3_ - 52);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 8);
         var _loc11_:int = li32(_loc3_ - 52);
         if(_loc11_ >= _loc1_)
         {
            break;
         }
         si32(0,_loc3_ - 56);
         while(true)
         {
            _loc1_ = li32(_loc3_ - 12);
            _loc11_ = li32(_loc3_ - 56);
            if(_loc11_ >= _loc1_)
            {
               break;
            }
            var _temp_8:* = li32(_loc3_ - 4);
            var _temp_7:* = li32(_loc3_ - 8);
            var _temp_6:* = li32(_loc3_ - 12);
            var _temp_5:* = li32(_loc3_ - 52);
            var _temp_4:* = li32(_loc3_ - 56);
            _loc2_ -= 32;
            si32(_temp_4,_loc2_ + 16);
            si32(_temp_5,_loc2_ + 12);
            si32(_temp_6,_loc2_ + 8);
            si32(_temp_7,_loc2_ + 4);
            si32(_temp_8,_loc2_);
            ESP = _loc2_;
            F_whatSegment();
            _loc10_ = 1;
            _loc2_ += 32;
            if(eax != 0)
            {
               _loc10_ = 0;
            }
            _loc1_ = _loc10_ & 1;
            si8(_loc1_,_loc3_ - 17);
            if(_loc1_ != 0)
            {
               var _temp_12:* = li32(_loc3_ - 28);
               var _temp_10:* = li32(_loc3_ - 56);
               _loc2_ -= 16;
               var _loc9_:Number = _temp_10;
               sf64(_loc9_,_loc2_ + 8);
               var _loc8_:Number = _temp_12;
               sf64(_loc8_,_loc2_);
               ESP = _loc2_;
               F_fmin();
               _loc2_ += 16;
               _loc8_ = st0;
               si32(int(_loc8_),_loc3_ - 28);
               var _temp_18:* = li32(_loc3_ - 36);
               var _temp_16:* = li32(_loc3_ - 56);
               _loc2_ -= 16;
               _loc9_ = _temp_16;
               sf64(_loc9_,_loc2_ + 8);
               _loc8_ = _temp_18;
               sf64(_loc8_,_loc2_);
               ESP = _loc2_;
               F_fmax();
               _loc2_ += 16;
               _loc8_ = st0;
               si32(int(_loc8_),_loc3_ - 36);
               var _temp_24:* = li32(_loc3_ - 32);
               var _temp_22:* = li32(_loc3_ - 52);
               _loc2_ -= 16;
               _loc9_ = _temp_22;
               sf64(_loc9_,_loc2_ + 8);
               _loc8_ = _temp_24;
               sf64(_loc8_,_loc2_);
               ESP = _loc2_;
               F_fmin();
               _loc2_ += 16;
               _loc8_ = st0;
               si32(int(_loc8_),_loc3_ - 32);
               var _temp_30:* = li32(_loc3_ - 40);
               var _temp_28:* = li32(_loc3_ - 52);
               _loc2_ -= 16;
               _loc9_ = _temp_28;
               sf64(_loc9_,_loc2_ + 8);
               _loc8_ = _temp_30;
               sf64(_loc8_,_loc2_);
               ESP = _loc2_;
               F_fmax();
               _loc2_ += 16;
               _loc8_ = st0;
               si32(int(_loc8_),_loc3_ - 40);
            }
            _loc1_ = li32(_loc3_ - 56);
            _loc1_ += 1;
            si32(_loc1_,_loc3_ - 56);
         }
         si32(int(li32(_loc3_ - 52) + 1),_loc3_ - 52);
      }
      var _temp_35:* = li32(_loc3_ - 32);
      si32(int((_loc11_ = li32(_loc3_ - 40)) - _temp_35),_loc3_ - 44);
      var _temp_37:* = li32(_loc3_ - 28);
      _loc11_ = (_loc11_ = li32(_loc3_ - 36)) - _temp_37;
      si32(_loc11_,_loc3_ - 48);
      var _temp_46:* = li32(_loc3_ - 36);
      var _temp_39:* = li32(_loc3_ - 12);
      _loc2_ -= 16;
      var _loc13_:int;
      var _loc12_:Number = _loc13_ = _temp_39 + -1;
      sf64(_loc12_,_loc2_);
      _loc13_ = _loc11_ >> 31;
      var _temp_43:* = _loc13_ >>> 30;
      _loc11_ += _temp_43;
      _loc11_ = _loc11_ >> 2;
      _loc8_ = int(_loc11_ + _temp_46);
      sf64(_loc8_,_loc2_ + 8);
      ESP = _loc2_;
      F_fmin();
      _loc2_ += 16;
      _loc8_ = st0;
      si32(int(_loc8_),_loc3_ - 36);
      var _temp_57:* = li32(_loc3_ - 40);
      var _temp_53:* = li32(_loc3_ - 44);
      var _temp_50:* = li32(_loc3_ - 8);
      _loc2_ -= 16;
      _loc12_ = _loc13_ = _temp_50 + -1;
      sf64(_loc12_,_loc2_);
      _loc11_ = _temp_53 + ((_loc13_ = _temp_53 >> 31) >>> 30);
      _loc11_ = _loc11_ >> 2;
      _loc8_ = int(_loc11_ + _temp_57);
      sf64(_loc8_,_loc2_ + 8);
      ESP = _loc2_;
      F_fmin();
      _loc2_ += 16;
      _loc8_ = st0;
      si32(int(_loc8_),_loc3_ - 40);
      var _temp_64:* = li32(_loc3_ - 28);
      var _temp_61:* = li32(_loc3_ - 48);
      _loc2_ -= 16;
      si32(0,_loc2_ + 4);
      si32(0,_loc2_);
      _loc11_ = _temp_61 + ((_loc13_ = _temp_61 >> 31) >>> 30);
      _loc8_ = int(_temp_64 - (_loc11_ >> 2));
      sf64(_loc8_,_loc2_ + 8);
      ESP = _loc2_;
      F_fmax();
      _loc2_ += 16;
      _loc8_ = st0;
      si32(int(_loc8_),_loc3_ - 28);
      var _temp_71:* = li32(_loc3_ - 32);
      var _temp_68:* = li32(_loc3_ - 44);
      _loc2_ -= 16;
      si32(0,_loc2_ + 4);
      si32(0,_loc2_);
      _loc11_ = _temp_68 + ((_loc13_ = _temp_68 >> 31) >>> 30);
      _loc8_ = int(_temp_71 - (_loc11_ >> 2));
      sf64(_loc8_,_loc2_ + 8);
      ESP = _loc2_;
      F_fmax();
      _loc2_ += 16;
      _loc13_ = _loc8_ = st0;
      si32(_loc13_,_loc3_ - 32);
      var _temp_78:* = li32(_loc3_ - 28);
      var _temp_77:* = li32(_loc3_ - 36);
      var _temp_76:* = li32(_loc3_ - 40);
      _loc2_ -= 32;
      si32(_temp_76,_loc2_ + 16);
      si32(_temp_77,_loc2_ + 12);
      si32(_loc13_,_loc2_ + 8);
      si32(_temp_78,_loc2_ + 4);
      si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.L__2E_str9,_loc2_);
      ESP = _loc2_;
      F_printf();
      _loc2_ += 32;
      si32(li32(_loc3_ - 28),_loc3_ - 60);
      while(true)
      {
         _loc11_ = li32(_loc3_ - 36);
         _loc1_ = li32(_loc3_ - 60);
         if(_loc1_ > _loc11_)
         {
            break;
         }
         var _temp_84:* = li32(_loc3_ - 4);
         var _temp_83:* = li32(_loc3_ - 8);
         var _temp_82:* = li32(_loc3_ - 12);
         var _temp_81:* = li32(_loc3_ - 32);
         var _temp_80:* = li32(_loc3_ - 60);
         _loc2_ -= 32;
         si32(_temp_80,_loc2_ + 16);
         si32(_temp_81,_loc2_ + 12);
         si32(_temp_82,_loc2_ + 8);
         si32(_temp_83,_loc2_ + 4);
         si32(_temp_84,_loc2_);
         ESP = _loc2_;
         F_whatSegment();
         _loc7_ = 1;
         _loc2_ += 32;
         if(eax != -1)
         {
            _loc7_ = 0;
         }
         _loc1_ = _loc7_ & 1;
         si8(_loc1_,_loc3_ - 16);
         if(_loc1_ != 0)
         {
            var _temp_90:* = li32(_loc3_ - 4);
            var _temp_89:* = li32(_loc3_ - 8);
            var _temp_88:* = li32(_loc3_ - 12);
            var _temp_87:* = li32(_loc3_ - 32);
            var _temp_86:* = li32(_loc3_ - 60);
            _loc2_ -= 48;
            si32(255,_loc2_ + 32);
            si32(0,_loc2_ + 28);
            si32(0,_loc2_ + 24);
            si32(255,_loc2_ + 20);
            si32(_temp_86,_loc2_ + 16);
            si32(_temp_87,_loc2_ + 12);
            si32(_temp_88,_loc2_ + 8);
            si32(_temp_89,_loc2_ + 4);
            si32(_temp_90,_loc2_);
            ESP = _loc2_;
            F_setPixel();
            _loc2_ += 48;
         }
         _loc1_ = li32(_loc3_ - 4);
         _loc11_ = li32(_loc3_ - 8);
         _loc13_ = li32(_loc3_ - 12);
         var _loc14_:int = li32(_loc3_ - 40);
         var _loc15_:int = li32(_loc3_ - 60);
         _loc2_ -= 32;
         si32(_loc15_,_loc2_ + 16);
         si32(_loc14_,_loc2_ + 12);
         si32(_loc13_,_loc2_ + 8);
         si32(_loc11_,_loc2_ + 4);
         si32(_loc1_,_loc2_);
         ESP = _loc2_;
         F_whatSegment();
         _loc6_ = 1;
         _loc2_ += 32;
         _loc1_ = eax;
         if(_loc1_ != -1)
         {
            _loc6_ = 0;
         }
         _loc1_ = _loc6_ & 1;
         si8(_loc1_,_loc3_ - 15);
         if(_loc1_ != 0)
         {
            var _temp_97:* = li32(_loc3_ - 4);
            var _temp_96:* = li32(_loc3_ - 8);
            var _temp_95:* = li32(_loc3_ - 12);
            var _temp_94:* = li32(_loc3_ - 40);
            var _temp_93:* = li32(_loc3_ - 60);
            _loc2_ -= 48;
            si32(255,_loc2_ + 32);
            si32(0,_loc2_ + 28);
            si32(0,_loc2_ + 24);
            si32(255,_loc2_ + 20);
            si32(_temp_93,_loc2_ + 16);
            si32(_temp_94,_loc2_ + 12);
            si32(_temp_95,_loc2_ + 8);
            si32(_temp_96,_loc2_ + 4);
            si32(_temp_97,_loc2_);
            ESP = _loc2_;
            F_setPixel();
            _loc2_ += 48;
         }
         _loc1_ = li32(_loc3_ - 60);
         _loc1_ += 1;
         si32(_loc1_,_loc3_ - 60);
      }
      si32(li32(_loc3_ - 32),_loc3_ - 64);
      while(true)
      {
         _loc11_ = li32(_loc3_ - 40);
         _loc1_ = li32(_loc3_ - 64);
         if(_loc1_ > _loc11_)
         {
            break;
         }
         var _temp_103:* = li32(_loc3_ - 4);
         var _temp_102:* = li32(_loc3_ - 8);
         var _temp_101:* = li32(_loc3_ - 12);
         var _temp_100:* = li32(_loc3_ - 64);
         var _temp_99:* = li32(_loc3_ - 28);
         _loc2_ -= 32;
         si32(_temp_99,_loc2_ + 16);
         si32(_temp_100,_loc2_ + 12);
         si32(_temp_101,_loc2_ + 8);
         si32(_temp_102,_loc2_ + 4);
         si32(_temp_103,_loc2_);
         ESP = _loc2_;
         F_whatSegment();
         _loc2_ += 32;
         var _temp_105:* = eax;
         _loc5_ = 1;
         if(_temp_105 != -1)
         {
            _loc5_ = 0;
         }
         _loc1_ = _loc5_ & 1;
         si8(_loc1_,_loc3_ - 14);
         if(_loc1_ != 0)
         {
            var _temp_110:* = li32(_loc3_ - 4);
            var _temp_109:* = li32(_loc3_ - 8);
            var _temp_108:* = li32(_loc3_ - 12);
            var _temp_107:* = li32(_loc3_ - 64);
            var _temp_106:* = li32(_loc3_ - 28);
            _loc2_ -= 48;
            si32(255,_loc2_ + 32);
            si32(0,_loc2_ + 28);
            si32(0,_loc2_ + 24);
            si32(255,_loc2_ + 20);
            si32(_temp_106,_loc2_ + 16);
            si32(_temp_107,_loc2_ + 12);
            si32(_temp_108,_loc2_ + 8);
            si32(_temp_109,_loc2_ + 4);
            si32(_temp_110,_loc2_);
            ESP = _loc2_;
            F_setPixel();
            _loc2_ += 48;
         }
         _loc1_ = li32(_loc3_ - 4);
         _loc11_ = li32(_loc3_ - 8);
         _loc13_ = li32(_loc3_ - 12);
         _loc14_ = li32(_loc3_ - 64);
         _loc15_ = li32(_loc3_ - 36);
         _loc2_ -= 32;
         si32(_loc15_,_loc2_ + 16);
         si32(_loc14_,_loc2_ + 12);
         si32(_loc13_,_loc2_ + 8);
         si32(_loc11_,_loc2_ + 4);
         si32(_loc1_,_loc2_);
         ESP = _loc2_;
         F_whatSegment();
         _loc4_ = 1;
         _loc2_ += 32;
         _loc1_ = eax;
         if(_loc1_ != -1)
         {
            _loc4_ = 0;
         }
         _loc1_ = _loc4_ & 1;
         si8(_loc1_,_loc3_ - 13);
         if(_loc1_ != 0)
         {
            var _temp_117:* = li32(_loc3_ - 4);
            var _temp_116:* = li32(_loc3_ - 8);
            var _temp_115:* = li32(_loc3_ - 12);
            var _temp_114:* = li32(_loc3_ - 64);
            var _temp_113:* = li32(_loc3_ - 36);
            _loc2_ -= 48;
            si32(255,_loc2_ + 32);
            si32(0,_loc2_ + 28);
            si32(0,_loc2_ + 24);
            si32(255,_loc2_ + 20);
            si32(_temp_113,_loc2_ + 16);
            si32(_temp_114,_loc2_ + 12);
            si32(_temp_115,_loc2_ + 8);
            si32(_temp_116,_loc2_ + 4);
            si32(_temp_117,_loc2_);
            ESP = _loc2_;
            F_setPixel();
            _loc2_ += 48;
         }
         _loc1_ = li32(_loc3_ - 64);
         _loc1_ += 1;
         si32(_loc1_,_loc3_ - 64);
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

