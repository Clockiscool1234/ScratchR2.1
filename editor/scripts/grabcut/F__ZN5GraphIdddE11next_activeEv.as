package grabcut
{
   import avm2.intrinsics.memory.li32;
   import avm2.intrinsics.memory.si32;
   import avm2.intrinsics.memory.si8;
   
   public function F__ZN5GraphIdddE11next_activeEv() : void
   {
      var _temp_1:* = this;
      var _loc3_:int = 0;
      var _loc1_:int = 0;
      var _loc5_:int = 0;
      var _loc2_:int = ESP;
      _loc3_ = _loc2_;
      _loc2_ -= 20;
      _loc1_ = li32(_loc3_);
      si32(_loc1_,_loc3_ - 4);
      while(true)
      {
         _loc1_ = li32(_loc3_ - 4);
         _loc1_ = li32(_loc1_ + 56);
         si32(_loc1_,_loc3_ - 20);
         _loc5_ = 1;
         if(_loc1_ != 0)
         {
            _loc5_ = 0;
         }
         _loc1_ = _loc5_ & 1;
         si8(_loc1_,_loc3_ - 13);
         if(_loc1_ != 0)
         {
            var _temp_5:* = li32(li32(_loc3_ - 4) + 60);
            si32(_temp_5,_loc3_ - 20);
            si32(_temp_5,li32(_loc3_ - 4) + 56);
            _loc1_ = li32(_loc3_ - 4);
            var _loc4_:int = li32(_loc1_ + 68);
            si32(_loc4_,_loc1_ + 64);
            var _temp_7:* = li32(_loc3_ - 4);
            si32(0,_temp_7 + 60);
            var _temp_8:* = li32(_loc3_ - 4);
            si32(0,_temp_8 + 68);
            if(li32(_loc3_ - 20) == 0)
            {
               si32(0,_loc3_ - 12);
               break;
            }
         }
         _loc4_ = li32(_loc3_ - 20);
         _loc1_ = li32(_loc4_ + 8);
         if(_loc1_ == _loc4_)
         {
            var _temp_10:* = li32(_loc3_ - 4);
            si32(0,_temp_10 + 64);
            _loc4_ = li32(_loc3_ - 4);
            si32(li32(_loc4_ + 64),_loc4_ + 56);
         }
         else
         {
            si32(li32(li32(_loc3_ - 20) + 8),li32(_loc3_ - 4) + 56);
         }
         _loc1_ = li32(_loc3_ - 20);
         si32(0,_loc1_ + 8);
         _loc1_ = li32(_loc3_ - 20);
         _loc1_ = li32(_loc1_ + 4);
         if(_loc1_ != 0)
         {
            si32(li32(_loc3_ - 20),_loc3_ - 12);
            break;
         }
      }
      _loc1_ = li32(_loc3_ - 12);
      si32(_loc1_,_loc3_ - 8);
      _loc1_ = li32(_loc3_ - 8);
      eax = _loc1_;
      _loc2_ = _loc3_;
      ESP = _loc2_;
   }
}

import avm2.intrinsics.memory.*;
import grabcut.*;
import grabcut_2F_var_2F_folders_2F_6q_2F_k8f6r3f11mz7vklyw3c3_thc0000gn_2F_T_2F__2F_ccVQcwCy_2E_o_3A_DB5CD35D_2D_786A_2D_4530_2D_A5AF_2D_7287B409CF40.*;

