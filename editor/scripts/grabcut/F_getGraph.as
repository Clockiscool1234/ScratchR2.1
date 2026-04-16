package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F_getGraph() : void
   {
      var _temp_1:* = this;
      var _loc2_:int = 0;
      var _loc7_:int = 0;
      var _loc26_:int = 0;
      var _loc23_:int = 0;
      var _loc9_:int = 0;
      var _loc32_:int = 0;
      var _loc30_:int = 0;
      var _loc11_:int = 0;
      var _loc28_:int = 0;
      var _loc24_:int = 0;
      var _loc22_:int = 0;
      var _loc20_:int = 0;
      var _loc14_:int = 0;
      var _loc53_:int = 0;
      var _loc54_:int = 0;
      var _loc55_:int = 0;
      var _loc56_:int = 0;
      var _loc49_:int = 0;
      var _loc50_:int = 0;
      var _loc44_:Number = NaN;
      var _loc51_:int = 0;
      var _loc52_:int = 0;
      var _loc12_:int = 0;
      var _loc48_:int = 0;
      var _loc47_:int = 0;
      var _loc43_:int = 0;
      var _loc41_:int = 0;
      var _loc42_:int = 0;
      var _loc39_:int = 0;
      var _loc40_:int = 0;
      var _loc37_:int = 0;
      var _loc38_:int = 0;
      var _loc35_:int = 0;
      var _loc36_:int = 0;
      var _loc34_:int = 0;
      var _loc17_:int = 0;
      var _loc46_:Number = NaN;
      var _loc16_:int = 0;
      var _loc21_:int = 0;
      var _loc19_:int = 0;
      var _loc25_:int = 0;
      var _loc29_:int = 0;
      var _loc27_:int = 0;
      var _loc33_:int = 0;
      var _loc15_:int = 0;
      var _loc18_:int = 0;
      var _loc31_:int = 0;
      var _loc45_:Number = NaN;
      var _loc5_:int = 0;
      var _loc4_:int = 0;
      var _loc3_:int = 0;
      var _loc10_:int = 0;
      var _loc8_:int = 0;
      var _loc6_:int = 0;
      var _loc13_:int = 0;
      var _loc1_:int = ESP;
      while(true)
      {
         try
         {
            if(!_loc7_)
            {
               _loc2_ = _loc1_;
               _loc1_ -= 208;
               _loc15_ = li32(_loc2_);
               si32(_loc15_,_loc2_ - 60);
               _loc15_ = li32(_loc2_ + 4);
               si32(_loc15_,_loc2_ - 64);
               _loc15_ = li32(_loc2_ + 8);
               si32(_loc15_,_loc2_ - 68);
               _loc15_ = li32(_loc2_ + 12);
               si32(_loc15_,_loc2_ - 72);
               _loc15_ = _loc1_;
               si32(_loc15_,_loc2_ - 120);
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.L_LSDA_78,_loc2_ - 28);
               si32(___gxx_personality_sj0,_loc2_ - 32);
               _loc15_ = _loc2_;
               si32(_loc15_,_loc2_ - 24);
               _loc15_ = _loc1_;
               si32(_loc15_,_loc2_ - 16);
               _loc32_ = _loc2_ - 56;
               _loc30_ = _loc32_ + 32;
               eax = setjmp(_loc30_,1,_loc1_);
            }
            else
            {
               switch(_loc7_ - 1)
               {
                  case 0:
                  default:
                     throw "bad longjmp";
               }
            }
            _loc15_ = eax;
            if(_loc15_ == 0)
            {
               _loc1_ -= 16;
               si32(_loc32_,_loc1_);
               ESP = _loc1_;
               F__Unwind_SjLj_Register();
               _loc1_ += 16;
               _loc28_ = _loc32_ | 4;
               si32(1,_loc28_);
               _loc1_ -= 16;
               si32(76,_loc1_);
               ESP = _loc1_;
               F__Znwj();
               _loc1_ += 16;
               _loc26_ = eax;
               si32(_loc26_,_loc2_ - 160);
               _loc24_ = li32(_loc2_ - 72);
               _loc22_ = li32(_loc2_ - 68);
               si32(2,_loc28_);
               _loc1_ -= 16;
               si32(0,_loc1_ + 12);
               si32(_loc26_,_loc1_);
               _loc15_ = _loc22_ * _loc24_;
               si32(_loc15_,_loc1_ + 4);
               _loc15_ <<= 3;
               si32(_loc15_,_loc1_ + 8);
               ESP = _loc1_;
               F__ZN5GraphIiiiEC1EiiPFvPcE();
               _loc1_ += 16;
               _loc20_ = li32(_loc2_ - 160);
               si32(_loc20_,_loc2_ - 164);
               _loc15_ = li32(_loc2_ - 72);
               _loc18_ = li32(_loc2_ - 68);
               si32(3,_loc28_);
               _loc14_ = _loc18_ * _loc15_;
               _loc1_ -= 16;
               si32(_loc14_,_loc1_ + 4);
               si32(_loc20_,_loc1_);
               ESP = _loc1_;
               F__ZN5GraphIiiiE8add_nodeEi();
               _loc1_ += 16;
               _loc15_ = li32(grabcut._BINS);
               _loc15_ = _loc15_ + -1;
               si32(_loc15_,_loc2_ - 156);
               _loc15_ <<= 2;
               _loc15_ = _loc15_ + 19;
               _loc18_ = _loc15_ & -16;
               _loc15_ = _loc1_;
               _loc15_ = _loc15_ - _loc18_;
               _loc1_ = _loc53_ = _loc15_ & -16;
               _loc15_ = _loc1_;
               si32(_loc15_,_loc2_ - 16);
               si32(_loc53_,_loc2_ - 152);
               _loc54_ = li32(_loc2_ - 60);
               _loc55_ = li32(_loc2_ - 64);
               _loc56_ = li32(_loc2_ - 68);
               _loc49_ = li32(_loc2_ - 72);
               si32(4,_loc28_);
               _loc1_ -= 32;
               si32(_loc49_,_loc1_ + 16);
               si32(_loc56_,_loc1_ + 12);
               si32(_loc53_,_loc1_ + 8);
               si32(_loc55_,_loc1_ + 4);
               si32(_loc54_,_loc1_);
               ESP = _loc1_;
               F_getProb();
               _loc1_ += 32;
               _loc15_ = li32(_loc2_ - 60);
               _loc18_ = li32(_loc2_ - 68);
               _loc50_ = li32(_loc2_ - 72);
               _loc1_ -= 16;
               si32(_loc50_,_loc1_ + 8);
               si32(_loc18_,_loc1_ + 4);
               si32(_loc15_,_loc1_);
               ESP = _loc1_;
               F_getBeta();
               _loc1_ += 16;
               _loc44_ = st0;
               sf32(_loc44_,_loc2_ - 168);
               si32(0,_loc2_ - 148);
               _loc1_ -= 16;
               _loc51_ = _loc2_ - 144;
               si32(_loc51_,_loc1_);
               ESP = _loc1_;
               F__ZNSaIiEC1Ev();
               _loc1_ += 16;
               si32(5,_loc28_);
               _loc1_ -= 16;
               si32(_loc51_,_loc1_ + 12);
               _loc15_ = _loc2_ - 148;
               si32(_loc15_,_loc1_ + 8);
               si32(2,_loc1_ + 4);
               _loc52_ = _loc2_ - 200;
               si32(_loc52_,_loc1_);
               ESP = _loc1_;
               F__ZNSt6vectorIiSaIiEEC1EjRKiRKS0_();
               _loc1_ += 16;
               _loc1_ -= 16;
               si32(_loc51_,_loc1_);
               ESP = _loc1_;
               F__ZNSaIiED1Ev();
               _loc1_ += 16;
               si32(0,_loc2_ - 172);
               loop2:
               while(true)
               {
                  _loc18_ = li32(_loc2_ - 68);
                  _loc15_ = li32(_loc2_ - 172);
                  if(_loc15_ < _loc18_)
                  {
                     si32(0,_loc2_ - 176);
                     while(true)
                     {
                        _loc15_ = li32(_loc2_ - 72);
                        _loc18_ = li32(_loc2_ - 176);
                        if(_loc18_ >= _loc15_)
                        {
                           continue loop2;
                        }
                        addr0697:
                        _loc48_ = li32(_loc2_ - 60);
                        _loc47_ = li32(_loc2_ - 64);
                        _loc43_ = li32(_loc2_ - 152);
                        _loc41_ = li32(_loc2_ - 68);
                        _loc42_ = li32(_loc2_ - 72);
                        _loc39_ = li32(_loc2_ - 172);
                        _loc40_ = li32(_loc2_ - 176);
                        si32(6,_loc28_);
                        _loc1_ -= 32;
                        si32(_loc40_,_loc1_ + 28);
                        si32(_loc39_,_loc1_ + 24);
                        si32(_loc42_,_loc1_ + 20);
                        si32(_loc41_,_loc1_ + 16);
                        si32(_loc43_,_loc1_ + 12);
                        si32(_loc47_,_loc1_ + 8);
                        si32(_loc48_,_loc1_ + 4);
                        _loc37_ = _loc2_ - 136;
                        si32(_loc37_,_loc1_);
                        ESP = _loc1_;
                        F_getTWeight();
                        _loc1_ += 32;
                        si32(7,_loc28_);
                        _loc1_ -= 16;
                        si32(_loc37_,_loc1_ + 4);
                        si32(_loc52_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSt6vectorIiSaIiEEaSERKS1_();
                        _loc1_ += 16;
                        si32(8,_loc28_);
                        _loc1_ -= 16;
                        si32(_loc37_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSt6vectorIiSaIiEED1Ev();
                        _loc1_ += 16;
                        _loc15_ = li32(_loc2_ - 72);
                        _loc18_ = li32(_loc2_ - 172);
                        _loc15_ = _loc18_ * _loc15_;
                        _loc18_ = li32(_loc2_ - 176);
                        _loc15_ += _loc18_;
                        si32(_loc15_,_loc2_ - 180);
                        _loc1_ -= 16;
                        si32(0,_loc1_ + 4);
                        si32(_loc52_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSt6vectorIiSaIiEEixEj();
                        _loc1_ += 16;
                        _loc15_ = eax;
                        _loc38_ = li32(_loc15_);
                        _loc1_ -= 16;
                        si32(1,_loc1_ + 4);
                        si32(_loc52_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSt6vectorIiSaIiEEixEj();
                        _loc1_ += 16;
                        _loc15_ = eax;
                        _loc35_ = li32(_loc15_);
                        _loc36_ = li32(_loc2_ - 164);
                        _loc34_ = li32(_loc2_ - 180);
                        si32(10,_loc28_);
                        _loc1_ -= 16;
                        si32(_loc35_,_loc1_ + 12);
                        si32(_loc38_,_loc1_ + 8);
                        si32(_loc34_,_loc1_ + 4);
                        si32(_loc36_,_loc1_);
                        ESP = _loc1_;
                        F__ZN5GraphIiiiE12add_tweightsEiii();
                        _loc1_ += 16;
                        _loc15_ = li32(_loc2_ - 72);
                        _loc18_ = _loc15_ + -1;
                        _loc15_ = li32(_loc2_ - 176);
                        if(_loc18_ > _loc15_)
                        {
                           _loc15_ = li32(_loc2_ - 180);
                           _loc15_ = _loc15_ + 1;
                           si32(_loc15_,_loc2_ - 184);
                           _loc17_ = li32(_loc2_ - 60);
                           _loc46_ = lf32(_loc2_ - 168);
                           _loc16_ = li32(_loc2_ - 68);
                           _loc21_ = li32(_loc2_ - 72);
                           _loc19_ = li32(_loc2_ - 172);
                           _loc25_ = li32(_loc2_ - 176);
                           si32(11,_loc28_);
                           _loc1_ -= 32;
                           _loc15_ = _loc25_ + 1;
                           si32(_loc15_,_loc1_ + 28);
                           si32(_loc19_,_loc1_ + 24);
                           si32(_loc25_,_loc1_ + 20);
                           si32(_loc19_,_loc1_ + 16);
                           si32(_loc21_,_loc1_ + 12);
                           si32(_loc16_,_loc1_ + 8);
                           sf32(_loc46_,_loc1_ + 4);
                           si32(_loc17_,_loc1_);
                           ESP = _loc1_;
                           F_getNWeight();
                           _loc1_ += 32;
                           _loc23_ = eax;
                           si32(_loc23_,_loc2_ - 188);
                           _loc29_ = li32(_loc2_ - 164);
                           _loc27_ = li32(_loc2_ - 180);
                           _loc33_ = li32(_loc2_ - 184);
                           si32(12,_loc28_);
                           _loc1_ -= 32;
                           si32(_loc23_,_loc1_ + 16);
                           si32(_loc23_,_loc1_ + 12);
                           si32(_loc33_,_loc1_ + 8);
                           si32(_loc27_,_loc1_ + 4);
                           si32(_loc29_,_loc1_);
                           ESP = _loc1_;
                           F__ZN5GraphIiiiE8add_edgeEiiii();
                           _loc1_ += 32;
                        }
                        _loc15_ = li32(_loc2_ - 68);
                        _loc15_ = _loc15_ + -1;
                        _loc18_ = li32(_loc2_ - 172);
                        if(_loc15_ > _loc18_)
                        {
                           _loc15_ = li32(_loc2_ - 72);
                           _loc18_ = li32(_loc2_ - 180);
                           _loc15_ = _loc18_ + _loc15_;
                           si32(_loc15_,_loc2_ - 184);
                           _loc31_ = li32(_loc2_ - 60);
                           _loc45_ = lf32(_loc2_ - 168);
                           _loc5_ = li32(_loc2_ - 68);
                           _loc4_ = li32(_loc2_ - 72);
                           _loc3_ = li32(_loc2_ - 172);
                           _loc10_ = li32(_loc2_ - 176);
                           si32(13,_loc28_);
                           _loc1_ -= 32;
                           si32(_loc10_,_loc1_ + 28);
                           _loc15_ = _loc3_ + 1;
                           si32(_loc15_,_loc1_ + 24);
                           si32(_loc10_,_loc1_ + 20);
                           si32(_loc3_,_loc1_ + 16);
                           si32(_loc4_,_loc1_ + 12);
                           si32(_loc5_,_loc1_ + 8);
                           sf32(_loc45_,_loc1_ + 4);
                           si32(_loc31_,_loc1_);
                           ESP = _loc1_;
                           F_getNWeight();
                           _loc1_ += 32;
                           _loc9_ = eax;
                           si32(_loc9_,_loc2_ - 188);
                           _loc8_ = li32(_loc2_ - 164);
                           _loc6_ = li32(_loc2_ - 180);
                           _loc13_ = li32(_loc2_ - 184);
                           si32(14,_loc28_);
                           _loc1_ -= 32;
                           si32(_loc9_,_loc1_ + 16);
                           si32(_loc9_,_loc1_ + 12);
                           si32(_loc13_,_loc1_ + 8);
                           si32(_loc6_,_loc1_ + 4);
                           si32(_loc8_,_loc1_);
                           ESP = _loc1_;
                           F__ZN5GraphIiiiE8add_edgeEiiii();
                           _loc1_ += 32;
                        }
                        _loc15_ = li32(_loc2_ - 176);
                        _loc15_ = _loc15_ + 1;
                        si32(_loc15_,_loc2_ - 176);
                     }
                     break;
                  }
                  _loc15_ = li32(_loc2_ - 164);
                  si32(_loc15_,_loc2_ - 124);
                  si32(15,_loc28_);
                  _loc1_ -= 16;
                  si32(_loc52_,_loc1_);
                  ESP = _loc1_;
                  F__ZNSt6vectorIiSaIiEED1Ev();
                  _loc1_ += 16;
                  _loc15_ = li32(_loc2_ - 172);
                  _loc15_ = _loc15_ + 1;
                  si32(_loc15_,_loc2_ - 172);
               }
               §§goto(addr0db6);
            }
            loop1:
            while(true)
            {
               while(true)
               {
                  _loc15_ = _loc32_ | 4;
                  _loc11_ = li32(_loc15_);
                  if(_loc11_ <= 5)
                  {
                     if(_loc11_ <= 1)
                     {
                        if(_loc11_ != 0)
                        {
                           if(_loc11_ != 1)
                           {
                              break loop1;
                           }
                           _loc15_ = li32(_loc2_ - 48);
                           si32(_loc15_,_loc2_ - 204);
                           _loc15_ = li32(_loc2_ - 44);
                           si32(_loc15_,_loc2_ - 208);
                           _loc15_ = li32(_loc2_ - 208);
                           si32(_loc15_,_loc2_ - 112);
                           _loc15_ = li32(_loc2_ - 204);
                           si32(_loc15_,_loc2_ - 116);
                           _loc15_ = li32(_loc2_ - 160);
                           _loc1_ -= 16;
                           si32(_loc15_,_loc1_);
                           ESP = _loc1_;
                           F__ZdlPv();
                           _loc1_ += 16;
                           _loc15_ = li32(_loc2_ - 116);
                           si32(_loc15_,_loc2_ - 204);
                           _loc15_ = li32(_loc2_ - 112);
                           si32(_loc15_,_loc2_ - 208);
                           continue loop1;
                        }
                     }
                     else
                     {
                        _loc15_ = _loc11_ + -2;
                        if((uint(_loc15_)) >= 2)
                        {
                           if(_loc11_ != 4)
                           {
                              if(_loc11_ != 5)
                              {
                                 break loop1;
                              }
                              addr0c15:
                              _loc15_ = li32(_loc2_ - 48);
                              si32(_loc15_,_loc2_ - 204);
                              _loc15_ = li32(_loc2_ - 44);
                              si32(_loc15_,_loc2_ - 208);
                              break;
                           }
                           _loc15_ = li32(_loc2_ - 48);
                           si32(_loc15_,_loc2_ - 204);
                           _loc15_ = li32(_loc2_ - 44);
                           si32(_loc15_,_loc2_ - 208);
                           _loc15_ = li32(_loc2_ - 208);
                           si32(_loc15_,_loc2_ - 104);
                           _loc15_ = li32(_loc2_ - 204);
                           si32(_loc15_,_loc2_ - 108);
                           _loc1_ -= 16;
                           _loc15_ = _loc2_ - 144;
                           si32(_loc15_,_loc1_);
                           ESP = _loc1_;
                           F__ZNSaIiED1Ev();
                           _loc1_ += 16;
                           _loc15_ = li32(_loc2_ - 108);
                           si32(_loc15_,_loc2_ - 204);
                           _loc15_ = li32(_loc2_ - 104);
                           si32(_loc15_,_loc2_ - 208);
                           continue loop1;
                        }
                     }
                     addr0baf:
                     _loc15_ = li32(_loc2_ - 48);
                     si32(_loc15_,_loc2_ - 204);
                     _loc15_ = li32(_loc2_ - 44);
                     si32(_loc15_,_loc2_ - 208);
                     continue loop1;
                  }
                  if(_loc11_ <= 8)
                  {
                     if(_loc11_ == 6)
                     {
                        _loc15_ = li32(_loc2_ - 48);
                        si32(_loc15_,_loc2_ - 204);
                        _loc15_ = li32(_loc2_ - 44);
                        si32(_loc15_,_loc2_ - 208);
                        _loc15_ = li32(_loc2_ - 208);
                        si32(_loc15_,_loc2_ - 96);
                        _loc15_ = li32(_loc2_ - 204);
                        si32(_loc15_,_loc2_ - 100);
                        _loc15_ = _loc32_ | 4;
                        si32(9,_loc15_);
                        _loc1_ -= 16;
                        _loc15_ = _loc2_ - 136;
                        si32(_loc15_,_loc1_);
                        ESP = _loc1_;
                        F__ZNSt6vectorIiSaIiEED1Ev();
                        _loc1_ += 16;
                        _loc15_ = li32(_loc2_ - 100);
                        si32(_loc15_,_loc2_ - 204);
                        _loc15_ = li32(_loc2_ - 96);
                        si32(_loc15_,_loc2_ - 208);
                        break;
                     }
                     if(_loc11_ != 7)
                     {
                        if(_loc11_ != 8)
                        {
                           break loop1;
                        }
                        _loc15_ = li32(_loc2_ - 48);
                        si32(_loc15_,_loc2_ - 204);
                        _loc15_ = li32(_loc2_ - 44);
                        si32(_loc15_,_loc2_ - 208);
                        ESP = _loc1_;
                        F__ZSt9terminatev();
                        §§goto(addr0697);
                     }
                  }
                  else
                  {
                     _loc15_ = _loc11_ + -9;
                     if((uint(_loc15_)) >= 5)
                     {
                        if(_loc11_ != 14)
                        {
                           if(_loc11_ != 15)
                           {
                              break loop1;
                           }
                           §§goto(addr0af9);
                        }
                        §§goto(addr0baf);
                     }
                  }
                  §§goto(addr0c15);
               }
               _loc15_ = li32(_loc2_ - 208);
               si32(_loc15_,_loc2_ - 80);
               _loc15_ = li32(_loc2_ - 204);
               si32(_loc15_,_loc2_ - 84);
               _loc1_ = _loc15_ = li32(_loc2_ - 120);
               _loc15_ = _loc1_;
               si32(_loc15_,_loc2_ - 16);
               _loc15_ = li32(_loc2_ - 84);
               si32(_loc15_,_loc2_ - 204);
               _loc15_ = li32(_loc2_ - 80);
               si32(_loc15_,_loc2_ - 208);
               _loc15_ = _loc32_ | 4;
               _loc18_ = li32(_loc2_ - 204);
               si32(-1,_loc15_);
               _loc1_ -= 16;
               si32(_loc18_,_loc1_);
               ESP = _loc1_;
               F__Unwind_SjLj_Resume();
               _loc1_ += 16;
               _loc15_ = li32(_loc2_ - 208);
               si32(_loc15_,_loc2_ - 88);
               _loc15_ = li32(_loc2_ - 204);
               si32(_loc15_,_loc2_ - 92);
               _loc15_ = _loc32_ | 4;
               si32(16,_loc15_);
               _loc1_ -= 16;
               _loc15_ = _loc2_ - 200;
               si32(_loc15_,_loc1_);
               ESP = _loc1_;
               F__ZNSt6vectorIiSaIiEED1Ev();
               _loc1_ += 16;
               _loc15_ = li32(_loc2_ - 92);
               si32(_loc15_,_loc2_ - 204);
               _loc15_ = li32(_loc2_ - 88);
               si32(_loc15_,_loc2_ - 208);
            }
            while(true)
            {
            }
            addr0af9:
            _loc15_ = li32(_loc2_ - 48);
            si32(_loc15_,_loc2_ - 204);
            _loc15_ = li32(_loc2_ - 44);
            si32(_loc15_,_loc2_ - 208);
            ESP = _loc1_;
            F__ZSt9terminatev();
            _loc1_ = _loc15_ = li32(_loc2_ - 120);
            _loc15_ = _loc1_;
            si32(_loc15_,_loc2_ - 16);
            _loc15_ = li32(_loc2_ - 124);
            si32(_loc15_,_loc2_ - 76);
            _loc12_ = li32(_loc2_ - 76);
            _loc1_ -= 16;
            si32(_loc32_,_loc1_);
            ESP = _loc1_;
            F__Unwind_SjLj_Unregister();
            _loc1_ += 16;
            eax = _loc12_;
            _loc1_ = _loc2_;
            ESP = _loc1_;
            return;
         }
         catch(l:LongJmp)
         {
            var _temp_147:* = this;
            var _temp_148:* = l;
            if(l.esp < _loc2_)
            {
               continue;
            }
         }
         addr0db6:
         throw l;
         ESP = _loc1_ = int(l.esp);
         eax = l.retval;
         _loc7_ = int(l.sjid);
      }
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

