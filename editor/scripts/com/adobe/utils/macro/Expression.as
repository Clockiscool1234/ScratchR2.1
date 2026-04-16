package com.adobe.utils.macro
{
   public class Expression
   {
      
      public function Expression()
      {
         super();
      }
      
      public function print(param1:int) : void
      {
      }
      
      public function exec(param1:VM) : void
      {
      }
      
      protected function spaces(param1:int) : String
      {
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1)
         {
            _loc2_ += "  ";
            _loc3_++;
         }
         return _loc2_;
      }
   }
}

