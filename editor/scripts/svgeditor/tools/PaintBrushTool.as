package svgeditor.tools
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import svgeditor.DrawProperties;
   import svgeditor.ImageEdit;
   import svgeditor.objs.ISVGEditable;
   import svgeditor.objs.SVGShape;
   import svgeditor.objs.SVGTextField;
   import svgutils.SVGElement;
   
   public final class PaintBrushTool extends SVGEditTool
   {
      
      private var shapeUnderMouse:ISVGEditable;
      
      private var overStroke:Boolean;
      
      private var oldStrokeW:*;
      
      private var oldStrokeO:*;
      
      private var oldStroke:*;
      
      private var oldFill:*;
      
      private var isOverStroke:Boolean;
      
      public function PaintBrushTool(param1:ImageEdit)
      {
         super(param1);
         cursorBMName = "vpaintbrushOff";
         cursorHotSpot = new Point(17,16);
      }
      
      override protected function edit(param1:ISVGEditable, param2:MouseEvent) : void
      {
         if(this.shapeUnderMouse)
         {
            dispatchEvent(new Event(Event.CHANGE));
            this.shapeUnderMouse = null;
         }
      }
      
      override protected function init() : void
      {
         super.init();
         editor.getContentLayer().addEventListener(MouseEvent.ROLL_OVER,this.rollOver,false,0,true);
         editor.getContentLayer().addEventListener(MouseEvent.ROLL_OUT,this.rollOut,false,0,true);
      }
      
      override protected function shutdown() : void
      {
         editor.getContentLayer().removeEventListener(MouseEvent.ROLL_OVER,this.rollOver);
         editor.getContentLayer().removeEventListener(MouseEvent.ROLL_OUT,this.rollOut);
         editor.getContentLayer().removeEventListener(MouseEvent.MOUSE_MOVE,this.previewColorChange);
         super.shutdown();
      }
      
      private function rollOver(param1:MouseEvent) : void
      {
         editor.getContentLayer().addEventListener(MouseEvent.MOUSE_MOVE,this.previewColorChange,false,0,true);
         this.previewColorChange(param1);
      }
      
      private function rollOut(param1:MouseEvent) : void
      {
         editor.getContentLayer().removeEventListener(MouseEvent.MOUSE_MOVE,this.previewColorChange);
         this.previewColorChange();
      }
      
      private function previewColorChange(param1:MouseEvent = null) : void
      {
         var _loc3_:SVGElement = null;
         var _loc4_:* = undefined;
         var _loc5_:Number = NaN;
         var _loc2_:ISVGEditable = param1 ? getEditableUnderMouse(false) : null;
         if(!(_loc2_ is SVGShape || _loc2_ is SVGTextField))
         {
            _loc2_ = null;
         }
         if(Boolean(this.shapeUnderMouse) && this.shapeUnderMouse != _loc2_)
         {
            _loc3_ = this.shapeUnderMouse.getElement();
            _loc3_.setAttribute("fill",this.oldFill);
            _loc3_.setAttribute("stroke",this.oldStroke);
            _loc3_.setAttribute("stroke-width",this.oldStrokeW);
            _loc3_.setAttribute("stroke-opacity",this.oldStrokeO);
            this.shapeUnderMouse.redraw();
         }
         if(_loc2_)
         {
            _loc4_ = this.getFillValue(_loc2_);
            _loc5_ = editor.getShapeProps().alpha;
            _loc3_ = _loc2_.getElement();
            if(this.shapeUnderMouse != _loc2_)
            {
               this.oldFill = _loc3_.getAttribute("fill");
               this.oldStroke = _loc3_.getAttribute("stroke");
               this.oldStrokeW = _loc3_.getAttribute("stroke-width");
               this.oldStrokeO = _loc3_.getAttribute("stroke-opacity",1);
            }
            if(!_loc3_.isBackDropFill() && !(_loc2_ is SVGTextField))
            {
               _loc3_.setAttribute("fill","none");
               _loc3_.setAttribute("stroke-opacity",1);
               if(this.oldStroke == "none" || this.oldStrokeW < 2)
               {
                  _loc3_.setAttribute("stroke","black");
                  if(this.oldStrokeW < 2 || this.oldStrokeW == null)
                  {
                     _loc3_.setAttribute("stroke-width",2);
                  }
               }
               _loc2_.redraw(true);
               this.isOverStroke = (_loc2_ as DisplayObject).hitTestPoint(STAGE.mouseX,STAGE.mouseY,true);
            }
            else
            {
               this.isOverStroke = false;
            }
            if(this.isOverStroke)
            {
               if(_loc5_ > 0 || _loc4_ is SVGElement)
               {
                  _loc3_.setAttribute("stroke",_loc4_);
                  _loc3_.setAttribute("stroke-opacity",_loc5_);
               }
               else
               {
                  _loc3_.setAttribute("stroke-opacity",0);
               }
               _loc3_.setAttribute("fill",this.oldFill);
            }
            else
            {
               if(_loc5_ > 0 || _loc4_ is SVGElement)
               {
                  _loc3_.setAttribute("fill",_loc4_);
               }
               else
               {
                  _loc3_.setAttribute("fill","none");
               }
               _loc3_.setAttribute("stroke-opacity",this.oldStrokeO);
               _loc3_.setAttribute("stroke",this.oldStroke);
               _loc3_.setAttribute("stroke-width",this.oldStrokeW);
            }
            _loc2_.redraw();
         }
         this.shapeUnderMouse = _loc2_;
      }
      
      private function getFillValue(param1:ISVGEditable) : *
      {
         var _loc6_:Rectangle = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         if(editor.getShapeProps().fillType == "solid" || !(param1 is SVGShape))
         {
            return SVGElement.colorToHex(editor.getShapeProps().color);
         }
         var _loc2_:String = editor.getShapeProps().fillType == "radial" ? "radialGradient" : "linearGradient";
         var _loc3_:SVGElement = new SVGElement(_loc2_,"grad" + Math.floor(Math.random() * 1000));
         if(_loc2_ == "radialGradient")
         {
            _loc6_ = (param1 as DisplayObject).getBounds(param1 as DisplayObject);
            _loc7_ = _loc6_.topLeft;
            _loc8_ = new Point((param1 as DisplayObject).mouseX,(param1 as DisplayObject).mouseY);
            _loc9_ = (_loc8_.x - _loc7_.x) / _loc6_.width;
            _loc10_ = (_loc8_.y - _loc7_.y) / _loc6_.height;
            _loc11_ = Math.floor(_loc9_ * 10000) / 100;
            _loc12_ = Math.floor(_loc10_ * 10000) / 100;
            _loc3_.setAttribute("cx",_loc11_ + "%");
            _loc3_.setAttribute("cy",_loc12_ + "%");
            _loc3_.setAttribute("r",65 + 1.3 * Math.max(Math.abs(_loc11_ - 50),Math.abs(_loc12_ - 50)) + "%");
         }
         else
         {
            _loc3_.setAttribute("x1","0%");
            _loc3_.setAttribute("y1","0%");
            if(editor.getShapeProps().fillType == "linearHorizontal")
            {
               _loc3_.setAttribute("x2","100%");
               _loc3_.setAttribute("y2","0%");
            }
            else
            {
               _loc3_.setAttribute("x2","0%");
               _loc3_.setAttribute("y2","100%");
            }
         }
         var _loc4_:DrawProperties = editor.getShapeProps();
         var _loc5_:SVGElement = new SVGElement("stop");
         _loc5_.setAttribute("offset",0);
         _loc5_.setAttribute("stop-color",SVGElement.colorToHex(_loc4_.alpha > 0 ? _loc4_.color : _loc4_.secondColor));
         _loc5_.setAttribute("stop-opacity",_loc4_.alpha);
         _loc3_.subElements.push(_loc5_);
         _loc5_ = new SVGElement("stop");
         _loc5_.setAttribute("offset",1);
         _loc5_.setAttribute("stop-color",SVGElement.colorToHex(_loc4_.secondAlpha > 0 ? _loc4_.secondColor : _loc4_.color));
         _loc5_.setAttribute("stop-opacity",_loc4_.secondAlpha);
         _loc3_.subElements.push(_loc5_);
         return _loc3_;
      }
   }
}

