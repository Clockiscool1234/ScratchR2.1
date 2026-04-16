package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;
   
   public function F__ZN5GraphIdddE16test_consistencyEPNS0_4nodeE() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc10_:int = 0;
      var _loc9_:int = 0;
      var _loc8_:int = 0;
      var _loc6_:int = 0;
      var _loc5_:int = 0;
      var _loc4_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 32;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      si32(0,_loc3_ - 28);
      si32(0,_loc3_ - 32);
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_);
      si32(_loc1_,_loc3_ - 16);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 4);
         _loc1_ = li32(_loc1_ + 4);
         var _loc11_:int = li32(_loc3_ - 16);
         if(uint(_loc1_) <= uint(_loc11_))
         {
            break;
         }
         if(li32(li32(_loc3_ - 16) + 8) == 0)
         {
            var _temp_2:* = li32(_loc3_ - 8);
            if(li32(_loc3_ - 16) != _temp_2)
            {
               continue;
            }
         }
         _loc1_ = li32(_loc3_ - 28);
         _loc1_ += 1;
         si32(_loc1_,_loc3_ - 28);
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ += 32;
         si32(_loc1_,_loc3_ - 16);
      }
      si32(0,_loc3_ - 24);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 24);
         if(_loc1_ >= 3)
         {
            break;
         }
         if(li32(_loc3_ - 24) != 2)
         {
            var _temp_4:* = li32(_loc3_ - 24) << 2;
            si32(li32(int((_loc11_ = li32(_loc3_ - 4)) + _temp_4) + 56),_loc3_ - 12);
         }
         else
         {
            si32(li32(_loc3_ - 8),_loc3_ - 12);
         }
         _loc1_ = li32(_loc3_ - 12);
         si32(_loc1_,_loc3_ - 16);
         if(_loc1_ != 0)
         {
            while(true)
            {
               _loc1_ = li32(_loc3_ - 32);
               _loc1_ += 1;
               si32(_loc1_,_loc3_ - 32);
               _loc1_ = li32(_loc3_ - 16);
               _loc11_ = li32(_loc1_ + 8);
               if(_loc11_ == _loc1_)
               {
                  break;
               }
               si32(li32(li32(_loc3_ - 16) + 8),_loc3_ - 16);
            }
            if(li32(_loc3_ - 24) <= 1)
            {
               var _temp_7:* = li32(_loc3_ - 24) << 2;
               if(li32(int((_loc11_ = li32(_loc3_ - 4)) + _temp_7) + 64) != li32(_loc3_ - 16))
               {
                  _loc2_ -= 16;
                  si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str1,_loc2_ + 12);
                  si32(631,_loc2_ + 8);
                  si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                  si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                  ESP = _loc2_;
                  F___assert();
                  _loc2_ += 16;
               }
            }
            else
            {
               var _temp_9:* = li32(_loc3_ - 8);
               if(li32(_loc3_ - 16) != _temp_9)
               {
                  _loc2_ -= 16;
                  si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str2,_loc2_ + 12);
                  si32(632,_loc2_ + 8);
                  si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                  si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                  ESP = _loc2_;
                  F___assert();
                  _loc2_ += 16;
               }
            }
         }
         _loc1_ = li32(_loc3_ - 24);
         _loc1_ += 1;
         si32(_loc1_,_loc3_ - 24);
      }
      var _temp_12:* = li32(_loc3_ - 32);
      if((_loc11_ = li32(_loc3_ - 28)) != _temp_12)
      {
         _loc2_ -= 16;
         si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str3,_loc2_ + 12);
         si32(637,_loc2_ + 8);
         si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
         si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
         ESP = _loc2_;
         F___assert();
         _loc2_ += 16;
      }
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_);
      si32(_loc1_,_loc3_ - 16);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 4);
         _loc11_ = li32(_loc1_ + 4);
         _loc1_ = li32(_loc3_ - 16);
         if(uint(_loc11_) <= uint(_loc1_))
         {
            break;
         }
         if(li32(li32(_loc3_ - 16) + 4) != 0)
         {
            if(li32(li32(_loc3_ - 16) + 4) != 2)
            {
               if(li32(li32(_loc3_ - 16) + 4) == 1)
               {
                  if((li8(li32(_loc3_ - 16) + 20) & 1) == 0)
                  {
                     var _temp_25:* = lf64(li32(_loc3_ - 16) + 24);
                     _loc10_ = 1;
                     if(_temp_25 <= 0)
                     {
                        _loc10_ = 0;
                     }
                     _loc1_ = _loc10_ & 1;
                     if(_loc1_ == 0)
                     {
                        _loc2_ -= 16;
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str4,_loc2_ + 12);
                        si32(646,_loc2_ + 8);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                        ESP = _loc2_;
                        F___assert();
                        _loc2_ += 16;
                     }
                  }
                  else
                  {
                     var _temp_27:* = lf64(li32(_loc3_ - 16) + 24);
                     _loc9_ = 1;
                     if(_temp_27 >= 0)
                     {
                        _loc9_ = 0;
                     }
                     _loc1_ = _loc9_ & 1;
                     if(_loc1_ == 0)
                     {
                        _loc2_ -= 16;
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str5,_loc2_ + 12);
                        si32(647,_loc2_ + 8);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                        ESP = _loc2_;
                        F___assert();
                        _loc2_ += 16;
                     }
                  }
               }
               else if((li8(li32(_loc3_ - 16) + 20) & 1) == 0)
               {
                  var _temp_29:* = lf64(li32(li32(li32(_loc3_ - 16) + 4) + 8) + 16);
                  _loc8_ = 1;
                  if(_temp_29 <= 0)
                  {
                     _loc8_ = 0;
                  }
                  _loc1_ = _loc8_ & 1;
                  if(_loc1_ == 0)
                  {
                     _loc2_ -= 16;
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str6,_loc2_ + 12);
                     si32(651,_loc2_ + 8);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                     ESP = _loc2_;
                     F___assert();
                     _loc2_ += 16;
                  }
               }
               else
               {
                  var _temp_31:* = lf64(li32(li32(_loc3_ - 16) + 4) + 16);
                  _loc6_ = 1;
                  if(_temp_31 <= 0)
                  {
                     _loc6_ = 0;
                  }
                  _loc1_ = _loc6_ & 1;
                  if(_loc1_ == 0)
                  {
                     _loc2_ -= 16;
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str7,_loc2_ + 12);
                     si32(652,_loc2_ + 8);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                     ESP = _loc2_;
                     F___assert();
                     _loc2_ += 16;
                  }
               }
            }
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_ + 4);
         if(_loc1_ != 0)
         {
            if(li32(li32(_loc3_ - 16) + 8) == 0)
            {
               if((li8(li32(_loc3_ - 16) + 20) & 1) == 0)
               {
                  var _temp_33:* = lf64(li32(_loc3_ - 16) + 24);
                  _loc5_ = 1;
                  if(_temp_33 < 0)
                  {
                     _loc5_ = 0;
                  }
                  _loc1_ = _loc5_ & 1;
                  if(_loc1_ == 0)
                  {
                     _loc2_ -= 16;
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str8,_loc2_ + 12);
                     si32(660,_loc2_ + 8);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                     ESP = _loc2_;
                     F___assert();
                     _loc2_ += 16;
                  }
                  _loc1_ = li32(_loc3_ - 16);
                  _loc1_ = li32(_loc1_);
                  si32(_loc1_,_loc3_ - 20);
                  while(true)
                  {
                     _loc1_ = li32(_loc3_ - 20);
                     if(_loc1_ == 0)
                     {
                        break;
                     }
                     var _loc7_:Number = lf64(li32(_loc3_ - 20) + 16);
                     if(!(_loc7_ <= 0 | _loc7_ != _loc7_ | false))
                     {
                        if(li32(li32(li32(_loc3_ - 20)) + 4) != 0)
                        {
                           if((li8(li32(li32(_loc3_ - 20)) + 20) & 1) == 0)
                           {
                              continue;
                           }
                        }
                        _loc2_ -= 16;
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str9,_loc2_ + 12);
                        si32(663,_loc2_ + 8);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                        ESP = _loc2_;
                        F___assert();
                        _loc2_ += 16;
                     }
                     _loc1_ = li32(_loc3_ - 20);
                     _loc1_ = li32(_loc1_ + 4);
                     si32(_loc1_,_loc3_ - 20);
                  }
               }
               else
               {
                  var _temp_37:* = lf64(li32(_loc3_ - 16) + 24);
                  _loc4_ = 1;
                  if(_temp_37 > 0)
                  {
                     _loc4_ = 0;
                  }
                  _loc1_ = _loc4_ & 1;
                  if(_loc1_ == 0)
                  {
                     _loc2_ -= 16;
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str10,_loc2_ + 12);
                     si32(668,_loc2_ + 8);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                     ESP = _loc2_;
                     F___assert();
                     _loc2_ += 16;
                  }
                  _loc1_ = li32(_loc3_ - 16);
                  _loc1_ = li32(_loc1_);
                  si32(_loc1_,_loc3_ - 20);
                  while(true)
                  {
                     _loc1_ = li32(_loc3_ - 20);
                     if(_loc1_ == 0)
                     {
                        break;
                     }
                     _loc7_ = lf64(li32(li32(_loc3_ - 20) + 8) + 16);
                     if(!(_loc7_ <= 0 | _loc7_ != _loc7_ | false))
                     {
                        if(li32(li32(li32(_loc3_ - 20)) + 4) != 0)
                        {
                           if((li8(li32(li32(_loc3_ - 20)) + 20) & 1) != 0)
                           {
                              continue;
                           }
                        }
                        _loc2_ -= 16;
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str11,_loc2_ + 12);
                        si32(671,_loc2_ + 8);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                        ESP = _loc2_;
                        F___assert();
                        _loc2_ += 16;
                     }
                     _loc1_ = li32(_loc3_ - 20);
                     _loc1_ = li32(_loc1_ + 4);
                     si32(_loc1_,_loc3_ - 20);
                  }
               }
            }
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ = li32(_loc1_ + 4);
         if(_loc1_ != 0)
         {
            if(li32(li32(_loc3_ - 16) + 4) != 2)
            {
               if(li32(li32(_loc3_ - 16) + 4) != 1)
               {
                  _loc11_ = li32(_loc3_ - 16);
                  if(li32(_loc11_ + 12) > li32((_loc11_ = li32(_loc11_ = li32(_loc11_ + 4))) + 12))
                  {
                     _loc2_ -= 16;
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str12,_loc2_ + 12);
                     si32(678,_loc2_ + 8);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                     si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                     ESP = _loc2_;
                     F___assert();
                     _loc2_ += 16;
                  }
                  _loc11_ = li32(_loc3_ - 16);
                  _loc1_ = li32(_loc11_ + 12);
                  _loc11_ = li32(_loc11_ + 4);
                  _loc11_ = li32(_loc11_);
                  _loc11_ = li32(_loc11_ + 12);
                  if(_loc1_ == _loc11_)
                  {
                     _loc11_ = li32(_loc3_ - 16);
                     if(li32(_loc11_ + 16) <= li32((_loc11_ = li32(_loc11_ = li32(_loc11_ + 4))) + 16))
                     {
                        _loc2_ -= 16;
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str13,_loc2_ + 12);
                        si32(679,_loc2_ + 8);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str,_loc2_ + 4);
                        si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.__ZZN5GraphIdddE16test_consistencyEPNS0_4nodeEE8__func__,_loc2_);
                        ESP = _loc2_;
                        F___assert();
                        _loc2_ += 16;
                     }
                  }
               }
            }
         }
         _loc1_ = li32(_loc3_ - 16);
         _loc1_ += 32;
         si32(_loc1_,_loc3_ - 16);
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

