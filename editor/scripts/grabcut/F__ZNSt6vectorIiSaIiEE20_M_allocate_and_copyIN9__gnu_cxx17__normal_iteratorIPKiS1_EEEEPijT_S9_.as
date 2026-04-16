package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F__ZNSt6vectorIiSaIiEE20_M_allocate_and_copyIN9__gnu_cxx17__normal_iteratorIPKiS1_EEEEPijT_S9_() : void
   {
      var _temp_1:* = this;
      var _loc5_:int = 0;
      var _loc10_:int = 0;
      var _loc14_:int = 0;
      var _loc15_:int = 0;
      var _loc16_:int = 0;
      var _loc18_:int = 0;
      var _loc17_:int = 0;
      var _loc13_:int = 0;
      var _loc12_:int = 0;
      var _loc2_:int = 0;
      var _loc4_:int = 0;
      var _loc11_:int = 0;
      var _loc1_:int = 0;
      var _loc6_:int = 0;
      var _loc7_:int = 0;
      var _loc8_:int = 0;
      var _loc9_:int = 0;
      var _loc3_:int = ESP;
      while(true)
      {
         try
         {
            if(!_loc10_)
            {
               _loc5_ = _loc3_;
               _loc3_ -= 128;
               _loc4_ = li32(_loc5_);
               si32(_loc4_,_loc5_ - 60);
               _loc4_ = li32(_loc5_ + 4);
               si32(_loc4_,_loc5_ - 64);
               _loc4_ = li32(_loc5_ + 8);
               si32(_loc4_,_loc5_ - 72);
               _loc4_ = li32(_loc5_ + 12);
               si32(_loc4_,_loc5_ - 80);
               _loc18_ = li32(_loc5_ - 60);
               _loc4_ = li32(_loc5_ - 64);
               _loc3_ -= 16;
               si32(_loc4_,_loc3_ + 4);
               si32(_loc18_,_loc3_);
               ESP = _loc3_;
               F__ZNSt12_Vector_baseIiSaIiEE11_M_allocateEj();
               _loc3_ += 16;
               _loc4_ = eax;
               si32(_loc4_,_loc5_ - 116);
               _loc4_ = li32(_loc5_ - 60);
               _loc3_ -= 16;
               si32(_loc4_,_loc3_);
               ESP = _loc3_;
               F__ZNSt12_Vector_baseIiSaIiEE19_M_get_Tp_allocatorEv();
               _loc3_ += 16;
               _loc4_ = eax;
               _loc3_ -= 16;
               si32(_loc4_,_loc3_ + 4);
               _loc17_ = _loc5_ - 112;
               si32(_loc17_,_loc3_);
               ESP = _loc3_;
               F__ZNSaIiEC1ERKS_();
               _loc3_ += 16;
               _loc16_ = li32(_loc5_ - 116);
               _loc15_ = li32(_loc5_ - 80);
               _loc14_ = li32(_loc5_ - 72);
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.L_LSDA_67,_loc5_ - 28);
               si32(___gxx_personality_sj0,_loc5_ - 32);
               _loc4_ = _loc5_;
               si32(_loc4_,_loc5_ - 24);
               _loc4_ = _loc3_;
               si32(_loc4_,_loc5_ - 16);
               _loc13_ = _loc5_ - 56;
               _loc12_ = _loc13_ + 32;
               eax = setjmp(_loc12_,1,_loc3_);
            }
            else
            {
               switch(_loc10_ - 1)
               {
                  case 0:
                  default:
                     throw "bad longjmp";
               }
            }
            _loc4_ = eax;
            if(_loc4_ == 0)
            {
               _loc3_ -= 16;
               si32(_loc13_,_loc3_);
               ESP = _loc3_;
               F__Unwind_SjLj_Register();
               _loc3_ += 16;
               _loc4_ = _loc13_ | 4;
               si32(1,_loc4_);
               _loc3_ -= 16;
               si32(_loc17_,_loc3_ + 12);
               si32(_loc16_,_loc3_ + 8);
               si32(_loc15_,_loc3_ + 4);
               si32(_loc14_,_loc3_);
               ESP = _loc3_;
               F__ZSt22__uninitialized_copy_aIN9__gnu_cxx17__normal_iteratorIPKiSt6vectorIiSaIiEEEEPiiET0_T_SA_S9_SaIT1_E();
               _loc3_ += 16;
               _loc3_ -= 16;
               si32(_loc17_,_loc3_);
               ESP = _loc3_;
               F__ZNSaIiED1Ev();
               _loc3_ += 16;
               _loc4_ = li32(_loc5_ - 116);
               si32(_loc4_,_loc5_ - 104);
               si32(_loc4_,_loc5_ - 84);
            }
            else
            {
               while(true)
               {
                  _loc4_ = _loc13_ | 4;
                  _loc2_ = li32(_loc4_);
                  if(_loc2_ != 0)
                  {
                     _loc4_ = _loc2_ + -1;
                     if((uint(_loc4_)) >= 2)
                     {
                        break;
                     }
                     _loc4_ = li32(_loc5_ - 48);
                     si32(_loc4_,_loc5_ - 120);
                     _loc4_ = li32(_loc5_ - 44);
                     si32(_loc4_,_loc5_ - 124);
                  }
                  else
                  {
                     _loc4_ = li32(_loc5_ - 48);
                     si32(_loc4_,_loc5_ - 120);
                     _loc4_ = li32(_loc5_ - 44);
                     si32(_loc4_,_loc5_ - 124);
                     _loc4_ = li32(_loc5_ - 124);
                     si32(_loc4_,_loc5_ - 96);
                     _loc4_ = li32(_loc5_ - 120);
                     si32(_loc4_,_loc5_ - 100);
                     _loc3_ -= 16;
                     si32(_loc17_,_loc3_);
                     ESP = _loc3_;
                     F__ZNSaIiED1Ev();
                     _loc3_ += 16;
                     _loc4_ = li32(_loc5_ - 100);
                     si32(_loc4_,_loc5_ - 120);
                     _loc4_ = li32(_loc5_ - 96);
                     si32(_loc4_,_loc5_ - 124);
                     _loc4_ = li32(_loc5_ - 120);
                     _loc3_ -= 16;
                     si32(_loc4_,_loc3_);
                     ESP = _loc3_;
                     F___cxa_begin_catch();
                     _loc3_ += 16;
                     _loc11_ = _loc13_ | 4;
                     _loc1_ = li32(_loc5_ - 60);
                     _loc6_ = li32(_loc5_ - 116);
                     _loc7_ = li32(_loc5_ - 64);
                     si32(2,_loc11_);
                     _loc3_ -= 16;
                     si32(_loc7_,_loc3_ + 8);
                     si32(_loc6_,_loc3_ + 4);
                     si32(_loc1_,_loc3_);
                     ESP = _loc3_;
                     F__ZNSt12_Vector_baseIiSaIiEE13_M_deallocateEPij();
                     _loc3_ += 16;
                     si32(3,_loc11_);
                     ESP = _loc3_;
                     F___cxa_rethrow();
                  }
                  _loc4_ = li32(_loc5_ - 124);
                  si32(_loc4_,_loc5_ - 88);
                  _loc4_ = li32(_loc5_ - 120);
                  si32(_loc4_,_loc5_ - 92);
                  _loc8_ = _loc13_ | 4;
                  si32(4,_loc8_);
                  ESP = _loc3_;
                  F___cxa_end_catch();
                  _loc4_ = li32(_loc5_ - 92);
                  si32(_loc4_,_loc5_ - 120);
                  _loc4_ = li32(_loc5_ - 88);
                  si32(_loc4_,_loc5_ - 124);
                  _loc4_ = li32(_loc5_ - 120);
                  si32(-1,_loc8_);
                  _loc3_ -= 16;
                  si32(_loc4_,_loc3_);
                  ESP = _loc3_;
                  F__Unwind_SjLj_Resume();
                  _loc3_ += 16;
               }
               if(_loc2_ != 3)
               {
                  while(true)
                  {
                  }
               }
               else
               {
                  _loc4_ = li32(_loc5_ - 48);
                  si32(_loc4_,_loc5_ - 120);
                  _loc4_ = li32(_loc5_ - 44);
                  si32(_loc4_,_loc5_ - 124);
                  ESP = _loc3_;
                  F__ZSt9terminatev();
               }
            }
            _loc9_ = li32(_loc5_ - 84);
            _loc3_ -= 16;
            si32(_loc13_,_loc3_);
            ESP = _loc3_;
            F__Unwind_SjLj_Unregister();
            _loc3_ += 16;
            eax = _loc9_;
            _loc3_ = _loc5_;
            ESP = _loc3_;
            return;
         }
         catch(l:LongJmp)
         {
            var _temp_49:* = this;
            var _temp_50:* = l;
            if(l.esp >= _loc5_)
            {
               throw l;
            }
         }
         ESP = _loc3_ = int(l.esp);
         eax = l.retval;
         _loc10_ = int(l.sjid);
      }
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

