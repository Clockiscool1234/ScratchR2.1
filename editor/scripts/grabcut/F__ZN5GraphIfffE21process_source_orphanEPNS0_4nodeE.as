package grabcut
{
   import avm2.intrinsics.memory.lf32;
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.li8;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F__ZN5GraphIfffE21process_source_orphanEPNS0_4nodeE() : void
   {
      var _temp_1:* = this;
      var _loc4_:int = 0;
      var _loc2_:int = 0;
      var _loc8_:int = 0;
      var _loc3_:int = ESP;
      _loc4_ = _loc3_;
      _loc3_ -= 48;
      _loc2_ = li32(_loc4_);
      si32(_loc2_,_loc4_ - 4);
      _loc2_ = li32(_loc4_ + 4);
      si32(_loc2_,_loc4_ - 8);
      si32(0,_loc4_ - 28);
      si32(2147483647,_loc4_ - 40);
      _loc2_ = li32(_loc4_ - 8);
      _loc2_ = li32(_loc2_);
      si32(_loc2_,_loc4_ - 24);
      _loc8_ = 1;
      loop0:
      while(true)
      {
         _loc2_ = li32(_loc4_ - 24);
         if(_loc2_ == 0)
         {
            break;
         }
         var _temp_5:* = 0;
         var _loc5_:Number;
         var _loc7_:int;
         if((_loc5_ = lf32((_loc7_ = li32((_loc7_ = li32(_loc4_ - 24)) + 8)) + 12)) != _temp_5)
         {
            var _temp_6:* = li32(li32(_loc4_ - 24));
            si32(_temp_6,_loc4_ - 20);
            while(true)
            {
               if((li8(_temp_6 + 20) & 1) == 0)
               {
                  var _temp_7:* = li32(li32(_loc4_ - 20) + 4);
                  si32(_temp_7,_loc4_ - 32);
                  if(_temp_7 != 0)
                  {
                     si8(_loc8_,_loc4_ - 12);
                     break;
                  }
               }
               si8(0,_loc4_ - 12);
               break;
            }
            _loc2_ = li8(_loc4_ - 12);
            si8(_loc2_,_loc4_ - 13);
            if(_loc2_ != 0)
            {
               si32(0,_loc4_ - 36);
               while(true)
               {
                  _loc2_ = li32(_loc4_ - 4);
                  _loc2_ = li32(_loc2_ + 72);
                  _loc7_ = li32(_loc4_ - 20);
                  _loc7_ = li32(_loc7_ + 12);
                  if(_loc7_ == _loc2_)
                  {
                     si32(int(li32(li32(_loc4_ - 20) + 16) + li32(_loc4_ - 36)),_loc4_ - 36);
                  }
                  else
                  {
                     si32(li32(li32(_loc4_ - 20) + 4),_loc4_ - 32);
                     si32(int(li32(_loc4_ - 36) + 1),_loc4_ - 36);
                     if(li32(_loc4_ - 32) == 1)
                     {
                        si32(li32(li32(_loc4_ - 4) + 72),li32(_loc4_ - 20) + 12);
                        var _temp_10:* = li32(_loc4_ - 20);
                        si32(_loc8_,_temp_10 + 16);
                     }
                     else
                     {
                        if(li32(_loc4_ - 32) != 2)
                        {
                           continue;
                        }
                        si32(2147483647,_loc4_ - 36);
                     }
                  }
                  _loc2_ = li32(_loc4_ - 36);
                  if(_loc2_ != 2147483647)
                  {
                     var _temp_11:* = li32(_loc4_ - 40);
                     if(li32(_loc4_ - 36) < _temp_11)
                     {
                        si32(li32(_loc4_ - 24),_loc4_ - 28);
                        si32(li32(_loc4_ - 36),_loc4_ - 40);
                     }
                     _loc2_ = li32(_loc4_ - 24);
                     _loc2_ = li32(_loc2_);
                     si32(_loc2_,_loc4_ - 20);
                     while(true)
                     {
                        _loc2_ = li32(_loc4_ - 4);
                        _loc2_ = li32(_loc2_ + 72);
                        _loc7_ = li32(_loc4_ - 20);
                        _loc7_ = li32(_loc7_ + 12);
                        if(_loc7_ == _loc2_)
                        {
                           break;
                        }
                        si32(li32(li32(_loc4_ - 4) + 72),li32(_loc4_ - 20) + 12);
                        si32(li32(_loc4_ - 36),li32(_loc4_ - 20) + 16);
                        si32(int(li32(_loc4_ - 36) + -1),_loc4_ - 36);
                        si32(li32(li32(li32(_loc4_ - 20) + 4)),_loc4_ - 20);
                     }
                  }
                  continue loop0;
                  si32(li32(li32(_loc4_ - 32)),_loc4_ - 20);
               }
            }
         }
         _loc2_ = li32(_loc4_ - 24);
         _loc2_ = li32(_loc2_ + 4);
         si32(_loc2_,_loc4_ - 24);
      }
      si32(li32(_loc4_ - 28),li32(_loc4_ - 8) + 4);
      if(li32(li32(_loc4_ - 8) + 4) == 0)
      {
         _loc8_ = 0;
      }
      _loc2_ = _loc8_ & 1;
      si8(_loc2_,_loc4_ - 11);
      if(_loc2_ != 0)
      {
         si32(li32(li32(_loc4_ - 4) + 72),li32(_loc4_ - 8) + 12);
         si32(int(li32(_loc4_ - 40) + 1),li32(_loc4_ - 8) + 16);
      }
      else
      {
         var _temp_15:* = li32(_loc4_ - 4);
         var _temp_14:* = li32(_loc4_ - 8);
         _loc3_ -= 16;
         si32(_temp_14,_loc3_ + 4);
         si32(_temp_15,_loc3_);
         ESP = _loc3_;
         F__ZN5GraphIfffE19add_to_changed_listEPNS0_4nodeE();
         _loc3_ += 16;
         si32(li32(li32(_loc4_ - 8)),_loc4_ - 24);
         while(true)
         {
            _loc2_ = li32(_loc4_ - 24);
            if(_loc2_ == 0)
            {
               break;
            }
            var _temp_27:* = li32(li32(_loc4_ - 24));
            si32(_temp_27,_loc4_ - 20);
            while(true)
            {
               if((li8(_temp_27 + 20) & 1) == 0)
               {
                  var _temp_28:* = li32(li32(_loc4_ - 20) + 4);
                  si32(_temp_28,_loc4_ - 32);
                  if(_temp_28 != 0)
                  {
                     si8(1,_loc4_ - 9);
                     break;
                  }
               }
               si8(0,_loc4_ - 9);
               break;
            }
            _loc2_ = li8(_loc4_ - 9);
            si8(_loc2_,_loc4_ - 10);
            if(_loc2_ != 0)
            {
               var _temp_32:* = 0;
               if((_loc5_ = lf32((_loc7_ = li32((_loc7_ = li32(_loc4_ - 24)) + 8)) + 12)) != _temp_32)
               {
                  var _temp_34:* = li32(_loc4_ - 4);
                  var _temp_33:* = li32(_loc4_ - 20);
                  _loc3_ -= 16;
                  si32(_temp_33,_loc3_ + 4);
                  si32(_temp_34,_loc3_);
                  ESP = _loc3_;
                  F__ZN5GraphIfffE10set_activeEPNS0_4nodeE();
                  _loc3_ += 16;
               }
               _loc2_ = li32(_loc4_ - 32);
               if(_loc2_ != 1)
               {
                  if(li32(_loc4_ - 32) != 2)
                  {
                     if(li32(li32(_loc4_ - 32)) == li32(_loc4_ - 8))
                     {
                        var _temp_37:* = li32(_loc4_ - 4);
                        var _temp_36:* = li32(_loc4_ - 20);
                        _loc3_ -= 16;
                        si32(_temp_36,_loc3_ + 4);
                        si32(_temp_37,_loc3_);
                        ESP = _loc3_;
                        F__ZN5GraphIfffE15set_orphan_rearEPNS0_4nodeE();
                        _loc3_ += 16;
                     }
                  }
               }
            }
            _loc2_ = li32(_loc4_ - 24);
            _loc2_ = li32(_loc2_ + 4);
            si32(_loc2_,_loc4_ - 24);
         }
      }
      _loc3_ = _loc4_;
      ESP = _loc3_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

