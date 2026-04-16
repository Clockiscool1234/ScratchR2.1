package soundedit
{
   import assets.Resources;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.media.Microphone;
   import flash.text.TextField;
   import translation.Translator;
   import ui.parts.SoundsPart;
   import ui.parts.UIPart;
   import uiwidgets.IconButton;
   import uiwidgets.Menu;
   import uiwidgets.Scrollbar;
   import uiwidgets.Slider;
   
   public class SoundEditor extends Sprite
   {
      
      private static var microphone:Microphone = Microphone.getMicrophone();
      
      private const waveHeight:int = 170;
      
      private const borderColor:int = 6316128;
      
      private const bgColor:int = 15790320;
      
      private const cornerRadius:int = 20;
      
      public var app:Scratch;
      
      public var waveform:WaveformView;
      
      public var levelMeter:SoundLevelMeter;
      
      public var scrollbar:Scrollbar;
      
      private var buttons:Array = [];
      
      private var playButton:IconButton;
      
      private var stopButton:IconButton;
      
      private var recordButton:IconButton;
      
      private var editButton:IconButton;
      
      private var effectsButton:IconButton;
      
      private var recordIndicator:Shape;
      
      private var playIndicator:Shape;
      
      private var micVolumeLabel:TextField;
      
      private var micVolumeSlider:Slider;
      
      public function SoundEditor(param1:Scratch, param2:SoundsPart)
      {
         super();
         this.app = param1;
         addChild(this.levelMeter = new SoundLevelMeter(12,this.waveHeight));
         addChild(this.waveform = new WaveformView(this,param2));
         addChild(this.scrollbar = new Scrollbar(10,10,this.waveform.setScroll));
         this.addControls();
         this.addIndicators();
         this.addEditAndEffectsButtons();
         this.addMicVolumeSlider();
         this.updateIndicators();
      }
      
      public static function strings() : Array
      {
         var _loc1_:SoundEditor = new SoundEditor(null,null);
         _loc1_.editMenu(Menu.dummyButton());
         _loc1_.effectsMenu(Menu.dummyButton());
         return ["Edit","Effects","Microphone volume:"];
      }
      
      public function updateTranslation() : void
      {
         if(this.editButton.parent)
         {
            removeChild(this.editButton);
            removeChild(this.effectsButton);
         }
         this.micVolumeLabel.text = Translator.map("Microphone volume:");
         this.addEditAndEffectsButtons();
         this.setWidthHeight(width,height);
      }
      
      public function shutdown() : void
      {
         this.waveform.stopAll();
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc6_:IconButton = null;
         this.levelMeter.x = 0;
         this.levelMeter.y = 0;
         this.waveform.x = 23;
         this.waveform.y = 0;
         this.scrollbar.x = 25;
         this.scrollbar.y = this.waveHeight + 5;
         var _loc3_:int = param1 - this.waveform.x;
         this.waveform.setWidthHeight(_loc3_,this.waveHeight);
         this.scrollbar.setWidthHeight(_loc3_,10);
         _loc4_ = this.waveform.x - 2;
         var _loc5_:int = this.waveform.y + this.waveHeight + 25;
         for each(_loc6_ in this.buttons)
         {
            _loc6_.x = _loc4_;
            _loc6_.y = _loc5_;
            _loc4_ += _loc6_.width + 8;
         }
         this.editButton.x = _loc4_ + 20;
         this.editButton.y = _loc5_;
         this.effectsButton.x = this.editButton.x + this.editButton.width + 15;
         this.effectsButton.y = this.editButton.y;
         this.recordIndicator.x = this.recordButton.x + 9;
         this.recordIndicator.y = this.recordButton.y + 8;
         this.playIndicator.x = this.playButton.x + 12;
         this.playIndicator.y = this.playButton.y + 7;
         this.micVolumeSlider.x = this.micVolumeLabel.x + this.micVolumeLabel.textWidth + 15;
         this.micVolumeSlider.y = this.micVolumeLabel.y + 7;
      }
      
      private function addControls() : void
      {
         var _loc1_:IconButton = null;
         this.playButton = new IconButton(this.waveform.startPlaying,"playSnd",null,true);
         this.stopButton = new IconButton(this.waveform.stopAll,"stopSnd",null,true);
         this.recordButton = new IconButton(this.waveform.toggleRecording,"recordSnd",null,true);
         this.buttons = [this.playButton,this.stopButton,this.recordButton];
         for each(_loc1_ in this.buttons)
         {
            if(_loc1_ is IconButton)
            {
               _loc1_.isMomentary = true;
            }
            addChild(_loc1_);
         }
      }
      
      private function addEditAndEffectsButtons() : void
      {
         addChild(this.editButton = UIPart.makeMenuButton("Edit",this.editMenu,true,CSS.textColor));
         addChild(this.effectsButton = UIPart.makeMenuButton("Effects",this.effectsMenu,true,CSS.textColor));
      }
      
      private function addMicVolumeSlider() : void
      {
         var setMicLevel:Function = null;
         setMicLevel = function(param1:Number):void
         {
            if(microphone)
            {
               microphone.gain = param1;
            }
         };
         addChild(this.micVolumeLabel = Resources.makeLabel(Translator.map("Microphone volume:"),CSS.normalTextFormat,22,240));
         this.micVolumeSlider = new Slider(130,5,setMicLevel);
         this.micVolumeSlider.min = 1;
         this.micVolumeSlider.max = 100;
         this.micVolumeSlider.value = 50;
         addChild(this.micVolumeSlider);
      }
      
      private function addIndicators() : void
      {
         this.recordIndicator = new Shape();
         var _loc1_:Graphics = this.recordIndicator.graphics;
         _loc1_.beginFill(16711680);
         _loc1_.drawCircle(8,8,8);
         _loc1_.endFill();
         addChild(this.recordIndicator);
         this.playIndicator = new Shape();
         _loc1_ = this.playIndicator.graphics;
         _loc1_.beginFill(65280);
         _loc1_.moveTo(0,0);
         _loc1_.lineTo(11,8);
         _loc1_.lineTo(11,10);
         _loc1_.lineTo(0,18);
         _loc1_.endFill();
         addChild(this.playIndicator);
      }
      
      public function updateIndicators() : void
      {
         this.recordIndicator.visible = this.waveform.isRecording();
         this.playIndicator.visible = this.waveform.isPlaying();
         if(microphone)
         {
            this.micVolumeSlider.value = microphone.gain;
         }
      }
      
      private function editMenu(param1:IconButton) : void
      {
         var _loc2_:Menu = new Menu();
         _loc2_.addItem("undo",this.waveform.undo);
         _loc2_.addItem("redo",this.waveform.redo);
         _loc2_.addLine();
         _loc2_.addItem("cut",this.waveform.cut);
         _loc2_.addItem("copy",this.waveform.copy);
         _loc2_.addItem("paste",this.waveform.paste);
         _loc2_.addLine();
         _loc2_.addItem("delete",this.waveform.deleteSelection);
         _loc2_.addItem("select all",this.waveform.selectAll);
         var _loc3_:Point = param1.localToGlobal(new Point(0,0));
         _loc2_.showOnStage(stage,_loc3_.x + 1,_loc3_.y + param1.height - 1);
      }
      
      private function effectsMenu(param1:IconButton) : void
      {
         var p:Point;
         var applyEffect:Function = null;
         var shiftKey:Boolean = false;
         var b:IconButton = param1;
         applyEffect = function(param1:String):void
         {
            waveform.applyEffect(param1,shiftKey);
         };
         shiftKey = b.lastEvent.shiftKey;
         var m:Menu = new Menu(applyEffect);
         m.addItem("fade in");
         m.addItem("fade out");
         m.addLine();
         m.addItem("louder");
         m.addItem("softer");
         m.addItem("silence");
         m.addLine();
         m.addItem("reverse");
         p = b.localToGlobal(new Point(0,0));
         m.showOnStage(stage,p.x + 1,p.y + b.height - 1);
      }
      
      public function keyDown(param1:KeyboardEvent) : void
      {
         var _loc3_:String = null;
         if(!stage || Boolean(stage.focus))
         {
            return;
         }
         var _loc2_:int = int(param1.keyCode);
         if(_loc2_ == 8 || _loc2_ == 127)
         {
            this.waveform.deleteSelection(param1.shiftKey);
         }
         if(_loc2_ == 37)
         {
            this.waveform.leftArrow();
         }
         if(_loc2_ == 39)
         {
            this.waveform.rightArrow();
         }
         if(param1.ctrlKey || param1.shiftKey)
         {
            switch(String.fromCharCode(_loc2_))
            {
               case "A":
                  this.waveform.selectAll();
                  break;
               case "C":
                  this.waveform.copy();
                  break;
               case "V":
                  this.waveform.paste();
                  break;
               case "X":
                  this.waveform.cut();
                  break;
               case "Y":
                  this.waveform.redo();
                  break;
               case "Z":
                  this.waveform.undo();
            }
         }
         if(!param1.ctrlKey)
         {
            _loc3_ = String.fromCharCode(param1.charCode);
            if(_loc3_ == " ")
            {
               this.waveform.togglePlaying();
            }
            if(_loc3_ == "+")
            {
               this.waveform.zoomIn();
            }
            if(_loc3_ == "-")
            {
               this.waveform.zoomOut();
            }
         }
      }
   }
}

