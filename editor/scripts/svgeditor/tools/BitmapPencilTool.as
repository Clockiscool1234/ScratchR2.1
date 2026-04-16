package svgeditor.tools
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import svgeditor.DrawProperties;
   import svgeditor.ImageEdit;
   
   public class BitmapPencilTool extends SVGTool
   {
      
      private var eraseMode:Boolean;
      
      private var brushSize:int = 1;
      
      private var brushColor:int;
      
      private var feedbackObj:Bitmap;
      
      private var canvas:BitmapData;
      
      private var brush:BitmapData;
      
      private var eraser:BitmapData;
      
      private var tempBM:BitmapData;
      
      private var _lastPoint:Point;
      
      public function BitmapPencilTool(param1:ImageEdit, param2:Boolean = false)
      {
         super(param1);
         this.eraseMode = param2;
         mouseEnabled = false;
         mouseChildren = false;
      }
      
      override protected function init() : void
      {
         super.init();
         STAGE.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
         STAGE.addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove,false,0,true);
         STAGE.addEventListener(MouseEvent.MOUSE_UP,this.mouseUp,false,0,true);
         editor.getToolsLayer().mouseEnabled = false;
         this.updateProperties();
      }
      
      override protected function shutdown() : void
      {
         STAGE.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         STAGE.removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMove);
         STAGE.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         editor.getToolsLayer().mouseEnabled = true;
         this.removeFeedback();
         super.shutdown();
      }
      
      protected function getBrushColor() : int
      {
         return this.brushColor;
      }
      
      public function updateProperties() : void
      {
         this.updateFeedback();
         this.moveFeedback();
      }
      
      protected function mouseDown(param1:MouseEvent) : void
      {
         if(!editor)
         {
            return;
         }
         if(!editor.isActive())
         {
            return;
         }
         if(!editor.getWorkArea().clickInBitmap(param1.stageX,param1.stageY))
         {
            return;
         }
         this.startStroke();
         this.mouseMove(param1);
      }
      
      private function startStroke() : void
      {
         this.updateProperties();
         this.canvas = editor.getWorkArea().getBitmap().bitmapData;
         var _loc1_:Boolean = editor.isScene && (this.eraseMode || this.brushColor == 0);
         this.brush = this.makeBrush(this.brushSize,_loc1_ ? int(4294967295) : this.brushColor);
         this.eraser = this.makeBrush(this.brushSize,0,4294967295);
         this.tempBM = new BitmapData(this.brushSize,this.brushSize,true,0);
         this.lastPoint = null;
      }
      
      private function mouseMove(param1:MouseEvent) : void
      {
         var _loc2_:Point = null;
         if(!editor.isActive())
         {
            return;
         }
         this.moveFeedback();
         if(this.brush)
         {
            _loc2_ = this.penPoint();
            if(this.lastPoint)
            {
               this.drawLine(this.lastPoint.x,this.lastPoint.y,_loc2_.x,_loc2_.y);
            }
            else
            {
               this.drawAtPoint(_loc2_);
            }
            this.lastPoint = _loc2_;
         }
      }
      
      protected function set lastPoint(param1:Point) : void
      {
         this._lastPoint = param1;
      }
      
      protected function get lastPoint() : Point
      {
         return this._lastPoint;
      }
      
      protected function mouseUp(param1:MouseEvent) : void
      {
         if(this.brush)
         {
            editor.saveContent();
         }
         this.resetBrushes();
      }
      
      protected function resetBrushes() : void
      {
         this.brush = this.eraser = this.tempBM = null;
      }
      
      private function updateFeedback() : void
      {
         if(!this.feedbackObj)
         {
            this.feedbackObj = new Bitmap();
            this.feedbackObj.scaleX = this.feedbackObj.scaleY = 0.5;
            editor.getWorkArea().addBitmapFeedback(this.feedbackObj);
         }
         this.getPenProps();
         var _loc1_:Boolean = this.eraseMode || this.brushColor == 0;
         this.feedbackObj.bitmapData = this.makeBrush(this.brushSize,this.brushColor,0,_loc1_);
      }
      
      private function getPenProps() : void
      {
         var _loc1_:DrawProperties = editor.getShapeProps();
         this.brushSize = Math.max(1,2 * Math.round(this.eraseMode ? _loc1_.eraserWidth : _loc1_.strokeWidth));
         this.brushColor = _loc1_.alpha > 0 ? 0xFF000000 | _loc1_.color : 0;
      }
      
      protected function moveFeedback() : void
      {
         if(!this.feedbackObj)
         {
            return;
         }
         var _loc1_:Point = this.penPoint();
         this.feedbackObj.x = _loc1_.x / 2;
         this.feedbackObj.y = _loc1_.y / 2;
         this.setFeedbackVisibility();
      }
      
      protected function penPoint() : Point
      {
         var _loc1_:Point = editor.getWorkArea().bitmapMousePoint();
         var _loc2_:int = Math.round(_loc1_.x - this.brushSize / 2);
         var _loc3_:int = Math.round(_loc1_.y - this.brushSize / 2);
         if(_loc2_ & 1)
         {
            _loc2_--;
         }
         if(_loc3_ & 1)
         {
            _loc3_--;
         }
         return new Point(_loc2_,_loc3_);
      }
      
      private function setFeedbackVisibility() : void
      {
         var _loc1_:Rectangle = editor.getWorkArea().getMaskRect(editor);
         var _loc2_:Boolean = _loc1_.containsPoint(new Point(editor.mouseX,editor.mouseY));
         if(_loc2_)
         {
            Mouse.hide();
            this.feedbackObj.visible = true;
         }
         else
         {
            Mouse.show();
            this.feedbackObj.visible = false;
         }
      }
      
      private function removeFeedback() : void
      {
         if(Boolean(this.feedbackObj) && Boolean(this.feedbackObj.parent))
         {
            this.feedbackObj.parent.removeChild(this.feedbackObj);
         }
         this.feedbackObj = null;
      }
      
      private function drawLine(param1:int, param2:int, param3:int, param4:int) : void
      {
         var _loc10_:int = 0;
         var _loc5_:int = Math.abs(param3 - param1);
         var _loc6_:int = Math.abs(param4 - param2);
         var _loc7_:int = param1 < param3 ? 1 : -1;
         var _loc8_:int = param2 < param4 ? 1 : -1;
         var _loc9_:int = _loc5_ - _loc6_;
         while(1)
         {
            this.drawAtPoint(new Point(param1,param2));
            if(param1 == param3 && param2 == param4)
            {
               break;
            }
            _loc10_ = 2 * _loc9_;
            if(_loc10_ > -_loc6_)
            {
               _loc9_ -= _loc6_;
               param1 += _loc7_;
            }
            if(_loc10_ < _loc5_)
            {
               _loc9_ += _loc5_;
               param2 += _loc8_;
            }
         }
      }
      
      protected function drawAtPoint(param1:Point, param2:BitmapData = null, param3:BitmapData = null) : void
      {
         var _loc6_:Rectangle = null;
         var _loc4_:BitmapData = param3 || this.brush;
         param2 ||= this.canvas;
         var _loc5_:Boolean = this.eraseMode || this.brushColor == 0;
         if(_loc5_ && !editor.isScene)
         {
            _loc6_ = new Rectangle(param1.x,param1.y,this.brushSize,this.brushSize);
            this.tempBM.fillRect(this.tempBM.rect,0);
            this.tempBM.copyPixels(param2,_loc6_,new Point(0,0),this.eraser,new Point(0,0),true);
            param2.copyPixels(this.tempBM,this.tempBM.rect,param1);
         }
         else
         {
            param2.copyPixels(_loc4_,_loc4_.rect,param1,null,null,true);
         }
      }
      
      protected function makeBrush(param1:int, param2:int, param3:int = 0, param4:Boolean = false) : BitmapData
      {
         if(param4)
         {
            param2 = 4281348144;
         }
         var _loc5_:BitmapData = new BitmapData(param1,param1,true,param3);
         switch(param1)
         {
            case 1:
            case 2:
               _loc5_.fillRect(_loc5_.rect,param2);
               break;
            case 3:
               _loc5_.fillRect(_loc5_.rect,param2);
               if(param4)
               {
                  _loc5_.fillRect(new Rectangle(1,1,1,1),param3);
               }
               break;
            case 4:
               _loc5_.fillRect(_loc5_.rect,param2);
               if(param4)
               {
                  _loc5_.fillRect(new Rectangle(1,1,2,2),param3);
               }
               break;
            case 5:
               _loc5_.fillRect(new Rectangle(0,1,5,3),param2);
               _loc5_.fillRect(new Rectangle(1,0,3,5),param2);
               if(param4)
               {
                  _loc5_.fillRect(new Rectangle(1,1,3,3),param3);
               }
               break;
            case 6:
               _loc5_.fillRect(new Rectangle(0,2,6,2),param2);
               _loc5_.fillRect(new Rectangle(2,0,2,6),param2);
               _loc5_.fillRect(new Rectangle(1,1,4,4),param2);
               if(param4)
               {
                  _loc5_.fillRect(new Rectangle(2,2,2,2),param3);
               }
               break;
            case 7:
               _loc5_.fillRect(new Rectangle(0,2,7,3),param2);
               _loc5_.fillRect(new Rectangle(2,0,3,7),param2);
               _loc5_.fillRect(new Rectangle(1,1,5,5),param2);
               if(param4)
               {
                  _loc5_.fillRect(new Rectangle(2,2,3,3),param3);
                  _loc5_.fillRect(new Rectangle(1,3,5,1),param3);
                  _loc5_.fillRect(new Rectangle(3,1,1,5),param3);
               }
               break;
            default:
               this.drawCircle(param1,param2,_loc5_,param4);
         }
         return _loc5_;
      }
      
      private function drawCircle(param1:int, param2:int, param3:BitmapData, param4:Boolean) : void
      {
         var diameter:int = param1;
         var c:int = param2;
         var bm:BitmapData = param3;
         var outlineOnly:Boolean = param4;
         var fillLine:Function = function(param1:int, param2:int, param3:int):void
         {
            if(outlineOnly)
            {
               bm.setPixel32(param1,param3,c);
               bm.setPixel32(param2,param3,c);
            }
            else
            {
               bm.fillRect(new Rectangle(param1,param3,param2 - param1 + 1,1),c);
            }
         };
         var radius:int = diameter / 2;
         var center:int = radius;
         var adjust:int = (diameter & 1) == 0 ? -1 : 0;
         var x:int = radius;
         var y:int = 0;
         var xChange:int = 1 - (radius << 1);
         var yChange:int = 0;
         var radiusError:int = 0;
         while(x >= y)
         {
            fillLine(-x + center,x + center + adjust,y + center + adjust);
            fillLine(-y + center,y + center + adjust,x + center + adjust);
            fillLine(-y + center,y + center + adjust,-x + center);
            fillLine(-x + center,x + center + adjust,-y + center);
            y++;
            radiusError += yChange;
            yChange += 2;
            if((radiusError << 1) + xChange > 0)
            {
               x--;
               radiusError += xChange;
               xChange += 2;
            }
         }
      }
   }
}

