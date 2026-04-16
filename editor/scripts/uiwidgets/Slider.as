package uiwidgets
{
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import util.DragClient;
   
   public class Slider extends Sprite implements DragClient
   {
      
      public var slotColor:int = 12303807;
      
      public var slotColor2:int = -1;
      
      private var slot:Shape;
      
      private var knob:Shape;
      
      private var positionFraction:Number = 0;
      
      private var isVertical:Boolean;
      
      private var isTriangle:Boolean;
      
      private var dragOffset:int;
      
      private var scrollFunction:Function;
      
      private var minValue:Number;
      
      private var maxValue:Number;
      
      public function Slider(param1:int, param2:int, param3:Function = null, param4:Boolean = false)
      {
         super();
         this.scrollFunction = param3;
         this.isTriangle = param4;
         this.minValue = 0;
         this.maxValue = 1;
         addChild(this.slot = new Shape());
         addChild(this.knob = new Shape());
         this.setWidthHeight(param1,param2);
         this.moveKnob();
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
      }
      
      public function get min() : Number
      {
         return this.minValue;
      }
      
      public function set min(param1:Number) : void
      {
         this.minValue = param1;
      }
      
      public function get max() : Number
      {
         return this.maxValue;
      }
      
      public function set max(param1:Number) : void
      {
         this.maxValue = param1;
      }
      
      public function get value() : Number
      {
         return this.positionFraction * (this.maxValue - this.minValue) + this.minValue;
      }
      
      public function set value(param1:Number) : void
      {
         var _loc2_:Number = Math.max(0,Math.min((param1 - this.minValue) / (this.maxValue - this.minValue),1));
         if(_loc2_ != this.positionFraction)
         {
            this.positionFraction = _loc2_;
            this.moveKnob();
         }
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.isVertical = param2 > param1;
         this.drawSlot(param1,param2);
         this.drawKnob(param1,param2);
      }
      
      private function drawSlot(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Matrix = null;
         var _loc3_:Graphics = this.slot.graphics;
         if(this.isTriangle)
         {
            _loc3_.beginFill(this.slotColor,1);
            _loc3_.moveTo(0,param2 / 2 + 0.5);
            _loc3_.lineTo(param1,param2);
            _loc3_.lineTo(param1,0);
            _loc3_.lineTo(0,param2 / 2 - 0.5);
            _loc3_.endFill();
         }
         else
         {
            _loc4_ = 9;
            _loc3_.clear();
            if(this.slotColor2 >= 0)
            {
               _loc5_ = new Matrix();
               _loc5_.createGradientBox(param1,param2,this.isVertical ? -Math.PI / 2 : Math.PI,0,0);
               _loc3_.beginGradientFill(GradientType.LINEAR,[this.slotColor,this.slotColor2],[1,1],[0,255],_loc5_);
            }
            else
            {
               _loc3_.beginFill(this.slotColor);
            }
            _loc3_.drawRoundRect(0,0,param1,param2,_loc4_,_loc4_);
            _loc3_.endFill();
         }
      }
      
      private function drawKnob(param1:int, param2:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:int = 7368816;
         var _loc4_:int = 15461355;
         var _loc5_:int = 6;
         var _loc8_:int = 0.5;
         if(this.isTriangle)
         {
            _loc6_ = this.isVertical ? int(param1 + 3) : 7;
            _loc7_ = this.isVertical ? 7 : int(param2 + 3);
            _loc8_ += 2;
         }
         else
         {
            _loc6_ = this.isVertical ? int(param1 + 7) : 7;
            _loc7_ = this.isVertical ? 7 : int(param2 + 7);
         }
         var _loc9_:Graphics = this.knob.graphics;
         _loc9_.clear();
         _loc9_.lineStyle(1,_loc3_);
         _loc9_.beginFill(_loc4_);
         _loc9_.drawRoundRect(_loc8_,_loc8_,_loc6_,_loc7_,_loc5_,_loc5_);
         _loc9_.endFill();
      }
      
      private function moveKnob() : void
      {
         if(this.isVertical)
         {
            this.knob.x = -4;
            this.knob.y = Math.round((1 - this.positionFraction) * (this.slot.height - this.knob.height));
         }
         else
         {
            this.knob.x = Math.round(this.positionFraction * (this.slot.width - this.knob.width));
            this.knob.y = -4;
         }
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         Scratch.app.gh.setDragClient(this,param1);
      }
      
      public function dragBegin(param1:MouseEvent) : void
      {
         var _loc2_:Point = this.knob.localToGlobal(new Point(0,0));
         if(this.isVertical)
         {
            this.dragOffset = param1.stageY - _loc2_.y;
            this.dragOffset = Math.max(5,Math.min(this.dragOffset,this.knob.height - 5));
         }
         else
         {
            this.dragOffset = param1.stageX - _loc2_.x;
            this.dragOffset = Math.max(5,Math.min(this.dragOffset,this.knob.width - 5));
         }
         this.dragMove(param1);
      }
      
      public function dragMove(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         var _loc4_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         if(this.isVertical)
         {
            _loc2_ = this.slot.height - this.knob.height;
            this.positionFraction = 1 - (_loc4_.y - this.dragOffset) / _loc2_;
         }
         else
         {
            _loc2_ = this.slot.width - this.knob.width;
            this.positionFraction = (_loc4_.x - this.dragOffset) / _loc2_;
         }
         this.positionFraction = Math.max(0,Math.min(this.positionFraction,1));
         this.moveKnob();
         if(this.scrollFunction != null)
         {
            this.scrollFunction(this.value);
         }
      }
      
      public function dragEnd(param1:MouseEvent) : void
      {
         dispatchEvent(new Event(Event.COMPLETE));
      }
   }
}

