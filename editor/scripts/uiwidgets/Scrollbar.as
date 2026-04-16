package uiwidgets
{
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.BevelFilter;
   import flash.geom.Point;
   import util.DragClient;
   
   public class Scrollbar extends Sprite implements DragClient
   {
      
      public static var color:int = 13356495;
      
      public static var sliderColor:int = 4342855;
      
      public static var cornerRadius:int = 9;
      
      public static var look3D:Boolean = false;
      
      public var w:int;
      
      public var h:int;
      
      private var base:Shape;
      
      private var slider:Shape;
      
      private var positionFraction:Number = 0;
      
      private var sliderSizeFraction:Number = 0.1;
      
      private var isVertical:Boolean;
      
      private var dragOffset:int;
      
      private var scrollFunction:Function;
      
      public function Scrollbar(param1:int, param2:int, param3:Function = null)
      {
         super();
         this.scrollFunction = param3;
         this.base = new Shape();
         this.slider = new Shape();
         addChild(this.base);
         addChild(this.slider);
         if(look3D)
         {
            this.addFilters();
         }
         alpha = 0.7;
         this.setWidthHeight(param1,param2);
         this.allowDragging(true);
      }
      
      public function scrollValue() : Number
      {
         return this.positionFraction;
      }
      
      public function sliderSize() : Number
      {
         return this.sliderSizeFraction;
      }
      
      public function update(param1:Number, param2:Number = 0) : Boolean
      {
         var _loc3_:Number = Math.max(0,Math.min(param1,1));
         var _loc4_:Number = Math.max(0,Math.min(param2,1));
         if(_loc3_ != this.positionFraction || _loc4_ != this.sliderSizeFraction)
         {
            this.positionFraction = _loc3_;
            this.sliderSizeFraction = _loc4_;
            this.drawSlider();
            this.slider.visible = _loc4_ < 0.99;
         }
         return this.slider.visible;
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.w = param1;
         this.h = param2;
         this.base.graphics.clear();
         this.base.graphics.beginFill(color);
         this.base.graphics.drawRoundRect(0,0,param1,param2,cornerRadius,cornerRadius);
         this.base.graphics.endFill();
         this.drawSlider();
      }
      
      private function drawSlider() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         this.isVertical = this.base.height > this.base.width;
         if(this.isVertical)
         {
            _loc3_ = this.base.height;
            _loc1_ = this.base.width;
            _loc2_ = Math.max(10,Math.min(this.sliderSizeFraction * _loc3_,_loc3_));
            this.slider.x = 0;
            this.slider.y = this.positionFraction * (this.height - _loc2_);
         }
         else
         {
            _loc3_ = this.base.width;
            _loc1_ = Math.max(10,Math.min(this.sliderSizeFraction * _loc3_,_loc3_));
            _loc2_ = this.base.height;
            this.slider.x = this.positionFraction * (this.width - _loc1_);
            this.slider.y = 0;
         }
         this.slider.graphics.clear();
         this.slider.graphics.beginFill(sliderColor);
         this.slider.graphics.drawRoundRect(0,0,_loc1_,_loc2_,cornerRadius,cornerRadius);
         this.slider.graphics.endFill();
      }
      
      private function addFilters() : void
      {
         var _loc1_:BevelFilter = new BevelFilter();
         _loc1_.distance = 1;
         _loc1_.blurX = _loc1_.blurY = 2;
         _loc1_.highlightAlpha = 0.5;
         _loc1_.shadowAlpha = 0.5;
         _loc1_.angle = 225;
         this.base.filters = [_loc1_];
         _loc1_ = new BevelFilter();
         _loc1_.distance = 2;
         _loc1_.blurX = _loc1_.blurY = 4;
         _loc1_.highlightAlpha = 1;
         _loc1_.shadowAlpha = 0.5;
         this.slider.filters = [_loc1_];
      }
      
      public function allowDragging(param1:Boolean) : void
      {
         if(param1)
         {
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         }
         else
         {
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         }
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         Scratch.app.gh.setDragClient(this,param1);
      }
      
      public function dragBegin(param1:MouseEvent) : void
      {
         var _loc2_:Point = this.slider.localToGlobal(new Point(0,0));
         if(this.isVertical)
         {
            this.dragOffset = param1.stageY - _loc2_.y;
            this.dragOffset = Math.max(5,Math.min(this.dragOffset,this.slider.height - 5));
         }
         else
         {
            this.dragOffset = param1.stageX - _loc2_.x;
            this.dragOffset = Math.max(5,Math.min(this.dragOffset,this.slider.width - 5));
         }
         dispatchEvent(new Event(Event.SCROLL));
         this.dragMove(param1);
      }
      
      public function dragMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         if(this.isVertical)
         {
            _loc2_ = this.base.height - this.slider.height;
            this.positionFraction = (_loc4_.y - this.dragOffset) / _loc2_;
         }
         else
         {
            _loc2_ = this.base.width - this.slider.width;
            this.positionFraction = (_loc4_.x - this.dragOffset) / _loc2_;
         }
         this.positionFraction = Math.max(0,Math.min(this.positionFraction,1));
         this.drawSlider();
         if(this.scrollFunction != null)
         {
            this.scrollFunction(this.positionFraction);
         }
      }
      
      public function dragEnd(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

