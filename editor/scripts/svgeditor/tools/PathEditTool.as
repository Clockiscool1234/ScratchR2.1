package svgeditor.tools
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import svgeditor.ImageEdit;
   import svgeditor.objs.ISVGEditable;
   import svgeditor.objs.SVGShape;
   import svgutils.SVGElement;
   import svgutils.SVGPath;
   
   public final class PathEditTool extends SVGEditTool
   {
      
      private var pathElem:SVGElement;
      
      private var controlPoints:Array;
      
      private var toolsLayer:Sprite;
      
      private var currentEndPoints:Array;
      
      private var movingPoint:Boolean;
      
      public function PathEditTool(param1:ImageEdit)
      {
         super(param1,["path","rect","ellipse","circle"]);
         this.reset();
      }
      
      override protected function init() : void
      {
         super.init();
         this.showPathPoints();
      }
      
      override protected function shutdown() : void
      {
         super.shutdown();
         PathEndPointManager.removeEndPoints();
      }
      
      private function reset() : void
      {
         this.pathElem = null;
         this.controlPoints = null;
      }
      
      override public function refresh() : void
      {
         if(!object)
         {
            return;
         }
         var _loc1_:ISVGEditable = object;
         this.edit(null,currentEvent);
         this.edit(_loc1_,currentEvent);
      }
      
      override protected function edit(param1:ISVGEditable, param2:MouseEvent) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         if(param1 != object)
         {
            PathEndPointManager.removeEndPoints();
            this.currentEndPoints = null;
            if(object)
            {
               _loc3_ = 0;
               while(_loc3_ < this.controlPoints.length)
               {
                  removeChild(this.controlPoints[_loc3_]);
                  _loc3_++;
               }
               this.reset();
            }
            super.edit(param1,param2);
            if(object)
            {
               this.pathElem = object.getElement();
               if(this.pathElem.tag != "path")
               {
                  this.pathElem.convertToPath();
                  object.redraw();
               }
               this.showPathPoints();
            }
            return;
         }
         if(object)
         {
            _loc4_ = (object as SVGShape).getPathCmdIndexUnderMouse();
            if(_loc4_ < 0)
            {
               return;
            }
            _loc5_ = object as DisplayObject;
            this.addPoint(_loc4_,new Point(_loc5_.mouseX,_loc5_.mouseY));
         }
      }
      
      private function getAttribute(param1:String) : *
      {
         return this.pathElem.getAttribute(param1);
      }
      
      private function showPathPoints() : void
      {
         var _loc5_:PathAnchorPoint = null;
         var _loc6_:Boolean = false;
         if(Boolean(this.controlPoints) && Boolean(this.controlPoints.length))
         {
            for each(_loc5_ in this.controlPoints)
            {
               removeChild(_loc5_);
            }
         }
         this.controlPoints = [];
         if(!object || !parent)
         {
            return;
         }
         var _loc1_:int = int(this.pathElem.path.length);
         var _loc2_:int = 0;
         var _loc3_:Array = this.pathElem.path.getSegmentEndPoints(0);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc1_)
         {
            if(_loc4_ > _loc3_[1])
            {
               _loc3_ = this.pathElem.path.getSegmentEndPoints(_loc4_);
            }
            if(this.validAnchorIndex(_loc4_))
            {
               _loc6_ = !_loc3_[2] && (_loc4_ == _loc3_[0] || _loc4_ == _loc3_[1]);
               this.controlPoints.push(this.getAnchorPoint(_loc4_,_loc6_));
               _loc2_++;
            }
            _loc4_++;
         }
      }
      
      private function resetControlPointIndices() : void
      {
         var _loc1_:int = int(this.pathElem.path.length);
         var _loc2_:int = 0;
         var _loc3_:Array = this.pathElem.path.getSegmentEndPoints(0);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc1_)
         {
            if(_loc4_ > _loc3_[1])
            {
               _loc3_ = this.pathElem.path.getSegmentEndPoints(_loc4_);
            }
            if(this.validAnchorIndex(_loc4_))
            {
               this.controlPoints[_loc2_].index = _loc4_;
               this.controlPoints[_loc2_].endPoint = !_loc3_[2] && (_loc4_ == _loc3_[0] || _loc4_ == _loc3_[1]);
               _loc2_++;
            }
            _loc4_++;
         }
      }
      
      private function redrawObj(param1:Boolean = false) : void
      {
         object.redraw();
         if(!param1)
         {
            dispatchEvent(new Event(Event.CHANGE));
         }
      }
      
      public function moveControlPoint(param1:uint, param2:Boolean, param3:Point, param4:Boolean = false) : void
      {
         var _loc5_:Array = null;
         if(param1 < this.pathElem.path.length && this.pathElem.path[param1][0] == "C")
         {
            param3 = (object as DisplayObject).globalToLocal(param3);
            _loc5_ = this.pathElem.path[param1];
            if(param2)
            {
               _loc5_[1] = param3.x;
               _loc5_[2] = param3.y;
            }
            else
            {
               _loc5_[3] = param3.x;
               _loc5_[4] = param3.y;
            }
            this.redrawObj(!param4);
         }
      }
      
      public function movePoint(param1:uint, param2:Point, param3:Boolean = false) : void
      {
         var _loc6_:Number = NaN;
         var _loc7_:Object = null;
         var _loc4_:DisplayObject = object as DisplayObject;
         param2 = _loc4_.globalToLocal(param2);
         this.pathElem.path.move(param1,param2);
         this.redrawObj(!param3);
         if(param3)
         {
            this.currentEndPoints = this.pathElem.path.getSegmentEndPoints(param1);
            if(!this.currentEndPoints[2])
            {
               _loc6_ = 2 * (this.getAttribute("stroke-width") || 1);
               if(this.currentEndPoints[0] == param1 && this.pathElem.path.getPos(param1).subtract(this.pathElem.path.getPos(this.currentEndPoints[1])).length < _loc6_ || this.currentEndPoints[1] == param1 && this.pathElem.path.getPos(param1).subtract(this.pathElem.path.getPos(this.currentEndPoints[0])).length < _loc6_)
               {
                  this.pathElem.path.splice(this.currentEndPoints[1] + 1,0,["Z"]);
                  this.pathElem.path.adjustPathAroundAnchor(this.currentEndPoints[1],1,1);
                  this.pathElem.path.adjustPathAroundAnchor(this.currentEndPoints[1],1,1);
                  this.redrawObj(!param3);
                  this.refresh();
               }
               else
               {
                  _loc4_.visible = false;
                  _loc7_ = getContinuableShapeUnderMouse(Number(this.getAttribute("stroke-width")) || 1);
                  _loc4_.visible = true;
                  if(Boolean(_loc7_) && (object as SVGShape).connectPaths(_loc7_.shape))
                  {
                     (_loc7_.shape as DisplayObject).parent.removeChild(_loc7_.shape as DisplayObject);
                     (object as SVGShape).redraw();
                     this.refresh();
                  }
               }
            }
            this.movingPoint = false;
            PathEndPointManager.removeEndPoints();
         }
         else if(!this.movingPoint)
         {
            this.currentEndPoints = this.pathElem.path.getSegmentEndPoints(param1);
            if(!this.currentEndPoints[2] && (param1 == this.currentEndPoints[0] || param1 == this.currentEndPoints[1]))
            {
               PathEndPointManager.makeEndPoints(_loc4_);
            }
            this.movingPoint = true;
         }
         var _loc5_:uint = 0;
         while(_loc5_ < numChildren)
         {
            _loc4_ = getChildAt(_loc5_);
            if(_loc4_ is PathControlPoint)
            {
               (_loc4_ as PathControlPoint).refresh();
            }
            _loc5_++;
         }
      }
      
      public function removePoint(param1:uint, param2:MouseEvent) : void
      {
         var _loc7_:Point = null;
         var _loc8_:Array = null;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:Array = null;
         var _loc12_:Array = null;
         var _loc13_:int = 0;
         var _loc14_:* = undefined;
         var _loc15_:SVGShape = null;
         var _loc16_:DisplayObject = null;
         var _loc3_:Array = this.pathElem.path.getSegmentEndPoints(param1);
         var _loc4_:int = int(this.pathElem.path.length);
         var _loc5_:int = 0;
         var _loc6_:uint = 0;
         while(_loc6_ < _loc4_)
         {
            if(this.validAnchorIndex(_loc6_))
            {
               if(_loc6_ == param1)
               {
                  break;
               }
               _loc5_++;
            }
            _loc6_++;
         }
         if((Boolean(param1 < _loc3_[1] || _loc3_[2] && param1 == _loc3_[1])) && Boolean(param1 > _loc3_[0]) && param2.shiftKey)
         {
            _loc8_ = (object as SVGShape).getAllIntersectionsWithShape(this.controlPoints[_loc5_],true);
            _loc9_ = this.pathElem.path.getPos(_loc8_[0].start.index,_loc8_[0].start.time);
            _loc10_ = this.pathElem.path.getPos(_loc8_[0].end.index,_loc8_[0].end.time);
            this.pathElem.path.move(param1,_loc9_,SVGPath.ADJUST.NONE);
            this.pathElem.path.splice(param1 + 1,0,["M",_loc10_.x,_loc10_.y]);
            if(_loc3_[2])
            {
               _loc11_ = this.pathElem.path.getSegmentEndPoints(param1 + 1);
               _loc12_ = this.pathElem.path.splice(_loc11_[0],_loc11_[1] + 1);
               --_loc12_.length;
               _loc13_ = _loc12_.length - 1;
               _loc12_.unshift(1);
               _loc12_.unshift(0);
               this.pathElem.path.splice.apply(this.pathElem.path,_loc12_);
               this.pathElem.path.adjustPathAroundAnchor(_loc13_,2);
               this.pathElem.path.adjustPathAroundAnchor(0,2);
               _loc3_ = this.pathElem.path.getSegmentEndPoints(0);
               _loc14_ = this.pathElem.getAttribute("fill");
               if(_loc14_ != "none" && this.pathElem.getAttribute("stroke") == "none")
               {
                  this.pathElem.setAttribute("stroke",_loc14_);
               }
               this.pathElem.setAttribute("fill","none");
            }
            else if(param1 <= _loc3_[1])
            {
               _loc15_ = (object as SVGShape).clone() as SVGShape;
               (object as SVGShape).parent.addChildAt(_loc15_,(object as SVGShape).parent.getChildIndex(object as DisplayObject));
               _loc15_.getElement().path.splice(0,param1 + 1);
               _loc15_.redraw();
               this.pathElem.path.length = param1 + 1;
            }
            this.refresh();
         }
         else
         {
            removeChild(this.controlPoints[_loc5_]);
            this.controlPoints.splice(_loc5_,1);
            this.pathElem.path.remove(param1);
            if(param1 == _loc3_[1] && Boolean(_loc3_[2]))
            {
               _loc7_ = this.pathElem.path.getPos(param1 - 1);
               this.pathElem.path[_loc3_[0]][1] = _loc7_.x;
               this.pathElem.path[_loc3_[0]][2] = _loc7_.y;
            }
            this.resetControlPointIndices();
         }
         if(this.controlPoints.length == 1)
         {
            _loc16_ = object as DisplayObject;
            _loc16_.parent.removeChild(_loc16_);
            setObject(null);
            dispatchEvent(new Event(Event.CHANGE));
         }
         else
         {
            this.redrawObj();
         }
      }
      
      private function validAnchorIndex(param1:uint) : Boolean
      {
         var _loc2_:Array = this.pathElem.path.getSegmentEndPoints(param1);
         if(this.pathElem.path[param1][0] == "Z" || Boolean(_loc2_[2]) && Boolean(param1 == _loc2_[0]))
         {
            return false;
         }
         return true;
      }
      
      private function addPoint(param1:uint, param2:Point, param3:Boolean = false) : void
      {
         var _loc7_:PathAnchorPoint = null;
         var _loc4_:DisplayObject = object as DisplayObject;
         var _loc5_:int = int(this.pathElem.path.length);
         var _loc6_:int = 0;
         var _loc8_:uint = 0;
         while(_loc8_ < _loc5_)
         {
            if(this.validAnchorIndex(_loc8_))
            {
               if(_loc8_ == param1)
               {
                  this.pathElem.path.add(_loc8_,param2,!currentEvent.shiftKey);
                  _loc7_ = this.getAnchorPoint(_loc8_,false);
                  this.controlPoints.splice(_loc6_,0,_loc7_);
                  break;
               }
               _loc6_++;
            }
            _loc8_++;
         }
         this.resetControlPointIndices();
         this.redrawObj();
         if(_loc7_)
         {
            _loc7_.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
            _loc7_.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
         }
      }
      
      private function getAnchorPoint(param1:uint, param2:Boolean) : PathAnchorPoint
      {
         var _loc3_:Point = globalToLocal((object as DisplayObject).localToGlobal(this.pathElem.path.getPos(param1)));
         var _loc4_:PathAnchorPoint = new PathAnchorPoint(this,param1,param2);
         _loc4_.x = _loc3_.x;
         _loc4_.y = _loc3_.y;
         addChild(_loc4_);
         return _loc4_;
      }
      
      public function getControlPoint(param1:uint, param2:Boolean) : PathControlPoint
      {
         var _loc4_:Array = null;
         var _loc5_:Point = null;
         var _loc3_:PathControlPoint = null;
         if(this.pathElem.path[param1][0] == "C")
         {
            _loc4_ = this.pathElem.path[param1];
            _loc5_ = this.getControlPos(param1,param2);
            _loc3_ = new PathControlPoint(this,param1,param2);
            _loc3_.x = _loc5_.x;
            _loc3_.y = _loc5_.y;
            addChild(_loc3_);
         }
         return _loc3_;
      }
      
      public function getControlPos(param1:uint, param2:Boolean) : Point
      {
         var _loc4_:Array = null;
         var _loc3_:Point = null;
         if(this.pathElem.path[param1][0] == "C")
         {
            _loc4_ = this.pathElem.path[param1];
            _loc3_ = new Point(param2 ? Number(_loc4_[1]) : Number(_loc4_[3]),param2 ? Number(_loc4_[2]) : Number(_loc4_[4]));
            _loc3_ = globalToLocal((object as DisplayObject).localToGlobal(_loc3_));
         }
         return _loc3_;
      }
   }
}

