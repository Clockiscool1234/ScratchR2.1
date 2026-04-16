package svgeditor.objs
{
   import flash.display.BitmapData;
   import flash.geom.Rectangle;
   import svgeditor.BitmapEdit;
   
   public class SegmentationState
   {
      
      public var scribbleBitmap:BitmapData;
      
      public var unmarkedBitmap:BitmapData;
      
      public var costumeRect:Rectangle;
      
      public var lastMask:BitmapData;
      
      public var next:SegmentationState = null;
      
      public var prev:SegmentationState = null;
      
      public var xMin:int;
      
      public var yMin:int;
      
      public var xMax:int;
      
      public var yMax:int;
      
      public function SegmentationState()
      {
         super();
         this.reset();
      }
      
      public function clone() : SegmentationState
      {
         var _loc1_:SegmentationState = new SegmentationState();
         if(this.scribbleBitmap)
         {
            _loc1_.scribbleBitmap = this.scribbleBitmap.clone();
         }
         if(this.unmarkedBitmap)
         {
            _loc1_.unmarkedBitmap = this.unmarkedBitmap;
         }
         if(this.costumeRect)
         {
            _loc1_.costumeRect = this.costumeRect.clone();
         }
         if(this.lastMask)
         {
            _loc1_.lastMask = this.lastMask.clone();
         }
         _loc1_.next = this.next;
         _loc1_.prev = this.prev;
         _loc1_.xMax = this.xMax;
         _loc1_.xMin = this.xMin;
         _loc1_.yMax = this.yMax;
         _loc1_.yMin = this.yMin;
         return _loc1_;
      }
      
      public function recordForUndo() : void
      {
         this.next = this.clone();
         this.next.next = null;
         this.next.prev = this;
      }
      
      public function canUndo() : Boolean
      {
         return this.prev != null;
      }
      
      public function canRedo() : Boolean
      {
         return this.next != null;
      }
      
      public function reset() : void
      {
         this.scribbleBitmap = null;
         this.lastMask = null;
         this.next = null;
         this.xMin = -1;
         this.yMin = -1;
         this.xMax = 0;
         this.yMax = 0;
      }
      
      public function eraseUndoHistory() : void
      {
         this.prev = this.next = null;
      }
      
      public function flip(param1:Boolean) : void
      {
         this.scribbleBitmap = BitmapEdit.flipBitmap(param1,this.scribbleBitmap);
         this.lastMask = BitmapEdit.flipBitmap(param1,this.lastMask);
         this.unmarkedBitmap = BitmapEdit.flipBitmap(param1,this.unmarkedBitmap);
         this.costumeRect.x = this.unmarkedBitmap.width - this.costumeRect.x - this.costumeRect.width;
         this.costumeRect.y = this.unmarkedBitmap.height - this.costumeRect.y - this.costumeRect.height;
      }
   }
}

