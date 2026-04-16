package svgutils
{
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class SVGImportPath
   {
      
      private var firstMove:Boolean;
      
      private var startX:Number;
      
      private var startY:Number;
      
      private var lastX:Number;
      
      private var lastY:Number;
      
      private var lastCX:Number;
      
      private var lastCY:Number;
      
      private const pathCmdArgCount:Object = {
         "A":7,
         "a":7,
         "C":6,
         "c":6,
         "H":1,
         "h":1,
         "L":2,
         "l":2,
         "M":2,
         "m":2,
         "Q":4,
         "q":4,
         "S":4,
         "s":4,
         "T":2,
         "t":2,
         "V":1,
         "v":1,
         "Z":0,
         "z":0
      };
      
      public function SVGImportPath()
      {
         super();
      }
      
      public function generatePathCmds(param1:SVGElement) : void
      {
         switch(param1.tag)
         {
            case "circle":
               param1.path = this.cmdsForCircleOrEllipse(param1);
               break;
            case "ellipse":
               param1.path = this.cmdsForCircleOrEllipse(param1);
               break;
            case "line":
               param1.path = this.cmdsForLine(param1);
               break;
            case "path":
               param1.path = this.cmdsForPath(param1);
               break;
            case "polygon":
               param1.path = this.cmdsForPolygon(param1);
               break;
            case "polyline":
               param1.path = this.cmdsForPolyline(param1);
               break;
            case "rect":
               param1.path = this.cmdsForRect(param1);
         }
      }
      
      private function cmdsForCircleOrEllipse(param1:SVGElement) : SVGPath
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc2_:Number = param1.getAttribute("cx",100);
         var _loc3_:Number = param1.getAttribute("cy",100);
         if("circle" == param1.tag)
         {
            _loc4_ = _loc5_ = param1.getAttribute("r",10);
         }
         else
         {
            _loc4_ = param1.getAttribute("rx",10);
            _loc5_ = param1.getAttribute("ry",5);
         }
         var _loc6_:SVGPath = new SVGPath(["M",_loc2_,_loc3_ - _loc5_],this.quarterCircle(true,_loc2_,_loc3_ - _loc5_,_loc2_ + _loc4_,_loc3_),this.quarterCircle(false,_loc2_ + _loc4_,_loc3_,_loc2_,_loc3_ + _loc5_),this.quarterCircle(true,_loc2_,_loc3_ + _loc5_,_loc2_ - _loc4_,_loc3_),this.quarterCircle(false,_loc2_ - _loc4_,_loc3_,_loc2_,_loc3_ - _loc5_),["Z"]);
         _loc6_.splitCurve(1,0.5);
         _loc6_.splitCurve(3,0.5);
         _loc6_.splitCurve(5,0.5);
         _loc6_.splitCurve(7,0.5);
         return _loc6_;
      }
      
      private function quarterCircle(param1:Boolean, param2:Number, param3:Number, param4:Number, param5:Number) : Array
      {
         var _loc6_:Number = 0.551784;
         var _loc7_:Number = param4 - param2;
         var _loc8_:Number = param5 - param3;
         return param1 ? ["C",param2 + _loc6_ * _loc7_,param3,param4,param5 - _loc6_ * _loc8_,param4,param5] : ["C",param2,param3 + _loc6_ * _loc8_,param4 - _loc6_ * _loc7_,param5,param4,param5];
      }
      
      private function cmdsForLine(param1:SVGElement) : SVGPath
      {
         return new SVGPath(["M",param1.getAttribute("x1",0),param1.getAttribute("y1",0)],["L",param1.getAttribute("x2",0),param1.getAttribute("y2",0)]);
      }
      
      private function cmdsForPolygon(param1:SVGElement) : SVGPath
      {
         var _loc2_:SVGPath = this.cmdsForPolyline(param1);
         if(_loc2_.length == 0)
         {
            return new SVGPath();
         }
         var _loc3_:Array = _loc2_[0];
         _loc2_.push(["L",_loc3_[1],_loc3_[2]]);
         return _loc2_;
      }
      
      private function cmdsForPolyline(param1:SVGElement) : SVGPath
      {
         var _loc2_:SVGPath = new SVGPath();
         var _loc3_:Array = param1.extractNumericArgs(param1.getAttribute("points",""));
         if(_loc3_.length < 4)
         {
            return new SVGPath();
         }
         _loc2_.push(["M",_loc3_[0],_loc3_[1]]);
         var _loc4_:int = 2;
         while(_loc4_ < _loc3_.length - 1)
         {
            _loc2_.push(["L",_loc3_[_loc4_],_loc3_[_loc4_ + 1]]);
            _loc4_ += 2;
         }
         return _loc2_;
      }
      
      private function cmdsForRect(param1:SVGElement) : SVGPath
      {
         var _loc2_:Number = param1.getAttribute("x",0);
         var _loc3_:Number = param1.getAttribute("y",0);
         var _loc4_:Number = param1.getAttribute("width",10);
         var _loc5_:Number = param1.getAttribute("height",10);
         return new SVGPath(["M",_loc2_,_loc3_],["L",_loc2_ + _loc4_,_loc3_],["L",_loc2_ + _loc4_,_loc3_ + _loc5_],["L",_loc2_,_loc3_ + _loc5_],["L",_loc2_,_loc3_],["Z"]);
      }
      
      private function cmdsForPath(param1:SVGElement) : SVGPath
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc6_:SVGPath = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:Array = [];
         this.firstMove = true;
         this.startX = this.startY = 0;
         this.lastX = this.lastY = 0;
         this.lastCX = this.lastCY = 0;
         var _loc3_:String = param1.getAttribute("d");
         for each(_loc4_ in _loc3_.match(/[A-DF-Za-df-z][^A-Za-df-z]*/g))
         {
            _loc7_ = _loc4_.charAt(0);
            _loc8_ = param1.extractNumericArgs(_loc4_.substr(1));
            _loc9_ = int(this.pathCmdArgCount[_loc7_]);
            if(_loc9_ == 0)
            {
               _loc2_.push(this.simplePathCommands(_loc7_,_loc8_));
            }
            else
            {
               if("m" == _loc7_.toLowerCase() && _loc8_.length > 2)
               {
                  _loc2_.push(this.simplePathCommands(_loc7_,_loc8_));
                  _loc8_ = _loc8_.slice(2);
                  _loc7_ = "M" == _loc7_ ? "L" : "l";
               }
               if(_loc8_.length == _loc9_)
               {
                  _loc2_.push(this.simplePathCommands(_loc7_,_loc8_));
               }
               else
               {
                  _loc10_ = 0;
                  while(_loc8_.length >= _loc10_ + _loc9_)
                  {
                     _loc2_.push(this.simplePathCommands(_loc7_,_loc8_.slice(_loc10_,_loc10_ + _loc9_)));
                     _loc10_ += _loc9_;
                  }
               }
            }
         }
         _loc5_ = [];
         _loc5_ = _loc5_.concat.apply(_loc5_,_loc2_);
         _loc6_ = new SVGPath();
         _loc6_.set(_loc5_);
         return _loc6_;
      }
      
      private function simplePathCommands(param1:String, param2:Array) : Array
      {
         switch(param1)
         {
            case "A":
               return this.arcCmds(param2,false);
            case "a":
               return this.arcCmds(param2,true);
            case "C":
               return [this.cubicCurveCmd(param2,false)];
            case "c":
               return [this.cubicCurveCmd(param2,true)];
            case "H":
               return [this.hLineCmd(param2[0])];
            case "h":
               return [this.hLineCmd(this.lastX + param2[0])];
            case "L":
               return [this.lineCmd(this.absoluteArgs(param2))];
            case "l":
               return [this.lineCmd(this.relativeArgs(param2))];
            case "M":
               return [this.moveCmd(this.absoluteArgs(param2))];
            case "m":
               return [this.moveCmd(this.relativeArgs(param2))];
            case "Q":
               return [this.quadraticCurveCmd(param2,false)];
            case "q":
               return [this.quadraticCurveCmd(param2,true)];
            case "S":
               return [this.cubicCurveSmoothCmd(param2,false)];
            case "s":
               return [this.cubicCurveSmoothCmd(param2,true)];
            case "T":
               return [this.quadraticCurveSmoothCmd(param2,false)];
            case "t":
               return [this.quadraticCurveSmoothCmd(param2,true)];
            case "V":
               return [this.vLineCmd(param2[0])];
            case "v":
               return [this.vLineCmd(this.lastY + param2[0])];
            case "Z":
            case "z":
               return [["Z"]];
            default:
               return [];
         }
      }
      
      private function absoluteArgs(param1:Array) : Array
      {
         this.lastX = param1[0];
         this.lastY = param1[1];
         return param1;
      }
      
      private function relativeArgs(param1:Array) : Array
      {
         this.lastX += param1[0];
         this.lastY += param1[1];
         return param1;
      }
      
      private function arcCmds(param1:Array, param2:Boolean) : Array
      {
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         var _loc29_:Point = null;
         var _loc30_:Point = null;
         var _loc31_:Point = null;
         var _loc3_:Point = new Point(this.lastX,this.lastY);
         this.lastX = param2 ? this.lastX + param1[5] : Number(param1[5]);
         this.lastY = param2 ? this.lastY + param1[6] : Number(param1[6]);
         var _loc4_:Point = new Point(this.lastX,this.lastY);
         var _loc5_:Number = Point.distance(_loc3_,_loc4_);
         if(_loc5_ == 0)
         {
            return [];
         }
         var _loc6_:Number = param1[0] * param1[1] == 0 ? _loc5_ / 2 : Math.abs(param1[0]);
         var _loc7_:Number = param1[0] * param1[1] == 0 ? _loc5_ / 2 : Math.abs(param1[1]);
         var _loc8_:Boolean = param1[3] == 1;
         var _loc9_:Boolean = param1[4] == 1;
         var _loc10_:Number = _loc8_ == _loc9_ ? 1 : -1;
         var _loc11_:Matrix = new Matrix();
         _loc11_.rotate(-param1[2] / Math.PI * 180);
         _loc11_.scale(1 / _loc6_,1 / _loc7_);
         _loc3_ = _loc11_.transformPoint(_loc3_);
         _loc4_ = _loc11_.transformPoint(_loc4_);
         _loc5_ = Point.distance(_loc3_,_loc4_);
         var _loc12_:Number = _loc5_ > 2 ? _loc5_ / 2 : 1;
         _loc11_ = new Matrix();
         _loc11_.scale(1 / _loc12_,1 / _loc12_);
         _loc3_ = _loc11_.transformPoint(_loc3_);
         _loc4_ = _loc11_.transformPoint(_loc4_);
         _loc5_ = Point.distance(_loc3_,_loc4_);
         var _loc13_:Point = new Point(_loc4_.x - _loc3_.x,_loc4_.y - _loc3_.y);
         var _loc14_:Point = new Point((_loc3_.x + _loc4_.x) / 2,(_loc3_.y + _loc4_.y) / 2);
         var _loc15_:Number = Math.sqrt(Math.max(0,1 - _loc5_ * _loc5_ / 4));
         var _loc16_:Point = new Point(_loc10_ * _loc13_.y / _loc5_ * _loc15_,-_loc10_ * _loc13_.x / _loc5_ * _loc15_);
         var _loc17_:Point = new Point(_loc14_.x + _loc16_.x,_loc14_.y + _loc16_.y);
         _loc11_ = new Matrix();
         _loc11_.translate(-_loc17_.x,-_loc17_.y);
         _loc3_ = _loc11_.transformPoint(_loc3_);
         _loc4_ = _loc11_.transformPoint(_loc4_);
         var _loc18_:Number = Math.atan2(_loc3_.y,_loc3_.x);
         var _loc19_:Number = Math.atan2(_loc4_.y,_loc4_.x);
         var _loc20_:Number = _loc19_ - _loc18_;
         if(_loc9_ && _loc20_ < 0)
         {
            _loc20_ += 2 * Math.PI;
         }
         if(!_loc9_ && _loc20_ > 0)
         {
            _loc20_ -= 2 * Math.PI;
         }
         var _loc21_:Matrix = new Matrix();
         _loc21_.translate(_loc17_.x,_loc17_.y);
         _loc21_.scale(_loc6_ * _loc12_,_loc7_ * _loc12_);
         _loc21_.rotate(param1[2] / Math.PI * 180);
         var _loc22_:Number = Math.PI / 2 * 1.001;
         var _loc23_:int = Math.ceil(Math.abs(_loc20_) / _loc22_);
         var _loc24_:Number = 4 / 3 * (1 - Math.cos(_loc20_ / 2 / _loc23_)) / Math.sin(_loc20_ / 2 / _loc23_);
         var _loc25_:Array = new Array();
         var _loc26_:int = 0;
         while(_loc26_ < _loc23_)
         {
            _loc27_ = _loc18_ + _loc20_ * (_loc26_ / _loc23_);
            _loc28_ = _loc18_ + _loc20_ * ((_loc26_ + 1) / _loc23_);
            _loc29_ = _loc21_.transformPoint(new Point(Math.cos(_loc27_) - _loc24_ * Math.sin(_loc27_),Math.sin(_loc27_) + _loc24_ * Math.cos(_loc27_)));
            _loc30_ = _loc21_.transformPoint(new Point(Math.cos(_loc28_) + _loc24_ * Math.sin(_loc28_),Math.sin(_loc28_) - _loc24_ * Math.cos(_loc28_)));
            _loc31_ = _loc21_.transformPoint(new Point(Math.cos(_loc28_),Math.sin(_loc28_)));
            _loc25_.push(["C",_loc29_.x,_loc29_.y,_loc30_.x,_loc30_.y,_loc31_.x,_loc31_.y]);
            _loc26_++;
         }
         return _loc25_;
      }
      
      private function closePath() : Array
      {
         this.lastX = this.startX;
         this.lastY = this.startY;
         this.firstMove = true;
         return ["L",this.lastX,this.lastY];
      }
      
      private function hLineCmd(param1:Number) : Array
      {
         this.lastX = param1;
         return ["L",this.lastX,this.lastY];
      }
      
      private function lineCmd(param1:Array) : Array
      {
         return ["L",this.lastX,this.lastY];
      }
      
      private function moveCmd(param1:Array) : Array
      {
         if(this.firstMove)
         {
            this.startX = this.lastX;
            this.startY = this.lastY;
            this.lastCX = this.lastX;
            this.lastCY = this.lastY;
            this.firstMove = false;
         }
         return ["M",this.lastX,this.lastY];
      }
      
      private function vLineCmd(param1:Number) : Array
      {
         this.lastY = param1;
         return ["L",this.lastX,this.lastY];
      }
      
      private function cubicCurveCmd(param1:Array, param2:Boolean) : Array
      {
         var _loc3_:Number = param2 ? this.lastX + param1[0] : Number(param1[0]);
         var _loc4_:Number = param2 ? this.lastY + param1[1] : Number(param1[1]);
         this.lastCX = param2 ? this.lastX + param1[2] : Number(param1[2]);
         this.lastCY = param2 ? this.lastY + param1[3] : Number(param1[3]);
         this.lastX = param2 ? this.lastX + param1[4] : Number(param1[4]);
         this.lastY = param2 ? this.lastY + param1[5] : Number(param1[5]);
         return ["C",_loc3_,_loc4_,this.lastCX,this.lastCY,this.lastX,this.lastY];
      }
      
      private function cubicCurveSmoothCmd(param1:Array, param2:Boolean) : Array
      {
         var _loc3_:Number = this.lastX + (this.lastX - this.lastCX);
         var _loc4_:Number = this.lastY + (this.lastY - this.lastCY);
         this.lastCX = param2 ? this.lastX + param1[0] : Number(param1[0]);
         this.lastCY = param2 ? this.lastY + param1[1] : Number(param1[1]);
         this.lastX = param2 ? this.lastX + param1[2] : Number(param1[2]);
         this.lastY = param2 ? this.lastY + param1[3] : Number(param1[3]);
         return ["C",_loc3_,_loc4_,this.lastCX,this.lastCY,this.lastX,this.lastY];
      }
      
      private function quadraticCurveCmd(param1:Array, param2:Boolean) : Array
      {
         var _loc3_:Number = this.lastX;
         var _loc4_:Number = this.lastY;
         this.lastCX = param2 ? this.lastX + param1[0] : Number(param1[0]);
         this.lastCY = param2 ? this.lastY + param1[1] : Number(param1[1]);
         this.lastX = param2 ? this.lastX + param1[2] : Number(param1[2]);
         this.lastY = param2 ? this.lastY + param1[3] : Number(param1[3]);
         var _loc5_:Number = _loc3_ + (this.lastCX - _loc3_) * 2 / 3;
         var _loc6_:Number = _loc4_ + (this.lastCY - _loc4_) * 2 / 3;
         var _loc7_:Number = this.lastX + (this.lastCX - this.lastX) * 2 / 3;
         var _loc8_:Number = this.lastY + (this.lastCY - this.lastY) * 2 / 3;
         return ["C",_loc5_,_loc6_,_loc7_,_loc8_,this.lastX,this.lastY];
      }
      
      private function quadraticCurveSmoothCmd(param1:Array, param2:Boolean) : Array
      {
         var _loc3_:Number = this.lastX;
         var _loc4_:Number = this.lastY;
         this.lastCX = this.lastX + (this.lastX - this.lastCX);
         this.lastCY = this.lastY + (this.lastY - this.lastCY);
         this.lastX = param2 ? this.lastX + param1[0] : Number(param1[0]);
         this.lastY = param2 ? this.lastY + param1[1] : Number(param1[1]);
         var _loc5_:Number = _loc3_ + (this.lastCX - _loc3_) * 2 / 3;
         var _loc6_:Number = _loc4_ + (this.lastCY - _loc4_) * 2 / 3;
         var _loc7_:Number = this.lastX + (this.lastCX - this.lastX) * 2 / 3;
         var _loc8_:Number = this.lastY + (this.lastCY - this.lastY) * 2 / 3;
         return ["C",_loc5_,_loc6_,_loc7_,_loc8_,this.lastX,this.lastY];
      }
   }
}

