package grabcut
{
   import avm2.intrinsics.memory.lf64;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F__ZN5GraphIdddE24maxflow_reuse_trees_initEv() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc6_:int = 0;
      var _loc5_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 32;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc1_ + 60);
      si32(_loc1_,_loc3_ - 20);
      _loc1_ = li32(_loc3_ - 4);
      si32(0,_loc1_ + 64);
      _loc1_ = li32(_loc3_ - 4);
      var _loc7_:int = li32(_loc1_ + 64);
      si32(_loc7_,_loc1_ + 56);
      _loc1_ = li32(_loc3_ - 4);
      si32(0,_loc1_ + 68);
      _loc1_ = li32(_loc3_ - 4);
      _loc7_ = li32(_loc1_ + 68);
      si32(_loc7_,_loc1_ + 60);
      _loc1_ = li32(_loc3_ - 4);
      si32(0,_loc1_ + 76);
      _loc1_ = li32(_loc3_ - 4);
      _loc7_ = li32(_loc1_ + 76);
      si32(_loc7_,_loc1_ + 72);
      _loc1_ = li32(_loc3_ - 4);
      _loc7_ = li32(_loc1_ + 80);
      _loc7_ = _loc7_ + 1;
      si32(_loc7_,_loc1_ + 80);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 20);
         si32(_loc1_,_loc3_ - 12);
         _loc6_ = 1;
         if(_loc1_ == 0)
         {
            _loc6_ = 0;
         }
         _loc1_ = _loc6_ & 1;
         si8(_loc1_,_loc3_ - 6);
         if(_loc1_ == 0)
         {
            break;
         }
         var _temp_7:* = li32(li32(_loc3_ - 12) + 8);
         si32(_temp_7,_loc3_ - 20);
         if(_temp_7 == li32(_loc3_ - 12))
         {
            si32(0,_loc3_ - 20);
         }
         _loc1_ = li32(_loc3_ - 12);
         si32(0,_loc1_ + 8);
         _loc1_ = li32(_loc3_ - 12);
         _loc7_ = li8(_loc1_ + 20);
         _loc7_ = _loc7_ & 0xFD;
         si8(_loc7_,_loc1_ + 20);
         _loc1_ = li32(_loc3_ - 4);
         _loc7_ = li32(_loc3_ - 12);
         _loc2_ -= 16;
         si32(_loc7_,_loc2_ + 4);
         si32(_loc1_,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIdddE10set_activeEPNS0_4nodeE();
         _loc2_ += 16;
         _loc1_ = li32(_loc3_ - 12);
         var _loc4_:Number = lf64(_loc1_ + 24);
         if(!(_loc4_ != 0 | _loc4_ != _loc4_ | false))
         {
            if(li32(li32(_loc3_ - 12) + 4) != 0)
            {
               var _temp_13:* = li32(_loc3_ - 4);
               var _temp_12:* = li32(_loc3_ - 12);
               _loc2_ -= 16;
               si32(_temp_12,_loc2_ + 4);
               si32(_temp_13,_loc2_);
               ESP = _loc2_;
               F__ZN5GraphIdddE15set_orphan_rearEPNS0_4nodeE();
               _loc2_ += 16;
            }
         }
         else
         {
            _loc4_ = lf64(li32(_loc3_ - 12) + 24);
            if(!(_loc4_ <= 0 | _loc4_ != _loc4_ | false))
            {
               while(true)
               {
                  if(li32(li32(_loc3_ - 12) + 4) != 0)
                  {
                     if((li8(li32(_loc3_ - 12) + 20) & 1) == 0)
                     {
                        break;
                     }
                  }
                  _loc1_ = li32(_loc3_ - 12);
                  _loc7_ = li8(_loc1_ + 20);
                  _loc7_ = _loc7_ & 0xFE;
                  si8(_loc7_,_loc1_ + 20);
                  _loc1_ = li32(_loc3_ - 12);
                  _loc1_ = li32(_loc1_);
                  si32(_loc1_,_loc3_ - 24);
                  while(true)
                  {
                     _loc1_ = li32(_loc3_ - 24);
                     if(_loc1_ == 0)
                     {
                        break;
                     }
                     var _temp_18:* = li32(li32(_loc3_ - 24));
                     si32(_temp_18,_loc3_ - 16);
                     if((li8(_temp_18 + 20) >>> 1 & 1) == 0)
                     {
                        var _temp_21:* = li32(li32(_loc3_ - 24) + 8);
                        if((_loc7_ = li32((_loc7_ = li32(_loc3_ - 16)) + 4)) == _temp_21)
                        {
                           var _temp_23:* = li32(_loc3_ - 4);
                           var _temp_22:* = li32(_loc3_ - 16);
                           _loc2_ -= 16;
                           si32(_temp_22,_loc2_ + 4);
                           si32(_temp_23,_loc2_);
                           ESP = _loc2_;
                           F__ZN5GraphIdddE15set_orphan_rearEPNS0_4nodeE();
                           _loc2_ += 16;
                        }
                        _loc1_ = li32(_loc3_ - 16);
                        _loc1_ = li32(_loc1_ + 4);
                        if(_loc1_ != 0)
                        {
                           if((li8(li32(_loc3_ - 16) + 20) & 1) != 0)
                           {
                              _loc4_ = lf64(li32(_loc3_ - 24) + 16);
                              if(!(_loc4_ <= 0 | _loc4_ != _loc4_ | false))
                              {
                                 var _temp_27:* = li32(_loc3_ - 4);
                                 var _temp_26:* = li32(_loc3_ - 16);
                                 _loc2_ -= 16;
                                 si32(_temp_26,_loc2_ + 4);
                                 si32(_temp_27,_loc2_);
                                 ESP = _loc2_;
                                 F__ZN5GraphIdddE10set_activeEPNS0_4nodeE();
                                 _loc2_ += 16;
                              }
                           }
                        }
                     }
                     _loc1_ = li32(_loc3_ - 24);
                     _loc1_ = li32(_loc1_ + 4);
                     si32(_loc1_,_loc3_ - 24);
                  }
                  var _temp_30:* = li32(_loc3_ - 4);
                  var _temp_29:* = li32(_loc3_ - 12);
                  _loc2_ -= 16;
                  si32(_temp_29,_loc2_ + 4);
                  si32(_temp_30,_loc2_);
                  ESP = _loc2_;
                  F__ZN5GraphIdddE19add_to_changed_listEPNS0_4nodeE();
                  _loc2_ += 16;
                  break;
               }
            }
            else
            {
               while(true)
               {
                  if(li32(li32(_loc3_ - 12) + 4) != 0)
                  {
                     if((li8(li32(_loc3_ - 12) + 20) & 1) != 0)
                     {
                        break;
                     }
                  }
                  _loc1_ = li32(_loc3_ - 12);
                  _loc7_ = li8(_loc1_ + 20);
                  _loc7_ = _loc7_ | 1;
                  si8(_loc7_,_loc1_ + 20);
                  _loc1_ = li32(_loc3_ - 12);
                  _loc1_ = li32(_loc1_);
                  si32(_loc1_,_loc3_ - 24);
                  while(true)
                  {
                     _loc1_ = li32(_loc3_ - 24);
                     if(_loc1_ == 0)
                     {
                        break;
                     }
                     var _temp_34:* = li32(li32(_loc3_ - 24));
                     si32(_temp_34,_loc3_ - 16);
                     if((li8(_temp_34 + 20) >>> 1 & 1) == 0)
                     {
                        var _temp_37:* = li32(li32(_loc3_ - 24) + 8);
                        if((_loc7_ = li32((_loc7_ = li32(_loc3_ - 16)) + 4)) == _temp_37)
                        {
                           var _temp_39:* = li32(_loc3_ - 4);
                           var _temp_38:* = li32(_loc3_ - 16);
                           _loc2_ -= 16;
                           si32(_temp_38,_loc2_ + 4);
                           si32(_temp_39,_loc2_);
                           ESP = _loc2_;
                           F__ZN5GraphIdddE15set_orphan_rearEPNS0_4nodeE();
                           _loc2_ += 16;
                        }
                        _loc1_ = li32(_loc3_ - 16);
                        _loc1_ = li32(_loc1_ + 4);
                        if(_loc1_ != 0)
                        {
                           if((li8(li32(_loc3_ - 16) + 20) & 1) == 0)
                           {
                              _loc4_ = lf64(li32(li32(_loc3_ - 24) + 8) + 16);
                              if(!(_loc4_ <= 0 | _loc4_ != _loc4_ | false))
                              {
                                 var _temp_43:* = li32(_loc3_ - 4);
                                 var _temp_42:* = li32(_loc3_ - 16);
                                 _loc2_ -= 16;
                                 si32(_temp_42,_loc2_ + 4);
                                 si32(_temp_43,_loc2_);
                                 ESP = _loc2_;
                                 F__ZN5GraphIdddE10set_activeEPNS0_4nodeE();
                                 _loc2_ += 16;
                              }
                           }
                        }
                     }
                     _loc1_ = li32(_loc3_ - 24);
                     _loc1_ = li32(_loc1_ + 4);
                     si32(_loc1_,_loc3_ - 24);
                  }
                  var _temp_46:* = li32(_loc3_ - 4);
                  var _temp_45:* = li32(_loc3_ - 12);
                  _loc2_ -= 16;
                  si32(_temp_45,_loc2_ + 4);
                  si32(_temp_46,_loc2_);
                  ESP = _loc2_;
                  F__ZN5GraphIdddE19add_to_changed_listEPNS0_4nodeE();
                  _loc2_ += 16;
                  break;
               }
            }
            _loc1_ = li32(_loc3_ - 12);
            si32(1,_loc1_ + 4);
            _loc1_ = li32(_loc3_ - 4);
            _loc7_ = li32(_loc1_ + 80);
            _loc1_ = li32(_loc3_ - 12);
            si32(_loc7_,_loc1_ + 12);
            _loc1_ = li32(_loc3_ - 12);
            si32(1,_loc1_ + 16);
         }
      }
      while(true)
      {
         _loc1_ = li32(_loc3_ - 4);
         _loc1_ = li32(_loc1_ + 72);
         si32(_loc1_,_loc3_ - 28);
         _loc5_ = 1;
         if(_loc1_ == 0)
         {
            _loc5_ = 0;
         }
         _loc1_ = _loc5_ & 1;
         si8(_loc1_,_loc3_ - 5);
         if(_loc1_ == 0)
         {
            break;
         }
         si32(li32(li32(_loc3_ - 28) + 4),li32(_loc3_ - 4) + 72);
         si32(li32(li32(_loc3_ - 28)),_loc3_ - 12);
         var _temp_49:* = li32(li32(_loc3_ - 4) + 28);
         var _temp_48:* = li32(_loc3_ - 28);
         _loc2_ -= 16;
         si32(_temp_48,_loc2_ + 4);
         si32(_temp_49,_loc2_);
         ESP = _loc2_;
         F__ZN6DBlockIN5GraphIdddE7nodeptrEE6DeleteEPS2_();
         _loc2_ += 16;
         if(li32(li32(_loc3_ - 4) + 72) == 0)
         {
            var _temp_51:* = li32(_loc3_ - 4);
            si32(0,_temp_51 + 76);
         }
         _loc1_ = li32(_loc3_ - 12);
         _loc1_ = li8(_loc1_ + 20);
         _loc1_ &= 1;
         if(_loc1_ != 0)
         {
            var _temp_53:* = li32(_loc3_ - 4);
            var _temp_52:* = li32(_loc3_ - 12);
            _loc2_ -= 16;
            si32(_temp_52,_loc2_ + 4);
            si32(_temp_53,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIdddE19process_sink_orphanEPNS0_4nodeE();
            _loc2_ += 16;
         }
         else
         {
            var _temp_56:* = li32(_loc3_ - 4);
            var _temp_55:* = li32(_loc3_ - 12);
            _loc2_ -= 16;
            si32(_temp_55,_loc2_ + 4);
            si32(_temp_56,_loc2_);
            ESP = _loc2_;
            F__ZN5GraphIdddE21process_source_orphanEPNS0_4nodeE();
            _loc2_ += 16;
         }
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

