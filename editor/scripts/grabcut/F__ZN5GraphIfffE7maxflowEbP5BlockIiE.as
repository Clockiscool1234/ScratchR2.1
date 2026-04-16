package grabcut
{
   import avm2.intrinsics.memory.*;
   import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;
   
   public function F__ZN5GraphIfffE7maxflowEbP5BlockIiE() : void
   {
      var _temp_1:* = this;
      var _loc6_:int = 0;
      var _loc14_:int = 0;
      var _loc11_:int = 0;
      var _loc9_:int = 0;
      var _loc8_:int = 0;
      var _loc7_:int = 0;
      var _loc3_:int = 0;
      _loc6_ = ESP;
      var _loc4_:int = _loc6_ - 64;
      var _loc5_:int = li32(_loc6_);
      si32(_loc5_,_loc6_ - 4);
      _loc5_ = li32(_loc6_ + 4);
      si8(_loc5_,_loc6_ - 5);
      _loc5_ = li32(_loc6_ + 8);
      si32(_loc5_,_loc6_ - 12);
      si32(0,_loc6_ - 44);
      _loc5_ = li32(_loc6_ - 4);
      _loc5_ = li32(_loc5_ + 28);
      if(_loc5_ == 0)
      {
         _loc4_ -= 16;
         si32(16,_loc4_);
         ESP = _loc4_;
         F__Znwj();
         _loc4_ += 16;
         _loc5_ = eax;
         si32(_loc5_,_loc6_ - 32);
         var _loc16_:int = li32(_loc6_ - 4);
         si32(li32(_loc16_ + 32),(_loc4_ -= 16) + 8);
         si32(128,_loc4_ + 4);
         si32(_loc5_,_loc4_);
         ESP = _loc4_;
         F__ZN6DBlockIN5GraphIfffE7nodeptrEEC1EiPFvPcE();
         _loc4_ += 16;
         si32(li32(_loc6_ - 32),li32(_loc6_ - 4) + 28);
      }
      _loc5_ = li32(_loc6_ - 12);
      _loc16_ = li32(_loc6_ - 4);
      si32(_loc5_,_loc16_ + 44);
      _loc5_ = li32(_loc6_ - 4);
      _loc5_ = li32(_loc5_ + 40);
      if(_loc5_ == 0)
      {
         _loc5_ = li8(_loc6_ - 5);
         if(_loc5_ != 0)
         {
            _loc5_ = li32(_loc6_ - 4);
            _loc5_ = li32(_loc5_ + 32);
            if(_loc5_ != 0)
            {
               _loc5_ = li32(_loc6_ - 4);
               var _loc15_:int = li32(_loc5_ + 32);
               _loc4_ -= 16;
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str20,_loc4_);
               ESP = _loc4_;
               ptr2fun[_loc15_]();
               _loc4_ += 16;
            }
            _loc4_ -= 16;
            si32(1,_loc4_);
            ESP = _loc4_;
            F_exit();
            _loc4_ += 16;
         }
      }
      _loc5_ = li32(_loc6_ - 4);
      _loc5_ = li32(_loc5_ + 44);
      if(_loc5_ != 0)
      {
         _loc14_ = 1;
         _loc5_ = li8(_loc6_ - 5);
         if(_loc5_ != 0)
         {
            _loc14_ = 0;
         }
         _loc5_ = _loc14_ & 1;
         if(_loc5_ != 0)
         {
            _loc5_ = li32(_loc6_ - 4);
            _loc5_ = li32(_loc5_ + 32);
            if(_loc5_ != 0)
            {
               _loc5_ = li32(_loc6_ - 4);
               var _loc13_:int = li32(_loc5_ + 32);
               _loc4_ -= 16;
               si32(grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.L__2E_str21,_loc4_);
               ESP = _loc4_;
               ptr2fun[_loc13_]();
               _loc4_ += 16;
            }
            _loc4_ -= 16;
            si32(1,_loc4_);
            ESP = _loc4_;
            F_exit();
            _loc4_ += 16;
         }
      }
      _loc5_ = li8(_loc6_ - 5);
      if(_loc5_ != 0)
      {
         si32(li32(_loc6_ - 4),_loc4_ -= 16);
         ESP = _loc4_;
         F__ZN5GraphIfffE24maxflow_reuse_trees_initEv();
         _loc4_ += 16;
      }
      else
      {
         si32(li32(_loc6_ - 4),_loc4_ -= 16);
         ESP = _loc4_;
         F__ZN5GraphIfffE12maxflow_initEv();
         _loc4_ += 16;
      }
      while(true)
      {
         _loc5_ = li32(_loc6_ - 44);
         si32(_loc5_,_loc6_ - 36);
         _loc11_ = 1;
         if(_loc5_ == 0)
         {
            _loc11_ = 0;
         }
         _loc5_ = _loc11_ & 1;
         si8(_loc5_,_loc6_ - 28);
         if(_loc5_ != 0)
         {
            var _temp_39:* = li32(_loc6_ - 36);
            si32(0,_temp_39 + 8);
            _loc5_ = li32(_loc6_ - 36);
            _loc5_ = li32(_loc5_ + 4);
            if(_loc5_ == 0)
            {
               si32(0,_loc6_ - 36);
            }
         }
         _loc5_ = li32(_loc6_ - 36);
         if(_loc5_ == 0)
         {
            si32(li32(_loc6_ - 4),_loc4_ -= 16);
            ESP = _loc4_;
            F__ZN5GraphIfffE11next_activeEv();
            _loc4_ += 16;
            _loc5_ = eax;
            si32(_loc5_,_loc6_ - 36);
            _loc9_ = 1;
            if(_loc5_ != 0)
            {
               _loc9_ = 0;
            }
            _loc5_ = _loc9_ & 1;
            si8(_loc5_,_loc6_ - 27);
            if(_loc5_ != 0)
            {
               break;
            }
         }
         _loc5_ = li32(_loc6_ - 36);
         _loc5_ = li8(_loc5_ + 20);
         _loc5_ = _loc5_ & 1;
         if(_loc5_ == 0)
         {
            _loc5_ = li32(_loc6_ - 36);
            _loc5_ = li32(_loc5_);
            si32(_loc5_,_loc6_ - 48);
            while(true)
            {
               _loc5_ = li32(_loc6_ - 48);
               if(_loc5_ == 0)
               {
                  break;
               }
               _loc5_ = li32(_loc6_ - 48);
               if(lf32(_loc5_ + 12) != 0)
               {
                  _loc5_ = li32(_loc6_ - 48);
                  _loc5_ = li32(_loc5_);
                  si32(_loc5_,_loc6_ - 40);
                  _loc5_ = li32(_loc5_ + 4);
                  if(_loc5_ == 0)
                  {
                     _loc5_ = li32(_loc6_ - 40);
                     _loc16_ = li8(_loc5_ + 20);
                     _loc16_ = _loc16_ & 0xFE;
                     si8(_loc16_,_loc5_ + 20);
                     _loc5_ = li32(_loc6_ - 48);
                     si32(li32(_loc5_ + 8),li32(_loc6_ - 40) + 4);
                     _loc5_ = li32(_loc6_ - 36);
                     si32(li32(_loc5_ + 12),li32(_loc6_ - 40) + 12);
                     _loc5_ = li32(_loc6_ - 36);
                     _loc5_ = li32(_loc5_ + 16);
                     si32(int(_loc5_ + 1),li32(_loc6_ - 40) + 16);
                     var _temp_67:* = li32(_loc6_ - 4);
                     si32(li32(_loc6_ - 40),(_loc4_ -= 16) + 4);
                     si32(_temp_67,_loc4_);
                     ESP = _loc4_;
                     F__ZN5GraphIfffE10set_activeEPNS0_4nodeE();
                     _loc4_ += 16;
                     var _temp_70:* = li32(_loc6_ - 4);
                     si32(li32(_loc6_ - 40),(_loc4_ -= 16) + 4);
                     si32(_temp_70,_loc4_);
                     ESP = _loc4_;
                     F__ZN5GraphIfffE19add_to_changed_listEPNS0_4nodeE();
                     _loc4_ += 16;
                  }
                  else
                  {
                     _loc5_ = li32(_loc6_ - 40);
                     _loc5_ = li8(_loc5_ + 20);
                     _loc5_ = _loc5_ & 1;
                     if(_loc5_ != 0)
                     {
                        break;
                     }
                     _loc5_ = li32(_loc6_ - 36);
                     var _temp_78:* = li32(_loc5_ + 12);
                     if((_loc16_ = li32((_loc16_ = li32(_loc6_ - 40)) + 12)) <= _temp_78)
                     {
                        _loc5_ = li32(_loc6_ - 36);
                        var _temp_82:* = li32(_loc5_ + 16);
                        if((_loc16_ = li32((_loc16_ = li32(_loc6_ - 40)) + 16)) > _temp_82)
                        {
                           _loc5_ = li32(_loc6_ - 48);
                           si32(li32(_loc5_ + 8),li32(_loc6_ - 40) + 4);
                           _loc5_ = li32(_loc6_ - 36);
                           si32(li32(_loc5_ + 12),li32(_loc6_ - 40) + 12);
                           _loc5_ = li32(_loc6_ - 36);
                           _loc5_ = li32(_loc5_ + 16);
                           si32(int(_loc5_ + 1),li32(_loc6_ - 40) + 16);
                        }
                     }
                  }
               }
               _loc5_ = li32(_loc6_ - 48);
               _loc5_ = li32(_loc5_ + 4);
               si32(_loc5_,_loc6_ - 48);
            }
         }
         else
         {
            _loc5_ = li32(_loc6_ - 36);
            _loc5_ = li32(_loc5_);
            si32(_loc5_,_loc6_ - 48);
            while(true)
            {
               _loc5_ = li32(_loc6_ - 48);
               if(_loc5_ == 0)
               {
                  break;
               }
               var _temp_95:* = 0;
               var _loc10_:Number;
               if((_loc10_ = lf32((_loc16_ = li32((_loc16_ = li32(_loc6_ - 48)) + 8)) + 12)) != _temp_95)
               {
                  _loc5_ = li32(_loc6_ - 48);
                  _loc5_ = li32(_loc5_);
                  si32(_loc5_,_loc6_ - 40);
                  _loc5_ = li32(_loc5_ + 4);
                  if(_loc5_ == 0)
                  {
                     _loc5_ = li32(_loc6_ - 40);
                     _loc16_ = li8(_loc5_ + 20);
                     _loc16_ = _loc16_ | 1;
                     si8(_loc16_,_loc5_ + 20);
                     _loc5_ = li32(_loc6_ - 48);
                     si32(li32(_loc5_ + 8),li32(_loc6_ - 40) + 4);
                     _loc5_ = li32(_loc6_ - 36);
                     si32(li32(_loc5_ + 12),li32(_loc6_ - 40) + 12);
                     _loc5_ = li32(_loc6_ - 36);
                     _loc5_ = li32(_loc5_ + 16);
                     si32(int(_loc5_ + 1),li32(_loc6_ - 40) + 16);
                     var _temp_107:* = li32(_loc6_ - 4);
                     si32(li32(_loc6_ - 40),(_loc4_ -= 16) + 4);
                     si32(_temp_107,_loc4_);
                     ESP = _loc4_;
                     F__ZN5GraphIfffE10set_activeEPNS0_4nodeE();
                     _loc4_ += 16;
                     var _temp_110:* = li32(_loc6_ - 4);
                     si32(li32(_loc6_ - 40),(_loc4_ -= 16) + 4);
                     si32(_temp_110,_loc4_);
                     ESP = _loc4_;
                     F__ZN5GraphIfffE19add_to_changed_listEPNS0_4nodeE();
                     _loc4_ += 16;
                  }
                  else
                  {
                     _loc5_ = li32(_loc6_ - 40);
                     _loc5_ = li8(_loc5_ + 20);
                     _loc5_ = _loc5_ & 1;
                     if(_loc5_ == 0)
                     {
                        _loc5_ = li32(_loc6_ - 48);
                        _loc5_ = li32(_loc5_ + 8);
                        si32(_loc5_,_loc6_ - 48);
                        break;
                     }
                     _loc5_ = li32(_loc6_ - 36);
                     var _temp_120:* = li32(_loc5_ + 12);
                     if((_loc16_ = li32((_loc16_ = li32(_loc6_ - 40)) + 12)) <= _temp_120)
                     {
                        _loc5_ = li32(_loc6_ - 36);
                        var _temp_124:* = li32(_loc5_ + 16);
                        if((_loc16_ = li32((_loc16_ = li32(_loc6_ - 40)) + 16)) > _temp_124)
                        {
                           _loc5_ = li32(_loc6_ - 48);
                           si32(li32(_loc5_ + 8),li32(_loc6_ - 40) + 4);
                           _loc5_ = li32(_loc6_ - 36);
                           si32(li32(_loc5_ + 12),li32(_loc6_ - 40) + 12);
                           _loc5_ = li32(_loc6_ - 36);
                           _loc5_ = li32(_loc5_ + 16);
                           si32(int(_loc5_ + 1),li32(_loc6_ - 40) + 16);
                        }
                     }
                  }
               }
               _loc5_ = li32(_loc6_ - 48);
               _loc5_ = li32(_loc5_ + 4);
               si32(_loc5_,_loc6_ - 48);
            }
         }
         _loc5_ = li32(_loc6_ - 4);
         _loc16_ = li32(_loc5_ + 72);
         _loc16_ = _loc16_ + 1;
         si32(_loc16_,_loc5_ + 72);
         _loc5_ = li32(_loc6_ - 48);
         if(_loc5_ != 0)
         {
            _loc5_ = li32(_loc6_ - 36);
            si32(_loc5_,_loc5_ + 8);
            _loc5_ = li32(_loc6_ - 36);
            si32(_loc5_,_loc6_ - 44);
            var _temp_136:* = li32(_loc6_ - 4);
            si32(li32(_loc6_ - 48),(_loc4_ -= 16) + 4);
            si32(_temp_136,_loc4_);
            ESP = _loc4_;
            F__ZN5GraphIfffE7augmentEPNS0_3arcE();
            _loc4_ += 16;
            while(true)
            {
               _loc5_ = li32(_loc6_ - 4);
               _loc5_ = li32(_loc5_ + 64);
               si32(_loc5_,_loc6_ - 52);
               _loc7_ = 1;
               if(_loc5_ == 0)
               {
                  _loc7_ = 0;
               }
               _loc5_ = _loc7_ & 1;
               si8(_loc5_,_loc6_ - 26);
               if(_loc5_ == 0)
               {
                  break;
               }
               _loc5_ = li32(_loc6_ - 52);
               _loc5_ = li32(_loc5_ + 4);
               si32(_loc5_,_loc6_ - 56);
               var _temp_143:* = li32(_loc6_ - 52);
               si32(0,_temp_143 + 4);
               while(true)
               {
                  _loc5_ = li32(_loc6_ - 4);
                  _loc5_ = li32(_loc5_ + 64);
                  si32(_loc5_,_loc6_ - 52);
                  _loc8_ = 1;
                  if(_loc5_ == 0)
                  {
                     _loc8_ = 0;
                  }
                  _loc5_ = _loc8_ & 1;
                  si8(_loc5_,_loc6_ - 25);
                  if(_loc5_ == 0)
                  {
                     break;
                  }
                  _loc5_ = li32(_loc6_ - 52);
                  si32(li32(_loc5_ + 4),li32(_loc6_ - 4) + 64);
                  _loc5_ = li32(_loc6_ - 52);
                  _loc5_ = li32(_loc5_);
                  si32(_loc5_,_loc6_ - 36);
                  _loc5_ = li32(_loc6_ - 4);
                  var _temp_152:* = li32(_loc5_ + 28);
                  si32(li32(_loc6_ - 52),(_loc4_ -= 16) + 4);
                  si32(_temp_152,_loc4_);
                  ESP = _loc4_;
                  F__ZN6DBlockIN5GraphIfffE7nodeptrEE6DeleteEPS2_();
                  _loc4_ += 16;
                  _loc5_ = li32(_loc6_ - 4);
                  _loc5_ = li32(_loc5_ + 64);
                  if(_loc5_ == 0)
                  {
                     var _temp_156:* = li32(_loc6_ - 4);
                     si32(0,_temp_156 + 68);
                  }
                  _loc5_ = li32(_loc6_ - 36);
                  _loc5_ = li8(_loc5_ + 20);
                  _loc5_ = _loc5_ & 1;
                  if(_loc5_ != 0)
                  {
                     var _temp_161:* = li32(_loc6_ - 4);
                     si32(li32(_loc6_ - 36),(_loc4_ -= 16) + 4);
                     si32(_temp_161,_loc4_);
                     ESP = _loc4_;
                     F__ZN5GraphIfffE19process_sink_orphanEPNS0_4nodeE();
                     _loc4_ += 16;
                  }
                  else
                  {
                     var _temp_164:* = li32(_loc6_ - 4);
                     si32(li32(_loc6_ - 36),(_loc4_ -= 16) + 4);
                     si32(_temp_164,_loc4_);
                     ESP = _loc4_;
                     F__ZN5GraphIfffE21process_source_orphanEPNS0_4nodeE();
                     _loc4_ += 16;
                  }
               }
               si32(li32(_loc6_ - 56),li32(_loc6_ - 4) + 64);
            }
         }
         else
         {
            si32(0,_loc6_ - 44);
         }
      }
      _loc3_ = 1;
      _loc5_ = li8(_loc6_ - 5);
      if(_loc5_ != 0)
      {
         _loc3_ = 0;
      }
      while(true)
      {
         _loc5_ = _loc3_ & 1;
         if(_loc5_ == 0)
         {
            _loc5_ = li32(_loc6_ - 4);
            _loc5_ = li8(_loc5_ + 40);
            _loc5_ = _loc5_ & 0x3F;
            if(_loc5_ != 0)
            {
               break;
            }
         }
         _loc5_ = li32(_loc6_ - 4);
         _loc5_ = li32(_loc5_ + 28);
         si32(_loc5_,_loc6_ - 24);
         if(_loc5_ != 0)
         {
            si32(li32(_loc6_ - 24),_loc4_ -= 16);
            ESP = _loc4_;
            F__ZN6DBlockIN5GraphIfffE7nodeptrEED1Ev();
            _loc4_ += 16;
            si32(li32(_loc6_ - 24),_loc4_ -= 16);
            ESP = _loc4_;
            F__ZdlPv();
            _loc4_ += 16;
         }
         _loc5_ = li32(_loc6_ - 4);
         si32(0,_loc5_ + 28);
         break;
      }
      _loc5_ = li32(_loc6_ - 4);
      _loc16_ = li32(_loc5_ + 40);
      _loc16_ = _loc16_ + 1;
      si32(_loc16_,_loc5_ + 40);
      _loc5_ = li32(_loc6_ - 4);
      var _loc2_:Number = lf32(_loc5_ + 36);
      sf32(_loc2_,_loc6_ - 20);
      sf32(_loc2_,_loc6_ - 16);
      _loc2_ = lf32(_loc6_ - 16);
      st0 = _loc2_;
      ESP = _loc4_ = _loc6_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

