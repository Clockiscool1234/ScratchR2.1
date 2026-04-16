package svgeditor.tools
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import svgeditor.*;
   import svgeditor.objs.SVGShape;
   import svgutils.*;
   
   public final class PathTool extends SVGCreateTool
   {
      
      private static var testWidth:Number = 1;
      
      private static const dotProd:Number = 0.985;
      
      private var newElement:SVGElement;
      
      private var gfx:Graphics;
      
      private var svgShape:SVGShape;
      
      private var shiftDown:Boolean;
      
      private var strokeWidth:Number;
      
      private var pathContinued:SVGShape;
      
      private var previewShape:Shape;
      
      private var indexContinued:int;
      
      private var endContinued:Boolean;
      
      private var endMerge:Boolean;
      
      private var linesOnly:Boolean;
      
      private var smoothness:Number;
      
      private var lastSaveTime:uint;
      
      private var beforeLastSavePt:Point;
      
      private var lastSavePt:Point;
      
      private var lastSaveC2:Point;
      
      private var lastSaveDir:Point;
      
      private var lastSaveDev:Point;
      
      private var lastMousePt:Point;
      
      public function PathTool(param1:ImageEdit, param2:Boolean = false)
      {
         super(param1,false);
         this.linesOnly = param2;
         cursorBMName = "pencilCursor";
         cursorHotSpot = new Point(0,16);
         this.shiftDown = false;
         this.pathContinued = null;
         this.indexContinued = -1;
         this.endContinued = false;
         this.endMerge = false;
         this.previewShape = new Shape();
      }
      
      override protected function init() : void
      {
         super.init();
         if(!this.linesOnly)
         {
            STAGE.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPress,false,0,true);
            STAGE.addEventListener(KeyboardEvent.KEY_UP,this.onKeyRelease,false,0,true);
         }
         editor.getToolsLayer().mouseEnabled = false;
         mouseEnabled = false;
         mouseChildren = false;
         this.strokeWidth = editor.getShapeProps().strokeWidth;
         this.smoothness = editor.getStrokeSmoothness() * 0.01;
         if(editor is SVGEdit)
         {
            PathEndPointManager.makeEndPoints();
         }
      }
      
      override protected function shutdown() : void
      {
         STAGE.removeEventListener(KeyboardEvent.KEY_DOWN,this.onKeyPress);
         STAGE.removeEventListener(KeyboardEvent.KEY_UP,this.onKeyRelease);
         editor.getToolsLayer().mouseEnabled = true;
         PathEndPointManager.removeEndPoints();
         if(this.previewShape.parent)
         {
            this.previewShape.parent.removeChild(this.previewShape);
         }
         super.shutdown();
      }
      
      private function onKeyPress(param1:KeyboardEvent) : void
      {
         this.shiftDown = param1.shiftKey;
      }
      
      private function onKeyRelease(param1:KeyboardEvent) : void
      {
         this.shiftDown = param1.shiftKey;
         if(currentEvent)
         {
            currentEvent.shiftKey = param1.shiftKey;
         }
      }
      
      override protected function mouseDown(param1:Point) : void
      {
         var _loc2_:DrawProperties = editor.getShapeProps();
         if(_loc2_.strokeWidth == 0)
         {
            _loc2_.strokeWidth = 2;
         }
         this.smoothness = editor.getStrokeSmoothness() * 0.01;
         if(_loc2_.alpha == 0 || _loc2_.strokeWidth < 0.01)
         {
            return;
         }
         PathEndPointManager.toggleEndPoint(false);
         this.beforeLastSavePt = null;
         this.lastSavePt = null;
         this.lastSaveC2 = null;
         this.lastSaveDir = null;
         this.lastSaveDev = null;
         this.lastMousePt = null;
         this.newElement = new SVGElement("path",null);
         this.newElement.setAttribute("d"," ");
         this.newElement.setShapeStroke(editor.getShapeProps());
         this.newElement.setAttribute("fill","none");
         this.newElement.setAttribute("stroke-linecap","round");
         this.newElement.path = new SVGPath();
         this.svgShape = new SVGShape(this.newElement);
         contentLayer.addChild(this.svgShape);
         contentLayer.addChild(this.previewShape);
         newObject = this.svgShape;
         var _loc3_:Number = Number(this.newElement.getAttribute("opacity",1));
         _loc3_ = Math.max(0,Math.min(_loc3_,1));
         this.shiftDown = currentEvent.shiftKey;
         this.lastSaveTime = new Date().time;
         this.processMousePos(param1);
         var _loc4_:Object = this.getContinuableShape();
         if(_loc4_)
         {
            this.pathContinued = _loc4_.shape as SVGShape;
            this.endContinued = _loc4_.bEnd;
            this.indexContinued = _loc4_.index;
            this.endMerge = false;
            this.strokeWidth = this.pathContinued.getElement().getAttribute("stroke-width",1);
            this.newElement.setAttribute("stroke-width",this.strokeWidth);
            this.newElement.setAttribute("stroke",this.pathContinued.getElement().getAttribute("stroke"));
            PathEndPointManager.makeEndPoints(this.pathContinued.parent as Sprite);
         }
         else
         {
            this.strokeWidth = this.newElement.getAttribute("stroke-width",1);
         }
         this.gfx = this.svgShape.graphics;
         this.setLineStyle(this.gfx);
         this.setLineStyle(this.previewShape.graphics);
         this.gfx.moveTo(param1.x,param1.y);
      }
      
      private function setLineStyle(param1:Graphics) : void
      {
         var _loc2_:String = this.newElement.getAttribute("stroke");
         if(Boolean(_loc2_) && _loc2_ != "none")
         {
            param1.lineStyle(this.newElement.getAttribute("stroke-width",1),this.newElement.getColorValue(_loc2_),alpha);
         }
         else
         {
            param1.lineStyle(NaN);
         }
      }
      
      override protected function mouseMove(param1:Point) : void
      {
         var _loc3_:SVGShape = null;
         var _loc4_:SVGPath = null;
         if(!editor.isActive())
         {
            return;
         }
         this.shiftDown = currentEvent.shiftKey;
         if(this.newElement)
         {
            if(new Date().time - this.lastSaveTime < 100)
            {
               return;
            }
            if(this.linesOnly && this.shiftDown)
            {
               param1 = this.constrainToVericalOrHorizontal(this.lastSavePt,param1);
            }
            if(this.linesOnly)
            {
               this.previewShape.graphics.clear();
               this.setLineStyle(this.previewShape.graphics);
               this.previewShape.graphics.moveTo(this.lastSavePt.x,this.lastSavePt.y);
               this.previewShape.graphics.lineTo(param1.x,param1.y);
            }
            else
            {
               this.lastSaveTime = new Date().time;
               this.processMousePos(param1);
            }
         }
         var _loc2_:Object = this.getContinuableShape();
         if(_loc2_)
         {
            _loc3_ = _loc2_.shape;
            _loc4_ = _loc3_.getElement().path;
            param1 = editor.getToolsLayer().globalToLocal(_loc3_.localToGlobal(_loc4_.getPos(_loc2_.index)));
            PathEndPointManager.updateOrb(true,param1);
         }
      }
      
      private function constrainToVericalOrHorizontal(param1:Point, param2:Point) : Point
      {
         var _loc3_:int = Math.abs(param2.x - this.lastSavePt.x);
         var _loc4_:int = Math.abs(param2.y - this.lastSavePt.y);
         return _loc3_ > _loc4_ ? new Point(param2.x,this.lastSavePt.y) : new Point(this.lastSavePt.x,param2.y);
      }
      
      private function processMousePos(param1:Point, param2:Boolean = false) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Point = null;
         var _loc15_:Point = null;
         var _loc16_:Point = null;
         var _loc17_:Array = null;
         var _loc18_:Point = null;
         var _loc19_:Point = null;
         var _loc3_:Number = Math.min(this.smoothness,this.strokeWidth * 0.4);
         var _loc4_:Number = Math.min(this.smoothness,this.strokeWidth);
         var _loc5_:Number = this.smoothness < 1 ? Math.pow(dotProd,this.smoothness) : dotProd;
         if(Boolean(this.lastSavePt) && Boolean(param1.subtract(this.lastSavePt).length < this.strokeWidth) && !param2)
         {
            return;
         }
         if(!this.lastSaveDir)
         {
            if(!this.lastMousePt)
            {
               this.lastSaveC2 = param1;
               this.lastMousePt = param1;
               this.lastSavePt = param1;
               this.newElement.path.push(["M",param1.x,param1.y]);
               this.previewShape.graphics.clear();
               this.previewShape.graphics.moveTo(param1.x,param1.y);
               this.setLineStyle(this.previewShape.graphics);
               return;
            }
            this.lastSaveDir = param1.subtract(this.lastMousePt);
            this.lastMousePt = param1;
            this.previewShape.graphics.lineTo(param1.x,param1.y);
            return;
         }
         var _loc6_:Point = param1.subtract(this.lastMousePt);
         this.lastMousePt = param1;
         var _loc7_:Number = param1.subtract(this.lastSavePt).length;
         var _loc8_:Point = this.lastSaveDir.clone();
         _loc8_.normalize(_loc7_);
         var _loc9_:Point = _loc8_.add(this.lastSavePt);
         var _loc10_:Point = param1.subtract(_loc9_);
         if(this.lastSaveDev)
         {
            _loc12_ = _loc10_.length * this.lastSaveDev.length;
            if(_loc12_ == 0)
            {
               _loc12_ = 0.01;
            }
            _loc13_ = (_loc10_.x * this.lastSaveDev.x + _loc10_.y * this.lastSaveDev.y) / _loc12_;
         }
         var _loc11_:Number = this.lastSaveDev ? Math.abs(_loc10_.length - this.lastSaveDev.length) : 0;
         if(_loc10_.length > _loc3_ && !this.lastSaveDev || _loc13_ < _loc5_ || _loc11_ > _loc4_ || param2)
         {
            _loc14_ = this.beforeLastSavePt || this.lastSavePt;
            _loc15_ = this.lastSavePt;
            _loc16_ = param1;
            _loc17_ = SVGPath.getControlPointsAdjacentAnchor(_loc14_,_loc15_,_loc16_);
            _loc18_ = _loc17_[0];
            _loc19_ = _loc17_[1];
            SVGPath.drawCubicBezier(this.gfx,_loc14_,this.lastSaveC2,_loc18_,_loc15_,null,null);
            this.newElement.path.push(["C",this.lastSaveC2.x,this.lastSaveC2.y,_loc18_.x,_loc18_.y,_loc15_.x,_loc15_.y]);
            this.lastSaveC2 = _loc19_;
            this.previewShape.graphics.clear();
            this.previewShape.graphics.moveTo(_loc15_.x,_loc15_.y);
            this.beforeLastSavePt = this.lastSavePt;
            this.lastSavePt = param1;
            this.lastSaveDir = _loc6_;
            this.lastSaveDev = _loc10_;
            this.setLineStyle(this.previewShape.graphics);
            SVGPath.drawCubicBezier(this.previewShape.graphics,_loc15_,_loc19_,_loc16_,_loc16_,null,null);
            if(param2)
            {
               SVGPath.drawCubicBezier(this.gfx,_loc14_,_loc19_,_loc16_,_loc16_,null,null);
               this.newElement.path.push(["C",_loc19_.x,_loc19_.y,_loc16_.x,_loc16_.y,_loc16_.x,_loc16_.y]);
            }
         }
         else
         {
            this.previewShape.graphics.lineTo(param1.x,param1.y);
         }
      }
      
      override public function refresh() : void
      {
         PathEndPointManager.makeEndPoints();
      }
      
      private function getContinuableShape() : Object
      {
         if(this.svgShape)
         {
            this.svgShape.visible = false;
         }
         var _loc1_:Object = getContinuableShapeUnderMouse(this.strokeWidth);
         if(this.svgShape)
         {
            this.svgShape.visible = true;
         }
         return _loc1_;
      }
      
      override protected function mouseUp(param1:Point) : void
      {
         var _loc2_:Point = null;
         var _loc3_:uint = 0;
         var _loc4_:Number = NaN;
         this.shiftDown = currentEvent.shiftKey;
         this.previewShape.graphics.clear();
         if(!this.newElement)
         {
            return;
         }
         if(this.linesOnly && this.shiftDown)
         {
            param1 = this.constrainToVericalOrHorizontal(this.lastSavePt,param1);
         }
         if(this.linesOnly)
         {
            this.newElement.path.push(["L",param1.x,param1.y]);
         }
         else
         {
            this.processMousePos(param1,true);
         }
         this.previewShape.graphics.clear();
         if(this.newElement.path.length > 1)
         {
            if(editor.editingScene())
            {
               _loc2_ = this.newElement.path.getPos(0);
               if(_loc2_.x < 5)
               {
                  _loc2_.x = -5;
               }
               if(_loc2_.x > ImageCanvas.canvasWidth - 5)
               {
                  _loc2_.x = ImageCanvas.canvasWidth + 5;
               }
               if(_loc2_.y < 5)
               {
                  _loc2_.y = -5;
               }
               if(_loc2_.y > ImageCanvas.canvasHeight - 5)
               {
                  _loc2_.y = ImageCanvas.canvasHeight + 5;
               }
               this.newElement.path[0][1] = _loc2_.x;
               this.newElement.path[0][2] = _loc2_.y;
               _loc3_ = this.newElement.path.length - 1;
               _loc2_ = this.newElement.path.getPos(_loc3_);
               if(_loc2_.x < 5)
               {
                  _loc2_.x = -5;
               }
               if(_loc2_.x > ImageCanvas.canvasWidth - 5)
               {
                  _loc2_.x = ImageCanvas.canvasWidth + 5;
               }
               if(_loc2_.y < 5)
               {
                  _loc2_.y = -5;
               }
               if(_loc2_.y > ImageCanvas.canvasHeight - 5)
               {
                  _loc2_.y = ImageCanvas.canvasHeight + 5;
               }
               if(this.newElement.path[_loc3_][0] == "L")
               {
                  this.newElement.path[_loc3_][1] = _loc2_.x;
                  this.newElement.path[_loc3_][2] = _loc2_.y;
               }
               else if(this.newElement.path[_loc3_][0] == "C")
               {
                  this.newElement.path[_loc3_][3] = _loc2_.x;
                  this.newElement.path[_loc3_][4] = _loc2_.y;
                  this.newElement.path[_loc3_][5] = _loc2_.x;
                  this.newElement.path[_loc3_][6] = _loc2_.y;
               }
            }
            this.processPath();
         }
         else if(this.newElement.path.length)
         {
            this.newElement.tag = "path";
            _loc4_ = 0.3;
            _loc2_ = this.newElement.path.getPos(0);
            this.newElement.setAttribute("d","M " + _loc2_.x + " " + _loc2_.y + " " + "L " + (_loc4_ + _loc2_.x) + " " + (_loc4_ + _loc2_.y));
            this.newElement.setAttribute("stroke-linecap","round");
            this.newElement.updatePath();
            this.svgShape.redraw();
         }
         this.gfx = null;
         this.newElement = null;
         this.svgShape = null;
         this.pathContinued = null;
         PathEndPointManager.makeEndPoints();
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      private function processPath() : void
      {
         var _loc5_:Object = null;
         var _loc1_:Point = this.newElement.path.getPos(0);
         if(this.newElement.path.getPos(1).subtract(_loc1_).length < 1)
         {
            this.newElement.path.splice(1,1);
            this.newElement.path.adjustPathAroundAnchor(1);
            if(this.linesOnly)
            {
               this.svgShape.parent.removeChild(this.svgShape);
               return;
            }
         }
         if(this.strokeWidth > 1.5 && this.newElement.path.length < 100)
         {
            this.svgShape.smoothPath2(editor.getStrokeSmoothness());
         }
         var _loc2_:Boolean = !this.pathContinued;
         var _loc3_:Boolean = false;
         if(this.pathContinued)
         {
            if(this.svgShape.connectPaths(this.pathContinued))
            {
               this.pathContinued.parent.removeChild(this.pathContinued);
            }
         }
         var _loc4_:Array = this.newElement.path.getSegmentEndPoints();
         if(!this.newElement.path.getSegmentEndPoints()[2] && this.newElement.path.getPos(0).subtract(this.newElement.path.getPos(this.newElement.path.length - 1)).length < this.strokeWidth * 2)
         {
            this.newElement.path.push(["Z"]);
            this.newElement.path.adjustPathAroundAnchor(this.newElement.path.length - 2);
            this.newElement.path.adjustPathAroundAnchor(1);
            if(this.strokeWidth > 1.5 && this.newElement.path.length < 100)
            {
               this.svgShape.smoothPath2(editor.getStrokeSmoothness());
            }
            this.newElement.path.adjustPathAroundAnchor(this.newElement.path.length - 2);
            this.newElement.path.adjustPathAroundAnchor(1);
            _loc2_ = false;
         }
         else
         {
            _loc5_ = this.getContinuableShape();
            if(_loc5_)
            {
               this.pathContinued = _loc5_.shape as SVGShape;
               if(this.svgShape.connectPaths(this.pathContinued))
               {
                  this.pathContinued.parent.removeChild(this.pathContinued);
                  _loc4_ = this.newElement.path.getSegmentEndPoints();
                  if(!this.newElement.path.getSegmentEndPoints()[2] && this.newElement.path.getPos(0).subtract(this.newElement.path.getPos(this.newElement.path.length - 1)).length < this.strokeWidth * 2)
                  {
                     this.newElement.path.push(["Z"]);
                     this.newElement.path.adjustPathAroundAnchor(this.newElement.path.length - 1);
                     this.newElement.path.adjustPathAroundAnchor(0);
                     _loc2_ = false;
                  }
               }
            }
         }
         this.newElement.setAttribute("d",SVGExport.pathCmds(this.newElement.path));
         this.svgShape.redraw();
         if(_loc2_)
         {
            if(!this.newElement.path.pathIsClosed())
            {
               this.intersectPathWithBackdrop();
            }
         }
      }
      
      private function intersectPathWithBackdrop() : void
      {
         if(!editor.editingScene())
         {
            return;
         }
         var _loc1_:Array = editor.getWorkArea().getBackDropFills();
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         while(_loc3_ < _loc1_.length)
         {
            if(PixelPerfectCollisionDetection.isColliding(this.svgShape,_loc1_[_loc3_]))
            {
               _loc2_ ||= this.handleIntersections(_loc1_[_loc3_] as SVGShape);
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            contentLayer.removeChild(this.svgShape);
         }
      }
      
      private function handleIntersections(param1:SVGShape) : Boolean
      {
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         var _loc13_:Object = null;
         var _loc14_:int = 0;
         var _loc15_:* = 0;
         var _loc16_:Number = NaN;
         var _loc17_:SVGPath = null;
         var _loc18_:Point = null;
         var _loc19_:Point = null;
         var _loc20_:SVGPath = null;
         var _loc21_:uint = 0;
         var _loc22_:uint = 0;
         var _loc23_:uint = 0;
         var _loc24_:SVGPath = null;
         var _loc25_:Array = null;
         var _loc26_:SVGPath = null;
         var _loc27_:SVGShape = null;
         var _loc28_:SVGShape = null;
         var _loc29_:SVGShape = null;
         var _loc30_:SVGPath = null;
         var _loc31_:Point = null;
         if(!param1.getElement().path.getSegmentEndPoints(0)[2])
         {
            return false;
         }
         if(param1.getElement().tag != "path")
         {
            param1.getElement().convertToPath();
         }
         var _loc2_:* = param1.getElement().getAttribute("stroke-width");
         var _loc3_:* = param1.getElement().getAttribute("stroke");
         var _loc4_:* = param1.getElement().getAttribute("fill");
         var _loc5_:* = this.svgShape.getElement().getAttribute("stroke-width");
         var _loc6_:Boolean = false;
         param1.getElement().setAttribute("stroke-width",testWidth);
         param1.getElement().setAttribute("stroke","black");
         param1.getElement().setAttribute("fill","none");
         this.svgShape.getElement().setAttribute("stroke-width",testWidth);
         param1.visible = false;
         param1.redraw();
         param1.visible = true;
         this.svgShape.visible = false;
         this.svgShape.redraw();
         this.svgShape.visible = true;
         var _loc7_:Sprite = editor.getContentLayer();
         this.svgShape.distCheck = SVGShape.bisectionDistCheck;
         var _loc8_:Array = this.svgShape.getAllIntersectionsWithShape(param1);
         var _loc9_:SVGPath = this.svgShape.getElement().path.clone();
         this.svgShape.visible = false;
         this.svgShape.redraw();
         this.svgShape.visible = true;
         param1.distCheck = SVGShape.bisectionDistCheck;
         var _loc10_:Array = param1.getAllIntersectionsWithShape(this.svgShape);
         if(_loc8_.length == 2)
         {
            _loc11_ = Point.interpolate(_loc9_.getPos(_loc8_[0].start.index,_loc8_[0].start.time),_loc9_.getPos(_loc8_[0].end.index,_loc8_[0].end.time),0.5);
            _loc12_ = Point.interpolate(_loc9_.getPos(_loc8_[1].start.index,_loc8_[1].start.time),_loc9_.getPos(_loc8_[1].end.index,_loc8_[1].end.time),0.5);
            _loc13_ = _loc8_[0];
            _loc14_ = int(_loc13_.start.index);
            _loc15_ = int(_loc14_ - 1);
            if(Boolean(_loc13_.end) && _loc14_ == _loc13_.end.index)
            {
               _loc16_ = (_loc13_.start.time + _loc13_.end.time) / 2;
               if(_loc9_.splitCurve(_loc14_,_loc16_))
               {
                  _loc15_--;
               }
            }
            _loc9_.splice(0,_loc14_,["M",_loc11_.x,_loc11_.y]);
            _loc9_[1][1] = Math.floor(_loc11_.x);
            _loc9_[1][2] = Math.floor(_loc11_.y);
            _loc9_.adjustPathAroundAnchor(0,1,1);
            _loc13_ = _loc8_[1];
            _loc14_ = _loc13_.start.index - _loc15_;
            if(Boolean(_loc13_.end) && _loc14_ == _loc13_.end.index - _loc15_)
            {
               _loc16_ = (_loc13_.start.time + _loc13_.end.time) / 2;
               _loc9_.splitCurve(_loc14_,_loc16_);
               _loc14_++;
               _loc9_.length = Math.min(_loc14_,_loc9_.length);
            }
            else
            {
               _loc14_++;
               _loc9_.length = Math.min(_loc14_,_loc9_.length);
            }
            _loc9_.move(_loc9_.length - 1,_loc12_);
            _loc9_[_loc9_.length - 1][3] = _loc12_.x;
            _loc9_[_loc9_.length - 1][4] = _loc12_.y;
            this.svgShape.getElement().setAttribute("stroke-linecap","butt");
            if(_loc10_.length == 2)
            {
               _loc17_ = param1.getElement().path.clone();
               _loc18_ = Point.interpolate(_loc17_.getPos(_loc10_[0].start.index,_loc10_[0].start.time),_loc17_.getPos(_loc10_[0].end.index,_loc10_[0].end.time),0.5);
               _loc19_ = Point.interpolate(_loc17_.getPos(_loc10_[1].start.index,_loc10_[1].start.time),_loc17_.getPos(_loc10_[1].end.index,_loc10_[1].end.time),0.5);
               _loc20_ = _loc9_.clone();
               _loc20_.reversePath(0);
               if(_loc11_.subtract(_loc18_).length > _loc11_.subtract(_loc19_).length)
               {
                  _loc30_ = _loc9_;
                  _loc9_ = _loc20_;
                  _loc20_ = _loc30_;
                  _loc31_ = _loc11_;
                  _loc11_ = _loc12_;
                  _loc12_ = _loc31_;
               }
               _loc21_ = _loc17_.splitCurve(_loc10_[1].end.index,_loc10_[1].end.time);
               _loc22_ = _loc17_.splitCurve(_loc10_[0].start.index,_loc10_[0].start.time);
               _loc23_ = _loc21_ - _loc22_ + 1;
               _loc24_ = _loc9_.clone();
               _loc9_.transform(this.svgShape,param1);
               _loc25_ = _loc9_.slice(1);
               _loc25_.unshift(_loc23_);
               _loc25_.unshift(_loc22_ + 1);
               _loc26_ = new SVGPath();
               _loc26_.set(_loc17_.splice.apply(_loc17_,_loc25_));
               _loc17_.move(_loc22_,_loc18_,SVGPath.ADJUST.CORNER);
               _loc17_.move(_loc21_ - _loc23_ + _loc9_.length,_loc19_,SVGPath.ADJUST.CORNER);
               if(_loc17_[_loc17_.length - 1][0] != "Z")
               {
                  _loc17_.push(["Z"]);
               }
               _loc26_.transform(param1,this.svgShape);
               _loc20_.push.apply(_loc20_,_loc26_.slice(0));
               if(_loc20_[_loc20_.length - 1][0] != "Z")
               {
                  _loc20_.push(["Z"]);
               }
               _loc27_ = this.svgShape.clone() as SVGShape;
               _loc17_.transform(param1,this.svgShape);
               _loc27_.getElement().path = _loc17_;
               _loc27_.getElement().setAttribute("d",SVGExport.pathCmds(_loc17_));
               _loc27_.getElement().setAttribute("stroke","none");
               _loc27_.getElement().setAttribute("fill",_loc4_);
               _loc27_.getElement().setAttribute("scratch-type","backdrop-fill");
               editor.getWorkArea().addBackdropFill(_loc27_);
               _loc27_.redraw();
               _loc28_ = this.svgShape.clone() as SVGShape;
               _loc28_.getElement().path = _loc20_;
               _loc28_.getElement().setAttribute("d",SVGExport.pathCmds(_loc20_));
               _loc28_.getElement().setAttribute("stroke","none");
               _loc28_.getElement().setAttribute("fill",_loc4_);
               _loc28_.getElement().setAttribute("scratch-type","backdrop-fill");
               editor.getWorkArea().addBackdropFill(_loc28_);
               _loc28_.redraw();
               _loc29_ = this.svgShape.clone() as SVGShape;
               _loc29_.getElement().path = _loc24_;
               _loc29_.getElement().setAttribute("d",SVGExport.pathCmds(_loc24_));
               _loc29_.getElement().setAttribute("fill","none");
               _loc29_.getElement().setAttribute("stroke-width",_loc5_);
               _loc29_.getElement().setAttribute("scratch-type","backdrop-stroke");
               editor.getWorkArea().addBackdropStroke(_loc29_);
               _loc29_.redraw();
               contentLayer.removeChild(param1);
               _loc6_ = true;
            }
         }
         param1.getElement().setAttribute("stroke",_loc3_);
         param1.getElement().setAttribute("stroke-width",_loc2_);
         param1.getElement().setAttribute("fill",_loc4_);
         this.svgShape.getElement().setAttribute("stroke-width",_loc5_);
         param1.visible = false;
         param1.redraw();
         param1.visible = true;
         this.svgShape.visible = false;
         this.svgShape.redraw();
         this.svgShape.visible = true;
         return _loc6_;
      }
   }
}

