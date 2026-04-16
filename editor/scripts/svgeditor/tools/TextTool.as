package svgeditor.tools
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.utils.Timer;
   import svgeditor.*;
   import svgeditor.objs.ISVGEditable;
   import svgeditor.objs.SVGTextField;
   import svgutils.SVGElement;
   
   public final class TextTool extends SVGEditTool
   {
      
      private static const dashLength:uint = 3;
      
      private static const dashColor:uint = 13421772;
      
      private var created:Boolean;
      
      public function TextTool(param1:ImageEdit)
      {
         super(param1,"text");
         cursorName = "ibeam";
      }
      
      override protected function init() : void
      {
         super.init();
         if(object)
         {
            STAGE.focus = object as SVGTextField;
         }
         editor.getContentLayer().removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         editor.getWorkArea().addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
         this.created = false;
      }
      
      override protected function shutdown() : void
      {
         this.endEdit();
         editor.getWorkArea().removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         super.shutdown();
      }
      
      private function handleEvents(param1:Event) : void
      {
         var _loc2_:KeyboardEvent = null;
         if(param1 is KeyboardEvent)
         {
            _loc2_ = param1 as KeyboardEvent;
            if(_loc2_.keyCode == 27)
            {
               STAGE.focus = null;
               editor.endCurrentTool(object);
               param1.stopImmediatePropagation();
            }
         }
         else if(param1 is Event)
         {
            this.saveState();
            this.drawDashedBorder();
         }
      }
      
      override protected function edit(param1:ISVGEditable, param2:MouseEvent) : void
      {
         var s:Sprite;
         var tf:SVGTextField = null;
         var focusTimer:Timer = null;
         var obj:ISVGEditable = param1;
         var e:MouseEvent = param2;
         super.edit(obj,e);
         graphics.clear();
         if(!object)
         {
            return;
         }
         tf = object as SVGTextField;
         if(tf.type != TextFieldType.INPUT)
         {
            tf.type = TextFieldType.INPUT;
            tf.selectable = true;
            tf.autoSize = TextFieldAutoSize.LEFT;
         }
         else
         {
            focusTimer = new Timer(1);
            focusTimer.addEventListener(TimerEvent.TIMER,function(param1:Event):void
            {
               focusTimer.removeEventListener(TimerEvent.TIMER,arguments.callee);
               focusTimer.stop();
               tf.autoSize = TextFieldAutoSize.LEFT;
               tf.selectable = true;
            },false,0,true);
            focusTimer.start();
         }
         tf.addEventListener(KeyboardEvent.KEY_DOWN,this.handleEvents,false,0,true);
         tf.addEventListener(Event.CHANGE,this.handleEvents,false,0,true);
         if(STAGE.focus != tf)
         {
            STAGE.focus = tf;
         }
         if(tf.text == " ")
         {
            tf.text = "";
         }
         if(editor is SVGEdit)
         {
            tf.filters = [new DropShadowFilter(4,45,0,0.3)];
         }
         s = new Sprite();
         s.transform.matrix = (object as DisplayObject).transform.concatenatedMatrix.clone();
         rotation = s.rotation;
         this.drawDashedBorder();
      }
      
      override public function refresh() : void
      {
         if(object)
         {
            this.drawDashedBorder();
         }
      }
      
      private function drawDashedBorder() : void
      {
         graphics.clear();
         DashDrawer.drawBox(graphics,(object as SVGTextField).getBounds(this),dashLength,dashColor);
      }
      
      private function endEdit() : void
      {
         graphics.clear();
         if(!object)
         {
            return;
         }
         var _loc1_:SVGTextField = object as SVGTextField;
         _loc1_.type = TextFieldType.DYNAMIC;
         _loc1_.autoSize = TextFieldAutoSize.NONE;
         _loc1_.selectable = false;
         _loc1_.background = false;
         _loc1_.removeEventListener(KeyboardEvent.KEY_DOWN,this.handleEvents);
         _loc1_.removeEventListener(Event.CHANGE,this.handleEvents);
         this.saveState();
         if(editor is SVGEdit)
         {
            _loc1_.filters = [];
         }
         if(_loc1_.text == "" || _loc1_.text == " ")
         {
            _loc1_.parent.removeChild(_loc1_);
         }
         setObject(null);
      }
      
      private function saveState() : void
      {
         if(!object)
         {
            return;
         }
         var _loc1_:SVGTextField = object as SVGTextField;
         object.getElement().text = (object as SVGTextField).text;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      override public function mouseDown(param1:MouseEvent) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Sprite = null;
         var _loc7_:SVGElement = null;
         var _loc8_:SVGTextField = null;
         var _loc9_:Point = null;
         var _loc10_:Number = NaN;
         var _loc2_:Boolean = !!object;
         var _loc3_:ISVGEditable = getEditableUnderMouse(false);
         var _loc4_:ISVGEditable = object;
         if(_loc3_ != object)
         {
            if(!_loc3_ && Boolean(object))
            {
               _loc5_ = object as DisplayObject;
               if(_loc5_.getBounds(_loc5_).contains(_loc5_.mouseX,_loc5_.mouseY))
               {
                  return;
               }
            }
            this.endEdit();
            if(_loc3_ is SVGTextField)
            {
               this.edit(_loc3_,null);
            }
            else
            {
               setObject(null);
            }
         }
         if(!object)
         {
            if(Boolean(_loc2_) && Boolean((_loc4_ as SVGTextField).text.length) && (_loc4_ as SVGTextField).text != " ")
            {
               editor.endCurrentTool(this.created ? _loc4_ : null);
               param1.stopPropagation();
            }
            else
            {
               _loc6_ = editor.getContentLayer();
               _loc7_ = new SVGElement("text","");
               _loc7_.setAttribute("text-anchor","start");
               _loc7_.text = "";
               _loc7_.setShapeFill(editor.getShapeProps());
               _loc7_.setFont(editor.getShapeProps().fontName,22);
               _loc8_ = new SVGTextField(_loc7_);
               _loc6_.addChild(_loc8_);
               _loc8_.redraw();
               _loc9_ = new Point(_loc6_.mouseX,_loc6_.mouseY);
               _loc10_ = _loc8_.getLineMetrics(0).ascent;
               _loc8_.x = _loc9_.x;
               _loc8_.y = _loc9_.y - _loc8_.textHeight;
               _loc7_.setAttribute("x",_loc8_.x + 2);
               _loc7_.setAttribute("y",_loc8_.y + _loc10_ + 2);
               _loc7_.transform = _loc8_.transform.matrix.clone();
               this.saveState();
               this.edit(_loc8_,null);
               this.created = true;
            }
         }
      }
   }
}

