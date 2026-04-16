package svgeditor
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import svgeditor.objs.ISVGEditable;
   import svgeditor.objs.SVGBitmap;
   import svgeditor.objs.SVGGroup;
   import svgeditor.objs.SVGShape;
   import svgeditor.objs.SVGTextField;
   import svgutils.SVGElement;
   
   public class Selection implements IEventDispatcher
   {
      
      private var selectedObjects:Array;
      
      private var refDispObj:DisplayObject;
      
      private var initialMatrices:Array;
      
      private var initialTempMatrix:Matrix;
      
      private var rotationCenter:Point;
      
      private var origRect:Rectangle;
      
      private var maintainAspectRatio:Boolean;
      
      public function Selection(param1:Array)
      {
         super();
         this.selectedObjects = param1;
         this.createRefObject();
      }
      
      private function createRefObject() : void
      {
         var _loc1_:Sprite = null;
         var _loc2_:Rectangle = null;
         if(this.refDispObj != null)
         {
            if(this.refDispObj.parent)
            {
               this.refDispObj.parent.removeChild(this.refDispObj);
            }
            this.refDispObj = null;
         }
         _loc1_ = new Sprite();
         this.refDispObj = _loc1_;
         this.selectedObjects[0].parent.addChild(this.refDispObj);
         if(this.selectedObjects.length == 1)
         {
            _loc1_.rotation = this.selectedObjects[0].rotation;
            _loc2_ = this.getBounds(_loc1_);
         }
         else
         {
            _loc2_ = this.getBounds(this.selectedObjects[0].parent);
         }
         _loc1_.x = _loc2_.left;
         _loc1_.y = _loc2_.top;
      }
      
      public function cloneObjs(param1:Sprite) : Array
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Matrix = null;
         var _loc7_:ISVGEditable = null;
         var _loc2_:Array = null;
         if(!this.selectedObjects.length)
         {
            return _loc2_;
         }
         var _loc3_:Array = [];
         var _loc4_:uint = 0;
         while(_loc4_ < this.selectedObjects.length)
         {
            _loc5_ = this.selectedObjects[_loc4_].parent;
            _loc6_ = new Matrix();
            while(_loc5_ != param1)
            {
               _loc6_.concat(_loc5_.transform.matrix);
               _loc5_ = _loc5_.parent;
            }
            _loc7_ = this.selectedObjects[_loc4_].clone();
            (_loc7_ as DisplayObject).transform.matrix.concat(_loc6_);
            _loc7_.getElement().transform = (_loc7_ as DisplayObject).transform.matrix.clone();
            _loc3_.push(_loc7_);
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function shutdown() : void
      {
         if(this.refDispObj.parent)
         {
            this.refDispObj.parent.removeChild(this.refDispObj);
         }
         this.refDispObj = null;
      }
      
      public function contains(param1:DisplayObject) : Boolean
      {
         return this.selectedObjects.indexOf(param1) != -1;
      }
      
      public function raise(param1:Boolean = false) : void
      {
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         var _loc2_:DisplayObjectContainer = this.refDispObj.parent;
         var _loc3_:uint = _loc2_.numChildren - 1;
         if(param1)
         {
            _loc4_ = 0;
            while(_loc4_ < this.selectedObjects.length)
            {
               _loc2_.setChildIndex(this.selectedObjects[_loc4_],_loc3_);
               _loc4_++;
            }
         }
         else
         {
            _loc4_ = 0;
            while(_loc4_ < this.selectedObjects.length)
            {
               _loc5_ = this.getNextIndex(_loc2_.getChildIndex(this.selectedObjects[_loc4_]),1);
               _loc2_.setChildIndex(this.selectedObjects[_loc4_],_loc5_);
               _loc4_++;
            }
         }
      }
      
      public function lower(param1:Boolean = false) : void
      {
         var _loc3_:uint = 0;
         var _loc4_:uint = 0;
         var _loc2_:DisplayObjectContainer = this.refDispObj.parent;
         if(param1)
         {
            _loc3_ = 0;
            while(_loc3_ < this.selectedObjects.length)
            {
               _loc2_.setChildIndex(this.selectedObjects[_loc3_],0);
               _loc3_++;
            }
         }
         else
         {
            _loc3_ = 0;
            while(_loc3_ < this.selectedObjects.length)
            {
               _loc4_ = this.getNextIndex(_loc2_.getChildIndex(this.selectedObjects[_loc3_]),-1);
               _loc2_.setChildIndex(this.selectedObjects[_loc3_],_loc4_);
               _loc3_++;
            }
         }
      }
      
      private function getNextIndex(param1:int, param2:int) : uint
      {
         var _loc3_:DisplayObjectContainer = this.refDispObj.parent;
         param1 += param2;
         while(param1 > 0 && param1 < _loc3_.numChildren && !(_loc3_.getChildAt(param1) is ISVGEditable))
         {
            param1 += param2;
         }
         return int(Math.max(0,Math.min(_loc3_.numChildren - 1,param1)));
      }
      
      public function remove() : void
      {
         var _loc2_:uint = 0;
         if(this.selectedObjects.length == 0)
         {
            return;
         }
         var _loc1_:DisplayObjectContainer = this.selectedObjects[0].parent;
         if(_loc1_)
         {
            _loc2_ = 0;
            while(_loc2_ < this.selectedObjects.length)
            {
               _loc1_.removeChild(this.selectedObjects[_loc2_]);
               _loc2_++;
            }
         }
         this.selectedObjects = [];
      }
      
      public function group() : Selection
      {
         var _loc1_:DisplayObjectContainer = null;
         var _loc2_:SVGGroup = null;
         var _loc3_:uint = 0;
         if(this.selectedObjects.length > 1)
         {
            _loc1_ = this.selectedObjects[0].parent;
            _loc2_ = new SVGGroup(new SVGElement("g",""));
            _loc1_.addChild(_loc2_);
            _loc3_ = 0;
            while(_loc3_ < _loc1_.numChildren)
            {
               if(this.selectedObjects.indexOf(_loc1_.getChildAt(_loc3_)) != -1)
               {
                  _loc2_.addChild(_loc1_.getChildAt(_loc3_));
                  _loc3_--;
               }
               _loc3_++;
            }
            return new Selection([_loc2_]);
         }
         return this;
      }
      
      public function ungroup() : Selection
      {
         var _loc1_:Matrix = null;
         var _loc2_:SVGGroup = null;
         var _loc3_:uint = 0;
         var _loc4_:Array = null;
         var _loc5_:uint = 0;
         var _loc6_:DisplayObject = null;
         var _loc7_:Matrix = null;
         if(this.isGroup())
         {
            _loc1_ = this.selectedObjects[0].transform.matrix;
            _loc2_ = this.selectedObjects[0];
            _loc3_ = _loc2_.parent.getChildIndex(_loc2_) + 1;
            _loc4_ = [];
            while(_loc2_.numChildren)
            {
               _loc5_ = _loc2_.numChildren - 1;
               _loc6_ = _loc2_.getChildAt(_loc5_);
               _loc7_ = _loc6_.transform.matrix.clone();
               _loc7_.concat(_loc1_);
               _loc6_.transform.matrix = _loc7_;
               _loc4_.push(_loc6_);
               _loc2_.parent.addChildAt(_loc6_,_loc3_);
            }
            _loc2_.parent.removeChild(_loc2_);
            return new Selection(_loc4_);
         }
         return this;
      }
      
      public function isGroup() : Boolean
      {
         return this.selectedObjects.length == 1 && this.selectedObjects[0] is SVGGroup;
      }
      
      public function isTextField() : Boolean
      {
         return this.selectedObjects.length == 1 && this.selectedObjects[0] is SVGTextField;
      }
      
      public function canMoveByMouse() : Boolean
      {
         return !this.isTextField() || (this.selectedObjects[0] as SVGTextField).selectable == false;
      }
      
      public function isShape() : Boolean
      {
         return this.selectedObjects.length == 1 && this.selectedObjects[0] is SVGShape;
      }
      
      public function isImage() : Boolean
      {
         return this.selectedObjects.length == 1 && this.selectedObjects[0] is SVGBitmap;
      }
      
      public function getObjs() : Array
      {
         return this.selectedObjects;
      }
      
      public function saveTransform() : void
      {
         var _loc2_:SVGElement = null;
         var _loc3_:Matrix = null;
         var _loc1_:uint = 0;
         while(_loc1_ < this.selectedObjects.length)
         {
            _loc2_ = (this.selectedObjects[_loc1_] as ISVGEditable).getElement();
            _loc3_ = this.selectedObjects[_loc1_].transform.matrix;
            _loc2_.setAttribute("transform","matrix(" + _loc3_.a + "," + _loc3_.b + "," + _loc3_.c + "," + _loc3_.d + "," + _loc3_.tx + "," + _loc3_.ty + ")");
            _loc1_++;
         }
      }
      
      public function getRotation(param1:Sprite) : Number
      {
         var _loc2_:Matrix = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Sprite = null;
         if(this.selectedObjects.length == 1)
         {
            _loc2_ = new Matrix();
            _loc3_ = this.selectedObjects[0] as DisplayObject;
            while(Boolean(_loc3_) && _loc3_ != param1)
            {
               _loc2_.concat(_loc3_.transform.matrix);
               _loc3_ = _loc3_.parent;
            }
            _loc4_ = new Sprite();
            _loc4_.transform.matrix = _loc2_;
            return _loc4_.rotation;
         }
         return 0;
      }
      
      public function startResize(param1:String) : void
      {
         this.saveMatrices();
         this.origRect = this.getBounds(this.refDispObj);
         this.maintainAspectRatio = param1 != param1.toLowerCase();
      }
      
      public function scaleByMouse(param1:String) : void
      {
         var _loc5_:String = null;
         var _loc6_:Point = null;
         var _loc8_:DisplayObject = null;
         var _loc2_:Rectangle = this.origRect;
         var _loc3_:Number = 1;
         var _loc4_:Number = 1;
         switch(param1)
         {
            case "topLeft":
               _loc5_ = "bottomRight";
               _loc3_ = (_loc2_.right - this.refDispObj.mouseX) / _loc2_.width;
               _loc4_ = (_loc2_.bottom - this.refDispObj.mouseY) / _loc2_.height;
               break;
            case "top":
               _loc5_ = "bottomRight";
               _loc4_ = (_loc2_.bottom - this.refDispObj.mouseY) / _loc2_.height;
               break;
            case "topRight":
               _loc5_ = "bottomLeft";
               _loc3_ = (this.refDispObj.mouseX - _loc2_.left) / _loc2_.width;
               _loc4_ = (_loc2_.bottom - this.refDispObj.mouseY) / _loc2_.height;
               break;
            case "right":
               _loc5_ = "topLeft";
               _loc3_ = (this.refDispObj.mouseX - _loc2_.left) / _loc2_.width;
               break;
            case "bottomLeft":
               _loc5_ = "topRight";
               _loc3_ = (_loc2_.right - this.refDispObj.mouseX) / _loc2_.width;
               _loc4_ = (this.refDispObj.mouseY - _loc2_.top) / _loc2_.height;
               break;
            case "bottom":
               _loc5_ = "topLeft";
               _loc4_ = (this.refDispObj.mouseY - _loc2_.top) / _loc2_.height;
               break;
            case "bottomRight":
               _loc5_ = "topLeft";
               _loc3_ = (this.refDispObj.mouseX - _loc2_.left) / _loc2_.width;
               _loc4_ = (this.refDispObj.mouseY - _loc2_.top) / _loc2_.height;
               break;
            case "left":
               _loc5_ = "bottomRight";
               _loc3_ = (_loc2_.right - this.refDispObj.mouseX) / _loc2_.width;
         }
         switch(_loc5_)
         {
            case "topLeft":
            case "bottomRight":
               _loc6_ = _loc2_[_loc5_];
               break;
            case "topRight":
               _loc6_ = new Point(_loc2_.right,_loc2_.top);
               break;
            case "bottomLeft":
               _loc6_ = new Point(_loc2_.left,_loc2_.bottom);
         }
         _loc6_ = this.refDispObj.parent.globalToLocal(this.refDispObj.localToGlobal(_loc6_));
         if(this.maintainAspectRatio)
         {
            _loc3_ = _loc4_ = Math.min(_loc3_,_loc4_);
         }
         var _loc7_:uint = 0;
         while(_loc7_ < this.selectedObjects.length)
         {
            _loc8_ = this.selectedObjects[_loc7_];
            this.scaleAroundPoint(_loc8_,_loc6_.x,_loc6_.y,_loc3_,_loc4_,this.initialMatrices[_loc7_].clone());
            _loc7_++;
         }
      }
      
      private function scaleAroundPoint(param1:DisplayObject, param2:int, param3:int, param4:Number, param5:Number, param6:Matrix) : void
      {
         var _loc7_:Number = this.refDispObj.rotation * Math.PI / 180;
         param6.translate(-param2,-param3);
         param6.rotate(-_loc7_);
         param6.scale(param4,param5);
         param6.rotate(_loc7_);
         param6.translate(param2,param3);
         param1.transform.matrix = param6;
      }
      
      public function flip(param1:Boolean = false) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc2_:Rectangle = this.getBounds(this.refDispObj.parent);
         var _loc3_:Point = new Point((_loc2_.left + _loc2_.right) / 2,(_loc2_.top + _loc2_.bottom) / 2);
         var _loc4_:uint = 0;
         while(_loc4_ < this.selectedObjects.length)
         {
            _loc5_ = this.selectedObjects[_loc4_];
            this.flipAroundPoint(_loc5_,_loc3_.x,_loc3_.y,param1);
            _loc4_++;
         }
      }
      
      private function flipAroundPoint(param1:DisplayObject, param2:Number, param3:Number, param4:Boolean) : void
      {
         var _loc5_:Point = param1.parent.localToGlobal(new Point(param2,param3));
         var _loc6_:Matrix = param1.transform.concatenatedMatrix.clone();
         _loc6_.translate(-_loc5_.x,-_loc5_.y);
         _loc6_.scale(param4 ? 1 : -1,param4 ? -1 : 1);
         _loc6_.translate(_loc5_.x,_loc5_.y);
         var _loc7_:Matrix = param1.parent.transform.concatenatedMatrix.clone();
         _loc7_.invert();
         _loc6_.concat(_loc7_);
         param1.transform.matrix = _loc6_;
      }
      
      public function startRotation(param1:Point) : void
      {
         this.rotationCenter = this.refDispObj.parent.globalToLocal(param1);
         this.saveMatrices();
         this.initialTempMatrix = this.refDispObj.transform.matrix.clone();
      }
      
      private function saveMatrices() : void
      {
         this.initialMatrices = new Array();
         var _loc1_:uint = 0;
         while(_loc1_ < this.selectedObjects.length)
         {
            this.initialMatrices.push(this.selectedObjects[_loc1_].transform.matrix.clone());
            _loc1_++;
         }
      }
      
      public function setShapeProperties(param1:DrawProperties) : void
      {
         var _loc3_:SVGElement = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.selectedObjects.length)
         {
            _loc3_ = this.selectedObjects[_loc2_].getElement();
            _loc3_.applyShapeProps(param1);
            this.selectedObjects[_loc2_].redraw();
            _loc2_++;
         }
      }
      
      public function doRotation(param1:Number) : void
      {
         var _loc4_:Matrix = null;
         var _loc2_:Point = this.rotationCenter;
         var _loc3_:uint = 0;
         while(_loc3_ < this.selectedObjects.length)
         {
            _loc4_ = this.initialMatrices[_loc3_].clone();
            _loc4_.translate(-_loc2_.x,-_loc2_.y);
            _loc4_.rotate(param1);
            _loc4_.translate(_loc2_.x,_loc2_.y);
            this.selectedObjects[_loc3_].transform.matrix = _loc4_;
            _loc3_++;
         }
         _loc4_ = this.initialTempMatrix.clone();
         _loc4_.translate(-_loc2_.x,-_loc2_.y);
         _loc4_.rotate(param1);
         _loc4_.translate(_loc2_.x,_loc2_.y);
         this.refDispObj.transform.matrix = _loc4_;
      }
      
      public function getGlobalBoundingPoints() : Object
      {
         var _loc1_:Rectangle = this.getBounds(this.refDispObj);
         return {
            "topLeft":this.refDispObj.localToGlobal(_loc1_.topLeft),
            "topRight":this.refDispObj.localToGlobal(new Point(_loc1_.right,_loc1_.top)),
            "botLeft":this.refDispObj.localToGlobal(new Point(_loc1_.left,_loc1_.bottom)),
            "botRight":this.refDispObj.localToGlobal(_loc1_.bottomRight)
         };
      }
      
      public function setTLPosition(param1:Point) : void
      {
         var _loc4_:Point = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:Point = null;
         var _loc2_:Point = this.refDispObj.parent.globalToLocal(param1);
         var _loc3_:Point = this.refDispObj.localToGlobal(this.getBounds(this.refDispObj).topLeft);
         _loc4_ = _loc2_.subtract(this.refDispObj.parent.globalToLocal(_loc3_));
         var _loc5_:uint = 0;
         while(_loc5_ < this.selectedObjects.length)
         {
            _loc6_ = this.selectedObjects[_loc5_];
            _loc6_.x += _loc4_.x;
            _loc6_.y += _loc4_.y;
            _loc7_ = new Point(_loc6_.x,_loc6_.y);
            _loc5_++;
         }
         this.refDispObj.x += _loc4_.x;
         this.refDispObj.y += _loc4_.y;
      }
      
      public function getBounds(param1:DisplayObject) : Rectangle
      {
         var _loc3_:uint = 0;
         var _loc2_:Rectangle = this.selectedObjects[0].getBounds(param1);
         if(this.selectedObjects.length > 1)
         {
            _loc3_ = 1;
            while(_loc3_ < this.selectedObjects.length)
            {
               _loc2_ = _loc2_.union(this.selectedObjects[_loc3_].getBounds(param1));
               _loc3_++;
            }
         }
         return _loc2_;
      }
      
      public function toggleHighlight(param1:Boolean) : void
      {
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         var _loc6_:uint = 0;
         while(_loc6_ < this.selectedObjects.length)
         {
            this.selectedObjects[_loc6_].addEventListener(param1,param2,param3,param4,param5);
            _loc6_++;
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         var _loc4_:uint = 0;
         while(_loc4_ < this.selectedObjects.length)
         {
            this.selectedObjects[_loc4_].removeEventListener(param1,param2,param3);
            _loc4_++;
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         var _loc2_:Boolean = false;
         var _loc3_:uint = 0;
         while(_loc3_ < this.selectedObjects.length)
         {
            if(this.selectedObjects[_loc3_].dispatchEvent(param1))
            {
               _loc2_ = true;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this.selectedObjects[0].hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this.selectedObjects[0].willTrigger(param1);
      }
   }
}

