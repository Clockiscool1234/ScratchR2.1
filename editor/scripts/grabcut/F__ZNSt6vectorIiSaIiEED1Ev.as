package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F__ZNSt6vectorIiSaIiEED1Ev() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc6_:int = 0;
      var _loc12_:int = 0;
      var _loc13_:int = 0;
      var _loc11_:int = 0;
      var _loc10_:int = 0;
      var _loc9_:int = 0;
      var _loc4_:int = 0;
      var _loc8_:int = 0;
      var _loc7_:int = 0;
      var _loc5_:int = 0;
      var _loc1_:int = 0;
      var _loc2_:int = ESP;
      while(true)
      {
         try
         {
            if(!_loc6_)
            {
               _loc3_ = _loc2_;
               _loc2_ -= 96;
               _loc1_ = li32(_loc3_);
               si32(_loc1_,_loc3_ - 60);
               _loc13_ = li32(_loc1_ + 4);
               _loc12_ = li32(_loc1_);
               _loc2_ -= 16;
               si32(_loc1_,_loc2_);
               ESP = _loc2_;
               F__ZNSt12_Vector_baseIiSaIiEE19_M_get_Tp_allocatorEv();
               _loc2_ += 16;
               _loc1_ = eax;
               _loc2_ -= 16;
               si32(_loc1_,_loc2_ + 4);
               _loc11_ = _loc3_ - 80;
               si32(_loc11_,_loc2_);
               ESP = _loc2_;
               F__ZNSaIiEC1ERKS_();
               _loc2_ += 16;
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.L_LSDA_51,_loc3_ - 28);
               si32(___gxx_personality_sj0,_loc3_ - 32);
               _loc1_ = _loc3_;
               si32(_loc1_,_loc3_ - 24);
               _loc1_ = _loc2_;
               si32(_loc1_,_loc3_ - 16);
               _loc10_ = _loc3_ - 56;
               _loc9_ = _loc10_ + 32;
               eax = setjmp(_loc9_,1,_loc2_);
            }
            else
            {
               switch(_loc6_ - 1)
               {
                  case 0:
                  default:
                     throw "bad longjmp";
               }
            }
            _loc1_ = eax;
            if(_loc1_ == 0)
            {
               _loc2_ -= 16;
               si32(_loc10_,_loc2_);
               ESP = _loc2_;
               F__Unwind_SjLj_Register();
               _loc2_ += 16;
               _loc8_ = _loc10_ | 4;
               si32(1,_loc8_);
               _loc2_ -= 16;
               si32(_loc11_,_loc2_ + 8);
               si32(_loc13_,_loc2_ + 4);
               si32(_loc12_,_loc2_);
               ESP = _loc2_;
               F__ZSt8_DestroyIPiiEvT_S1_SaIT0_E();
               _loc2_ += 16;
               _loc2_ -= 16;
               si32(_loc11_,_loc2_);
               ESP = _loc2_;
               F__ZNSaIiED1Ev();
               _loc2_ += 16;
               _loc1_ = li32(_loc3_ - 60);
               si32(_loc1_,_loc3_ - 92);
               si32(-1,_loc8_);
               _loc2_ -= 16;
               si32(_loc1_,_loc2_);
               ESP = _loc2_;
               F__ZNSt12_Vector_baseIiSaIiEED2Ev();
               _loc2_ += 16;
            }
            else
            {
               while(true)
               {
                  _loc1_ = _loc10_ | 4;
                  _loc4_ = li32(_loc1_);
                  if(_loc4_ != 0)
                  {
                     break;
                  }
                  _loc1_ = li32(_loc3_ - 48);
                  si32(_loc1_,_loc3_ - 84);
                  _loc1_ = li32(_loc3_ - 44);
                  si32(_loc1_,_loc3_ - 88);
                  _loc1_ = li32(_loc3_ - 88);
                  si32(_loc1_,_loc3_ - 72);
                  _loc1_ = li32(_loc3_ - 84);
                  si32(_loc1_,_loc3_ - 76);
                  _loc2_ -= 16;
                  si32(_loc11_,_loc2_);
                  ESP = _loc2_;
                  F__ZNSaIiED1Ev();
                  _loc2_ += 16;
                  _loc1_ = li32(_loc3_ - 76);
                  si32(_loc1_,_loc3_ - 84);
                  _loc1_ = li32(_loc3_ - 72);
                  si32(_loc1_,_loc3_ - 88);
                  _loc1_ = li32(_loc3_ - 88);
                  si32(_loc1_,_loc3_ - 64);
                  _loc1_ = li32(_loc3_ - 84);
                  si32(_loc1_,_loc3_ - 68);
                  _loc7_ = li32(_loc3_ - 60);
                  si32(_loc7_,_loc3_ - 92);
                  _loc5_ = _loc10_ | 4;
                  si32(2,_loc5_);
                  _loc2_ -= 16;
                  si32(_loc7_,_loc2_);
                  ESP = _loc2_;
                  F__ZNSt12_Vector_baseIiSaIiEED2Ev();
                  _loc2_ += 16;
                  _loc1_ = li32(_loc3_ - 68);
                  si32(_loc1_,_loc3_ - 84);
                  _loc1_ = li32(_loc3_ - 64);
                  si32(_loc1_,_loc3_ - 88);
                  _loc1_ = li32(_loc3_ - 84);
                  si32(-1,_loc5_);
                  _loc2_ -= 16;
                  si32(_loc1_,_loc2_);
                  ESP = _loc2_;
                  F__Unwind_SjLj_Resume();
                  _loc2_ += 16;
               }
               if(_loc4_ != 1)
               {
                  while(true)
                  {
                  }
               }
               else
               {
                  _loc1_ = li32(_loc3_ - 48);
                  si32(_loc1_,_loc3_ - 84);
                  _loc1_ = li32(_loc3_ - 44);
                  si32(_loc1_,_loc3_ - 88);
                  ESP = _loc2_;
                  F__ZSt9terminatev();
               }
            }
            _loc2_ -= 16;
            si32(_loc10_,_loc2_);
            ESP = _loc2_;
            F__Unwind_SjLj_Unregister();
            _loc2_ += 16;
            _loc2_ = _loc3_;
            ESP = _loc2_;
            return;
         }
         catch(l:LongJmp)
         {
            var _temp_22:* = this;
            var _temp_23:* = l;
            if(l.esp >= _loc3_)
            {
               throw l;
            }
         }
         ESP = _loc2_ = int(l.esp);
         eax = l.retval;
         _loc6_ = int(l.sjid);
      }
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

