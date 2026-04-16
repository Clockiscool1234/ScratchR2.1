package svgeditor
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.*;
   import scratch.ScratchCostume;
   import svgeditor.objs.*;
   import svgeditor.tools.*;
   import svgutils.*;
   import ui.parts.ImagesPart;
   import uiwidgets.*;
   
   public class SVGEdit extends ImageEdit
   {
      
      public static const tools:Array = [{
         "name":"select",
         "desc":"Select"
      },{
         "name":"pathedit",
         "desc":"Reshape"
      },null,{
         "name":"path",
         "desc":"Pencil"
      },{
         "name":"vectorLine",
         "desc":"Line"
      },{
         "name":"vectorRect",
         "desc":"Rectangle",
         "shiftDesc":"Square"
      },{
         "name":"vectorEllipse",
         "desc":"Ellipse",
         "shiftDesc":"Circle"
      },{
         "name":"text",
         "desc":"Text"
      },null,{
         "name":"vpaintbrush",
         "desc":"Color a shape"
      },{
         "name":"clone",
         "desc":"Duplicate",
         "shiftDesc":"Multiple"
      },null,{
         "name":"front",
         "desc":"Forward a layer",
         "shiftDesc":"Bring to front"
      },{
         "name":"back",
         "desc":"Back a layer",
         "shiftDesc":"Send to back"
      },{
         "name":"group",
         "desc":"Group"
      },{
         "name":"ungroup",
         "desc":"Ungroup"
      }];
      
      private static const immediateTools:Array = ["back","front","group","ungroup","noZoom","zoomOut"];
      
      private static const bmptoolist:Array = ["wand","lasso","slice"];
      
      private static const unimplemented:Array = ["wand","lasso","slice"];
      
      private var smoothValue:Number = 20;
      
      private var lastShape:SVGShape = null;
      
      public function SVGEdit(param1:Scratch, param2:ImagesPart)
      {
         super(param1,param2);
         PathEndPointManager.init(this);
         setToolMode("path");
      }
      
      override protected function getToolDefs() : Array
      {
         return tools;
      }
      
      override protected function getImmediateToolList() : Array
      {
         return immediateTools;
      }
      
      override protected function selectHandler(param1:Event = null) : void
      {
         var _loc4_:Selection = null;
         var _loc5_:ISVGEditable = null;
         drawPropsUI.showSmoothnessUI(false);
         var _loc2_:Array = [];
         var _loc3_:Boolean = false;
         if(currentTool is ObjectTransformer)
         {
            _loc4_ = currentTool is ObjectTransformer ? (currentTool as ObjectTransformer).getSelection() : null;
            if(_loc4_)
            {
               _loc2_ = _loc4_.getObjs();
               _loc3_ = _loc4_.isGroup();
            }
         }
         else if(currentTool is SVGEditTool)
         {
            _loc5_ = (currentTool as SVGEditTool).getObject();
            if(_loc5_)
            {
               _loc2_.push(_loc5_);
               drawPropsUI.showSmoothnessUI(_loc5_ is SVGShape,false);
               if(_loc5_ is SVGTextField)
               {
                  drawPropsUI.updateFontUI(_loc5_.getElement().getAttribute("font-family"));
               }
            }
         }
         this.lastShape = null;
         if(_loc2_.length == 1)
         {
            updateShapeUI(_loc2_[0]);
         }
         (toolButtons["group"] as IconButton).setDisabled(_loc2_.length < 2);
         (toolButtons["ungroup"] as IconButton).setDisabled(!_loc2_.length || !_loc3_);
         (toolButtons["front"] as IconButton).setDisabled(!_loc2_.length);
         (toolButtons["back"] as IconButton).setDisabled(!_loc2_.length);
      }
      
      override public function setWidthHeight(param1:int, param2:int) : void
      {
         super.setWidthHeight(param1,param2);
         toolButtonsLayer.x = param1 - 25;
      }
      
      public function smoothStroke() : void
      {
         var _loc2_:SVGShape = null;
         var _loc1_:Boolean = false;
         if(currentTool is SVGEditTool)
         {
            _loc2_ = (currentTool as SVGEditTool).getObject() as SVGShape;
            if(_loc2_)
            {
               if(_loc2_ == this.lastShape)
               {
                  this.smoothValue = Math.min(35,this.smoothValue + 5);
               }
               else
               {
                  this.smoothValue = 20;
               }
               _loc2_.smoothPath2(this.smoothValue);
               this.saveContent();
               currentTool.refresh();
               this.lastShape = _loc2_;
               _loc1_ = true;
            }
         }
         if(!_loc1_)
         {
            this.lastShape = null;
         }
      }
      
      private function showPanel(param1:Sprite) : void
      {
         var _loc2_:int = (w - param1.width) / 2;
         var _loc3_:int = (h - param1.height) / 2;
         param1.x = _loc2_;
         param1.y = _loc3_;
         addChild(param1);
      }
      
      override protected function runImmediateTool(param1:String, param2:Boolean, param3:Selection) : void
      {
         if(!(currentTool is ObjectTransformer) || !param3)
         {
            return;
         }
         var _loc4_:Boolean = true;
         switch(param1)
         {
            case "front":
               param3.raise(param2);
               break;
            case "back":
               param3.lower(param2);
               break;
            case "group":
               this.highlightElements(param3,false);
               param3 = param3.group();
               (currentTool as ObjectTransformer).select(null);
               (currentTool as ObjectTransformer).select(param3);
               break;
            case "ungroup":
               param3 = param3.ungroup();
               this.highlightElements(param3,true);
               (currentTool as ObjectTransformer).select(null);
               break;
            default:
               _loc4_ = false;
         }
         if(_loc4_)
         {
            this.saveContent();
         }
      }
      
      override protected function onDrawPropsChange(param1:Event) : void
      {
         var _loc2_:ISVGEditable = null;
         var _loc3_:SVGElement = null;
         if(currentTool is SVGEditTool && toolMode != "select" && toolMode != "text")
         {
            _loc2_ = (currentTool as SVGEditTool).getObject();
            if(_loc2_)
            {
               _loc3_ = _loc2_.getElement();
               _loc3_.setAttribute("stroke-width",drawPropsUI.settings.strokeWidth);
               _loc2_.redraw();
               this.saveContent();
            }
         }
         else
         {
            super.onDrawPropsChange(param1);
         }
      }
      
      override protected function stageKeyDownHandler(param1:KeyboardEvent) : Boolean
      {
         if(!super.stageKeyDownHandler(param1))
         {
            if(param1.keyCode == 83)
            {
               this.smoothStroke();
            }
         }
         return false;
      }
      
      private function highlightElements(param1:Selection, param2:Boolean) : void
      {
         var t:Timer = null;
         var maxStrength:uint = 0;
         var s:Selection = param1;
         var separating:Boolean = param2;
         if(!separating)
         {
            return;
         }
         t = new Timer(20,25);
         maxStrength = 12;
         t.addEventListener(TimerEvent.TIMER,function(param1:TimerEvent):void
         {
            var _loc6_:DisplayObject = null;
            var _loc3_:Number = maxStrength * (1 - t.currentCount / t.repeatCount);
            var _loc4_:Number = 6 + _loc3_ * 0.5;
            _loc3_ += 2;
            var _loc5_:Array = [new GlowFilter(16777215,1 - t.currentCount / t.repeatCount,_loc4_,_loc4_,_loc3_),new GlowFilter(2663898)];
            for each(_loc6_ in s.getObjs())
            {
               _loc6_.filters = _loc5_;
            }
            if(t.currentCount == t.repeatCount)
            {
               t.removeEventListener(TimerEvent.TIMER,arguments.callee);
            }
            param1.updateAfterEvent();
         });
         t.addEventListener(TimerEvent.TIMER_COMPLETE,function(param1:TimerEvent):void
         {
            var _loc4_:DisplayObject = null;
            t.removeEventListener(TimerEvent.TIMER_COMPLETE,arguments.callee);
            t.stop();
            t = null;
            var _loc3_:Array = [];
            for each(_loc4_ in s.getObjs())
            {
               _loc4_.filters = _loc3_;
            }
         });
         t.start();
      }
      
      override protected function flipAll(param1:Boolean) : void
      {
         var _loc2_:Sprite = workArea.getContentLayer();
         if(_loc2_.numChildren == 0)
         {
            return;
         }
         var _loc3_:Array = new Array(_loc2_.numChildren);
         var _loc4_:uint = 0;
         while(_loc4_ < _loc2_.numChildren)
         {
            _loc3_[_loc4_] = _loc2_.getChildAt(_loc4_);
            _loc4_++;
         }
         var _loc5_:Selection = new Selection(_loc3_);
         _loc5_.flip(param1);
         _loc5_.shutdown();
         this.saveContent();
      }
      
      override public function stamp() : void
      {
         setToolMode("clone");
      }
      
      override protected function loadCostume(param1:ScratchCostume) : void
      {
         workArea.clearContent();
         if(param1.isBitmap())
         {
            this.insertBitmap(param1.baseLayerBitmap.clone(),param1.costumeName,true,targetCostume.rotationCenterX,targetCostume.rotationCenterY);
            this.insertOldTextLayer();
         }
         else
         {
            if(targetCostume.undoList.length == 0)
            {
               recordForUndo(param1.baseLayerData,param1.rotationCenterX,param1.rotationCenterY);
            }
            this.installSVGData(param1.baseLayerData,param1.rotationCenterX,param1.rotationCenterY);
         }
         imagesPart.refreshUndoButtons();
         if(toolMode == "select" || Boolean(param1.svgRoot && param1.svgRoot.subElements.length) && (Boolean(!isScene || param1.svgRoot.subElements.length > 1)))
         {
            setToolMode("select",true);
         }
      }
      
      override public function addCostume(param1:ScratchCostume, param2:Point) : void
      {
         var _loc3_:Point = new Point(ImageCanvas.canvasWidth / 2,ImageCanvas.canvasHeight / 2);
         _loc3_ = _loc3_.subtract(param2);
         _loc3_ = _loc3_.add(new Point(param1.rotationCenterX,param1.rotationCenterY));
         if(param1.isBitmap())
         {
            this.insertBitmap(param1.baseLayerBitmap.clone(),param1.costumeName,false,_loc3_.x,_loc3_.y);
            this.insertOldTextLayer();
         }
         else
         {
            this.installSVGData(param1.baseLayerData,Math.round(_loc3_.x),Math.round(_loc3_.y),true);
         }
         this.saveContent();
      }
      
      private function insertBitmap(param1:BitmapData, param2:String, param3:Boolean, param4:Number, param5:Number) : void
      {
         var _loc8_:BitmapData = null;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         if(!param1.transparent)
         {
            _loc8_ = new BitmapData(param1.width,param1.height,true,0);
            _loc8_.copyPixels(param1,param1.rect,new Point(0,0));
            param1 = _loc8_;
         }
         if(param3)
         {
            this.saveInitialBitmapForUndo(param1,param2);
         }
         var _loc6_:SVGElement = new SVGElement("image",param2);
         _loc6_.bitmap = param1;
         _loc6_.setAttribute("x",0);
         _loc6_.setAttribute("y",0);
         _loc6_.setAttribute("width",param1.width);
         _loc6_.setAttribute("height",param1.height);
         if(!isScene)
         {
            _loc9_ = Math.ceil(ImageCanvas.canvasWidth / 2 - param4);
            _loc10_ = Math.ceil(ImageCanvas.canvasHeight / 2 - param5);
            _loc6_.transform = new Matrix();
            _loc6_.transform.translate(_loc9_,_loc10_);
         }
         var _loc7_:SVGBitmap = new SVGBitmap(_loc6_);
         _loc7_.redraw();
         workArea.getContentLayer().addChild(_loc7_);
      }
      
      private function insertOldTextLayer() : void
      {
         var _loc10_:uint = 0;
         var _loc11_:String = null;
         var _loc12_:String = null;
         if(!targetCostume.text)
         {
            return;
         }
         var _loc1_:int = targetCostume.textRect.x;
         var _loc2_:int = targetCostume.textRect.y;
         if(!isScene)
         {
            _loc1_ += ImageCanvas.canvasWidth / 2 - targetCostume.rotationCenterX;
            _loc2_ += ImageCanvas.canvasHeight / 2 - targetCostume.rotationCenterY;
         }
         var _loc3_:TextField = new TextField();
         _loc3_.defaultTextFormat = new TextFormat("Helvetica",targetCostume.fontSize);
         _loc1_ += 5;
         _loc2_ += Math.round(0.9 * _loc3_.getLineMetrics(0).ascent);
         var _loc4_:SVGElement = new SVGElement("text");
         _loc4_.text = targetCostume.text;
         _loc4_.setAttribute("font-family","Helvetica");
         _loc4_.setAttribute("font-weight","bold");
         _loc4_.setAttribute("font-size",targetCostume.fontSize);
         _loc4_.setAttribute("stroke",SVGElement.colorToHex(targetCostume.textColor & 0xFFFFFF));
         _loc4_.setAttribute("text-anchor","start");
         _loc4_.transform = new Matrix(1,0,0,1,_loc1_,_loc2_);
         var _loc5_:SVGTextField = new SVGTextField(_loc4_);
         _loc5_.redraw();
         workArea.getContentLayer().addChild(_loc5_);
         var _loc6_:Number = 480 - _loc5_.x;
         var _loc7_:String = _loc4_.text;
         var _loc8_:uint = 0;
         _loc5_.text = "";
         var _loc9_:uint = 0;
         while(_loc9_ < _loc7_.length)
         {
            _loc5_.text += _loc7_.charAt(_loc9_);
            if(_loc5_.textWidth > _loc6_)
            {
               _loc10_ = _loc9_;
               while(_loc10_ > _loc8_)
               {
                  _loc11_ = _loc7_.charAt(_loc10_);
                  if(_loc11_.match(/\s/) != null)
                  {
                     _loc12_ = _loc5_.text;
                     _loc5_.text = _loc12_.substring(0,_loc10_) + "\n" + _loc12_.substring(_loc10_ + 1);
                     _loc8_ = _loc10_ + 1;
                     break;
                  }
                  _loc10_--;
               }
            }
            _loc9_++;
         }
         _loc4_.text = _loc5_.text;
         _loc5_.redraw();
      }
      
      private function installSVGData(param1:ByteArray, param2:int, param3:int, param4:Boolean = false) : void
      {
         var importer:SVGImporter;
         var imagesLoaded:Function = null;
         var data:ByteArray = param1;
         var rotationCenterX:int = param2;
         var rotationCenterY:int = param3;
         var isInsert:Boolean = param4;
         imagesLoaded = function(param1:SVGElement):void
         {
            var _loc2_:Array = null;
            var _loc3_:Sprite = null;
            var _loc4_:int = 0;
            var _loc5_:int = 0;
            if(isInsert)
            {
               _loc2_ = [];
               _loc3_ = workArea.getContentLayer();
               while(_loc3_.numChildren)
               {
                  _loc2_.push(_loc3_.removeChildAt(0));
               }
            }
            Renderer.renderToSprite(workArea.getContentLayer(),param1);
            if(!isScene)
            {
               _loc4_ = Math.ceil(ImageCanvas.canvasWidth / 2 - rotationCenterX);
               _loc5_ = Math.ceil(ImageCanvas.canvasHeight / 2 - rotationCenterY);
               translateContents(_loc4_,_loc5_);
            }
            if(isInsert)
            {
               while(_loc2_.length)
               {
                  _loc3_.addChildAt(_loc2_.pop(),0);
               }
            }
         };
         if(!isInsert)
         {
            workArea.clearContent();
         }
         importer = new SVGImporter(XML(data));
         importer.loadAllImages(imagesLoaded);
      }
      
      override public function saveContent(param1:Event = null, param2:Boolean = true) : void
      {
         var _loc4_:ByteArray = null;
         var _loc5_:Rectangle = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc3_:Sprite = workArea.getContentLayer();
         if(isScene)
         {
            _loc4_ = this.convertToSVG(_loc3_);
            targetCostume.setSVGData(_loc4_,false);
         }
         else
         {
            _loc5_ = _loc3_.getBounds(_loc3_);
            _loc6_ = Math.floor(_loc5_.x);
            _loc7_ = Math.floor(_loc5_.y);
            this.translateContents(-_loc6_,-_loc7_);
            _loc4_ = this.convertToSVG(_loc3_);
            targetCostume.setSVGData(_loc4_,false);
            this.translateContents(_loc6_,_loc7_);
            targetCostume.rotationCenterX = ImageCanvas.canvasWidth / 2 - _loc6_;
            targetCostume.rotationCenterY = ImageCanvas.canvasHeight / 2 - _loc7_;
            app.viewedObj().updateCostume();
         }
         recordForUndo(_loc4_,targetCostume.rotationCenterX,targetCostume.rotationCenterY);
         app.setSaveNeeded();
      }
      
      override public function canClearCanvas() : Boolean
      {
         return workArea.getContentLayer().numChildren > 0;
      }
      
      override public function clearCanvas(param1:* = null) : void
      {
         if(isScene)
         {
            targetCostume.baseLayerData = ScratchCostume.emptyBackdropSVG();
            this.installSVGData(targetCostume.baseLayerData,targetCostume.rotationCenterX,targetCostume.rotationCenterY);
         }
         else
         {
            workArea.clearContent();
         }
         super.clearCanvas(param1);
      }
      
      override public function translateContents(param1:Number, param2:Number) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:Matrix = null;
         var _loc3_:Sprite = workArea.getContentLayer();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.numChildren)
         {
            _loc5_ = _loc3_.getChildAt(_loc4_);
            if("getElement" in _loc5_)
            {
               _loc6_ = _loc5_.transform.matrix || new Matrix();
               _loc6_.translate(param1,param2);
               _loc5_.transform.matrix = _loc6_;
            }
            _loc4_++;
         }
      }
      
      private function convertToSVG(param1:Sprite) : ByteArray
      {
         var _loc4_:* = undefined;
         var _loc2_:SVGElement = new SVGElement("svg",targetCostume.costumeName);
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if("getElement" in _loc4_)
            {
               _loc2_.subElements.push(_loc4_.getElement());
            }
            _loc3_++;
         }
         return new SVGExport(_loc2_).svgData();
      }
      
      private function saveInitialBitmapForUndo(param1:BitmapData, param2:String) : void
      {
         var _loc3_:SVGElement = new SVGElement("svg",param2);
         var _loc4_:SVGElement = new SVGElement("image",param2);
         _loc4_.bitmap = param1;
         _loc4_.setAttribute("x",0);
         _loc4_.setAttribute("y",0);
         _loc4_.setAttribute("width",param1.width);
         _loc4_.setAttribute("height",param1.height);
         _loc3_.subElements.push(_loc4_);
         var _loc5_:ByteArray = new SVGExport(_loc3_).svgData();
         recordForUndo(_loc5_,targetCostume.rotationCenterX,targetCostume.rotationCenterY);
      }
      
      override protected function restoreUndoState(param1:Array) : void
      {
         var _loc3_:ISVGEditable = null;
         var _loc2_:String = null;
         if(toolMode == "select")
         {
            setToolMode("select",true);
         }
         else if(currentTool is SVGEditTool && Boolean((currentTool as SVGEditTool).getObject()))
         {
            _loc2_ = (currentTool as SVGEditTool).getObject().getElement().id;
         }
         this.installSVGData(param1[0],param1[1],param1[2]);
         if(_loc2_)
         {
            _loc3_ = this.getElementByID(_loc2_);
            if(_loc3_)
            {
               (currentTool as SVGEditTool).setObject(_loc3_);
               currentTool.refresh();
            }
            else
            {
               (currentTool as SVGEditTool).setObject(null);
            }
         }
      }
      
      private function getElementByID(param1:String, param2:Sprite = null) : ISVGEditable
      {
         var _loc4_:* = undefined;
         var _loc5_:ISVGEditable = null;
         if(!param2)
         {
            param2 = getContentLayer();
         }
         var _loc3_:int = 0;
         while(_loc3_ < param2.numChildren)
         {
            _loc4_ = param2.getChildAt(_loc3_);
            if(_loc4_ is SVGGroup)
            {
               _loc5_ = this.getElementByID(param1,_loc4_ as Sprite);
               if(_loc5_)
               {
                  return _loc5_;
               }
            }
            else if(_loc4_ is ISVGEditable && (_loc4_ as ISVGEditable).getElement().id == param1)
            {
               return _loc4_ as ISVGEditable;
            }
            _loc3_++;
         }
         return null;
      }
   }
}

