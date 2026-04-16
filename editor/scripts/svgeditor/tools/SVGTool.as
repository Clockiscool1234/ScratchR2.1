package svgeditor.tools
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.Stage;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import svgeditor.ImageEdit;
   import svgeditor.objs.*;
   import svgutils.SVGPath;
   
   public class SVGTool extends Sprite
   {
      
      protected static var STAGE:Stage;
      
      protected var editor:ImageEdit;
      
      protected var isShuttingDown:Boolean;
      
      protected var currentEvent:MouseEvent;
      
      protected var cursorBMName:String;
      
      protected var cursorName:String;
      
      protected var cursorHotSpot:Point;
      
      protected var touchesContent:Boolean;
      
      public function SVGTool(param1:ImageEdit)
      {
         super();
         this.editor = param1;
         this.isShuttingDown = false;
         this.touchesContent = false;
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         addEventListener(Event.REMOVED,this.removedFromStage);
      }
      
      public static function setStage(param1:Stage) : void
      {
         STAGE = param1;
      }
      
      public static function staticGetEditableUnderMouse(param1:ImageEdit, param2:Boolean = true, param3:SVGTool = null) : ISVGEditable
      {
         var _loc5_:* = 0;
         var _loc6_:DisplayObject = null;
         var _loc7_:DisplayObject = null;
         var _loc8_:Boolean = false;
         var _loc9_:Boolean = false;
         var _loc4_:Array = STAGE.getObjectsUnderPoint(new Point(STAGE.mouseX,STAGE.mouseY));
         if(_loc4_.length)
         {
            _loc5_ = int(_loc4_.length - 1);
            while(_loc5_ >= 0)
            {
               _loc6_ = _loc4_[_loc5_];
               _loc7_ = getChildOfSelectionContext(_loc6_,param1);
               if(!param2 && _loc7_ is SVGGroup && _loc6_.parent is SVGGroup && _loc6_ is ISVGEditable)
               {
                  _loc7_ = _loc6_;
               }
               _loc8_ = param3 is PaintBucketTool || param3 is PaintBrushTool;
               _loc9_ = param3 is ObjectTransformer;
               if(_loc7_ is ISVGEditable && (param2 || !(_loc7_ is SVGGroup)) && (_loc8_ || !(_loc7_ as ISVGEditable).getElement().isBackDropBG()))
               {
                  return _loc7_ as ISVGEditable;
               }
               _loc5_--;
            }
         }
         return null;
      }
      
      private static function getChildOfSelectionContext(param1:DisplayObject, param2:ImageEdit) : DisplayObject
      {
         var _loc3_:Sprite = param2.getContentLayer();
         while(Boolean(param1) && param1.parent != _loc3_)
         {
            param1 = param1.parent;
         }
         return param1;
      }
      
      public function refresh() : void
      {
      }
      
      protected function init() : void
      {
         if(Boolean(this.cursorBMName) && Boolean(this.cursorHotSpot))
         {
            this.editor.setCurrentCursor(this.cursorBMName,this.cursorBMName,this.cursorHotSpot);
         }
         else if(this.cursorName)
         {
            this.editor.setCurrentCursor(this.cursorName);
         }
      }
      
      protected function shutdown() : void
      {
         this.editor.setCurrentCursor(null);
         this.editor = null;
      }
      
      final public function interactsWithContent() : Boolean
      {
         return this.touchesContent;
      }
      
      public function cancel() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
      }
      
      private function addedToStage(param1:Event) : void
      {
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStage);
         this.init();
      }
      
      private function removedFromStage(param1:Event) : void
      {
         if(param1.target != this)
         {
            return;
         }
         removeEventListener(Event.REMOVED,this.removedFromStage);
         this.isShuttingDown = true;
         this.shutdown();
      }
      
      protected function getEditableUnderMouse(param1:Boolean = true) : ISVGEditable
      {
         return staticGetEditableUnderMouse(this.editor,param1,this);
      }
      
      protected function getContinuableShapeUnderMouse(param1:Number) : Object
      {
         var _loc3_:SVGShape = null;
         var _loc4_:SVGPath = null;
         var _loc5_:Array = null;
         var _loc6_:Boolean = false;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc2_:ISVGEditable = this.getEditableUnderMouse(false);
         if(_loc2_ is SVGShape)
         {
            _loc3_ = _loc2_ as SVGShape;
            _loc4_ = _loc3_.getElement().path;
            _loc5_ = _loc4_.getSegmentEndPoints(0);
            _loc6_ = Boolean(_loc5_[2]);
            _loc7_ = _loc3_.getElement().getAttribute("stroke-width",1);
            _loc8_ = (param1 + _loc7_) / 2;
            if(!_loc6_)
            {
               _loc9_ = new Point(_loc3_.mouseX,_loc3_.mouseY);
               _loc10_ = null;
               if(_loc4_.getPos(_loc5_[0]).subtract(_loc9_).length < _loc8_)
               {
                  return {
                     "index":_loc5_[0],
                     "bEnd":false,
                     "shape":_loc2_ as SVGShape
                  };
               }
               if(_loc4_.getPos(_loc5_[1]).subtract(_loc9_).length < _loc8_)
               {
                  return {
                     "index":_loc5_[1],
                     "bEnd":true,
                     "shape":_loc2_ as SVGShape
                  };
               }
            }
         }
         return null;
      }
   }
}

