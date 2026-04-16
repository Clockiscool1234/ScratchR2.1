package util
{
   import blocks.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import scratch.*;
   import svgeditor.*;
   import uiwidgets.*;
   import watchers.*;
   
   public class GestureHandler
   {
      
      private static var bubbleRange:Number = 25;
      
      private static var bubbleMargin:Number = 5;
      
      private const DOUBLE_CLICK_MSECS:int = 400;
      
      private const DEBUG:Boolean = false;
      
      private const SCROLL_RANGE:Number = 60;
      
      private const SCROLL_MAX_SPEED:Number = 20;
      
      private const SCROLL_MSECS:int = 500;
      
      public var mouseIsDown:Boolean;
      
      public var carriedObj:Sprite;
      
      private var originalParent:DisplayObjectContainer;
      
      private var originalPosition:Point;
      
      private var originalScale:Number;
      
      private var app:Scratch;
      
      private var stage:Stage;
      
      private var dragClient:DragClient;
      
      private var mouseDownTime:uint;
      
      private var gesture:String = "idle";
      
      private var mouseTarget:*;
      
      private var objToGrabOnUp:Sprite;
      
      private var mouseDownEvent:MouseEvent;
      
      private var inIE:Boolean;
      
      private var scrollTarget:ScrollFrame;
      
      private var scrollStartTime:int;
      
      private var scrollXVelocity:Number;
      
      private var scrollYVelocity:Number;
      
      private var bubble:TalkBubble;
      
      private var bubbleStartX:Number;
      
      private var bubbleStartY:Number;
      
      private var lastGrowShrinkSprite:Sprite;
      
      private var debugSelection:DisplayObject;
      
      public function GestureHandler(param1:Scratch, param2:Boolean)
      {
         super();
         this.app = param1;
         this.stage = param1.stage;
         this.inIE = param2;
      }
      
      private static function isAncestor(param1:DisplayObject, param2:DisplayObject) : Boolean
      {
         while(param2)
         {
            if(param1 == param2)
            {
               return true;
            }
            param2 = param2.parent;
         }
         return false;
      }
      
      public function setDragClient(param1:DragClient, param2:MouseEvent) : void
      {
         Menu.removeMenusFrom(this.stage);
         if(this.carriedObj)
         {
            return;
         }
         if(this.dragClient != null)
         {
            this.dragClient.dragEnd(param2);
         }
         this.dragClient = param1 as DragClient;
         this.dragClient.dragBegin(param2);
         param2.stopImmediatePropagation();
      }
      
      public function grabOnMouseUp(param1:Sprite) : void
      {
         if(CursorTool.tool == "copy")
         {
            this.grab(param1,null);
            this.gesture = "drag";
         }
         else
         {
            this.objToGrabOnUp = param1;
         }
      }
      
      public function step() : void
      {
         var _loc1_:Block = null;
         if(CachedTimer.getCachedTimer() - this.mouseDownTime > this.DOUBLE_CLICK_MSECS)
         {
            if(this.gesture == "unknown")
            {
               if(this.mouseTarget != null)
               {
                  this.handleDrag(null);
               }
               if(this.gesture != "drag")
               {
                  this.handleClick(this.mouseDownEvent);
               }
            }
            if(this.gesture == "clickOrDoubleClick")
            {
               this.handleClick(this.mouseDownEvent);
            }
         }
         if(Boolean(this.carriedObj && this.scrollTarget) && Boolean(CachedTimer.getCachedTimer() - this.scrollStartTime > this.SCROLL_MSECS) && (Boolean(this.scrollXVelocity) || Boolean(this.scrollYVelocity)))
         {
            if(this.scrollTarget.allowHorizontalScrollbar)
            {
               this.scrollTarget.contents.x = Math.min(0,Math.max(-this.scrollTarget.maxScrollH(),this.scrollTarget.contents.x + this.scrollXVelocity));
            }
            if(this.scrollTarget.allowVerticalScrollbar)
            {
               this.scrollTarget.contents.y = Math.min(0,Math.max(-this.scrollTarget.maxScrollV(),this.scrollTarget.contents.y + this.scrollYVelocity));
            }
            if(this.scrollTarget.allowHorizontalScrollbar || this.scrollTarget.allowVerticalScrollbar)
            {
               this.scrollTarget.constrainScroll();
               this.scrollTarget.updateScrollbars();
            }
            _loc1_ = this.carriedObj as Block;
            if(_loc1_)
            {
               this.app.scriptsPane.findTargetsFor(_loc1_);
               this.app.scriptsPane.updateFeedbackFor(_loc1_);
            }
         }
      }
      
      public function rightMouseClick(param1:MouseEvent) : void
      {
         this.rightMouseDown(param1.stageX,param1.stageY,false);
      }
      
      public function rightMouseDown(param1:int, param2:int, param3:Boolean) : void
      {
         var _loc5_:Menu = null;
         Menu.removeMenusFrom(this.stage);
         var _loc4_:* = this.findTargetFor("menu",this.app,param1,param2);
         if(!_loc4_)
         {
            return;
         }
         try
         {
            _loc5_ = _loc4_.menu(new MouseEvent("right click"));
         }
         catch(e:Error)
         {
         }
         if(_loc5_)
         {
            _loc5_.showOnStage(this.stage,param1,param2);
         }
         if(!param3)
         {
            Menu.removeMenusFrom(this.stage);
         }
      }
      
      private function findTargetFor(param1:String, param2:*, param3:int, param4:int) : DisplayObject
      {
         var _loc5_:* = 0;
         var _loc6_:DisplayObject = null;
         if(!param2.visible || !param2.hitTestPoint(param3,param4,true))
         {
            return null;
         }
         if(param2 is DisplayObjectContainer)
         {
            _loc5_ = int(param2.numChildren - 1);
            while(_loc5_ >= 0)
            {
               _loc6_ = this.findTargetFor(param1,param2.getChildAt(_loc5_),param3,param4);
               if(_loc6_)
               {
                  return _loc6_;
               }
               _loc5_--;
            }
         }
         return param1 in param2 ? param2 : null;
      }
      
      public function mouseDown(param1:MouseEvent) : void
      {
         if(this.inIE && this.app.editMode && this.app.jsEnabled)
         {
            this.app.externalCall("tip_bar_api.fixIE");
         }
         param1.updateAfterEvent();
         this.hideBubble();
         this.mouseIsDown = true;
         if(this.gesture == "clickOrDoubleClick")
         {
            this.handleDoubleClick(this.mouseDownEvent);
            return;
         }
         if(CursorTool.tool)
         {
            this.handleTool(param1);
            return;
         }
         this.mouseDownTime = CachedTimer.getCachedTimer();
         this.mouseDownEvent = param1;
         this.gesture = "unknown";
         this.mouseTarget = null;
         if(this.carriedObj != null)
         {
            this.drop(param1);
            return;
         }
         if(this.dragClient != null)
         {
            this.dragClient.dragBegin(param1);
            return;
         }
         if(this.DEBUG && param1.shiftKey)
         {
            return this.showDebugFeedback(param1);
         }
         var _loc2_:* = param1.target;
         if(_loc2_ is TextField && TextField(_loc2_).type == TextFieldType.INPUT)
         {
            return;
         }
         this.mouseTarget = this.findMouseTarget(param1,_loc2_);
         if(this.mouseTarget == null)
         {
            this.gesture = "ignore";
            return;
         }
         if(this.doClickImmediately())
         {
            this.handleClick(param1);
            return;
         }
         if(param1.shiftKey && this.app.editMode && "menu" in this.mouseTarget)
         {
            this.gesture = "menu";
            return;
         }
      }
      
      private function doClickImmediately() : Boolean
      {
         if(this.app.editMode)
         {
            return false;
         }
         if(this.mouseTarget is ScratchStage)
         {
            return true;
         }
         return this.mouseTarget is ScratchSprite && !ScratchSprite(this.mouseTarget).isDraggable;
      }
      
      public function mouseMove(param1:MouseEvent) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Point = null;
         var _loc6_:ScratchSprite = null;
         var _loc7_:Point = null;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(this.gesture == "debug")
         {
            param1.stopImmediatePropagation();
            return;
         }
         this.mouseIsDown = param1.buttonDown;
         if(this.dragClient != null)
         {
            this.dragClient.dragMove(param1);
            return;
         }
         if(this.gesture == "unknown")
         {
            if(this.mouseTarget != null)
            {
               this.handleDrag(param1);
            }
            return;
         }
         if(this.gesture == "drag" && this.carriedObj is Block)
         {
            this.app.scriptsPane.updateFeedbackFor(Block(this.carriedObj));
         }
         if(this.gesture == "drag" && this.carriedObj is ScratchSprite)
         {
            _loc5_ = this.app.stagePane.globalToLocal(this.carriedObj.localToGlobal(new Point(0,0)));
            _loc6_ = ScratchSprite(this.carriedObj);
            _loc6_.scratchX = _loc5_.x - 240;
            _loc6_.scratchY = 180 - _loc5_.y;
            _loc6_.updateBubble();
         }
         var _loc2_:ScrollFrame = this.scrollTarget;
         this.scrollTarget = null;
         var _loc3_:Array = this.stage.getObjectsUnderPoint(new Point(this.stage.mouseX,this.stage.mouseY));
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_ is ScrollFrameContents)
            {
               this.scrollTarget = _loc4_.parent as ScrollFrame;
               if(this.scrollTarget != _loc2_)
               {
                  this.scrollStartTime = CachedTimer.getCachedTimer();
               }
               break;
            }
         }
         if(this.scrollTarget)
         {
            _loc7_ = this.scrollTarget.localToGlobal(new Point(0,0));
            _loc8_ = this.stage.mouseX;
            _loc9_ = this.stage.mouseY;
            _loc10_ = _loc8_ - _loc7_.x;
            if(_loc10_ >= 0 && _loc10_ <= this.SCROLL_RANGE && this.scrollTarget.canScrollLeft())
            {
               this.scrollXVelocity = (1 - _loc10_ / this.SCROLL_RANGE) * this.SCROLL_MAX_SPEED;
            }
            else
            {
               _loc10_ = _loc7_.x + this.scrollTarget.visibleW() - _loc8_;
               if(_loc10_ >= 0 && _loc10_ <= this.SCROLL_RANGE && this.scrollTarget.canScrollRight())
               {
                  this.scrollXVelocity = (_loc10_ / this.SCROLL_RANGE - 1) * this.SCROLL_MAX_SPEED;
               }
               else
               {
                  this.scrollXVelocity = 0;
               }
            }
            _loc10_ = _loc9_ - _loc7_.y;
            if(_loc10_ >= 0 && _loc10_ <= this.SCROLL_RANGE && this.scrollTarget.canScrollUp())
            {
               this.scrollYVelocity = (1 - _loc10_ / this.SCROLL_RANGE) * this.SCROLL_MAX_SPEED;
            }
            else
            {
               _loc10_ = _loc7_.y + this.scrollTarget.visibleH() - _loc9_;
               if(_loc10_ >= 0 && _loc10_ <= this.SCROLL_RANGE && this.scrollTarget.canScrollDown())
               {
                  this.scrollYVelocity = (_loc10_ / this.SCROLL_RANGE - 1) * this.SCROLL_MAX_SPEED;
               }
               else
               {
                  this.scrollYVelocity = 0;
               }
            }
            if(!this.scrollXVelocity && !this.scrollYVelocity)
            {
               this.scrollStartTime = CachedTimer.getCachedTimer();
            }
         }
         if(this.bubble)
         {
            _loc11_ = this.bubbleStartX - this.stage.mouseX;
            _loc12_ = this.bubbleStartY - this.stage.mouseY;
            if(_loc11_ * _loc11_ + _loc12_ * _loc12_ > bubbleRange * bubbleRange)
            {
               this.hideBubble();
            }
         }
      }
      
      public function mouseUp(param1:MouseEvent) : void
      {
         var _loc2_:DragClient = null;
         if(this.gesture == "debug")
         {
            param1.stopImmediatePropagation();
            return;
         }
         this.mouseIsDown = false;
         if(this.dragClient != null)
         {
            _loc2_ = this.dragClient;
            this.dragClient = null;
            _loc2_.dragEnd(param1);
            return;
         }
         this.drop(param1);
         Menu.removeMenusFrom(this.stage);
         if(this.gesture == "unknown")
         {
            if(Boolean(this.mouseTarget) && "doubleClick" in this.mouseTarget)
            {
               this.gesture = "clickOrDoubleClick";
            }
            else
            {
               this.handleClick(param1);
               this.mouseTarget = null;
               this.gesture = "idle";
            }
            return;
         }
         if(this.gesture == "menu")
         {
            this.handleMenu(param1);
         }
         if(this.app.scriptsPane)
         {
            this.app.scriptsPane.draggingDone();
         }
         this.mouseTarget = null;
         this.gesture = "idle";
         if(this.objToGrabOnUp != null)
         {
            this.gesture = "drag";
            this.grab(this.objToGrabOnUp,param1);
            this.objToGrabOnUp = null;
         }
      }
      
      public function mouseWheel(param1:MouseEvent) : void
      {
         this.hideBubble();
      }
      
      public function escKeyDown() : void
      {
         if(this.carriedObj != null && this.carriedObj is Block)
         {
            this.carriedObj.stopDrag();
            this.removeDropShadowFrom(this.carriedObj);
            Block(this.carriedObj).restoreOriginalState();
            this.carriedObj = null;
         }
      }
      
      private function findMouseTarget(param1:MouseEvent, param2:*) : DisplayObject
      {
         var _loc4_:Boolean = false;
         var _loc6_:Rectangle = null;
         if(param2 is TextField && TextField(param2).type == TextFieldType.INPUT)
         {
            return null;
         }
         if(param2 is Button || param2 is IconButton)
         {
            return null;
         }
         var _loc3_:DisplayObject = param1.target as DisplayObject;
         if(_loc3_ == this.stage)
         {
            _loc6_ = this.app.stageObj().getRect(this.stage);
            _loc4_ = _loc6_.contains(param1.stageX,param1.stageY);
         }
         else
         {
            _loc4_ = isAncestor(this.app.stageObj(),_loc3_);
         }
         if(_loc4_)
         {
            return this.findMouseTargetOnStage(param1.stageX / this.app.scaleX,param1.stageY / this.app.scaleY);
         }
         var _loc5_:Boolean = false;
         while(_loc3_ != null)
         {
            if(this.isMouseTarget(_loc3_,param1.stageX / this.app.scaleX,param1.stageY / this.app.scaleY))
            {
               _loc5_ = true;
               break;
            }
            _loc3_ = _loc3_.parent;
         }
         if(_loc3_ is Block && Block(_loc3_).isEmbeddedInProcHat())
         {
            return _loc3_.parent;
         }
         return _loc3_;
      }
      
      private function findMouseTargetOnStage(param1:int, param2:int) : DisplayObject
      {
         var _loc5_:DisplayObject = null;
         if(this.app.isIn3D)
         {
            this.app.stagePane.visible = true;
         }
         var _loc3_:Sprite = this.app.stagePane.getUILayer();
         var _loc4_:* = int(_loc3_.numChildren - 1);
         while(_loc4_ > 0)
         {
            _loc5_ = _loc3_.getChildAt(_loc4_) as DisplayObject;
            if(_loc5_ is Bitmap)
            {
               break;
            }
            if(_loc5_.visible && _loc5_.hitTestPoint(param1,param2,true))
            {
               if(this.app.isIn3D)
               {
                  this.app.stagePane.visible = false;
               }
               return _loc5_;
            }
            _loc4_--;
         }
         if(this.app.stagePane != _loc3_)
         {
            _loc4_ = int(this.app.stagePane.numChildren - 1);
            while(_loc4_ > 0)
            {
               _loc5_ = this.app.stagePane.getChildAt(_loc4_) as DisplayObject;
               if(_loc5_ is Bitmap)
               {
                  break;
               }
               if(_loc5_.visible && _loc5_.hitTestPoint(param1,param2,true))
               {
                  if(this.app.isIn3D)
                  {
                     this.app.stagePane.visible = false;
                  }
                  return _loc5_;
               }
               _loc4_--;
            }
         }
         if(this.app.isIn3D)
         {
            this.app.stagePane.visible = false;
         }
         return this.app.stagePane;
      }
      
      private function isMouseTarget(param1:DisplayObject, param2:int, param3:int) : Boolean
      {
         if(!param1.hitTestPoint(param2,param3,true))
         {
            return false;
         }
         if("click" in param1 || "doubleClick" in param1)
         {
            return true;
         }
         if("menu" in param1 || "objToGrab" in param1)
         {
            return true;
         }
         return false;
      }
      
      private function handleDrag(param1:MouseEvent) : void
      {
         Menu.removeMenusFrom(this.stage);
         if(!("objToGrab" in this.mouseTarget))
         {
            return;
         }
         if(!this.app.editMode)
         {
            if(this.app.loadInProgress)
            {
               return;
            }
            if(this.mouseTarget is ScratchSprite && !ScratchSprite(this.mouseTarget).isDraggable)
            {
               return;
            }
            if(this.mouseTarget is Watcher || this.mouseTarget is ListWatcher)
            {
               return;
            }
         }
         this.grab(this.mouseTarget,param1);
         this.gesture = "drag";
         if(this.carriedObj is Block)
         {
            this.app.scriptsPane.updateFeedbackFor(Block(this.carriedObj));
         }
      }
      
      private function handleClick(param1:MouseEvent) : void
      {
         if(this.mouseTarget == null)
         {
            return;
         }
         param1.updateAfterEvent();
         if("click" in this.mouseTarget)
         {
            this.mouseTarget.click(param1);
         }
         this.gesture = "click";
      }
      
      private function handleDoubleClick(param1:MouseEvent) : void
      {
         if(this.mouseTarget == null)
         {
            return;
         }
         if("doubleClick" in this.mouseTarget)
         {
            this.mouseTarget.doubleClick(param1);
         }
         this.gesture = "doubleClick";
      }
      
      private function handleMenu(param1:MouseEvent) : void
      {
         var _loc2_:Menu = null;
         if(this.mouseTarget == null)
         {
            return;
         }
         try
         {
            _loc2_ = this.mouseTarget.menu(param1);
         }
         catch(e:Error)
         {
         }
         if(_loc2_)
         {
            _loc2_.showOnStage(this.stage,param1.stageX / this.app.scaleX,param1.stageY / this.app.scaleY);
         }
      }
      
      private function handleTool(param1:MouseEvent) : void
      {
         var clearTool:Function = null;
         var evt:MouseEvent = param1;
         var isGrowShrink:Boolean = "grow" == CursorTool.tool || "shrink" == CursorTool.tool;
         var t:* = this.findTargetFor("handleTool",this.app,evt.stageX / this.app.scaleX,evt.stageY / this.app.scaleY);
         if(!t)
         {
            t = this.findMouseTargetOnStage(evt.stageX / this.app.scaleX,evt.stageY / this.app.scaleY);
         }
         if(isGrowShrink && t is ScratchSprite)
         {
            clearTool = function(param1:MouseEvent):void
            {
               if(lastGrowShrinkSprite)
               {
                  lastGrowShrinkSprite.removeEventListener(MouseEvent.MOUSE_OUT,clearTool);
                  lastGrowShrinkSprite = null;
                  app.clearTool();
               }
            };
            if(!this.lastGrowShrinkSprite && !evt.shiftKey)
            {
               t.addEventListener(MouseEvent.MOUSE_OUT,clearTool);
               this.lastGrowShrinkSprite = t;
            }
            t.handleTool(CursorTool.tool,evt);
            return;
         }
         if(Boolean(t) && "handleTool" in t)
         {
            t.handleTool(CursorTool.tool,evt);
         }
         if(isGrowShrink && (Boolean(t is Block && t.isInPalette) || Boolean(t is ImageCanvas)))
         {
            return;
         }
         if(!evt.shiftKey)
         {
            this.app.clearTool();
         }
      }
      
      private function grab(param1:*, param2:MouseEvent) : void
      {
         var _loc4_:Block = null;
         var _loc5_:ScratchComment = null;
         var _loc6_:Boolean = false;
         if(param2)
         {
            this.drop(param2);
         }
         var _loc3_:Point = param1.localToGlobal(new Point(0,0));
         param1 = param1.objToGrab(param2 ? param2 : new MouseEvent(""));
         if(!param1)
         {
            return;
         }
         if(param1.parent)
         {
            _loc3_ = param1.localToGlobal(new Point(0,0));
         }
         this.originalParent = param1.parent;
         this.originalPosition = new Point(param1.x,param1.y);
         this.originalScale = param1.scaleX;
         if(param1 is Block)
         {
            _loc4_ = Block(param1);
            _loc4_.saveOriginalState();
            if(_loc4_.parent is Block)
            {
               Block(_loc4_.parent).removeBlock(_loc4_);
            }
            if(_loc4_.parent != null)
            {
               _loc4_.parent.removeChild(_loc4_);
            }
            this.app.scriptsPane.prepareToDrag(_loc4_);
         }
         else if(param1 is ScratchComment)
         {
            _loc5_ = ScratchComment(param1);
            if(_loc5_.parent != null)
            {
               _loc5_.parent.removeChild(_loc5_);
            }
            this.app.scriptsPane.prepareToDragComment(_loc5_);
         }
         else
         {
            _loc6_ = param1.parent == this.app.stagePane;
            if(param1.parent != null)
            {
               if(param1 is ScratchSprite && this.app.isIn3D)
               {
                  (param1 as ScratchSprite).prepareToDrag();
               }
               param1.parent.removeChild(param1);
            }
            if(_loc6_ && this.app.stagePane.scaleX != 1)
            {
               param1.scaleX = param1.scaleY = param1.scaleX * this.app.stagePane.scaleX;
            }
         }
         if(this.app.editMode)
         {
            this.addDropShadowTo(param1);
         }
         this.stage.addChild(param1);
         param1.x = _loc3_.x;
         param1.y = _loc3_.y;
         if(Boolean(param2) && Boolean(this.mouseDownEvent))
         {
            param1.x += param2.stageX - this.mouseDownEvent.stageX;
            param1.y += param2.stageY - this.mouseDownEvent.stageY;
         }
         param1.startDrag();
         if(param1 is DisplayObject)
         {
            param1.cacheAsBitmap = true;
         }
         this.carriedObj = param1;
         this.scrollStartTime = CachedTimer.getCachedTimer();
      }
      
      private function dropHandled(param1:*, param2:MouseEvent) : Boolean
      {
         var _loc5_:* = undefined;
         if(this.app.isIn3D)
         {
            this.app.stagePane.visible = true;
         }
         var _loc3_:Array = this.stage.getObjectsUnderPoint(new Point(param2.stageX / this.app.scaleX,param2.stageY / this.app.scaleY));
         if(this.app.isIn3D)
         {
            this.app.stagePane.visible = false;
            if(_loc3_.length == 0 && this.app.stagePane.scrollRect.contains(this.app.stagePane.mouseX,this.app.stagePane.mouseY))
            {
               _loc3_.push(this.app.stagePane);
            }
         }
         _loc3_.reverse();
         var _loc4_:Array = [];
         for each(_loc5_ in _loc3_)
         {
            while(_loc5_)
            {
               if(_loc4_.indexOf(_loc5_) == -1)
               {
                  if("handleDrop" in _loc5_ && Boolean(_loc5_.handleDrop(param1)))
                  {
                     return true;
                  }
                  _loc4_.push(_loc5_);
               }
               _loc5_ = _loc5_.parent;
            }
         }
         return false;
      }
      
      private function drop(param1:MouseEvent) : void
      {
         var _loc2_:ScratchSprite = null;
         if(this.carriedObj == null)
         {
            return;
         }
         if(this.carriedObj is DisplayObject)
         {
            this.carriedObj.cacheAsBitmap = false;
         }
         this.carriedObj.stopDrag();
         this.removeDropShadowFrom(this.carriedObj);
         this.carriedObj.parent.removeChild(this.carriedObj);
         if(!this.dropHandled(this.carriedObj,param1))
         {
            if(this.carriedObj is Block)
            {
               Block(this.carriedObj).restoreOriginalState();
            }
            else if(this.originalParent)
            {
               this.carriedObj.x = this.originalPosition.x;
               this.carriedObj.y = this.originalPosition.y;
               this.carriedObj.scaleX = this.carriedObj.scaleY = this.originalScale;
               this.originalParent.addChild(this.carriedObj);
               if(this.carriedObj is ScratchSprite)
               {
                  _loc2_ = this.carriedObj as ScratchSprite;
                  _loc2_.updateCostume();
                  _loc2_.updateBubble();
               }
            }
         }
         this.app.scriptsPane.draggingDone();
         this.carriedObj = null;
         this.originalParent = null;
         this.originalPosition = null;
      }
      
      private function addDropShadowTo(param1:DisplayObject) : void
      {
         var _loc2_:DropShadowFilter = new DropShadowFilter();
         var _loc3_:Number = this.app.scriptsPane ? this.app.scriptsPane.scaleX : 1;
         _loc2_.distance = 8 * _loc3_;
         _loc2_.blurX = _loc2_.blurY = 2;
         _loc2_.alpha = 0.4;
         param1.filters = param1.filters.concat([_loc2_]);
      }
      
      private function removeDropShadowFrom(param1:DisplayObject) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1.filters)
         {
            if(!(_loc3_ is DropShadowFilter))
            {
               _loc2_.push(_loc3_);
            }
         }
         param1.filters = _loc2_;
      }
      
      public function showBubble(param1:String, param2:Number, param3:Number, param4:Number = 0) : void
      {
         this.hideBubble();
         this.bubble = new TalkBubble(param1 || " ","say","result",this);
         this.bubbleStartX = this.stage.mouseX;
         this.bubbleStartY = this.stage.mouseY;
         var _loc5_:Number = param2 + param4;
         var _loc6_:Number = param3 - this.bubble.height;
         if(_loc5_ + this.bubble.width > this.stage.stageWidth - bubbleMargin && param2 - this.bubble.width > bubbleMargin)
         {
            _loc5_ = param2 - this.bubble.width;
            this.bubble.setDirection("right");
         }
         else
         {
            this.bubble.setDirection("left");
         }
         this.bubble.x = Math.max(bubbleMargin,Math.min(this.stage.stageWidth - bubbleMargin,_loc5_));
         this.bubble.y = Math.max(bubbleMargin,Math.min(this.stage.stageHeight - bubbleMargin,_loc6_));
         var _loc7_:DropShadowFilter = new DropShadowFilter();
         _loc7_.distance = 4;
         _loc7_.blurX = _loc7_.blurY = 8;
         _loc7_.alpha = 0.2;
         this.bubble.filters = this.bubble.filters.concat(_loc7_);
         this.stage.addChild(this.bubble);
      }
      
      public function hideBubble() : void
      {
         if(this.bubble)
         {
            this.stage.removeChild(this.bubble);
            this.bubble = null;
         }
      }
      
      private function showDebugFeedback(param1:MouseEvent) : void
      {
         param1.stopImmediatePropagation();
         this.gesture = "debug";
         var _loc2_:DisplayObject = param1.target.stage;
         if(this.debugSelection != null)
         {
            this.removeDebugGlow(this.debugSelection);
            if(this.debugSelection.getRect(_loc2_).containsPoint(new Point(_loc2_.mouseX,_loc2_.mouseY)))
            {
               this.debugSelection = this.debugSelection.parent;
            }
            else
            {
               this.debugSelection = DisplayObject(param1.target);
            }
         }
         else
         {
            this.debugSelection = DisplayObject(param1.target);
         }
         if(this.debugSelection is Stage)
         {
            this.debugSelection = null;
            return;
         }
         this.addDebugGlow(this.debugSelection);
      }
      
      private function addDebugGlow(param1:DisplayObject) : void
      {
         var _loc2_:Array = [];
         if(param1.filters != null)
         {
            _loc2_ = param1.filters;
         }
         var _loc3_:GlowFilter = new GlowFilter(16776960);
         _loc3_.strength = 15;
         _loc3_.blurX = _loc3_.blurY = 6;
         _loc3_.inner = true;
         _loc2_.push(_loc3_);
         param1.filters = _loc2_;
      }
      
      private function removeDebugGlow(param1:DisplayObject) : void
      {
         var _loc3_:* = undefined;
         var _loc2_:Array = [];
         for each(_loc3_ in param1.filters)
         {
            if(!(_loc3_ is GlowFilter))
            {
               _loc2_.push(_loc3_);
            }
         }
         param1.filters = _loc2_;
      }
   }
}

