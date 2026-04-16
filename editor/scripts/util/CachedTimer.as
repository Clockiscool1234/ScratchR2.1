package util
{
   import flash.utils.getTimer;
   
   public class CachedTimer
   {
      
      private static var cachedTimer:int;
      
      private static var dirty:Boolean = true;
      
      public function CachedTimer()
      {
         super();
      }
      
      public static function getCachedTimer() : int
      {
         return dirty ? getFreshTimer() : cachedTimer;
      }
      
      public static function clearCachedTimer() : void
      {
         dirty = true;
      }
      
      public static function getFreshTimer() : int
      {
         cachedTimer = getTimer();
         dirty = false;
         return cachedTimer;
      }
   }
}

