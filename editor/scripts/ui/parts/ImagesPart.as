package ui.parts
{
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.geom.*;
   import flash.text.*;
   import flash.utils.setTimeout;
   import scratch.*;
   import svgeditor.*;
   import svgutils.*;
   import translation.Translator;
   import ui.media.*;
   import uiwidgets.*;
   
   public class ImagesPart extends UIPart
   {
      
      public var editor:ImageEdit;
      
      private const columnWidth:int = 106;
      
      private const contentsX:int = 119;
      
      private const topButtonSize:Point = new Point(24,22);
      
      private const smallSpace:int = 3;
      
      private var bigSpace:int;
      
      private var shape:Shape;
      
      private var listFrame:ScrollFrame;
      
      private var nameField:EditableLabel;
      
      private var undoButton:IconButton;
      
      private var redoButton:IconButton;
      
      private var clearButton:Button;
      
      private var libraryButton:Button;
      
      private var editorImportButton:Button;
      
      private var cropButton:IconButton;
      
      private var flipHButton:IconButton;
      
      private var flipVButton:IconButton;
      
      private var centerButton:IconButton;
      
      private var newCostumeLabel:TextField;
      
      private var backdropLibraryButton:IconButton;
      
      private var costumeLibraryButton:IconButton;
      
      private var paintButton:IconButton;
      
      private var importButton:IconButton;
      
      private var cameraButton:IconButton;
      
      public function ImagesPart(param1:Scratch)
      {
         super();
         this.app = param1;
         addChild(this.shape = new Shape());
         addChild(this.newCostumeLabel = makeLabel("",new TextFormat(CSS.font,12,CSS.textColor,true)));
         this.addNewCostumeButtons();
         this.addListFrame();
         addChild(this.nameField = new EditableLabel(this.nameChanged));
         this.addEditor(true);
         this.addUndoButtons();
         this.addFlipButtons();
         this.addCenterButton();
         this.updateTranslation();
      }
      
      public static function strings() : Array
      {
         return ["Clear","Add","Import","New backdrop:","New costume:","photo1","Undo","Redo","Flip left-right","Flip up-down","Set costume center","Choose backdrop from library","Choose costume from library","Paint new backdrop","Upload backdrop from file","New backdrop from camera","Paint new costume","Upload costume from file","New costume from camera"];
      }
      
      protected function addEditor(param1:Boolean) : void
      {
         if(param1)
         {
            addChild(this.editor = new SVGEdit(app,this));
         }
         else
         {
            addChild(this.editor = new BitmapEdit(app,this));
         }
      }
      
      public function updateTranslation() : void
      {
         this.clearButton.setLabel(Translator.map("Clear"));
         this.libraryButton.setLabel(Translator.map("Add"));
         this.editorImportButton.setLabel(Translator.map("Import"));
         if(this.editor)
         {
            this.editor.updateTranslation();
         }
         this.updateLabel();
         this.fixlayout();
      }
      
      public function refresh(param1:Boolean = false) : void
      {
         this.updateLabel();
         this.backdropLibraryButton.visible = this.isStage();
         this.costumeLibraryButton.visible = !this.isStage();
         (this.listFrame.contents as MediaPane).refresh();
         if(!param1)
         {
            this.selectCostume();
         }
      }
      
      private function updateLabel() : void
      {
         this.newCostumeLabel.text = Translator.map(this.isStage() ? "New backdrop:" : "New costume:");
         SimpleTooltips.add(this.backdropLibraryButton,{
            "text":"Choose backdrop from library",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.costumeLibraryButton,{
            "text":"Choose costume from library",
            "direction":"bottom"
         });
         if(this.isStage())
         {
            SimpleTooltips.add(this.paintButton,{
               "text":"Paint new backdrop",
               "direction":"bottom"
            });
            SimpleTooltips.add(this.importButton,{
               "text":"Upload backdrop from file",
               "direction":"bottom"
            });
            SimpleTooltips.add(this.cameraButton,{
               "text":"New backdrop from camera",
               "direction":"bottom"
            });
         }
         else
         {
            SimpleTooltips.add(this.paintButton,{
               "text":"Paint new costume",
               "direction":"bottom"
            });
            SimpleTooltips.add(this.importButton,{
               "text":"Upload costume from file",
               "direction":"bottom"
            });
            SimpleTooltips.add(this.cameraButton,{
               "text":"New costume from camera",
               "direction":"bottom"
            });
         }
      }
      
      private function isStage() : Boolean
      {
         return Boolean(app.viewedObj()) && app.viewedObj().isStage;
      }
      
      public function step() : void
      {
         (this.listFrame.contents as MediaPane).updateSelection();
         this.listFrame.updateScrollbars();
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.w = param1;
         this.h = param2;
         var _loc3_:Graphics = this.shape.graphics;
         _loc3_.clear();
         _loc3_.lineStyle(0.5,CSS.borderColor,1,true);
         _loc3_.beginFill(CSS.tabColor);
         _loc3_.drawRect(0,0,param1,param2);
         _loc3_.endFill();
         _loc3_.lineStyle(0.5,CSS.borderColor,1,true);
         _loc3_.beginFill(CSS.panelColor);
         _loc3_.drawRect(this.columnWidth + 1,5,param1 - this.columnWidth - 6,param2 - 10);
         _loc3_.endFill();
         this.fixlayout();
      }
      
      private function fixlayout() : void
      {
         var _loc1_:int = Math.max(0,(w - 590) / 3);
         this.bigSpace = this.smallSpace + _loc1_;
         this.newCostumeLabel.x = 7;
         this.newCostumeLabel.y = 7;
         this.listFrame.x = 1;
         this.listFrame.y = 58;
         this.listFrame.setWidthHeight(this.columnWidth,h - this.listFrame.y);
         var _loc2_:int = w - this.contentsX - 15;
         this.nameField.setWidth(Math.min(135,_loc2_));
         this.nameField.x = this.contentsX;
         this.nameField.y = 15;
         this.undoButton.x = this.nameField.x + this.nameField.width + this.bigSpace;
         this.redoButton.x = this.undoButton.right() + this.smallSpace;
         this.clearButton.x = this.redoButton.right() + this.bigSpace;
         this.clearButton.y = this.nameField.y;
         this.undoButton.y = this.redoButton.y = this.nameField.y - 2;
         this.fixEditorLayout();
         if(parent)
         {
            this.refresh();
         }
      }
      
      public function selectCostume() : void
      {
         var _loc1_:MediaPane = this.listFrame.contents as MediaPane;
         var _loc2_:Boolean = _loc1_.updateSelection();
         var _loc3_:ScratchObj = app.viewedObj();
         if(_loc3_ == null)
         {
            return;
         }
         this.nameField.setContents(_loc3_.currentCostume().costumeName);
         var _loc4_:Array = this.editor.getZoomAndScroll();
         this.editor.shutdown();
         var _loc5_:ScratchCostume = _loc3_.currentCostume();
         this.useBitmapEditor(_loc5_.isBitmap() && !_loc5_.text);
         this.editor.editCostume(_loc5_,_loc3_.isStage);
         this.editor.setZoomAndScroll(_loc4_);
         if(_loc2_)
         {
            app.setSaveNeeded();
         }
      }
      
      private function addListFrame() : void
      {
         this.listFrame = new ScrollFrame();
         this.listFrame.setContents(app.getMediaPane(app,"costumes"));
         this.listFrame.contents.color = CSS.tabColor;
         this.listFrame.allowHorizontalScrollbar = false;
         addChild(this.listFrame);
      }
      
      private function nameChanged() : void
      {
         app.runtime.renameCostume(this.nameField.contents());
         this.nameField.setContents(app.viewedObj().currentCostume().costumeName);
         (this.listFrame.contents as MediaPane).refresh();
      }
      
      private function addNewCostumeButtons() : void
      {
         var _loc1_:int = 8;
         var _loc2_:int = 32;
         addChild(this.backdropLibraryButton = this.makeButton(this.costumeFromLibrary,"landscape",_loc1_,_loc2_ + 1));
         addChild(this.costumeLibraryButton = this.makeButton(this.costumeFromLibrary,"library",_loc1_ + 1,_loc2_ - 2));
         addChild(this.paintButton = this.makeButton(this.paintCostume,"paintbrush",_loc1_ + 23,_loc2_ - 1));
         addChild(this.importButton = this.makeButton(this.costumeFromComputer,"import",_loc1_ + 44,_loc2_ - 2));
         addChild(this.cameraButton = this.makeButton(this.costumeFromCamera,"camera",_loc1_ + 72,_loc2_));
      }
      
      public function useBitmapEditor(param1:Boolean) : void
      {
         var _loc2_:DrawProperties = null;
         var _loc3_:Array = null;
         if(this.editor)
         {
            _loc2_ = this.editor.getShapeProps();
            _loc3_ = this.editor.getWorkArea().getZoomAndScroll();
         }
         if(param1)
         {
            if(this.editor is BitmapEdit)
            {
               return;
            }
            if(Boolean(this.editor) && Boolean(this.editor.parent))
            {
               removeChild(this.editor);
            }
            this.addEditor(false);
         }
         else
         {
            if(this.editor is SVGEdit)
            {
               return;
            }
            if(Boolean(this.editor) && Boolean(this.editor.parent))
            {
               removeChild(this.editor);
            }
            this.addEditor(true);
         }
         if(_loc2_)
         {
            this.editor.setShapeProps(_loc2_);
            this.editor.getWorkArea().setZoomAndScroll([_loc3_[0],0.5,0.5]);
         }
         this.editor.registerToolButton("setCenter",this.centerButton);
         this.fixEditorLayout();
      }
      
      private function fixEditorLayout() : void
      {
         var _loc1_:int = 0;
         _loc1_ = w - this.contentsX - 15;
         if(this.editor)
         {
            this.editor.x = this.contentsX;
            this.editor.y = 45;
            this.editor.setWidthHeight(_loc1_,h - this.editor.y - 14);
         }
         _loc1_ = w - 16;
         this.libraryButton.x = this.clearButton.x + this.clearButton.width + this.smallSpace;
         this.libraryButton.y = this.clearButton.y;
         this.editorImportButton.x = this.libraryButton.x + this.libraryButton.width + this.smallSpace;
         this.editorImportButton.y = this.clearButton.y;
         this.centerButton.x = _loc1_ - this.centerButton.width;
         this.flipVButton.x = this.centerButton.x - this.flipVButton.width - this.smallSpace;
         this.flipHButton.x = this.flipVButton.x - this.flipHButton.width - this.smallSpace;
         this.cropButton.x = this.flipHButton.x - this.cropButton.width - this.smallSpace;
         this.cropButton.y = this.flipHButton.y = this.flipVButton.y = this.centerButton.y = this.nameField.y - 1;
      }
      
      private function makeButton(param1:Function, param2:String, param3:int, param4:int) : IconButton
      {
         var _loc5_:IconButton = new IconButton(param1,param2);
         _loc5_.isMomentary = true;
         _loc5_.x = param3;
         _loc5_.y = param4;
         return _loc5_;
      }
      
      private function makeTopButton(param1:Function, param2:String, param3:Boolean = false) : IconButton
      {
         return new IconButton(param1,SoundsPart.makeButtonImg(param2,true,this.topButtonSize),SoundsPart.makeButtonImg(param2,false,this.topButtonSize),param3);
      }
      
      public function convertToBitmap() : void
      {
         var finishConverting:Function = null;
         finishConverting = function():void
         {
            var _loc1_:ScratchCostume = editor.targetCostume;
            var _loc2_:Boolean = editor.isScene;
            var _loc3_:Array = editor.getZoomAndScroll();
            useBitmapEditor(true);
            var _loc4_:BitmapData = _loc1_.bitmapForEditor(_loc2_);
            _loc1_.setBitmapData(_loc4_,2 * _loc1_.rotationCenterX,2 * _loc1_.rotationCenterY);
            editor.editCostume(_loc1_,_loc2_,true);
            editor.setZoomAndScroll(_loc3_);
            editor.saveContent();
         };
         if(this.editor is BitmapEdit)
         {
            return;
         }
         this.editor.shutdown();
         setTimeout(finishConverting,300);
      }
      
      public function convertToVector() : void
      {
         if(this.editor is SVGEdit)
         {
            return;
         }
         this.editor.shutdown();
         this.editor.setToolMode("select",true);
         var _loc1_:ScratchCostume = this.editor.targetCostume;
         var _loc2_:Boolean = this.editor.isScene;
         var _loc3_:Array = this.editor.getZoomAndScroll();
         this.useBitmapEditor(false);
         var _loc4_:SVGElement = new SVGElement("svg");
         var _loc5_:Rectangle = _loc1_.baseLayerBitmap.getColorBoundsRect(4278190080,0,false);
         if(_loc5_.width != 0 && _loc5_.height != 0)
         {
            _loc4_.subElements.push(SVGElement.makeBitmapEl(_loc1_.baseLayerBitmap,1 / _loc1_.bitmapResolution));
         }
         _loc1_.rotationCenterX /= _loc1_.bitmapResolution;
         _loc1_.rotationCenterY /= _loc1_.bitmapResolution;
         _loc1_.setSVGData(new SVGExport(_loc4_).svgData(),false,false);
         this.editor.editCostume(_loc1_,_loc2_,true);
         this.editor.setZoomAndScroll(_loc3_);
      }
      
      private function addUndoButtons() : void
      {
         addChild(this.undoButton = this.makeTopButton(this.undo,"undo"));
         addChild(this.redoButton = this.makeTopButton(this.redo,"redo"));
         addChild(this.clearButton = new Button(Translator.map("Clear"),this.clear,true));
         addChild(this.libraryButton = new Button(Translator.map("Add"),this.importFromLibrary,true));
         addChild(this.editorImportButton = new Button(Translator.map("Import"),this.importIntoEditor,true));
         this.undoButton.isMomentary = true;
         this.redoButton.isMomentary = true;
         SimpleTooltips.add(this.undoButton,{
            "text":"Undo",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.redoButton,{
            "text":"Redo",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.clearButton,{
            "text":"Erase all",
            "direction":"bottom"
         });
      }
      
      private function undo(param1:*) : void
      {
         this.editor.undo(param1);
      }
      
      private function redo(param1:*) : void
      {
         this.editor.redo(param1);
      }
      
      private function clear() : void
      {
         this.editor.clearCanvas();
      }
      
      private function importFromLibrary() : void
      {
         var _loc1_:String = this.isStage() ? "backdrop" : "costume";
         var _loc2_:MediaLibrary = app.getMediaLibrary(_loc1_,this.addCostume);
         _loc2_.open();
      }
      
      private function importIntoEditor() : void
      {
         var _loc1_:MediaLibrary = app.getMediaLibrary("",this.addCostume);
         _loc1_.importFromDisk();
      }
      
      private function addCostume(param1:*) : void
      {
         var _loc2_:ScratchCostume = param1 as ScratchCostume;
         if(!_loc2_ && param1 is Array)
         {
            _loc2_ = param1[0] as ScratchCostume;
         }
         var _loc3_:Point = new Point(240,180);
         this.editor.addCostume(_loc2_,_loc3_);
      }
      
      public function refreshUndoButtons() : void
      {
         if(this.undoButton)
         {
            this.undoButton.setDisabled(!(this.editor.canUndo() || this.editor.canUndoSegmentation()),0.5);
         }
         if(this.redoButton)
         {
            this.redoButton.setDisabled(!(this.editor.canRedo() || this.editor.canRedoSegmentation()),0.5);
         }
         if(this.clearButton)
         {
            if(this.editor.canClearCanvas())
            {
               this.clearButton.alpha = 1;
               this.clearButton.mouseEnabled = true;
            }
            else
            {
               this.clearButton.alpha = 0.5;
               this.clearButton.mouseEnabled = false;
            }
         }
      }
      
      public function setCanCrop(param1:Boolean) : void
      {
         if(param1)
         {
            this.cropButton.alpha = 1;
            this.cropButton.mouseEnabled = true;
         }
         else
         {
            this.cropButton.alpha = 0.5;
            this.cropButton.mouseEnabled = false;
         }
      }
      
      private function addFlipButtons() : void
      {
         addChild(this.cropButton = this.makeTopButton(this.crop,"crop"));
         addChild(this.flipHButton = this.makeTopButton(this.flipH,"flipH"));
         addChild(this.flipVButton = this.makeTopButton(this.flipV,"flipV"));
         this.cropButton.isMomentary = true;
         this.flipHButton.isMomentary = true;
         this.flipVButton.isMomentary = true;
         SimpleTooltips.add(this.cropButton,{
            "text":"Crop to selection",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.flipHButton,{
            "text":"Flip left-right",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.flipVButton,{
            "text":"Flip up-down",
            "direction":"bottom"
         });
         this.setCanCrop(false);
      }
      
      private function crop(param1:*) : void
      {
         var _loc2_:BitmapEdit = this.editor as BitmapEdit;
         if(_loc2_)
         {
            _loc2_.cropToSelection();
         }
      }
      
      private function flipH(param1:*) : void
      {
         this.editor.flipContent(false);
      }
      
      private function flipV(param1:*) : void
      {
         this.editor.flipContent(true);
      }
      
      private function addCenterButton() : void
      {
         var setCostumeCenter:Function = null;
         setCostumeCenter = function(param1:IconButton):void
         {
            editor.setToolMode("setCenter");
            param1.lastEvent.stopPropagation();
         };
         this.centerButton = this.makeTopButton(setCostumeCenter,"setCenter",true);
         SimpleTooltips.add(this.centerButton,{
            "text":"Set costume center",
            "direction":"bottom"
         });
         this.editor.registerToolButton("setCenter",this.centerButton);
         addChild(this.centerButton);
      }
      
      private function costumeFromComputer(param1:* = null) : void
      {
         this.importCostume(true);
      }
      
      private function costumeFromLibrary(param1:* = null) : void
      {
         this.importCostume(false);
      }
      
      private function importCostume(param1:Boolean) : void
      {
         var addCostume:Function = null;
         var fromComputer:Boolean = param1;
         addCostume = function(param1:*):void
         {
            var _loc2_:ScratchCostume = param1 as ScratchCostume;
            if(_loc2_)
            {
               addAndSelectCostume(_loc2_);
               return;
            }
            var _loc3_:ScratchSprite = param1 as ScratchSprite;
            if(_loc3_)
            {
               for each(_loc2_ in _loc3_.costumes)
               {
                  addAndSelectCostume(_loc2_);
               }
               return;
            }
            var _loc4_:Array = param1 as Array;
            if(_loc4_)
            {
               for each(_loc2_ in _loc4_)
               {
                  addAndSelectCostume(_loc2_);
               }
            }
         };
         var type:String = this.isStage() ? "backdrop" : "costume";
         var lib:MediaLibrary = app.getMediaLibrary(type,addCostume);
         if(fromComputer)
         {
            lib.importFromDisk();
         }
         else
         {
            lib.open();
         }
      }
      
      private function paintCostume(param1:* = null) : void
      {
         this.addAndSelectCostume(ScratchCostume.emptyBitmapCostume("",this.isStage()));
      }
      
      protected function savePhotoAsCostume(param1:BitmapData) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Matrix = null;
         var _loc6_:BitmapData = null;
         app.closeCameraDialog();
         var _loc2_:ScratchObj = app.viewedObj();
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.isStage)
         {
            _loc4_ = 480 / param1.width;
            _loc5_ = new Matrix();
            _loc5_.scale(_loc4_,_loc4_);
            _loc6_ = new BitmapData(480,360,true,0);
            _loc6_.draw(param1,_loc5_);
            param1 = _loc6_;
         }
         var _loc3_:ScratchCostume = new ScratchCostume(Translator.map("photo1"),param1);
         this.addAndSelectCostume(_loc3_);
         this.editor.getWorkArea().zoom();
      }
      
      private function costumeFromCamera(param1:* = null) : void
      {
         app.openCameraDialog(this.savePhotoAsCostume);
      }
      
      private function addAndSelectCostume(param1:ScratchCostume) : void
      {
         var _loc2_:ScratchObj = app.viewedObj();
         if(!param1.baseLayerData)
         {
            param1.prepareToSave();
         }
         if(!app.okayToAdd(param1.baseLayerData.length))
         {
            return;
         }
         param1.costumeName = _loc2_.unusedCostumeName(param1.costumeName);
         _loc2_.costumes.push(param1);
         _loc2_.showCostume(_loc2_.costumes.length - 1);
         app.setSaveNeeded(true);
         this.refresh();
      }
      
      public function handleTool(param1:String, param2:MouseEvent) : void
      {
         var _loc3_:Point = globalToLocal(new Point(stage.mouseX,stage.mouseY));
         if(param1 == "help")
         {
            if(_loc3_.x > this.columnWidth)
            {
               Scratch.app.showTip("paint");
            }
            else
            {
               Scratch.app.showTip("scratchUI");
            }
         }
      }
   }
}

