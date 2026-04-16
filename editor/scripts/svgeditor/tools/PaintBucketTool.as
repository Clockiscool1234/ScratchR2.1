package svgeditor.tools
{
   import com.hangunsworld.util.BMPFunctions;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import svgeditor.*;
   import svgeditor.objs.*;
   
   public final class PaintBucketTool extends SVGTool
   {
      
      private var highlightedObj:DisplayObject;
      
      private var tolerance:uint;
      
      private var lastClick:Point;
      
      private var savedBM:BitmapData;
      
      public function PaintBucketTool(param1:ImageEdit)
      {
         super(param1);
         this.tolerance = 30;
         this.lastClick = new Point(editor.mouseX,editor.mouseY);
         cursorBMName = "paintbucketOff";
         cursorHotSpot = new Point(20,18);
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:Sprite = editor is BitmapEdit ? editor.getWorkArea() : editor.getContentLayer();
         _loc1_.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
         if(editor is SVGEdit)
         {
            editor.getContentLayer().addEventListener(MouseEvent.ROLL_OVER,this.rollOver,false,0,true);
            editor.getContentLayer().addEventListener(MouseEvent.ROLL_OUT,this.rollOut,false,0,true);
         }
      }
      
      override protected function shutdown() : void
      {
         if(this.highlightedObj)
         {
            this.highlightedObj.filters = [];
         }
         if(this.savedBM)
         {
            this.savedBM.dispose();
         }
         var _loc1_:Sprite = editor is BitmapEdit ? editor.getWorkArea() : editor.getContentLayer();
         _loc1_.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         if(editor is SVGEdit)
         {
            editor.getContentLayer().removeEventListener(MouseEvent.ROLL_OVER,this.rollOver);
            editor.getContentLayer().removeEventListener(MouseEvent.ROLL_OUT,this.rollOut);
            editor.getContentLayer().removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         }
         super.shutdown();
      }
      
      private function rollOver(param1:MouseEvent) : void
      {
         editor.getContentLayer().addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove,false,0,true);
         this.checkUnderMouse();
      }
      
      private function rollOut(param1:MouseEvent) : void
      {
         editor.getContentLayer().removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         this.checkUnderMouse();
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         var _loc3_:Bitmap = null;
         var _loc4_:DrawProperties = null;
         currentEvent = param1;
         var _loc2_:ISVGEditable = getEditableUnderMouse();
         _loc2_ = this.highlightedObj as ISVGEditable;
         if(_loc2_ is SVGBitmap || editor is BitmapEdit)
         {
            _loc3_ = editor is BitmapEdit ? editor.getWorkArea().getBitmap() : _loc2_ as Bitmap;
            if(Point.distance(new Point(editor.mouseX,editor.mouseY),this.lastClick) < 3)
            {
               this.tolerance += 10;
               if(this.savedBM)
               {
                  _loc3_.bitmapData = this.savedBM.clone();
               }
            }
            else
            {
               this.tolerance = 30;
               if(this.savedBM)
               {
                  this.savedBM.dispose();
               }
               this.savedBM = _loc3_.bitmapData.clone();
            }
            if(editor is BitmapEdit)
            {
               this.bitmapFloodFill(_loc3_.bitmapData,_loc3_.mouseX,_loc3_.mouseY);
            }
            else
            {
               _loc4_ = editor.getShapeProps();
               if(this.tolerance < 1)
               {
                  _loc3_.bitmapData.floodFill(_loc3_.mouseX,_loc3_.mouseY,_loc4_.rawColor);
               }
               else
               {
                  BMPFunctions.floodFill(_loc3_.bitmapData,_loc3_.mouseX,_loc3_.mouseY,_loc4_.rawColor,this.tolerance,true);
               }
            }
            this.lastClick = new Point(editor.mouseX,editor.mouseY);
            dispatchEvent(new Event(Event.CHANGE));
         }
         if(!(_loc2_ is SVGBitmap) && !(editor is BitmapEdit) && Boolean(this.savedBM))
         {
            this.savedBM.dispose();
            this.savedBM = null;
         }
      }
      
      private function mouseMove(param1:MouseEvent) : void
      {
         this.checkUnderMouse();
      }
      
      private function objIsFillable(param1:ISVGEditable) : Boolean
      {
         return param1 is SVGBitmap;
      }
      
      private function checkUnderMouse() : void
      {
         var _loc1_:ISVGEditable = getEditableUnderMouse(false);
         if(!this.objIsFillable(_loc1_))
         {
            _loc1_ = null;
         }
         if(_loc1_ != this.highlightedObj)
         {
            if(this.highlightedObj)
            {
               this.highlightedObj.filters = [];
            }
            this.highlightedObj = _loc1_ as DisplayObject;
            if(Boolean(this.highlightedObj) && this.objIsFillable(_loc1_))
            {
               this.highlightedObj.filters = [new GlowFilter(2663898)];
            }
         }
      }
      
      private function bitmapFloodFill(param1:BitmapData, param2:int, param3:int) : void
      {
         var _loc4_:uint = 4294902015;
         var _loc5_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         var _loc6_:uint = param1.getPixel32(param2,param3);
         var _loc7_:uint = this.toleranceMask();
         if((_loc6_ >> 24 & 0xFF) < 255)
         {
            _loc7_ &= 4278190080;
         }
         _loc5_.threshold(param1,_loc5_.rect,new Point(0,0),"==",_loc6_,0xFF000000 | _loc6_,_loc7_);
         _loc5_.floodFill(param2,param3,_loc4_);
         var _loc8_:Rectangle = _loc5_.getColorBoundsRect(4294967295,_loc4_);
         _loc8_.width = Math.max(_loc8_.width,1);
         _loc8_.height = Math.max(_loc8_.height,1);
         var _loc9_:BitmapData = new BitmapData(_loc8_.width,_loc8_.height,true,0);
         _loc9_.threshold(_loc5_,_loc8_,new Point(0,0),"==",_loc4_,4278190080);
         var _loc10_:BitmapData = new BitmapData(_loc8_.width,_loc8_.height,true,0);
         _loc10_.threshold(_loc5_,_loc8_,new Point(0,0),"!=",_loc4_,4278190080);
         var _loc11_:BitmapData = new BitmapData(_loc8_.width,_loc8_.height,true,0);
         this.gradientFill(_loc11_,_loc11_.rect,param2 - _loc8_.x,param3 - _loc8_.y);
         _loc11_.copyPixels(_loc11_,_loc11_.rect,new Point(0,0),_loc9_);
         var _loc12_:BitmapData = new BitmapData(_loc8_.width,_loc8_.height,true,0);
         _loc12_.copyPixels(param1,_loc8_,new Point(0,0),_loc10_);
         _loc12_.draw(new Bitmap(_loc11_));
         param1.copyPixels(_loc12_,_loc12_.rect,_loc8_.topLeft);
      }
      
      private function toleranceMask() : uint
      {
         var _loc1_:int = Math.max(0,Math.min(this.tolerance / 10,7));
         var _loc2_:int = 255 << _loc1_ & 0xFF;
         return _loc2_ << 24 | _loc2_ << 16 | _loc2_ << 8 | _loc2_;
      }
      
      private function gradientFill(param1:BitmapData, param2:Rectangle, param3:int, param4:int) : void
      {
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc5_:DrawProperties = editor.getShapeProps();
         var _loc6_:Array = [_loc5_.color,_loc5_.secondColor];
         var _loc7_:Array = [_loc5_.alpha,_loc5_.secondAlpha];
         var _loc8_:Array = [0,255];
         var _loc9_:Matrix = new Matrix();
         var _loc10_:Shape = new Shape();
         var _loc11_:Graphics = _loc10_.graphics;
         switch(_loc5_.fillType)
         {
            case "linearHorizontal":
               _loc9_.createGradientBox(param2.width,param2.height,0,0,0);
               _loc11_.beginGradientFill(GradientType.LINEAR,_loc6_,_loc7_,_loc8_,_loc9_);
               break;
            case "linearVertical":
               _loc9_.createGradientBox(param2.width,param2.height,Math.PI / 2,0,0);
               _loc11_.beginGradientFill(GradientType.LINEAR,_loc6_,_loc7_,_loc8_,_loc9_);
               break;
            case "radial":
               _loc12_ = param3 / param2.width;
               _loc13_ = param4 / param2.height;
               _loc14_ = (65 + 1.3 * Math.max(Math.abs(_loc12_ * 100 - 50),Math.abs(_loc13_ * 100 - 50))) / 100;
               _loc15_ = param2.width * _loc14_;
               _loc16_ = param2.height * _loc14_;
               _loc9_.createGradientBox(2 * _loc15_,2 * _loc16_,0,param3 - _loc15_,param4 - _loc16_);
               _loc11_.beginGradientFill(GradientType.RADIAL,_loc6_,_loc7_,_loc8_,_loc9_,SpreadMethod.PAD,InterpolationMethod.RGB,0);
               break;
            default:
               _loc11_.beginFill(_loc6_[0],_loc7_[0]);
         }
         _loc11_.drawRect(0,0,param2.width,param2.height);
         _loc9_ = new Matrix();
         _loc9_.translate(param2.x,param2.y);
         param1.draw(_loc10_,_loc9_);
      }
   }
}

