package render3d
{
   import flash.display.BitmapData;
   
   public class SpriteStamp extends BitmapData
   {
      
      private var fx:Object;
      
      public function SpriteStamp(param1:int, param2:int, param3:Object)
      {
         super(param1,param2,true,0);
         this.effects = param3;
      }
      
      public function set effects(param1:Object) : void
      {
         var _loc2_:String = null;
         this.fx = null;
         if(param1)
         {
            this.fx = {};
            for(_loc2_ in param1)
            {
               this.fx[_loc2_] = param1[_loc2_];
            }
         }
      }
      
      public function get effects() : Object
      {
         return this.fx;
      }
   }
}

