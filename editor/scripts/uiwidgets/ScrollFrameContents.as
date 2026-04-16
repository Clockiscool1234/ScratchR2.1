package uiwidgets
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class ScrollFrameContents extends Sprite
   {
      
      public var color:int = 14737632;
      
      public var texture:BitmapData;
      
      public var hExtra:int = 10;
      
      public var vExtra:int = 10;
      
      public function ScrollFrameContents()
      {
         super();
      }
      
      public function clear(param1:Boolean = true) : void
      {
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         if(param1)
         {
            x = y = 0;
         }
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         graphics.clear();
         if(this.texture)
         {
            graphics.beginBitmapFill(this.texture);
         }
         else
         {
            graphics.beginFill(this.color);
         }
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
      
      public function updateSize() : void
      {
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc1_:int = 5;
         var _loc3_:int = 5;
         _loc6_ = 0;
         while(_loc6_ < numChildren)
         {
            _loc5_ = getChildAt(_loc6_);
            _loc1_ = Math.min(_loc1_,_loc5_.x);
            _loc3_ = Math.min(_loc3_,_loc5_.y);
            _loc2_ = Math.max(_loc2_,_loc5_.x + _loc5_.width);
            _loc4_ = Math.max(_loc4_,_loc5_.y + _loc5_.height);
            _loc6_++;
         }
         if(_loc1_ < 0 || _loc3_ < 0)
         {
            _loc7_ = Math.max(0,-_loc1_ + 5);
            _loc8_ = Math.max(0,-_loc3_ + 5);
            _loc6_ = 0;
            while(_loc6_ < numChildren)
            {
               _loc5_ = getChildAt(_loc6_);
               _loc5_.x += _loc7_;
               _loc5_.y += _loc8_;
               _loc6_++;
            }
            _loc2_ += _loc7_;
            _loc4_ += _loc8_;
         }
         _loc2_ += this.hExtra;
         _loc4_ += this.vExtra;
         if(parent is ScrollFrame)
         {
            _loc2_ = Math.max(_loc2_,(ScrollFrame(parent).visibleW() - x) / scaleX);
            _loc4_ = Math.max(_loc4_,(ScrollFrame(parent).visibleH() - y) / scaleY);
         }
         this.setWidthHeight(_loc2_,_loc4_);
         if(parent is ScrollFrame)
         {
            (parent as ScrollFrame).updateScrollbarVisibility();
         }
      }
   }
}

