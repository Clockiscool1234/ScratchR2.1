package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F__ZNSt12_Vector_baseIiSaIiEED2Ev() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc4_:int = 0;
      var _loc10_:int = 0;
      var _loc5_:int = 0;
      var _loc1_:int = 0;
      var _loc11_:int = 0;
      var _loc8_:int = 0;
      var _loc7_:int = 0;
      var _loc9_:int = 0;
      var _loc6_:int = 0;
      var _loc2_:int = ESP;
      while(true)
      {
         try
         {
            if(!_loc4_)
            {
               _loc3_ = _loc2_;
               _loc2_ -= 80;
               _loc1_ = li32(_loc3_);
               si32(_loc1_,_loc3_ - 60);
               _loc11_ = li32(_loc1_ + 8);
               _loc10_ = li32(_loc1_);
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.L_LSDA_49,_loc3_ - 28);
               si32(___gxx_personality_sj0,_loc3_ - 32);
               _loc9_ = _loc3_;
               si32(_loc9_,_loc3_ - 24);
               _loc9_ = _loc2_;
               si32(_loc9_,_loc3_ - 16);
               _loc8_ = _loc3_ - 56;
               _loc7_ = _loc8_ + 32;
               eax = setjmp(_loc7_,1,_loc2_);
            }
            else
            {
               switch(_loc4_ - 1)
               {
                  case 0:
                  default:
                     throw "bad longjmp";
               }
            }
            _loc9_ = eax;
            if(_loc9_ == 0)
            {
               _loc9_ = _loc11_ - _loc10_;
               _loc6_ = _loc9_ >> 31;
               _loc6_ = _loc6_ >>> 30;
               _loc9_ += _loc6_;
               _loc5_ = _loc9_ >> 2;
               _loc2_ -= 16;
               si32(_loc8_,_loc2_);
               ESP = _loc2_;
               F__Unwind_SjLj_Register();
               _loc2_ += 16;
               _loc9_ = _loc8_ | 4;
               si32(1,_loc9_);
               _loc2_ -= 16;
               si32(_loc5_,_loc2_ + 8);
               si32(_loc10_,_loc2_ + 4);
               si32(_loc1_,_loc2_);
               ESP = _loc2_;
               F__ZNSt12_Vector_baseIiSaIiEE13_M_deallocateEPij();
               _loc2_ += 16;
               _loc9_ = li32(_loc3_ - 60);
               si32(_loc9_,_loc3_ - 80);
               _loc2_ -= 16;
               si32(_loc9_,_loc2_);
               ESP = _loc2_;
               F__ZNSt12_Vector_baseIiSaIiEE12_Vector_implD1Ev();
               _loc2_ += 16;
               _loc2_ -= 16;
               si32(_loc8_,_loc2_);
               ESP = _loc2_;
               F__Unwind_SjLj_Unregister();
               _loc2_ += 16;
               _loc2_ = _loc3_;
               ESP = _loc2_;
               return;
            }
            while(true)
            {
               _loc9_ = _loc8_ | 4;
               _loc9_ = li32(_loc9_);
               if(_loc9_ != 0)
               {
                  break;
               }
               _loc9_ = li32(_loc3_ - 48);
               si32(_loc9_,_loc3_ - 72);
               _loc9_ = li32(_loc3_ - 44);
               si32(_loc9_,_loc3_ - 76);
               _loc9_ = li32(_loc3_ - 76);
               si32(_loc9_,_loc3_ - 64);
               _loc9_ = li32(_loc3_ - 72);
               si32(_loc9_,_loc3_ - 68);
               _loc9_ = li32(_loc3_ - 60);
               si32(_loc9_,_loc3_ - 80);
               _loc2_ -= 16;
               si32(_loc9_,_loc2_);
               ESP = _loc2_;
               F__ZNSt12_Vector_baseIiSaIiEE12_Vector_implD1Ev();
               _loc2_ += 16;
               _loc9_ = li32(_loc3_ - 68);
               si32(_loc9_,_loc3_ - 72);
               _loc9_ = li32(_loc3_ - 64);
               si32(_loc9_,_loc3_ - 76);
               _loc6_ = _loc8_ | 4;
               _loc9_ = li32(_loc3_ - 72);
               si32(-1,_loc6_);
               _loc2_ -= 16;
               si32(_loc9_,_loc2_);
               ESP = _loc2_;
               F__Unwind_SjLj_Resume();
               _loc2_ += 16;
            }
            while(true)
            {
            }
         }
         catch(l:LongJmp)
         {
            var _temp_30:* = this;
            var _temp_31:* = l;
            if(l.esp >= _loc3_)
            {
               throw l;
            }
         }
         ESP = _loc2_ = int(l.esp);
         eax = l.retval;
         _loc4_ = int(l.sjid);
      }
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

