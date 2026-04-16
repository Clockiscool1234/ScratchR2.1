package soundedit
{
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   
   public class SoundLevelMeter extends Sprite
   {
      
      private var w:int;
      
      private var h:int;
      
      private var bar:Shape;
      
      private var recentMax:Number = 0;
      
      public function SoundLevelMeter(param1:int, param2:int)
      {
         super();
         this.w = param1;
         this.h = param2;
         graphics.lineStyle(1,CSS.borderColor,1,true);
         graphics.drawRoundRect(0,0,this.w,this.h,7,7);
         addChild(this.bar = new Shape());
      }
      
      public function clear() : void
      {
         this.recentMax = 0;
         this.setLevel(0);
      }
      
      public function setLevel(param1:Number) : void
      {
         this.recentMax *= 0.85;
         this.recentMax = Math.max(param1,this.recentMax);
         this.drawBar(this.recentMax);
      }
      
      private function drawBar(param1:Number) : void
      {
         var _loc2_:int = 16711680;
         var _loc3_:int = 16776960;
         var _loc4_:int = 65280;
         var _loc5_:int = 3;
         var _loc6_:Graphics = this.bar.graphics;
         _loc6_.clear();
         _loc6_.beginFill(_loc2_);
         var _loc7_:int = (this.h - 1) * Math.min(param1,100) / 100;
         _loc6_.drawRoundRect(1,this.h - _loc7_,this.w - 1,_loc7_,_loc5_,_loc5_);
         _loc6_.beginFill(_loc3_);
         _loc7_ = this.h * Math.min(param1,95) / 100;
         _loc6_.drawRoundRect(1,this.h - _loc7_,this.w - 1,_loc7_,_loc5_,_loc5_);
         _loc6_.beginFill(_loc4_);
         _loc7_ = this.h * Math.min(param1,70) / 100;
         _loc6_.drawRoundRect(1,this.h - _loc7_,this.w - 1,_loc7_,_loc5_,_loc5_);
      }
   }
}

