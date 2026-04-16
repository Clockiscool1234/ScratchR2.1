package ui.parts
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.KeyboardEvent;
   import flash.geom.*;
   import flash.text.*;
   import scratch.*;
   import sound.WAVFile;
   import soundedit.SoundEditor;
   import translation.Translator;
   import ui.media.*;
   import uiwidgets.*;
   
   public class SoundsPart extends UIPart
   {
      
      public var editor:SoundEditor;
      
      public var currentIndex:int;
      
      private const columnWidth:int = 106;
      
      private var shape:Shape;
      
      private var listFrame:ScrollFrame;
      
      private var nameField:EditableLabel;
      
      private var undoButton:IconButton;
      
      private var redoButton:IconButton;
      
      private var newSoundLabel:TextField;
      
      private var libraryButton:IconButton;
      
      private var importButton:IconButton;
      
      private var recordButton:IconButton;
      
      public function SoundsPart(param1:Scratch)
      {
         super();
         this.app = param1;
         addChild(this.shape = new Shape());
         addChild(this.newSoundLabel = makeLabel("",new TextFormat(CSS.font,12,CSS.textColor,true)));
         this.addNewSoundButtons();
         this.addListFrame();
         addChild(this.nameField = new EditableLabel(this.nameChanged));
         addChild(this.editor = new SoundEditor(param1,this));
         this.addUndoButtons();
         param1.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.editor.keyDown);
         this.updateTranslation();
      }
      
      public static function strings() : Array
      {
         new SoundsPart(Scratch.app).showNewSoundMenu(Menu.dummyButton());
         return ["New sound:","recording1","Choose sound from library","Record new sound","Upload sound from file"];
      }
      
      public static function makeButtonImg(param1:String, param2:Boolean, param3:Point = null) : Sprite
      {
         var _loc6_:int = 0;
         var _loc7_:Sprite = null;
         var _loc9_:Matrix = null;
         var _loc4_:Bitmap = Resources.createBmp(param1 + (param2 ? "On" : "Off"));
         var _loc5_:int = Math.max(_loc4_.width,param3 ? param3.x : 24);
         _loc6_ = Math.max(_loc4_.height,param3 ? param3.y : 24);
         _loc7_ = new Sprite();
         var _loc8_:Graphics = _loc7_.graphics;
         _loc8_.clear();
         _loc8_.lineStyle(0.5,CSS.borderColor,1,true);
         if(param2)
         {
            _loc8_.beginFill(CSS.overColor);
         }
         else
         {
            _loc9_ = new Matrix();
            _loc9_.createGradientBox(24,24,Math.PI / 2,0,0);
            _loc8_.beginGradientFill(GradientType.LINEAR,CSS.titleBarColors,[100,100],[0,255],_loc9_);
         }
         _loc8_.drawRoundRect(0,0,_loc5_,_loc6_,8);
         _loc8_.endFill();
         _loc4_.x = (_loc5_ - _loc4_.width) / 2;
         _loc4_.y = (_loc6_ - _loc4_.height) / 2;
         _loc7_.addChild(_loc4_);
         return _loc7_;
      }
      
      public function updateTranslation() : void
      {
         this.newSoundLabel.text = Translator.map("New sound:");
         this.editor.updateTranslation();
         SimpleTooltips.add(this.libraryButton,{
            "text":"Choose sound from library",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.recordButton,{
            "text":"Record new sound",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.importButton,{
            "text":"Upload sound from file",
            "direction":"bottom"
         });
         this.fixlayout();
      }
      
      public function selectSound(param1:ScratchSound) : void
      {
         var _loc2_:ScratchObj = app.viewedObj();
         if(_loc2_ == null)
         {
            return;
         }
         if(_loc2_.sounds.length == 0)
         {
            return;
         }
         this.currentIndex = 0;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.sounds.length)
         {
            if(_loc2_.sounds[_loc3_] as ScratchSound == param1)
            {
               this.currentIndex = _loc3_;
            }
            _loc3_++;
         }
         (this.listFrame.contents as MediaPane).updateSelection();
         this.refresh(false);
      }
      
      public function refresh(param1:Boolean = true) : void
      {
         var _loc4_:MediaPane = null;
         if(param1)
         {
            _loc4_ = this.listFrame.contents as MediaPane;
            _loc4_.refresh();
         }
         this.nameField.setContents("");
         var _loc2_:ScratchObj = app.viewedObj();
         if(_loc2_.sounds.length < 1)
         {
            this.nameField.visible = false;
            this.editor.visible = false;
            this.undoButton.visible = false;
            this.redoButton.visible = false;
            return;
         }
         this.nameField.visible = true;
         this.editor.visible = true;
         this.undoButton.visible = true;
         this.redoButton.visible = true;
         this.refreshUndoButtons();
         this.editor.waveform.stopAll();
         var _loc3_:ScratchSound = _loc2_.sounds[this.currentIndex];
         if(_loc3_)
         {
            this.nameField.setContents(_loc3_.soundName);
            this.editor.waveform.editSound(_loc3_);
         }
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
         this.newSoundLabel.x = 7;
         this.newSoundLabel.y = 7;
         this.listFrame.x = 1;
         this.listFrame.y = 58;
         this.listFrame.setWidthHeight(this.columnWidth,h - this.listFrame.y);
         var _loc1_:int = this.columnWidth + 13;
         var _loc2_:int = w - _loc1_ - 15;
         this.nameField.setWidth(Math.min(135,_loc2_));
         this.nameField.x = _loc1_;
         this.nameField.y = 15;
         this.undoButton.x = this.nameField.x + this.nameField.width + 30;
         this.redoButton.x = this.undoButton.right() + 8;
         this.undoButton.y = this.redoButton.y = this.nameField.y - 2;
         this.editor.setWidthHeight(_loc2_,200);
         this.editor.x = _loc1_;
         this.editor.y = 50;
      }
      
      private function addNewSoundButtons() : void
      {
         var _loc1_:int = 16;
         var _loc2_:int = 31;
         addChild(this.libraryButton = this.makeButton(this.soundFromLibrary,"soundlibrary",_loc1_,_loc2_));
         addChild(this.recordButton = this.makeButton(this.recordSound,"record",_loc1_ + 34,_loc2_));
         addChild(this.importButton = this.makeButton(this.soundFromComputer,"import",_loc1_ + 61,_loc2_ - 1));
      }
      
      private function makeButton(param1:Function, param2:String, param3:int, param4:int) : IconButton
      {
         var _loc5_:IconButton = null;
         _loc5_ = new IconButton(param1,param2);
         _loc5_.isMomentary = true;
         _loc5_.x = param3;
         _loc5_.y = param4;
         return _loc5_;
      }
      
      private function addListFrame() : void
      {
         this.listFrame = new ScrollFrame();
         this.listFrame.setContents(app.getMediaPane(app,"sounds"));
         this.listFrame.contents.color = CSS.tabColor;
         this.listFrame.allowHorizontalScrollbar = false;
         addChild(this.listFrame);
      }
      
      private function nameChanged() : void
      {
         this.currentIndex = Math.min(this.currentIndex,app.viewedObj().sounds.length - 1);
         var _loc1_:ScratchSound = app.viewedObj().sounds[this.currentIndex] as ScratchSound;
         app.runtime.renameSound(_loc1_,this.nameField.contents());
         this.nameField.setContents(_loc1_.soundName);
         (this.listFrame.contents as MediaPane).refresh();
      }
      
      private function addUndoButtons() : void
      {
         addChild(this.undoButton = new IconButton(this.editor.waveform.undo,makeButtonImg("undo",true),makeButtonImg("undo",false)));
         addChild(this.redoButton = new IconButton(this.editor.waveform.redo,makeButtonImg("redo",true),makeButtonImg("redo",false)));
         this.undoButton.isMomentary = true;
         this.redoButton.isMomentary = true;
      }
      
      public function refreshUndoButtons() : void
      {
         this.undoButton.setDisabled(!this.editor.waveform.canUndo(),0.5);
         this.redoButton.setDisabled(!this.editor.waveform.canRedo(),0.5);
      }
      
      private function showNewSoundMenu(param1:IconButton) : void
      {
         var _loc2_:Menu = new Menu(null,"New Sound",11579568,28);
         _loc2_.minWidth = 90;
         _loc2_.addItem("Library",this.soundFromLibrary);
         _loc2_.addItem("Record",this.recordSound);
         _loc2_.addItem("Import",this.soundFromComputer);
         var _loc3_:Point = param1.localToGlobal(new Point(0,0));
         _loc2_.showOnStage(stage,_loc3_.x - 1,_loc3_.y + param1.height - 2);
      }
      
      public function soundFromLibrary(param1:* = null) : void
      {
         app.getMediaLibrary("sound",app.addSound).open();
      }
      
      public function soundFromComputer(param1:* = null) : void
      {
         app.getMediaLibrary("sound",app.addSound).importFromDisk();
      }
      
      public function recordSound(param1:* = null) : void
      {
         var _loc2_:String = app.viewedObj().unusedSoundName(Translator.map("recording1"));
         app.addSound(new ScratchSound(_loc2_,WAVFile.empty()));
      }
   }
}

