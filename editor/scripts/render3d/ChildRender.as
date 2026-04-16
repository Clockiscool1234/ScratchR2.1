package render3d
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ChildRender extends BitmapData
   {
      
      private const allowPartial:Boolean = true;
      
      private const maxSize:uint = 1022;
      
      private const halfSize:uint = this.maxSize >> 1;
      
      private var orig_width:Number;
      
      private var orig_height:Number;
      
      private var orig_bounds:Rectangle;
      
      public var inner_x:Number;
      
      public var inner_y:Number;
      
      public var inner_w:Number;
      
      public var inner_h:Number;
      
      public var scale:Number = 1;
      
      public function ChildRender(param1:Number, param2:Number, param3:DisplayObject, param4:DisplayObject, param5:Rectangle)
      {
         this.orig_width = param1;
         this.orig_height = param2;
         this.orig_bounds = param5;
         this.reset(param3,param4);
         super(Math.ceil(Math.min(param1,this.maxSize)),Math.ceil(Math.min(param2,this.maxSize)),true,0);
      }
      
      public function reset(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc3_:Rectangle = null;
         this.inner_x = this.inner_y = 0;
         this.inner_w = this.inner_h = 1;
         if(!this.allowPartial)
         {
            if(this.orig_width > this.maxSize || this.orig_height > this.maxSize)
            {
               this.scale = this.maxSize / Math.max(this.orig_width,this.orig_height);
            }
            return;
         }
         if(this.orig_width > this.maxSize || this.orig_height > this.maxSize)
         {
            _loc3_ = this.getVisibleBounds(param1,param2);
            _loc3_.inflate(this.halfSize - _loc3_.width / 2,0);
            if(_loc3_.x < 0)
            {
               _loc3_.width += _loc3_.x;
               _loc3_.x = 0;
            }
            if(_loc3_.right > this.orig_width)
            {
               _loc3_.width += this.orig_width - _loc3_.right;
            }
            this.inner_x = _loc3_.x / this.orig_width;
            this.inner_w = this.maxSize / this.orig_width;
         }
         if(this.orig_height > this.maxSize)
         {
            if(!_loc3_)
            {
               _loc3_ = this.getVisibleBounds(param1,param2);
            }
            _loc3_.inflate(0,this.halfSize - _loc3_.height / 2);
            if(_loc3_.y < 0)
            {
               _loc3_.height += _loc3_.y;
               _loc3_.y = 0;
            }
            if(_loc3_.bottom > this.orig_height)
            {
               _loc3_.height += this.orig_height - _loc3_.bottom;
            }
            this.inner_y = _loc3_.y / this.orig_height;
            this.inner_h = this.maxSize / this.orig_height;
         }
      }
      
      public function isPartial() : Boolean
      {
         return this.allowPartial && (width < this.orig_width || height < this.orig_height);
      }
      
      public function get renderWidth() : Number
      {
         return width > this.orig_width ? this.orig_width : width;
      }
      
      public function get renderHeight() : Number
      {
         return height > this.orig_height ? this.orig_height : height;
      }
      
      public function needsResize(param1:Number, param2:Number) : Boolean
      {
         if(width > this.orig_width && Math.ceil(param1) > width)
         {
            return true;
         }
         if(height > this.orig_height && Math.ceil(param2) > height)
         {
            return true;
         }
         return false;
      }
      
      public function needsRender(param1:DisplayObject, param2:Number, param3:Number, param4:DisplayObject) : Boolean
      {
         if(this.inner_x == 0 && this.inner_y == 0 && this.inner_w == 1 && this.inner_h == 1)
         {
            return false;
         }
         var _loc5_:Rectangle = new Rectangle(this.inner_x * param2,this.inner_y * param3,this.inner_w * param2,this.inner_h * param3);
         _loc5_.width += 0.001;
         _loc5_.height += 0.001;
         var _loc6_:Rectangle = this.getVisibleBounds(param1,param4);
         var _loc7_:Boolean = _loc5_.containsRect(_loc6_);
         return !_loc7_;
      }
      
      private function getVisibleBounds(param1:DisplayObject, param2:DisplayObject) : Rectangle
      {
         var _loc3_:Rectangle = param2.getBounds(param1);
         var _loc4_:Point = this.orig_bounds.topLeft;
         _loc3_.offset(-_loc4_.x,-_loc4_.y);
         if(_loc3_.x < 0)
         {
            _loc3_.width += _loc3_.x;
            _loc3_.x = 0;
         }
         if(_loc3_.y < 0)
         {
            _loc3_.height += _loc3_.y;
            _loc3_.y = 0;
         }
         if(_loc3_.right > this.orig_width)
         {
            _loc3_.width += this.orig_width - _loc3_.right;
         }
         if(_loc3_.bottom > this.orig_height)
         {
            _loc3_.height += this.orig_height - _loc3_.bottom;
         }
         _loc3_.x *= param1.scaleX;
         _loc3_.y *= param1.scaleY;
         _loc3_.width *= param1.scaleX;
         _loc3_.height *= param1.scaleY;
         return _loc3_;
      }
   }
}

