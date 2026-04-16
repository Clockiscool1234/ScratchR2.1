package ui
{
   import blocks.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import translation.Translator;
   import uiwidgets.*;
   import util.*;
   
   public class RecordingSpecEditor extends Sprite
   {
      
      private var base:Shape;
      
      private var row:Array = [];
      
      private var description:TextField;
      
      private var notSavedLabel:TextField;
      
      private var pleaseNoteLabel:TextField;
      
      private var moreLabel:TextField;
      
      private var moreButton:IconButton;
      
      private var checkboxLabels:Array = [];
      
      private var checkboxes:Array = [];
      
      private var micVolumeSlider:Slider;
      
      private var topBar:Shape;
      
      private var bottomBar:Shape;
      
      private var toggleOn:Boolean;
      
      private var slotColor:int = 12303807;
      
      private const labelColor:int = 8861887;
      
      public function RecordingSpecEditor()
      {
         super();
         addChild(this.base = new Shape());
         this.setWidthHeight(440,10);
         addChild(this.description = this.makeLabel("Capture and download a video of your project to your computer.\nYou can record up to 60 seconds of video.",14));
         addChild(this.notSavedLabel = this.makeLabel("that the video will not be saved on Scratch.",14));
         addChild(this.pleaseNoteLabel = this.makeLabel("Please note",14,true));
         addChild(this.moreLabel = this.makeLabel("More Options",14));
         this.moreLabel.addEventListener(MouseEvent.MOUSE_DOWN,this.toggleButtons);
         var _loc1_:TextFormat = new TextFormat();
         _loc1_.align = TextFormatAlign.CENTER;
         _loc1_.leading = 5;
         this.description.setTextFormat(_loc1_);
         this.topBar = new Shape();
         this.bottomBar = new Shape();
         var _loc2_:int = 9;
         var _loc3_:Graphics = this.topBar.graphics;
         _loc3_.clear();
         _loc3_.beginFill(this.slotColor);
         _loc3_.drawRoundRect(0,0,400,1,_loc2_,_loc2_);
         _loc3_.endFill();
         var _loc4_:Graphics = this.bottomBar.graphics;
         _loc4_.clear();
         _loc4_.beginFill(this.slotColor);
         _loc4_.drawRoundRect(0,0,400,1,_loc2_,_loc2_);
         _loc4_.endFill();
         addChild(this.topBar);
         addChild(this.bottomBar);
         addChild(this.moreButton = new IconButton(this.toggleButtons,"toggle"));
         this.moreButton.disableMouseover();
         this.addCheckboxesAndLabels();
         this.checkboxes[0].setOn(true);
         this.showButtons(false);
         this.fixLayout();
      }
      
      private function setWidthHeight(param1:int, param2:int) : void
      {
         var _loc3_:Graphics = this.base.graphics;
         _loc3_.clear();
         _loc3_.beginFill(CSS.white);
         _loc3_.drawRect(0,0,param1,param2);
         _loc3_.endFill();
      }
      
      public function spec() : String
      {
         var _loc2_:* = undefined;
         var _loc1_:String = "";
         for each(_loc2_ in this.row)
         {
            if(_loc2_ is TextField)
            {
               _loc1_ += ReadStream.escape(TextField(_loc2_).text);
            }
            if(_loc1_.length > 0 && _loc1_.charAt(_loc1_.length - 1) != " ")
            {
               _loc1_ += " ";
            }
         }
         if(_loc1_.length > 0 && _loc1_.charAt(_loc1_.length - 1) == " ")
         {
            _loc1_ = _loc1_.slice(0,_loc1_.length - 1);
         }
         return _loc1_;
      }
      
      public function soundFlag() : Boolean
      {
         return this.checkboxes[0].isOn();
      }
      
      public function editorFlag() : Boolean
      {
         return this.checkboxes[3].isOn();
      }
      
      public function microphoneFlag() : Boolean
      {
         return this.checkboxes[1].isOn();
      }
      
      public function cursorFlag() : Boolean
      {
         return this.checkboxes[2].isOn();
      }
      
      public function fifteenFlag() : Boolean
      {
         return this.checkboxes[4].isOn();
      }
      
      private function addCheckboxesAndLabels() : void
      {
         var c:int;
         var toggleCheckbox:Function;
         var disable:Function = null;
         var hideVolume:Function = null;
         var label:TextField = null;
         var b:IconButton = null;
         disable = function():void
         {
            if(editorFlag())
            {
               checkboxes[4].setDisabled(true,0.4);
            }
            else
            {
               checkboxes[4].setDisabled(false);
            }
         };
         hideVolume = function():void
         {
            if(microphoneFlag())
            {
               addChild(micVolumeSlider);
            }
            else
            {
               removeChild(micVolumeSlider);
            }
         };
         this.checkboxLabels = [this.makeLabel("Include sound from project",14),this.makeLabel("Include sound from microphone",14),this.makeLabel("Show mouse pointer",14),this.makeLabel("Record entire editor (may run slowly)",14),this.makeLabel("Record at highest quality (may run slowly)",14)];
         this.checkboxes = [new IconButton(null,"checkbox"),new IconButton(hideVolume,"checkbox"),new IconButton(null,"checkbox"),new IconButton(disable,"checkbox"),new IconButton(null,"checkbox")];
         c = 0;
         for each(label in this.checkboxLabels)
         {
            toggleCheckbox = function(param1:MouseEvent):void
            {
               var _loc2_:IconButton = null;
               _loc2_ = checkboxes[checkboxLabels.indexOf(param1.currentTarget)];
               _loc2_.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN));
            };
            c += 1;
            label.addEventListener(MouseEvent.MOUSE_DOWN,toggleCheckbox);
            addChild(label);
         }
         for each(b in this.checkboxes)
         {
            b.disableMouseover();
            addChild(b);
         }
         this.micVolumeSlider = new Slider(75,10,null,true);
         this.micVolumeSlider.min = 1;
         this.micVolumeSlider.max = 100;
         this.micVolumeSlider.value = 50;
      }
      
      public function getMicVolume() : int
      {
         return this.micVolumeSlider.value;
      }
      
      private function makeLabel(param1:String, param2:int, param3:Boolean = false) : TextField
      {
         var _loc4_:TextField = new TextField();
         _loc4_.selectable = false;
         _loc4_.defaultTextFormat = new TextFormat(CSS.font,param2,CSS.textColor,param3);
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.text = Translator.map(param1);
         addChild(_loc4_);
         return _loc4_;
      }
      
      private function toggleButtons(param1:*) : void
      {
         this.showButtons(!this.toggleOn);
         removeChild(this.moreLabel);
         if(this.toggleOn)
         {
            addChild(this.moreLabel = this.makeLabel("Fewer Options",14));
         }
         else
         {
            addChild(this.moreLabel = this.makeLabel("More Options",14));
         }
         this.moreLabel.addEventListener(MouseEvent.MOUSE_DOWN,this.toggleButtons);
         this.fixLayout();
      }
      
      private function showButtons(param1:Boolean) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:IconButton = null;
         var _loc4_:int = 0;
         var _loc5_:int = 140;
         if(param1)
         {
            _loc5_ += 14;
            this.toggleOn = true;
            _loc4_ = 1;
            while(_loc4_ < this.checkboxLabels.length)
            {
               _loc2_ = this.checkboxLabels[_loc4_];
               _loc5_ += _loc2_.height + 7;
               addChild(_loc2_);
               _loc4_++;
            }
            _loc4_ = 1;
            while(_loc4_ < this.checkboxes.length)
            {
               addChild(this.checkboxes[_loc4_]);
               _loc4_++;
            }
            if(this.microphoneFlag())
            {
               addChild(this.micVolumeSlider);
            }
         }
         else
         {
            this.toggleOn = false;
            _loc4_ = 1;
            while(_loc4_ < this.checkboxLabels.length)
            {
               _loc2_ = this.checkboxLabels[_loc4_];
               if(_loc2_.parent)
               {
                  removeChild(_loc2_);
               }
               _loc4_++;
            }
            _loc4_ = 1;
            while(_loc4_ < this.checkboxes.length)
            {
               removeChild(this.checkboxes[_loc4_]);
               _loc4_++;
            }
            if(this.microphoneFlag())
            {
               removeChild(this.micVolumeSlider);
            }
         }
         this.moreButton.setOn(param1);
         this.setWidthHeight(this.base.width,_loc5_);
         if(parent is DialogBox)
         {
            DialogBox(parent).fixLayout();
         }
      }
      
      private function appendObj(param1:DisplayObject) : void
      {
         this.row.push(param1);
         addChild(param1);
         if(stage)
         {
            if(param1 is TextField)
            {
               stage.focus = TextField(param1);
            }
         }
         this.fixLayout();
      }
      
      private function makeTextField(param1:String) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.borderColor = 0;
         _loc2_.backgroundColor = this.labelColor;
         _loc2_.background = true;
         _loc2_.type = TextFieldType.INPUT;
         _loc2_.defaultTextFormat = Block.blockLabelFormat;
         if(param1.length > 0)
         {
            _loc2_.width = 1000;
            _loc2_.text = param1;
            _loc2_.width = Math.max(10,_loc2_.textWidth + 2);
         }
         else
         {
            _loc2_.width = 27;
         }
         _loc2_.height = _loc2_.textHeight + 5;
         return _loc2_;
      }
      
      private function fixLayout(param1:Boolean = true) : void
      {
         var _loc5_:TextField = null;
         this.description.x = (440 - this.description.width) / 2;
         this.description.y = 0;
         this.topBar.x = 20;
         this.topBar.y = 48;
         var _loc2_:int = 30;
         var _loc3_:int = 62;
         var _loc4_:int = 0;
         while(_loc4_ < this.checkboxes.length)
         {
            _loc5_ = this.checkboxLabels[_loc4_];
            this.checkboxes[_loc4_].x = _loc2_;
            this.checkboxes[_loc4_].y = _loc3_ - 4;
            this.checkboxLabels[_loc4_].x = this.checkboxes[_loc4_].x + 20;
            this.checkboxLabels[_loc4_].y = this.checkboxes[_loc4_].y - 3;
            if(_loc4_ == 1)
            {
               this.micVolumeSlider.x = this.checkboxLabels[_loc4_].x + this.checkboxLabels[_loc4_].width + 15;
               this.micVolumeSlider.y = this.checkboxes[_loc4_].y + 4;
            }
            _loc3_ += 30;
            _loc4_++;
         }
         if(this.toggleOn)
         {
            this.moreButton.x = _loc2_ + 1;
            this.moreButton.y = _loc3_ - 5;
            this.moreLabel.x = this.moreButton.x + 10;
            this.moreLabel.y = this.moreButton.y - 4;
         }
         else
         {
            this.moreButton.x = _loc2_ + 1;
            this.moreButton.y = 85;
            this.moreLabel.x = this.moreButton.x + 10;
            this.moreLabel.y = this.moreButton.y - 4;
         }
         this.bottomBar.x = 20;
         this.bottomBar.y = this.moreButton.y + 20;
         this.notSavedLabel.x = (440 - this.notSavedLabel.width - this.pleaseNoteLabel.width) / 2 + this.pleaseNoteLabel.width;
         this.notSavedLabel.y = this.bottomBar.y + 7;
         this.pleaseNoteLabel.x = (440 - this.notSavedLabel.width - this.pleaseNoteLabel.width) / 2;
         this.pleaseNoteLabel.y = this.bottomBar.y + 7;
         if(parent is DialogBox)
         {
            DialogBox(parent).fixLayout();
         }
      }
   }
}

