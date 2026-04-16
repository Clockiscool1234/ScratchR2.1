package svgeditor
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import svgeditor.objs.SVGShape;
   import uiwidgets.*;
   
   public class ImageCanvas extends Sprite
   {
      
      public static const canvasWidth:uint = 480;
      
      public static const canvasHeight:uint = 360;
      
      private static const canvasBorderWidth:uint = 25;
      
      private static const scrollbarThickness:int = 9;
      
      private static const maxZoom:Number = 16;
      
      private var visibleArea:Sprite;
      
      private var interactiveLayer:Sprite;
      
      private var visibleCanvas:Sprite;
      
      private var contentLayer:Sprite;
      
      private var bitmapLayer:Bitmap;
      
      private var segmentationLayer:Bitmap;
      
      private var visibleMask:Shape;
      
      private var hScrollbar:Scrollbar;
      
      private var vScrollbar:Scrollbar;
      
      private var visibleRect:Rectangle;
      
      private var currWidth:uint;
      
      private var currHeight:uint;
      
      private var isZoomedIn:Boolean;
      
      private var editor:ImageEdit;
      
      private const growthFactor:Number = 1.2;
      
      public function ImageCanvas(param1:uint, param2:uint, param3:ImageEdit)
      {
         super();
         this.editor = param3;
         this.createLayers();
         this.hScrollbar = new Scrollbar(50,scrollbarThickness,this.setHScroll);
         this.hScrollbar.addEventListener(Event.SCROLL,this.scrollEventHandler,false,0,true);
         this.hScrollbar.addEventListener(Event.COMPLETE,this.scrollEventHandler,false,0,true);
         addChild(this.hScrollbar);
         this.vScrollbar = new Scrollbar(scrollbarThickness,50,this.setVScroll);
         this.vScrollbar.addEventListener(Event.SCROLL,this.scrollEventHandler,false,0,true);
         this.vScrollbar.addEventListener(Event.COMPLETE,this.scrollEventHandler,false,0,true);
         addChild(this.vScrollbar);
         this.currWidth = this.currHeight = 0;
         this.isZoomedIn = false;
         this.resize(param1,param2);
      }
      
      private function scrollEventHandler(param1:Event) : void
      {
         var _loc2_:Boolean = param1.type == Event.COMPLETE;
         this.editor.getToolsLayer().visible = _loc2_;
         if(_loc2_)
         {
            this.editor.refreshCurrentTool();
         }
      }
      
      public function toggleContentInteraction(param1:Boolean) : void
      {
         this.visibleArea.mouseEnabled = param1;
         this.visibleArea.mouseChildren = param1;
      }
      
      public function getVisibleLayer() : Sprite
      {
         return this.visibleCanvas;
      }
      
      public function getVisibleRect(param1:Sprite) : Rectangle
      {
         return this.visibleArea.getRect(param1);
      }
      
      public function getMaskRect(param1:Sprite) : Rectangle
      {
         return this.visibleMask.getRect(param1);
      }
      
      public function getInteractionLayer() : Sprite
      {
         return this.interactiveLayer;
      }
      
      public function getContentLayer() : Sprite
      {
         return this.contentLayer;
      }
      
      public function getBitmap() : Bitmap
      {
         return this.bitmapLayer;
      }
      
      public function getSegmentation() : Bitmap
      {
         return this.segmentationLayer;
      }
      
      public function bitmapMousePoint() : Point
      {
         if(!this.bitmapLayer)
         {
            return new Point(0,0);
         }
         var _loc1_:BitmapData = this.bitmapLayer.bitmapData;
         var _loc2_:int = Math.min(_loc1_.width,Math.max(0,this.visibleArea.mouseX / this.bitmapLayer.scaleX));
         var _loc3_:int = Math.min(_loc1_.height,Math.max(0,this.visibleArea.mouseY / this.bitmapLayer.scaleY));
         return new Point(_loc2_,_loc3_);
      }
      
      public function clickInBitmap(param1:int, param2:int) : Boolean
      {
         var _loc3_:Rectangle = this.visibleMask.getRect(stage);
         return _loc3_.contains(param1,param2);
      }
      
      public function addBitmapFeedback(param1:DisplayObject) : void
      {
         this.visibleArea.addChild(param1);
      }
      
      public function getScale() : Number
      {
         return this.visibleArea.scaleX;
      }
      
      private function createLayers() : void
      {
         var _loc1_:BitmapData = null;
         this.interactiveLayer = new Sprite();
         addChild(this.interactiveLayer);
         this.visibleMask = new Shape();
         addChild(this.visibleMask);
         this.visibleArea = new Sprite();
         addChild(this.visibleArea);
         this.visibleCanvas = new Sprite();
         this.visibleCanvas.mouseEnabled = false;
         this.visibleArea.addChild(this.visibleCanvas);
         this.contentLayer = new Sprite();
         if(this.editor is BitmapEdit)
         {
            _loc1_ = new BitmapData(960,720,true,0);
            this.visibleArea.addChild(this.bitmapLayer = new Bitmap(_loc1_));
            this.bitmapLayer.scaleX = this.bitmapLayer.scaleY = 0.5;
            this.visibleArea.addChild(this.segmentationLayer = new Bitmap(_loc1_.clone()));
            this.segmentationLayer.scaleX = this.segmentationLayer.scaleY = 0.5;
         }
         this.visibleArea.mask = this.visibleMask;
         this.visibleArea.addChild(this.contentLayer);
      }
      
      public function clearContent() : void
      {
         while(this.contentLayer.numChildren > 0)
         {
            this.contentLayer.removeChildAt(0);
         }
      }
      
      public function getBackDropFills() : Array
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:String = null;
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < this.contentLayer.numChildren)
         {
            _loc3_ = this.contentLayer.getChildAt(_loc2_);
            if(_loc3_ is SVGShape)
            {
               _loc4_ = (_loc3_ as SVGShape).getElement().getAttribute("scratch-type");
               if(_loc4_ == "backdrop-fill")
               {
                  _loc1_.push(_loc3_);
               }
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function addBackdropFill(param1:SVGShape) : void
      {
         this.contentLayer.addChildAt(param1,0);
      }
      
      public function addBackdropStroke(param1:SVGShape) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc2_:uint = 0;
         while(_loc2_ < this.contentLayer.numChildren)
         {
            _loc3_ = this.contentLayer.getChildAt(_loc2_);
            if(!(_loc3_ is SVGShape) || (_loc3_ as SVGShape).getElement().getAttribute("scratch-type") != "backdrop-fill")
            {
               this.contentLayer.addChildAt(param1,_loc2_);
               return;
            }
            _loc2_++;
         }
         this.contentLayer.addChildAt(param1,_loc2_);
      }
      
      private function getZoomLevelZero(param1:uint, param2:uint) : Number
      {
         if(this.editor is BitmapEdit)
         {
            return 1;
         }
         return 1;
      }
      
      public function resize(param1:uint, param2:uint) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = param1 - this.vScrollbar.w;
         var _loc6_:int = param2 - this.hScrollbar.h;
         var _loc7_:Number = this.getZoomLevelZero(_loc5_,_loc6_);
         if(!this.isZoomedIn || this.visibleArea.scaleX < _loc7_)
         {
            this.visibleArea.scaleX = this.visibleArea.scaleY = _loc7_;
            this.isZoomedIn = false;
            this.editor.updateZoomReadout();
         }
         if(this.visibleArea.scaleX * canvasWidth < _loc5_ - 1)
         {
            _loc3_ = _loc5_ - this.visibleArea.scaleX * canvasWidth;
            _loc5_ -= _loc3_;
            _loc3_ *= 0.5;
         }
         if(this.visibleArea.scaleX * canvasHeight < _loc6_ - 1)
         {
            _loc4_ = _loc6_ - this.visibleArea.scaleX * canvasHeight;
            _loc6_ -= _loc4_;
            _loc4_ *= 0.5;
         }
         this.drawGrid();
         var _loc8_:Graphics = this.visibleMask.graphics;
         _loc8_.clear();
         _loc8_.beginFill(15790080);
         _loc8_.drawRect(_loc3_,_loc4_,_loc5_,_loc6_);
         _loc8_.endFill();
         _loc8_ = this.interactiveLayer.graphics;
         _loc8_.clear();
         _loc8_.beginFill(15790080,0);
         _loc8_.drawRect(_loc3_ - canvasBorderWidth,_loc4_ - canvasBorderWidth,_loc5_ + 2 * canvasBorderWidth,_loc6_ + 2 * canvasBorderWidth);
         _loc8_.endFill();
         this.visibleRect = this.visibleMask.getRect(this);
         var _loc9_:Number = this.visibleRect.right - this.visibleArea.scaleX * canvasWidth;
         var _loc10_:Number = this.visibleRect.bottom - this.visibleArea.scaleY * canvasHeight;
         this.visibleArea.x = Math.max(_loc9_,Math.min(this.visibleRect.left,this.visibleArea.x));
         this.visibleArea.y = Math.max(_loc10_,Math.min(this.visibleRect.top,this.visibleArea.y));
         this.updateScrollbars();
         this.currWidth = param1;
         this.currHeight = param2;
      }
      
      private function drawGrid() : void
      {
         var _loc1_:Graphics = this.visibleCanvas.graphics;
         _loc1_.clear();
         _loc1_.beginBitmapFill(Resources.createBmp("canvasGrid").bitmapData);
         _loc1_.drawRect(0,0,canvasWidth,canvasHeight);
         _loc1_.endFill();
         var _loc2_:int = 11579568;
         var _loc3_:Number = 0.5;
         var _loc4_:Number = canvasWidth / 2;
         var _loc5_:Number = canvasHeight / 2;
         _loc1_.beginFill(_loc2_);
         _loc1_.drawRect(_loc4_ - 4,_loc5_ - _loc3_ / 2,8,_loc3_);
         _loc1_.beginFill(_loc2_);
         _loc1_.drawRect(_loc4_ - _loc3_ / 2,_loc5_ - 4,_loc3_,8);
      }
      
      private function setHScroll(param1:Number) : void
      {
         this.visibleArea.x = Math.round(this.visibleRect.left - param1 * this.maxScrollH());
      }
      
      private function setVScroll(param1:Number) : void
      {
         this.visibleArea.y = Math.round(this.visibleRect.top - param1 * this.maxScrollV());
      }
      
      private function maxScrollH() : int
      {
         return Math.max(0,this.visibleArea.scaleX * canvasWidth - this.visibleMask.width);
      }
      
      private function maxScrollV() : int
      {
         return Math.max(0,this.visibleArea.scaleY * canvasHeight - this.visibleMask.height);
      }
      
      private function updateScrollbars() : void
      {
         var _loc1_:int = 2;
         var _loc2_:Rectangle = this.visibleMask.getRect(this);
         this.hScrollbar.x = _loc2_.x;
         this.hScrollbar.y = _loc2_.bottom + _loc1_;
         this.hScrollbar.setWidthHeight(this.visibleMask.width,this.hScrollbar.h);
         this.hScrollbar.visible = this.hScrollbar.update(-this.visibleArea.x / this.maxScrollH(),_loc2_.width / (this.visibleArea.scaleX * canvasWidth));
         this.vScrollbar.x = _loc2_.right + _loc1_;
         this.vScrollbar.y = _loc2_.top;
         this.vScrollbar.setWidthHeight(this.vScrollbar.w,this.visibleMask.height);
         this.vScrollbar.visible = this.vScrollbar.update(-this.visibleArea.y / this.maxScrollV(),_loc2_.height / (this.visibleArea.scaleY * canvasHeight));
      }
      
      public function centerAround(param1:Point) : void
      {
         param1 = this.visibleArea.globalToLocal(param1);
         param1.x *= this.visibleArea.scaleX;
         param1.y *= this.visibleArea.scaleY;
         this.setHScroll(Math.min(1,Math.max(0,(param1.x - this.visibleMask.width * 0.5) / this.maxScrollH())));
         this.setVScroll(Math.min(1,Math.max(0,(param1.y - this.visibleMask.height * 0.5) / this.maxScrollV())));
         this.resize(this.currWidth,this.currHeight);
      }
      
      public function zoomOut() : void
      {
         var _loc2_:Point = null;
         var _loc1_:Rectangle = this.visibleMask.getRect(this.visibleMask);
         _loc2_ = new Point(_loc1_.x + _loc1_.width / 2,_loc1_.y + _loc1_.height / 2);
         _loc2_ = this.visibleMask.localToGlobal(_loc2_);
         var _loc3_:Point = _loc2_;
         _loc2_ = this.visibleArea.globalToLocal(_loc2_);
         this.visibleArea.scaleX *= 0.5;
         this.visibleArea.scaleY *= 0.5;
         this.editor.updateZoomReadout();
         _loc2_ = this.visibleArea.localToGlobal(_loc2_).subtract(_loc3_);
         this.visibleArea.x -= _loc2_.x;
         this.visibleArea.y -= _loc2_.y;
         this.resize(this.currWidth,this.currHeight);
      }
      
      public function zoom(param1:Point = null) : void
      {
         if(!param1)
         {
            this.isZoomedIn = false;
            this.resize(this.currWidth,this.currHeight);
            return;
         }
         this.isZoomedIn = true;
         var _loc2_:Point = new Point(param1.x,param1.y);
         param1 = this.visibleArea.globalToLocal(param1);
         if(this.visibleArea.scaleX < maxZoom)
         {
            this.visibleArea.scaleX *= 2;
            this.visibleArea.scaleY *= 2;
         }
         this.editor.updateZoomReadout();
         param1 = this.visibleArea.localToGlobal(param1).subtract(_loc2_);
         this.visibleArea.x -= param1.x;
         this.visibleArea.y -= param1.y;
         this.resize(this.currWidth,this.currHeight);
      }
      
      public function getZoomAndScroll() : Array
      {
         return [this.visibleArea.scaleX,this.hScrollbar.scrollValue(),this.vScrollbar.scrollValue()];
      }
      
      public function setZoomAndScroll(param1:Array) : void
      {
         var _loc2_:Number = Number(param1[0]);
         if(this.editor is BitmapEdit)
         {
            _loc2_ = Math.round(_loc2_);
         }
         this.visibleArea.scaleX = this.visibleArea.scaleY = _loc2_;
         this.isZoomedIn = _loc2_ > 1;
         this.editor.updateZoomReadout();
         this.setHScroll(param1[1]);
         this.setVScroll(param1[2]);
         this.resize(this.currWidth,this.currHeight);
      }
      
      public function handleTool(param1:String, param2:MouseEvent) : void
      {
         if("help" == param1)
         {
            Scratch.app.showTip("paint");
         }
         var _loc3_:BitmapEdit = this.editor as BitmapEdit;
         if(Boolean(_loc3_) && ("grow" == param1 || "shrink" == param1))
         {
            if("grow" == param1)
            {
               _loc3_.scaleAll(this.growthFactor);
            }
            if("shrink" == param1)
            {
               _loc3_.scaleAll(1 / this.growthFactor);
            }
         }
         else
         {
            CursorTool.setTool(null);
         }
         param2.stopImmediatePropagation();
      }
   }
}

