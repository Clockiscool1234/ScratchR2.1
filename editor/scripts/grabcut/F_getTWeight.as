package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F_getTWeight() : void
   {
      var _temp_1:* = this;
      var _loc7_:int = 0;
      var _loc11_:int = 0;
      var _loc17_:int = 0;
      var _loc6_:int = 0;
      var _loc22_:int = 0;
      var _loc21_:int = 0;
      var _loc20_:int = 0;
      var _loc18_:int = 0;
      var _loc15_:int = 0;
      var _loc13_:int = 0;
      var _loc12_:int = 0;
      var _loc16_:Number = NaN;
      var _loc1_:Number = NaN;
      var _loc3_:Number = NaN;
      var _loc14_:Number = NaN;
      var _loc9_:int = 0;
      var _loc10_:int = 0;
      var _loc19_:Number = NaN;
      var _loc2_:Number = NaN;
      var _loc4_:int = 0;
      var _loc8_:int = 0;
      var _loc5_:int = ESP;
      while(true)
      {
         try
         {
            if(!_loc11_)
            {
               _loc7_ = _loc5_;
               _loc5_ -= 176;
               _loc6_ = li32(_loc7_);
               si32(_loc6_,_loc7_ - 60);
               _loc6_ = li32(_loc7_ + 4);
               si32(_loc6_,_loc7_ - 64);
               _loc6_ = li32(_loc7_ + 8);
               si32(_loc6_,_loc7_ - 68);
               _loc6_ = li32(_loc7_ + 12);
               si32(_loc6_,_loc7_ - 72);
               _loc6_ = li32(_loc7_ + 16);
               si32(_loc6_,_loc7_ - 76);
               _loc6_ = li32(_loc7_ + 20);
               si32(_loc6_,_loc7_ - 80);
               _loc6_ = li32(_loc7_ + 24);
               si32(_loc6_,_loc7_ - 84);
               _loc6_ = li32(_loc7_ + 28);
               si32(_loc6_,_loc7_ - 88);
               si32(10000000,_loc7_ - 120);
               _loc22_ = li32(_loc7_ - 68);
               _loc21_ = li32(_loc7_ - 76);
               _loc20_ = li32(_loc7_ - 80);
               _loc18_ = li32(_loc7_ - 84);
               _loc6_ = li32(_loc7_ - 88);
               _loc5_ -= 32;
               si32(_loc6_,_loc5_ + 16);
               si32(_loc18_,_loc5_ + 12);
               si32(_loc20_,_loc5_ + 8);
               si32(_loc21_,_loc5_ + 4);
               si32(_loc22_,_loc5_);
               ESP = _loc5_;
               F_whatSegment();
               _loc5_ += 32;
               _loc6_ = eax;
               si32(_loc6_,_loc7_ - 124);
               _loc17_ = li32(_loc7_ - 60);
               si32(0,_loc7_ - 116);
               _loc5_ -= 16;
               _loc15_ = _loc7_ - 112;
               si32(_loc15_,_loc5_);
               ESP = _loc5_;
               F__ZNSaIiEC1Ev();
               _loc5_ += 16;
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.L_LSDA_56,_loc7_ - 28);
               si32(___gxx_personality_sj0,_loc7_ - 32);
               _loc6_ = _loc7_;
               si32(_loc6_,_loc7_ - 24);
               _loc6_ = _loc5_;
               si32(_loc6_,_loc7_ - 16);
               _loc13_ = _loc7_ - 56;
               _loc12_ = _loc13_ + 32;
               eax = setjmp(_loc12_,1,_loc5_);
            }
            else
            {
               switch(_loc11_ - 1)
               {
                  case 0:
                  default:
                     throw "bad longjmp";
               }
            }
            _loc6_ = eax;
            if(_loc6_ == 0)
            {
               _loc5_ -= 16;
               si32(_loc13_,_loc5_);
               ESP = _loc5_;
               F__Unwind_SjLj_Register();
               _loc5_ += 16;
               _loc6_ = _loc13_ | 4;
               _loc4_ = 1;
               si32(_loc4_,_loc6_);
               _loc5_ -= 16;
               si32(_loc15_,_loc5_ + 12);
               _loc6_ = _loc7_ - 116;
               si32(_loc6_,_loc5_ + 8);
               si32(2,_loc5_ + 4);
               si32(_loc17_,_loc5_);
               ESP = _loc5_;
               F__ZNSt6vectorIiSaIiEEC1EjRKiRKS0_();
               _loc5_ += 16;
               _loc5_ -= 16;
               si32(_loc15_,_loc5_);
               ESP = _loc5_;
               F__ZNSaIiED1Ev();
               _loc5_ += 16;
               _loc6_ = li32(_loc7_ - 124);
               if(_loc6_ != 0)
               {
                  _loc6_ = li32(_loc7_ - 124);
                  if(_loc6_ == 1)
                  {
                     _loc6_ = li32(_loc7_ - 60);
                     _loc5_ -= 16;
                     si32(0,_loc5_ + 4);
                     si32(_loc6_,_loc5_);
                     ESP = _loc5_;
                     F__ZNSt6vectorIiSaIiEEixEj();
                     _loc5_ += 16;
                     _loc6_ = eax;
                     si32(0,_loc6_);
                     _loc6_ = li32(_loc7_ - 60);
                     _loc5_ -= 16;
                     si32(1,_loc5_ + 4);
                     si32(_loc6_,_loc5_);
                     ESP = _loc5_;
                     F__ZNSt6vectorIiSaIiEEixEj();
                     _loc5_ += 16;
                     _loc18_ = eax;
                     _loc6_ = li32(_loc7_ - 120);
                     si32(_loc6_,_loc18_);
                  }
                  else
                  {
                     _loc22_ = li32(_loc7_ - 64);
                     _loc21_ = li32(_loc7_ - 76);
                     _loc20_ = li32(_loc7_ - 80);
                     _loc18_ = li32(_loc7_ - 84);
                     _loc6_ = li32(_loc7_ - 88);
                     _loc5_ -= 32;
                     si32(_loc6_,_loc5_ + 16);
                     si32(_loc18_,_loc5_ + 12);
                     si32(_loc20_,_loc5_ + 8);
                     si32(_loc21_,_loc5_ + 4);
                     si32(_loc22_,_loc5_);
                     ESP = _loc5_;
                     F_getPixel();
                     _loc5_ += 32;
                     _loc6_ = eax;
                     si32(_loc6_,_loc7_ - 104);
                     _loc6_ = li8(_loc7_ - 104);
                     si8(_loc6_,_loc7_ - 168);
                     _loc21_ = _loc7_ - 168;
                     _loc18_ = _loc21_ | 1;
                     _loc20_ = _loc7_ - 104;
                     _loc6_ = _loc20_ | 1;
                     _loc6_ = li8(_loc6_);
                     si8(_loc6_,_loc18_);
                     _loc6_ = _loc21_ | 2;
                     _loc22_ = _loc20_ | 2;
                     _loc22_ = li8(_loc22_);
                     si8(_loc22_,_loc6_);
                     _loc21_ |= 3;
                     _loc20_ |= 3;
                     _loc20_ = li8(_loc20_);
                     si8(_loc20_,_loc21_);
                     _loc20_ = li8(_loc18_);
                     _loc18_ = li8(_loc7_ - 168);
                     _loc18_ = _loc18_ + _loc20_;
                     _loc6_ = li8(_loc6_);
                     _loc16_ = _loc6_ = _loc18_ + _loc6_;
                     _loc1_ = _loc16_ = _loc16_ / 3;
                     sf32(_loc1_,_loc7_ - 128);
                     _loc16_ = _loc1_;
                     _loc3_ = _loc18_ = li32(grabcut._BINS);
                     _loc14_ = _loc3_;
                     _loc1_ = _loc16_ = _loc14_ * _loc16_;
                     _loc16_ = _loc1_;
                     _loc3_ = 256;
                     _loc14_ = _loc3_;
                     _loc1_ = _loc16_ /= _loc14_;
                     _loc6_ = _loc1_;
                     si32(_loc6_,_loc7_ - 136);
                     _loc18_ = _loc6_ << 2;
                     _loc6_ = li32(_loc7_ - 72);
                     _loc6_ = _loc6_ + _loc18_;
                     _loc1_ = lf32(_loc6_);
                     sf32(_loc1_,_loc7_ - 132);
                     _loc16_ = _loc1_;
                     _loc3_ = 0;
                     _loc14_ = _loc3_;
                     if(_loc16_ <= _loc14_)
                     {
                        _loc4_ = 0;
                     }
                     while(true)
                     {
                        _loc6_ = _loc4_ & 1;
                        if(_loc6_ != 0)
                        {
                           _loc1_ = 1;
                           _loc14_ = _loc1_;
                           _loc8_ = 1;
                           _loc16_ = lf32(_loc7_ - 132);
                           if(_loc16_ >= _loc14_)
                           {
                              _loc8_ = 0;
                           }
                           _loc6_ = _loc8_ & 1;
                           if(_loc6_ != 0)
                           {
                              _loc6_ = li32(_loc7_ - 60);
                              _loc5_ -= 16;
                              si32(0,_loc5_ + 4);
                              si32(_loc6_,_loc5_);
                              ESP = _loc5_;
                              F__ZNSt6vectorIiSaIiEEixEj();
                              _loc5_ += 16;
                              _loc9_ = eax;
                              _loc16_ = lf32(_loc7_ - 132);
                              _loc5_ -= 16;
                              sf64(_loc16_,_loc5_);
                              ESP = _loc5_;
                              F_log();
                              _loc5_ += 16;
                              _loc16_ = st0;
                              _loc6_ = _loc16_ = -_loc16_;
                              si32(_loc6_,_loc9_);
                              _loc6_ = li32(_loc7_ - 60);
                              _loc5_ -= 16;
                              si32(1,_loc5_ + 4);
                              si32(_loc6_,_loc5_);
                              ESP = _loc5_;
                              F__ZNSt6vectorIiSaIiEEixEj();
                              _loc5_ += 16;
                              _loc10_ = eax;
                              _loc16_ = lf32(_loc7_ - 132);
                              _loc5_ -= 16;
                              _loc16_ = 1 - _loc16_;
                              sf64(_loc16_,_loc5_);
                              ESP = _loc5_;
                              F_log();
                              _loc5_ += 16;
                              _loc16_ = st0;
                              _loc6_ = _loc16_ = -_loc16_;
                              si32(_loc6_,_loc10_);
                              break;
                           }
                        }
                        _loc6_ = li32(_loc7_ - 60);
                        _loc5_ -= 16;
                        si32(0,_loc5_ + 4);
                        si32(_loc6_,_loc5_);
                        ESP = _loc5_;
                        F__ZNSt6vectorIiSaIiEEixEj();
                        _loc5_ += 16;
                        _loc6_ = eax;
                        _loc3_ = _loc18_ = li32(_loc7_ - 120);
                        _loc19_ = _loc3_;
                        _loc14_ = lf32(_loc7_ - 132);
                        _loc3_ = _loc14_ = _loc19_ * _loc14_;
                        _loc18_ = _loc3_;
                        si32(_loc18_,_loc6_);
                        _loc6_ = li32(_loc7_ - 60);
                        _loc5_ -= 16;
                        si32(1,_loc5_ + 4);
                        si32(_loc6_,_loc5_);
                        ESP = _loc5_;
                        F__ZNSt6vectorIiSaIiEEixEj();
                        _loc1_ = 1;
                        _loc14_ = _loc1_;
                        _loc5_ += 16;
                        _loc6_ = eax;
                        _loc19_ = lf32(_loc7_ - 132);
                        _loc3_ = _loc14_ -= _loc19_;
                        _loc14_ = _loc3_;
                        _loc2_ = _loc20_ = li32(_loc7_ - 120);
                        _loc19_ = _loc2_;
                        _loc3_ = _loc14_ = _loc19_ * _loc14_;
                        _loc18_ = _loc3_;
                        si32(_loc18_,_loc6_);
                        break;
                     }
                  }
               }
               else
               {
                  _loc6_ = li32(_loc7_ - 60);
                  _loc5_ -= 16;
                  si32(0,_loc5_ + 4);
                  si32(_loc6_,_loc5_);
                  ESP = _loc5_;
                  F__ZNSt6vectorIiSaIiEEixEj();
                  _loc5_ += 16;
                  _loc18_ = eax;
                  _loc6_ = li32(_loc7_ - 120);
                  si32(_loc6_,_loc18_);
                  _loc6_ = li32(_loc7_ - 60);
                  _loc5_ -= 16;
                  si32(1,_loc5_ + 4);
                  si32(_loc6_,_loc5_);
                  ESP = _loc5_;
                  F__ZNSt6vectorIiSaIiEEixEj();
                  _loc5_ += 16;
                  _loc6_ = eax;
                  si32(0,_loc6_);
               }
               _loc5_ -= 16;
               si32(_loc13_,_loc5_);
               ESP = _loc5_;
               F__Unwind_SjLj_Unregister();
               _loc5_ += 16;
               ESP = _loc5_ = _loc7_;
               return;
            }
            while(true)
            {
               _loc6_ = _loc13_ | 4;
               _loc6_ = li32(_loc6_);
               if(_loc6_ != 0)
               {
                  break;
               }
               _loc6_ = li32(_loc7_ - 48);
               si32(_loc6_,_loc7_ - 156);
               _loc6_ = li32(_loc7_ - 44);
               si32(_loc6_,_loc7_ - 160);
               _loc6_ = li32(_loc7_ - 160);
               si32(_loc6_,_loc7_ - 92);
               _loc6_ = li32(_loc7_ - 156);
               si32(_loc6_,_loc7_ - 96);
               _loc5_ -= 16;
               si32(_loc15_,_loc5_);
               ESP = _loc5_;
               F__ZNSaIiED1Ev();
               _loc5_ += 16;
               _loc6_ = li32(_loc7_ - 96);
               si32(_loc6_,_loc7_ - 156);
               _loc6_ = li32(_loc7_ - 92);
               si32(_loc6_,_loc7_ - 160);
               _loc6_ = _loc13_ | 4;
               _loc18_ = li32(_loc7_ - 156);
               si32(-1,_loc6_);
               _loc5_ -= 16;
               si32(_loc18_,_loc5_);
               ESP = _loc5_;
               F__Unwind_SjLj_Resume();
               _loc5_ += 16;
            }
            while(true)
            {
            }
         }
         catch(l:LongJmp)
         {
            var _temp_93:* = this;
            var _temp_94:* = l;
            if(l.esp >= _loc7_)
            {
               throw l;
            }
         }
         ESP = _loc5_ = int(l.esp);
         eax = l.retval;
         _loc11_ = int(l.sjid);
      }
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;

