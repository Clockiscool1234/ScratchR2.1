package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.*;
   
   public function F_getProb() : void
   {
      var _temp_1:* = this;
      var _loc7_:int = 0;
      var _loc11_:int = 0;
      var _loc4_:int = 0;
      var _loc22_:int = 0;
      var _loc21_:int = 0;
      var _loc10_:int = 0;
      var _loc16_:Number = NaN;
      var _loc1_:Number = NaN;
      var _loc18_:Number = NaN;
      var _loc3_:Number = NaN;
      var _loc19_:int = 0;
      var _loc17_:int = 0;
      var _loc15_:int = 0;
      var _loc13_:int = 0;
      var _loc12_:int = 0;
      var _loc8_:int = 0;
      var _loc9_:int = 0;
      var _loc6_:int = 0;
      var _loc23_:int = 0;
      var _loc14_:Number = NaN;
      var _loc2_:Number = NaN;
      var _loc20_:Number = NaN;
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
               _loc6_ = _loc5_;
               si32(_loc6_,_loc7_ - 88);
               si32(0,_loc7_ - 116);
               si32(0,_loc7_ - 120);
               _loc6_ = li32(grabcut._BINS);
               _loc6_ = _loc6_ + -1;
               si32(_loc6_,_loc7_ - 112);
               _loc6_ <<= 2;
               _loc6_ = _loc6_ + 19;
               _loc6_ = _loc6_ & -16;
               _loc23_ = _loc5_;
               _loc6_ = _loc23_ - _loc6_;
               _loc5_ = _loc6_ & -16;
               si32(_loc5_,_loc7_ - 108);
               _loc6_ = li32(grabcut._BINS);
               _loc6_ = _loc6_ + -1;
               si32(_loc6_,_loc7_ - 104);
               _loc6_ <<= 2;
               _loc6_ = _loc6_ + 19;
               _loc6_ = _loc6_ & -16;
               _loc23_ = _loc5_;
               _loc6_ = _loc23_ - _loc6_;
               _loc5_ = _loc6_ & -16;
               si32(_loc5_,_loc7_ - 100);
               si32(0,_loc7_ - 124);
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccJkt6Tg_2E_o_3A_867FA3D3_2D_F96E_2D_404D_2D_9DBB_2D_0ACB3EFD0AC6.L_LSDA_57,_loc7_ - 28);
               si32(___gxx_personality_sj0,_loc7_ - 32);
               _loc6_ = _loc7_;
               si32(_loc6_,_loc7_ - 24);
               _loc6_ = _loc5_;
               si32(_loc6_,_loc7_ - 16);
               _loc22_ = _loc7_ - 56;
               _loc21_ = _loc22_ + 32;
               eax = setjmp(_loc21_,1,_loc5_);
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
               si32(_loc22_,_loc5_);
               ESP = _loc5_;
               F__Unwind_SjLj_Register();
               _loc5_ += 16;
               while(true)
               {
                  _loc6_ = li32(_loc7_ - 72);
                  _loc23_ = li32(_loc7_ - 124);
                  if(_loc23_ >= _loc6_)
                  {
                     break;
                  }
                  si32(0,_loc7_ - 128);
                  while(true)
                  {
                     _loc23_ = li32(_loc7_ - 76);
                     _loc6_ = li32(_loc7_ - 128);
                     if(_loc6_ >= _loc23_)
                     {
                        break;
                     }
                     _loc6_ = _loc22_ | 4;
                     _loc19_ = li32(_loc7_ - 64);
                     _loc17_ = li32(_loc7_ - 72);
                     _loc15_ = li32(_loc7_ - 76);
                     _loc13_ = li32(_loc7_ - 124);
                     _loc12_ = li32(_loc7_ - 128);
                     si32(1,_loc6_);
                     _loc5_ -= 32;
                     si32(_loc12_,_loc5_ + 16);
                     si32(_loc13_,_loc5_ + 12);
                     si32(_loc15_,_loc5_ + 8);
                     si32(_loc17_,_loc5_ + 4);
                     si32(_loc19_,_loc5_);
                     ESP = _loc5_;
                     F_whatSegment();
                     _loc5_ += 32;
                     _loc4_ = eax;
                     si32(_loc4_,_loc7_ - 136);
                     _loc8_ = li32(_loc7_ - 60);
                     _loc9_ = li32(_loc7_ - 72);
                     _loc10_ = li32(_loc7_ - 76);
                     _loc23_ = li32(_loc7_ - 124);
                     _loc6_ = li32(_loc7_ - 128);
                     _loc5_ -= 32;
                     si32(_loc6_,_loc5_ + 16);
                     si32(_loc23_,_loc5_ + 12);
                     si32(_loc10_,_loc5_ + 8);
                     si32(_loc9_,_loc5_ + 4);
                     si32(_loc8_,_loc5_);
                     ESP = _loc5_;
                     F_getPixel();
                     _loc5_ += 32;
                     _loc6_ = eax;
                     si32(_loc6_,_loc7_ - 96);
                     _loc6_ = li8(_loc7_ - 96);
                     si8(_loc6_,_loc7_ - 160);
                     _loc9_ = _loc7_ - 160;
                     _loc23_ = _loc9_ | 1;
                     _loc10_ = _loc7_ - 96;
                     _loc6_ = _loc10_ | 1;
                     _loc6_ = li8(_loc6_);
                     si8(_loc6_,_loc23_);
                     _loc6_ = _loc9_ | 2;
                     _loc8_ = _loc10_ | 2;
                     _loc8_ = li8(_loc8_);
                     si8(_loc8_,_loc6_);
                     _loc9_ |= 3;
                     _loc10_ |= 3;
                     _loc10_ = li8(_loc10_);
                     si8(_loc10_,_loc9_);
                     _loc23_ = li8(_loc23_);
                     _loc10_ = li8(_loc7_ - 160);
                     _loc23_ = _loc10_ + _loc23_;
                     _loc6_ = li8(_loc6_);
                     _loc16_ = _loc6_ = _loc23_ + _loc6_;
                     _loc1_ = _loc16_ = _loc16_ / 3;
                     sf32(_loc1_,_loc7_ - 140);
                     _loc16_ = _loc1_;
                     _loc3_ = _loc23_ = li32(grabcut._BINS);
                     _loc14_ = _loc3_;
                     _loc1_ = _loc16_ = _loc14_ * _loc16_;
                     _loc16_ = _loc1_;
                     _loc3_ = 256;
                     _loc14_ = _loc3_;
                     _loc1_ = _loc16_ /= _loc14_;
                     _loc6_ = _loc1_;
                     si32(_loc6_,_loc7_ - 132);
                     _loc6_ = li32(_loc7_ - 136);
                     if(_loc6_ == 0)
                     {
                        _loc6_ = li32(_loc7_ - 132);
                        _loc23_ = _loc6_ << 2;
                        _loc6_ = li32(_loc7_ - 108);
                        _loc6_ = _loc6_ + _loc23_;
                        _loc14_ = lf32(_loc6_);
                        _loc2_ = 1;
                        _loc20_ = _loc2_;
                        _loc14_ += _loc20_;
                        sf32(_loc14_,_loc6_);
                        _loc6_ = li32(_loc7_ - 116);
                        _loc6_ = _loc6_ + 1;
                        si32(_loc6_,_loc7_ - 116);
                     }
                     else
                     {
                        _loc6_ = li32(_loc7_ - 136);
                        if(_loc6_ == 1)
                        {
                           _loc6_ = li32(_loc7_ - 120);
                           _loc6_ = _loc6_ + 1;
                           si32(_loc6_,_loc7_ - 120);
                           _loc6_ = li32(_loc7_ - 132);
                           _loc6_ = _loc6_ << 2;
                           _loc23_ = li32(_loc7_ - 100);
                           _loc6_ = _loc23_ + _loc6_;
                           _loc14_ = lf32(_loc6_);
                           _loc2_ = 1;
                           _loc20_ = _loc2_;
                           _loc14_ += _loc20_;
                           sf32(_loc14_,_loc6_);
                        }
                     }
                     _loc6_ = li32(_loc7_ - 128);
                     _loc6_ = _loc6_ + 1;
                     si32(_loc6_,_loc7_ - 128);
                  }
                  _loc6_ = li32(_loc7_ - 124);
                  _loc6_ = _loc6_ + 1;
                  si32(_loc6_,_loc7_ - 124);
               }
               si32(0,_loc7_ - 124);
               while(true)
               {
                  _loc6_ = li32(grabcut._BINS);
                  _loc23_ = li32(_loc7_ - 124);
                  if(_loc23_ >= _loc6_)
                  {
                     break;
                  }
                  _loc6_ = li32(_loc7_ - 124);
                  _loc6_ = _loc6_ << 2;
                  _loc23_ = li32(_loc7_ - 100);
                  _loc23_ = _loc23_ + _loc6_;
                  _loc14_ = lf32(_loc23_);
                  _loc10_ = li32(_loc7_ - 108);
                  _loc6_ = _loc10_ + _loc6_;
                  _loc16_ = lf32(_loc6_);
                  _loc1_ = _loc16_ = _loc16_ + _loc14_;
                  _loc6_ = _loc1_;
                  si32(_loc6_,_loc7_ - 144);
                  if(_loc6_ >= 1)
                  {
                     _loc6_ = li32(_loc7_ - 124);
                     _loc23_ = _loc6_ << 2;
                     _loc6_ = li32(_loc7_ - 108);
                     _loc6_ = _loc6_ + _loc23_;
                     _loc14_ = lf32(_loc6_);
                     _loc1_ = 0;
                     _loc18_ = _loc1_;
                     if(!(_loc14_ != _loc18_ | _loc14_ != _loc14_ | _loc18_ != _loc18_))
                     {
                        si32(0,_loc7_ - 148);
                     }
                     else
                     {
                        _loc6_ = li32(_loc7_ - 124);
                        _loc6_ = _loc6_ << 2;
                        _loc23_ = li32(_loc7_ - 108);
                        _loc6_ = _loc23_ + _loc6_;
                        _loc16_ = lf32(_loc6_);
                        _loc3_ = _loc23_ = li32(_loc7_ - 116);
                        _loc14_ = _loc3_;
                        _loc16_ /= _loc14_;
                        sf32(_loc16_,_loc7_ - 148);
                     }
                     _loc6_ = li32(_loc7_ - 124);
                     _loc6_ = _loc6_ << 2;
                     _loc23_ = li32(_loc7_ - 100);
                     _loc6_ = _loc23_ + _loc6_;
                     _loc16_ = lf32(_loc6_);
                     if(!(_loc16_ != _loc18_ | _loc16_ != _loc16_ | _loc18_ != _loc18_))
                     {
                        si32(0,_loc7_ - 152);
                     }
                     else
                     {
                        _loc6_ = li32(_loc7_ - 124);
                        _loc6_ = _loc6_ << 2;
                        _loc23_ = li32(_loc7_ - 100);
                        _loc6_ = _loc23_ + _loc6_;
                        _loc16_ = lf32(_loc6_);
                        _loc3_ = _loc23_ = li32(_loc7_ - 120);
                        _loc14_ = _loc3_;
                        _loc16_ /= _loc14_;
                        sf32(_loc16_,_loc7_ - 152);
                     }
                     _loc6_ = li32(_loc7_ - 124);
                     _loc6_ = _loc6_ << 2;
                     _loc23_ = li32(_loc7_ - 68);
                     _loc6_ = _loc23_ + _loc6_;
                     _loc20_ = lf32(_loc7_ - 152);
                     _loc14_ = lf32(_loc7_ - 148);
                     _loc2_ = _loc20_ = _loc14_ + _loc20_;
                     _loc20_ = _loc2_;
                     _loc14_ /= _loc20_;
                     sf32(_loc14_,_loc6_);
                  }
                  else
                  {
                     _loc6_ = li32(_loc7_ - 124);
                     _loc23_ = _loc6_ << 2;
                     _loc6_ = li32(_loc7_ - 68);
                     _loc6_ = _loc6_ + _loc23_;
                     si32(1056964608,_loc6_);
                  }
                  _loc6_ = li32(_loc7_ - 124);
                  _loc6_ = _loc6_ + 1;
                  si32(_loc6_,_loc7_ - 124);
               }
               _loc6_ = _loc5_ = _loc6_ = li32(_loc7_ - 88);
               si32(_loc6_,_loc7_ - 16);
               _loc5_ -= 16;
               si32(_loc22_,_loc5_);
               ESP = _loc5_;
               F__Unwind_SjLj_Unregister();
               _loc5_ += 16;
               ESP = _loc5_ = _loc7_;
               return;
            }
            while(true)
            {
               _loc6_ = _loc22_ | 4;
               _loc6_ = li32(_loc6_);
               if(_loc6_ != 0)
               {
                  break;
               }
               _loc6_ = li32(_loc7_ - 48);
               si32(_loc6_,_loc7_ - 164);
               _loc6_ = li32(_loc7_ - 44);
               si32(_loc6_,_loc7_ - 168);
               _loc6_ = li32(_loc7_ - 168);
               si32(_loc6_,_loc7_ - 80);
               _loc6_ = li32(_loc7_ - 164);
               si32(_loc6_,_loc7_ - 84);
               _loc6_ = _loc5_ = _loc6_ = li32(_loc7_ - 88);
               si32(_loc6_,_loc7_ - 16);
               _loc6_ = li32(_loc7_ - 84);
               si32(_loc6_,_loc7_ - 164);
               _loc6_ = li32(_loc7_ - 80);
               si32(_loc6_,_loc7_ - 168);
               _loc23_ = _loc22_ | 4;
               _loc6_ = li32(_loc7_ - 164);
               si32(-1,_loc23_);
               _loc5_ -= 16;
               si32(_loc6_,_loc5_);
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
            var _temp_125:* = this;
            var _temp_126:* = l;
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

