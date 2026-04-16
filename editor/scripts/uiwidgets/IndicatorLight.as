package uiwidgets
{
   import flash.display.Graphics;
   import flash.display.Sprite;
   
   public class IndicatorLight extends Sprite
   {
      
      public var target:*;
      
      private var color:int;
      
      private var msg:String = "";
      
      public function IndicatorLight(param1:* = null)
      {
         super();
         this.target = param1;
         this.redraw();
      }
      
      public function setColorAndMsg(param1:int, param2:String) : void
      {
         if(param1 == this.color && param2 == this.msg)
         {
            return;
         }
         this.color = param1;
         this.msg = param2;
         SimpleTooltips.add(this,{
            "text":param2,
            "direction":"bottom"
         });
         this.redraw();
      }
      
      private function redraw() : void
      {
         var _loc1_:int = 5263440;
         var _loc2_:Graphics = graphics;
         _loc2_.clear();
         _loc2_.lineStyle(1,_loc1_);
         _loc2_.beginFill(this.color);
         _loc2_.drawCircle(7,7,6);
         _loc2_.endFill();
      }
   }
}

