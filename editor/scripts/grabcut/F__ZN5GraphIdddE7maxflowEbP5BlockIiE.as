package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;
   
   public function F__ZN5GraphIdddE7maxflowEbP5BlockIiE() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc11_:int = 0;
      var _loc9_:int = 0;
      var _loc7_:int = 0;
      var _loc6_:int = 0;
      var _loc5_:int = 0;
      var _loc4_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 80;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si8(_loc1_,_loc3_ - 5);
      _loc1_ = li32(_loc3_ + 8);
      si32(_loc1_,_loc3_ - 12);
      si32(0,_loc3_ - 56);
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
         si32(_temp_3,_loc3_ - 44);
         var _loc13_:int = li32(_loc3_ - 4);
         var _temp_5:* = li32(_loc13_ + 32);
         _loc2_ -= 16;
         si32(_temp_5,_loc2_ + 8);
         si32(128,_loc2_ + 4);
         si32(_temp_3,_loc2_);
         ESP = _loc2_;
         F__ZN6DBlockIN5GraphIdddE7nodeptrEEC1EiPFvPcE();
         _loc2_ += 16;
         si32(li32(_loc3_ - 44),li32(_loc3_ - 4) + 28);
      }
      _loc1_ = li32(_loc3_ - 12);
      _loc13_ = li32(_loc3_ - 4);
      si32(_loc1_,_loc13_ + 52);
      _loc1_ = li32(_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 48);
      if(_loc1_ == 0)
      {
         if(li8(_loc3_ - 5) != 0)
         {
            if(li32(li32(_loc3_ - 4) + 32) != 0)
            {
               var _loc12_:int = li32(li32(_loc3_ - 4) + 32);
               _loc2_ -= 16;
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str20,_loc2_);
               ESP = _loc2_;
               ptr2fun[_loc12_]();
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
      _loc1_ = li32(_loc1_ + 52);
      if(_loc1_ != 0)
      {
         _loc11_ = 1;
         if(li8(_loc3_ - 5) != 0)
         {
            _loc11_ = 0;
         }
         _loc1_ = _loc11_ & 1;
         if(_loc1_ != 0)
         {
            if(li32(li32(_loc3_ - 4) + 32) != 0)
            {
               var _loc10_:int = li32(li32(_loc3_ - 4) + 32);
               _loc2_ -= 16;
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str21,_loc2_);
               ESP = _loc2_;
               ptr2fun[_loc10_]();
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
         F__ZN5GraphIdddE24maxflow_reuse_trees_initEv();
         _loc2_ += 16;
      }
      else
      {
         var _temp_15:* = li32(_loc3_ - 4);
         _loc2_ -= 16;
         si32(_temp_15,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIdddE12maxflow_initEv();
         _loc2_ += 16;
      }
      while(true)
      {
         _loc1_ = li32(_loc3_ - 56);
         si32(_loc1_,_loc3_ - 48);
         _loc9_ = 1;
         if(_loc1_ == 0)
         {
            _loc9_ = 0;
         }
         _loc1_ = _loc9_ & 1;
         si8(_loc1_,_loc3_ - 40);
         if(_loc1_ != 0)
         {
            var _temp_17:* = li32(_loc3_ - 48);
            si32(0,_temp_17 + 8);
            if(li32(li32(_loc3_ - 48) + 4) == 0)
            {
               si32(0,_loc3_ - 48);
            }
         }
         _loc1_ = li32(_loc3_ - 48);
         if(_loc1_ == 0)
         {
            var _temp_18:* = li32(_loc3_ - 4);
            _loc2_ -= 16;
            si32(_temp_18,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIdddE11next_activeEv();
            _loc2_ += 16;
            var _temp_20:* = eax;
            si32(_temp_20,_loc3_ - 48);
            _loc7_ = 1;
            if(_temp_20 != 0)
            {
               _loc7_ = 0;
            }
            _loc1_ = _loc7_ & 1;
            si8(_loc1_,_loc3_ - 39);
            if(_loc1_ != 0)
            {
               break;
            }
         }
         _loc1_ = li32(_loc3_ - 48);
         _loc1_ = li8(_loc1_ + 20);
         _loc1_ &= 1;
         if(_loc1_ == 0)
         {
            si32(li32(li32(_loc3_ - 48)),_loc3_ - 60);
            while(true)
            {
               _loc1_ = li32(_loc3_ - 60);
               if(_loc1_ == 0)
               {
                  break;
               }
               var _loc8_:Number = lf64(li32(_loc3_ - 60) + 16);
               if(_loc8_ != 0)
               {
                  var _temp_22:* = li32(li32(_loc3_ - 60));
                  si32(_temp_22,_loc3_ - 52);
                  if(li32(_temp_22 + 4) == 0)
                  {
                     _loc1_ = li32(_loc3_ - 52);
                     _loc13_ = li8(_loc1_ + 20);
                     _loc13_ = _loc13_ & 0xFE;
                     si8(_loc13_,_loc1_ + 20);
                     si32(li32(li32(_loc3_ - 60) + 8),li32(_loc3_ - 52) + 4);
                     si32(li32(li32(_loc3_ - 48) + 12),li32(_loc3_ - 52) + 12);
                     si32(int(li32(li32(_loc3_ - 48) + 16) + 1),li32(_loc3_ - 52) + 16);
                     var _temp_26:* = li32(_loc3_ - 4);
                     var _temp_25:* = li32(_loc3_ - 52);
                     _loc2_ -= 16;
                     si32(_temp_25,_loc2_ + 4);
                     si32(_temp_26,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIdddE10set_activeEPNS0_4nodeE();
                     _loc2_ += 16;
                     var _temp_29:* = li32(_loc3_ - 4);
                     var _temp_28:* = li32(_loc3_ - 52);
                     _loc2_ -= 16;
                     si32(_temp_28,_loc2_ + 4);
                     si32(_temp_29,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIdddE19add_to_changed_listEPNS0_4nodeE();
                     _loc2_ += 16;
                  }
                  else
                  {
                     if((li8(li32(_loc3_ - 52) + 20) & 1) != 0)
                     {
                        break;
                     }
                     var _temp_33:* = li32(li32(_loc3_ - 48) + 12);
                     if((_loc13_ = li32((_loc13_ = li32(_loc3_ - 52)) + 12)) <= _temp_33)
                     {
                        var _temp_36:* = li32(li32(_loc3_ - 48) + 16);
                        if((_loc13_ = li32((_loc13_ = li32(_loc3_ - 52)) + 16)) > _temp_36)
                        {
                           si32(li32(li32(_loc3_ - 60) + 8),li32(_loc3_ - 52) + 4);
                           si32(li32(li32(_loc3_ - 48) + 12),li32(_loc3_ - 52) + 12);
                           si32(int(li32(li32(_loc3_ - 48) + 16) + 1),li32(_loc3_ - 52) + 16);
                        }
                     }
                  }
               }
               _loc1_ = li32(_loc3_ - 60);
               _loc1_ = li32(_loc1_ + 4);
               si32(_loc1_,_loc3_ - 60);
            }
         }
         else
         {
            si32(li32(li32(_loc3_ - 48)),_loc3_ - 60);
            while(true)
            {
               _loc1_ = li32(_loc3_ - 60);
               if(_loc1_ == 0)
               {
                  break;
               }
               _loc8_ = lf64(li32(li32(_loc3_ - 60) + 8) + 16);
               if(_loc8_ != 0)
               {
                  var _temp_38:* = li32(li32(_loc3_ - 60));
                  si32(_temp_38,_loc3_ - 52);
                  if(li32(_temp_38 + 4) == 0)
                  {
                     _loc1_ = li32(_loc3_ - 52);
                     _loc13_ = li8(_loc1_ + 20);
                     _loc13_ = _loc13_ | 1;
                     si8(_loc13_,_loc1_ + 20);
                     si32(li32(li32(_loc3_ - 60) + 8),li32(_loc3_ - 52) + 4);
                     si32(li32(li32(_loc3_ - 48) + 12),li32(_loc3_ - 52) + 12);
                     si32(int(li32(li32(_loc3_ - 48) + 16) + 1),li32(_loc3_ - 52) + 16);
                     var _temp_42:* = li32(_loc3_ - 4);
                     var _temp_41:* = li32(_loc3_ - 52);
                     _loc2_ -= 16;
                     si32(_temp_41,_loc2_ + 4);
                     si32(_temp_42,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIdddE10set_activeEPNS0_4nodeE();
                     _loc2_ += 16;
                     var _temp_45:* = li32(_loc3_ - 4);
                     var _temp_44:* = li32(_loc3_ - 52);
                     _loc2_ -= 16;
                     si32(_temp_44,_loc2_ + 4);
                     si32(_temp_45,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIdddE19add_to_changed_listEPNS0_4nodeE();
                     _loc2_ += 16;
                  }
                  else
                  {
                     if((li8(li32(_loc3_ - 52) + 20) & 1) == 0)
                     {
                        si32(li32(li32(_loc3_ - 60) + 8),_loc3_ - 60);
                        break;
                     }
                     var _temp_49:* = li32(li32(_loc3_ - 48) + 12);
                     if((_loc13_ = li32((_loc13_ = li32(_loc3_ - 52)) + 12)) <= _temp_49)
                     {
                        var _temp_52:* = li32(li32(_loc3_ - 48) + 16);
                        if((_loc13_ = li32((_loc13_ = li32(_loc3_ - 52)) + 16)) > _temp_52)
                        {
                           si32(li32(li32(_loc3_ - 60) + 8),li32(_loc3_ - 52) + 4);
                           si32(li32(li32(_loc3_ - 48) + 12),li32(_loc3_ - 52) + 12);
                           si32(int(li32(li32(_loc3_ - 48) + 16) + 1),li32(_loc3_ - 52) + 16);
                        }
                     }
                  }
               }
               _loc1_ = li32(_loc3_ - 60);
               _loc1_ = li32(_loc1_ + 4);
               si32(_loc1_,_loc3_ - 60);
            }
         }
         _loc1_ = li32(_loc3_ - 4);
         _loc13_ = li32(_loc1_ + 80);
         _loc13_ = _loc13_ + 1;
         si32(_loc13_,_loc1_ + 80);
         _loc1_ = li32(_loc3_ - 60);
         if(_loc1_ != 0)
         {
            _loc1_ = li32(_loc3_ - 48);
            si32(_loc1_,_loc1_ + 8);
            si32(li32(_loc3_ - 48),_loc3_ - 56);
            var _temp_56:* = li32(_loc3_ - 4);
            var _temp_55:* = li32(_loc3_ - 60);
            _loc2_ -= 16;
            si32(_temp_55,_loc2_ + 4);
            si32(_temp_56,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIdddE7augmentEPNS0_3arcE();
            _loc2_ += 16;
            while(true)
            {
               _loc1_ = li32(_loc3_ - 4);
               _loc1_ = li32(_loc1_ + 72);
               si32(_loc1_,_loc3_ - 64);
               _loc5_ = 1;
               if(_loc1_ == 0)
               {
                  _loc5_ = 0;
               }
               _loc1_ = _loc5_ & 1;
               si8(_loc1_,_loc3_ - 38);
               if(_loc1_ == 0)
               {
                  break;
               }
               si32(li32(li32(_loc3_ - 64) + 4),_loc3_ - 68);
               var _temp_58:* = li32(_loc3_ - 64);
               si32(0,_temp_58 + 4);
               while(true)
               {
                  _loc1_ = li32(_loc3_ - 4);
                  _loc1_ = li32(_loc1_ + 72);
                  si32(_loc1_,_loc3_ - 64);
                  _loc6_ = 1;
                  if(_loc1_ == 0)
                  {
                     _loc6_ = 0;
                  }
                  _loc1_ = _loc6_ & 1;
                  si8(_loc1_,_loc3_ - 37);
                  if(_loc1_ == 0)
                  {
                     break;
                  }
                  si32(li32(li32(_loc3_ - 64) + 4),li32(_loc3_ - 4) + 72);
                  si32(li32(li32(_loc3_ - 64)),_loc3_ - 48);
                  var _temp_60:* = li32(li32(_loc3_ - 4) + 28);
                  var _temp_59:* = li32(_loc3_ - 64);
                  _loc2_ -= 16;
                  si32(_temp_59,_loc2_ + 4);
                  si32(_temp_60,_loc2_);
                  ESP = _loc2_;
                  F__ZN6DBlockIN5GraphIdddE7nodeptrEE6DeleteEPS2_();
                  _loc2_ += 16;
                  if(li32(li32(_loc3_ - 4) + 72) == 0)
                  {
                     var _temp_62:* = li32(_loc3_ - 4);
                     si32(0,_temp_62 + 76);
                  }
                  _loc1_ = li32(_loc3_ - 48);
                  _loc1_ = li8(_loc1_ + 20);
                  _loc1_ &= 1;
                  if(_loc1_ != 0)
                  {
                     var _temp_64:* = li32(_loc3_ - 4);
                     var _temp_63:* = li32(_loc3_ - 48);
                     _loc2_ -= 16;
                     si32(_temp_63,_loc2_ + 4);
                     si32(_temp_64,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIdddE19process_sink_orphanEPNS0_4nodeE();
                     _loc2_ += 16;
                  }
                  else
                  {
                     var _temp_67:* = li32(_loc3_ - 4);
                     var _temp_66:* = li32(_loc3_ - 48);
                     _loc2_ -= 16;
                     si32(_temp_66,_loc2_ + 4);
                     si32(_temp_67,_loc2_);
                     ESP = _loc2_;
                     F__ZN5GraphIdddE21process_source_orphanEPNS0_4nodeE();
                     _loc2_ += 16;
                  }
               }
               si32(li32(_loc3_ - 68),li32(_loc3_ - 4) + 72);
            }
         }
         else
         {
            si32(0,_loc3_ - 56);
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
            if((li8(li32(_loc3_ - 4) + 48) & 0x3F) != 0)
            {
               break;
            }
         }
         _loc1_ = li32(_loc3_ - 4);
         _loc1_ = li32(_loc1_ + 28);
         si32(_loc1_,_loc3_ - 36);
         if(_loc1_ != 0)
         {
            var _temp_69:* = li32(_loc3_ - 36);
            _loc2_ -= 16;
            si32(_temp_69,_loc2_);
            ESP = _loc2_;
            F__ZN6DBlockIN5GraphIdddE7nodeptrEED1Ev();
            _loc2_ += 16;
            var _temp_71:* = li32(_loc3_ - 36);
            _loc2_ -= 16;
            si32(_temp_71,_loc2_);
            ESP = _loc2_;
            F__ZdlPv();
            _loc2_ += 16;
         }
         _loc1_ = li32(_loc3_ - 4);
         si32(0,_loc1_ + 28);
         break;
      }
      _loc1_ = li32(_loc3_ - 4);
      _loc13_ = li32(_loc1_ + 48);
      _loc13_ = _loc13_ + 1;
      si32(_loc13_,_loc1_ + 48);
      _loc1_ = li32(_loc3_ - 4);
      _loc8_ = lf64(_loc1_ + 40);
      sf64(_loc8_,_loc3_ - 32);
      sf64(_loc8_,_loc3_ - 24);
      st0 = _loc8_ = lf64(_loc3_ - 24);
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

