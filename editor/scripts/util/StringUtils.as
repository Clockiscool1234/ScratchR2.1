package util
{
   import flash.utils.Dictionary;
   
   public class StringUtils
   {
      
      public function StringUtils()
      {
         super();
      }
      
      public static function substitute(param1:String, param2:Dictionary) : String
      {
         var _loc3_:String = null;
         for(_loc3_ in param2)
         {
            param1 = param1.replace("{" + _loc3_ + "}",param2[_loc3_]);
         }
         return param1;
      }
   }
}

