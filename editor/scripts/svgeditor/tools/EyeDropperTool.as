package svgeditor.tools
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import svgeditor.BitmapEdit;
   import svgeditor.ImageEdit;
   import svgeditor.objs.ISVGEditable;
   
   public final class EyeDropperTool extends SVGTool
   {
      
      public function EyeDropperTool(param1:ImageEdit)
      {
         super(param1);
         touchesContent = true;
         cursorBMName = "eyedropperOff";
         cursorHotSpot = new Point(14,20);
      }
      
      override protected function init() : void
      {
         super.init();
         editor.getWorkArea().addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
      }
      
      override protected function shutdown() : void
      {
         editor.getWorkArea().removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.mouseUp();
         super.shutdown();
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         currentEvent = param1;
         this.grabColor();
         STAGE.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove,false,0,true);
         STAGE.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp,false,0,true);
         param1.stopPropagation();
      }
      
      private function mouseMove(param1:MouseEvent) : void
      {
         currentEvent = param1;
         this.grabColor();
      }
      
      private function mouseUp(param1:MouseEvent = null) : void
      {
         STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         STAGE.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
      }
      
      private function grabColor() : void
      {
         var _loc1_:uint = 0;
         var _loc2_:ISVGEditable = null;
         var _loc3_:Bitmap = null;
         var _loc4_:Point = null;
         var _loc5_:DisplayObject = null;
         var _loc6_:BitmapData = null;
         var _loc7_:Matrix = null;
         if(editor is BitmapEdit)
         {
            _loc3_ = editor.getWorkArea().getBitmap();
            _loc4_ = editor.getWorkArea().bitmapMousePoint();
            _loc1_ = _loc3_.bitmapData.getPixel32(_loc4_.x,_loc4_.y);
         }
         else
         {
            _loc2_ = getEditableUnderMouse(false);
            if(_loc2_ != null)
            {
               _loc5_ = _loc2_ as DisplayObject;
               _loc6_ = new BitmapData(1,1,true,0);
               _loc7_ = new Matrix();
               _loc7_.translate(-_loc5_.mouseX,-_loc5_.mouseY);
               _loc6_.draw(_loc5_,_loc7_);
               _loc1_ = _loc6_.getPixel32(0,0);
            }
         }
         if(_loc1_ & 0xFF000000)
         {
            editor.setCurrentColor(_loc1_ & 0xFFFFFF,1);
         }
      }
   }
}

