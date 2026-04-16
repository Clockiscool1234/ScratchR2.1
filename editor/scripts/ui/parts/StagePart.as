package ui.parts
{
   import assets.Resources;
   import flash.display.Bitmap;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.media.SoundMixer;
   import flash.media.SoundTransform;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import scratch.ReadyLabel;
   import scratch.ScratchStage;
   import translation.Translator;
   import uiwidgets.EditableLabel;
   import uiwidgets.IconButton;
   
   public class StagePart extends UIPart
   {
      
      private const readoutTextColor:int = Scratch.app.isExtensionDevMode ? CSS.white : CSS.textColor;
      
      private const readoutLabelFormat:TextFormat = new TextFormat(CSS.font,12,this.readoutTextColor,true);
      
      private const readoutFormat:TextFormat = new TextFormat(CSS.font,10,this.readoutTextColor);
      
      private const topBarHeightNormal:int = 39;
      
      private const topBarHeightSmallPlayerMode:int = 26;
      
      private var topBarHeight:int = 39;
      
      private var outline:Shape;
      
      protected var projectTitle:EditableLabel;
      
      protected var projectInfo:TextField;
      
      private var versionInfo:TextField;
      
      private var turboIndicator:TextField;
      
      private var runButton:IconButton;
      
      private var stopButton:IconButton;
      
      private var fullscreenButton:IconButton;
      
      private var stageSizeButton:Sprite;
      
      private var stopRecordingButton:IconButton;
      
      private var recordingIndicator:Shape;
      
      private var videoProgressBar:Shape;
      
      private var recordingTime:TextField;
      
      private var playButton:Sprite;
      
      private var userNameWarning:Sprite;
      
      private var runButtonOnTicks:int;
      
      private var readouts:Sprite;
      
      private var xLabel:TextField;
      
      private var xReadout:TextField;
      
      private var yLabel:TextField;
      
      private var yReadout:TextField;
      
      private var lastTime:int = 0;
      
      private var lastX:int;
      
      private var lastY:int;
      
      public function StagePart(param1:Scratch)
      {
         super();
         this.app = param1;
         this.outline = new Shape();
         addChild(this.outline);
         this.addTitleAndInfo();
         this.addRunStopButtons();
         this.addRecordingTools();
         this.addTurboIndicator();
         this.addFullScreenButton();
         this.addXYReadouts();
         this.addStageSizeButton();
         this.fixLayout();
         addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheel);
      }
      
      public static function strings() : Array
      {
         return ["by","shared","unshared","Turbo Mode","This project can detect who is using it, through the “username” block. To hide your identity, sign out before using the project."];
      }
      
      public function updateTranslation() : void
      {
         this.turboIndicator.text = Translator.map("Turbo Mode");
         this.turboIndicator.x = w - this.turboIndicator.width - 73;
         this.updateProjectInfo();
      }
      
      public function setWidthHeight(param1:int, param2:int, param3:Number) : void
      {
         this.w = param1;
         this.h = param2;
         if(app.stagePane)
         {
            app.stagePane.scaleX = app.stagePane.scaleY = param3;
         }
         this.topBarHeight = this.computeTopBarHeight();
         this.drawOutline();
         this.fixLayout();
      }
      
      public function computeTopBarHeight() : int
      {
         return app.isSmallPlayer ? this.topBarHeightSmallPlayerMode : this.topBarHeightNormal;
      }
      
      public function installStage(param1:ScratchStage, param2:Boolean) : void
      {
         var _loc3_:Number = app.stageIsContracted ? 0.5 : 1;
         if(app.stagePane != null && app.stagePane.parent != null)
         {
            _loc3_ = app.stagePane.scaleX;
            app.stagePane.parent.removeChild(app.stagePane);
         }
         this.topBarHeight = this.computeTopBarHeight();
         param1.x = 1;
         param1.y = this.topBarHeight;
         param1.scaleX = param1.scaleY = _loc3_;
         addChild(param1);
         app.stagePane = param1;
         if(param2)
         {
            this.showPlayButton();
         }
         else
         {
            this.hidePlayButton();
         }
      }
      
      public function projectName() : String
      {
         return this.projectTitle.contents();
      }
      
      public function setProjectName(param1:String) : void
      {
         this.projectTitle.setContents(param1);
      }
      
      public function isInPresentationMode() : Boolean
      {
         return this.fullscreenButton.visible && this.fullscreenButton.isOn();
      }
      
      public function presentationModeWasChanged(param1:Boolean) : void
      {
         this.fullscreenButton.setOn(param1);
         this.drawOutline();
         this.refresh();
      }
      
      public function refresh() : void
      {
         if((app.runtime.ready == ReadyLabel.COUNTDOWN || app.runtime.ready == ReadyLabel.READY) && !this.stopRecordingButton.isDisabled())
         {
            this.resetTime();
         }
         this.readouts.visible = app.editMode;
         this.projectTitle.visible = app.editMode;
         this.projectInfo.visible = app.editMode;
         this.stageSizeButton.visible = app.editMode;
         this.turboIndicator.visible = app.interp.turboMode;
         this.fullscreenButton.visible = !app.isSmallPlayer;
         this.stopRecordingButton.visible = (app.runtime.ready == ReadyLabel.COUNTDOWN || app.runtime.recording) && app.editMode;
         this.videoProgressBar.visible = (app.runtime.ready == ReadyLabel.COUNTDOWN || app.runtime.recording) && app.editMode;
         this.recordingTime.visible = (app.runtime.ready == ReadyLabel.COUNTDOWN || app.runtime.recording) && app.editMode;
         this.recordingIndicator.visible = app.runtime.recording && app.editMode;
         if(app.editMode)
         {
            this.fullscreenButton.setOn(false);
            this.drawStageSizeButton();
         }
         if(this.userNameWarning)
         {
            this.userNameWarning.visible = app.usesUserNameBlock;
         }
         this.updateProjectInfo();
      }
      
      private function drawOutline() : void
      {
         var _loc1_:Array = app.isSmallPlayer ? [CSS.tabColor,CSS.tabColor] : CSS.titleBarColors;
         var _loc2_:Graphics = this.outline.graphics;
         _loc2_.clear();
         drawTopBar(_loc2_,_loc1_,getTopBarPath(w - 1,this.topBarHeight),w,this.topBarHeight,CSS.borderColor);
         _loc2_.lineStyle(1,CSS.borderColor,1,true);
         _loc2_.drawRect(0,this.topBarHeight - 1,w - 1,h - this.topBarHeight);
         this.versionInfo.visible = !this.fullscreenButton.isOn();
      }
      
      protected function fixLayout() : void
      {
         var _loc2_:int = 0;
         if(app.stagePane)
         {
            app.stagePane.y = this.topBarHeight;
         }
         this.projectTitle.x = 50;
         this.projectTitle.y = app.isOffline ? 8 : 2;
         this.projectInfo.x = this.projectTitle.x + 3;
         this.projectInfo.y = this.projectTitle.y + 18;
         this.runButton.x = w - 60;
         this.runButton.y = int((this.topBarHeight - this.runButton.height) / 2);
         this.stopButton.x = this.runButton.x + 32;
         this.stopButton.y = this.runButton.y + 1;
         this.turboIndicator.x = w - this.turboIndicator.width - 73;
         this.turboIndicator.y = app.isSmallPlayer ? 5 : (app.editMode ? 22 : 12);
         this.fullscreenButton.x = 11;
         --this.stopButton.y;
         this.versionInfo.x = this.fullscreenButton.x + 1;
         this.versionInfo.y = 27;
         this.projectTitle.setWidth(this.runButton.x - this.projectTitle.x - 15);
         var _loc1_:int = w - 98;
         this.xLabel.x = _loc1_;
         this.xReadout.x = _loc1_ + 16;
         this.yLabel.x = _loc1_ + 43;
         this.yReadout.x = _loc1_ + 60;
         _loc2_ = h + 1;
         this.xReadout.y = this.yReadout.y = _loc2_;
         this.xLabel.y = this.yLabel.y = _loc2_ - 2;
         this.stopRecordingButton.x = 2;
         this.stopRecordingButton.y = _loc2_ + 2;
         this.recordingIndicator.x = 8 + this.stopRecordingButton.width;
         this.recordingIndicator.y = _loc2_ + 3;
         this.recordingTime.x = this.recordingIndicator.x + this.recordingIndicator.width + 6;
         this.recordingTime.y = _loc2_;
         this.videoProgressBar.x = this.recordingTime.x + 42;
         this.videoProgressBar.y = _loc2_ + 3;
         this.stageSizeButton.x = w - 4;
         this.stageSizeButton.y = h + 2;
         if(this.playButton)
         {
            this.playButton.scaleX = this.playButton.scaleY = app.stagePane.scaleX;
         }
      }
      
      private function addRecordingTools() : void
      {
         this.stopRecordingButton = new IconButton(app.stopVideo,"stopVideo");
         addChild(this.stopRecordingButton);
         this.videoProgressBar = new Shape();
         var _loc1_:int = CSS.overColor;
         var _loc2_:int = 12303807;
         var _loc3_:int = 10;
         var _loc4_:Graphics = this.videoProgressBar.graphics;
         _loc4_.clear();
         _loc4_.beginGradientFill(GradientType.LINEAR,[_loc1_,CSS.borderColor],[1,1],[0,0]);
         _loc4_.drawRoundRect(0,0,300,10,_loc3_,_loc3_);
         _loc4_.beginGradientFill(GradientType.LINEAR,[_loc1_,_loc2_],[1,1],[0,0]);
         _loc4_.drawRoundRect(0,0.5,300,9,9,9);
         _loc4_.endFill();
         addChild(this.videoProgressBar);
         var _loc5_:TextFormat = new TextFormat(CSS.font,11,CSS.textColor);
         addChild(this.recordingTime = makeLabel(" 0 secs",_loc5_));
         this.recordingIndicator = new Shape();
         var _loc6_:Graphics = this.recordingIndicator.graphics;
         _loc6_.clear();
         _loc6_.beginFill(16711680);
         _loc6_.drawRoundRect(0,0,10,10,_loc3_,_loc3_);
         _loc6_.endFill();
         addChild(this.recordingIndicator);
      }
      
      private function resetTime() : void
      {
         this.updateRecordingTools(0);
         removeChild(this.stopRecordingButton);
         this.stopRecordingButton = new IconButton(app.stopVideo,"stopVideo");
         addChild(this.stopRecordingButton);
         this.fixLayout();
      }
      
      public function removeRecordingTools() : void
      {
         this.stopRecordingButton.visible = false;
         this.videoProgressBar.visible = false;
         this.recordingTime.visible = false;
         this.recordingIndicator.visible = false;
      }
      
      public function updateRecordingTools(param1:Number = -1) : void
      {
         var _loc8_:String = null;
         var _loc9_:TextFormat = null;
         if(param1 < 0)
         {
            param1 = Number(this.lastTime);
         }
         var _loc2_:int = CSS.overColor;
         var _loc3_:int = CSS.tabColor;
         var _loc4_:Graphics = this.videoProgressBar.graphics;
         var _loc5_:int = 10;
         _loc4_.clear();
         var _loc6_:int = 300;
         if(app.stageIsContracted)
         {
            _loc6_ = 64;
         }
         var _loc7_:Matrix = new Matrix();
         _loc7_.createGradientBox(_loc6_,10,0,int(param1 / 60 * _loc6_),0);
         _loc4_.beginGradientFill(GradientType.LINEAR,[_loc2_,CSS.borderColor],[1,1],[0,0]);
         _loc4_.drawRoundRect(0,0,_loc6_,10,_loc5_,_loc5_);
         if(param1 == 0)
         {
            _loc4_.beginGradientFill(GradientType.LINEAR,[_loc2_,_loc3_],[1,1],[0,0]);
         }
         else
         {
            _loc4_.beginGradientFill(GradientType.LINEAR,[_loc2_,_loc3_],[1,1],[0,0],_loc7_);
         }
         _loc4_.drawRoundRect(0,0.5,_loc6_,9,9,9);
         _loc4_.endFill();
         if(this.lastTime != int(param1))
         {
            _loc8_ = "";
            if(int(param1) < 10)
            {
               _loc8_ += " ";
            }
            _loc8_ += int(param1).toString() + " secs";
            removeChild(this.recordingTime);
            _loc9_ = new TextFormat(CSS.font,11,CSS.textColor);
            addChild(this.recordingTime = makeLabel(_loc8_,_loc9_));
            this.lastTime = int(param1);
         }
         if(param1 != 0)
         {
            this.fixLayout();
            this.refresh();
            if(int(param1) % 2 == 0)
            {
               this.recordingIndicator.visible = false;
            }
         }
      }
      
      private function addTitleAndInfo() : void
      {
         var _loc1_:TextFormat = app.isOffline ? new TextFormat(CSS.font,16,CSS.textColor) : CSS.projectTitleFormat;
         this.projectTitle = this.getProjectTitle(_loc1_);
         addChild(this.projectTitle);
         addChild(this.projectInfo = makeLabel("",CSS.projectInfoFormat));
         var _loc2_:TextFormat = new TextFormat(CSS.font,9,9474192);
         addChild(this.versionInfo = makeLabel(Scratch.versionString,_loc2_));
      }
      
      protected function getProjectTitle(param1:TextFormat) : EditableLabel
      {
         return new EditableLabel(null,param1);
      }
      
      public function updateVersionInfo(param1:String) : void
      {
         this.versionInfo.text = param1;
      }
      
      private function addTurboIndicator() : void
      {
         this.turboIndicator = new TextField();
         this.turboIndicator.defaultTextFormat = new TextFormat(CSS.font,11,CSS.buttonLabelOverColor,true);
         this.turboIndicator.autoSize = TextFieldAutoSize.LEFT;
         this.turboIndicator.selectable = false;
         this.turboIndicator.text = Translator.map("Turbo Mode");
         this.turboIndicator.visible = false;
         addChild(this.turboIndicator);
      }
      
      private function addXYReadouts() : void
      {
         this.readouts = new Sprite();
         addChild(this.readouts);
         this.xLabel = makeLabel("x:",this.readoutLabelFormat);
         this.readouts.addChild(this.xLabel);
         this.xReadout = makeLabel("-888",this.readoutFormat);
         this.readouts.addChild(this.xReadout);
         this.yLabel = makeLabel("y:",this.readoutLabelFormat);
         this.readouts.addChild(this.yLabel);
         this.yReadout = makeLabel("-888",this.readoutFormat);
         this.readouts.addChild(this.yReadout);
      }
      
      protected function updateProjectInfo() : void
      {
         this.projectTitle.setEditable(false);
         this.projectInfo.text = "";
      }
      
      public function step() : void
      {
         this.updateRunStopButtons();
         if(app.editMode)
         {
            this.updateMouseReadout();
         }
      }
      
      private function updateRunStopButtons() : void
      {
         if(app.interp.threadCount() > 0)
         {
            this.threadStarted();
         }
         else if(this.runButtonOnTicks > 2)
         {
            this.runButton.turnOff();
            this.stopButton.turnOn();
         }
         ++this.runButtonOnTicks;
      }
      
      private function updateMouseReadout() : void
      {
         if(stage.mouseX != this.lastX)
         {
            this.lastX = app.stagePane.scratchMouseX();
            this.xReadout.text = String(this.lastX);
         }
         if(stage.mouseY != this.lastY)
         {
            this.lastY = app.stagePane.scratchMouseY();
            this.yReadout.text = String(this.lastY);
         }
      }
      
      public function threadStarted() : void
      {
         this.runButtonOnTicks = 0;
         this.runButton.turnOn();
         this.stopButton.turnOff();
         if(this.playButton)
         {
            this.hidePlayButton();
         }
      }
      
      private function addRunStopButtons() : void
      {
         var startAll:Function = null;
         var stopAll:Function = null;
         startAll = function(param1:IconButton):void
         {
            playButtonPressed(param1.lastEvent);
         };
         stopAll = function(param1:IconButton):void
         {
            app.runtime.stopAll();
         };
         this.runButton = new IconButton(startAll,"greenflag");
         this.runButton.actOnMouseUp();
         addChild(this.runButton);
         this.stopButton = new IconButton(stopAll,"stop");
         addChild(this.stopButton);
      }
      
      private function addFullScreenButton() : void
      {
         var toggleFullscreen:Function = null;
         toggleFullscreen = function(param1:IconButton):void
         {
            app.presentationModeWasChanged(param1.isOn());
            drawOutline();
         };
         this.fullscreenButton = new IconButton(toggleFullscreen,"fullscreen");
         this.fullscreenButton.disableMouseover();
         addChild(this.fullscreenButton);
      }
      
      private function addStageSizeButton() : void
      {
         var toggleStageSize:Function = null;
         toggleStageSize = function(param1:*):void
         {
            app.toggleSmallStage();
         };
         this.stageSizeButton = new Sprite();
         this.stageSizeButton.addEventListener(MouseEvent.MOUSE_DOWN,toggleStageSize);
         this.drawStageSizeButton();
         addChild(this.stageSizeButton);
      }
      
      private function drawStageSizeButton() : void
      {
         var _loc1_:Graphics = this.stageSizeButton.graphics;
         _loc1_.clear();
         _loc1_.lineStyle(1,CSS.borderColor);
         _loc1_.beginFill(CSS.tabColor);
         _loc1_.moveTo(10,0);
         _loc1_.lineTo(3,0);
         _loc1_.lineTo(0,3);
         _loc1_.lineTo(0,13);
         _loc1_.lineTo(3,15);
         _loc1_.lineTo(10,15);
         _loc1_.lineStyle();
         _loc1_.beginFill(CSS.arrowColor);
         if(app.stageIsContracted)
         {
            _loc1_.moveTo(3,3.5);
            _loc1_.lineTo(9,7.5);
            _loc1_.lineTo(3,12);
         }
         else
         {
            _loc1_.moveTo(8,3.5);
            _loc1_.lineTo(2,7.5);
            _loc1_.lineTo(8,12);
         }
         _loc1_.endFill();
      }
      
      private function showPlayButton() : void
      {
         var _loc1_:Bitmap = null;
         if(!this.playButton)
         {
            this.playButton = new Sprite();
            this.playButton.graphics.beginFill(0,0.3);
            this.playButton.graphics.drawRect(0,0,480,360);
            _loc1_ = Resources.createBmp("playerStartFlag");
            _loc1_.x = (480 - _loc1_.width) / 2;
            _loc1_.y = (360 - _loc1_.height) / 2;
            this.playButton.alpha = 0.9;
            this.playButton.addChild(_loc1_);
            this.playButton.addEventListener(MouseEvent.MOUSE_DOWN,this.stopEvent,false,9);
            this.playButton.addEventListener(MouseEvent.MOUSE_UP,this.playButtonPressed,false,9);
            this.addUserNameWarning();
         }
         this.playButton.scaleX = this.playButton.scaleY = app.stagePane.scaleX;
         this.playButton.x = app.stagePane.x;
         this.playButton.y = app.stagePane.y;
         addChild(this.playButton);
      }
      
      private function stopEvent(param1:Event) : void
      {
         if(param1)
         {
            param1.stopImmediatePropagation();
            param1.preventDefault();
         }
      }
      
      public function addUserNameWarning() : void
      {
         this.userNameWarning = new Sprite();
         var _loc1_:Graphics = this.userNameWarning.graphics;
         _loc1_.clear();
         _loc1_.beginFill(CSS.white);
         _loc1_.drawRoundRect(10,30,this.playButton.width - 20,70,15,15);
         _loc1_.endFill();
         this.userNameWarning.alpha = 0.9;
         var _loc2_:TextFormat = new TextFormat(CSS.font,16,0);
         var _loc3_:TextField = makeLabel(Translator.map("This project can detect who is using it, through the “username” block. To hide your identity, sign out before using the project."),_loc2_,15,45);
         _loc3_.width = this.userNameWarning.width - 10;
         _loc3_.multiline = true;
         _loc3_.wordWrap = true;
         this.userNameWarning.addChild(_loc3_);
         this.playButton.addChild(this.userNameWarning);
         this.userNameWarning.visible = false;
      }
      
      public function playButtonPressed(param1:MouseEvent) : void
      {
         if(app.loadInProgress)
         {
            this.stopEvent(param1);
            return;
         }
         SoundMixer.soundTransform = new SoundTransform(Boolean(param1) && param1.ctrlKey ? 0 : 1);
         if(Boolean(param1) && param1.shiftKey)
         {
            app.toggleTurboMode();
            return;
         }
         var _loc2_:Boolean = this.playButton != null;
         this.hidePlayButton();
         this.stopEvent(param1);
         app.runtime.startGreenFlags(_loc2_);
      }
      
      public function hidePlayButton() : void
      {
         if(this.playButton)
         {
            removeChild(this.playButton);
         }
         this.playButton = null;
      }
      
      private function mouseWheel(param1:MouseEvent) : void
      {
         param1.preventDefault();
         app.runtime.startKeyHats(param1.delta > 0 ? 30 : 31);
      }
   }
}

