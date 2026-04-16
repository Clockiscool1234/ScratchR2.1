package svgeditor.tools
{
   import assets.Resources;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.ui.MouseCursorData;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import grabcut.CModule;
   import svgeditor.ImageEdit;
   import svgeditor.objs.SegmentationState;
   
   public class BitmapBackgroundTool extends BitmapPencilTool
   {
      
      public static const UPDATE_REQUIRED:String = "got_mask";
      
      private static const SCALE_FACTOR:Number = 0.5;
      
      private static const SMOOTHING_ITERATIONS:int = 2;
      
      private static var STARTED_ASYNC:Boolean = false;
      
      private static const BUSY_CURSOR:String = "segmentationBusy";
      
      private static const BG_ISLAND_THRESHOLD:Number = 0.1;
      
      private static const OBJECT_ISLAND_THRESHOLD:Number = 0.1;
      
      private static const SEGMENT_STROKE_WIDTH:int = 6;
      
      private static const SEGMENT_OBJ_COLOR:uint = 4278190335;
      
      private static const SEGMENT_DISPLAY_COLOR:uint = 4278255360;
      
      private var segmentationRequired:Boolean = false;
      
      private var initialState:SegmentationState;
      
      private var previewFrameTimer:Timer = new Timer(100);
      
      private var previewFrameBackgrounds:Vector.<BitmapData> = new Vector.<BitmapData>();
      
      private var previewFrameIdx:int = 0;
      
      private var previewFrames:Vector.<BitmapData>;
      
      private var prevBrushColor:uint;
      
      private var prevAlpha:Number;
      
      private var prevStrokeWidth:int;
      
      private var segmentBrush:BitmapData;
      
      private var cursor:MouseCursorData = new MouseCursorData();
      
      private var firstPoint:Point;
      
      public function BitmapBackgroundTool(param1:ImageEdit)
      {
         if(!STARTED_ASYNC)
         {
            CModule.startAsync();
            STARTED_ASYNC = true;
         }
         this.previewFrameBackgrounds.push(Resources.createBmp("first").bitmapData,Resources.createBmp("second").bitmapData,Resources.createBmp("third").bitmapData,Resources.createBmp("fourth").bitmapData,Resources.createBmp("fifth").bitmapData,Resources.createBmp("sixth").bitmapData,Resources.createBmp("seventh").bitmapData,Resources.createBmp("eighth").bitmapData);
         this.previewFrameTimer.addEventListener("timer",this.nextPreviewFrame);
         var _loc2_:Vector.<BitmapData> = new Vector.<BitmapData>();
         _loc2_.push(Resources.createBmp(BitmapBackgroundTool.BUSY_CURSOR).bitmapData);
         this.cursor.hotSpot = new Point(10,10);
         this.cursor.data = _loc2_;
         Mouse.registerCursor(BitmapBackgroundTool.BUSY_CURSOR,this.cursor);
         super(param1,false);
      }
      
      private static function argbToRgba(param1:ByteArray) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length / 4)
         {
            _loc3_ = _loc2_ * 4;
            _loc4_ = int(param1[_loc3_]);
            _loc5_ = int(param1[_loc3_ + 1]);
            _loc6_ = int(param1[_loc3_ + 2]);
            _loc7_ = int(param1[_loc3_ + 3]);
            param1[_loc3_] = _loc5_;
            param1[_loc3_ + 1] = _loc6_;
            param1[_loc3_ + 2] = _loc7_;
            param1[_loc3_ + 3] = _loc4_;
            _loc2_++;
         }
      }
      
      private static function rgbaToArgb(param1:ByteArray) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length / 4)
         {
            _loc3_ = _loc2_ * 4;
            _loc4_ = int(param1[_loc3_]);
            _loc5_ = int(param1[_loc3_ + 1]);
            _loc6_ = int(param1[_loc3_ + 2]);
            _loc7_ = int(param1[_loc3_ + 3]);
            param1[_loc3_] = _loc7_;
            param1[_loc3_ + 1] = _loc4_;
            param1[_loc3_ + 2] = _loc5_;
            param1[_loc3_ + 3] = _loc6_;
            _loc2_++;
         }
      }
      
      private function get bitmapLayerData() : BitmapData
      {
         return editor.getWorkArea().getBitmap().bitmapData;
      }
      
      private function get segmentationLayer() : Bitmap
      {
         return editor.getWorkArea().getSegmentation();
      }
      
      private function get segmentationLayerData() : BitmapData
      {
         return editor.getWorkArea().getSegmentation().bitmapData;
      }
      
      private function get bitmapLayer() : Bitmap
      {
         return editor.getWorkArea().getBitmap();
      }
      
      private function get segmentationState() : SegmentationState
      {
         return editor.targetCostume.segmentationState;
      }
      
      override protected function init() : void
      {
         this.prevStrokeWidth = editor.getShapeProps().strokeWidth;
         this.prevBrushColor = editor.getShapeProps().color;
         this.prevAlpha = editor.getShapeProps().alpha;
         editor.setCurrentColor(SEGMENT_DISPLAY_COLOR,1);
         editor.getShapeProps().strokeWidth = SEGMENT_STROKE_WIDTH;
         this.segmentBrush = makeBrush(SEGMENT_STROKE_WIDTH,SEGMENT_OBJ_COLOR);
         this.initialState = this.segmentationState;
         this.initState();
         this.segmentationState.unmarkedBitmap = this.bitmapLayerData.clone();
         STAGE.addEventListener(MouseEvent.CLICK,this.mouseClick,false,0,true);
         super.init();
      }
      
      override public function refresh() : void
      {
         this.segmentationState.unmarkedBitmap = this.bitmapLayerData.clone();
         this.segmentationState.costumeRect = this.bitmapLayerData.getColorBoundsRect(4278190080,0,false);
      }
      
      override protected function shutdown() : void
      {
         if(this.segmentationState != this.initialState)
         {
            this.commitMask();
         }
         this.segmentationState.eraseUndoHistory();
         editor.getShapeProps().strokeWidth = this.prevStrokeWidth;
         editor.setCurrentColor(this.prevBrushColor,this.prevAlpha);
         updateProperties();
         STAGE.removeEventListener(MouseEvent.CLICK,this.mouseClick);
         super.shutdown();
      }
      
      override protected function mouseDown(param1:MouseEvent) : void
      {
         if(editor.getWorkArea().clickInBitmap(param1.stageX,param1.stageY))
         {
            this.previewFrameTimer.stop();
            this.firstPoint = penPoint();
            if(this.segmentationState.costumeRect.contains(this.firstPoint.x,this.firstPoint.y))
            {
               this.segmentationState.recordForUndo();
               editor.targetCostume.nextSegmentationState();
               this.segmentationRequired = true;
            }
         }
         super.mouseDown(param1);
      }
      
      private function mouseClick(param1:MouseEvent) : void
      {
         var _loc2_:Point = penPoint();
         if(Boolean(this.firstPoint && !this.segmentationState.costumeRect.contains(this.firstPoint.x,this.firstPoint.y) && editor.getWorkArea().clickInBitmap(param1.stageX,param1.stageY) && _loc2_) && Boolean(!this.segmentationState.costumeRect.contains(_loc2_.x,_loc2_.y)) || editor.clickedOutsideBitmap(param1))
         {
            if(this.segmentationState.lastMask)
            {
               this.firstPoint = null;
               if(this.segmentationState.next == null)
               {
                  this.segmentationState.recordForUndo();
               }
               editor.targetCostume.nextSegmentationState();
               this.commitMask(false);
               Scratch.app.setSaveNeeded();
               if(Mouse.supportsNativeCursor)
               {
                  Mouse.cursor = "arrow";
               }
               resetBrushes();
               moveFeedback();
            }
            else
            {
               this.segmentationState.reset();
               this.initState();
            }
         }
      }
      
      override protected function mouseUp(param1:MouseEvent) : void
      {
         if(editor)
         {
            if(this.segmentationRequired && editor.getWorkArea().clickInBitmap(param1.stageX,param1.stageY))
            {
               if(Mouse.supportsNativeCursor)
               {
                  Mouse.cursor = BitmapBackgroundTool.BUSY_CURSOR;
                  Mouse.show();
               }
               setTimeout(this.getObjectMask,0);
               this.segmentationRequired = false;
            }
            resetBrushes();
         }
      }
      
      override protected function set lastPoint(param1:Point) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1 != null)
         {
            if(super.lastPoint == null)
            {
               dispatchEvent(new Event(BitmapBackgroundTool.UPDATE_REQUIRED));
            }
            _loc2_ = Math.max(param1.x,0);
            _loc3_ = _loc2_ + SEGMENT_STROKE_WIDTH;
            _loc4_ = Math.max(param1.y,0);
            _loc5_ = _loc4_ + SEGMENT_STROKE_WIDTH;
            if(_loc3_ > this.segmentationState.xMax)
            {
               this.segmentationState.xMax = Math.min(_loc3_,this.bitmapLayerData.width);
            }
            if(_loc5_ > this.segmentationState.yMax)
            {
               this.segmentationState.yMax = Math.min(_loc5_,this.bitmapLayerData.height);
            }
            if(_loc2_ < this.segmentationState.xMin)
            {
               this.segmentationState.xMin = Math.min(_loc2_,this.bitmapLayerData.width - SEGMENT_STROKE_WIDTH);
            }
            if(_loc4_ < this.segmentationState.yMin)
            {
               this.segmentationState.yMin = Math.min(_loc4_,this.bitmapLayerData.height - SEGMENT_STROKE_WIDTH);
            }
         }
         super.lastPoint = param1;
      }
      
      override protected function drawAtPoint(param1:Point, param2:BitmapData = null, param3:BitmapData = null) : void
      {
         param2 ||= this.segmentationLayerData;
         super.drawAtPoint(param1,this.segmentationState.scribbleBitmap,this.segmentBrush);
         super.drawAtPoint(param1,param2,param3);
      }
      
      private function nextPreviewFrame(param1:TimerEvent) : void
      {
         this.previewFrameIdx = (this.previewFrameIdx + 1) % this.previewFrameBackgrounds.length;
         this.segmentationLayerData.copyPixels(this.previewFrames[this.previewFrameIdx],this.previewFrames[this.previewFrameIdx].rect,new Point(0,0));
      }
      
      public function initState() : void
      {
         this.previewFrameTimer.stop();
         this.segmentationLayerData.fillRect(this.segmentationLayerData.rect,0);
         this.bitmapLayer.visible = true;
         this.segmentationLayer.visible = true;
         if(this.segmentationState.xMin < 0)
         {
            this.segmentationState.xMin = this.bitmapLayerData.width;
         }
         if(this.segmentationState.yMin < 0)
         {
            this.segmentationState.yMin = this.bitmapLayerData.height;
         }
         this.segmentationState.scribbleBitmap = new BitmapData(this.bitmapLayerData.width,this.bitmapLayerData.height,true,0);
         this.segmentationState.costumeRect = this.bitmapLayerData.getColorBoundsRect(4278190080,0,false);
      }
      
      private function applyPreviewMask(param1:BitmapData, param2:BitmapData) : void
      {
         var _loc6_:BitmapData = null;
         var _loc7_:BitmapData = null;
         param2.fillRect(param2.rect,0);
         var _loc3_:BitmapData = param2.clone();
         var _loc4_:Point = new Point(0,0);
         var _loc5_:Array = [0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0,0,0,0.75,0];
         param2.applyFilter(this.segmentationState.unmarkedBitmap,this.segmentationState.unmarkedBitmap.rect,_loc4_,new ColorMatrixFilter(_loc5_));
         _loc3_.copyPixels(this.segmentationState.unmarkedBitmap,this.segmentationState.unmarkedBitmap.rect,_loc4_,param1,_loc4_,true);
         param2.draw(_loc3_);
         this.previewFrames = new Vector.<BitmapData>();
         this.previewFrameIdx = 0;
         _loc3_.applyFilter(_loc3_,_loc3_.rect,new Point(0,0),new GlowFilter(16777037,1,4,4,255,1,false,true));
         for each(_loc6_ in this.previewFrameBackgrounds)
         {
            _loc7_ = param2.clone();
            _loc3_.copyPixels(_loc6_,_loc6_.rect,new Point(0,0),_loc3_);
            _loc7_.draw(_loc3_);
            this.previewFrames.push(_loc7_);
         }
         param2.copyPixels(this.previewFrames[this.previewFrameIdx],this.previewFrames[this.previewFrameIdx].rect,_loc4_);
      }
      
      public function commitMask(param1:Boolean = true) : void
      {
         this.previewFrameTimer.stop();
         this.bitmapLayer.visible = true;
         this.segmentationLayerData.fillRect(this.segmentationLayerData.rect,0);
         this.segmentationState.reset();
         this.segmentationState.unmarkedBitmap = this.bitmapLayerData.clone();
         editor.saveContent(null,param1);
         this.initState();
         dispatchEvent(new Event(BitmapBackgroundTool.UPDATE_REQUIRED));
      }
      
      public function refreshSegmentation() : void
      {
         this.previewFrameTimer.stop();
         if(this.segmentationState.lastMask)
         {
            this.setGreyscale();
            this.applyMask(this.segmentationState.lastMask,this.bitmapLayerData);
         }
         editor.saveContent(null,false);
      }
      
      public function restoreUnmarkedBitmap() : void
      {
         this.previewFrameTimer.stop();
         this.segmentationLayerData.fillRect(this.segmentationLayerData.rect,0);
         this.bitmapLayerData.copyPixels(this.segmentationState.unmarkedBitmap,this.segmentationState.unmarkedBitmap.rect,new Point(0,0));
         this.bitmapLayer.visible = true;
         editor.saveContent(null,false);
      }
      
      private function setGreyscale() : void
      {
         this.bitmapLayer.visible = false;
         this.segmentationLayer.visible = true;
         this.applyPreviewMask(this.segmentationState.lastMask,this.segmentationLayerData);
         this.previewFrameTimer.start();
      }
      
      private function applyMask(param1:BitmapData, param2:BitmapData) : void
      {
         param2.copyPixels(this.segmentationState.unmarkedBitmap,this.segmentationState.unmarkedBitmap.rect,new Point(0,0));
         if(param1)
         {
            param2.threshold(param1,param1.rect,new Point(0,0),"==",0,editor.isScene ? uint(4294967295) : 0,4278190080,false);
         }
      }
      
      private function cropRect() : Rectangle
      {
         var _loc1_:int = this.segmentationState.xMin;
         var _loc2_:int = this.segmentationState.yMin;
         var _loc3_:int = this.segmentationState.xMax - this.segmentationState.xMin;
         var _loc4_:int = this.segmentationState.yMax - this.segmentationState.yMin;
         var _loc5_:Rectangle = new Rectangle(_loc1_,_loc2_,_loc3_,_loc4_);
         var _loc6_:int = Math.round(_loc5_.width * 0.1);
         var _loc7_:int = Math.round(_loc5_.height * 0.1);
         _loc5_.inflate(_loc6_,_loc7_);
         return this.bitmapLayerData.rect.intersection(_loc5_.intersection(this.segmentationState.costumeRect));
      }
      
      private function cropAndScale(param1:BitmapData, param2:Rectangle) : BitmapData
      {
         var _loc3_:ByteArray = param1.getPixels(param2);
         _loc3_.position = 0;
         var _loc4_:BitmapData = new BitmapData(param2.width,param2.height,true,16777215);
         _loc4_.setPixels(_loc4_.rect,_loc3_);
         var _loc5_:BitmapData = new BitmapData(_loc4_.width * 0.5,_loc4_.height * 0.5,true,16777215);
         var _loc6_:Matrix = new Matrix();
         _loc6_.scale(SCALE_FACTOR,SCALE_FACTOR);
         _loc5_.draw(_loc4_,_loc6_);
         return _loc5_;
      }
      
      private function getObjectMask() : void
      {
         var scaledScribbleBM:BitmapData;
         var scribbleData:ByteArray;
         var didGetObjectMask:Function;
         var scaledWorkingBM:BitmapData = null;
         var workingData:ByteArray = null;
         var imgPtr:int = 0;
         var scribblePtr:int = 0;
         var args:Vector.<int> = null;
         var func:int = 0;
         var costumeRect:Rectangle = this.cropRect();
         if(costumeRect.x < 0 || costumeRect.y < 0 || costumeRect.width <= 0 || costumeRect.height <= 0)
         {
            return;
         }
         scaledWorkingBM = this.cropAndScale(this.segmentationState.unmarkedBitmap,costumeRect);
         workingData = scaledWorkingBM.getPixels(scaledWorkingBM.rect);
         workingData.position = 0;
         scaledScribbleBM = this.cropAndScale(this.segmentationState.scribbleBitmap,costumeRect);
         scribbleData = scaledScribbleBM.getPixels(scaledScribbleBM.rect);
         scribbleData.position = 0;
         try
         {
            didGetObjectMask = function():void
            {
               var scaledMaskBitmap:BitmapData;
               var smoothedMask:BitmapData;
               var m:Matrix;
               var finalRect:Rectangle;
               var maskBitmap:BitmapData;
               var resetCursor:Function = null;
               resetCursor = function():void
               {
                  if(Mouse.supportsNativeCursor)
                  {
                     Mouse.cursor = "arrow";
                  }
               };
               var bmData:ByteArray = new ByteArray();
               CModule.readBytes(imgPtr,workingData.length,bmData);
               bmData.position = 0;
               rgbaToArgb(bmData);
               scaledMaskBitmap = new BitmapData(scaledWorkingBM.width,scaledWorkingBM.height,true,16777215);
               scaledMaskBitmap.setPixels(scaledMaskBitmap.rect,bmData);
               smoothedMask = removeIslands(scaledMaskBitmap,SMOOTHING_ITERATIONS);
               m = new Matrix();
               m.scale(1 / SCALE_FACTOR,1 / SCALE_FACTOR);
               finalRect = cropRect();
               m.tx = finalRect.x;
               m.ty = finalRect.y;
               maskBitmap = new BitmapData(bitmapLayerData.width,bitmapLayerData.height,true,16777215);
               maskBitmap.draw(smoothedMask,m);
               bmData.position = 0;
               segmentationState.lastMask = maskBitmap;
               setGreyscale();
               setTimeout(resetCursor,0);
               applyMask(segmentationState.lastMask,bitmapLayerData);
               editor.saveContent(null,false);
               dispatchEvent(new Event(BitmapBackgroundTool.UPDATE_REQUIRED));
            };
            imgPtr = CModule.malloc(workingData.length);
            scribblePtr = CModule.malloc(workingData.length);
            argbToRgba(workingData);
            argbToRgba(scribbleData);
            CModule.writeBytes(imgPtr,workingData.length,workingData);
            CModule.writeBytes(scribblePtr,scribbleData.length,scribbleData);
            args = new Vector.<int>();
            args.push(imgPtr,scribblePtr,scaledWorkingBM.height,scaledWorkingBM.width,1);
            func = CModule.getPublicSymbol("grabCut");
            CModule.callI(func,args);
            didGetObjectMask();
         }
         finally
         {
            CModule.free(imgPtr);
            CModule.free(scribblePtr);
         }
      }
      
      private function removeIslands(param1:BitmapData, param2:int) : BitmapData
      {
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:uint = 0;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:uint = 0;
         var _loc16_:uint = 0;
         var _loc17_:int = 0;
         var _loc18_:uint = 0;
         param2--;
         if(param2 < 0)
         {
            return param1;
         }
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,16777215);
         var _loc4_:Array = new Array();
         var _loc5_:Array = new Array();
         var _loc6_:Array = [];
         var _loc7_:uint = 1;
         var _loc8_:int = 0;
         while(_loc8_ < param1.height)
         {
            _loc17_ = 0;
            while(_loc17_ < param1.width)
            {
               if(_loc3_.getPixel(_loc17_,_loc8_) == 0)
               {
                  _loc18_ = param1.getPixel(_loc17_,_loc8_);
                  (_loc18_ == 0 ? _loc5_ : _loc4_)[_loc7_] = this.tagComponent(param1,_loc3_,_loc7_,_loc18_,_loc17_,_loc8_);
                  _loc7_ *= 2;
                  if(_loc7_ >= 16777215)
                  {
                     break;
                  }
               }
               _loc17_++;
            }
            if(_loc7_ >= 16777215)
            {
               break;
            }
            _loc8_++;
         }
         var _loc9_:uint = 0;
         for each(_loc10_ in _loc5_)
         {
            _loc9_ = Math.max(_loc9_,_loc10_ as uint);
         }
         for(_loc11_ in _loc5_)
         {
            if(_loc5_[_loc11_ as uint] > _loc9_ * BG_ISLAND_THRESHOLD)
            {
               _loc6_.push(_loc11_ as uint);
            }
         }
         _loc12_ = 0;
         for each(_loc13_ in _loc4_)
         {
            _loc12_ = Math.max(_loc12_,_loc13_ as uint);
         }
         for(_loc14_ in _loc4_)
         {
            if(_loc4_[_loc14_ as uint] < _loc12_ * OBJECT_ISLAND_THRESHOLD)
            {
               _loc6_.push(_loc14_ as uint);
            }
         }
         _loc15_ = 0;
         for each(_loc16_ in _loc6_)
         {
            _loc15_ |= _loc16_;
         }
         param1.fillRect(param1.rect,16777215);
         param1.threshold(_loc3_,_loc3_.rect,new Point(0,0),"==",0,4294967295,_loc15_);
         return this.removeIslands(param1,param2);
      }
      
      private function tagComponent(param1:BitmapData, param2:BitmapData, param3:uint, param4:uint, param5:uint, param6:uint) : uint
      {
         var _loc7_:uint = 4278190080 + param3;
         param1.floodFill(param5,param6,_loc7_);
         return param2.threshold(param1,param1.rect,new Point(0,0),"==",_loc7_,_loc7_,4294967295);
      }
   }
}

