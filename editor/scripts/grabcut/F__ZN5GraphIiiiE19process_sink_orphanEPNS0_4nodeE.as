package grabcut
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F__ZN5GraphIiiiE19process_sink_orphanEPNS0_4nodeE() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc5_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 48;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      _loc1_ = li32(_loc3_ + 4);
      si32(_loc1_,_loc3_ - 8);
      si32(0,_loc3_ - 28);
      si32(2147483647,_loc3_ - 40);
      _loc1_ = li32(_loc3_ - 8);
      _loc1_ = li32(_loc1_);
      si32(_loc1_,_loc3_ - 24);
      _loc5_ = 1;
      loop0:
      while(true)
      {
         _loc1_ = li32(_loc3_ - 24);
         if(_loc1_ == 0)
         {
            break;
         }
         if(li32(li32(_loc3_ - 24) + 12) != 0)
         {
            var _temp_2:* = li32(li32(_loc3_ - 24));
            si32(_temp_2,_loc3_ - 20);
            while(true)
            {
               if((li8(_temp_2 + 20) & 1) != 0)
               {
                  var _temp_3:* = li32(li32(_loc3_ - 20) + 4);
                  si32(_temp_3,_loc3_ - 32);
                  if(_temp_3 != 0)
                  {
                     si8(_loc5_,_loc3_ - 12);
                     break;
                  }
               }
               si8(0,_loc3_ - 12);
               break;
            }
            _loc1_ = li8(_loc3_ - 12);
            si8(_loc1_,_loc3_ - 13);
            if(_loc1_ != 0)
            {
               si32(0,_loc3_ - 36);
               while(true)
               {
                  _loc1_ = li32(_loc3_ - 4);
                  _loc1_ = li32(_loc1_ + 72);
                  var _loc4_:int = li32(_loc3_ - 20);
                  _loc4_ = li32(_loc4_ + 12);
                  if(_loc4_ == _loc1_)
                  {
                     si32(int(li32(li32(_loc3_ - 20) + 16) + li32(_loc3_ - 36)),_loc3_ - 36);
                  }
                  else
                  {
                     si32(li32(li32(_loc3_ - 20) + 4),_loc3_ - 32);
                     si32(int(li32(_loc3_ - 36) + 1),_loc3_ - 36);
                     if(li32(_loc3_ - 32) == 1)
                     {
                        si32(li32(li32(_loc3_ - 4) + 72),li32(_loc3_ - 20) + 12);
                        var _temp_6:* = li32(_loc3_ - 20);
                        si32(_loc5_,_temp_6 + 16);
                     }
                     else
                     {
                        if(li32(_loc3_ - 32) != 2)
                        {
                           continue;
                        }
                        si32(2147483647,_loc3_ - 36);
                     }
                  }
                  _loc1_ = li32(_loc3_ - 36);
                  if(_loc1_ != 2147483647)
                  {
                     var _temp_8:* = li32(_loc3_ - 40);
                     if((_loc4_ = li32(_loc3_ - 36)) < _temp_8)
                     {
                        si32(li32(_loc3_ - 24),_loc3_ - 28);
                        si32(li32(_loc3_ - 36),_loc3_ - 40);
                     }
                     _loc1_ = li32(_loc3_ - 24);
                     _loc1_ = li32(_loc1_);
                     si32(_loc1_,_loc3_ - 20);
                     while(true)
                     {
                        _loc1_ = li32(_loc3_ - 4);
                        _loc1_ = li32(_loc1_ + 72);
                        _loc4_ = li32(_loc3_ - 20);
                        _loc4_ = li32(_loc4_ + 12);
                        if(_loc4_ == _loc1_)
                        {
                           break;
                        }
                        si32(li32(li32(_loc3_ - 4) + 72),li32(_loc3_ - 20) + 12);
                        si32(li32(_loc3_ - 36),li32(_loc3_ - 20) + 16);
                        si32(int(li32(_loc3_ - 36) + -1),_loc3_ - 36);
                        si32(li32(li32(li32(_loc3_ - 20) + 4)),_loc3_ - 20);
                     }
                  }
                  continue loop0;
                  si32(li32(li32(_loc3_ - 32)),_loc3_ - 20);
               }
            }
         }
         _loc1_ = li32(_loc3_ - 24);
         _loc1_ = li32(_loc1_ + 4);
         si32(_loc1_,_loc3_ - 24);
      }
      si32(li32(_loc3_ - 28),li32(_loc3_ - 8) + 4);
      if(li32(li32(_loc3_ - 8) + 4) == 0)
      {
         _loc5_ = 0;
      }
      _loc1_ = _loc5_ & 1;
      si8(_loc1_,_loc3_ - 11);
      if(_loc1_ != 0)
      {
         si32(li32(li32(_loc3_ - 4) + 72),li32(_loc3_ - 8) + 12);
         si32(int(li32(_loc3_ - 40) + 1),li32(_loc3_ - 8) + 16);
      }
      else
      {
         var _temp_12:* = li32(_loc3_ - 4);
         var _temp_11:* = li32(_loc3_ - 8);
         _loc2_ -= 16;
         si32(_temp_11,_loc2_ + 4);
         si32(_temp_12,_loc2_);
         ESP = _loc2_;
         F__ZN5GraphIiiiE19add_to_changed_listEPNS0_4nodeE();
         _loc2_ += 16;
         si32(li32(li32(_loc3_ - 8)),_loc3_ - 24);
         while(true)
         {
            _loc1_ = li32(_loc3_ - 24);
            if(_loc1_ == 0)
            {
               break;
            }
            var _temp_20:* = li32(li32(_loc3_ - 24));
            si32(_temp_20,_loc3_ - 20);
            while(true)
            {
               if((li8(_temp_20 + 20) & 1) != 0)
               {
                  var _temp_21:* = li32(li32(_loc3_ - 20) + 4);
                  si32(_temp_21,_loc3_ - 32);
                  if(_temp_21 != 0)
                  {
                     si8(1,_loc3_ - 9);
                     break;
                  }
               }
               si8(0,_loc3_ - 9);
               break;
            }
            _loc1_ = li8(_loc3_ - 9);
            si8(_loc1_,_loc3_ - 10);
            if(_loc1_ != 0)
            {
               if(li32(li32(_loc3_ - 24) + 12) != 0)
               {
                  var _temp_23:* = li32(_loc3_ - 4);
                  var _temp_22:* = li32(_loc3_ - 20);
                  _loc2_ -= 16;
                  si32(_temp_22,_loc2_ + 4);
                  si32(_temp_23,_loc2_);
                  ESP = _loc2_;
                  F__ZN5GraphIiiiE10set_activeEPNS0_4nodeE();
                  _loc2_ += 16;
               }
               _loc1_ = li32(_loc3_ - 32);
               if(_loc1_ != 1)
               {
                  if(li32(_loc3_ - 32) != 2)
                  {
                     if(li32(li32(_loc3_ - 32)) == li32(_loc3_ - 8))
                     {
                        var _temp_26:* = li32(_loc3_ - 4);
                        var _temp_25:* = li32(_loc3_ - 20);
                        _loc2_ -= 16;
                        si32(_temp_25,_loc2_ + 4);
                        si32(_temp_26,_loc2_);
                        ESP = _loc2_;
                        F__ZN5GraphIiiiE15set_orphan_rearEPNS0_4nodeE();
                        _loc2_ += 16;
                     }
                  }
               }
            }
            _loc1_ = li32(_loc3_ - 24);
            _loc1_ = li32(_loc1_ + 4);
            si32(_loc1_,_loc3_ - 24);
         }
      }
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

