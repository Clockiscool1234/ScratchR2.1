package svgeditor.tools
{
   import assets.Resources;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BlendMode;
   import flash.display.CapsStyle;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import svgeditor.DrawProperties;
   import svgeditor.ImageEdit;
   import svgeditor.objs.ISVGEditable;
   import svgeditor.objs.SVGBitmap;
   import svgeditor.objs.SVGShape;
   import svgutils.SVGExport;
   import svgutils.SVGPath;
   
   public final class EraserTool extends SVGTool
   {
      
      private var eraserShape:Shape;
      
      private var lastPos:Point;
      
      private var eraserWidth:Number;
      
      private var erased:Boolean;
      
      public function EraserTool(param1:ImageEdit)
      {
         super(param1);
         touchesContent = true;
         this.eraserShape = new Shape();
         this.lastPos = null;
         this.erased = false;
         cursorHotSpot = new Point(7,18);
      }
      
      public function updateIcon() : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:Shape = null;
         var _loc4_:BitmapData = null;
         var _loc5_:Matrix = null;
         var _loc1_:DrawProperties = editor.getShapeProps();
         if(this.eraserWidth != _loc1_.eraserWidth)
         {
            _loc2_ = Resources.createBmp("eraserOff");
            _loc3_ = new Shape();
            _loc3_.graphics.lineStyle(1);
            _loc3_.graphics.drawCircle(0,0,_loc1_.eraserWidth * 0.65);
            _loc4_ = new BitmapData(32,32,true,0);
            _loc5_ = new Matrix();
            _loc5_.translate(16,18);
            _loc4_.draw(_loc3_,_loc5_);
            _loc5_.translate(-cursorHotSpot.x,-cursorHotSpot.y);
            _loc4_.draw(_loc2_,_loc5_);
            editor.setCurrentCursor("eraserOff",_loc4_,new Point(16,18),false);
            this.eraserWidth = _loc1_.eraserWidth;
         }
      }
      
      override protected function init() : void
      {
         super.init();
         editor.getWorkArea().addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
         STAGE.addChild(this.eraserShape);
         this.updateIcon();
      }
      
      override protected function shutdown() : void
      {
         editor.getWorkArea().removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         super.shutdown();
         STAGE.removeChild(this.eraserShape);
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         editor.getWorkArea().addEventListener(MouseEvent.MOUSE_MOVE,this.erase,false,0,true);
         STAGE.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp,false,0,true);
         this.eraserWidth = editor.getShapeProps().eraserWidth;
         this.erase();
      }
      
      private function mouseUp(param1:MouseEvent) : void
      {
         editor.getWorkArea().removeEventListener(MouseEvent.MOUSE_MOVE,this.erase);
         STAGE.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         this.erase();
         this.lastPos = null;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function erase(param1:MouseEvent = null) : void
      {
         this.updateEraserShape();
         this.erased = false;
         var _loc2_:Array = this.getObjectsUnderEraser();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            this.eraseObj(_loc2_[_loc3_]);
            _loc3_++;
         }
         this.lastPos = new Point(this.eraserShape.mouseX,this.eraserShape.mouseY);
      }
      
      private function getObjectsUnderEraser() : Array
      {
         var _loc1_:Array = [];
         var _loc2_:Sprite = editor.getContentLayer();
         this.testObjectsOnLayer(_loc2_,_loc1_);
         return _loc1_;
      }
      
      private function testObjectsOnLayer(param1:Sprite, param2:Array) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is Sprite)
            {
               this.testObjectsOnLayer(_loc4_ as Sprite,param2);
            }
            else if(_loc4_ is ISVGEditable && _loc4_.hitTestObject(this.eraserShape))
            {
               if(!(_loc4_ is SVGShape && (_loc4_ as SVGShape).getElement().isBackDropBG()))
               {
                  param2.push(_loc4_);
               }
            }
            _loc3_++;
         }
      }
      
      private function eraseObj(param1:ISVGEditable) : void
      {
         var _loc2_:SVGBitmap = null;
         var _loc3_:SVGShape = null;
         this.eraserShape.visible = true;
         if(param1 is SVGBitmap)
         {
            _loc2_ = param1 as SVGBitmap;
            this.eraseFromBitmap(_loc2_);
         }
         else if(param1 is SVGShape)
         {
            _loc3_ = param1 as SVGShape;
            if(_loc3_.getElement().getAttribute("stroke") !== "none")
            {
               this.eraseFromShape(_loc3_);
            }
         }
         this.eraserShape.visible = false;
      }
      
      private function updateEraserShape() : void
      {
         var _loc1_:Graphics = this.eraserShape.graphics;
         _loc1_.clear();
         var _loc2_:Point = new Point(this.eraserShape.mouseX,this.eraserShape.mouseY);
         if(this.lastPos)
         {
            _loc1_.lineStyle(this.eraserWidth,16711680,1,false,LineScaleMode.NORMAL,CapsStyle.ROUND);
            _loc1_.moveTo(this.lastPos.x,this.lastPos.y);
            _loc1_.lineTo(_loc2_.x,_loc2_.y);
         }
         else
         {
            _loc1_.lineStyle(0,0,0);
            _loc1_.beginFill(16711680);
            _loc1_.drawCircle(_loc2_.x,_loc2_.y,this.eraserWidth * 0.65);
            _loc1_.endFill();
            _loc1_.moveTo(_loc2_.x,_loc2_.y);
         }
         this.eraserShape.visible = true;
         this.eraserShape.visible = false;
      }
      
      private function eraseFromBitmap(param1:Bitmap) : void
      {
         this.eraserShape.alpha = 1;
         var _loc2_:Matrix = param1.transform.concatenatedMatrix;
         _loc2_.invert();
         param1.bitmapData.draw(this.eraserShape,_loc2_,null,BlendMode.ERASE,null);
         var _loc3_:Rectangle = param1.bitmapData.getColorBoundsRect(4278190080,0,false);
         if(!_loc3_ || _loc3_.width == 0 || _loc3_.height == 0)
         {
            param1.parent.removeChild(param1);
         }
         this.eraserShape.alpha = 0.5;
      }
      
      private function eraseFromShape(param1:SVGShape) : void
      {
         var _loc9_:int = 0;
         var _loc10_:Object = null;
         var _loc11_:int = 0;
         var _loc12_:Array = null;
         var _loc13_:uint = 0;
         var _loc14_:Number = NaN;
         var _loc15_:Point = null;
         var _loc16_:Array = null;
         var _loc17_:Number = NaN;
         var _loc18_:ISVGEditable = null;
         var _loc19_:Array = null;
         var _loc20_:int = 0;
         var _loc21_:SVGShape = null;
         if(!PixelPerfectCollisionDetection.isColliding(param1,this.eraserShape))
         {
            return;
         }
         var _loc2_:* = param1.getElement().getAttribute("stroke-width");
         var _loc3_:* = param1.getElement().getAttribute("stroke-linecap");
         param1.getElement().setAttribute("stroke-linecap","butt");
         param1.redraw();
         if(param1.getElement().tag != "path")
         {
            param1.getElement().convertToPath();
         }
         param1.distCheck = SVGShape.eraserDistCheck;
         var _loc4_:Array = param1.getAllIntersectionsWithShape(this.eraserShape,true);
         if(_loc4_.length)
         {
            this.erased = true;
         }
         var _loc5_:SVGPath = param1.getElement().path;
         var _loc6_:int = int(_loc5_.length);
         var _loc7_:int = -1;
         var _loc8_:int = 0;
         while(_loc8_ < _loc4_.length)
         {
            _loc9_ = _loc5_.length - _loc6_;
            _loc10_ = _loc4_[_loc8_];
            _loc11_ = _loc10_.start.index + _loc9_;
            _loc12_ = _loc5_.getSegmentEndPoints(_loc11_);
            if(_loc12_[2])
            {
               if(param1.getElement().getAttribute("fill") != "none" && param1.getElement().getAttribute("fill-opacity") !== 0)
               {
                  _loc18_ = param1.clone();
                  _loc18_.getElement().setAttribute("stroke","none");
                  _loc18_.getElement().setAttribute("stroke-width",null);
                  _loc18_.redraw();
                  param1.parent.addChildAt(_loc18_ as DisplayObject,param1.parent.getChildIndex(param1));
               }
               _loc7_ = int(_loc12_[1]);
               _loc5_.splice(_loc12_[1] + 1,1);
            }
            _loc13_ = Math.min(_loc10_.end.index + _loc9_,_loc12_[1]);
            _loc14_ = Number(_loc10_.end.time);
            _loc13_ = _loc5_.splitCurve(_loc13_,_loc14_);
            _loc15_ = _loc5_.getPos(_loc13_);
            _loc16_ = _loc5_.slice(_loc13_ + 1);
            _loc17_ = Number(_loc10_.start.time);
            if(_loc11_ == _loc10_.end.index + _loc9_)
            {
               _loc17_ /= _loc14_;
            }
            _loc11_ = int(_loc5_.splitCurve(_loc11_,_loc17_));
            _loc5_.length = _loc11_ + 1;
            _loc5_.push(["M",_loc15_.x,_loc15_.y]);
            _loc5_.push.apply(_loc5_,_loc16_);
            _loc8_++;
         }
         param1.getElement().setAttribute("stroke-width",_loc2_);
         param1.getElement().setAttribute("stroke-linecap",_loc3_);
         param1.redraw();
         if(_loc4_.length)
         {
            _loc5_.removeInvalidSegments(_loc2_);
            if(_loc7_ > 0)
            {
               _loc12_ = _loc5_.getSegmentEndPoints(_loc7_);
               _loc19_ = _loc5_.splice(_loc12_[0],_loc12_[1] + 1);
               _loc20_ = _loc19_.length - 1;
               _loc19_.unshift(1);
               _loc19_.unshift(0);
               _loc5_.splice.apply(_loc5_,_loc19_);
               _loc5_.adjustPathAroundAnchor(_loc20_,2);
               _loc5_.adjustPathAroundAnchor(0,2);
               _loc12_ = _loc5_.getSegmentEndPoints(0);
               param1.redraw();
            }
            if(_loc5_.length < 2)
            {
               param1.parent.removeChild(param1);
            }
            else
            {
               _loc12_ = _loc5_.getSegmentEndPoints(0);
               param1.getElement().setAttribute("fill","none");
               if(_loc12_[1] < _loc5_.length - 1)
               {
                  _loc21_ = param1.clone() as SVGShape;
                  _loc21_.getElement().path = _loc5_.clone();
                  _loc21_.getElement().path.splice(0,_loc12_[1] + 1);
                  _loc21_.getElement().setAttribute("d",SVGExport.pathCmds(_loc21_.getElement().path));
                  _loc21_.redraw();
                  _loc21_.getElement().path.setDirty();
                  param1.parent.addChildAt(_loc21_,param1.parent.getChildIndex(param1));
                  _loc5_.length = _loc12_[1] + 1;
               }
               param1.getElement().setAttribute("d",SVGExport.pathCmds(_loc5_));
               param1.getElement().path.setDirty();
               param1.redraw();
            }
         }
      }
   }
}

