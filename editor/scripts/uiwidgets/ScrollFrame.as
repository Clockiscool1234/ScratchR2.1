package uiwidgets
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import util.DragClient;
   
   public class ScrollFrame extends Sprite implements DragClient
   {
      
      public var contents:ScrollFrameContents;
      
      public var allowHorizontalScrollbar:Boolean = true;
      
      public var allowVerticalScrollbar:Boolean = true;
      
      private const decayFactor:Number = 0.95;
      
      private const stopThreshold:Number = 0.4;
      
      private const cornerRadius:int = 0;
      
      private const useFrame:Boolean = false;
      
      private var scrollbarThickness:int = 9;
      
      private var shadowFrame:Shape;
      
      private var hScrollbar:Scrollbar;
      
      private var vScrollbar:Scrollbar;
      
      private var dragScrolling:Boolean;
      
      private var xOffset:int;
      
      private var yOffset:int;
      
      private var xHistory:Array;
      
      private var yHistory:Array;
      
      private var xVelocity:Number = 0;
      
      private var yVelocity:Number = 0;
      
      private var scrollWheelHorizontal:Boolean;
      
      public function ScrollFrame(param1:Boolean = false)
      {
         super();
         this.dragScrolling = param1;
         if(param1)
         {
            this.scrollbarThickness = 3;
         }
         mask = new Shape();
         addChild(mask);
         if(this.useFrame)
         {
            this.addShadowFrame();
         }
         this.setWidthHeight(100,100);
         this.setContents(new ScrollFrameContents());
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.enableScrollWheel("vertical");
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.drawShape(Shape(mask).graphics,param1,param2);
         if(this.shadowFrame)
         {
            this.drawShape(this.shadowFrame.graphics,param1,param2);
         }
         if(this.contents)
         {
            this.contents.updateSize();
         }
         this.fixLayout();
      }
      
      private function drawShape(param1:Graphics, param2:int, param3:int) : void
      {
         param1.clear();
         param1.beginFill(65280,1);
         param1.drawRect(0,0,param2,param3);
         param1.endFill();
      }
      
      private function addShadowFrame() : void
      {
         this.shadowFrame = new Shape();
         addChild(this.shadowFrame);
         var _loc1_:GlowFilter = new GlowFilter(986895);
         _loc1_.blurX = _loc1_.blurY = 5;
         _loc1_.alpha = 0.2;
         _loc1_.inner = true;
         _loc1_.knockout = true;
         this.shadowFrame.filters = [_loc1_];
      }
      
      public function setContents(param1:Sprite) : void
      {
         if(this.contents)
         {
            this.removeChild(this.contents);
         }
         this.contents = param1 as ScrollFrameContents;
         this.contents.x = this.contents.y = 0;
         addChildAt(this.contents,1);
         this.contents.updateSize();
         this.updateScrollbars();
      }
      
      public function enableScrollWheel(param1:String) : void
      {
         removeEventListener(MouseEvent.MOUSE_WHEEL,this.handleScrollWheel);
         if("horizontal" == param1 || "vertical" == param1)
         {
            addEventListener(MouseEvent.MOUSE_WHEEL,this.handleScrollWheel);
            this.scrollWheelHorizontal = "horizontal" == param1;
         }
      }
      
      private function handleScrollWheel(param1:MouseEvent) : void
      {
         var _loc2_:int = 10 * param1.delta;
         if(this.scrollWheelHorizontal != param1.shiftKey)
         {
            this.contents.x = Math.min(0,Math.max(this.contents.x + _loc2_,-this.maxScrollH()));
         }
         else
         {
            this.contents.y = Math.min(0,Math.max(this.contents.y + _loc2_,-this.maxScrollV()));
         }
         this.updateScrollbars();
      }
      
      public function showHScrollbar(param1:Boolean) : void
      {
         if(this.hScrollbar)
         {
            removeChild(this.hScrollbar);
            this.hScrollbar = null;
         }
         if(param1)
         {
            this.hScrollbar = new Scrollbar(50,this.scrollbarThickness,this.setHScroll);
            addChild(this.hScrollbar);
         }
         addChildAt(this.contents,1);
         this.fixLayout();
      }
      
      public function showVScrollbar(param1:Boolean) : void
      {
         if(this.vScrollbar)
         {
            removeChild(this.vScrollbar);
            this.vScrollbar = null;
         }
         if(param1)
         {
            this.vScrollbar = new Scrollbar(this.scrollbarThickness,50,this.setVScroll);
            addChild(this.vScrollbar);
         }
         addChildAt(this.contents,1);
         this.fixLayout();
      }
      
      public function visibleW() : int
      {
         return mask.width;
      }
      
      public function visibleH() : int
      {
         return mask.height;
      }
      
      public function updateScrollbars() : void
      {
         if(this.hScrollbar)
         {
            this.hScrollbar.update(-this.contents.x / this.maxScrollH(),this.visibleW() / this.contents.width);
         }
         if(this.vScrollbar)
         {
            this.vScrollbar.update(-this.contents.y / this.maxScrollV(),this.visibleH() / this.contents.height);
         }
      }
      
      public function updateScrollbarVisibility() : void
      {
         var _loc1_:Boolean = false;
         var _loc2_:Boolean = false;
         if(this.dragScrolling)
         {
            return;
         }
         _loc1_ = this.visibleW() < this.contents.width && this.allowHorizontalScrollbar;
         _loc2_ = this.hScrollbar != null;
         if(_loc1_ != _loc2_)
         {
            this.showHScrollbar(_loc1_);
         }
         _loc1_ = this.visibleH() < this.contents.height && this.allowVerticalScrollbar;
         _loc2_ = this.vScrollbar != null;
         if(_loc1_ != _loc2_)
         {
            this.showVScrollbar(_loc1_);
         }
         this.updateScrollbars();
      }
      
      private function setHScroll(param1:Number) : void
      {
         this.contents.x = -param1 * this.maxScrollH();
         this.xVelocity = this.yVelocity = 0;
      }
      
      private function setVScroll(param1:Number) : void
      {
         this.contents.y = -param1 * this.maxScrollV();
         this.xVelocity = this.yVelocity = 0;
      }
      
      public function maxScrollH() : int
      {
         return Math.max(0,this.contents.width - this.visibleW());
      }
      
      public function maxScrollV() : int
      {
         return Math.max(0,this.contents.height - this.visibleH());
      }
      
      public function canScrollLeft() : Boolean
      {
         return this.contents.x < 0;
      }
      
      public function canScrollRight() : Boolean
      {
         return this.contents.x > -this.maxScrollH();
      }
      
      public function canScrollUp() : Boolean
      {
         return this.contents.y < 0;
      }
      
      public function canScrollDown() : Boolean
      {
         return this.contents.y > -this.maxScrollV();
      }
      
      private function fixLayout() : void
      {
         var _loc1_:int = 2;
         if(this.hScrollbar)
         {
            this.hScrollbar.setWidthHeight(mask.width - 14,this.hScrollbar.h);
            this.hScrollbar.x = _loc1_;
            this.hScrollbar.y = mask.height - this.hScrollbar.h - _loc1_;
         }
         if(this.vScrollbar)
         {
            this.vScrollbar.setWidthHeight(this.vScrollbar.w,mask.height - 2 * _loc1_);
            this.vScrollbar.x = mask.width - this.vScrollbar.w - _loc1_;
            this.vScrollbar.y = _loc1_;
         }
         this.updateScrollbars();
      }
      
      public function constrainScroll() : void
      {
         this.contents.x = Math.max(-this.maxScrollH(),Math.min(this.contents.x,0));
         this.contents.y = Math.max(-this.maxScrollV(),Math.min(this.contents.y,0));
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         if(param1.shiftKey || !this.dragScrolling)
         {
            return;
         }
         if(param1.target == this.contents)
         {
            Object(root).gh.setDragClient(this,param1);
            this.contents.mouseChildren = false;
         }
      }
      
      public function dragBegin(param1:MouseEvent) : void
      {
         this.xHistory = [mouseX,mouseX,mouseX];
         this.yHistory = [mouseY,mouseY,mouseY];
         this.xOffset = mouseX - this.contents.x;
         this.yOffset = mouseY - this.contents.y;
         if(this.visibleW() < this.contents.width)
         {
            this.showHScrollbar(true);
         }
         if(this.visibleH() < this.contents.height)
         {
            this.showVScrollbar(true);
         }
         if(this.hScrollbar)
         {
            this.hScrollbar.allowDragging(false);
         }
         if(this.vScrollbar)
         {
            this.vScrollbar.allowDragging(false);
         }
         this.updateScrollbars();
         removeEventListener(Event.ENTER_FRAME,this.step);
      }
      
      public function dragMove(param1:MouseEvent) : void
      {
         this.xHistory.push(mouseX);
         this.yHistory.push(mouseY);
         this.xHistory.shift();
         this.yHistory.shift();
         this.contents.x = mouseX - this.xOffset;
         this.contents.y = mouseY - this.yOffset;
         this.constrainScroll();
         this.updateScrollbars();
      }
      
      public function dragEnd(param1:MouseEvent) : void
      {
         this.xVelocity = (this.xHistory[2] - this.xHistory[0]) / 1.5;
         this.yVelocity = (this.yHistory[2] - this.yHistory[0]) / 1.5;
         if(Math.abs(this.xVelocity) < 2 && Math.abs(this.yVelocity) < 2)
         {
            this.xVelocity = this.yVelocity = 0;
         }
         addEventListener(Event.ENTER_FRAME,this.step);
      }
      
      private function step(param1:Event) : void
      {
         this.xVelocity = this.decayFactor * this.xVelocity;
         this.yVelocity = this.decayFactor * this.yVelocity;
         if(Math.abs(this.xVelocity) < this.stopThreshold)
         {
            this.xVelocity = 0;
         }
         if(Math.abs(this.yVelocity) < this.stopThreshold)
         {
            this.yVelocity = 0;
         }
         this.contents.x += this.xVelocity;
         this.contents.y += this.yVelocity;
         this.contents.x = Math.max(-this.maxScrollH(),Math.min(this.contents.x,0));
         this.contents.y = Math.max(-this.maxScrollV(),Math.min(this.contents.y,0));
         if(this.contents.x > -1 || this.contents.x - 1 < -this.maxScrollH())
         {
            this.xVelocity = 0;
         }
         if(this.contents.y > -1 || this.contents.y - 1 < -this.maxScrollV())
         {
            this.yVelocity = 0;
         }
         this.constrainScroll();
         this.updateScrollbars();
         if(this.xVelocity == 0 && this.yVelocity == 0)
         {
            if(this.hScrollbar)
            {
               this.hScrollbar.allowDragging(true);
            }
            if(this.vScrollbar)
            {
               this.vScrollbar.allowDragging(true);
            }
            this.showHScrollbar(false);
            this.showVScrollbar(false);
            this.contents.mouseChildren = true;
            removeEventListener(Event.ENTER_FRAME,this.step);
         }
      }
   }
}

