package render3d
{
   import flash.display.Sprite;
   
   public class StageUIContainer extends Sprite
   {
      
      public function StageUIContainer()
      {
         super();
      }
      
      public function step(param1:Object) : void
      {
         var _loc3_:Object = null;
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_.visible == true && _loc3_.hasOwnProperty("step"))
            {
               if("listName" in _loc3_)
               {
                  _loc3_.step();
               }
               else
               {
                  _loc3_.step(param1);
               }
            }
            _loc2_++;
         }
      }
   }
}

