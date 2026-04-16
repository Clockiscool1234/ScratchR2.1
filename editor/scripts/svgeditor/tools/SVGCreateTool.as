package svgeditor.tools
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import svgeditor.ImageCanvas;
   import svgeditor.ImageEdit;
   import svgeditor.objs.ISVGEditable;
   
   public class SVGCreateTool extends SVGTool
   {
      
      protected var newObject:ISVGEditable;
      
      protected var contentLayer:Sprite;
      
      protected var isQuick:Boolean;
      
      private var lastPos:Point;
      
      public function SVGCreateTool(param1:ImageEdit, param2:Boolean = true)
      {
         super(param1);
         this.contentLayer = editor.getContentLayer();
         this.isQuick = param2;
      }
      
      protected function mouseDown(param1:Point) : void
      {
      }
      
      protected function mouseMove(param1:Point) : void
      {
      }
      
      protected function mouseUp(param1:Point) : void
      {
      }
      
      public function getObject() : ISVGEditable
      {
         return this.newObject;
      }
      
      override protected function init() : void
      {
         super.init();
         this.addEventHandlers();
      }
      
      override protected function shutdown() : void
      {
         this.removeEventHandlers();
         super.shutdown();
         this.newObject = null;
         this.contentLayer = null;
      }
      
      override public function cancel() : void
      {
         var _loc1_:DisplayObject = null;
         if(Boolean(this.newObject) && this.newObject is DisplayObject)
         {
            _loc1_ = this.newObject as DisplayObject;
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
            this.newObject = null;
         }
         super.cancel();
      }
      
      public function eventHandler(param1:MouseEvent = null) : void
      {
         var _loc2_:Point = null;
         if(!this.contentLayer)
         {
            return;
         }
         _loc2_ = new Point(this.contentLayer.mouseX,this.contentLayer.mouseY);
         _loc2_.x = Math.min(ImageCanvas.canvasWidth,Math.max(0,_loc2_.x));
         _loc2_.y = Math.min(ImageCanvas.canvasHeight,Math.max(0,_loc2_.y));
         currentEvent = param1;
         if(param1.type == MouseEvent.MOUSE_DOWN)
         {
            this.mouseDown(_loc2_);
            if(this.isQuick && !isShuttingDown)
            {
               STAGE.addEventListener(MouseEvent.MOUSE_MOVE,this.eventHandler,false,0,true);
               STAGE.addEventListener(MouseEvent.MOUSE_UP,this.eventHandler,false,0,true);
            }
            this.lastPos = _loc2_;
         }
         else if(param1.type == MouseEvent.MOUSE_MOVE)
         {
            this.mouseMove(_loc2_);
            this.lastPos = _loc2_;
         }
         else if(param1.type == MouseEvent.MOUSE_UP)
         {
            if(!stage)
            {
               return;
            }
            if(!editor.getCanvasLayer().hitTestPoint(STAGE.mouseX,STAGE.mouseY,true))
            {
               _loc2_ = this.lastPos;
            }
            this.mouseUp(_loc2_);
            if(this.isQuick)
            {
               editor.endCurrentTool(this.newObject);
            }
         }
      }
      
      private function addEventHandlers() : void
      {
         editor.getCanvasLayer().addEventListener(MouseEvent.MOUSE_DOWN,this.eventHandler,false,0,true);
         if(!this.isQuick)
         {
            STAGE.addEventListener(MouseEvent.MOUSE_MOVE,this.eventHandler,false,0,true);
            STAGE.addEventListener(MouseEvent.MOUSE_UP,this.eventHandler,false,0,true);
         }
      }
      
      private function removeEventHandlers() : void
      {
         editor.getCanvasLayer().removeEventListener(MouseEvent.MOUSE_DOWN,this.eventHandler);
         STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,this.eventHandler);
         STAGE.removeEventListener(MouseEvent.MOUSE_UP,this.eventHandler);
      }
   }
}

