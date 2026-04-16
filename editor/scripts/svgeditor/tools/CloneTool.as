package svgeditor.tools
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import svgeditor.*;
   import svgeditor.objs.ISVGEditable;
   
   public final class CloneTool extends SVGCreateTool
   {
      
      private var copiedObjects:Array;
      
      private var previewObjects:Array;
      
      private var centerPt:Point;
      
      private var holder:Sprite;
      
      private var highlightedObj:DisplayObject;
      
      public function CloneTool(param1:ImageEdit, param2:Selection = null)
      {
         super(param1,false);
         this.holder = new Sprite();
         addChild(this.holder);
         cursorBMName = "cloneOff";
         cursorHotSpot = new Point(12,21);
         this.copiedObjects = null;
         this.previewObjects = null;
      }
      
      public function pasteFromClipboard(param1:Array) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Selection = null;
         for each(_loc2_ in param1)
         {
            contentLayer.addChild(_loc2_);
         }
         _loc3_ = new Selection(param1);
         this.previewObjects = _loc3_.cloneObjs(contentLayer);
         this.copiedObjects = _loc3_.cloneObjs(contentLayer);
         _loc3_.shutdown();
         for each(_loc2_ in param1)
         {
            contentLayer.removeChild(_loc2_);
         }
         this.createPreview();
      }
      
      private function makeCopies(param1:Selection) : void
      {
         this.copiedObjects = param1.cloneObjs(contentLayer);
         this.previewObjects = param1.cloneObjs(contentLayer);
      }
      
      override protected function init() : void
      {
         super.init();
         editor.getToolsLayer().mouseEnabled = false;
         editor.getToolsLayer().mouseChildren = false;
      }
      
      override protected function shutdown() : void
      {
         editor.getToolsLayer().mouseEnabled = true;
         editor.getToolsLayer().mouseChildren = true;
         super.shutdown();
         this.clearCurrentClone();
      }
      
      private function clearCurrentClone() : void
      {
         while(this.holder.numChildren)
         {
            this.holder.removeChildAt(0);
         }
         this.copiedObjects = null;
         this.previewObjects = null;
      }
      
      override protected function mouseMove(param1:Point) : void
      {
         if(this.copiedObjects)
         {
            this.centerPreview();
         }
         else
         {
            this.checkUnderMouse();
         }
      }
      
      override protected function mouseDown(param1:Point) : void
      {
         var _loc2_:ISVGEditable = null;
         if(this.copiedObjects == null)
         {
            _loc2_ = getEditableUnderMouse();
            if(_loc2_)
            {
               this.makeCopies(new Selection([_loc2_]));
               this.createPreview();
               this.checkUnderMouse(true);
            }
            return;
         }
      }
      
      override protected function mouseUp(param1:Point) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Point = null;
         var _loc6_:DisplayObject = null;
         if(this.copiedObjects == null)
         {
            return;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < this.copiedObjects.length)
         {
            _loc4_ = this.previewObjects[_loc2_] as DisplayObject;
            _loc5_ = new Point(_loc4_.x,_loc4_.y);
            _loc5_ = this.holder.localToGlobal(_loc5_);
            _loc5_ = contentLayer.globalToLocal(_loc5_);
            _loc6_ = this.copiedObjects[_loc2_] as DisplayObject;
            contentLayer.addChild(_loc6_);
            _loc6_.x = _loc5_.x;
            _loc6_.y = _loc5_.y;
            _loc2_++;
         }
         var _loc3_:Selection = new Selection(this.copiedObjects);
         if(currentEvent.shiftKey)
         {
            this.copiedObjects = _loc3_.cloneObjs(contentLayer);
            _loc3_.shutdown();
         }
         else
         {
            editor.endCurrentTool(_loc3_);
         }
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function createPreview() : void
      {
         var _loc4_:DisplayObject = null;
         x = y = 0;
         var _loc1_:Matrix = editor.getContentLayer().transform.concatenatedMatrix;
         this.holder.scaleX = _loc1_.deltaTransformPoint(new Point(0,1)).length;
         this.holder.scaleY = _loc1_.deltaTransformPoint(new Point(1,0)).length;
         var _loc2_:uint = 0;
         while(_loc2_ < this.copiedObjects.length)
         {
            _loc4_ = this.previewObjects[_loc2_] as DisplayObject;
            this.holder.addChild(_loc4_);
            _loc2_++;
         }
         var _loc3_:Rectangle = getBounds(this);
         this.centerPt = new Point((_loc3_.right + _loc3_.left) / 2,(_loc3_.bottom + _loc3_.top) / 2);
         this.centerPreview();
         alpha = 0.5;
      }
      
      private function centerPreview() : void
      {
         x += mouseX - this.centerPt.x;
         y += mouseY - this.centerPt.y;
      }
      
      private function checkUnderMouse(param1:Boolean = false) : void
      {
         var _loc2_:ISVGEditable = param1 ? null : getEditableUnderMouse();
         if(_loc2_ != this.highlightedObj)
         {
            if(this.highlightedObj)
            {
               this.highlightedObj.filters = [];
            }
            this.highlightedObj = _loc2_ as DisplayObject;
            if(this.highlightedObj)
            {
               this.highlightedObj.filters = [new GlowFilter(2663898)];
            }
         }
      }
   }
}

