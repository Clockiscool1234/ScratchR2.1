package svgeditor
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.ByteArray;
   import scratch.*;
   import svgeditor.objs.*;
   import svgeditor.tools.*;
   import svgutils.*;
   import translation.Translator;
   import ui.media.MediaInfo;
   import ui.parts.ImagesPart;
   import uiwidgets.*;
   import util.ProjectIO;
   
   public class ImageEdit extends Sprite
   {
      
      public static const repeatedTools:Array = ["rect","ellipse","vectorRect","vectorEllipse","text"];
      
      public static const selectionTools:Array = ["select","bitmapSelect"];
      
      public var app:Scratch;
      
      public var imagesPart:ImagesPart;
      
      public var targetCostume:ScratchCostume;
      
      public var isScene:Boolean;
      
      protected var toolMode:String;
      
      protected var lastToolMode:String;
      
      protected var currentTool:SVGTool;
      
      protected var drawPropsUI:DrawPropertyUI;
      
      protected var toolButtons:Object;
      
      protected var toolButtonsLayer:Sprite;
      
      protected var w:int;
      
      protected var h:int;
      
      protected var workArea:ImageCanvas;
      
      private var uiLayer:Sprite;
      
      private var toolsLayer:Sprite;
      
      private var svgEditorMask:Shape;
      
      private var currentCursor:String;
      
      private var globalToolObject:ISVGEditable;
      
      protected var clipBoard:*;
      
      public function ImageEdit(param1:Scratch, param2:ImagesPart)
      {
         super();
         this.app = param1;
         this.imagesPart = param2;
         this.toolsLayer = new Sprite();
         this.workArea = new ImageCanvas(100,100,this);
         addChild(this.workArea);
         addChild(this.toolsLayer);
         addChild(this.uiLayer = new Sprite());
         this.svgEditorMask = new Shape();
         mask = this.svgEditorMask;
         addChild(this.svgEditorMask);
         this.toolButtons = new Object();
         this.toolButtonsLayer = new Sprite();
         this.uiLayer.addChild(this.toolButtonsLayer);
         param1.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.stageKeyDownHandler,false,0,true);
         this.workArea.getContentLayer().addEventListener(MouseEvent.MOUSE_OVER,this.workAreaMouseHandler);
         this.workArea.getContentLayer().addEventListener(MouseEvent.MOUSE_OUT,this.workAreaMouseHandler);
         this.createTools();
         this.addDrawPropsUI();
         var _loc3_:DrawProperties = new DrawProperties();
         _loc3_.color = 4278190080;
         _loc3_.strokeWidth = 2;
         _loc3_.eraserWidth = _loc3_.strokeWidth * 4;
         _loc3_.filledShape = this is BitmapEdit;
         this.drawPropsUI.updateUI(_loc3_);
         this.selectHandler();
      }
      
      public static function strings() : Array
      {
         var _loc3_:Object = null;
         var _loc1_:Array = ["Shift:","Select and duplicate"];
         var _loc2_:Array = SVGEdit.tools.concat(BitmapEdit.bitmapTools);
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_)
            {
               if(_loc3_.desc)
               {
                  _loc1_.push(_loc3_.desc);
               }
               if(_loc3_.shiftDesc)
               {
                  _loc1_.push(_loc3_.shiftDesc);
               }
            }
         }
         return _loc1_;
      }
      
      public static function makeToolButton(param1:String, param2:Boolean, param3:Point = null) : Sprite
      {
         var _loc4_:Bitmap = param2 ? Resources.createBmp(param1 + "On") : Resources.createBmp(param1 + "Off");
         return buttonFrame(_loc4_,param2,param3);
      }
      
      public static function buttonFrame(param1:DisplayObject, param2:Boolean, param3:Point = null) : Sprite
      {
         var _loc8_:Matrix = null;
         var _loc4_:int = param3 ? int(param3.x) : int(param1.width);
         var _loc5_:int = param3 ? int(param3.y) : int(param1.height);
         var _loc6_:Sprite = new Sprite();
         var _loc7_:Graphics = _loc6_.graphics;
         _loc7_.clear();
         _loc7_.lineStyle(0.5,CSS.borderColor,1,true);
         if(param2)
         {
            _loc7_.beginFill(CSS.overColor,0.7);
            param1.alpha = 0.9;
         }
         else
         {
            _loc8_ = new Matrix();
            _loc8_.createGradientBox(_loc4_,_loc5_,Math.PI / 2,0,0);
            _loc7_.beginGradientFill(GradientType.LINEAR,CSS.titleBarColors,[100,100],[0,255],_loc8_);
         }
         _loc7_.drawRoundRect(0,0,_loc4_,_loc5_,8);
         _loc7_.endFill();
         param1.x = (_loc4_ - param1.width) / 2;
         param1.y = (_loc5_ - param1.height) / 2;
         _loc6_.addChild(param1);
         return _loc6_;
      }
      
      protected function get segmentationTool() : BitmapBackgroundTool
      {
         return this.currentTool as BitmapBackgroundTool;
      }
      
      private function get objectTransformer() : ObjectTransformer
      {
         return this.currentTool as ObjectTransformer;
      }
      
      public function clickedOutsideBitmap(param1:MouseEvent) : Boolean
      {
         return param1.target == this.imagesPart;
      }
      
      public function editingScene() : Boolean
      {
         return this.isScene;
      }
      
      public function getCanvasLayer() : Sprite
      {
         return this.workArea.getInteractionLayer();
      }
      
      public function getContentLayer() : Sprite
      {
         return this.workArea.getContentLayer();
      }
      
      public function getShapeProps() : DrawProperties
      {
         return this.drawPropsUI.settings;
      }
      
      public function setShapeProps(param1:DrawProperties) : void
      {
         this.drawPropsUI.settings = param1;
      }
      
      public function getStrokeSmoothness() : Number
      {
         return this.drawPropsUI.getStrokeSmoothness();
      }
      
      public function getToolsLayer() : Sprite
      {
         return this.toolsLayer;
      }
      
      public function getWorkArea() : ImageCanvas
      {
         return this.workArea;
      }
      
      public function handleDrop(param1:*) : Boolean
      {
         var insertCostume:Function = null;
         var insertSprite:Function = null;
         var dropPoint:Point = null;
         var projIO:ProjectIO = null;
         var obj:* = param1;
         insertCostume = function(param1:ScratchCostume):void
         {
            addCostume(param1,dropPoint);
         };
         insertSprite = function(param1:ScratchSprite):void
         {
            addCostume(param1.currentCostume(),dropPoint);
         };
         var item:MediaInfo = obj as MediaInfo;
         if(item)
         {
            dropPoint = this.workArea.getContentLayer().globalToLocal(new Point(stage.mouseX,stage.mouseY));
            projIO = new ProjectIO(this.app);
            if(item.mycostume)
            {
               insertCostume(item.mycostume);
            }
            else if(item.mysprite)
            {
               insertSprite(item.mysprite);
            }
            else if("image" == item.objType)
            {
               projIO.fetchImage(item.md5,item.objName,item.objWidth,insertCostume);
            }
            else if("sprite" == item.objType)
            {
               projIO.fetchSprite(item.md5,insertSprite);
            }
            return true;
         }
         return false;
      }
      
      public function refreshCurrentTool() : void
      {
         if(this.currentTool)
         {
            this.currentTool.refresh();
         }
      }
      
      protected function selectHandler(param1:Event = null) : void
      {
      }
      
      private function workAreaMouseHandler(param1:MouseEvent) : void
      {
         var _loc2_:ISVGEditable = null;
         var _loc3_:Selection = null;
         if(param1.type == MouseEvent.MOUSE_OVER && this.currentCursor != null)
         {
            CursorTool.setCustomCursor(this.currentCursor);
         }
         else
         {
            CursorTool.setCustomCursor(MouseCursor.AUTO);
         }
         if(param1.type == MouseEvent.MOUSE_OVER && Boolean(CursorTool.tool))
         {
            _loc2_ = SVGTool.staticGetEditableUnderMouse(this);
            _loc3_ = new Selection([_loc2_]);
            if(!_loc3_.isGroup())
            {
               this.workArea.getContentLayer().addEventListener(MouseEvent.MOUSE_DOWN,this.workAreaMouseDown,false,1,true);
            }
            else
            {
               this.workArea.getContentLayer().addEventListener(MouseEvent.MOUSE_DOWN,this.workAreaMouseDown,true,1,true);
            }
         }
         else
         {
            this.workArea.getContentLayer().removeEventListener(MouseEvent.MOUSE_DOWN,this.workAreaMouseDown);
         }
      }
      
      private function workAreaMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:ISVGEditable = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Point = null;
         var _loc6_:Matrix = null;
         var _loc7_:Point = null;
         if(!CursorTool.tool)
         {
            this.globalToolObject = null;
            return;
         }
         _loc2_ = SVGTool.staticGetEditableUnderMouse(this);
         if(_loc2_)
         {
            _loc3_ = _loc2_ as DisplayObject;
            if(CursorTool.tool == "grow" || CursorTool.tool == "shrink")
            {
               _loc4_ = _loc3_.getBounds(_loc3_);
               _loc5_ = _loc3_.parent.globalToLocal(_loc3_.localToGlobal(Point.interpolate(_loc4_.topLeft,_loc4_.bottomRight,0.5)));
               _loc6_ = _loc3_.transform.matrix.clone();
               if(CursorTool.tool == "grow")
               {
                  _loc6_.scale(1.05,1.05);
               }
               else
               {
                  _loc6_.scale(0.95,0.95);
               }
               _loc3_.transform.matrix = _loc6_;
               _loc4_ = _loc3_.getBounds(_loc3_);
               _loc7_ = _loc5_.subtract(_loc3_.parent.globalToLocal(_loc3_.localToGlobal(Point.interpolate(_loc4_.topLeft,_loc4_.bottomRight,0.5))));
               _loc3_.x += _loc7_.x;
               _loc3_.y += _loc7_.y;
               (_loc3_ as ISVGEditable).getElement();
               param1.stopImmediatePropagation();
               this.workArea.addEventListener(MouseEvent.MOUSE_MOVE,this.workAreaMouseMove,false,0,true);
               this.globalToolObject = _loc2_;
            }
            else if(CursorTool.tool == "cut")
            {
               this.app.clearTool();
               if(this.currentTool is SVGEditTool && (this.currentTool as SVGEditTool).getObject() == _loc2_)
               {
                  this.setToolMode("select",true);
               }
               _loc3_.parent.removeChild(_loc3_);
            }
            else if(CursorTool.tool == "copy")
            {
               this.app.clearTool();
               this.setToolMode("clone",true);
               this.getCanvasLayer().dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            }
            if(this.currentTool)
            {
               this.currentTool.refresh();
            }
            this.saveContent();
         }
         else
         {
            this.globalToolObject = null;
         }
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.w = param1;
         this.h = param2;
         var _loc3_:Graphics = this.svgEditorMask.graphics;
         _loc3_.clear();
         _loc3_.beginFill(15790080);
         _loc3_.drawRect(0,0,param1,param2 + 5);
         _loc3_.endFill();
         this.drawPropsUI.setWidthHeight(param1,106);
         this.drawPropsUI.x = 0;
         this.drawPropsUI.y = param2 - this.drawPropsUI.height;
         var _loc4_:uint = 44;
         var _loc5_:uint = 30;
         this.workArea.resize(param1 - _loc4_ - _loc5_,param2 - this.drawPropsUI.height - 12);
         this.workArea.x = _loc4_;
         this.refreshCurrentTool();
      }
      
      public function enableTools(param1:Boolean) : void
      {
         this.uiLayer.mouseChildren = param1;
         this.uiLayer.alpha = param1 ? 1 : 0.6;
         if(!param1)
         {
            this.setToolMode("select");
         }
      }
      
      public function isActive() : Boolean
      {
         if(!root)
         {
            return false;
         }
         if(CursorTool.tool)
         {
            return false;
         }
         return !this.app.mediaLibrary;
      }
      
      protected function stageKeyDownHandler(param1:KeyboardEvent) : Boolean
      {
         var _loc2_:SVGEditTool = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Selection = null;
         var _loc5_:ISVGEditable = null;
         if(!this.isActive())
         {
            return true;
         }
         if(Boolean(stage) && (stage.focus is TextField || stage.focus is SVGTextField && (stage.focus as SVGTextField).type == TextFieldType.INPUT))
         {
            return true;
         }
         if(param1.keyCode == 27)
         {
            this.setToolMode("select");
            return true;
         }
         if(this.toolMode != "select" && this.currentTool is SVGEditTool && (param1.keyCode == Keyboard.DELETE || param1.keyCode == Keyboard.BACKSPACE))
         {
            if(this is BitmapEdit)
            {
               return true;
            }
            _loc2_ = this.currentTool as SVGEditTool;
            _loc3_ = _loc2_.getObject() as DisplayObject;
            if(_loc3_)
            {
               _loc2_.setObject(null);
               _loc3_.parent.removeChild(_loc3_);
               this.saveContent();
            }
            return true;
         }
         if(param1.keyCode == 90 && param1.ctrlKey)
         {
            if(param1.shiftKey)
            {
               this.redo();
            }
            else
            {
               this.undo();
            }
         }
         else if(param1.keyCode == 67 && param1.ctrlKey)
         {
            _loc4_ = null;
            if(this.objectTransformer)
            {
               _loc4_ = this.objectTransformer.getSelection();
            }
            else if(this.currentTool is SVGEditTool)
            {
               _loc5_ = (this.currentTool as SVGEditTool).getObject();
               if(_loc5_)
               {
                  _loc4_ = new Selection([_loc5_]);
               }
            }
            if(_loc4_)
            {
               this.clipBoard = _loc4_.cloneObjs(this.workArea.getContentLayer());
               return true;
            }
         }
         else if(param1.keyCode == 86 && param1.ctrlKey && this.clipBoard is Array)
         {
            this.endCurrentTool();
            this.setToolMode("clone");
            (this.currentTool as CloneTool).pasteFromClipboard(this.clipBoard);
         }
         return false;
      }
      
      public function updateShapeUI(param1:ISVGEditable) : void
      {
         var _loc2_:SVGElement = null;
         var _loc3_:DrawProperties = null;
         var _loc4_:String = null;
         if(param1 is SVGShape)
         {
            _loc2_ = param1.getElement();
            _loc3_ = this.drawPropsUI.settings;
            _loc4_ = _loc2_.getAttribute("stroke");
            _loc3_.strokeWidth = _loc4_ == "none" ? 0 : int(parseFloat(_loc2_.getAttribute("stroke-width")));
            this.drawPropsUI.updateUI(_loc3_);
         }
      }
      
      protected function getToolDefs() : Array
      {
         return [];
      }
      
      protected function getImmediateToolList() : Array
      {
         return [];
      }
      
      private function createTools() : void
      {
         var _loc6_:IconButton = null;
         var _loc10_:String = null;
         var _loc11_:Boolean = false;
         var _loc12_:String = null;
         var _loc1_:int = this is BitmapEdit ? 4 : 2;
         var _loc2_:int = this is BitmapEdit ? 20 : 8;
         var _loc3_:Point = this is BitmapEdit ? new Point(37,33) : new Point(24,22);
         var _loc4_:Array = this.getToolDefs();
         var _loc5_:Array = this.getImmediateToolList();
         var _loc7_:Number = 0;
         var _loc8_:String = this is SVGEdit ? "left" : "right";
         var _loc9_:int = 0;
         while(_loc9_ < _loc4_.length)
         {
            if(_loc4_[_loc9_] == null)
            {
               _loc7_ += _loc2_;
            }
            else
            {
               _loc10_ = _loc4_[_loc9_].name;
               _loc11_ = Boolean(_loc5_) && _loc5_.indexOf(_loc10_) > -1;
               _loc12_ = _loc10_;
               if("bitmapBrush" == _loc10_)
               {
                  _loc12_ = "bitmapBrush";
               }
               if("bitmapEraser" == _loc10_)
               {
                  _loc12_ = "eraser";
               }
               if("bitmapSelect" == _loc10_)
               {
                  _loc12_ = "bitmapSelect";
               }
               if("ellipse" == _loc10_)
               {
                  _loc12_ = "bitmapEllipse";
               }
               if("paintbucket" == _loc10_)
               {
                  _loc12_ = "bitmapPaintbucket";
               }
               if("magicEraser" == _loc10_)
               {
                  _loc12_ = "magicEraser";
               }
               if("rect" == _loc10_)
               {
                  _loc12_ = "bitmapRect";
               }
               if("text" == _loc10_)
               {
                  _loc12_ = "bitmapText";
               }
               _loc6_ = new IconButton(_loc11_ ? this.handleImmediateTool : this.selectTool,makeToolButton(_loc12_,true,_loc3_),makeToolButton(_loc12_,false,_loc3_),!_loc11_);
               this.registerToolButton(_loc10_,_loc6_);
               _loc6_.isMomentary = _loc11_;
               this.toolButtonsLayer.addChild(_loc6_);
               _loc6_.y = _loc7_;
               if(_loc10_ != "group")
               {
                  _loc7_ += _loc6_.height + _loc1_;
               }
            }
            _loc9_++;
         }
         this.updateTranslation();
      }
      
      public function updateTranslation() : void
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         var _loc1_:String = this is SVGEdit ? "left" : "right";
         for each(_loc2_ in this.getToolDefs())
         {
            if(_loc2_)
            {
               _loc3_ = Translator.map(_loc2_.desc);
               if(_loc2_.shiftDesc)
               {
                  _loc3_ += " (" + Translator.map("Shift:") + " " + Translator.map(_loc2_.shiftDesc) + ")";
               }
               SimpleTooltips.add(this.toolButtons[_loc2_.name],{
                  "text":_loc3_,
                  "direction":_loc1_
               });
            }
         }
         if(this.drawPropsUI)
         {
            this.drawPropsUI.updateTranslation();
         }
      }
      
      private function addDrawPropsUI() : void
      {
         this.drawPropsUI = new DrawPropertyUI(this);
         this.drawPropsUI.x = 200;
         this.drawPropsUI.y = this.h - this.drawPropsUI.height - 40;
         this.drawPropsUI.addEventListener(DrawPropertyUI.ONCHANGE,this.onDrawPropsChange);
         this.drawPropsUI.addEventListener(DrawPropertyUI.ONFONTCHANGE,this.onFontChange);
         this.drawPropsUI.addEventListener(DrawPropertyUI.ONCOLORCHANGE,this.onColorChange);
         this.uiLayer.addChild(this.drawPropsUI);
      }
      
      public function registerToolButton(param1:String, param2:IconButton) : void
      {
         param2.name = param1;
         this.toolButtons[param1] = param2;
      }
      
      public function translateContents(param1:Number, param2:Number) : void
      {
      }
      
      public function handleImmediateTool(param1:IconButton) : void
      {
         var _loc5_:Rectangle = null;
         if(!param1)
         {
            return;
         }
         var _loc2_:Selection = null;
         if(this.currentTool)
         {
            if(this.toolMode == "select")
            {
               _loc2_ = this.objectTransformer.getSelection();
            }
            else if(this.currentTool is SVGEditTool && Boolean((this.currentTool as SVGEditTool).getObject()))
            {
               _loc2_ = new Selection([(this.currentTool as SVGEditTool).getObject()]);
            }
         }
         var _loc3_:Boolean = Boolean(param1.lastEvent) && param1.lastEvent.shiftKey;
         var _loc4_:Point = null;
         switch(param1.name)
         {
            case "zoomIn":
               _loc5_ = this.workArea.getVisibleLayer().getRect(stage);
               this.workArea.zoom(new Point(Math.round((_loc5_.right + _loc5_.left) / 2),Math.round((_loc5_.bottom + _loc5_.top) / 2)));
               if(_loc2_)
               {
                  _loc5_ = _loc2_.getBounds(stage);
                  this.workArea.centerAround(new Point(Math.round((_loc5_.right + _loc5_.left) / 2),Math.round((_loc5_.bottom + _loc5_.top) / 2)));
               }
               this.currentTool.refresh();
               if(this.toolButtons[this.toolMode])
               {
                  this.toolButtons[this.toolMode].turnOn();
               }
               break;
            case "zoomOut":
               this.workArea.zoomOut();
               this.currentTool.refresh();
               if(this.toolButtons[this.toolMode])
               {
                  this.toolButtons[this.toolMode].turnOn();
               }
               break;
            case "noZoom":
               this.workArea.zoom();
               this.currentTool.refresh();
               if(this.toolButtons[this.toolMode])
               {
                  this.toolButtons[this.toolMode].turnOn();
               }
               break;
            default:
               this.runImmediateTool(param1.name,_loc3_,_loc2_);
         }
         if(this.toolMode != "select" && Boolean(_loc2_))
         {
            _loc2_.shutdown();
         }
         param1.turnOff();
         if(param1.lastEvent)
         {
            param1.lastEvent.stopPropagation();
         }
      }
      
      protected function runImmediateTool(param1:String, param2:Boolean, param3:Selection) : void
      {
      }
      
      protected function onDrawPropsChange(param1:Event) : void
      {
         var _loc2_:Selection = null;
         var _loc3_:ISVGEditable = null;
         if(this.toolMode == "select")
         {
            _loc2_ = this.objectTransformer.getSelection();
            if(_loc2_)
            {
               _loc2_.setShapeProperties(this.drawPropsUI.settings);
               this.currentTool.refresh();
               this.saveContent();
            }
            return;
         }
         if(this.toolMode == "eraser" && this.currentTool is EraserTool)
         {
            (this.currentTool as EraserTool).updateIcon();
         }
         if(this.objectTransformer)
         {
            _loc2_ = this.objectTransformer.getSelection();
            if(_loc2_)
            {
               _loc2_.setShapeProperties(this.drawPropsUI.settings);
            }
         }
         if(this.currentTool is TextTool)
         {
            _loc3_ = (this.currentTool as TextTool).getObject();
            if(_loc3_)
            {
               _loc3_.getElement().applyShapeProps(this.drawPropsUI.settings);
               _loc3_.redraw();
            }
         }
      }
      
      private function onFontChange(param1:Event) : void
      {
         var _loc2_:Selection = null;
         var _loc3_:ISVGEditable = null;
         var _loc4_:String = this.drawPropsUI.settings.fontName;
         if(this.toolMode == "select")
         {
            _loc2_ = this.objectTransformer.getSelection();
            if(_loc2_)
            {
               for each(_loc3_ in _loc2_.getObjs())
               {
                  if(_loc3_ is SVGTextField)
                  {
                     _loc3_.getElement().setFont(_loc4_);
                  }
                  _loc3_.redraw();
               }
            }
         }
         else if(this.currentTool is TextTool)
         {
            _loc3_ = (this.currentTool as TextTool).getObject();
            if(_loc3_)
            {
               _loc3_.getElement().setFont(_loc4_);
               _loc3_.redraw();
            }
         }
         this.currentTool.refresh();
         this.saveContent();
      }
      
      private function onColorChange(param1:Event) : void
      {
         if(selectionTools.indexOf(this.toolMode) != -1 && repeatedTools.indexOf(this.lastToolMode) != -1)
         {
            this.setToolMode(this.lastToolMode);
         }
      }
      
      protected function fromHex(param1:String) : uint
      {
         if(!param1)
         {
            return 0;
         }
         return uint("0x" + param1.substr(1));
      }
      
      private function selectTool(param1:IconButton) : void
      {
         var _loc2_:String = param1 ? param1.name : "select";
         this.setToolMode(_loc2_,false,true);
         if(Boolean(param1) && Boolean(param1.lastEvent))
         {
            param1.lastEvent.stopPropagation();
         }
      }
      
      public function setToolMode(param1:String, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc6_:IconButton = null;
         if(!param3 && selectionTools.indexOf(param1) != -1 && repeatedTools.indexOf(this.toolMode) != -1)
         {
            this.lastToolMode = this.toolMode;
         }
         else
         {
            if(this.lastToolMode)
            {
               this.highlightTool(param1);
            }
            this.lastToolMode = "";
         }
         if(param1 == this.toolMode && !param2)
         {
            return;
         }
         var _loc4_:Boolean = true;
         var _loc5_:Selection = null;
         if(this.currentTool)
         {
            if(this.toolMode == "select" && param1 != "select")
            {
               _loc5_ = this.objectTransformer.getSelection();
            }
            if(_loc4_)
            {
               if(this.currentTool.parent)
               {
                  this.toolsLayer.removeChild(this.currentTool);
               }
               if(this.currentTool is SVGEditTool)
               {
                  this.currentTool.removeEventListener("select",this.selectHandler);
               }
               this.currentTool.removeEventListener(Event.CHANGE,this.saveContent);
               this.currentTool = null;
               _loc6_ = this.toolButtons[this.toolMode];
               if(_loc6_)
               {
                  _loc6_.turnOff();
               }
               _loc4_ = true;
            }
         }
         switch(param1)
         {
            case "select":
               this.currentTool = new ObjectTransformer(this);
               break;
            case "pathedit":
               this.currentTool = new PathEditTool(this);
               break;
            case "path":
               this.currentTool = new PathTool(this);
               break;
            case "vectorLine":
            case "line":
               this.currentTool = new PathTool(this,true);
               break;
            case "vectorEllipse":
            case "ellipse":
               this.currentTool = new EllipseTool(this);
               break;
            case "vectorRect":
            case "rect":
               this.currentTool = new RectangleTool(this);
               break;
            case "text":
               this.currentTool = new TextTool(this);
               break;
            case "eraser":
               this.currentTool = new EraserTool(this);
               break;
            case "clone":
               this.currentTool = new CloneTool(this);
               break;
            case "eyedropper":
               this.currentTool = new EyeDropperTool(this);
               break;
            case "vpaintbrush":
               this.currentTool = new PaintBrushTool(this);
               break;
            case "setCenter":
               this.currentTool = new SetCenterTool(this);
               break;
            case "bitmapBrush":
               this.currentTool = new BitmapPencilTool(this,false);
               break;
            case "bitmapEraser":
               this.currentTool = new BitmapPencilTool(this,true);
               break;
            case "bitmapSelect":
               this.currentTool = new ObjectTransformer(this);
               break;
            case "paintbucket":
               this.currentTool = new PaintBucketTool(this);
               break;
            case "magicEraser":
               this.currentTool = new BitmapBackgroundTool(this);
         }
         if(this.currentTool is SVGEditTool)
         {
            this.currentTool.addEventListener("select",this.selectHandler,false,0,true);
            if(Boolean(this.objectTransformer) && Boolean(_loc5_))
            {
               this.objectTransformer.select(_loc5_);
            }
         }
         this.updateDrawPropsForTool(param1);
         if(_loc4_)
         {
            if(this.currentTool)
            {
               this.toolsLayer.addChild(this.currentTool);
               _loc6_ = this.toolButtons[param1];
               if(_loc6_)
               {
                  _loc6_.turnOn();
               }
            }
            this.workArea.toggleContentInteraction(this.currentTool.interactsWithContent());
            this.toolMode = param1;
            if(this.currentTool is PathEditTool || this.currentTool is TextTool)
            {
               (this.currentTool as SVGEditTool).editSelection(_loc5_);
            }
            this.currentTool.addEventListener(Event.CHANGE,this.saveContent,false,0,true);
         }
         if(this.lastToolMode != "")
         {
            this.highlightTool(this.lastToolMode);
         }
         if(this.toolButtons.hasOwnProperty(param1) && Boolean(this.currentTool))
         {
            (this.toolButtons[param1] as IconButton).setDisabled(false);
         }
         this.imagesPart.refreshUndoButtons();
      }
      
      protected function updateDrawPropsForTool(param1:String) : void
      {
         var _loc5_:Number = NaN;
         var _loc6_:DrawProperties = null;
         if(param1 == "rect" || param1 == "vectorRect" || param1 == "ellipse" || param1 == "vectorEllipse")
         {
            this.drawPropsUI.toggleShapeUI(true,param1 == "ellipse" || param1 == "vectorEllipse");
         }
         else
         {
            this.drawPropsUI.toggleShapeUI(false);
         }
         this.drawPropsUI.toggleFillUI(param1 == "vpaintbrush" || param1 == "paintbucket");
         if(!(this is SVGEdit))
         {
            this.drawPropsUI.toggleSegmentationUI(param1 == "magicEraser",this.currentTool as BitmapBackgroundTool);
         }
         this.drawPropsUI.showSmoothnessUI(param1 == "path");
         if(param1 == "path")
         {
            _loc5_ = this.drawPropsUI.settings.strokeWidth;
            if(isNaN(_loc5_) || _loc5_ < 0.25)
            {
               _loc6_ = this.drawPropsUI.settings;
               _loc6_.strokeWidth = 2;
               this.drawPropsUI.settings = _loc6_;
            }
         }
         this.drawPropsUI.showFontUI("text" == param1);
         var _loc2_:Array = ["bitmapBrush","line","rect","ellipse","select","pathedit","path","vectorLine","vectorRect","vectorEllipse"];
         var _loc3_:Array = ["bitmapEraser","eraser"];
         this.drawPropsUI.showStrokeUI(_loc2_.indexOf(param1) > -1,_loc3_.indexOf(param1) > -1);
         var _loc4_:Array = ["text","vpaintbrush","paintbucket","bitmapSelect","eyedropper","bitmapBrush","line","rect","ellipse","select","path","vectorLine","vectorRect","vectorEllipse"];
         this.drawPropsUI.showColorUI(_loc4_.indexOf(param1) > -1);
      }
      
      public function setCurrentColor(param1:uint, param2:Number) : void
      {
         this.drawPropsUI.setCurrentColor(param1,param2);
      }
      
      public function endCurrentTool(param1:* = null) : void
      {
         var _loc3_:Selection = null;
         if(this is SVGEdit)
         {
            this.setToolMode("select");
         }
         var _loc2_:DisplayObject = param1 as DisplayObject;
         if(Boolean(param1) && (Boolean(_loc2_ && _loc2_.parent && _loc2_.width > 0 && _loc2_.height > 0) || Boolean(param1 is Selection)))
         {
            if(!(this is SVGEdit))
            {
               this.setToolMode("bitmapSelect");
            }
            _loc3_ = param1 is Selection ? param1 : new Selection([param1]);
            this.objectTransformer.select(_loc3_);
         }
         else if(this is SVGEdit && repeatedTools.indexOf(this.lastToolMode) > -1)
         {
            this.setToolMode(this.lastToolMode);
         }
         this.saveContent();
      }
      
      public function revertToCreateTool(param1:MouseEvent) : Boolean
      {
         if(selectionTools.indexOf(this.toolMode) != -1 && repeatedTools.indexOf(this.lastToolMode) != -1)
         {
            this.setToolMode(this.lastToolMode);
            if(this.currentTool is SVGCreateTool)
            {
               (this.currentTool as SVGCreateTool).eventHandler(param1);
            }
            else if(this.currentTool is SVGEditTool)
            {
               (this.currentTool as SVGEditTool).setObject(null);
               (this.currentTool as SVGEditTool).mouseDown(param1);
            }
            return true;
         }
         return false;
      }
      
      protected function highlightTool(param1:String) : void
      {
         var _loc2_:IconButton = null;
         if(!param1 || param1 == "")
         {
            return;
         }
         for each(_loc2_ in this.toolButtons)
         {
            _loc2_.turnOff();
         }
         if(this.toolButtons[param1])
         {
            this.toolButtons[param1].turnOn();
         }
      }
      
      public function editCostume(param1:ScratchCostume, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc4_:Rectangle = null;
         if(this.targetCostume == param1 && !param3)
         {
            return;
         }
         this.targetCostume = param1;
         this.isScene = param2;
         if(this.toolButtons["setCenter"])
         {
            (this.toolButtons["setCenter"] as IconButton).setDisabled(this.isScene);
         }
         this.loadCostume(this.targetCostume);
         if(this.segmentationTool)
         {
            this.segmentationTool.initState();
         }
         if(this.imagesPart)
         {
            this.imagesPart.refreshUndoButtons();
         }
         if(this.currentTool is SVGEditTool)
         {
            (this.currentTool as SVGEditTool).setObject(null);
         }
         else
         {
            this.currentTool.refresh();
         }
         this.workArea.zoom();
         if(!this.isScene)
         {
            _loc4_ = this.workArea.getVisibleLayer().getRect(stage);
            this.workArea.zoom(new Point(Math.round((_loc4_.right + _loc4_.left) / 2),Math.round((_loc4_.bottom + _loc4_.top) / 2)));
         }
      }
      
      protected function loadCostume(param1:ScratchCostume) : void
      {
      }
      
      public function addCostume(param1:ScratchCostume, param2:Point) : void
      {
      }
      
      public function saveContent(param1:Event = null, param2:Boolean = true) : void
      {
      }
      
      public function shutdown() : void
      {
         this.setToolMode(this.toolMode,true);
      }
      
      public function getZoomAndScroll() : Array
      {
         return this.workArea.getZoomAndScroll();
      }
      
      public function setZoomAndScroll(param1:Array) : void
      {
         return this.workArea.setZoomAndScroll(param1);
      }
      
      public function updateZoomReadout() : void
      {
         if(this.drawPropsUI)
         {
            this.drawPropsUI.updateZoomReadout();
         }
      }
      
      public function stamp() : void
      {
      }
      
      public function flipContent(param1:Boolean) : void
      {
         var _loc2_:Selection = null;
         if(this.objectTransformer)
         {
            _loc2_ = this.objectTransformer.getSelection();
         }
         if(_loc2_)
         {
            _loc2_.flip(param1);
            this.currentTool.refresh();
            this.currentTool.dispatchEvent(new Event(Event.CHANGE));
         }
         else
         {
            this.flipAll(param1);
         }
      }
      
      protected function flipAll(param1:Boolean) : void
      {
      }
      
      public function canClearCanvas() : Boolean
      {
         return false;
      }
      
      public function clearCanvas(param1:* = null) : void
      {
         if(this.currentTool is SVGEditTool)
         {
            (this.currentTool as SVGEditTool).setObject(null);
         }
         else
         {
            this.currentTool.refresh();
         }
         this.saveContent();
      }
      
      public function canUndo() : Boolean
      {
         return Boolean(this.targetCostume) && this.targetCostume.undoList.length > 0 && this.targetCostume.undoListIndex > 0;
      }
      
      public function canRedo() : Boolean
      {
         return this.targetCostume && this.targetCostume.undoList.length > 0 && this.targetCostume.undoListIndex < this.targetCostume.undoList.length - 1 && !this.targetCostume.segmentationState.lastMask;
      }
      
      public function canUndoSegmentation() : Boolean
      {
         return Boolean(this.segmentationTool) && this.targetCostume.segmentationState.canUndo();
      }
      
      public function canRedoSegmentation() : Boolean
      {
         return Boolean(this.segmentationTool) && this.targetCostume.segmentationState.canRedo() && !this.canRedo();
      }
      
      public function undo(param1:* = null) : void
      {
         var _loc2_:Array = null;
         if(this.canUndoSegmentation())
         {
            this.undoSegmentation();
            return;
         }
         this.clearSelection();
         if(this.canUndo())
         {
            _loc2_ = this.targetCostume.undoList[--this.targetCostume.undoListIndex];
            this.installUndoRecord(_loc2_);
         }
      }
      
      public function redo(param1:* = null) : void
      {
         var _loc2_:Array = null;
         if(this.canRedoSegmentation())
         {
            this.redoSegmentation();
            return;
         }
         this.clearSelection();
         if(this.canRedo())
         {
            _loc2_ = this.targetCostume.undoList[++this.targetCostume.undoListIndex];
            this.installUndoRecord(_loc2_);
         }
      }
      
      protected function clearSelection() : void
      {
      }
      
      final protected function recordForUndo(param1:*, param2:int, param3:int) : void
      {
         if(!this.targetCostume)
         {
            return;
         }
         if(this.targetCostume.undoListIndex < this.targetCostume.undoList.length)
         {
            this.targetCostume.undoList = this.targetCostume.undoList.slice(0,this.targetCostume.undoListIndex + 1);
         }
         this.targetCostume.undoListIndex = this.targetCostume.undoList.length;
         this.targetCostume.undoList.push([param1,param2,param3]);
         this.imagesPart.refreshUndoButtons();
      }
      
      private function installUndoRecord(param1:Array) : void
      {
         var _loc2_:* = param1[0];
         this.imagesPart.useBitmapEditor(_loc2_ is BitmapData);
         if(this.imagesPart.editor != this)
         {
            this.imagesPart.editor.targetCostume = this.targetCostume;
            this.imagesPart.editor.isScene = this.isScene;
         }
         this.targetCostume.rotationCenterX = param1[1];
         this.targetCostume.rotationCenterY = param1[2];
         if(_loc2_ is ByteArray)
         {
            this.targetCostume.setSVGData(_loc2_,false);
         }
         if(_loc2_ is BitmapData)
         {
            this.targetCostume.setBitmapData(_loc2_,param1[1],param1[2]);
         }
         this.imagesPart.editor.restoreUndoState(param1);
         this.imagesPart.refreshUndoButtons();
      }
      
      protected function restoreUndoState(param1:Array) : void
      {
      }
      
      private function workAreaMouseMove(param1:MouseEvent) : void
      {
         var _loc2_:ISVGEditable = null;
         if(CursorTool.tool)
         {
            _loc2_ = SVGTool.staticGetEditableUnderMouse(this);
            if(Boolean(_loc2_) && _loc2_ == this.globalToolObject)
            {
               return;
            }
         }
         this.globalToolObject = null;
         this.workArea.removeEventListener(MouseEvent.MOUSE_MOVE,this.workAreaMouseMove);
         this.app.clearTool();
      }
      
      public function setCurrentCursor(param1:String, param2:* = null, param3:Point = null, param4:Boolean = true) : void
      {
         if(param1 == null || [MouseCursor.HAND,MouseCursor.BUTTON].indexOf(param1) > -1)
         {
            this.currentCursor = param1 == null ? MouseCursor.AUTO : param1;
            CursorTool.setCustomCursor(this.currentCursor);
         }
         else
         {
            if(param2 is String)
            {
               param2 = Resources.createBmp(param1).bitmapData;
            }
            CursorTool.setCustomCursor(param1,param2,param3,param4);
            this.currentCursor = param1;
         }
         if(Boolean(stage) && Boolean(this.workArea.getInteractionLayer().hitTestPoint(stage.mouseX,stage.mouseY,true)) && !this.uiLayer.hitTestPoint(stage.mouseX,stage.mouseY,true))
         {
            CursorTool.setCustomCursor(this.currentCursor);
         }
         else
         {
            CursorTool.setCustomCursor(MouseCursor.AUTO);
         }
      }
      
      public function snapToGrid(param1:Point) : Point
      {
         return param1;
      }
      
      public function undoSegmentation() : void
      {
         if(this.segmentationTool)
         {
            this.targetCostume.prevSegmentationState();
            if(this.targetCostume.segmentationState.lastMask)
            {
               this.segmentationTool.refreshSegmentation();
            }
            else
            {
               this.segmentationTool.restoreUnmarkedBitmap();
            }
            this.imagesPart.refreshUndoButtons();
         }
      }
      
      public function redoSegmentation() : void
      {
         if(this.segmentationTool)
         {
            this.targetCostume.nextSegmentationState();
            if(this.targetCostume.segmentationState.lastMask)
            {
               this.segmentationTool.refreshSegmentation();
            }
            else
            {
               this.segmentationTool.commitMask(false);
            }
            this.imagesPart.refreshUndoButtons();
         }
      }
   }
}

