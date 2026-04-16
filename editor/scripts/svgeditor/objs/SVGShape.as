package svgeditor.objs
{
   import flash.display.*;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import svgeditor.tools.PixelPerfectCollisionDetection;
   import svgutils.SVGElement;
   import svgutils.SVGPath;
   
   public class SVGShape extends Shape implements ISVGEditable
   {
      
      private static var debugShape:Shape;
      
      private static var debugCD:Sprite;
      
      public static var bisectionDistCheck:Number = 0.05;
      
      public static var eraserDistCheck:Number = 0.5;
      
      private var element:SVGElement;
      
      private var collisionState:Boolean;
      
      private var testWidth:Number = 2;
      
      private var interval:Number = 0.1;
      
      private var eraserMode:Boolean = false;
      
      public var debugMode:Boolean = false;
      
      public var distCheck:Number = 0.05;
      
      public function SVGShape(param1:SVGElement)
      {
         super();
         this.element = param1;
      }
      
      public function getElement() : SVGElement
      {
         this.element.transform = transform.matrix;
         return this.element;
      }
      
      public function redraw(param1:Boolean = false) : void
      {
         graphics.clear();
         this.element.renderPathOn(this,param1);
      }
      
      public function clone() : ISVGEditable
      {
         var _loc1_:ISVGEditable = new SVGShape(this.element.clone());
         (_loc1_ as DisplayObject).transform.matrix = transform.matrix.clone();
         _loc1_.redraw();
         return _loc1_;
      }
      
      public function getAllIntersectionsWithShape(param1:DisplayObject, param2:Boolean = false) : Array
      {
         var _loc3_:Array = [];
         var _loc4_:Graphics = graphics;
         var _loc5_:SVGPath = this.getElement().path;
         var _loc6_:Point = _loc5_.getPos(0);
         this.collisionState = false;
         this.eraserMode = param2;
         var _loc7_:Number = 10;
         var _loc8_:Number = 10;
         var _loc9_:Number = 0.75;
         var _loc10_:int = 1;
         while(_loc10_ < _loc5_.length)
         {
            _loc4_.clear();
            _loc4_.moveTo(_loc6_.x,_loc6_.y);
            this.setTestStroke();
            SVGPath.renderPathCmd(_loc5_[_loc10_],_loc4_,_loc6_);
            if(PixelPerfectCollisionDetection.isColliding(this,param1))
            {
               this.findIntersections(_loc10_,param1,_loc3_);
            }
            else if(this.collisionState)
            {
               _loc3_[_loc3_.length - 1].end = {
                  "index":_loc10_ - 1,
                  "time":1
               };
               this.collisionState = false;
            }
            _loc10_++;
         }
         if(this.collisionState)
         {
            _loc3_[_loc3_.length - 1].end = {
               "index":_loc10_ - 1,
               "time":1
            };
            this.collisionState = false;
         }
         return _loc3_;
      }
      
      private function setTestStroke() : void
      {
         if(this.eraserMode)
         {
            graphics.lineStyle(this.element.getAttribute("stroke-width",1),0,1,true,"normal",CapsStyle.ROUND,JointStyle.MITER);
         }
         else
         {
            graphics.lineStyle(this.testWidth,0,1,false,"normal",CapsStyle.NONE,JointStyle.MITER,0);
         }
      }
      
      private function findIntersections(param1:int, param2:DisplayObject, param3:Array) : void
      {
         var _loc8_:Number = NaN;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Object = null;
         if(this.debugMode)
         {
            _loc8_ = 0;
            if(debugCD)
            {
               _loc8_ = debugCD.y + debugCD.height;
            }
            debugCD = new Sprite();
            parent.addChild(debugCD);
         }
         var _loc4_:SVGPath = this.element.path;
         var _loc5_:Array = _loc4_[param1];
         var _loc6_:Point = _loc4_.getPos(param1 - 1);
         var _loc7_:Point = _loc4_.getPos(param1);
         if(_loc5_[0] == "C" || _loc5_[0] == "L")
         {
            _loc9_ = _loc5_[0] == "C" ? new Point(_loc5_[1],_loc5_[2]) : null;
            _loc10_ = _loc5_[0] == "C" ? new Point(_loc5_[3],_loc5_[4]) : null;
            _loc11_ = this.interval * 2;
            _loc12_ = 0;
            _loc13_ = null;
            this.interval = 0.1;
            while(_loc12_ > -1)
            {
               _loc12_ = this.getNextCollisionChange(_loc12_,_loc6_,_loc9_,_loc10_,_loc7_,param2);
               if(_loc12_ <= -1)
               {
                  break;
               }
               if(this.collisionState)
               {
                  _loc13_ = {"start":{
                     "index":param1,
                     "time":_loc12_
                  }};
                  param3.push(_loc13_);
                  this.interval = Math.min(0.1,this.interval * 32);
               }
               else
               {
                  param3[param3.length - 1].end = {
                     "index":param1,
                     "time":_loc12_
                  };
                  this.interval = 0.1;
               }
            }
         }
         this.showIntersections(param3);
      }
      
      private function getNextCollisionChange(param1:Number, param2:Point, param3:Point, param4:Point, param5:Point, param6:DisplayObject) : Number
      {
         var _loc9_:Number = NaN;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:Boolean = false;
         var _loc7_:Graphics = graphics;
         var _loc8_:Number = param1 + this.interval;
         while(_loc8_ <= 1)
         {
            _loc7_.clear();
            _loc9_ = _loc8_ - this.interval;
            _loc10_ = SVGPath.getPosByTime(_loc9_ - this.interval,param2,param3,param4,param5);
            _loc7_.moveTo(_loc10_.x,_loc10_.y);
            this.setTestStroke();
            _loc11_ = SVGPath.getPosByTime(_loc8_,param2,param3,param4,param5);
            _loc7_.lineTo(_loc11_.x,_loc11_.y);
            _loc12_ = PixelPerfectCollisionDetection.isColliding(this,param6);
            if(_loc12_ != this.collisionState)
            {
               if(_loc11_.subtract(_loc10_).length > this.distCheck)
               {
                  this.interval *= 0.5;
                  return this.getNextCollisionChange(_loc9_,param2,param3,param4,param5,param6);
               }
               this.collisionState = _loc12_;
               return _loc12_ ? _loc8_ - this.interval : _loc9_;
            }
            _loc8_ += this.interval;
         }
         return -1;
      }
      
      public function getPathCmdIndexUnderMouse() : int
      {
         if(!this.element.path || this.element.path.length < 2)
         {
            return -1;
         }
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         var _loc3_:Number = this.element.getAttribute("stroke-width");
         _loc3_ = Math.max(8,(isNaN(_loc3_) ? 12 : _loc3_) + 2);
         _loc2_.lineStyle(_loc3_,16711935,1,true,"normal",CapsStyle.ROUND,JointStyle.MITER);
         var _loc4_:Boolean = this.element.path.length < 3;
         var _loc5_:Rectangle = getBounds(this);
         var _loc6_:BitmapData = new BitmapData(_loc5_.width,_loc5_.height,true,0);
         var _loc7_:Matrix = new Matrix(1,0,0,1,-_loc5_.topLeft.x,-_loc5_.topLeft.y);
         var _loc8_:Point = new Point();
         var _loc9_:Point = new Point();
         var _loc10_:Point = new Point(mouseX,mouseY);
         var _loc11_:int = -1;
         var _loc12_:uint = this.element.path.length - 1;
         var _loc13_:uint = 0;
         while(_loc13_ <= _loc12_)
         {
            _loc6_.fillRect(_loc6_.rect,0);
            SVGPath.renderPathCmd(this.element.path[_loc13_],_loc2_,_loc8_,_loc9_);
            _loc6_.draw(_loc1_,_loc7_);
            if(_loc6_.hitTest(_loc5_.topLeft,255,_loc10_))
            {
               _loc11_ = int(_loc13_);
               break;
            }
            _loc13_++;
         }
         _loc6_.dispose();
         return _loc11_;
      }
      
      public function smoothPath(param1:Number) : void
      {
         var _loc10_:uint = 0;
         var _loc11_:Boolean = false;
         var _loc12_:Array = null;
         var _loc13_:Rectangle = null;
         var _loc14_:uint = 0;
         var _loc15_:uint = 0;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:uint = 0;
         var _loc2_:String = this.getElement().getAttribute("fill");
         this.getElement().setAttribute("fill","none");
         var _loc3_:String = this.getElement().getAttribute("stroke");
         if(_loc3_ == "none")
         {
            this.getElement().setAttribute("stroke","black");
         }
         this.redraw();
         var _loc4_:Rectangle = getBounds(stage);
         var _loc5_:BitmapData = new BitmapData(_loc4_.width,_loc4_.height,true,0);
         var _loc6_:Matrix = transform.concatenatedMatrix.clone();
         _loc6_.translate(-_loc4_.x,-_loc4_.y);
         var _loc7_:Boolean = false;
         var _loc8_:Number = new Date().getTime();
         var _loc9_:SVGElement = this.getElement();
         do
         {
            _loc10_ = 1;
            _loc7_ = false;
            while(_loc10_ < _loc9_.path.length)
            {
               if(_loc9_.path[_loc10_][0] == "Z" || _loc9_.path[_loc10_][0] == "M")
               {
                  _loc10_++;
               }
               else
               {
                  this.redraw();
                  _loc5_.fillRect(_loc5_.rect,0);
                  _loc5_.draw(this,_loc6_);
                  _loc5_.threshold(_loc5_,_loc5_.rect,new Point(),"<",4026531840,0,4026531840);
                  _loc12_ = _loc9_.path[_loc10_];
                  _loc9_.path.splice(_loc10_,1);
                  _loc9_.path.adjustPathAroundAnchor(_loc10_,3,1);
                  this.redraw();
                  _loc5_.draw(this,_loc6_,null,BlendMode.ERASE);
                  _loc5_.threshold(_loc5_,_loc5_.rect,new Point(),"<",4026531840,0,4026531840);
                  _loc13_ = _loc5_.getColorBoundsRect(4278190080,4278190080,true);
                  if(Boolean(_loc13_) && Boolean(_loc13_.width > 1) && _loc13_.height > 1)
                  {
                     _loc14_ = 0;
                     _loc15_ = _loc13_.left;
                     while(_loc15_ < _loc13_.right)
                     {
                        _loc18_ = _loc13_.top;
                        while(_loc18_ < _loc13_.bottom)
                        {
                           if(_loc5_.getPixel32(_loc15_,_loc18_) >> 24 & 0xF0)
                           {
                              _loc14_++;
                           }
                           _loc18_++;
                        }
                        _loc15_++;
                     }
                     _loc16_ = new Point(_loc13_.width,_loc13_.height).length;
                     _loc17_ = _loc14_ / _loc16_;
                     if(_loc17_ > param1)
                     {
                        _loc9_.path.splice(_loc10_,0,_loc12_);
                        _loc9_.path.adjustPathAroundAnchor(_loc10_);
                     }
                     else
                     {
                        _loc7_ = true;
                     }
                  }
                  else
                  {
                     _loc7_ = true;
                  }
                  _loc9_.path.adjustPathAroundAnchor(_loc10_,3,1);
                  _loc9_.path.adjustPathAroundAnchor(_loc10_,3,1);
                  _loc9_.path.adjustPathAroundAnchor(_loc10_,3,1);
                  _loc10_++;
               }
            }
         }
         while(_loc7_);
         _loc5_.dispose();
         this.getElement().setAttribute("stroke",_loc3_);
         this.getElement().setAttribute("fill",_loc2_);
         this.redraw();
      }
      
      public function smoothPath2(param1:Number) : void
      {
         var _loc17_:uint = 0;
         var _loc18_:uint = 0;
         var _loc19_:uint = 0;
         var _loc20_:Boolean = false;
         var _loc21_:Array = null;
         var _loc22_:Rectangle = null;
         var _loc23_:uint = 0;
         var _loc24_:Number = NaN;
         param1 *= 0.01;
         var _loc2_:SVGElement = this.getElement();
         var _loc3_:String = _loc2_.getAttribute("fill");
         _loc2_.setAttribute("fill","none");
         var _loc4_:String = _loc2_.getAttribute("stroke");
         var _loc5_:String = _loc2_.getAttribute("stroke-width");
         if(_loc4_ == "none")
         {
            _loc2_.setAttribute("stroke","black");
            _loc2_.setAttribute("stroke-width",2);
         }
         this.redraw();
         var _loc6_:Rectangle = getBounds(stage);
         var _loc7_:BitmapData = new BitmapData(_loc6_.width,_loc6_.height,true,0);
         var _loc8_:BitmapData = _loc7_.clone();
         var _loc9_:Matrix = transform.concatenatedMatrix.clone();
         _loc9_.translate(-_loc6_.x,-_loc6_.y);
         _loc7_.draw(this,_loc9_);
         _loc7_.threshold(_loc7_,_loc7_.rect,new Point(),"<",4026531840,0,4026531840);
         var _loc10_:Rectangle = _loc7_.getColorBoundsRect(4278190080,4278190080,true);
         var _loc11_:uint = 0;
         var _loc12_:uint = _loc10_.left;
         while(_loc12_ < _loc10_.right)
         {
            _loc17_ = _loc10_.top;
            while(_loc17_ < _loc10_.bottom)
            {
               if(_loc7_.getPixel32(_loc12_,_loc17_) >> 24 & 0xF0)
               {
                  _loc11_++;
               }
               _loc17_++;
            }
            _loc12_++;
         }
         var _loc13_:Boolean = false;
         var _loc14_:Number = new Date().getTime();
         var _loc15_:uint = 0;
         var _loc16_:uint = _loc2_.path.length - _loc2_.path.getSegmentEndPoints()[1];
         do
         {
            _loc18_ = _loc2_.path.length - _loc16_;
            _loc19_ = 1;
            _loc13_ = false;
            while(_loc18_)
            {
               _loc18_--;
               _loc19_ = Math.floor(Math.random() * (_loc2_.path.length - _loc16_));
               if(!(_loc2_.path[_loc19_][0] == "Z" || _loc2_.path[_loc19_][0] == "M"))
               {
                  _loc8_.copyPixels(_loc7_,_loc7_.rect,new Point());
                  _loc21_ = _loc2_.path[_loc19_];
                  _loc2_.path.splice(_loc19_,1);
                  _loc2_.path.adjustPathAroundAnchor(_loc19_,3,1);
                  this.redraw();
                  _loc8_.draw(this,_loc9_,null,BlendMode.ERASE);
                  _loc8_.threshold(_loc7_,_loc7_.rect,new Point(),"<",4026531840,0,4026531840);
                  _loc22_ = _loc7_.getColorBoundsRect(4278190080,4278190080,true);
                  if(Boolean(_loc22_) && Boolean(_loc22_.width > 1) && _loc22_.height > 1)
                  {
                     _loc23_ = 0;
                     _loc12_ = _loc22_.left;
                     while(_loc12_ < _loc22_.right)
                     {
                        _loc17_ = _loc22_.top;
                        while(_loc17_ < _loc22_.bottom)
                        {
                           if(_loc8_.getPixel32(_loc12_,_loc17_) >> 24 & 0xF0)
                           {
                              _loc23_++;
                           }
                           _loc17_++;
                        }
                        _loc12_++;
                     }
                     _loc24_ = _loc23_ / _loc11_;
                     if(_loc24_ > param1)
                     {
                        _loc2_.path.splice(_loc19_,0,_loc21_);
                        _loc2_.path.adjustPathAroundAnchor(_loc19_);
                     }
                     else
                     {
                        _loc13_ = true;
                     }
                  }
                  else
                  {
                     _loc13_ = true;
                  }
                  _loc2_.path.adjustPathAroundAnchor(_loc19_,3,1);
                  _loc2_.path.adjustPathAroundAnchor(_loc19_,3,1);
                  _loc2_.path.adjustPathAroundAnchor(_loc19_,3,1);
               }
            }
            _loc15_++;
         }
         while(_loc13_);
         _loc7_.dispose();
         _loc8_.dispose();
         _loc2_.setAttribute("stroke",_loc4_);
         _loc2_.setAttribute("stroke-width",_loc5_);
         _loc2_.setAttribute("fill",_loc3_);
         this.redraw();
      }
      
      public function showIntersections(param1:Array) : void
      {
         var _loc3_:Object = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         if(this.debugMode)
         {
            if(debugShape)
            {
               if(debugShape.parent)
               {
                  debugShape.parent.removeChild(debugShape);
               }
               debugShape.graphics.clear();
            }
            else
            {
               debugShape = new Shape();
               debugShape.alpha = 0.25;
            }
            parent.addChild(debugShape);
            debugShape.transform = transform;
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc4_ = Boolean(_loc3_.end) && _loc3_.start.index == _loc3_.end.index ? Number(_loc3_.end.time) : 1;
            this.showPartialCurve(_loc3_.start.index,_loc3_.start.time,_loc4_);
            if(Boolean(_loc3_.end) && _loc3_.start.index != _loc3_.end.index)
            {
               if(_loc3_.end.index > _loc3_.start.index + 1)
               {
                  _loc5_ = _loc3_.start.index + 1;
                  while(_loc5_ < _loc3_.end.index)
                  {
                     this.showPartialCurve(_loc5_,0,1);
                     _loc5_++;
                  }
               }
               this.showPartialCurve(_loc3_.end.index,0,_loc3_.end.time);
            }
            _loc2_++;
         }
      }
      
      public function showPoints() : void
      {
         var _loc2_:Point = null;
         debugShape.graphics.lineStyle(2,52479);
         var _loc1_:int = 0;
         while(_loc1_ < this.element.path.length)
         {
            _loc2_ = this.element.path.getPos(_loc1_);
            debugShape.graphics.drawCircle(_loc2_.x,_loc2_.y,3);
            _loc1_++;
         }
      }
      
      private function showPartialCurve(param1:int, param2:Number, param3:Number) : void
      {
         var _loc13_:Number = NaN;
         if(!this.debugMode)
         {
            return;
         }
         var _loc4_:Array = this.element.path[param1];
         var _loc5_:Point = this.element.path.getPos(param1 - 1);
         var _loc6_:Point = new Point(_loc4_[1],_loc4_[2]);
         var _loc7_:Point = new Point(_loc4_[3],_loc4_[4]);
         var _loc8_:Point = new Point(_loc4_[5],_loc4_[6]);
         var _loc9_:Graphics = debugShape.graphics;
         var _loc10_:Point = SVGPath.getPosByTime(param2,_loc5_,_loc6_,_loc7_,_loc8_);
         var _loc11_:Number = this.interval;
         _loc9_.moveTo(_loc10_.x,_loc10_.y);
         _loc9_.lineStyle(5,16711680,0.7,true,"normal",CapsStyle.NONE,JointStyle.MITER);
         var _loc12_:Number = param2;
         while(_loc12_ <= param3)
         {
            _loc13_ = (_loc12_ - param2) / Math.min(param3 - param2,0.01);
            _loc10_ = SVGPath.getPosByTime(_loc12_ - this.interval - _loc11_,_loc5_,_loc6_,_loc7_,_loc8_);
            _loc10_ = SVGPath.getPosByTime(_loc12_,_loc5_,_loc6_,_loc7_,_loc8_);
            _loc9_.lineTo(_loc10_.x,_loc10_.y);
            _loc12_ += this.interval;
         }
      }
      
      public function connectPaths(param1:SVGShape) : Boolean
      {
         var _loc2_:SVGElement = param1.getElement();
         var _loc3_:Number = this.element.getAttribute("stroke-width",1);
         var _loc4_:Array = _loc2_.path.getSegmentEndPoints();
         if(_loc4_[2])
         {
            return false;
         }
         var _loc5_:Point = param1.localToGlobal(_loc2_.path.getPos(_loc4_[0]));
         var _loc6_:Point = param1.localToGlobal(_loc2_.path.getPos(_loc4_[1]));
         _loc4_ = this.element.path.getSegmentEndPoints();
         if(_loc4_[2])
         {
            return false;
         }
         var _loc7_:Point = localToGlobal(this.element.path.getPos(_loc4_[0]));
         var _loc8_:Point = localToGlobal(this.element.path.getPos(_loc4_[1]));
         var _loc9_:uint = 0;
         var _loc10_:Boolean = false;
         if(_loc8_.subtract(_loc5_).length < _loc3_ * 2)
         {
            _loc9_ = uint(_loc4_[1]);
            _loc10_ = true;
         }
         else if(_loc8_.subtract(_loc6_).length < _loc3_ * 2)
         {
            _loc9_ = uint(_loc4_[1]);
            _loc2_.path.reversePath();
            _loc10_ = true;
         }
         else if(_loc7_.subtract(_loc6_).length < _loc3_ * 2)
         {
            _loc9_ = uint(_loc4_[0]);
         }
         else if(_loc7_.subtract(_loc5_).length < _loc3_ * 2)
         {
            _loc9_ = uint(_loc4_[0]);
            _loc2_.path.reversePath();
         }
         _loc2_.path.transform(param1,this);
         var _loc11_:Array = _loc2_.path.concat();
         if(_loc10_)
         {
            _loc11_.shift();
         }
         _loc11_.unshift(_loc10_ ? 0 : 1);
         var _loc12_:int = _loc10_ ? int(_loc9_ + 1) : int(_loc9_);
         _loc11_.unshift(_loc12_);
         var _loc13_:SVGPath = this.element.path;
         _loc13_.splice.apply(_loc13_,_loc11_);
         _loc4_ = this.element.path.getSegmentEndPoints();
         if(this.element.path.getPos(_loc4_[0]).subtract(this.element.path.getPos(_loc4_[1])).length < _loc3_ * 2)
         {
            this.element.path.splice(_loc4_[1] + 1,0,["Z"]);
            this.element.path.adjustPathAroundAnchor(_loc4_[1]);
            this.element.path.adjustPathAroundAnchor(_loc4_[0]);
         }
         return true;
      }
   }
}

