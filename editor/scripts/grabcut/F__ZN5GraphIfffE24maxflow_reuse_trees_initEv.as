package grabcut
{
   import avm2.intrinsics.memory.lf32;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F__ZN5GraphIfffE24maxflow_reuse_trees_initEv() : void
   {
      var _temp_1:* = this;
      var _loc4_:int = 0;
      var _loc2_:int = 0;
      var _loc6_:Number = NaN;
      var _loc8_:int = 0;
      var _loc7_:int = 0;
      var _loc3_:int = ESP;
      _loc4_ = _loc3_;
      _loc3_ -= 32;
      _loc2_ = li32(_loc4_);
      si32(_loc2_,_loc4_ - 4);
      _loc2_ = li32(_loc2_ + 52);
      si32(_loc2_,_loc4_ - 20);
      _loc2_ = li32(_loc4_ - 4);
      si32(0,_loc2_ + 56);
      _loc2_ = li32(_loc4_ - 4);
      var _loc9_:int = li32(_loc2_ + 56);
      si32(_loc9_,_loc2_ + 48);
      _loc2_ = li32(_loc4_ - 4);
      si32(0,_loc2_ + 60);
      _loc2_ = li32(_loc4_ - 4);
      _loc9_ = li32(_loc2_ + 60);
      si32(_loc9_,_loc2_ + 52);
      _loc2_ = li32(_loc4_ - 4);
      si32(0,_loc2_ + 68);
      _loc2_ = li32(_loc4_ - 4);
      _loc9_ = li32(_loc2_ + 68);
      si32(_loc9_,_loc2_ + 64);
      _loc2_ = li32(_loc4_ - 4);
      _loc9_ = li32(_loc2_ + 72);
      _loc9_ = _loc9_ + 1;
      si32(_loc9_,_loc2_ + 72);
      while(true)
      {
         _loc2_ = li32(_loc4_ - 20);
         si32(_loc2_,_loc4_ - 12);
         _loc8_ = 1;
         if(_loc2_ == 0)
         {
            _loc8_ = 0;
         }
         _loc2_ = _loc8_ & 1;
         si8(_loc2_,_loc4_ - 6);
         if(_loc2_ == 0)
         {
            break;
         }
         var _temp_7:* = li32(li32(_loc4_ - 12) + 8);
         si32(_temp_7,_loc4_ - 20);
         if(_temp_7 == li32(_loc4_ - 12))
         {
            si32(0,_loc4_ - 20);
         }
         _loc2_ = li32(_loc4_ - 12);
         si32(0,_loc2_ + 8);
         _loc2_ = li32(_loc4_ - 12);
         _loc9_ = li8(_loc2_ + 20);
         _loc9_ = _loc9_ & 0xFD;
         si8(_loc9_,_loc2_ + 20);
         _loc2_ = li32(_loc4_ - 4);
         _loc9_ = li32(_loc4_ - 12);
         _loc3_ -= 16;
         si32(_loc9_,_loc3_ + 4);
         si32(_loc2_,_loc3_);
         ESP = _loc3_;
         F__ZN5GraphIfffE10set_activeEPNS0_4nodeE();
         _loc3_ += 16;
         var _loc1_:Number = 0;
         _loc6_ = _loc1_;
         _loc2_ = li32(_loc4_ - 12);
         var _loc5_:Number = lf32(_loc2_ + 24);
         if(!(_loc5_ != _loc6_ | _loc5_ != _loc5_ | _loc6_ != _loc6_))
         {
            if(li32(li32(_loc4_ - 12) + 4) != 0)
            {
               var _temp_13:* = li32(_loc4_ - 4);
               var _temp_12:* = li32(_loc4_ - 12);
               _loc3_ -= 16;
               si32(_temp_12,_loc3_ + 4);
               si32(_temp_13,_loc3_);
               ESP = _loc3_;
               F__ZN5GraphIfffE15set_orphan_rearEPNS0_4nodeE();
               _loc3_ += 16;
            }
         }
         else
         {
            _loc5_ = lf32(li32(_loc4_ - 12) + 24);
            if(!(_loc5_ <= _loc6_ | _loc5_ != _loc5_ | _loc6_ != _loc6_))
            {
               while(true)
               {
                  if(li32(li32(_loc4_ - 12) + 4) != 0)
                  {
                     if((li8(li32(_loc4_ - 12) + 20) & 1) == 0)
                     {
                        break;
                     }
                  }
                  _loc2_ = li32(_loc4_ - 12);
                  _loc9_ = li8(_loc2_ + 20);
                  _loc9_ = _loc9_ & 0xFE;
                  si8(_loc9_,_loc2_ + 20);
                  _loc2_ = li32(_loc4_ - 12);
                  _loc2_ = li32(_loc2_);
                  si32(_loc2_,_loc4_ - 24);
                  while(true)
                  {
                     _loc2_ = li32(_loc4_ - 24);
                     if(_loc2_ == 0)
                     {
                        break;
                     }
                     var _temp_18:* = li32(li32(_loc4_ - 24));
                     si32(_temp_18,_loc4_ - 16);
                     if((li8(_temp_18 + 20) >>> 1 & 1) == 0)
                     {
                        var _temp_21:* = li32(li32(_loc4_ - 24) + 8);
                        if((_loc9_ = li32((_loc9_ = li32(_loc4_ - 16)) + 4)) == _temp_21)
                        {
                           var _temp_23:* = li32(_loc4_ - 4);
                           var _temp_22:* = li32(_loc4_ - 16);
                           _loc3_ -= 16;
                           si32(_temp_22,_loc3_ + 4);
                           si32(_temp_23,_loc3_);
                           ESP = _loc3_;
                           F__ZN5GraphIfffE15set_orphan_rearEPNS0_4nodeE();
                           _loc3_ += 16;
                        }
                        _loc2_ = li32(_loc4_ - 16);
                        _loc2_ = li32(_loc2_ + 4);
                        if(_loc2_ != 0)
                        {
                           if((li8(li32(_loc4_ - 16) + 20) & 1) != 0)
                           {
                              _loc5_ = lf32(li32(_loc4_ - 24) + 12);
                              if(!(_loc5_ <= _loc6_ | _loc5_ != _loc5_ | _loc6_ != _loc6_))
                              {
                                 var _temp_27:* = li32(_loc4_ - 4);
                                 var _temp_26:* = li32(_loc4_ - 16);
                                 _loc3_ -= 16;
                                 si32(_temp_26,_loc3_ + 4);
                                 si32(_temp_27,_loc3_);
                                 ESP = _loc3_;
                                 F__ZN5GraphIfffE10set_activeEPNS0_4nodeE();
                                 _loc3_ += 16;
                              }
                           }
                        }
                     }
                     _loc2_ = li32(_loc4_ - 24);
                     _loc2_ = li32(_loc2_ + 4);
                     si32(_loc2_,_loc4_ - 24);
                  }
                  var _temp_30:* = li32(_loc4_ - 4);
                  var _temp_29:* = li32(_loc4_ - 12);
                  _loc3_ -= 16;
                  si32(_temp_29,_loc3_ + 4);
                  si32(_temp_30,_loc3_);
                  ESP = _loc3_;
                  F__ZN5GraphIfffE19add_to_changed_listEPNS0_4nodeE();
                  _loc3_ += 16;
                  break;
               }
            }
            else
            {
               while(true)
               {
                  if(li32(li32(_loc4_ - 12) + 4) != 0)
                  {
                     if((li8(li32(_loc4_ - 12) + 20) & 1) != 0)
                     {
                        break;
                     }
                  }
                  _loc2_ = li32(_loc4_ - 12);
                  _loc9_ = li8(_loc2_ + 20);
                  _loc9_ = _loc9_ | 1;
                  si8(_loc9_,_loc2_ + 20);
                  _loc2_ = li32(_loc4_ - 12);
                  _loc2_ = li32(_loc2_);
                  si32(_loc2_,_loc4_ - 24);
                  while(true)
                  {
                     _loc2_ = li32(_loc4_ - 24);
                     if(_loc2_ == 0)
                     {
                        break;
                     }
                     var _temp_34:* = li32(li32(_loc4_ - 24));
                     si32(_temp_34,_loc4_ - 16);
                     if((li8(_temp_34 + 20) >>> 1 & 1) == 0)
                     {
                        var _temp_37:* = li32(li32(_loc4_ - 24) + 8);
                        if((_loc9_ = li32((_loc9_ = li32(_loc4_ - 16)) + 4)) == _temp_37)
                        {
                           var _temp_39:* = li32(_loc4_ - 4);
                           var _temp_38:* = li32(_loc4_ - 16);
                           _loc3_ -= 16;
                           si32(_temp_38,_loc3_ + 4);
                           si32(_temp_39,_loc3_);
                           ESP = _loc3_;
                           F__ZN5GraphIfffE15set_orphan_rearEPNS0_4nodeE();
                           _loc3_ += 16;
                        }
                        _loc2_ = li32(_loc4_ - 16);
                        _loc2_ = li32(_loc2_ + 4);
                        if(_loc2_ != 0)
                        {
                           if((li8(li32(_loc4_ - 16) + 20) & 1) == 0)
                           {
                              _loc5_ = lf32(li32(li32(_loc4_ - 24) + 8) + 12);
                              if(!(_loc5_ <= _loc6_ | _loc5_ != _loc5_ | _loc6_ != _loc6_))
                              {
                                 var _temp_43:* = li32(_loc4_ - 4);
                                 var _temp_42:* = li32(_loc4_ - 16);
                                 _loc3_ -= 16;
                                 si32(_temp_42,_loc3_ + 4);
                                 si32(_temp_43,_loc3_);
                                 ESP = _loc3_;
                                 F__ZN5GraphIfffE10set_activeEPNS0_4nodeE();
                                 _loc3_ += 16;
                              }
                           }
                        }
                     }
                     _loc2_ = li32(_loc4_ - 24);
                     _loc2_ = li32(_loc2_ + 4);
                     si32(_loc2_,_loc4_ - 24);
                  }
                  var _temp_46:* = li32(_loc4_ - 4);
                  var _temp_45:* = li32(_loc4_ - 12);
                  _loc3_ -= 16;
                  si32(_temp_45,_loc3_ + 4);
                  si32(_temp_46,_loc3_);
                  ESP = _loc3_;
                  F__ZN5GraphIfffE19add_to_changed_listEPNS0_4nodeE();
                  _loc3_ += 16;
                  break;
               }
            }
            _loc2_ = li32(_loc4_ - 12);
            si32(1,_loc2_ + 4);
            _loc2_ = li32(_loc4_ - 4);
            _loc9_ = li32(_loc2_ + 72);
            _loc2_ = li32(_loc4_ - 12);
            si32(_loc9_,_loc2_ + 12);
            _loc2_ = li32(_loc4_ - 12);
            si32(1,_loc2_ + 16);
         }
      }
      while(true)
      {
         _loc2_ = li32(_loc4_ - 4);
         _loc2_ = li32(_loc2_ + 64);
         si32(_loc2_,_loc4_ - 28);
         _loc7_ = 1;
         if(_loc2_ == 0)
         {
            _loc7_ = 0;
         }
         _loc2_ = _loc7_ & 1;
         si8(_loc2_,_loc4_ - 5);
         if(_loc2_ == 0)
         {
            break;
         }
         si32(li32(li32(_loc4_ - 28) + 4),li32(_loc4_ - 4) + 64);
         si32(li32(li32(_loc4_ - 28)),_loc4_ - 12);
         var _temp_49:* = li32(li32(_loc4_ - 4) + 28);
         var _temp_48:* = li32(_loc4_ - 28);
         _loc3_ -= 16;
         si32(_temp_48,_loc3_ + 4);
         si32(_temp_49,_loc3_);
         ESP = _loc3_;
         F__ZN6DBlockIN5GraphIfffE7nodeptrEE6DeleteEPS2_();
         _loc3_ += 16;
         if(li32(li32(_loc4_ - 4) + 64) == 0)
         {
            var _temp_51:* = li32(_loc4_ - 4);
            si32(0,_temp_51 + 68);
         }
         _loc2_ = li32(_loc4_ - 12);
         _loc2_ = li8(_loc2_ + 20);
         _loc2_ &= 1;
         if(_loc2_ != 0)
         {
            var _temp_53:* = li32(_loc4_ - 4);
            var _temp_52:* = li32(_loc4_ - 12);
            _loc3_ -= 16;
            si32(_temp_52,_loc3_ + 4);
            si32(_temp_53,_loc3_);
            ESP = _loc3_;
            F__ZN5GraphIfffE19process_sink_orphanEPNS0_4nodeE();
            _loc3_ += 16;
         }
         else
         {
            var _temp_56:* = li32(_loc4_ - 4);
            var _temp_55:* = li32(_loc4_ - 12);
            _loc3_ -= 16;
            si32(_temp_55,_loc3_ + 4);
            si32(_temp_56,_loc3_);
            ESP = _loc3_;
            F__ZN5GraphIfffE21process_source_orphanEPNS0_4nodeE();
            _loc3_ += 16;
         }
      }
      _loc3_ = _loc4_;
      ESP = _loc3_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

