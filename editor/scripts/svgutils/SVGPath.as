package svgutils
{
   import flash.display.*;
   import flash.geom.*;
   import svgeditor.objs.PathDrawContext;
   
   public dynamic class SVGPath extends Array
   {
      
      public static const ADJUST:Object = {
         "NONE":0,
         "NORMAL":1,
         "CORNER":2
      };
      
      private static var capConversion:Object = {
         "butt":CapsStyle.NONE,
         "round":CapsStyle.ROUND,
         "square":CapsStyle.SQUARE
      };
      
      private static const tolerance:Number = 1;
      
      private const adjustmentFactor:Number = 0.5;
      
      private var dirty:Boolean;
      
      public function SVGPath(... rest)
      {
         var _loc3_:Number = NaN;
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         super();
         var _loc2_:uint = uint(rest.length);
         if(_loc2_ == 1 && rest[0] is Number)
         {
            _loc3_ = Number(rest[0]);
            _loc4_ = _loc3_;
            if(_loc4_ != _loc3_)
            {
               throw new RangeError("Array index is not a 32-bit unsigned integer (" + _loc3_ + ")");
            }
            length = _loc4_;
         }
         else
         {
            length = _loc2_;
            _loc5_ = 0;
            while(_loc5_ < _loc2_)
            {
               this[_loc5_] = rest[_loc5_];
               _loc5_++;
            }
         }
         this.dirty = false;
      }
      
      public static function getControlPointsAdjacentAnchor(param1:Point, param2:Point, param3:Point) : Array
      {
         var _loc4_:Point = param1.subtract(param2);
         var _loc5_:Number = _loc4_.length * 0.333;
         var _loc6_:Point = param3.subtract(param2);
         var _loc7_:Number = _loc6_.length * 0.333;
         var _loc8_:Point = param1.subtract(param3);
         var _loc9_:Number = _loc8_.length * 0.5;
         var _loc10_:Number = Math.min(1,_loc9_ / (_loc5_ + _loc7_));
         _loc8_.normalize(_loc10_ * Math.max(Math.min(_loc5_,_loc9_),_loc7_ / 4));
         var _loc11_:Point = param2.add(_loc8_);
         _loc8_.normalize(_loc10_ * Math.max(Math.min(_loc7_,_loc9_),_loc5_ / 4));
         var _loc12_:Point = param2.subtract(_loc8_);
         return [_loc11_,_loc12_];
      }
      
      public static function render(param1:SVGElement, param2:Graphics, param3:Boolean = false) : void
      {
         var _loc9_:Array = null;
         var _loc10_:String = null;
         if(!param1.path || param1.path.length == 0)
         {
            return;
         }
         var _loc4_:Vector.<int> = new Vector.<int>();
         var _loc5_:Vector.<Number> = new Vector.<Number>();
         var _loc6_:Number = 0;
         var _loc7_:Number = 0;
         var _loc8_:Point = new Point();
         setBorderAndFill(param2,param1,gradientBoxForPath(param1.path),param3);
         for each(_loc9_ in param1.path)
         {
            switch(_loc9_[0])
            {
               case "C":
                  drawCubicBezier(param2,new Point(_loc6_,_loc7_),new Point(_loc9_[1],_loc9_[2]),new Point(_loc9_[3],_loc9_[4]),new Point(_loc9_[5],_loc9_[6]),_loc4_,_loc5_);
                  break;
               case "L":
                  _loc4_.push(GraphicsPathCommand.LINE_TO);
                  _loc5_.push(_loc9_[1],_loc9_[2]);
                  break;
               case "M":
                  _loc4_.push(GraphicsPathCommand.MOVE_TO);
                  _loc5_.push(_loc9_[1],_loc9_[2]);
                  _loc8_ = new Point(_loc9_[1],_loc9_[2]);
                  break;
               case "Q":
                  _loc4_.push(GraphicsPathCommand.CURVE_TO);
                  _loc5_.push(_loc9_[1],_loc9_[2],_loc9_[3],_loc9_[4]);
                  break;
               case "Z":
                  _loc4_.push(GraphicsPathCommand.LINE_TO);
                  _loc5_.push(_loc8_.x,_loc8_.y);
            }
            _loc6_ = Number(_loc9_[_loc9_.length - 2]);
            _loc7_ = Number(_loc9_[_loc9_.length - 1]);
         }
         _loc10_ = param1.getAttribute("fill-rule","nonzero") == "nonzero" ? "nonZero" : "evenOdd";
         param2.drawPath(_loc4_,_loc5_,_loc10_);
         param2.endFill();
      }
      
      public static function drawCubicBezier(param1:Graphics, param2:Point, param3:Point, param4:Point, param5:Point, param6:Vector.<int>, param7:Vector.<Number>) : void
      {
         var _loc8_:Point = Point.interpolate(param3,param2,3 / 4);
         var _loc9_:Point = Point.interpolate(param4,param5,3 / 4);
         var _loc10_:Number = (param5.x - param2.x) / 16;
         var _loc11_:Number = (param5.y - param2.y) / 16;
         var _loc12_:Point = Point.interpolate(param3,param2,3 / 8);
         var _loc13_:Point = Point.interpolate(_loc9_,_loc8_,3 / 8);
         _loc13_.x -= _loc10_;
         _loc13_.y -= _loc11_;
         var _loc14_:Point = Point.interpolate(_loc8_,_loc9_,3 / 8);
         _loc14_.x += _loc10_;
         _loc14_.y += _loc11_;
         var _loc15_:Point = Point.interpolate(param4,param5,3 / 8);
         var _loc16_:Point = Point.interpolate(_loc12_,_loc13_,1 / 2);
         var _loc17_:Point = Point.interpolate(_loc8_,_loc9_,1 / 2);
         var _loc18_:Point = Point.interpolate(_loc14_,_loc15_,1 / 2);
         if(param6)
         {
            param6.push(GraphicsPathCommand.CURVE_TO,GraphicsPathCommand.CURVE_TO,GraphicsPathCommand.CURVE_TO,GraphicsPathCommand.CURVE_TO);
            param7.push(_loc12_.x,_loc12_.y,_loc16_.x,_loc16_.y,_loc13_.x,_loc13_.y,_loc17_.x,_loc17_.y,_loc14_.x,_loc14_.y,_loc18_.x,_loc18_.y,_loc15_.x,_loc15_.y,param5.x,param5.y);
         }
         else if(param1)
         {
            param1.curveTo(_loc12_.x,_loc12_.y,_loc16_.x,_loc16_.y);
            param1.curveTo(_loc13_.x,_loc13_.y,_loc17_.x,_loc17_.y);
            param1.curveTo(_loc14_.x,_loc14_.y,_loc18_.x,_loc18_.y);
            param1.curveTo(_loc15_.x,_loc15_.y,param5.x,param5.y);
         }
      }
      
      public static function setBorderAndFill(param1:Graphics, param2:SVGElement, param3:Rectangle, param4:Boolean = false) : void
      {
         var _loc5_:Number = NaN;
         var _loc8_:String = null;
         var _loc6_:* = param2.getAttribute("stroke");
         if(Boolean(_loc6_) && _loc6_ != "none")
         {
            _loc5_ = Number(param2.getAttribute("stroke-opacity",1));
            _loc5_ = Math.max(0,Math.min(_loc5_,1));
            _loc8_ = param2.getAttribute("stroke-linecap","butt");
            if(_loc8_ in capConversion)
            {
               _loc8_ = capConversion[_loc8_];
            }
            else
            {
               _loc8_ = CapsStyle.NONE;
            }
            if(_loc6_ is SVGElement)
            {
               setGradient(param1,_loc6_,param3,_loc5_,true,param2.getAttribute("stroke-width",1));
            }
            else
            {
               param1.lineStyle(param2.getAttribute("stroke-width",1),param2.getColorValue(_loc6_),_loc5_,false,"normal",_loc8_,JointStyle.MITER);
            }
         }
         else
         {
            param1.lineStyle(NaN);
         }
         var _loc7_:* = param2.getAttribute("fill","black");
         if(Boolean(_loc7_) && _loc7_ != "none")
         {
            _loc5_ = Number(param2.getAttribute("fill-opacity",1));
            _loc5_ = Math.max(0,Math.min(_loc5_,1));
            if(_loc7_ is SVGElement)
            {
               setGradient(param1,_loc7_,param3,_loc5_);
            }
            else
            {
               param1.beginFill(param2.getColorValue(_loc7_),_loc5_);
            }
         }
         else if(Boolean(param2.path) && Boolean(param2.path.getSegmentEndPoints(0)[2]) && !param4)
         {
            param1.beginFill(16777215,0.01);
         }
      }
      
      private static function setGradient(param1:Graphics, param2:SVGElement, param3:Rectangle, param4:Number, param5:Boolean = false, param6:Number = 0) : void
      {
         var _loc10_:Matrix = null;
         var _loc11_:SVGElement = null;
         var _loc7_:Array = [];
         var _loc8_:Array = [];
         var _loc9_:Array = [];
         for each(_loc11_ in param2.subElements)
         {
            _loc7_.push(_loc11_.getColorValue(_loc11_.getAttribute("stop-color",0)));
            _loc8_.push(_loc11_.getAttribute("stop-opacity",1) * param4);
            _loc9_.push(255 * _loc11_.getAttribute("offset",0));
         }
         if(_loc7_.length == 2)
         {
            if(_loc8_[0] == 0)
            {
               _loc7_[0] = _loc7_[1];
            }
            else if(_loc8_[1] == 0)
            {
               _loc7_[1] = _loc7_[0];
            }
         }
         if(_loc7_.length == 0)
         {
            if(!param5)
            {
               param1.beginFill(8421504);
            }
            else
            {
               param1.lineStyle(param6,8421504);
            }
         }
         else if(_loc7_.length == 1)
         {
            if(!param5)
            {
               param1.beginFill(param2.getColorValue(_loc7_[0]));
            }
            else
            {
               param1.lineStyle(param6,param2.getColorValue(_loc7_[0]));
            }
         }
         else if(param2.tag == "linearGradient")
         {
            _loc10_ = linearGradientMatrix(param2,param3);
            if(!param5)
            {
               param1.beginGradientFill(GradientType.LINEAR,_loc7_,_loc8_,_loc9_,_loc10_);
            }
            else
            {
               param1.lineStyle(param6);
               param1.lineGradientStyle(GradientType.LINEAR,_loc7_,_loc8_,_loc9_,_loc10_);
            }
         }
         else if(param2.tag == "radialGradient")
         {
            _loc10_ = radialGradientMatrix(param2,param3);
            if(!param5)
            {
               param1.beginGradientFill(GradientType.RADIAL,_loc7_,_loc8_,_loc9_,_loc10_,"pad","rgb",param2.getAttribute("fpRatio",0));
            }
            else
            {
               param1.lineStyle(param6);
               param1.lineGradientStyle(GradientType.RADIAL,_loc7_,_loc8_,_loc9_,_loc10_,"pad","rgb",param2.getAttribute("fpRatio",0));
            }
         }
      }
      
      private static function linearGradientMatrix(param1:SVGElement, param2:Rectangle) : Matrix
      {
         var _loc3_:Number = param1.getAttribute("x1",0);
         var _loc4_:Number = param1.getAttribute("y1",0);
         var _loc5_:Number = param1.getAttribute("x2",0);
         var _loc6_:Number = param1.getAttribute("y2",0);
         var _loc7_:Boolean = param1.getAttribute("gradientUnits","") == "userSpaceOnUse";
         if(_loc7_)
         {
            _loc3_ /= param2.width;
            _loc5_ /= param2.width;
            _loc4_ /= param2.height;
            _loc6_ /= param2.height;
         }
         var _loc8_:Number = Math.atan2(_loc6_ - _loc4_,_loc5_ - _loc3_);
         var _loc9_:Matrix = new Matrix();
         _loc9_.createGradientBox(param2.width,param2.height,_loc8_,param2.x,param2.y);
         return _loc9_;
      }
      
      private static function radialGradientMatrix(param1:SVGElement, param2:Rectangle) : Matrix
      {
         var _loc3_:Boolean = param1.getAttribute("gradientUnits","") == "userSpaceOnUse";
         var _loc4_:Number = Math.max(0,param1.getAttribute("r",0.5));
         var _loc5_:Number = param2.x + param2.width * param1.getAttribute("cx",0.5);
         var _loc6_:Number = param2.y + param2.height * param1.getAttribute("cy",0.5);
         var _loc7_:Number = param2.x + param2.width * param1.getAttribute("fx",param1.getAttribute("cx",0.5));
         var _loc8_:Number = param2.y + param2.height * param1.getAttribute("fy",param1.getAttribute("cy",0.5));
         if(_loc3_)
         {
            _loc4_ = Math.max(0,param1.getAttribute("r",0)) / param2.width;
            _loc5_ = param1.getAttribute("cx",param2.width / 2);
            _loc6_ = param1.getAttribute("cy",param2.height / 2);
            _loc7_ = param1.getAttribute("fx",_loc5_);
            _loc8_ = param1.getAttribute("fy",_loc6_);
         }
         var _loc9_:Number = param2.width * _loc4_;
         var _loc10_:Number = param2.height * _loc4_;
         var _loc11_:Number = (_loc7_ - _loc5_) / _loc9_;
         var _loc12_:Number = (_loc8_ - _loc6_) / _loc10_;
         var _loc13_:Number = Math.atan2(_loc12_,_loc11_);
         var _loc14_:Number = Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_);
         param1.setAttribute("fpRatio",_loc14_);
         var _loc15_:Matrix = new Matrix();
         _loc15_.createGradientBox(2 * _loc9_,2 * _loc10_,_loc13_,_loc5_ - _loc9_,_loc6_ - _loc10_);
         return _loc15_;
      }
      
      private static function gradientBoxForPath(param1:Array) : Rectangle
      {
         var _loc2_:Number = NaN;
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:Array = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc6_:Array = param1[0];
         _loc2_ = _loc4_ = Number(_loc6_[1]);
         _loc3_ = _loc5_ = Number(_loc6_[2]);
         for each(_loc7_ in param1)
         {
            _loc8_ = Number(_loc7_[1]);
            _loc9_ = Number(_loc7_[2]);
            if(_loc8_ < _loc2_)
            {
               _loc2_ = _loc8_;
            }
            if(_loc9_ < _loc3_)
            {
               _loc3_ = _loc9_;
            }
            if(_loc8_ > _loc4_)
            {
               _loc4_ = _loc8_;
            }
            if(_loc9_ > _loc5_)
            {
               _loc5_ = _loc9_;
            }
         }
         return new Rectangle(_loc2_,_loc3_,_loc4_ - _loc2_,_loc5_ - _loc3_);
      }
      
      public static function getPosByTime(param1:Number, param2:Point, param3:Point, param4:Point, param5:Point) : Point
      {
         var b1:Function;
         var b2:Function;
         var b3:Function;
         var b4:Function;
         var ratio:Number = param1;
         var p1:Point = param2;
         var cp1:Point = param3;
         var cp2:Point = param4;
         var p2:Point = param5;
         if(cp1)
         {
            b1 = function(param1:Number):Number
            {
               return param1 * param1 * param1;
            };
            b2 = function(param1:Number):Number
            {
               return 3 * param1 * param1 * (1 - param1);
            };
            b3 = function(param1:Number):Number
            {
               return 3 * param1 * (1 - param1) * (1 - param1);
            };
            b4 = function(param1:Number):Number
            {
               return (1 - param1) * (1 - param1) * (1 - param1);
            };
            ratio = 1 - ratio;
            return new Point(p1.x * b1(ratio) + cp1.x * b2(ratio) + cp2.x * b3(ratio) + p2.x * b4(ratio),p1.y * b1(ratio) + cp1.y * b2(ratio) + cp2.y * b3(ratio) + p2.y * b4(ratio));
         }
         return Point.interpolate(p2,p1,ratio);
      }
      
      private static function getCurveTangent(param1:Point, param2:Point, param3:Point) : Point
      {
         var _loc4_:Point = param1.subtract(param2);
         var _loc5_:Point = param3.subtract(param2);
         _loc4_.normalize(1);
         _loc5_.normalize(1);
         var _loc6_:Point = _loc4_.add(_loc5_);
         var _loc7_:Point = new Point(-_loc6_.y,_loc6_.x);
         if(_loc7_.x * _loc5_.x + _loc7_.y * _loc5_.y < 0)
         {
            _loc7_ = new Point(-_loc7_.x,-_loc7_.y);
         }
         return _loc7_;
      }
      
      private static function intersect2Lines(param1:Point, param2:Point, param3:Point, param4:Point) : Point
      {
         var _loc5_:Number = param1.x;
         var _loc6_:Number = param1.y;
         var _loc7_:Number = param4.x;
         var _loc8_:Number = param4.y;
         var _loc9_:Number = param2.x - _loc5_;
         var _loc10_:Number = param3.x - _loc7_;
         if(!_loc9_ && !_loc10_)
         {
            return null;
         }
         var _loc11_:Number = (param2.y - _loc6_) / _loc9_;
         var _loc12_:Number = (param3.y - _loc8_) / _loc10_;
         if(!_loc9_)
         {
            return new Point(_loc5_,_loc12_ * (_loc5_ - _loc7_) + _loc8_);
         }
         if(!_loc10_)
         {
            return new Point(_loc7_,_loc11_ * (_loc7_ - _loc5_) + _loc6_);
         }
         var _loc13_:Number = (-_loc12_ * _loc7_ + _loc8_ + _loc11_ * _loc5_ - _loc6_) / (_loc11_ - _loc12_);
         var _loc14_:Number = _loc11_ * (_loc13_ - _loc5_) + _loc6_;
         return new Point(_loc13_,_loc14_);
      }
      
      private static function bezierSplit(param1:Point, param2:Point, param3:Point, param4:Point) : Object
      {
         var _loc5_:Point = Point.interpolate(param1,param2,0.5);
         var _loc6_:Point = Point.interpolate(param2,param3,0.5);
         var _loc7_:Point = Point.interpolate(param3,param4,0.5);
         var _loc8_:Point = Point.interpolate(_loc5_,_loc6_,0.5);
         var _loc9_:Point = Point.interpolate(_loc6_,_loc7_,0.5);
         var _loc10_:Point = Point.interpolate(_loc8_,_loc9_,0.5);
         return {
            "b0":{
               "a":param1,
               "b":_loc5_,
               "c":_loc8_,
               "d":_loc10_
            },
            "b1":{
               "a":_loc10_,
               "b":_loc9_,
               "c":_loc7_,
               "d":param4
            }
         };
      }
      
      public static function renderPathCmd(param1:Array, param2:Graphics, param3:Point, param4:Point = null) : void
      {
         switch(param1[0])
         {
            case "C":
               SVGPath.drawCubicBezier(param2,new Point(param3.x,param3.y),new Point(param1[1],param1[2]),new Point(param1[3],param1[4]),new Point(param1[5],param1[6]),null,null);
               break;
            case "L":
               param2.lineTo(param1[1],param1[2]);
               break;
            case "M":
               param2.moveTo(param1[1],param1[2]);
               if(param4)
               {
                  param4.x = param1[1];
                  param4.y = param1[2];
               }
               break;
            case "Q":
               param2.curveTo(param1[1],param1[2],param1[3],param1[4]);
               break;
            case "Z":
               if(param4)
               {
                  param2.lineTo(param4.x,param4.y);
               }
         }
         param3.x = param1[param1.length - 2];
         param3.y = param1[param1.length - 1];
      }
      
      private static function debugDrawPoints(param1:Array, param2:Graphics) : void
      {
         var _loc3_:Array = null;
         var _loc4_:int = 0;
         param2.lineStyle();
         for each(_loc3_ in param1)
         {
            _loc4_ = int(_loc3_.length);
            param2.beginFill(255);
            param2.drawCircle(_loc3_[_loc4_ - 2],_loc3_[_loc4_ - 1],3);
            param2.beginFill(16776960);
            if(_loc3_.length > 3)
            {
               param2.drawCircle(_loc3_[1],_loc3_[2],2);
            }
            param2.beginFill(16711935);
            if(_loc3_.length > 5)
            {
               param2.drawCircle(_loc3_[3],_loc3_[4],2);
            }
         }
      }
      
      public function clone() : SVGPath
      {
         var _loc1_:SVGPath = new SVGPath(length);
         var _loc2_:int = 0;
         while(_loc2_ < length)
         {
            _loc1_[_loc2_] = this[_loc2_].slice();
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function set(param1:Array) : void
      {
         length = param1.length;
         var _loc2_:int = 0;
         while(_loc2_ < length)
         {
            this[_loc2_] = param1[_loc2_];
            _loc2_++;
         }
      }
      
      public function setDirty() : void
      {
         this.dirty = true;
      }
      
      public function move(param1:uint, param2:Point, param3:uint = 1) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         if(param1 < length)
         {
            _loc4_ = this[param1];
            _loc5_ = this.getSegmentEndPoints(param1);
            switch(_loc4_[0])
            {
               case "M":
               case "L":
                  _loc4_[1] = param2.x;
                  _loc4_[2] = param2.y;
                  this.dirty = true;
                  break;
               case "C":
                  _loc4_[5] = param2.x;
                  _loc4_[6] = param2.y;
                  if(param3 == ADJUST.CORNER)
                  {
                     _loc4_[3] = param2.x;
                     _loc4_[4] = param2.y;
                  }
                  this.dirty = true;
                  break;
               case "Q":
                  throw new Error("Ack!");
            }
            if(Boolean(_loc5_[2] && (_loc4_[0] == "C" || _loc4_[0] == "L") && param1 == _loc5_[1]) && Boolean(_loc5_[0] != param1) && this[_loc5_[0]][0] == "M")
            {
               this.move(_loc5_[0],param2,ADJUST.NONE);
            }
            if(param3 == ADJUST.NORMAL)
            {
               this.adjustPathAroundAnchor(param1);
            }
         }
      }
      
      public function transform(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Point = null;
         var _loc3_:uint = 0;
         while(_loc3_ < length)
         {
            _loc4_ = this[_loc3_];
            switch(_loc4_[0])
            {
               case "C":
                  _loc5_ = param2.globalToLocal(param1.localToGlobal(new Point(_loc4_[5],_loc4_[6])));
                  _loc4_[5] = _loc5_.x;
                  _loc4_[6] = _loc5_.y;
               case "Q":
                  _loc5_ = param2.globalToLocal(param1.localToGlobal(new Point(_loc4_[3],_loc4_[4])));
                  _loc4_[3] = _loc5_.x;
                  _loc4_[4] = _loc5_.y;
               case "M":
               case "L":
                  _loc5_ = param2.globalToLocal(param1.localToGlobal(new Point(_loc4_[1],_loc4_[2])));
                  _loc4_[1] = _loc5_.x;
            }
            _loc4_[2] = _loc5_.y;
            _loc3_++;
         }
      }
      
      public function remove(param1:uint) : void
      {
         var _loc2_:Array = null;
         var _loc3_:Point = null;
         if(param1 < length)
         {
            _loc2_ = this.getSegmentEndPoints(param1);
            if(Boolean(param1 == _loc2_[1] && _loc2_[2]) && Boolean(_loc2_[0] > 0) && this[_loc2_[0] - 1][0] == "M")
            {
               _loc3_ = this.getPos(param1 - 1);
               this[_loc2_[0] - 1] = ["M",_loc3_.x,_loc3_.y];
            }
            else if(param1 == _loc2_[0] && !_loc2_[2] && param1 < length - 1 && this[param1][0] == "M")
            {
               _loc3_ = this.getPos(param1 + 1);
               this[param1 + 1] = ["M",_loc3_.x,_loc3_.y];
            }
            splice(param1,1);
            this.adjustPathAroundAnchor(Math.min(_loc2_[1] - 1,param1));
            this.dirty = true;
         }
      }
      
      public function add(param1:uint, param2:Point, param3:Boolean) : void
      {
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc6_:Array = null;
         var _loc7_:Array = null;
         var _loc8_:Array = null;
         var _loc9_:Array = null;
         if(param1 < length)
         {
            _loc4_ = this[param1][0] == "C";
            if(!param3)
            {
               _loc4_ = !_loc4_;
            }
            if(_loc4_)
            {
               _loc6_ = this.getIndicesAroundAnchor(param1,2);
               _loc7_ = SVGPath.getControlPointsAdjacentAnchor(this.getPos(_loc6_[0]),this.getPos(_loc6_[1]),param2);
               _loc8_ = SVGPath.getControlPointsAdjacentAnchor(this.getPos(_loc6_[1]),param2,this.getPos(_loc6_[2]));
               if(this[param1][0] == "C")
               {
                  _loc5_ = this[param1];
                  _loc7_[1].x = _loc5_[1];
                  _loc7_[1].y = _loc5_[2];
               }
               _loc5_ = ["C",_loc7_[1].x,_loc7_[1].y,_loc8_[0].x,_loc8_[0].y,param2.x,param2.y];
               if(this[_loc6_[2]][0] == "C")
               {
                  _loc9_ = this[_loc6_[2]];
                  _loc9_[1] = _loc8_[1].x;
                  _loc9_[2] = _loc8_[1].y;
               }
            }
            else
            {
               _loc5_ = ["L",param2.x,param2.y];
            }
            splice(param1,0,_loc5_);
            this.adjustPathAroundAnchor(param1);
            this.dirty = true;
         }
      }
      
      public function getPos(param1:uint, param2:Number = 1) : Point
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         if(param1 < length)
         {
            _loc3_ = this[param1];
            switch(_loc3_[0])
            {
               case "M":
                  return new Point(_loc3_[1],_loc3_[2]);
               case "L":
                  if(param2 > 0.999)
                  {
                     return new Point(_loc3_[1],_loc3_[2]);
                  }
                  return getPosByTime(param2,this.getPos(param1 - 1),null,null,new Point(_loc3_[1],_loc3_[2]));
                  break;
               case "C":
                  if(param2 > 0.999)
                  {
                     return new Point(_loc3_[5],_loc3_[6]);
                  }
                  return getPosByTime(param2,this.getPos(param1 - 1),new Point(_loc3_[1],_loc3_[2]),new Point(_loc3_[3],_loc3_[4]),new Point(_loc3_[5],_loc3_[6]));
                  break;
               case "Q":
                  throw new Error("Ack!");
               case "Z":
                  _loc4_ = this.getSegmentEndPoints(param1);
                  if(_loc4_[0] < param1)
                  {
                     return this.getPos(_loc4_[0]);
                  }
                  return new Point();
            }
         }
         return null;
      }
      
      public function adjustPathAroundAnchor(param1:uint, param2:uint = 1, param3:Number = 0.5) : void
      {
         var _loc5_:Array = null;
         var _loc9_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         var _loc13_:Point = null;
         var _loc14_:Point = null;
         var _loc15_:Array = null;
         var _loc16_:Number = NaN;
         var _loc17_:Array = null;
         var _loc18_:Point = null;
         var _loc19_:Point = null;
         if(param1 >= length)
         {
            return;
         }
         var _loc4_:Array = this.getSegmentEndPoints(param1);
         if(!_loc4_[2] && _loc4_[1] - _loc4_[0] == 1)
         {
            _loc5_ = this[_loc4_[1]];
            if(_loc5_[0] == "C")
            {
               _loc11_ = this.getPos(_loc4_[0]);
               _loc5_[1] = _loc11_.x;
               _loc5_[2] = _loc11_.y;
               _loc5_[3] = _loc5_[5];
               _loc5_[4] = _loc5_[6];
            }
            return;
         }
         var _loc6_:Array = this.getIndicesAroundAnchor(param1,param2 + 1);
         var _loc7_:uint = uint(_loc6_.indexOf(param1));
         var _loc8_:uint = _loc6_.length - 1;
         var _loc10_:uint = 1;
         while(_loc10_ < _loc8_)
         {
            _loc12_ = _loc13_ ? _loc13_ : this.getPos(_loc6_[_loc10_ - 1]);
            _loc13_ = _loc14_ ? _loc14_ : this.getPos(_loc6_[_loc10_]);
            _loc14_ = this.getPos(_loc6_[_loc10_ + 1]);
            _loc15_ = SVGPath.getControlPointsAdjacentAnchor(_loc12_,_loc13_,_loc14_);
            _loc5_ = this[_loc6_[_loc10_]];
            _loc16_ = Math.pow(param3,1 + Math.abs(_loc7_ - _loc10_));
            if(!_loc4_[2] && (_loc6_[_loc10_] == _loc4_[0] || _loc6_[_loc10_] == _loc4_[1]))
            {
               _loc16_ = 1;
            }
            if(_loc5_[0] == "C")
            {
               if(_loc6_[_loc10_] == _loc4_[1] && !_loc4_[2])
               {
                  _loc5_[3] = _loc13_.x;
                  _loc5_[4] = _loc13_.y;
               }
               else
               {
                  _loc18_ = Point.interpolate(_loc15_[0],new Point(_loc5_[3],_loc5_[4]),_loc16_);
                  _loc5_[3] = _loc18_.x;
                  _loc5_[4] = _loc18_.y;
               }
            }
            else if(!_loc4_[2] && _loc5_[0] == "M")
            {
               _loc15_ = SVGPath.getControlPointsAdjacentAnchor(_loc12_,_loc12_,_loc13_);
            }
            else
            {
               _loc15_ = SVGPath.getControlPointsAdjacentAnchor(_loc12_,_loc13_,_loc13_.add(_loc13_.subtract(_loc12_)));
            }
            _loc17_ = this[_loc6_[_loc10_ + 1]];
            if(_loc6_[_loc10_] != _loc6_[_loc10_ + 1] && _loc17_[0] == "C")
            {
               _loc19_ = Point.interpolate(_loc15_[1],new Point(_loc17_[1],_loc17_[2]),_loc16_);
               _loc17_[1] = _loc19_.x;
               _loc17_[2] = _loc19_.y;
            }
            _loc10_++;
         }
      }
      
      private function getIndicesAroundAnchor(param1:uint, param2:uint = 1) : Array
      {
         var _loc10_:uint = 0;
         var _loc3_:uint = param1;
         var _loc4_:Array = [];
         var _loc5_:Array = this.getSegmentEndPoints(param1);
         var _loc6_:Boolean = Boolean(_loc5_[2]);
         param2 = Math.min(Math.max(param1 - _loc5_[0],_loc5_[1] - param1),param2);
         var _loc7_:int = param1 - param2;
         for(; _loc7_ <= param1 + param2; _loc7_++)
         {
            _loc10_ = uint(_loc7_);
            if(_loc7_ < _loc5_[0] || _loc7_ == _loc5_[0] && _loc6_)
            {
               if(!_loc6_)
               {
                  continue;
               }
               _loc10_ = _loc5_[1] + (_loc7_ - _loc5_[0]);
            }
            else if(_loc6_ && _loc7_ > _loc5_[1])
            {
               _loc10_ = _loc5_[0] + (_loc7_ - _loc5_[1]);
            }
            else if(_loc7_ > _loc5_[1])
            {
               continue;
            }
            if(_loc7_ == param1)
            {
               _loc3_ = _loc10_;
            }
            _loc4_.push(_loc10_);
         }
         var _loc8_:uint = uint(_loc4_.indexOf(_loc3_));
         var _loc9_:uint = _loc4_.length - 1;
         if(_loc8_ < _loc5_[0] + param2)
         {
            _loc4_.unshift(_loc4_[0]);
         }
         if(_loc9_ - _loc8_ < param2)
         {
            _loc4_.push(_loc4_[_loc4_.length - 1]);
         }
         return _loc4_;
      }
      
      public function getSegmentEndPoints(param1:uint = 0) : Array
      {
         var _loc5_:* = 0;
         param1 = Math.min(param1,length - 1);
         var _loc2_:Array = [param1,param1,false];
         var _loc3_:uint = param1;
         _loc5_ = int(param1 + 1);
         while(_loc5_ <= length - 1 && this[_loc5_][0] != "Z" && this[_loc5_][0] != "M")
         {
            _loc3_ = _loc5_;
            _loc5_++;
         }
         _loc2_[1] = _loc3_;
         _loc2_[2] = _loc5_ <= length - 1 && this[_loc5_][0] == "Z";
         var _loc4_:uint = _loc3_;
         _loc5_ = int(_loc3_ - 1);
         while(_loc5_ >= 0 && this[_loc5_][0] != "Z" && this[_loc4_][0] != "M")
         {
            _loc4_ = _loc5_;
            _loc5_--;
         }
         _loc2_[0] = _loc4_;
         return _loc2_;
      }
      
      public function isClosed() : Boolean
      {
         return Boolean(length) && this[length - 1] is Array && this[length - 1][0] == "z";
      }
      
      public function fromAnchorPoints(param1:Array) : void
      {
         var _loc3_:PathDrawContext = null;
         var _loc4_:uint = 0;
         var _loc5_:Point = null;
         var _loc6_:Boolean = false;
         var _loc2_:Point = param1[0];
         length = 0;
         this.push(["M",_loc2_.x,_loc2_.y]);
         if(param1.length < 3)
         {
            this.push(["L",param1[1].x,param1[1].y]);
         }
         else
         {
            _loc3_ = new PathDrawContext();
            _loc3_.cmds = this;
            _loc4_ = 1;
            while(_loc4_ < param1.length - 1)
            {
               this.processSegment(param1[_loc4_ - 1],param1[_loc4_],param1[_loc4_ + 1],_loc3_);
               _loc4_++;
            }
            _loc5_ = param1[param1.length - 1];
            _loc6_ = _loc5_.subtract(_loc2_).length < 10;
            if(_loc6_)
            {
               this.processSegment(param1[param1.length - 2],_loc5_,_loc2_,_loc3_);
               _loc3_.cmds.push(["z"]);
            }
            else
            {
               this.processSegment(param1[param1.length - 2],_loc5_,_loc5_,_loc3_);
            }
         }
      }
      
      public function pathIsClosed() : Boolean
      {
         var _loc4_:Array = null;
         var _loc5_:Rectangle = null;
         var _loc6_:BitmapData = null;
         var _loc7_:Matrix = null;
         var _loc8_:Rectangle = null;
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         var _loc3_:Point = new Point();
         _loc2_.lineStyle(0.5);
         for each(_loc4_ in this)
         {
            renderPathCmd(_loc4_,_loc2_,_loc3_);
         }
         _loc5_ = _loc1_.getBounds(_loc1_);
         _loc5_.width = Math.max(_loc5_.width,1);
         _loc5_.height = Math.max(_loc5_.height,1);
         _loc6_ = new BitmapData(_loc5_.width,_loc5_.height,true,0);
         _loc7_ = new Matrix(1,0,0,1,-_loc5_.topLeft.x,-_loc5_.topLeft.y);
         _loc6_.fillRect(_loc6_.rect,4294967295);
         _loc6_.draw(_loc1_,_loc7_);
         _loc6_.floodFill(0,0,4278190080);
         _loc6_.floodFill(0,_loc6_.height - 1,4278190080);
         _loc6_.floodFill(_loc6_.width - 1,_loc6_.height - 1,4278190080);
         _loc6_.floodFill(_loc6_.width - 1,0,4278190080);
         _loc8_ = _loc6_.getColorBoundsRect(4294967295,4294967295);
         _loc6_.dispose();
         if(_loc8_ != null && _loc8_.size.length > 0)
         {
            return true;
         }
         return false;
      }
      
      public function splitCurve(param1:uint, param2:Number) : uint
      {
         var _loc6_:Array = null;
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc9_:Point = null;
         var _loc10_:Point = null;
         var _loc11_:Point = null;
         var _loc12_:Point = null;
         if(param1 < 1)
         {
            return 0;
         }
         if(param1 >= length)
         {
            return length - 1;
         }
         if(param2 < 0.01)
         {
            return param1 - 1;
         }
         if(param2 > 0.99)
         {
            return param1;
         }
         var _loc3_:Array = this[param1];
         var _loc4_:Point = this.getPos(param1 - 1);
         var _loc5_:Point = this.getPos(param1);
         if(_loc3_[0] == "C")
         {
            _loc7_ = new Point(_loc3_[1],_loc3_[2]);
            _loc8_ = new Point(_loc3_[3],_loc3_[4]);
            _loc9_ = Point.interpolate(_loc8_,_loc7_,param2);
            _loc7_ = Point.interpolate(_loc7_,_loc4_,param2);
            _loc10_ = Point.interpolate(_loc5_,_loc8_,param2);
            _loc8_ = Point.interpolate(_loc9_,_loc7_,param2);
            _loc11_ = Point.interpolate(_loc10_,_loc9_,param2);
            _loc5_ = Point.interpolate(_loc11_,_loc8_,param2);
            _loc6_ = _loc3_.slice(0);
            _loc3_[1] = _loc7_.x;
            _loc3_[2] = _loc7_.y;
            _loc3_[3] = _loc8_.x;
            _loc3_[4] = _loc8_.y;
            _loc3_[5] = _loc5_.x;
            _loc3_[6] = _loc5_.y;
            _loc6_[1] = _loc11_.x;
            _loc6_[2] = _loc11_.y;
            _loc6_[3] = _loc10_.x;
            _loc6_[4] = _loc10_.y;
            splice(param1 + 1,0,_loc6_);
         }
         else if(_loc3_[0] == "L")
         {
            _loc12_ = Point.interpolate(_loc5_,_loc4_,param2);
            splice(param1,0,["L",_loc12_.x,_loc12_.y]);
         }
         return param1;
      }
      
      public function removeInvalidSegments(param1:Number) : void
      {
         var _loc4_:Array = null;
         var _loc5_:Point = null;
         var _loc6_:int = 0;
         var _loc7_:* = 0;
         var _loc8_:Number = NaN;
         var _loc2_:Number = Math.min(Math.max(1,param1 * 0.2),5);
         var _loc3_:int = 0;
         while(_loc3_ < length)
         {
            _loc4_ = this.getSegmentEndPoints(_loc3_);
            _loc5_ = this.getPos(_loc4_[0]);
            _loc6_ = _loc4_[0] + 1;
            _loc7_ = int(_loc4_[1] - _loc4_[0]);
            if(_loc7_ > 0)
            {
               _loc8_ = _loc5_.subtract(this.getPos(_loc6_)).length;
               if(this.getPos(_loc4_[1]).subtract(_loc5_).length < _loc2_ && _loc8_ < _loc2_)
               {
                  do
                  {
                     splice(_loc6_,1);
                     _loc7_--;
                     if(_loc6_ < length)
                     {
                        _loc8_ += _loc5_.subtract(this.getPos(_loc6_)).length;
                     }
                  }
                  while(_loc8_ < _loc2_ && _loc7_ > 1);
                  if(_loc7_ < 2)
                  {
                     splice(_loc4_[0],_loc7_ + 1);
                  }
                  else
                  {
                     _loc3_ = _loc4_[1] + 1;
                  }
               }
               else
               {
                  _loc3_ = _loc4_[1] + 1;
               }
            }
            else
            {
               splice(_loc4_[0],1);
            }
         }
      }
      
      public function reversePath(param1:uint = 0) : void
      {
         var _loc7_:Array = null;
         var _loc8_:Point = null;
         var _loc9_:Array = null;
         var _loc2_:Array = this.getSegmentEndPoints(param1);
         var _loc3_:Array = new Array(_loc2_[1] - _loc2_[0] + (_loc2_[2] ? 2 : 1));
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:* = int(_loc2_[1]);
         while(_loc6_ >= _loc2_[0])
         {
            _loc7_ = this[_loc6_];
            _loc8_ = this.getPos(_loc6_);
            if(_loc4_ == null)
            {
               _loc9_ = ["M",_loc8_.x,_loc8_.y];
            }
            else if(_loc4_[0] == "C")
            {
               _loc9_ = ["C",_loc4_[3],_loc4_[4],_loc4_[1],_loc4_[2],_loc8_.x,_loc8_.y];
            }
            else
            {
               if(_loc4_[0] != "L")
               {
                  throw new Error("Invalid path command!");
               }
               _loc9_ = ["L",_loc8_.x,_loc8_.y];
            }
            _loc3_[_loc5_] = _loc9_;
            _loc4_ = _loc7_;
            _loc5_++;
            _loc6_--;
         }
         if(_loc2_[2])
         {
            _loc3_[_loc5_] = ["Z"];
         }
         _loc3_.unshift(_loc3_.length);
         _loc3_.unshift(_loc2_[0]);
         super.splice.apply(this,_loc3_);
      }
      
      private function processSegment(param1:Point, param2:Point, param3:Point, param4:PathDrawContext) : void
      {
         var _loc5_:Number = param1.subtract(param2).length;
         var _loc6_:Number = param2.subtract(param3).length;
         var _loc7_:Number = param1.subtract(param3).length;
         var _loc8_:Number = _loc7_ / (_loc5_ + _loc6_);
         var _loc9_:Number = Math.min(_loc5_,_loc6_);
         var _loc10_:Point = getCurveTangent(param1,param2,param3);
         var _loc11_:Number = _loc8_ * _loc8_ * _loc9_ * 0.666;
         _loc10_.x *= _loc11_;
         _loc10_.y *= _loc11_;
         var _loc12_:Point = param4.acurve ? param1.add(param1.subtract(param4.lastcxy)) : param1;
         var _loc13_:Point = param2.subtract(_loc10_);
         this.getQuadraticBezierPoints(param1,_loc12_,_loc13_,param2,param4);
         param4.acurve = true;
         param4.lastcxy = _loc13_;
      }
      
      private function getQuadraticBezierPoints(param1:Point, param2:Point, param3:Point, param4:Point, param5:PathDrawContext) : void
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Point = null;
         var _loc6_:Point = intersect2Lines(param1,param2,param3,param4);
         if(Boolean(_loc6_ && !isNaN(_loc6_.x)) && Boolean(!isNaN(_loc6_.y)) && !param5.adjust)
         {
            _loc10_ = (param1.x + param4.x + _loc6_.x * 4 - (param2.x + param3.x) * 3) * 0.125;
            _loc11_ = (param1.y + param4.y + _loc6_.y * 4 - (param2.y + param3.y) * 3) * 0.125;
            if(_loc10_ * _loc10_ + _loc11_ * _loc11_ <= tolerance * tolerance)
            {
               param5.cmds.push(["Q",_loc6_.x,_loc6_.y,param4.x,param4.y]);
               return;
            }
         }
         else
         {
            _loc12_ = Point.interpolate(param1,param4,0.5);
            if(Point.distance(param1,_loc12_) <= tolerance || param5.adjust)
            {
               param5.cmds.push(["Q",_loc12_.x,_loc12_.y,param4.x,param4.y]);
               return;
            }
         }
         var _loc7_:Object = bezierSplit(param1,param2,param3,param4);
         var _loc8_:Object = _loc7_.b0;
         var _loc9_:Object = _loc7_.b1;
         this.getQuadraticBezierPoints(param1,_loc8_.b,_loc8_.c,_loc8_.d,param5);
         this.getQuadraticBezierPoints(_loc9_.a,_loc9_.b,_loc9_.c,param4,param5);
      }
      
      public function outputCommands(param1:int = 0, param2:int = -1) : void
      {
         var _loc4_:Array = null;
         if(param2 == -1)
         {
            param2 = length - 1;
         }
         var _loc3_:int = param1;
         while(_loc3_ <= param2)
         {
            _loc4_ = this[_loc3_];
            _loc3_++;
         }
      }
   }
}

