package svgeditor.tools
{
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import svgeditor.ImageCanvas;
   import svgeditor.ImageEdit;
   
   public final class SetCenterTool extends SVGTool
   {
      
      private var canvasCenter:Point;
      
      private var localRect:Rectangle;
      
      private var active:Boolean;
      
      public function SetCenterTool(param1:ImageEdit)
      {
         super(param1);
         cursorBMName = "setCenterOff";
         cursorHotSpot = new Point(8,8);
         this.active = false;
      }
      
      override protected function init() : void
      {
         super.init();
         editor.getToolsLayer().mouseEnabled = false;
         editor.getToolsLayer().mouseChildren = false;
         editor.getWorkArea().addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
         this.refresh();
      }
      
      override protected function shutdown() : void
      {
         editor.getToolsLayer().mouseEnabled = true;
         editor.getToolsLayer().mouseChildren = true;
         editor.getWorkArea().removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         editor.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         editor.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         super.shutdown();
      }
      
      override public function refresh() : void
      {
         var _loc3_:Point = null;
         var _loc1_:ImageCanvas = editor.getWorkArea();
         var _loc2_:Rectangle = _loc1_.getVisibleLayer().getRect(_loc1_.getVisibleLayer());
         this.canvasCenter = new Point(Math.round((_loc2_.right - _loc2_.left) / 2),Math.round((_loc2_.bottom - _loc2_.top) / 2));
         this.localRect = _loc1_.getVisibleLayer().getRect(this);
         if(!this.active)
         {
            _loc3_ = globalToLocal(_loc1_.getVisibleLayer().localToGlobal(this.canvasCenter));
            graphics.clear();
            if(this.localRect.containsPoint(_loc3_))
            {
               graphics.lineStyle(2);
               graphics.moveTo(this.localRect.left,_loc3_.y);
               graphics.lineTo(this.localRect.right,_loc3_.y);
               graphics.moveTo(_loc3_.x,this.localRect.top);
               graphics.lineTo(_loc3_.x,this.localRect.bottom);
            }
         }
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         editor.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove,false,0,true);
         editor.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp,false,0,true);
         this.mouseMove();
         this.active = true;
      }
      
      private function mouseMove(param1:MouseEvent = null) : void
      {
         graphics.clear();
         graphics.lineStyle(2);
         graphics.moveTo(this.localRect.left,mouseY);
         graphics.lineTo(this.localRect.right,mouseY);
         graphics.moveTo(mouseX,this.localRect.top);
         graphics.lineTo(mouseX,this.localRect.bottom);
      }
      
      private function mouseUp(param1:MouseEvent) : void
      {
         var _loc2_:ImageCanvas = editor.getWorkArea();
         var _loc3_:Number = ImageCanvas.canvasWidth / 2 - _loc2_.getVisibleLayer().mouseX;
         var _loc4_:Number = ImageCanvas.canvasHeight / 2 - _loc2_.getVisibleLayer().mouseY;
         editor.translateContents(_loc3_,_loc4_);
         editor.endCurrentTool();
      }
   }
}

