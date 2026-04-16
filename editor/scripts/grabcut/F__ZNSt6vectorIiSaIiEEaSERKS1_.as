package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F__ZNSt6vectorIiSaIiEEaSERKS1_() : void
   {
      var _temp_1:* = this;
      var _loc4_:int = 0;
      var _loc9_:int = 0;
      var _loc30_:int = 0;
      var _loc29_:int = 0;
      var _loc28_:int = 0;
      var _loc27_:int = 0;
      var _loc3_:int = 0;
      var _loc14_:int = 0;
      var _loc13_:int = 0;
      var _loc12_:int = 0;
      var _loc10_:int = 0;
      var _loc7_:int = 0;
      var _loc8_:int = 0;
      var _loc5_:int = 0;
      var _loc6_:int = 0;
      var _loc15_:int = 0;
      var _loc16_:int = 0;
      var _loc17_:int = 0;
      var _loc18_:int = 0;
      var _loc24_:int = 0;
      var _loc23_:int = 0;
      var _loc19_:int = 0;
      var _loc20_:int = 0;
      var _loc21_:int = 0;
      var _loc25_:int = 0;
      var _loc11_:int = 0;
      var _loc2_:int = 0;
      var _loc26_:int = 0;
      var _loc22_:int = 0;
      var _loc1_:int = ESP;
      while(true)
      {
         try
         {
            if(!_loc9_)
            {
               _loc4_ = _loc1_;
               _loc1_ -= 256;
               _loc14_ = li32(_loc4_);
               si32(_loc14_,_loc4_ - 60);
               _loc30_ = li32(_loc4_ + 4);
               si32(_loc30_,_loc4_ - 64);
               _loc29_ = li32(_loc4_ - 60);
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.L_LSDA_76,_loc4_ - 28);
               si32(___gxx_personality_sj0,_loc4_ - 32);
               _loc14_ = _loc4_;
               si32(_loc14_,_loc4_ - 24);
               _loc14_ = _loc1_;
               si32(_loc14_,_loc4_ - 16);
               _loc28_ = _loc4_ - 56;
               _loc27_ = _loc28_ + 32;
               eax = setjmp(_loc27_,1,_loc1_);
            }
            else
            {
               switch(_loc9_ - 1)
               {
                  case 0:
                  default:
                     throw "bad longjmp";
               }
            }
            _loc14_ = eax;
            if(_loc14_ == 0)
            {
               _loc1_ -= 16;
               si32(_loc28_,_loc1_);
               ESP = _loc1_;
               F__Unwind_SjLj_Register();
               _loc1_ += 16;
               if(_loc30_ != _loc29_)
               {
                  _loc14_ = li32(_loc4_ - 64);
                  _loc1_ -= 16;
                  si32(_loc14_,_loc1_);
                  ESP = _loc1_;
                  F__ZNKSt6vectorIiSaIiEE4sizeEv();
                  _loc1_ += 16;
                  _loc14_ = eax;
                  si32(_loc14_,_loc4_ - 240);
                  _loc14_ = li32(_loc4_ - 60);
                  _loc1_ -= 16;
                  si32(_loc14_,_loc1_);
                  ESP = _loc1_;
                  F__ZNKSt6vectorIiSaIiEE8capacityEv();
                  _loc26_ = 1;
                  _loc1_ += 16;
                  _loc14_ = eax;
                  _loc25_ = li32(_loc4_ - 240);
                  if(uint(_loc14_) >= uint(_loc25_))
                  {
                     _loc26_ = 0;
                  }
                  _loc14_ = _loc26_ & 1;
                  si8(_loc14_,_loc4_ - 233);
                  if(_loc14_ != 0)
                  {
                     _loc24_ = _loc28_ | 4;
                     _loc14_ = li32(_loc4_ - 64);
                     si32(-1,_loc24_);
                     _loc1_ -= 16;
                     si32(_loc14_,_loc1_);
                     ESP = _loc1_;
                     F__ZNKSt6vectorIiSaIiEE5beginEv();
                     _loc1_ += 16;
                     _loc14_ = eax;
                     si32(_loc14_,_loc4_ - 224);
                     si32(_loc14_,_loc4_ - 232);
                     _loc14_ = li32(_loc4_ - 64);
                     si32(-1,_loc24_);
                     _loc1_ -= 16;
                     si32(_loc14_,_loc1_);
                     ESP = _loc1_;
                     F__ZNKSt6vectorIiSaIiEE3endEv();
                     _loc1_ += 16;
                     _loc23_ = eax;
                     si32(_loc23_,_loc4_ - 208);
                     si32(_loc23_,_loc4_ - 216);
                     _loc11_ = li32(_loc4_ - 60);
                     _loc25_ = li32(_loc4_ - 240);
                     _loc14_ = li32(_loc4_ - 232);
                     si32(-1,_loc24_);
                     _loc1_ -= 16;
                     si32(_loc23_,_loc1_ + 12);
                     si32(_loc14_,_loc1_ + 8);
                     si32(_loc25_,_loc1_ + 4);
                     si32(_loc11_,_loc1_);
                     ESP = _loc1_;
                     F__ZNSt6vectorIiSaIiEE20_M_allocate_and_copyIN9__gnu_cxx17__normal_iteratorIPKiS1_EEEEPijT_S9_();
                     _loc1_ += 16;
                     _loc14_ = eax;
                     si32(_loc14_,_loc4_ - 244);
                     _loc14_ = li32(_loc4_ - 60);
                     _loc19_ = li32(_loc14_);
                     _loc20_ = li32(_loc14_ + 4);
                     _loc1_ -= 16;
                     si32(_loc14_,_loc1_);
                     ESP = _loc1_;
                     F__ZNSt12_Vector_baseIiSaIiEE19_M_get_Tp_allocatorEv();
                     _loc1_ += 16;
                     _loc14_ = eax;
                     _loc1_ -= 16;
                     si32(_loc14_,_loc1_ + 4);
                     _loc21_ = _loc4_ - 200;
                     si32(_loc21_,_loc1_);
                     ESP = _loc1_;
                     F__ZNSaIiEC1ERKS_();
                     _loc1_ += 16;
                     si32(1,_loc24_);
                     _loc1_ -= 16;
                     si32(_loc21_,_loc1_ + 8);
                     si32(_loc20_,_loc1_ + 4);
                     si32(_loc19_,_loc1_);
                     ESP = _loc1_;
                     F__ZSt8_DestroyIPiiEvT_S1_SaIT0_E();
                     _loc1_ += 16;
                     _loc1_ -= 16;
                     si32(_loc21_,_loc1_);
                     ESP = _loc1_;
                     F__ZNSaIiED1Ev();
                     _loc1_ += 16;
                     _loc14_ = li32(_loc4_ - 60);
                     _loc25_ = li32(_loc14_ + 8);
                     _loc11_ = li32(_loc14_);
                     si32(-1,_loc24_);
                     _loc1_ -= 16;
                     si32(_loc11_,_loc1_ + 4);
                     si32(_loc14_,_loc1_);
                     _loc14_ = _loc25_ - _loc11_;
                     _loc25_ = _loc14_ >> 31;
                     _loc25_ = _loc25_ >>> 30;
                     _loc14_ += _loc25_;
                     _loc14_ = _loc14_ >> 2;
                     si32(_loc14_,_loc1_ + 8);
                     ESP = _loc1_;
                     F__ZNSt12_Vector_baseIiSaIiEE13_M_deallocateEPij();
                     _loc1_ += 16;
                     _loc25_ = li32(_loc4_ - 244);
                     _loc14_ = li32(_loc4_ - 60);
                     si32(_loc25_,_loc14_);
                     _loc14_ = li32(_loc4_ - 240);
                     _loc11_ = _loc14_ << 2;
                     _loc14_ = li32(_loc4_ - 60);
                     _loc25_ = li32(_loc14_);
                     _loc25_ = _loc25_ + _loc11_;
                     si32(_loc25_,_loc14_ + 8);
                  }
                  else
                  {
                     _loc14_ = li32(_loc4_ - 60);
                     _loc1_ -= 16;
                     si32(_loc14_,_loc1_);
                     ESP = _loc1_;
                     F__ZNKSt6vectorIiSaIiEE4sizeEv();
                     _loc22_ = 1;
                     _loc1_ += 16;
                     _loc14_ = eax;
                     _loc25_ = li32(_loc4_ - 240);
                     if(uint(_loc14_) < uint(_loc25_))
                     {
                        _loc22_ = 0;
                     }
                     _loc14_ = _loc22_ & 1;
                     si8(_loc14_,_loc4_ - 193);
                     if(_loc14_ != 0)
                     {
                        _loc15_ = _loc28_ | 4;
                        _loc14_ = li32(_loc4_ - 64);
                        si32(-1,_loc15_);
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_);
                        ESP = _loc1_;
                        F__ZNKSt6vectorIiSaIiEE5beginEv();
                        _loc1_ += 16;
                        _loc14_ = eax;
                        si32(_loc14_,_loc4_ - 176);
                        si32(_loc14_,_loc4_ - 184);
                        _loc14_ = li32(_loc4_ - 64);
                        si32(-1,_loc15_);
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_);
                        ESP = _loc1_;
                        F__ZNKSt6vectorIiSaIiEE3endEv();
                        _loc1_ += 16;
                        _loc14_ = eax;
                        si32(_loc14_,_loc4_ - 160);
                        si32(_loc14_,_loc4_ - 168);
                        _loc14_ = li32(_loc4_ - 60);
                        si32(-1,_loc15_);
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSt6vectorIiSaIiEE5beginEv();
                        _loc1_ += 16;
                        _loc11_ = eax;
                        si32(_loc11_,_loc4_ - 144);
                        si32(_loc11_,_loc4_ - 152);
                        _loc25_ = li32(_loc4_ - 184);
                        _loc14_ = li32(_loc4_ - 168);
                        si32(-1,_loc15_);
                        _loc1_ -= 16;
                        si32(_loc11_,_loc1_ + 8);
                        si32(_loc14_,_loc1_ + 4);
                        si32(_loc25_,_loc1_);
                        ESP = _loc1_;
                        F__ZSt4copyIN9__gnu_cxx17__normal_iteratorIPKiSt6vectorIiSaIiEEEENS1_IPiS6_EEET0_T_SB_SA_();
                        _loc1_ += 16;
                        _loc14_ = eax;
                        si32(_loc14_,_loc4_ - 136);
                        si32(_loc14_,_loc4_ - 192);
                        _loc14_ = li32(_loc4_ - 60);
                        si32(-1,_loc15_);
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSt6vectorIiSaIiEE3endEv();
                        _loc1_ += 16;
                        _loc14_ = eax;
                        si32(_loc14_,_loc4_ - 120);
                        si32(_loc14_,_loc4_ - 128);
                        _loc14_ = li32(_loc4_ - 60);
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSt12_Vector_baseIiSaIiEE19_M_get_Tp_allocatorEv();
                        _loc1_ += 16;
                        _loc14_ = eax;
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_ + 4);
                        _loc16_ = _loc4_ - 112;
                        si32(_loc16_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSaIiEC1ERKS_();
                        _loc1_ += 16;
                        _loc17_ = li32(_loc4_ - 192);
                        _loc18_ = li32(_loc4_ - 128);
                        si32(2,_loc15_);
                        _loc1_ -= 16;
                        si32(_loc16_,_loc1_ + 8);
                        si32(_loc18_,_loc1_ + 4);
                        si32(_loc17_,_loc1_);
                        ESP = _loc1_;
                        F__ZSt8_DestroyIN9__gnu_cxx17__normal_iteratorIPiSt6vectorIiSaIiEEEEiEvT_S7_SaIT0_E();
                        _loc1_ += 16;
                        _loc1_ -= 16;
                        si32(_loc16_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSaIiED1Ev();
                        _loc1_ += 16;
                     }
                     else
                     {
                        _loc14_ = li32(_loc4_ - 64);
                        _loc13_ = li32(_loc14_);
                        _loc14_ = li32(_loc4_ - 60);
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_);
                        ESP = _loc1_;
                        F__ZNKSt6vectorIiSaIiEE4sizeEv();
                        _loc1_ += 16;
                        _loc14_ = eax;
                        _loc25_ = li32(_loc4_ - 60);
                        _loc25_ = li32(_loc25_);
                        _loc12_ = _loc28_ | 4;
                        si32(-1,_loc12_);
                        _loc1_ -= 16;
                        si32(_loc25_,_loc1_ + 8);
                        _loc14_ <<= 2;
                        _loc14_ = _loc13_ + _loc14_;
                        si32(_loc14_,_loc1_ + 4);
                        si32(_loc13_,_loc1_);
                        ESP = _loc1_;
                        F__ZSt4copyIPiS0_ET0_T_S2_S1_();
                        _loc1_ += 16;
                        _loc14_ = li32(_loc4_ - 64);
                        _loc10_ = li32(_loc14_);
                        _loc14_ = li32(_loc4_ - 60);
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_);
                        ESP = _loc1_;
                        F__ZNKSt6vectorIiSaIiEE4sizeEv();
                        _loc1_ += 16;
                        _loc7_ = eax;
                        _loc14_ = li32(_loc4_ - 64);
                        _loc8_ = li32(_loc14_ + 4);
                        _loc14_ = li32(_loc4_ - 60);
                        _loc5_ = li32(_loc14_ + 4);
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSt12_Vector_baseIiSaIiEE19_M_get_Tp_allocatorEv();
                        _loc1_ += 16;
                        _loc14_ = eax;
                        _loc1_ -= 16;
                        si32(_loc14_,_loc1_ + 4);
                        _loc6_ = _loc4_ - 104;
                        si32(_loc6_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSaIiEC1ERKS_();
                        _loc1_ += 16;
                        si32(3,_loc12_);
                        _loc1_ -= 16;
                        si32(_loc6_,_loc1_ + 12);
                        si32(_loc5_,_loc1_ + 8);
                        si32(_loc8_,_loc1_ + 4);
                        _loc14_ = _loc7_ << 2;
                        _loc14_ = _loc10_ + _loc14_;
                        si32(_loc14_,_loc1_);
                        ESP = _loc1_;
                        F__ZSt22__uninitialized_copy_aIPiS0_iET0_T_S2_S1_SaIT1_E();
                        _loc1_ += 16;
                        _loc1_ -= 16;
                        si32(_loc6_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSaIiED1Ev();
                        _loc1_ += 16;
                     }
                  }
                  _loc14_ = li32(_loc4_ - 240);
                  _loc25_ = _loc14_ << 2;
                  _loc14_ = li32(_loc4_ - 60);
                  _loc11_ = li32(_loc14_);
                  _loc25_ = _loc11_ + _loc25_;
                  si32(_loc25_,_loc14_ + 4);
               }
               _loc14_ = li32(_loc4_ - 60);
               si32(_loc14_,_loc4_ - 96);
               si32(_loc14_,_loc4_ - 68);
               _loc2_ = li32(_loc4_ - 68);
               _loc1_ -= 16;
               si32(_loc28_,_loc1_);
               ESP = _loc1_;
               F__Unwind_SjLj_Unregister();
               _loc1_ += 16;
               eax = _loc2_;
               _loc1_ = _loc4_;
               ESP = _loc1_;
               return;
            }
            while(true)
            {
               _loc14_ = _loc28_ | 4;
               _loc3_ = li32(_loc14_);
               if(_loc3_ != 0)
               {
                  if(_loc3_ != 1)
                  {
                     if(_loc3_ != 2)
                     {
                        break;
                     }
                     _loc14_ = li32(_loc4_ - 48);
                     si32(_loc14_,_loc4_ - 248);
                     _loc14_ = li32(_loc4_ - 44);
                     si32(_loc14_,_loc4_ - 252);
                     _loc14_ = li32(_loc4_ - 252);
                     si32(_loc14_,_loc4_ - 72);
                     _loc14_ = li32(_loc4_ - 248);
                     si32(_loc14_,_loc4_ - 76);
                     _loc1_ -= 16;
                     _loc14_ = _loc4_ - 104;
                     si32(_loc14_,_loc1_);
                     ESP = _loc1_;
                     F__ZNSaIiED1Ev();
                     _loc1_ += 16;
                     _loc14_ = li32(_loc4_ - 76);
                     si32(_loc14_,_loc4_ - 248);
                     _loc14_ = li32(_loc4_ - 72);
                     si32(_loc14_,_loc4_ - 252);
                  }
                  else
                  {
                     _loc14_ = li32(_loc4_ - 48);
                     si32(_loc14_,_loc4_ - 248);
                     _loc14_ = li32(_loc4_ - 44);
                     si32(_loc14_,_loc4_ - 252);
                     _loc14_ = li32(_loc4_ - 252);
                     si32(_loc14_,_loc4_ - 80);
                     _loc14_ = li32(_loc4_ - 248);
                     si32(_loc14_,_loc4_ - 84);
                     _loc1_ -= 16;
                     _loc14_ = _loc4_ - 112;
                     si32(_loc14_,_loc1_);
                     ESP = _loc1_;
                     F__ZNSaIiED1Ev();
                     _loc1_ += 16;
                     _loc14_ = li32(_loc4_ - 84);
                     si32(_loc14_,_loc4_ - 248);
                     _loc14_ = li32(_loc4_ - 80);
                     si32(_loc14_,_loc4_ - 252);
                  }
               }
               else
               {
                  _loc14_ = li32(_loc4_ - 48);
                  si32(_loc14_,_loc4_ - 248);
                  _loc14_ = li32(_loc4_ - 44);
                  si32(_loc14_,_loc4_ - 252);
                  _loc14_ = li32(_loc4_ - 252);
                  si32(_loc14_,_loc4_ - 88);
                  _loc14_ = li32(_loc4_ - 248);
                  si32(_loc14_,_loc4_ - 92);
                  _loc1_ -= 16;
                  _loc14_ = _loc4_ - 200;
                  si32(_loc14_,_loc1_);
                  ESP = _loc1_;
                  F__ZNSaIiED1Ev();
                  _loc1_ += 16;
                  _loc14_ = li32(_loc4_ - 92);
                  si32(_loc14_,_loc4_ - 248);
                  _loc14_ = li32(_loc4_ - 88);
                  si32(_loc14_,_loc4_ - 252);
               }
               _loc14_ = _loc28_ | 4;
               _loc25_ = li32(_loc4_ - 248);
               si32(-1,_loc14_);
               _loc1_ -= 16;
               si32(_loc25_,_loc1_);
               ESP = _loc1_;
               F__Unwind_SjLj_Resume();
               _loc1_ += 16;
            }
            while(true)
            {
            }
         }
         catch(l:LongJmp)
         {
            var _temp_105:* = this;
            var _temp_106:* = l;
            if(l.esp >= _loc4_)
            {
               throw l;
            }
         }
         ESP = _loc1_ = int(l.esp);
         eax = l.retval;
         _loc9_ = int(l.sjid);
      }
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

