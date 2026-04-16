package uiwidgets
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.Point;
   import util.DragClient;
   
   public class ResizeableFrame extends Sprite implements DragClient
   {
      
      public var w:int;
      
      public var h:int;
      
      public var minWidth:int = 20;
      
      public var minHeight:int = 20;
      
      private var borderColor:int;
      
      private var borderWidth:int;
      
      private var fillColor:int;
      
      private var cornerRadius:int;
      
      private var box:Shape;
      
      private var outline:Shape;
      
      private var resizer:Shape;
      
      public function ResizeableFrame(param1:int, param2:int, param3:int = 8, param4:Boolean = false, param5:int = 1)
      {
         super();
         this.borderColor = param1;
         this.borderWidth = param5;
         this.fillColor = param2;
         this.cornerRadius = param3;
         this.box = new Shape();
         addChild(this.box);
         if(param4)
         {
            this.box.filters = [this.insetBevelFilter()];
         }
         this.outline = new Shape();
         addChild(this.outline);
         this.setWidthHeight(80,60);
      }
      
      public function getColor() : int
      {
         return this.fillColor;
      }
      
      public function setColor(param1:int) : void
      {
         this.fillColor = param1;
         this.setWidthHeight(this.w,this.h);
      }
      
      public function showResizer() : void
      {
         if(this.resizer)
         {
            return;
         }
         this.resizer = new Shape();
         var _loc1_:Graphics = this.resizer.graphics;
         _loc1_.lineStyle(1,6316128);
         _loc1_.moveTo(0,10);
         _loc1_.lineTo(10,0);
         _loc1_.moveTo(4,10);
         _loc1_.lineTo(10,4);
         addChild(this.resizer);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
      }
      
      public function hideResizer() : void
      {
         if(this.resizer)
         {
            this.resizer.parent.removeChild(this.resizer);
            this.resizer = null;
         }
         removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.w = param1;
         this.h = param2;
         var _loc3_:Graphics = this.box.graphics;
         _loc3_.clear();
         _loc3_.beginFill(this.fillColor);
         _loc3_.drawRoundRect(0,0,param1,param2,this.cornerRadius,this.cornerRadius);
         _loc3_ = this.outline.graphics;
         _loc3_.clear();
         _loc3_.lineStyle(this.borderWidth,this.borderColor,1,true);
         _loc3_.drawRoundRect(0,0,param1,param2,this.cornerRadius,this.cornerRadius);
         if(this.resizer)
         {
            this.resizer.x = param1 - this.resizer.width;
            this.resizer.y = param2 - this.resizer.height;
         }
      }
      
      private function insetBevelFilter() : BitmapFilter
      {
         var _loc1_:BevelFilter = new BevelFilter(2);
         _loc1_.angle = 225;
         _loc1_.blurX = _loc1_.blurY = 3;
         _loc1_.highlightAlpha = 0.5;
         _loc1_.shadowAlpha = 0.5;
         return _loc1_;
      }
      
      public function mouseDown(param1:MouseEvent) : void
      {
         if(root is Scratch && !(root as Scratch).editMode)
         {
            return;
         }
         if(Boolean(this.resizer) && this.resizer.hitTestPoint(param1.stageX,param1.stageY))
         {
            Scratch(root).gh.setDragClient(this,param1);
         }
      }
      
      public function dragBegin(param1:MouseEvent) : void
      {
      }
      
      public function dragEnd(param1:MouseEvent) : void
      {
      }
      
      public function dragMove(param1:MouseEvent) : void
      {
         var _loc2_:Point = this.globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:int = Math.max(this.minWidth,_loc2_.x + 3);
         var _loc4_:int = Math.max(this.minHeight,_loc2_.y + 3);
         this.setWidthHeight(_loc3_,_loc4_);
         if(Boolean(parent) && "fixLayout" in parent)
         {
            (parent as Object).fixLayout();
         }
      }
   }
}

