package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;
   
   public function F__ZN5GraphIiiiE7maxflowEbP5BlockIiE() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc10_:int = 0;
      var _loc8_:int = 0;
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
      si8(_loc1_,_loc3_ - 5);
      _loc1_ = li32(_loc3_ + 8);
      si32(_loc1_,_loc3_ - 12);
      si32(0,_loc3_ - 44);
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 28);
      if(_loc1_ == 0)
      {
         _loc2_ -= 16;
         si32(16,_loc2_);
         ESP = _loc2_;
         F__Znwj();
         _loc2_ += 16;
         var _temp_3:* = eax;
         si32(_temp_3,_loc3_ - 32);
         var _loc12_:int = li32(_loc3_ - 4);
         var _temp_5:* = li32(_loc12_ + 32);
         _loc2_ -= 16;
         si32(_temp_5,_loc2_ + 8);
         si32(128,_loc2_ + 4);
         si32(_temp_3,_loc2_);
         ESP = _loc2_;
         F__ZN6DBlockIN5GraphIiiiE7nodeptrEEC1EiPFvPcE();
         _loc2_ += 16;
         si32(li32(_loc3_ - 32),li32(_loc3_ - 4) + 28);
      }
      _loc1_ = li32(_loc3_ - 12);
      _loc12_ = li32(_loc3_ - 4);
      si32(_loc1_,_loc12_ + 44);
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 40);
      if(_loc1_ == 0)
      {
         if(li8(_loc3_ - 5) != 0)
         {
            if(li32(li32(_loc3_ - 4) + 32) != 0)
            {
               var _loc11_:int = li32(li32(_loc3_ - 4) + 32);
               _loc2_ -= 16;
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str20,_loc2_);
               ESP = _loc2_;
               ptr2fun[_loc11_]();
               _loc2_ += 16;
            }
            _loc2_ -= 16;
            si32(1,_loc2_);
            ESP = _loc2_;
            F_exit();
            _loc2_ += 16;
         }
      }
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 44);
      if(_loc1_ != 0)
      {
         _loc10_ = 1;
         if(li8(_loc3_ - 5) != 0)
         {
            _loc10_ = 0;
         }
         _loc1_ = _loc10_ & 1;
         if(_loc1_ != 0)
         {
            if(li32(li32(_loc3_ - 4) + 32) != 0)
            {
               var _loc9_:int = li32(li32(_loc3_ - 4) + 32);
               _loc2_ -= 16;
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str21,_loc2_);
               ESP = _loc2_;
               ptr2fun[_loc9_]();
               _loc2_ += 16;
            }
            _loc2_ -= 16;
            si32(1,_loc2_);
            ESP = _loc2_;
            F_exit();
            _loc2_ += 16;
         }
      }
      _loc1_ = li8(_loc3_ - 5);
      if(_loc1_ != 0)
      {
         var _temp_13:* = li32(_loc3_ - 4);
         _loc2_ -= 16;
         si32(_temp_13,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIiiiE24maxflow_reuse_trees_initEv();
         _loc2_ += 16;
      }
      else
      {
         var _temp_15:* = li32(_loc3_ - 4);
         _loc2_ -= 16;
         si32(_temp_15,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIiiiE12maxflow_initEv();
         _loc2_ += 16;
      }
      while(true)
      {
         _loc1_ = li32(_loc3_ - 44);
         si32(_loc1_,_loc3_ - 36);
         _loc8_ = 1;
         if(_loc1_ == 0)
         {
            _loc8_ = 0;
         }
         _loc1_ = _loc8_ & 1;
         si8(_loc1_,_loc3_ - 28);
         if(_loc1_ != 0)
         {
            var _temp_17:* = li32(_loc3_ - 36);
            si32(0,_temp_17 + 8);
            if(li32(li32(_loc3_ - 36) + 4) == 0)
            {
               si32(0,_loc3_ - 36);
            }
         }
         _loc1_ = li32(_loc3_ - 36);
         if(_loc1_ == 0)
         {
            var _temp_18:* = li32(_loc3_ - 4);
            _loc2_ -= 16;
            si32(_temp_18,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIiiiE11next_activeEv();
            _loc2_ += 16;
            var _temp_20:* = eax;
            si32(_temp_20,_loc3_ - 36);
            _loc7_ = 1;
            if(_temp_20 != 0)
            {
               _loc7_ = 0;
            }
            _loc1_ = _loc7_ & 1;
            si8(_loc1_,_loc3_ - 27);
            if(_loc1_ != 0)
            {
               break;
            }
         }
         _loc1_ = li32(_loc3_ - 36);
         _loc1_ = li8(_loc1_ + 20);
         _loc1_ &= 1;
         if(_loc1_ == 0)
         {
            si32(li32(li32(_loc3_ - 36)),_loc3_ - 48);
            while(true)
            {
               _loc1_ = li32(_loc3_ - 48);
               if(_loc1_ == 0)
               {
                  break;
               }
               if(li32(li32(_loc3_ - 48) + 12) != 0)
               {
                  var _temp_21:* = li32(li32(_loc3_ - 48));
                  si32(_temp_21,_loc3_ - 40);
                  if(li32(_temp_21 + 4) == 0)
                  {
                     _loc1_ = li32(_loc3_ - 40);
                     _loc12_ = li8(_loc1_ + 20);
                     _loc12_ = _loc12_ & 0xFE;
                     si8(_loc12_,_loc1_ + 20);
                     si32(li32(li32(_loc3_ - 48) + 8),li32(_loc3_ - 40) + 4);
                     si32(li32(li32(_loc3_ - 36) + 12),li32(_loc3_ - 40) + 12);
                     si32(int(li32(li32(_loc3_ - 36) + 16) + 1),li32(_loc3_ - 40) + 16);
                     var _temp_25:* = li32(_loc3_ - 4);
                     var _temp_24:* = li32(_loc3_ - 40);
                     _loc2_ -= 16;
                     si32(_temp_24,_loc2_ + 4);
                     si32(_temp_25,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIiiiE10set_activeEPNS0_4nodeE();
                     _loc2_ += 16;
                     var _temp_28:* = li32(_loc3_ - 4);
                     var _temp_27:* = li32(_loc3_ - 40);
                     _loc2_ -= 16;
                     si32(_temp_27,_loc2_ + 4);
                     si32(_temp_28,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIiiiE19add_to_changed_listEPNS0_4nodeE();
                     _loc2_ += 16;
                  }
                  else
                  {
                     if((li8(li32(_loc3_ - 40) + 20) & 1) != 0)
                     {
                        break;
                     }
                     var _temp_32:* = li32(li32(_loc3_ - 36) + 12);
                     if((_loc12_ = li32((_loc12_ = li32(_loc3_ - 40)) + 12)) <= _temp_32)
                     {
                        var _temp_35:* = li32(li32(_loc3_ - 36) + 16);
                        if((_loc12_ = li32((_loc12_ = li32(_loc3_ - 40)) + 16)) > _temp_35)
                        {
                           si32(li32(li32(_loc3_ - 48) + 8),li32(_loc3_ - 40) + 4);
                           si32(li32(li32(_loc3_ - 36) + 12),li32(_loc3_ - 40) + 12);
                           si32(int(li32(li32(_loc3_ - 36) + 16) + 1),li32(_loc3_ - 40) + 16);
                        }
                     }
                  }
               }
               _loc1_ = li32(_loc3_ - 48);
               _loc1_ = li32(_loc1_ + 4);
               si32(_loc1_,_loc3_ - 48);
            }
         }
         else
         {
            si32(li32(li32(_loc3_ - 36)),_loc3_ - 48);
            while(true)
            {
               _loc1_ = li32(_loc3_ - 48);
               if(_loc1_ == 0)
               {
                  break;
               }
               if(li32(li32(li32(_loc3_ - 48) + 8) + 12) != 0)
               {
                  var _temp_36:* = li32(li32(_loc3_ - 48));
                  si32(_temp_36,_loc3_ - 40);
                  if(li32(_temp_36 + 4) == 0)
                  {
                     _loc1_ = li32(_loc3_ - 40);
                     _loc12_ = li8(_loc1_ + 20);
                     _loc12_ = _loc12_ | 1;
                     si8(_loc12_,_loc1_ + 20);
                     si32(li32(li32(_loc3_ - 48) + 8),li32(_loc3_ - 40) + 4);
                     si32(li32(li32(_loc3_ - 36) + 12),li32(_loc3_ - 40) + 12);
                     si32(int(li32(li32(_loc3_ - 36) + 16) + 1),li32(_loc3_ - 40) + 16);
                     var _temp_40:* = li32(_loc3_ - 4);
                     var _temp_39:* = li32(_loc3_ - 40);
                     _loc2_ -= 16;
                     si32(_temp_39,_loc2_ + 4);
                     si32(_temp_40,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIiiiE10set_activeEPNS0_4nodeE();
                     _loc2_ += 16;
                     var _temp_43:* = li32(_loc3_ - 4);
                     var _temp_42:* = li32(_loc3_ - 40);
                     _loc2_ -= 16;
                     si32(_temp_42,_loc2_ + 4);
                     si32(_temp_43,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIiiiE19add_to_changed_listEPNS0_4nodeE();
                     _loc2_ += 16;
                  }
                  else
                  {
                     if((li8(li32(_loc3_ - 40) + 20) & 1) == 0)
                     {
                        si32(li32(li32(_loc3_ - 48) + 8),_loc3_ - 48);
                        break;
                     }
                     var _temp_47:* = li32(li32(_loc3_ - 36) + 12);
                     if((_loc12_ = li32((_loc12_ = li32(_loc3_ - 40)) + 12)) <= _temp_47)
                     {
                        var _temp_50:* = li32(li32(_loc3_ - 36) + 16);
                        if((_loc12_ = li32((_loc12_ = li32(_loc3_ - 40)) + 16)) > _temp_50)
                        {
                           si32(li32(li32(_loc3_ - 48) + 8),li32(_loc3_ - 40) + 4);
                           si32(li32(li32(_loc3_ - 36) + 12),li32(_loc3_ - 40) + 12);
                           si32(int(li32(li32(_loc3_ - 36) + 16) + 1),li32(_loc3_ - 40) + 16);
                        }
                     }
                  }
               }
               _loc1_ = li32(_loc3_ - 48);
               _loc1_ = li32(_loc1_ + 4);
               si32(_loc1_,_loc3_ - 48);
            }
         }
         _loc1_ = li32(_loc3_ - 4);
         _loc12_ = li32(_loc1_ + 72);
         _loc12_ = _loc12_ + 1;
         si32(_loc12_,_loc1_ + 72);
         _loc1_ = li32(_loc3_ - 48);
         if(_loc1_ != 0)
         {
            _loc1_ = li32(_loc3_ - 36);
            si32(_loc1_,_loc1_ + 8);
            si32(li32(_loc3_ - 36),_loc3_ - 44);
            var _temp_54:* = li32(_loc3_ - 4);
            var _temp_53:* = li32(_loc3_ - 48);
            _loc2_ -= 16;
            si32(_temp_53,_loc2_ + 4);
            si32(_temp_54,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIiiiE7augmentEPNS0_3arcE();
            _loc2_ += 16;
            while(true)
            {
               _loc1_ = li32(_loc3_ - 4);
               _loc1_ = li32(_loc1_ + 64);
               si32(_loc1_,_loc3_ - 52);
               _loc5_ = 1;
               if(_loc1_ == 0)
               {
                  _loc5_ = 0;
               }
               _loc1_ = _loc5_ & 1;
               si8(_loc1_,_loc3_ - 26);
               if(_loc1_ == 0)
               {
                  break;
               }
               si32(li32(li32(_loc3_ - 52) + 4),_loc3_ - 56);
               var _temp_56:* = li32(_loc3_ - 52);
               si32(0,_temp_56 + 4);
               while(true)
               {
                  _loc1_ = li32(_loc3_ - 4);
                  _loc1_ = li32(_loc1_ + 64);
                  si32(_loc1_,_loc3_ - 52);
                  _loc6_ = 1;
                  if(_loc1_ == 0)
                  {
                     _loc6_ = 0;
                  }
                  _loc1_ = _loc6_ & 1;
                  si8(_loc1_,_loc3_ - 25);
                  if(_loc1_ == 0)
                  {
                     break;
                  }
                  si32(li32(li32(_loc3_ - 52) + 4),li32(_loc3_ - 4) + 64);
                  si32(li32(li32(_loc3_ - 52)),_loc3_ - 36);
                  var _temp_58:* = li32(li32(_loc3_ - 4) + 28);
                  var _temp_57:* = li32(_loc3_ - 52);
                  _loc2_ -= 16;
                  si32(_temp_57,_loc2_ + 4);
                  si32(_temp_58,_loc2_);
                  ESP = _loc2_;
                  F__ZN6DBlockIN5GraphIiiiE7nodeptrEE6DeleteEPS2_();
                  _loc2_ += 16;
                  if(li32(li32(_loc3_ - 4) + 64) == 0)
                  {
                     var _temp_60:* = li32(_loc3_ - 4);
                     si32(0,_temp_60 + 68);
                  }
                  _loc1_ = li32(_loc3_ - 36);
                  _loc1_ = li8(_loc1_ + 20);
                  _loc1_ &= 1;
                  if(_loc1_ != 0)
                  {
                     var _temp_62:* = li32(_loc3_ - 4);
                     var _temp_61:* = li32(_loc3_ - 36);
                     _loc2_ -= 16;
                     si32(_temp_61,_loc2_ + 4);
                     si32(_temp_62,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIiiiE19process_sink_orphanEPNS0_4nodeE();
                     _loc2_ += 16;
                  }
                  else
                  {
                     var _temp_65:* = li32(_loc3_ - 4);
                     var _temp_64:* = li32(_loc3_ - 36);
                     _loc2_ -= 16;
                     si32(_temp_64,_loc2_ + 4);
                     si32(_temp_65,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIiiiE21process_source_orphanEPNS0_4nodeE();
                     _loc2_ += 16;
                  }
               }
               si32(li32(_loc3_ - 56),li32(_loc3_ - 4) + 64);
            }
         }
         else
         {
            si32(0,_loc3_ - 44);
         }
      }
      _loc4_ = 1;
      if(li8(_loc3_ - 5) != 0)
      {
         _loc4_ = 0;
      }
      _loc1_ = _loc4_ & 1;
      while(true)
      {
         if(_loc1_ == 0)
         {
            if((li8(li32(_loc3_ - 4) + 40) & 0x3F) != 0)
            {
               break;
            }
         }
         _loc1_ = li32(_loc3_ - 4);
         _loc1_ = li32(_loc1_ + 28);
         si32(_loc1_,_loc3_ - 24);
         if(_loc1_ != 0)
         {
            var _temp_67:* = li32(_loc3_ - 24);
            _loc2_ -= 16;
            si32(_temp_67,_loc2_);
            ESP = _loc2_;
            F__ZN6DBlockIN5GraphIiiiE7nodeptrEED1Ev();
            _loc2_ += 16;
            var _temp_69:* = li32(_loc3_ - 24);
            _loc2_ -= 16;
            si32(_temp_69,_loc2_);
            ESP = _loc2_;
            F__ZdlPv();
            _loc2_ += 16;
         }
         _loc1_ = li32(_loc3_ - 4);
         si32(0,_loc1_ + 28);
         break;
      }
      _loc1_ = li32(_loc3_ - 4);
      _loc12_ = li32(_loc1_ + 40);
      _loc12_ = _loc12_ + 1;
      si32(_loc12_,_loc1_ + 40);
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 36);
      si32(_loc1_,_loc3_ - 20);
      si32(_loc1_,_loc3_ - 16);
      _loc1_ = li32(_loc3_ - 16);
      eax = _loc1_;
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

