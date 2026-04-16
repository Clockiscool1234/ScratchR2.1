package svgeditor.tools
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import svgeditor.*;
   import svgeditor.objs.*;
   
   public class ObjectTransformer extends SVGEditTool
   {
      
      private static const dashLength:uint = 3;
      
      private static const dashColor:uint = 13421772;
      
      private static const grpDashLength:uint = 3;
      
      private static const grpDashColor:uint = 16489216;
      
      private static const bmDashLength:uint = 4;
      
      private static const bmDashColor:uint = 255;
      
      private static const resizeColor:uint = 0;
      
      private static const rotateColor:uint = 6710886;
      
      private static const moveColor:uint = 52224;
      
      private static const HT_RESIZER:uint = 0;
      
      private static const HT_ROTATOR:uint = 1;
      
      private static const HT_MOVER:uint = 2;
      
      private var toolsLayer:Sprite;
      
      private var contentLayer:Sprite;
      
      private var selectionContext:DisplayObject;
      
      private var targetObj:Selection;
      
      private var topLeftHandle:Sprite;
      
      private var topHandle:Sprite;
      
      private var topRightHandle:Sprite;
      
      private var rightHandle:Sprite;
      
      private var bottomRightHandle:Sprite;
      
      private var bottomHandle:Sprite;
      
      private var bottomLeftHandle:Sprite;
      
      private var leftHandle:Sprite;
      
      private var rotateHandle:Sprite;
      
      private var moveHandle:Sprite;
      
      private var activeHandle:Sprite;
      
      private var scaleHandleDict:Dictionary;
      
      private var initialMatrix:Matrix;
      
      private var initialRotation:Number;
      
      private var initialRotation2:Number;
      
      private var moveOffset:Point;
      
      private var selectionRect:Rectangle;
      
      private var centerMoved:Boolean;
      
      private var copiedObjects:Array;
      
      private var dblClickTimer:Timer;
      
      private var preEditTF:TextField;
      
      private var isRefreshing:Boolean;
      
      private var isTransforming:Boolean;
      
      private var handleMoveCursor:Function;
      
      private var _isChanged:Boolean = false;
      
      private var movingHandle:Boolean = false;
      
      private var wasMoved:Boolean = false;
      
      private var selectionOrigin:Point;
      
      public function ObjectTransformer(param1:ImageEdit)
      {
         var ed:ImageEdit = param1;
         super(ed);
         this.activeHandle = null;
         this.toolsLayer = editor.getToolsLayer();
         this.contentLayer = editor.getContentLayer();
         this.selectionContext = this.contentLayer;
         this.scaleHandleDict = new Dictionary();
         this.topLeftHandle = this.makeHandle();
         this.scaleHandleDict[this.topLeftHandle] = "topLeft";
         this.topHandle = this.makeHandle();
         this.scaleHandleDict[this.topHandle] = "top";
         this.topRightHandle = this.makeHandle();
         this.scaleHandleDict[this.topRightHandle] = "topRight";
         this.rightHandle = this.makeHandle();
         this.scaleHandleDict[this.rightHandle] = "right";
         this.bottomRightHandle = this.makeHandle();
         this.scaleHandleDict[this.bottomRightHandle] = "bottomRight";
         this.bottomHandle = this.makeHandle();
         this.scaleHandleDict[this.bottomHandle] = "bottom";
         this.bottomLeftHandle = this.makeHandle();
         this.scaleHandleDict[this.bottomLeftHandle] = "bottomLeft";
         this.leftHandle = this.makeHandle();
         this.scaleHandleDict[this.leftHandle] = "left";
         this.rotateHandle = this.makeHandle(HT_ROTATOR);
         this.moveHandle = this.makeHandle(HT_MOVER);
         this.centerMoved = false;
         this.isTransforming = false;
         this.isRefreshing = false;
         this.handleMoveCursor = function(param1:MouseEvent):void
         {
            toolCursorHandler(param1,HT_MOVER);
         };
         this.selectionRect = new Rectangle(-5,-5,5,5);
      }
      
      public function get isChanged() : Boolean
      {
         return this._isChanged;
      }
      
      override protected function init() : void
      {
         var wasChanged:Function = null;
         wasChanged = function():void
         {
            _isChanged = true;
         };
         if(editor is BitmapEdit && !this.targetObj)
         {
            cursorBMName = "crosshairCursor";
            cursorHotSpot = new Point(8,8);
         }
         else
         {
            cursorBMName = null;
         }
         super.init();
         addEventListener(Event.CHANGE,wasChanged,false,0,true);
         editor.getWorkArea().addEventListener(MouseEvent.MOUSE_DOWN,this.selectionBoxHandler,false,0,true);
         this.toggleHandles(false);
         alpha = 0.65;
      }
      
      public function reset() : void
      {
         this._isChanged = false;
      }
      
      override protected function shutdown() : void
      {
         var _loc1_:Stage = STAGE;
         this.removeSelectionEventHandlers();
         editor.getWorkArea().removeEventListener(MouseEvent.MOUSE_DOWN,this.selectionBoxHandler);
         _loc1_.removeEventListener(MouseEvent.MOUSE_MOVE,this.selectionBoxHandler);
         _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.selectionBoxHandler);
         this.select(null);
         this.setActive(false);
         super.shutdown();
      }
      
      override protected function edit(param1:ISVGEditable, param2:MouseEvent) : void
      {
         if(Boolean(this.targetObj) && this.targetObj.contains(param1 as DisplayObject))
         {
            if(Boolean(param2) && (param2.shiftKey || param2.ctrlKey))
            {
               this.targetObj.getObjs().splice(this.targetObj.getObjs().indexOf(param1),1);
               if(this.targetObj.getObjs().length)
               {
                  this.select(this.targetObj);
               }
               else
               {
                  this.select(null);
               }
            }
            else
            {
               this.moveHandler(new MouseEvent(MouseEvent.MOUSE_DOWN));
            }
         }
         else
         {
            if(editor.revertToCreateTool(param2))
            {
               return;
            }
            if(Boolean(this.targetObj) && Boolean(param2) && (param2.shiftKey || param2.ctrlKey))
            {
               this.targetObj.getObjs().push(param1);
               this.select(this.targetObj);
            }
            else if(param1)
            {
               this.select(new Selection([param1]),true);
            }
            else
            {
               this.select(null);
            }
            dispatchEvent(new Event("select"));
         }
      }
      
      private function startDblClickTimer() : void
      {
         this.clearPreEditTF();
         if(Boolean(this.targetObj) && this.targetObj.isTextField())
         {
            this.dblClickTimer = new Timer(250);
            this.dblClickTimer.start();
            this.dblClickTimer.addEventListener(TimerEvent.TIMER,this.dblClickTimeout,false,0,true);
            this.preEditTF = this.targetObj.getObjs()[0] as TextField;
            this.preEditTF.type = TextFieldType.INPUT;
            this.preEditTF.addEventListener(FocusEvent.FOCUS_IN,this.handleTextFocus,false,0,true);
            STAGE.focus = null;
         }
      }
      
      private function handleTextFocus(param1:FocusEvent) : void
      {
         this.clearDblClickTimeout();
         this.clearPreEditTF(true);
         editor.setToolMode("text");
      }
      
      private function clearPreEditTF(param1:Boolean = false) : void
      {
         if(this.preEditTF)
         {
            if(!param1)
            {
               this.preEditTF.type = TextFieldType.DYNAMIC;
            }
            this.preEditTF.removeEventListener(FocusEvent.FOCUS_IN,this.handleTextFocus);
            this.preEditTF = null;
         }
      }
      
      private function dblClickTimeout(param1:TimerEvent = null) : void
      {
         this.clearPreEditTF();
         this.clearDblClickTimeout();
      }
      
      private function clearDblClickTimeout() : void
      {
         if(!this.dblClickTimer)
         {
            return;
         }
         this.dblClickTimer.removeEventListener(TimerEvent.TIMER,this.dblClickTimeout);
         this.dblClickTimer.stop();
         this.dblClickTimer = null;
      }
      
      private function getChildOfSelectionContext(param1:DisplayObject) : DisplayObject
      {
         while(Boolean(param1) && Boolean(param1.parent != this.contentLayer) && param1.parent != this.selectionContext)
         {
            param1 = param1.parent;
         }
         return param1;
      }
      
      public function select(param1:Selection, param2:Boolean = false) : void
      {
         if(this.targetObj == param1 && Boolean(param1))
         {
            if(param2)
            {
               this.moveHandler(new MouseEvent(MouseEvent.MOUSE_DOWN));
            }
            this.selectionRect = this.targetObj.getBounds(this);
            this.centerMoved = false;
            this.showUI();
            return;
         }
         if(this.targetObj)
         {
            this.targetObj.toggleHighlight(false);
            this.targetObj.removeEventListener(MouseEvent.MOUSE_DOWN,this.moveHandler);
            this.targetObj.removeEventListener(MouseEvent.ROLL_OVER,this.handleMoveCursor);
            this.targetObj.removeEventListener(MouseEvent.ROLL_OUT,this.handleMoveCursor);
            this.targetObj.shutdown();
         }
         this.targetObj = param1;
         var _loc3_:Event = new Event("select");
         graphics.clear();
         this.toggleHandles(!!this.targetObj);
         if(this.targetObj)
         {
            this.targetObj.toggleHighlight(true);
            this.targetObj.addEventListener(MouseEvent.MOUSE_DOWN,this.moveHandler,false,0,true);
            this.targetObj.addEventListener(MouseEvent.ROLL_OVER,this.handleMoveCursor,false,0,true);
            this.targetObj.addEventListener(MouseEvent.ROLL_OUT,this.handleMoveCursor,false,0,true);
            transform.matrix = new Matrix();
            rotation = this.targetObj.getRotation(this.contentLayer);
            this.selectionRect = this.targetObj.getBounds(this);
            this.centerMoved = false;
            this.showUI();
            if(param2)
            {
               this.handleMoveCursor(new MouseEvent(MouseEvent.ROLL_OVER));
               this.moveHandler(new MouseEvent(MouseEvent.MOUSE_DOWN),true);
            }
            STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.keyPressed,false,0,true);
         }
         else
         {
            STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,this.keyPressed);
            transform.matrix = new Matrix();
         }
         if(Boolean(this.targetObj) && this.targetObj.getObjs().length == 1)
         {
            object = this.targetObj.getObjs()[0];
         }
         else
         {
            object = null;
         }
         if(!this.isRefreshing && !isShuttingDown)
         {
            dispatchEvent(_loc3_);
         }
         if(!isShuttingDown && !this.targetObj && currentEvent is MouseEvent && currentEvent.type == MouseEvent.MOUSE_DOWN)
         {
            this.selectionBoxHandler(currentEvent);
         }
      }
      
      override public function setObject(param1:ISVGEditable) : void
      {
         this.select(null);
         if(param1)
         {
            this.select(new Selection([param1]));
         }
      }
      
      override public function getObject() : ISVGEditable
      {
         if(Boolean(this.targetObj) && this.targetObj.getObjs().length == 1)
         {
            return this.targetObj.getObjs()[0];
         }
         return null;
      }
      
      override public function refresh() : void
      {
         if(!this.targetObj)
         {
            return;
         }
         var _loc1_:Selection = new Selection(this.targetObj.getObjs());
         this.isRefreshing = true;
         this.select(null);
         this.select(_loc1_);
         this.isRefreshing = false;
      }
      
      public function getSelection() : Selection
      {
         return this.targetObj;
      }
      
      public function getSelectedElement() : ISVGEditable
      {
         return this.targetObj as ISVGEditable;
      }
      
      public function deleteSelection() : void
      {
         if(editor is BitmapEdit)
         {
            (editor as BitmapEdit).deletingSelection();
         }
         if(this.targetObj)
         {
            this.targetObj.remove();
         }
         this.removeSelectionEventHandlers();
         this.select(null);
      }
      
      private function removeSelectionEventHandlers() : void
      {
         var _loc1_:Stage = STAGE;
         if(_loc1_)
         {
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.moveHandler);
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.resizeHandler);
            _loc1_.removeEventListener(MouseEvent.MOUSE_UP,this.rotateHandler);
            _loc1_.removeEventListener(MouseEvent.MOUSE_MOVE,this.rotateHandler);
         }
         if(editor)
         {
            editor.removeEventListener(MouseEvent.MOUSE_MOVE,this.moveHandler);
            editor.removeEventListener(MouseEvent.MOUSE_MOVE,this.resizeHandler);
         }
      }
      
      private function keyPressed(param1:KeyboardEvent) : void
      {
         var _loc3_:Selection = null;
         if(isShuttingDown || !editor.isActive())
         {
            return;
         }
         if(STAGE.focus is TextField || STAGE.focus is SVGTextField && (STAGE.focus as SVGTextField).type == TextFieldType.INPUT)
         {
            return;
         }
         var _loc2_:Boolean = true;
         switch(param1.keyCode)
         {
            case Keyboard.DELETE:
            case Keyboard.BACKSPACE:
               this.deleteSelection();
               break;
            case Keyboard.UP:
               --y;
               this.updateTarget();
               break;
            case Keyboard.DOWN:
               ++y;
               this.updateTarget();
               break;
            case Keyboard.LEFT:
               --x;
               this.updateTarget();
               break;
            case Keyboard.RIGHT:
               ++x;
               this.updateTarget();
               break;
            case 99:
               _loc2_ = false;
               if(param1.ctrlKey)
               {
               }
               break;
            case 103:
               _loc3_ = this.getSelection();
               if(_loc3_)
               {
                  if(_loc3_.isGroup())
                  {
                     _loc3_.ungroup();
                  }
                  else
                  {
                     _loc3_.group();
                  }
                  this.select(_loc3_);
               }
               else
               {
                  _loc2_ = false;
               }
               break;
            default:
               _loc2_ = false;
         }
         if(_loc2_)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function makeHandle(param1:int = 0) : Sprite
      {
         var handlerWrapper:Function;
         var handleType:int = param1;
         var spr:Sprite = new Sprite();
         var handler:Function = null;
         var color:uint = 0;
         switch(handleType)
         {
            case HT_RESIZER:
               color = resizeColor;
               handler = this.resizeHandler;
               break;
            case HT_ROTATOR:
               color = rotateColor;
               handler = this.rotateHandler;
               break;
            case HT_MOVER:
               color = moveColor;
               handler = this.moveHandler;
         }
         handlerWrapper = function(param1:MouseEvent):void
         {
            toolCursorHandler(param1,handleType);
         };
         spr.addEventListener(MouseEvent.ROLL_OVER,handlerWrapper,false,0,true);
         spr.addEventListener(MouseEvent.ROLL_OUT,handlerWrapper,false,0,true);
         spr.graphics.lineStyle(1,color);
         spr.graphics.beginFill(16777215);
         if(handleType == HT_ROTATOR || handleType == HT_MOVER)
         {
            spr.graphics.drawCircle(0,0,4);
         }
         else
         {
            spr.graphics.drawRect(-3,-3,6,6);
         }
         spr.graphics.endFill();
         spr.addEventListener(MouseEvent.MOUSE_DOWN,handler,false,0,true);
         addChild(spr);
         return spr;
      }
      
      private function setActive(param1:Boolean) : void
      {
         this.isTransforming = param1;
         editor.getToolsLayer().mouseEnabled = !param1;
         editor.getToolsLayer().mouseChildren = !param1;
         if(!param1)
         {
            editor.setCurrentCursor(null);
         }
      }
      
      private function toolCursorHandler(param1:MouseEvent, param2:int) : void
      {
         if(param1.type == MouseEvent.ROLL_OUT)
         {
            if(!this.isTransforming)
            {
               if(editor)
               {
                  editor.setCurrentCursor(null);
               }
               else if(param1.currentTarget)
               {
                  param1.currentTarget.removeEventListener(param1.type,arguments.callee);
               }
            }
            return;
         }
         if(this.isTransforming)
         {
            return;
         }
         switch(param2)
         {
            case HT_RESIZER:
               this.updateResizeCursor(param1.target as Sprite);
               break;
            case HT_ROTATOR:
               editor.setCurrentCursor("rotateCursor","rotateCursor",new Point(10,13));
               break;
            case HT_MOVER:
               editor.setCurrentCursor(MouseCursor.HAND);
         }
      }
      
      private function updateResizeCursor(param1:Sprite) : void
      {
         var _loc2_:Boolean = (this.scaleHandleDict[param1] as String).length > 6;
         var _loc3_:Rectangle = this.targetObj.getBounds(STAGE);
         var _loc4_:Point = new Point((_loc3_.left + _loc3_.right) / 2,(_loc3_.top + _loc3_.bottom) / 2);
         var _loc5_:Point = localToGlobal(new Point(param1.x,param1.y)).subtract(_loc4_);
         _loc5_.normalize(1);
         var _loc6_:Point = new Point(-_loc5_.y,_loc5_.x);
         var _loc7_:Number = 14;
         var _loc8_:Number = 0.4;
         var _loc9_:Number = _loc8_ * _loc7_;
         var _loc10_:Number = 0.5 * _loc9_;
         var _loc11_:Number = (1 - _loc8_) * _loc7_;
         var _loc12_:Sprite = new Sprite();
         _loc12_.graphics.lineStyle(2,4606802);
         _loc12_.graphics.moveTo(-_loc11_ * _loc5_.x,-_loc11_ * _loc5_.y);
         _loc12_.graphics.lineTo(_loc11_ * _loc5_.x,_loc11_ * _loc5_.y);
         _loc12_.graphics.lineStyle(1,4606802);
         if(_loc2_)
         {
            _loc12_.graphics.beginFill(4606802);
         }
         _loc12_.graphics.moveTo(_loc7_ * _loc5_.x,_loc7_ * _loc5_.y);
         _loc12_.graphics.lineTo(_loc11_ * _loc5_.x + _loc10_ * _loc6_.x,_loc11_ * _loc5_.y + _loc10_ * _loc6_.y);
         _loc12_.graphics.lineTo(_loc11_ * _loc5_.x - _loc10_ * _loc6_.x,_loc11_ * _loc5_.y - _loc10_ * _loc6_.y);
         _loc12_.graphics.lineTo(_loc7_ * _loc5_.x,_loc7_ * _loc5_.y);
         if(_loc2_)
         {
            _loc12_.graphics.endFill();
         }
         if(_loc2_)
         {
            _loc12_.graphics.beginFill(4606802);
         }
         _loc12_.graphics.moveTo(-_loc7_ * _loc5_.x,-_loc7_ * _loc5_.y);
         _loc12_.graphics.lineTo(-_loc11_ * _loc5_.x + _loc10_ * _loc6_.x,-_loc11_ * _loc5_.y + _loc10_ * _loc6_.y);
         _loc12_.graphics.lineTo(-_loc11_ * _loc5_.x - _loc10_ * _loc6_.x,-_loc11_ * _loc5_.y - _loc10_ * _loc6_.y);
         _loc12_.graphics.lineTo(-_loc7_ * _loc5_.x,-_loc7_ * _loc5_.y);
         if(_loc2_)
         {
            _loc12_.graphics.endFill();
         }
         _loc12_.filters = [new GlowFilter(16777215,0.6,3,3)];
         var _loc13_:BitmapData = new BitmapData(28,28,true,0);
         var _loc14_:Matrix = new Matrix();
         _loc14_.translate(14,14);
         _loc13_.draw(_loc12_,_loc14_);
         editor.setCurrentCursor("resize",_loc13_,new Point(16,16),false);
      }
      
      private function toggleHandles(param1:Boolean) : void
      {
         var _loc2_:uint = 0;
         while(_loc2_ < numChildren)
         {
            getChildAt(_loc2_).visible = param1;
            _loc2_++;
         }
      }
      
      private function resizeHandler(param1:MouseEvent) : void
      {
         switch(param1.type)
         {
            case MouseEvent.MOUSE_DOWN:
               this.activeHandle = Sprite(param1.target);
               editor.addEventListener(MouseEvent.MOUSE_MOVE,arguments.callee,false,0,true);
               STAGE.addEventListener(MouseEvent.MOUSE_UP,arguments.callee,false,0,true);
               param1.stopPropagation();
               this.centerMoved = false;
               this.targetObj.startResize(this.scaleHandleDict[this.activeHandle]);
               this.setActive(true);
               break;
            case MouseEvent.MOUSE_MOVE:
               this.targetObj.scaleByMouse(this.scaleHandleDict[this.activeHandle]);
               this.showUI();
               break;
            case MouseEvent.MOUSE_UP:
               this.setActive(false);
               editor.removeEventListener(MouseEvent.MOUSE_MOVE,arguments.callee);
               STAGE.removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
               removeEventListener(MouseEvent.MOUSE_DOWN,arguments.callee);
               this.activeHandle = null;
               this.targetObj.saveTransform();
               dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function moveHandler(param1:MouseEvent, param2:Boolean = false) : void
      {
         var _loc4_:Point = null;
         var _loc5_:Point = null;
         if(!stage)
         {
            return;
         }
         switch(param1.type)
         {
            case MouseEvent.MOUSE_DOWN:
               if(!this.dblClickTimer)
               {
                  this.startDblClickTimer();
               }
               if(!this.targetObj.canMoveByMouse())
               {
                  return;
               }
               editor.addEventListener(MouseEvent.MOUSE_MOVE,arguments.callee,false,0,true);
               STAGE.addEventListener(MouseEvent.MOUSE_UP,arguments.callee,false,0,true);
               if(param1.target == this.moveHandle && param1.shiftKey)
               {
                  this.moveOffset = null;
               }
               else
               {
                  this.moveOffset = new Point(parent.mouseX - x,parent.mouseY - y);
               }
               this.wasMoved = false;
               this.setActive(true);
               param1.stopImmediatePropagation();
            case MouseEvent.MOUSE_MOVE:
               if(!editor.getCanvasLayer().getBounds(STAGE).containsPoint(new Point(STAGE.mouseX,STAGE.mouseY)))
               {
                  break;
               }
               if(this.moveOffset)
               {
                  x = parent.mouseX - this.moveOffset.x;
                  y = parent.mouseY - this.moveOffset.y;
                  if(editor is BitmapEdit)
                  {
                     _loc4_ = this.toolsLayer.globalToLocal(localToGlobal(new Point(this.topLeftHandle.x,this.topLeftHandle.y)));
                     _loc5_ = editor.snapToGrid(_loc4_);
                     x += _loc5_.x - _loc4_.x;
                     y += _loc5_.y - _loc4_.y;
                  }
                  this.updateTarget();
               }
               else
               {
                  this.moveHandle.x = mouseX;
                  this.moveHandle.y = mouseY;
               }
               if(param1.type == MouseEvent.MOUSE_MOVE)
               {
                  this.wasMoved = true;
               }
               break;
            case MouseEvent.MOUSE_UP:
               this.setActive(false);
               this.centerMoved = this.moveOffset == null;
               editor.removeEventListener(MouseEvent.MOUSE_MOVE,arguments.callee);
               STAGE.removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
               this.targetObj.saveTransform();
               if(this.wasMoved)
               {
                  dispatchEvent(new Event(Event.CHANGE));
                  this.dblClickTimeout();
               }
         }
      }
      
      private function rotateHandler(param1:MouseEvent) : void
      {
         var _loc3_:Matrix = null;
         var _loc4_:Number = NaN;
         var _loc5_:Point = null;
         switch(param1.type)
         {
            case MouseEvent.MOUSE_DOWN:
               STAGE.addEventListener(MouseEvent.MOUSE_MOVE,arguments.callee,false,0,true);
               STAGE.addEventListener(MouseEvent.MOUSE_UP,arguments.callee,false,0,true);
               param1.stopPropagation();
               this.initialMatrix = transform.matrix.clone();
               this.initialRotation = Math.atan2(this.rotateHandle.y - this.moveHandle.y,this.rotateHandle.x - this.moveHandle.x);
               this.targetObj.startRotation(localToGlobal(new Point(this.moveHandle.x,this.moveHandle.y)));
               this.setActive(true);
               break;
            case MouseEvent.MOUSE_MOVE:
               _loc3_ = this.initialMatrix.clone();
               transform.matrix = _loc3_;
               _loc4_ = Math.atan2(mouseY - this.moveHandle.y,mouseX - this.moveHandle.x);
               _loc5_ = localToGlobal(new Point(this.moveHandle.x,this.moveHandle.y));
               _loc5_ = parent.globalToLocal(_loc5_);
               _loc3_.tx -= _loc5_.x;
               _loc3_.ty -= _loc5_.y;
               _loc3_.rotate(_loc4_ - this.initialRotation);
               _loc3_.tx += _loc5_.x;
               _loc3_.ty += _loc5_.y;
               transform.matrix = _loc3_;
               this.targetObj.doRotation(_loc4_ - this.initialRotation);
               break;
            case MouseEvent.MOUSE_UP:
               this.setActive(false);
               STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,arguments.callee);
               STAGE.removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
               this.targetObj.saveTransform();
               dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      private function updateTarget() : void
      {
         var _loc1_:Point = null;
         if(this.targetObj)
         {
            _loc1_ = localToGlobal(new Point(this.topLeftHandle.x,this.topLeftHandle.y));
            this.targetObj.setTLPosition(_loc1_);
         }
      }
      
      private function showUI() : void
      {
         graphics.clear();
         var _loc1_:Object = this.targetObj.getGlobalBoundingPoints();
         var _loc2_:Point = globalToLocal(_loc1_.topLeft);
         var _loc3_:Point = globalToLocal(_loc1_.topRight);
         var _loc4_:Point = globalToLocal(_loc1_.botLeft);
         var _loc5_:Point = globalToLocal(_loc1_.botRight);
         var _loc6_:uint = this.targetObj.isGroup() ? grpDashLength : (this.targetObj.isImage() ? bmDashLength : dashLength);
         var _loc7_:uint = this.targetObj.isGroup() ? grpDashColor : (this.targetObj.isImage() ? bmDashColor : dashColor);
         graphics.lineStyle(2,_loc7_);
         graphics.moveTo(_loc2_.x,_loc2_.y);
         graphics.lineTo(_loc3_.x,_loc3_.y);
         graphics.lineTo(_loc5_.x,_loc5_.y);
         graphics.lineTo(_loc4_.x,_loc4_.y);
         graphics.lineTo(_loc2_.x,_loc2_.y);
         if(!this.centerMoved)
         {
            this.moveHandle.x = (_loc2_.x + _loc5_.x) / 2;
            this.moveHandle.y = (_loc2_.y + _loc5_.y) / 2;
         }
         this.topLeftHandle.x = _loc2_.x;
         this.topLeftHandle.y = _loc2_.y;
         this.topRightHandle.x = _loc3_.x;
         this.topRightHandle.y = _loc3_.y;
         this.bottomLeftHandle.x = _loc4_.x;
         this.bottomLeftHandle.y = _loc4_.y;
         this.bottomRightHandle.x = _loc5_.x;
         this.bottomRightHandle.y = _loc5_.y;
         this.topHandle.x = (_loc2_.x + _loc3_.x) / 2;
         this.topHandle.y = (_loc2_.y + _loc3_.y) / 2;
         this.leftHandle.x = (_loc2_.x + _loc4_.x) / 2;
         this.leftHandle.y = (_loc2_.y + _loc4_.y) / 2;
         this.bottomHandle.x = (_loc4_.x + _loc5_.x) / 2;
         this.bottomHandle.y = (_loc4_.y + _loc5_.y) / 2;
         this.rightHandle.x = (_loc3_.x + _loc5_.x) / 2;
         this.rightHandle.y = (_loc3_.y + _loc5_.y) / 2;
         var _loc8_:Point = new Point(this.topHandle.x - this.moveHandle.x,this.topHandle.y - this.moveHandle.y);
         _loc8_.normalize(20);
         this.rotateHandle.x = this.topHandle.x + _loc8_.x;
         this.rotateHandle.y = this.topHandle.y + _loc8_.y;
         graphics.moveTo(this.topHandle.x,this.topHandle.y);
         graphics.lineTo(this.rotateHandle.x,this.rotateHandle.y);
         x = y = 0;
      }
      
      private function selectionBoxHandler(param1:MouseEvent) : void
      {
         var _loc3_:Point = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Rectangle = null;
         var _loc9_:Point = null;
         var _loc10_:Number = NaN;
         var _loc11_:Rectangle = null;
         var _loc12_:SVGBitmap = null;
         if(this.selectionOrigin)
         {
            _loc3_ = editor.snapToGrid(new Point(this.toolsLayer.mouseX,this.toolsLayer.mouseY));
            _loc4_ = Math.min(this.selectionOrigin.x,_loc3_.x);
            _loc5_ = Math.min(this.selectionOrigin.y,_loc3_.y);
            _loc6_ = Math.max(this.selectionOrigin.x,_loc3_.x);
            _loc7_ = Math.max(this.selectionOrigin.y,_loc3_.y);
            _loc8_ = new Rectangle(_loc4_,_loc5_,_loc6_ - _loc4_,_loc7_ - _loc5_);
         }
         switch(param1.type)
         {
            case MouseEvent.MOUSE_DOWN:
               if(editor.revertToCreateTool(param1))
               {
                  return;
               }
               STAGE.addEventListener(MouseEvent.MOUSE_MOVE,arguments.callee,false,0,true);
               STAGE.addEventListener(MouseEvent.MOUSE_UP,arguments.callee,false,0,true);
               this.selectionOrigin = editor.snapToGrid(new Point(this.toolsLayer.mouseX,this.toolsLayer.mouseY));
               currentEvent = null;
               this.select(null);
               break;
            case MouseEvent.MOUSE_MOVE:
               this.toolsLayer.graphics.clear();
               if(editor is BitmapEdit)
               {
                  this.toolsLayer.graphics.lineStyle(1,4210752);
                  this.toolsLayer.graphics.drawRect(_loc8_.x,_loc8_.y,_loc8_.width,_loc8_.height);
               }
               else
               {
                  DashDrawer.drawBox(this.toolsLayer.graphics,_loc8_,3,255);
               }
               break;
            case MouseEvent.MOUSE_UP:
               this.toolsLayer.graphics.clear();
               STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,arguments.callee);
               STAGE.removeEventListener(MouseEvent.MOUSE_UP,arguments.callee);
               if(editor is BitmapEdit)
               {
                  _loc9_ = this.contentLayer.globalToLocal(this.toolsLayer.localToGlobal(_loc8_.topLeft));
                  _loc10_ = editor.getWorkArea().getScale();
                  _loc11_ = new Rectangle(Math.floor(_loc9_.x * 2),Math.floor(_loc9_.y * 2),Math.ceil(_loc8_.width / _loc10_ * 2),Math.ceil(_loc8_.height / _loc10_ * 2));
                  _loc12_ = (editor as BitmapEdit).getSelection(_loc11_);
                  if(_loc12_)
                  {
                     this.select(new Selection([_loc12_]));
                  }
               }
               else
               {
                  this.attemptSelect(_loc8_);
               }
         }
      }
      
      private function attemptSelect(param1:Rectangle) : void
      {
         var _loc6_:DisplayObject = null;
         var _loc7_:Rectangle = null;
         var _loc2_:Number = param1.width * 0.2;
         var _loc3_:Number = param1.height * 0.2;
         param1.top -= _loc3_;
         param1.bottom += _loc3_;
         param1.left -= _loc2_;
         param1.right += _loc2_;
         var _loc4_:Array = new Array();
         var _loc5_:int = 0;
         while(_loc5_ < this.contentLayer.numChildren)
         {
            _loc6_ = DisplayObject(this.contentLayer.getChildAt(_loc5_));
            _loc7_ = _loc6_.getRect(this.toolsLayer);
            if(_loc6_ is ISVGEditable && param1.containsRect(_loc7_) && _loc4_.indexOf(_loc6_) == -1 && !(_loc6_ as ISVGEditable).getElement().isBackDropBG())
            {
               _loc4_.push(_loc6_);
            }
            _loc5_++;
         }
         if(_loc4_.length > 0)
         {
            this.select(new Selection(_loc4_));
         }
         else
         {
            this.select(null);
         }
      }
   }
}

