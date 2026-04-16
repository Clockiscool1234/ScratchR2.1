package svgeditor
{
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import scratch.ScratchCostume;
   import svgeditor.objs.*;
   import svgeditor.tools.*;
   import svgutils.SVGElement;
   import ui.parts.*;
   import uiwidgets.*;
   
   public class BitmapEdit extends ImageEdit
   {
      
      public static const bitmapTools:Array = [{
         "name":"bitmapBrush",
         "desc":"Brush"
      },{
         "name":"line",
         "desc":"Line"
      },{
         "name":"rect",
         "desc":"Rectangle",
         "shiftDesc":"Square"
      },{
         "name":"ellipse",
         "desc":"Ellipse",
         "shiftDesc":"Circle"
      },{
         "name":"text",
         "desc":"Text"
      },{
         "name":"paintbucket",
         "desc":"Fill with color"
      },{
         "name":"bitmapEraser",
         "desc":"Erase"
      },{
         "name":"bitmapSelect",
         "desc":"Select"
      },{
         "name":"magicEraser",
         "desc":"Remove Background"
      }];
      
      public var stampMode:Boolean;
      
      private var offscreenBM:BitmapData;
      
      public function BitmapEdit(param1:Scratch, param2:ImagesPart)
      {
         super(param1,param2);
         this.addStampTool();
         this.setToolMode("bitmapBrush");
      }
      
      public static function flipBitmap(param1:Boolean, param2:BitmapData) : BitmapData
      {
         var _loc3_:BitmapData = new BitmapData(param2.width,param2.height,true,0);
         var _loc4_:Matrix = new Matrix();
         if(param1)
         {
            _loc4_.scale(1,-1);
            _loc4_.translate(0,param2.height);
         }
         else
         {
            _loc4_.scale(-1,1);
            _loc4_.translate(param2.width,0);
         }
         _loc3_.draw(param2,_loc4_);
         return _loc3_;
      }
      
      override protected function getToolDefs() : Array
      {
         return bitmapTools;
      }
      
      override protected function onDrawPropsChange(param1:Event) : void
      {
         var _loc2_:BitmapPencilTool = currentTool as BitmapPencilTool;
         if(_loc2_)
         {
            _loc2_.updateProperties();
         }
         super.onDrawPropsChange(param1);
      }
      
      override public function shutdown() : void
      {
         super.shutdown();
         this.bakeIntoBitmap();
         this.saveToCostume();
      }
      
      override public function snapToGrid(param1:Point) : Point
      {
         var _loc2_:Sprite = getToolsLayer();
         var _loc3_:Sprite = workArea.getContentLayer();
         var _loc4_:Point = _loc3_.globalToLocal(_loc2_.localToGlobal(param1));
         var _loc5_:Point = workArea.getScale() == 1 ? new Point(Math.round(_loc4_.x),Math.round(_loc4_.y)) : new Point(Math.round(_loc4_.x * 2) / 2,Math.round(_loc4_.y * 2) / 2);
         return _loc2_.globalToLocal(_loc3_.localToGlobal(_loc5_));
      }
      
      public function getSelection(param1:Rectangle) : SVGBitmap
      {
         var _loc5_:SVGBitmap = null;
         var _loc2_:BitmapData = workArea.getBitmap().bitmapData;
         param1 = param1.intersection(_loc2_.rect);
         if(param1.width < 1 || param1.height < 1)
         {
            return null;
         }
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         _loc3_.copyPixels(_loc2_,param1,new Point(0,0));
         if(this.stampMode)
         {
            highlightTool("bitmapSelect");
         }
         else
         {
            _loc2_.fillRect(param1,this.bgColor());
         }
         if(isScene)
         {
            this.removeWhiteAroundSelection(_loc3_);
         }
         var _loc4_:SVGElement = SVGElement.makeBitmapEl(_loc3_,0.5);
         _loc5_ = new SVGBitmap(_loc4_,_loc4_.bitmap);
         _loc5_.redraw();
         _loc5_.x = param1.x / 2;
         _loc5_.y = param1.y / 2;
         workArea.getContentLayer().addChild(_loc5_);
         return _loc5_;
      }
      
      private function removeWhiteAroundSelection(param1:BitmapData) : void
      {
         var _loc4_:Point = null;
         var _loc2_:Rectangle = param1.getColorBoundsRect(4294967295,4294967295,false);
         if(_loc2_.width == 0 || _loc2_.height == 0)
         {
            return;
         }
         _loc2_.inflate(1,1);
         var _loc3_:Array = [new Point(_loc2_.x,_loc2_.y),new Point(_loc2_.right,0),new Point(0,_loc2_.bottom),new Point(_loc2_.right,_loc2_.bottom)];
         for each(_loc4_ in _loc3_)
         {
            if(param1.getPixel(_loc4_.x,_loc4_.y) == 16777215)
            {
               param1.floodFill(_loc4_.x,_loc4_.y,0);
            }
         }
      }
      
      override protected function selectHandler(param1:Event = null) : void
      {
         if(currentTool is ObjectTransformer && !(currentTool as ObjectTransformer).getSelection() && (currentTool as ObjectTransformer).isChanged)
         {
            this.bakeIntoBitmap();
            this.saveToCostume();
            (currentTool as ObjectTransformer).reset();
         }
         var _loc2_:Boolean = currentTool is ObjectTransformer && !!(currentTool as ObjectTransformer).getSelection();
         imagesPart.setCanCrop(_loc2_);
      }
      
      public function cropToSelection() : void
      {
         var _loc1_:Selection = null;
         var _loc3_:BitmapData = null;
         var _loc2_:ObjectTransformer = currentTool as ObjectTransformer;
         if(_loc2_)
         {
            _loc1_ = _loc2_.getSelection();
         }
         if(_loc1_)
         {
            _loc3_ = workArea.getBitmap().bitmapData;
            _loc3_.fillRect(_loc3_.rect,0);
            app.runtime.shiftIsDown = false;
            this.bakeIntoBitmap(false);
         }
      }
      
      public function deletingSelection() : void
      {
         if(app.runtime.shiftIsDown)
         {
            this.cropToSelection();
         }
      }
      
      override protected function loadCostume(param1:ScratchCostume) : void
      {
         var _loc2_:BitmapData = workArea.getBitmap().bitmapData;
         _loc2_.fillRect(_loc2_.rect,this.bgColor());
         var _loc3_:Rectangle = param1.scaleAndCenter(_loc2_,isScene);
         param1.segmentationState.unmarkedBitmap = _loc2_.clone();
         param1.segmentationState.costumeRect = _loc3_;
         var _loc4_:Number = 2 / param1.bitmapResolution;
         if(param1.undoList.length == 0)
         {
            recordForUndo(param1.bitmapForEditor(isScene),_loc4_ * param1.rotationCenterX,_loc4_ * param1.rotationCenterY);
         }
      }
      
      override public function addCostume(param1:ScratchCostume, param2:Point) : void
      {
         var _loc4_:SVGBitmap = null;
         var _loc3_:SVGElement = SVGElement.makeBitmapEl(param1.bitmapForEditor(isScene),0.5);
         _loc4_ = new SVGBitmap(_loc3_,_loc3_.bitmap);
         _loc4_.redraw();
         _loc4_.x = param2.x - param1.width() / 2;
         _loc4_.y = param2.y - param1.height() / 2;
         this.setToolMode("bitmapSelect");
         workArea.getContentLayer().addChild(_loc4_);
         (currentTool as ObjectTransformer).select(new Selection([_loc4_]));
      }
      
      override public function saveContent(param1:Event = null, param2:Boolean = true) : void
      {
         if(currentTool is ObjectTransformer)
         {
            return;
         }
         if(currentTool is TextTool)
         {
            return;
         }
         this.bakeIntoBitmap();
         this.saveToCostume(param2);
      }
      
      private function saveToCostume(param1:Boolean = true) : void
      {
         var _loc4_:Rectangle = null;
         var _loc5_:BitmapData = null;
         var _loc2_:ScratchCostume = targetCostume;
         var _loc3_:BitmapData = workArea.getBitmap().bitmapData;
         if(isScene)
         {
            _loc2_.setBitmapData(_loc3_.clone(),_loc3_.width / 2,_loc3_.height / 2);
         }
         else
         {
            _loc4_ = _loc3_.getColorBoundsRect(4278190080,0,false);
            if(_loc4_.width >= 1 && _loc4_.height >= 1)
            {
               _loc5_ = new BitmapData(_loc4_.width,_loc4_.height,true,0);
               _loc5_.copyPixels(_loc3_,_loc4_,new Point(0,0));
               _loc2_.setBitmapData(_loc5_,Math.floor(480 - _loc4_.x),Math.floor(360 - _loc4_.y));
            }
            else
            {
               _loc5_ = new BitmapData(2,2,true,0);
               _loc2_.setBitmapData(_loc5_,0,0);
            }
         }
         if(param1)
         {
            recordForUndo(_loc2_.baseLayerBitmap.clone(),_loc2_.rotationCenterX,_loc2_.rotationCenterY);
            Scratch.app.setSaveNeeded();
         }
         else if(targetCostume.undoListIndex < targetCostume.undoList.length)
         {
            targetCostume.undoList = targetCostume.undoList.slice(0,targetCostume.undoListIndex + 1);
         }
      }
      
      override public function setToolMode(param1:String, param2:Boolean = false, param3:Boolean = false) : void
      {
         imagesPart.setCanCrop(false);
         highlightTool("none");
         var _loc4_:ISVGEditable = null;
         if((param2 || param1 != toolMode) && currentTool is SVGEditTool)
         {
            _loc4_ = (currentTool as SVGEditTool).getObject();
         }
         super.setToolMode(param1,param2,param3);
         if(_loc4_)
         {
            if(!(currentTool is ObjectTransformer))
            {
               this.bakeIntoBitmap();
               this.saveToCostume();
               if(segmentationTool)
               {
                  segmentationTool.refresh();
               }
            }
         }
      }
      
      private function createdObjectIsEmpty() : Boolean
      {
         var _loc2_:SVGShape = null;
         var _loc3_:SVGElement = null;
         var _loc4_:Object = null;
         var _loc1_:Sprite = workArea.getContentLayer();
         if(_loc1_.numChildren == 1)
         {
            _loc2_ = _loc1_.getChildAt(0) as SVGShape;
            if(_loc2_)
            {
               _loc3_ = _loc2_.getElement();
               _loc4_ = _loc3_.attributes;
               if(_loc3_.tag == "ellipse")
               {
                  if(!_loc4_.rx || _loc4_.rx < 1)
                  {
                     return true;
                  }
                  if(!_loc4_.ry || _loc4_.ry < 1)
                  {
                     return true;
                  }
               }
               if(_loc3_.tag == "rect")
               {
                  if(!_loc4_.width || _loc4_.width < 1)
                  {
                     return true;
                  }
                  if(!_loc4_.height || _loc4_.height < 1)
                  {
                     return true;
                  }
               }
            }
         }
         return false;
      }
      
      private function bakeIntoBitmap(param1:Boolean = true) : void
      {
         var _loc4_:Matrix = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         var _loc8_:SVGTextField = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc2_:Sprite = workArea.getContentLayer();
         if(_loc2_.numChildren == 0)
         {
            return;
         }
         var _loc3_:BitmapData = workArea.getBitmap().bitmapData;
         if(Boolean(_loc3_) && _loc2_.numChildren > 0)
         {
            _loc4_ = _loc2_.getChildAt(0).transform.matrix.clone();
            _loc4_.scale(2,2);
            _loc5_ = stage.quality;
            if(!Scratch.app.runtime.shiftIsDown)
            {
               stage.quality = StageQuality.LOW;
            }
            _loc6_ = 0;
            while(_loc6_ < _loc2_.numChildren)
            {
               _loc7_ = _loc2_.getChildAt(_loc6_) as DisplayObject;
               _loc8_ = _loc7_ as SVGTextField;
               if(Boolean(_loc8_) && !Scratch.app.runtime.shiftIsDown)
               {
                  _loc9_ = 96 << 24;
                  _loc10_ = 0xFF000000 | _loc8_.textColor;
                  this.clearOffscreenBM();
                  this.offscreenBM.draw(_loc7_,_loc4_,null,null,null,true);
                  this.offscreenBM.threshold(this.offscreenBM,this.offscreenBM.rect,new Point(0,0),">",_loc9_,_loc10_,4278190080,false);
                  this.offscreenBM.threshold(this.offscreenBM,this.offscreenBM.rect,new Point(0,0),"<=",_loc9_,0,4278190080,false);
                  _loc3_.draw(this.offscreenBM);
               }
               else
               {
                  _loc3_.draw(_loc7_,_loc4_,null,null,null,true);
               }
               _loc6_++;
            }
            stage.quality = _loc5_;
         }
         if(param1)
         {
            workArea.clearContent();
         }
         this.stampMode = false;
      }
      
      private function clearOffscreenBM() : void
      {
         var _loc1_:BitmapData = workArea.getBitmap().bitmapData;
         if(!this.offscreenBM || this.offscreenBM.width != _loc1_.width || this.offscreenBM.height != _loc1_.height)
         {
            this.offscreenBM = new BitmapData(_loc1_.width,_loc1_.height,true,0);
            return;
         }
         this.offscreenBM.fillRect(this.offscreenBM.rect,0);
      }
      
      override public function translateContents(param1:Number, param2:Number) : void
      {
         var _loc3_:BitmapData = workArea.getBitmap().bitmapData;
         var _loc4_:BitmapData = new BitmapData(_loc3_.width,_loc3_.height,true,0);
         _loc4_.copyPixels(_loc3_,_loc3_.rect,new Point(Math.round(2 * param1),Math.round(2 * param2)));
         workArea.getBitmap().bitmapData = _loc4_;
      }
      
      private function addStampTool() : void
      {
         var _loc1_:Point = new Point(37,33);
         var _loc2_:DisplayObject = toolButtonsLayer.getChildAt(toolButtonsLayer.numChildren - 1);
         var _loc3_:IconButton = new IconButton(this.stampBitmap,SoundsPart.makeButtonImg("bitmapStamp",true,_loc1_),SoundsPart.makeButtonImg("bitmapStamp",false,_loc1_));
         _loc3_.x = 0;
         _loc3_.y = _loc2_.y + _loc2_.height + 4;
         SimpleTooltips.add(_loc3_,{
            "text":"Select and duplicate",
            "direction":"right"
         });
         registerToolButton("bitmapStamp",_loc3_);
         toolButtonsLayer.addChild(_loc3_);
      }
      
      private function stampBitmap(param1:*) : void
      {
         this.setToolMode("bitmapBrush");
         this.setToolMode("bitmapSelect");
         highlightTool("bitmapStamp");
         this.stampMode = true;
      }
      
      override protected function flipAll(param1:Boolean) : void
      {
         workArea.getBitmap().bitmapData = flipBitmap(param1,workArea.getBitmap().bitmapData);
         if(Boolean(segmentationTool) && Boolean(targetCostume.segmentationState.lastMask))
         {
            targetCostume.segmentationState.recordForUndo();
            targetCostume.nextSegmentationState();
            targetCostume.segmentationState.flip(param1);
            segmentationTool.refreshSegmentation();
         }
         else
         {
            this.saveToCostume();
         }
      }
      
      private function getBitmapSelection() : SVGBitmap
      {
         var _loc3_:SVGBitmap = null;
         var _loc1_:Sprite = workArea.getContentLayer();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.numChildren)
         {
            _loc3_ = _loc1_.getChildAt(_loc2_) as SVGBitmap;
            if(_loc3_)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function scaleAll(param1:Number) : void
      {
         var _loc2_:BitmapData = workArea.getBitmap().bitmapData;
         var _loc3_:Rectangle = isScene ? _loc2_.getColorBoundsRect(4294967295,4294967295,false) : _loc2_.getColorBoundsRect(4278190080,0,false);
         var _loc4_:BitmapData = new BitmapData(Math.max(1,_loc3_.width * param1),Math.max(1,_loc3_.height * param1),true,this.bgColor());
         var _loc5_:Matrix = new Matrix();
         _loc5_.translate(-_loc3_.x,-_loc3_.y);
         _loc5_.scale(param1,param1);
         _loc4_.draw(_loc2_,_loc5_);
         var _loc6_:Point = new Point(_loc3_.x - _loc3_.width * (param1 - 1) / 2,_loc3_.y - _loc3_.height * (param1 - 1) / 2);
         _loc2_.fillRect(_loc2_.rect,this.bgColor());
         _loc2_.copyPixels(_loc4_,_loc4_.rect,_loc6_);
         this.saveToCostume();
      }
      
      override protected function clearSelection() : void
      {
         if(!segmentationTool)
         {
            this.setToolMode(lastToolMode ? lastToolMode : toolMode,true);
         }
      }
      
      override public function canClearCanvas() : Boolean
      {
         var _loc1_:BitmapData = workArea.getBitmap().bitmapData;
         var _loc2_:Rectangle = _loc1_.getColorBoundsRect(4294967295,this.bgColor(),false);
         return _loc2_.width > 0 && _loc2_.height > 0;
      }
      
      override public function clearCanvas(param1:* = null) : void
      {
         this.setToolMode("bitmapBrush");
         var _loc2_:BitmapData = workArea.getBitmap().bitmapData;
         _loc2_.fillRect(_loc2_.rect,this.bgColor());
         super.clearCanvas();
      }
      
      private function bgColor() : int
      {
         return isScene ? int(4294967295) : 0;
      }
      
      override protected function restoreUndoState(param1:Array) : void
      {
         var _loc2_:ScratchCostume = targetCostume;
         _loc2_.setBitmapData(param1[0],param1[1],param1[2]);
         this.loadCostume(_loc2_);
      }
   }
}

