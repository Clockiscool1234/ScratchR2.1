package scratch
{
   import assets.Resources;
   import blocks.Block;
   import blocks.BlockArg;
   import extensions.ExtensionManager;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.media.*;
   import flash.net.*;
   import flash.system.System;
   import flash.text.TextField;
   import flash.ui.Keyboard;
   import flash.utils.*;
   import interpreter.*;
   import leelib.util.flvEncoder.*;
   import logging.LogLevel;
   import primitives.VideoMotionPrims;
   import sound.ScratchSoundPlayer;
   import translation.*;
   import ui.BlockPalette;
   import ui.RecordingSpecEditor;
   import ui.SharingSpecEditor;
   import ui.media.MediaInfo;
   import uiwidgets.DialogBox;
   import util.*;
   import watchers.*;
   
   public class ScratchRuntime
   {
      
      private static const SCRATCH_ARROW_LEFT:int = 28;
      
      private static const SCRATCH_ARROW_RIGHT:int = 29;
      
      private static const SCRATCH_ARROW_UP:int = 30;
      
      private static const SCRATCH_ARROW_DOWN:int = 31;
      
      public var app:Scratch;
      
      public var interp:Interpreter;
      
      public var motionDetector:VideoMotionPrims;
      
      public var keyIsDown:Array = [];
      
      public var shiftIsDown:Boolean;
      
      public var lastAnswer:String = "";
      
      public var cloneCount:int;
      
      public var edgeTriggersEnabled:Boolean = false;
      
      public var currentDoObj:ScratchObj = null;
      
      private var microphone:Microphone;
      
      private var timerBase:uint;
      
      protected var projectToInstall:ScratchStage;
      
      protected var saveAfterInstall:Boolean;
      
      public var recording:Boolean;
      
      private var videoFrames:Array = [];
      
      private var videoSounds:Array = [];
      
      private var videoTimer:Timer;
      
      private var baFlvEncoder:ByteArrayFlvEncoder;
      
      private var videoPosition:int;
      
      private var videoSeconds:Number;
      
      private var videoAlreadyDone:int;
      
      private var projectSound:Boolean;
      
      private var micSound:Boolean;
      
      private var showCursor:Boolean;
      
      public var fullEditor:Boolean;
      
      private var videoFramerate:Number;
      
      private var videoWidth:int;
      
      private var videoHeight:int;
      
      public var ready:int = -1;
      
      private var micBytes:ByteArray;
      
      private var micPosition:int = 0;
      
      private var mic:Microphone;
      
      private var micReady:Boolean;
      
      private var timeout:int;
      
      protected var triggeredHats:Array = [];
      
      protected var activeHats:Array = [];
      
      protected var waitingHats:Array = [];
      
      private var lastDelete:Array;
      
      public function ScratchRuntime(param1:Scratch, param2:Interpreter)
      {
         super();
         this.app = param1;
         this.interp = param2;
         this.timerBase = param2.currentMSecs;
         this.clearKeyDownArray();
      }
      
      private static function getKeyCodeFromEvent(param1:KeyboardEvent) : int
      {
         var _loc2_:int = int(param1.charCode);
         if(_loc2_ == 0)
         {
            switch(param1.keyCode)
            {
               case Keyboard.LEFT:
                  return SCRATCH_ARROW_LEFT;
               case Keyboard.RIGHT:
                  return SCRATCH_ARROW_RIGHT;
               case Keyboard.UP:
                  return SCRATCH_ARROW_UP;
               case Keyboard.DOWN:
                  return SCRATCH_ARROW_DOWN;
            }
         }
         return String.fromCharCode(_loc2_).toLowerCase().charCodeAt(0);
      }
      
      public static function getKeyCode(param1:String) : int
      {
         switch(param1)
         {
            case "left arrow":
               return SCRATCH_ARROW_LEFT;
            case "right arrow":
               return SCRATCH_ARROW_RIGHT;
            case "up arrow":
               return SCRATCH_ARROW_UP;
            case "down arrow":
               return SCRATCH_ARROW_DOWN;
            case "space":
               return Keyboard.SPACE;
            default:
               return param1.charCodeAt(0);
         }
      }
      
      public static function getKeyName(param1:int) : String
      {
         switch(param1)
         {
            case SCRATCH_ARROW_LEFT:
               return "left arrow";
            case SCRATCH_ARROW_RIGHT:
               return "right arrow";
            case SCRATCH_ARROW_UP:
               return "up arrow";
            case SCRATCH_ARROW_DOWN:
               return "down arrow";
            case Keyboard.SPACE:
               return "space";
            default:
               return String.fromCharCode(param1);
         }
      }
      
      public function stepRuntime() : void
      {
         var _loc1_:Number = NaN;
         var _loc2_:int = 0;
         var _loc3_:Number = NaN;
         if(this.projectToInstall != null && (this.app.isOffline || this.app.isExtensionDevMode))
         {
            this.installProject(this.projectToInstall);
            if(this.saveAfterInstall)
            {
               this.app.setSaveNeeded(true);
            }
            this.projectToInstall = null;
            this.saveAfterInstall = false;
            return;
         }
         if(this.ready == ReadyLabel.COUNTDOWN)
         {
            _loc1_ = CachedTimer.getCachedTimer() * 0.001 - this.videoSeconds;
            while(_loc3_ > this.videoSounds.length / this.videoFramerate + 1 / this.videoFramerate)
            {
               this.saveSound();
            }
            _loc2_ = 3;
            if(_loc1_ >= 3.75)
            {
               this.ready = ReadyLabel.READY;
               _loc2_ = 1;
               this.videoSounds = [];
               this.videoFrames = [];
               if(this.fullEditor)
               {
                  Scratch.app.log(LogLevel.TRACK,"Editor video started",{"projectID":this.app.projectID});
               }
               else
               {
                  Scratch.app.log(LogLevel.TRACK,"Project video started",{"projectID":this.app.projectID});
               }
            }
            else if(_loc1_ >= 2.5)
            {
               _loc2_ = 1;
            }
            else if(_loc1_ >= 1.25 && this.micReady)
            {
               _loc2_ = 2;
            }
            else if(_loc1_ >= 1.25)
            {
               this.videoSeconds += _loc1_;
            }
            else
            {
               this.app.refreshStagePart();
            }
         }
         if(this.recording)
         {
            _loc3_ = CachedTimer.getCachedTimer() * 0.001 - this.videoSeconds;
            if(_loc3_ > this.videoSounds.length / this.videoFramerate + 1 / this.videoFramerate)
            {
               if(this.fullEditor)
               {
                  this.app.removeRecordingTools();
               }
               this.saveFrame();
               this.app.updateRecordingTools(_loc3_);
            }
            else
            {
               this.app.updateRecordingTools(_loc3_);
               if(this.videoFrames.length > this.videoPosition && (this.videoFrames.length % 2 == 0 || this.videoFrames.length % 3 == 0))
               {
                  this.baFlvEncoder.addFrame(this.videoFrames[this.videoPosition],this.videoSounds[this.videoPosition]);
                  this.videoFrames[this.videoPosition] = null;
                  this.videoSounds[this.videoPosition] = null;
                  ++this.videoPosition;
               }
            }
            if(this.videoFrames.length > this.videoPosition && this.videoFramerate == 30)
            {
               this.baFlvEncoder.addFrame(this.videoFrames[this.videoPosition],this.videoSounds[this.videoPosition]);
               this.videoFrames[this.videoPosition] = null;
               this.videoSounds[this.videoPosition] = null;
               ++this.videoPosition;
            }
         }
         this.app.extensionManager.step();
         if(this.motionDetector)
         {
            this.motionDetector.step();
         }
         this.app.stagePane.step(this);
         this.processEdgeTriggeredHats();
         this.interp.stepThreads();
         this.app.stagePane.commitPenStrokes();
         if(this.ready == ReadyLabel.COUNTDOWN || this.ready == ReadyLabel.READY)
         {
            this.app.stagePane.countdown(_loc2_);
         }
      }
      
      private function saveFrame() : void
      {
         var _loc2_:BitmapData = null;
         var _loc3_:DisplayObject = null;
         var _loc4_:Bitmap = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:Matrix = null;
         var _loc9_:Number = NaN;
         var _loc10_:BitmapData = null;
         var _loc11_:Number = NaN;
         var _loc12_:BitmapData = null;
         this.saveSound();
         var _loc1_:Number = CachedTimer.getCachedTimer() * 0.001 - this.videoSeconds;
         while(_loc1_ > this.videoSounds.length / this.videoFramerate + 1 / this.videoFramerate)
         {
            this.saveSound();
         }
         if(this.showCursor)
         {
            _loc3_ = Resources.createDO("videoCursor");
         }
         if(this.showCursor && this.app.gh.mouseIsDown)
         {
            _loc4_ = Resources.createBmp("mouseCircle");
         }
         if(this.fullEditor)
         {
            _loc5_ = this.app.stage.stageWidth;
            _loc6_ = this.app.stage.stageHeight;
            if(!Scratch.app.isIn3D)
            {
               if(this.app.stagePane.videoImage)
               {
                  this.app.stagePane.videoImage.visible = false;
               }
            }
            if(this.videoWidth != _loc5_ || this.videoHeight != _loc6_)
            {
               _loc7_ = 1;
               _loc7_ = this.videoWidth / _loc5_ > this.videoHeight / _loc6_ ? this.videoHeight / _loc6_ : this.videoWidth / _loc5_;
               _loc8_ = new Matrix();
               _loc8_.scale(_loc7_,_loc7_);
               _loc2_ = new BitmapData(this.videoWidth,this.videoHeight,false);
               _loc2_.draw(this.app.stage,_loc8_,null,null,new Rectangle(0,0,_loc5_ * _loc7_,_loc6_ * _loc7_),false);
               if(Scratch.app.isIn3D)
               {
                  _loc9_ = _loc7_;
                  if(!this.app.editMode)
                  {
                     _loc9_ *= this.app.presentationScale;
                  }
                  else if(this.app.stageIsContracted)
                  {
                     _loc9_ *= 0.5;
                  }
                  _loc10_ = this.app.stagePane.saveScreenData();
                  _loc2_.draw(_loc10_,new Matrix(_loc9_,0,0,_loc9_,this.app.stagePane.localToGlobal(new Point(0,0)).x * _loc7_,this.app.stagePane.localToGlobal(new Point(0,0)).y * _loc7_));
               }
               else if(this.app.stagePane.videoImage)
               {
                  this.app.stagePane.videoImage.visible = true;
               }
               if(this.showCursor && this.app.gh.mouseIsDown)
               {
                  _loc2_.draw(_loc4_,new Matrix(_loc7_,0,0,_loc7_,(this.app.stage.mouseX - _loc4_.width / 2) * _loc7_,(this.app.stage.mouseY - _loc4_.height / 2) * _loc7_));
               }
               if(this.showCursor)
               {
                  _loc2_.draw(_loc3_,new Matrix(_loc7_,0,0,_loc7_,this.app.stage.mouseX * _loc7_,this.app.stage.mouseY * _loc7_));
               }
            }
            else
            {
               _loc2_ = new BitmapData(this.videoWidth,this.videoHeight,false);
               _loc2_.draw(this.app.stage);
               if(Scratch.app.isIn3D)
               {
                  _loc11_ = 1;
                  if(!this.app.editMode)
                  {
                     _loc11_ *= this.app.presentationScale;
                  }
                  else if(this.app.stageIsContracted)
                  {
                     _loc11_ *= 0.5;
                  }
                  _loc12_ = this.app.stagePane.saveScreenData();
                  if(_loc11_ == 1)
                  {
                     _loc2_.copyPixels(_loc12_,_loc12_.rect,new Point(this.app.stagePane.localToGlobal(new Point(0,0)).x,this.app.stagePane.localToGlobal(new Point(0,0)).y));
                  }
                  else
                  {
                     _loc2_.draw(_loc12_,new Matrix(_loc11_,0,0,_loc11_,this.app.stagePane.localToGlobal(new Point(0,0)).x,this.app.stagePane.localToGlobal(new Point(0,0)).y));
                  }
               }
               else if(this.app.stagePane.videoImage)
               {
                  this.app.stagePane.videoImage.visible = true;
               }
               if(this.showCursor && this.app.gh.mouseIsDown)
               {
                  _loc2_.copyPixels(_loc4_.bitmapData,_loc4_.bitmapData.rect,new Point(this.app.stage.mouseX - _loc4_.width / 2,this.app.stage.mouseY - _loc4_.height / 2));
               }
               if(this.showCursor)
               {
                  _loc2_.draw(_loc3_,new Matrix(1,0,0,1,this.app.stage.mouseX,this.app.stage.mouseY));
               }
            }
         }
         else
         {
            _loc2_ = this.app.stagePane.saveScreenData();
            if(this.showCursor && this.app.gh.mouseIsDown)
            {
               _loc2_.copyPixels(_loc4_.bitmapData,_loc4_.bitmapData.rect,new Point(this.app.stagePane.mouseX - _loc4_.width / 2,this.app.stagePane.mouseY - _loc4_.height / 2));
            }
            if(this.showCursor)
            {
               _loc2_.draw(_loc3_,new Matrix(1,0,0,1,this.app.stagePane.scratchMouseX() + 240,-this.app.stagePane.scratchMouseY() + 180));
            }
         }
         while(this.videoSounds.length > this.videoFrames.length)
         {
            this.videoFrames.push(_loc2_);
         }
      }
      
      private function saveSound() : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:ScratchSoundPlayer = null;
         var _loc7_:int = 0;
         var _loc1_:Array = [];
         if(this.micSound && this.micBytes.length > 0)
         {
            this.micBytes.position = this.micPosition;
            while(this.micBytes.length > this.micBytes.position && _loc1_.length <= this.baFlvEncoder.audioFrameSize / 4)
            {
               _loc1_.push(this.micBytes.readFloat());
            }
            this.micPosition = this.micBytes.position;
            this.micBytes.position = this.micBytes.length;
         }
         while(_loc1_.length <= this.baFlvEncoder.audioFrameSize / 4)
         {
            _loc1_.push(0);
         }
         if(this.projectSound)
         {
            _loc4_ = 0;
            while(_loc4_ < ScratchSoundPlayer.activeSounds.length)
            {
               _loc5_ = 0;
               _loc6_ = ScratchSoundPlayer.activeSounds[_loc4_];
               _loc6_.dataBytes.position = _loc6_.readPosition;
               while(_loc5_ < _loc1_.length && _loc6_.dataBytes.position < _loc6_.dataBytes.length)
               {
                  _loc1_[_loc5_] += _loc6_.dataBytes.readFloat();
                  if(_loc4_ == ScratchSoundPlayer.activeSounds.length - 1)
                  {
                     if(_loc1_[_loc5_] < -1 || _loc1_[_loc5_] > 1)
                     {
                        _loc7_ = _loc4_ + 1 + int(this.micSound);
                        _loc1_[_loc5_] /= _loc7_;
                     }
                  }
                  _loc5_++;
               }
               _loc6_.readPosition = _loc6_.dataBytes.position;
               _loc6_.dataBytes.position = _loc6_.dataBytes.length;
               _loc4_++;
            }
         }
         var _loc2_:ByteArray = new ByteArray();
         for each(_loc3_ in _loc1_)
         {
            _loc2_.writeFloat(_loc3_);
         }
         _loc1_ = null;
         this.videoSounds.push(_loc2_);
         _loc2_ = null;
      }
      
      private function micSampleDataHandler(param1:SampleDataEvent) : void
      {
         var _loc2_:Number = NaN;
         while(param1.data.bytesAvailable)
         {
            _loc2_ = param1.data.readFloat();
            this.micBytes.writeFloat(_loc2_);
            this.micBytes.writeFloat(_loc2_);
         }
      }
      
      public function startVideo(param1:RecordingSpecEditor) : void
      {
         var _loc2_:Number = NaN;
         this.projectSound = param1.soundFlag();
         this.micSound = param1.microphoneFlag();
         this.fullEditor = param1.editorFlag();
         this.showCursor = param1.cursorFlag();
         this.videoFramerate = !param1.fifteenFlag() ? 15 : 30;
         if(this.fullEditor)
         {
            this.videoFramerate = 10;
         }
         this.micReady = true;
         if(this.micSound)
         {
            this.mic = Microphone.getMicrophone();
            this.mic.setSilenceLevel(0);
            this.mic.gain = param1.getMicVolume();
            this.mic.rate = 44;
            this.micReady = false;
         }
         if(this.fullEditor)
         {
            if(this.app.stage.stageWidth < 960 && this.app.stage.stageHeight < 640)
            {
               this.videoWidth = this.app.stage.stageWidth;
               this.videoHeight = this.app.stage.stageHeight;
            }
            else
            {
               _loc2_ = this.app.stage.stageWidth / this.app.stage.stageHeight;
               if(960 / _loc2_ < 640)
               {
                  this.videoWidth = 960;
                  this.videoHeight = 960 / _loc2_;
               }
               else
               {
                  this.videoWidth = 640 * _loc2_;
                  this.videoHeight = 640;
               }
            }
         }
         else
         {
            this.videoWidth = 480;
            this.videoHeight = 360;
         }
         this.ready = ReadyLabel.COUNTDOWN;
         this.videoSeconds = CachedTimer.getCachedTimer() * 0.001;
         this.baFlvEncoder = new ByteArrayFlvEncoder(this.videoFramerate);
         this.baFlvEncoder.setVideoProperties(this.videoWidth,this.videoHeight);
         this.baFlvEncoder.setAudioProperties(FlvEncoder.SAMPLERATE_44KHZ,true,true,true);
         this.baFlvEncoder.start();
         this.waitAndStart();
      }
      
      public function exportToVideo() : void
      {
         var specEditor:RecordingSpecEditor = null;
         var startCountdown:Function = null;
         startCountdown = function():void
         {
            startVideo(specEditor);
         };
         specEditor = new RecordingSpecEditor();
         DialogBox.close("Record Project Video",null,specEditor,"Start",this.app.stage,startCountdown);
      }
      
      public function stopVideo() : void
      {
         if(this.recording)
         {
            this.videoTimer.dispatchEvent(new TimerEvent(TimerEvent.TIMER));
         }
         else if(this.ready == ReadyLabel.COUNTDOWN || Boolean(ReadyLabel.READY))
         {
            this.ready = ReadyLabel.NOT_READY;
            this.app.refreshStagePart();
            this.app.stagePane.countdown(0);
         }
      }
      
      public function finishVideoExport(param1:TimerEvent) : void
      {
         this.stopRecording();
         this.stopAll();
         this.app.addLoadProgressBox("Writing video to file...");
         this.videoAlreadyDone = this.videoPosition;
         clearTimeout(this.timeout);
         this.timeout = setTimeout(this.saveRecording,1);
      }
      
      public function waitAndStart() : void
      {
         var _loc1_:ScratchSoundPlayer = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(!this.micReady && !this.mic.hasEventListener(StatusEvent.STATUS))
         {
            this.micBytes = new ByteArray();
            this.mic.addEventListener(SampleDataEvent.SAMPLE_DATA,this.micSampleDataHandler);
            this.micReady = true;
         }
         if(this.ready == ReadyLabel.COUNTDOWN || this.ready == ReadyLabel.NOT_READY)
         {
            if(this.ready == ReadyLabel.NOT_READY)
            {
               this.baFlvEncoder = null;
               return;
            }
            clearTimeout(this.timeout);
            this.timeout = setTimeout(this.waitAndStart,1);
            return;
         }
         this.app.stagePane.countdown(0);
         this.ready = ReadyLabel.NOT_READY;
         this.app.refreshStagePart();
         this.videoSeconds = CachedTimer.getCachedTimer() * 0.001;
         for each(_loc1_ in ScratchSoundPlayer.activeSounds)
         {
            _loc2_ = int(_loc1_.soundChannel.position * 0.001 * this.videoFramerate);
            _loc1_.readPosition = Math.max(Math.min(this.baFlvEncoder.audioFrameSize * _loc2_,_loc1_.dataBytes.length),0);
         }
         this.clearRecording();
         this.recording = true;
         _loc3_ = 60;
         this.videoTimer = new Timer(1000 * _loc3_,1);
         this.videoTimer.addEventListener(TimerEvent.TIMER,this.finishVideoExport);
         this.videoTimer.start();
      }
      
      public function stopRecording() : void
      {
         this.recording = false;
         this.videoTimer.stop();
         this.videoTimer.removeEventListener(TimerEvent.TIMER,this.finishVideoExport);
         this.videoTimer = null;
         this.app.refreshStagePart();
      }
      
      public function clearRecording() : void
      {
         this.recording = false;
         this.videoFrames = [];
         this.videoSounds = [];
         this.micBytes = new ByteArray();
         this.micPosition = 0;
         this.videoPosition = 0;
         System.gc();
         this.ready = ReadyLabel.NOT_READY;
      }
      
      public function saveRecording() : void
      {
         var seconds:Number = NaN;
         var video:ByteArray = null;
         var saveFile:Function = null;
         var releaseVideo:Function = null;
         var b:int = 0;
         saveFile = function():void
         {
            var _loc1_:FileReference = new FileReference();
            _loc1_.save(video,"movie.flv");
            Scratch.app.log(LogLevel.TRACK,"Video downloaded",{
               "projectID":app.projectID,
               "seconds":roundToTens(seconds),
               "megabytes":roundToTens(video.length / 1000000)
            });
            var _loc2_:SharingSpecEditor = new SharingSpecEditor();
            DialogBox.close("Playing and Sharing Your Video",null,_loc2_,"Back to Scratch");
            releaseVideo(false);
         };
         releaseVideo = function(param1:Boolean = true):void
         {
            if(param1)
            {
               Scratch.app.log(LogLevel.TRACK,"Video canceled",{
                  "projectID":app.projectID,
                  "seconds":roundToTens(seconds),
                  "megabytes":roundToTens(video.length / 1000000)
               });
            }
            video = null;
         };
         if(this.videoFrames.length > this.videoPosition)
         {
            b = 0;
            while(b < 20)
            {
               if(this.videoPosition >= this.videoFrames.length)
               {
                  break;
               }
               this.baFlvEncoder.addFrame(this.videoFrames[this.videoPosition],this.videoSounds[this.videoPosition]);
               this.videoFrames[this.videoPosition] = null;
               this.videoSounds[this.videoPosition] = null;
               ++this.videoPosition;
               b++;
            }
            if(this.app.lp)
            {
               this.app.lp.setProgress(Math.min((this.videoPosition - this.videoAlreadyDone) / (this.videoFrames.length - this.videoAlreadyDone),1));
            }
            clearTimeout(this.timeout);
            this.timeout = setTimeout(this.saveRecording,1);
            return;
         }
         seconds = this.videoFrames.length / this.videoFramerate;
         this.app.removeLoadProgressBox();
         this.baFlvEncoder.updateDurationMetadata();
         if(this.micSound)
         {
            this.mic.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.micSampleDataHandler);
            this.mic = null;
         }
         this.videoFrames = [];
         this.videoSounds = [];
         this.micBytes = null;
         this.micPosition = 0;
         video = this.baFlvEncoder.byteArray;
         this.baFlvEncoder.kill();
         DialogBox.close("Video Finished!","To save, click the button below.",null,"Save and Download",this.app.stage,saveFile,releaseVideo,null,true);
      }
      
      private function roundToTens(param1:Number) : Number
      {
         return int(param1 * 10) / 10;
      }
      
      public function stopAll() : void
      {
         var _loc1_:ScratchSprite = null;
         this.interp.stopAllThreads();
         this.clearRunFeedback();
         this.app.stagePane.deleteClones();
         this.cloneCount = 0;
         this.clearKeyDownArray();
         ScratchSoundPlayer.stopAllSounds();
         this.app.extensionManager.stopButtonPressed();
         this.app.stagePane.clearFilters();
         for each(_loc1_ in this.app.stagePane.sprites())
         {
            _loc1_.clearFilters();
            _loc1_.hideBubble();
         }
         this.app.removeLoadProgressBox();
         this.motionDetector = null;
      }
      
      public function startGreenFlags(param1:Boolean = false) : void
      {
         var startIfGreenFlag:Function = null;
         var firstTime:Boolean = param1;
         startIfGreenFlag = function(param1:Block, param2:ScratchObj):void
         {
            if(param1.op == "whenGreenFlag")
            {
               interp.toggleThread(param1,param2);
            }
         };
         this.stopAll();
         this.lastAnswer = "";
         if(firstTime && Boolean(this.app.stagePane.info.videoOn))
         {
            this.app.stagePane.setVideoState("on");
         }
         this.clearEdgeTriggeredHats();
         this.timerReset();
         setTimeout(function():void
         {
            allStacksAndOwnersDo(startIfGreenFlag);
         },0);
      }
      
      public function startClickedHats(param1:ScratchObj) : void
      {
         var _loc2_:Block = null;
         for each(_loc2_ in param1.scripts)
         {
            if(_loc2_.op == "whenClicked")
            {
               this.interp.restartThread(_loc2_,param1);
            }
         }
      }
      
      public function startKeyHats(param1:int) : void
      {
         var keyName:String = null;
         var startMatchingKeyHats:Function = null;
         var ch:int = param1;
         startMatchingKeyHats = function(param1:Block, param2:ScratchObj):void
         {
            var _loc3_:String = null;
            if(param1.op == "whenKeyPressed")
            {
               _loc3_ = param1.args[0].argValue;
               if(_loc3_ == "any" || _loc3_ == keyName)
               {
                  if(!interp.isRunning(param1,param2))
                  {
                     interp.toggleThread(param1,param2);
                  }
               }
            }
         };
         keyName = getKeyName(ch);
         this.allStacksAndOwnersDo(startMatchingKeyHats);
      }
      
      public function collectBroadcasts() : Array
      {
         var palette:BlockPalette;
         var i:int;
         var addBlock:Function = null;
         var result:Array = null;
         var b:Block = null;
         addBlock = function(param1:Block):void
         {
            var _loc2_:String = null;
            if(param1.op == "broadcast:" || param1.op == "doBroadcastAndWait" || param1.op == "whenIReceive")
            {
               if(param1.args[0] is BlockArg)
               {
                  _loc2_ = param1.args[0].argValue;
                  if(result.indexOf(_loc2_) < 0)
                  {
                     result.push(_loc2_);
                  }
               }
            }
         };
         result = [];
         this.allStacksAndOwnersDo(function(param1:Block, param2:ScratchObj):void
         {
            param1.allBlocksDo(addBlock);
         });
         palette = this.app.palette;
         i = 0;
         while(i < palette.numChildren)
         {
            b = palette.getChildAt(i) as Block;
            if(b)
            {
               addBlock(b);
            }
            i++;
         }
         if(result.length > 0)
         {
            result.sort();
            return result;
         }
         return [Translator.map("message1")];
      }
      
      public function hasUnofficialExtensions() : Boolean
      {
         var found:Boolean = false;
         found = false;
         this.allStacksAndOwnersDo(function(param1:Block, param2:ScratchObj):void
         {
            var stack:Block = param1;
            var target:ScratchObj = param2;
            if(found)
            {
               return;
            }
            stack.allBlocksDo(function(param1:Block):void
            {
               if(found)
               {
                  return;
               }
               if(isUnofficialExtensionBlock(param1))
               {
                  found = true;
               }
            });
         });
         return found;
      }
      
      private function isUnofficialExtensionBlock(param1:Block) : Boolean
      {
         var _loc2_:String = ExtensionManager.unpackExtensionName(param1.op);
         return Boolean(_loc2_) && !this.app.extensionManager.isInternal(_loc2_);
      }
      
      public function hasGraphicEffects() : Boolean
      {
         var found:Boolean = false;
         found = false;
         this.allStacksAndOwnersDo(function(param1:Block, param2:ScratchObj):void
         {
            var stack:Block = param1;
            var target:ScratchObj = param2;
            if(found)
            {
               return;
            }
            stack.allBlocksDo(function(param1:Block):void
            {
               if(found)
               {
                  return;
               }
               if(isGraphicEffectBlock(param1))
               {
                  found = true;
               }
            });
         });
         return found;
      }
      
      private function isGraphicEffectBlock(param1:Block) : Boolean
      {
         return "op" in param1 && (param1.op == "changeGraphicEffect:by:" || param1.op == "setGraphicEffect:to:") && "argValue" in param1.args[0] && param1.args[0].argValue != "ghost" && param1.args[0].argValue != "brightness";
      }
      
      private function clearEdgeTriggeredHats() : void
      {
         this.edgeTriggersEnabled = true;
         this.triggeredHats = [];
      }
      
      protected function startEdgeTriggeredHats(param1:Block, param2:ScratchObj) : void
      {
         var _loc3_:String = null;
         var _loc4_:Number = NaN;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:uint = 0;
         var _loc9_:Array = null;
         var _loc10_:uint = 0;
         if(!param1.isHat || !param1.nextBlock)
         {
            return;
         }
         if("whenSensorGreaterThan" == param1.op)
         {
            _loc3_ = this.interp.arg(param1,0);
            _loc4_ = this.interp.numarg(param1,1);
            if("loudness" == _loc3_ && this.soundLevel() > _loc4_ || "timer" == _loc3_ && this.timer() > _loc4_ || "video motion" == _loc3_ && param2.visible && VideoMotionPrims.readMotionSensor("motion",param2) > _loc4_)
            {
               if(this.triggeredHats.indexOf(param1) == -1)
               {
                  if(!this.interp.isRunning(param1,param2))
                  {
                     this.interp.toggleThread(param1,param2);
                  }
               }
               this.activeHats.push(param1);
            }
         }
         else if("whenSensorConnected" == param1.op)
         {
            if(this.getBooleanSensor(this.interp.arg(param1,0)))
            {
               if(this.triggeredHats.indexOf(param1) == -1)
               {
                  if(!this.interp.isRunning(param1,param2))
                  {
                     this.interp.toggleThread(param1,param2);
                  }
               }
               this.activeHats.push(param1);
            }
         }
         else if(this.app.jsEnabled)
         {
            _loc5_ = ExtensionManager.unpackExtensionAndOp(param1.op);
            _loc6_ = _loc5_[0];
            if(Boolean(_loc6_) && this.app.extensionManager.extensionActive(_loc6_))
            {
               _loc7_ = _loc5_[1];
               _loc8_ = param1.args.length;
               _loc9_ = new Array(_loc8_);
               _loc10_ = 0;
               while(_loc10_ < _loc8_)
               {
                  _loc9_[_loc10_] = this.interp.arg(param1,_loc10_);
                  _loc10_++;
               }
               this.processExtensionReporter(param1,param2,_loc6_,_loc7_,_loc9_);
            }
         }
      }
      
      private function processExtensionReporter(param1:Block, param2:ScratchObj, param3:String, param4:String, param5:Array) : void
      {
         var triggerHatBlock:Function = null;
         var hat:Block = param1;
         var target:ScratchObj = param2;
         var extName:String = param3;
         var op:String = param4;
         var finalArgs:Array = param5;
         triggerHatBlock = function(param1:Boolean):void
         {
            if(param1)
            {
               if(triggeredHats.indexOf(hat) == -1)
               {
                  if(!interp.isRunning(hat,target))
                  {
                     interp.toggleThread(hat,target);
                  }
               }
               activeHats.push(hat);
            }
         };
         if(!hat.isAsyncHat)
         {
            this.app.externalCall("ScratchExtensions.getReporter",triggerHatBlock,extName,op,finalArgs);
         }
         else
         {
            if(hat.requestState == 0)
            {
               if(!this.interp.isRunning(hat,target))
               {
                  this.interp.toggleThread(hat,target,0,true);
               }
            }
            if(this.triggeredHats.indexOf(hat) >= 0)
            {
               this.activeHats.push(hat);
            }
         }
      }
      
      public function waitingHatFired(param1:Block, param2:Boolean) : Boolean
      {
         if(param2)
         {
            if(this.activeHats.indexOf(param1) < 0)
            {
               param1.showRunFeedback();
               if(param1.forceAsync)
               {
                  this.activeHats.push(param1);
               }
               return true;
            }
         }
         else
         {
            this.activeHats.splice(this.activeHats.indexOf(param1),1);
            this.triggeredHats.splice(this.triggeredHats.indexOf(param1),1);
         }
         return false;
      }
      
      private function processEdgeTriggeredHats() : void
      {
         if(!this.edgeTriggersEnabled)
         {
            return;
         }
         this.activeHats = [];
         this.allStacksAndOwnersDo(this.startEdgeTriggeredHats,true);
         this.triggeredHats = this.activeHats;
      }
      
      public function blockDropped(param1:Block) : void
      {
         var stack:Block = param1;
         stack.allBlocksDo(function(param1:Block):void
         {
            var _loc2_:String = param1.op;
            if(_loc2_ == Specs.GET_PARAM)
            {
               param1.parameterIndex = -1;
            }
            if("senseVideoMotion" == _loc2_ || "whenSensorGreaterThan" == _loc2_ && "video motion" == interp.arg(param1,0))
            {
               app.libraryPart.showVideoButton();
            }
            if(isGraphicEffectBlock(param1))
            {
               app.go3D();
            }
         });
      }
      
      public function installEmptyProject() : void
      {
         this.app.saveForRevert(null,true);
         this.app.oldWebsiteURL = "";
         this.installProject(new ScratchStage());
      }
      
      public function installNewProject() : void
      {
         this.installEmptyProject();
      }
      
      public function selectProjectFile() : void
      {
         var fileName:String = null;
         var data:ByteArray = null;
         var fileLoadHandler:Function = null;
         var doInstall:Function = null;
         var filter:FileFilter = null;
         fileLoadHandler = function(param1:Event):void
         {
            var _loc2_:FileReference = FileReference(param1.target);
            fileName = _loc2_.name;
            data = _loc2_.data;
            if(app.stagePane.isEmpty())
            {
               doInstall();
            }
            else
            {
               DialogBox.confirm("Replace contents of the current project?",app.stage,doInstall);
            }
         };
         doInstall = function(param1:* = null):void
         {
            installProjectFromFile(fileName,data);
         };
         this.stopAll();
         if(Scratch.app.isExtensionDevMode)
         {
            filter = new FileFilter("ScratchX Project","*.sbx;*.sb;*.sb2");
         }
         else
         {
            filter = new FileFilter("Scratch Project","*.sb;*.sb2");
         }
         Scratch.loadSingleFile(fileLoadHandler,filter);
      }
      
      public function installProjectFromFile(param1:String, param2:ByteArray) : void
      {
         this.stopAll();
         this.app.oldWebsiteURL = "";
         this.app.loadInProgress = true;
         this.installProjectFromData(param2);
         this.app.setProjectName(param1);
      }
      
      public function installProjectFromData(param1:ByteArray, param2:Boolean = true) : void
      {
         var newProject:ScratchStage = null;
         var info:Object = null;
         var objTable:Array = null;
         var reader:ObjReader = null;
         var data:ByteArray = param1;
         var saveForRevert:Boolean = param2;
         this.stopAll();
         data.position = 0;
         if(data.length < 8 || data.readUTFBytes(8) != "ScratchV")
         {
            data.position = 0;
            newProject = new ProjectIO(this.app).decodeProjectFromZipFile(data);
            if(!newProject)
            {
               this.projectLoadFailed();
               return;
            }
         }
         else
         {
            data.position = 0;
            reader = new ObjReader(data);
            try
            {
               info = reader.readInfo();
            }
            catch(e:Error)
            {
               data.position = 0;
            }
            try
            {
               objTable = reader.readObjTable();
            }
            catch(e:Error)
            {
            }
            if(!objTable)
            {
               this.projectLoadFailed();
               return;
            }
            newProject = new OldProjectReader().extractProject(objTable);
            newProject.info = info;
            if(info != null)
            {
               delete info.thumbnail;
            }
         }
         if(saveForRevert)
         {
            this.app.saveForRevert(data,false);
         }
         this.app.extensionManager.clearImportedExtensions();
         this.decodeImagesAndInstall(newProject);
      }
      
      public function projectLoadFailed(param1:* = null) : void
      {
         this.app.removeLoadProgressBox();
         this.app.loadProjectFailed();
      }
      
      public function decodeImagesAndInstall(param1:ScratchStage) : void
      {
         var imagesDecoded:Function = null;
         var newProject:ScratchStage = param1;
         imagesDecoded = function():void
         {
            projectToInstall = newProject;
         };
         new ProjectIO(this.app).decodeAllImages(newProject.allObjects(),imagesDecoded);
      }
      
      protected function installProject(param1:ScratchStage) : void
      {
         var obj:ScratchObj = null;
         var allSprites:Array = null;
         var spr:ScratchSprite = null;
         var project:ScratchStage = param1;
         if(this.app.stagePane != null)
         {
            this.stopAll();
         }
         if(this.app.scriptsPane)
         {
            this.app.scriptsPane.viewScriptsFor(null);
         }
         if(this.app.isIn3D)
         {
            this.app.render3D.setStage(project,project.penLayer);
         }
         for each(obj in project.allObjects())
         {
            obj.showCostume(obj.currentCostumeIndex);
            if(Scratch.app.isIn3D)
            {
               obj.updateCostume();
            }
            spr = obj as ScratchSprite;
            if(spr)
            {
               spr.setDirection(spr.direction);
            }
         }
         this.app.resetPlugin(function():void
         {
            app.extensionManager.clearImportedExtensions();
            app.extensionManager.loadSavedExtensions(project.info.savedExtensions);
         });
         this.app.installStage(project);
         this.app.updateSpriteLibrary(true);
         allSprites = this.app.stagePane.sprites();
         if(allSprites.length > 0)
         {
            allSprites = allSprites.sortOn("indexInLibrary");
            this.app.selectSprite(allSprites[0]);
         }
         else
         {
            this.app.selectSprite(this.app.stagePane);
         }
         this.app.extensionManager.step();
         this.app.projectLoaded();
         this.checkForGraphicEffects();
      }
      
      public function checkForGraphicEffects() : void
      {
         if(this.hasGraphicEffects())
         {
            this.app.go3D();
         }
         else
         {
            this.app.go2D();
         }
      }
      
      public function showAskPrompt(param1:String = "") : void
      {
         var _loc2_:AskPrompter = new AskPrompter(param1,this.app);
         this.interp.askThread = this.interp.activeThread;
         _loc2_.x = 15;
         _loc2_.y = ScratchObj.STAGEH - _loc2_.height - 5;
         this.app.stagePane.addChild(_loc2_);
         setTimeout(_loc2_.grabKeyboardFocus,100);
      }
      
      private function hideAskBubble() : void
      {
         if(Boolean(this.interp.askThread) && Boolean(this.interp.askThread.target))
         {
            if(this.interp.askThread.target != this.app.stagePane && Boolean(this.interp.askThread.target.bubble))
            {
               if(this.interp.askThread.target.bubble.style == "ask")
               {
                  this.interp.askThread.target.hideBubble();
               }
            }
         }
      }
      
      public function hideAskPrompt(param1:AskPrompter) : void
      {
         this.hideAskBubble();
         this.interp.askThread = null;
         this.lastAnswer = param1.answer();
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
         this.app.stage.focus = null;
      }
      
      public function askPromptShowing() : Boolean
      {
         var _loc1_:Sprite = this.app.stagePane.getUILayer();
         var _loc2_:int = 0;
         while(_loc2_ < _loc1_.numChildren)
         {
            if(_loc1_.getChildAt(_loc2_) is AskPrompter)
            {
               return true;
            }
            _loc2_++;
         }
         return false;
      }
      
      public function clearAskPrompts() : void
      {
         var _loc3_:DisplayObject = null;
         this.hideAskBubble();
         this.interp.askThread = null;
         var _loc1_:Array = [];
         var _loc2_:Sprite = this.app.stagePane.getUILayer();
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_.numChildren)
         {
            _loc3_ = _loc2_.getChildAt(_loc4_);
            if(_loc3_ is AskPrompter)
            {
               _loc1_.push(_loc3_);
            }
            _loc4_++;
         }
         for each(_loc3_ in _loc1_)
         {
            _loc2_.removeChild(_loc3_);
         }
      }
      
      public function keyDown(param1:KeyboardEvent) : void
      {
         this.shiftIsDown = param1.shiftKey;
         var _loc2_:int = getKeyCodeFromEvent(param1);
         if(!(param1.target is TextField))
         {
            this.startKeyHats(_loc2_);
         }
         this.keyIsDown[_loc2_] = true;
      }
      
      public function keyUp(param1:KeyboardEvent) : void
      {
         this.shiftIsDown = param1.shiftKey;
         var _loc2_:int = getKeyCodeFromEvent(param1);
         this.keyIsDown[_loc2_] = false;
      }
      
      private function clearKeyDownArray() : void
      {
         this.keyIsDown.length = 0;
      }
      
      public function getSensor(param1:String) : Number
      {
         return this.app.extensionManager.getStateVar("PicoBoard",param1,0);
      }
      
      public function getBooleanSensor(param1:String) : Boolean
      {
         if(param1 == "button pressed")
         {
            return this.app.extensionManager.getStateVar("PicoBoard","button",1023) < 10;
         }
         if(param1.indexOf("connected") > -1)
         {
            param1 = "resistance-" + param1.charAt(0);
            return this.app.extensionManager.getStateVar("PicoBoard",param1,1023) < 10;
         }
         return false;
      }
      
      public function getTimeString(param1:String) : *
      {
         var _loc2_:Date = new Date();
         switch(param1)
         {
            case "hour":
               return _loc2_.hours;
            case "minute":
               return _loc2_.minutes;
            case "second":
               return _loc2_.seconds;
            case "year":
               return _loc2_.fullYear;
            case "month":
               return _loc2_.month + 1;
            case "date":
               return _loc2_.date;
            case "day of week":
               return _loc2_.day + 1;
            default:
               return "";
         }
      }
      
      public function createVariable(param1:String) : void
      {
         this.app.viewedObj().lookupOrCreateVar(param1);
      }
      
      public function deleteVariable(param1:String) : void
      {
         var _loc2_:Variable = this.app.viewedObj().lookupVar(param1);
         if(this.app.viewedObj().ownsVar(param1))
         {
            this.app.viewedObj().deleteVar(param1);
         }
         else
         {
            this.app.stageObj().deleteVar(param1);
         }
         this.clearAllCaches();
      }
      
      public function allVarNames() : Array
      {
         var _loc2_:Variable = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.app.stageObj().variables)
         {
            _loc1_.push(_loc2_.name);
         }
         if(!this.app.viewedObj().isStage)
         {
            for each(_loc2_ in this.app.viewedObj().variables)
            {
               _loc1_.push(_loc2_.name);
            }
         }
         return _loc1_;
      }
      
      public function renameVariable(param1:String, param2:String) : void
      {
         if(param1 == param2)
         {
            return;
         }
         var _loc3_:ScratchObj = this.app.viewedObj();
         if(!_loc3_.ownsVar(param1))
         {
            _loc3_ = this.app.stagePane;
         }
         if(_loc3_.hasName(param2))
         {
            DialogBox.notify("Cannot Rename","That name is already in use.");
            return;
         }
         var _loc4_:Variable = _loc3_.lookupVar(param1);
         if(_loc4_ != null)
         {
            _loc4_.name = param2;
            if(_loc4_.watcher)
            {
               _loc4_.watcher.changeVarName(param2);
            }
         }
         else
         {
            _loc3_.lookupOrCreateVar(param2);
         }
         this.updateVarRefs(param1,param2,_loc3_);
         this.app.updatePalette();
      }
      
      public function updateVariable(param1:Variable) : void
      {
      }
      
      public function makeVariable(param1:Object) : Variable
      {
         return new Variable(param1.name,param1.value);
      }
      
      public function makeListWatcher() : ListWatcher
      {
         return new ListWatcher();
      }
      
      private function updateVarRefs(param1:String, param2:String, param3:ScratchObj) : void
      {
         var _loc4_:Block = null;
         for each(_loc4_ in this.allUsesOfVariable(param1,param3))
         {
            if(_loc4_.op == Specs.GET_VAR)
            {
               _loc4_.setSpec(param2);
               _loc4_.fixExpressionLayout();
            }
            else
            {
               _loc4_.args[0].setArgValue(param2);
            }
         }
      }
      
      public function allListNames() : Array
      {
         var _loc1_:Array = this.app.stageObj().listNames();
         if(!this.app.viewedObj().isStage)
         {
            _loc1_ = _loc1_.concat(this.app.viewedObj().listNames());
         }
         return _loc1_;
      }
      
      public function deleteList(param1:String) : void
      {
         if(this.app.viewedObj().ownsList(param1))
         {
            this.app.viewedObj().deleteList(param1);
         }
         else
         {
            this.app.stageObj().deleteList(param1);
         }
         this.clearAllCaches();
      }
      
      public function timer() : Number
      {
         return (this.interp.currentMSecs - this.timerBase) / 1000;
      }
      
      public function timerReset() : void
      {
         this.timerBase = this.interp.currentMSecs;
      }
      
      public function isLoud() : Boolean
      {
         return this.soundLevel() > 10;
      }
      
      public function soundLevel() : int
      {
         if(this.microphone == null)
         {
            this.microphone = Microphone.getMicrophone();
            if(this.microphone)
            {
               this.microphone.setLoopBack(true);
               this.microphone.soundTransform = new SoundTransform(0,0);
            }
         }
         return this.microphone ? int(this.microphone.activityLevel) : 0;
      }
      
      public function renameCostume(param1:String) : void
      {
         var _loc2_:ScratchObj = this.app.viewedObj();
         var _loc3_:ScratchCostume = _loc2_.currentCostume();
         _loc3_.costumeName = "";
         var _loc4_:String = _loc3_.costumeName;
         param1 = _loc2_.unusedCostumeName(param1 || Translator.map("costume1"));
         _loc3_.costumeName = param1;
         this.updateArgs(_loc2_.isStage ? this.allUsesOfBackdrop(_loc4_) : this.allUsesOfCostume(_loc4_),param1);
      }
      
      public function renameSprite(param1:String) : void
      {
         var _loc4_:ListWatcher = null;
         var _loc2_:ScratchObj = this.app.viewedObj();
         var _loc3_:String = _loc2_.objName;
         _loc2_.objName = "";
         param1 = this.app.stagePane.unusedSpriteName(param1 || Translator.map("Sprite1"));
         _loc2_.objName = param1;
         for each(_loc4_ in this.app.viewedObj().lists)
         {
            _loc4_.updateTitle();
         }
         this.updateArgs(this.allUsesOfSprite(_loc3_),param1);
      }
      
      private function updateArgs(param1:Array, param2:*) : void
      {
         var _loc3_:BlockArg = null;
         for each(_loc3_ in param1)
         {
            _loc3_.setArgValue(param2);
         }
         this.app.setSaveNeeded();
      }
      
      public function renameSound(param1:ScratchSound, param2:String) : void
      {
         var s:ScratchSound = param1;
         var newName:String = param2;
         var obj:ScratchObj = this.app.viewedObj();
         var oldName:String = s.soundName;
         s.soundName = "";
         newName = obj.unusedSoundName(newName || Translator.map("sound1"));
         s.soundName = newName;
         this.allUsesOfSoundDo(oldName,function(param1:BlockArg):void
         {
            param1.setArgValue(newName);
         });
         this.app.setSaveNeeded();
      }
      
      public function clearRunFeedback() : void
      {
         var stack:Block = null;
         if(this.app.editMode)
         {
            for each(stack in this.allStacks())
            {
               stack.allBlocksDo(function(param1:Block):void
               {
                  param1.hideRunFeedback();
               });
            }
         }
         this.app.updatePalette();
      }
      
      public function allSendersOfBroadcast(param1:String) : Array
      {
         var _loc3_:ScratchObj = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.app.stagePane.allObjects())
         {
            if(this.sendsBroadcast(_loc3_,param1))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function allReceiversOfBroadcast(param1:String) : Array
      {
         var _loc3_:ScratchObj = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.app.stagePane.allObjects())
         {
            if(this.receivesBroadcast(_loc3_,param1))
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
      
      public function renameBroadcast(param1:String, param2:String) : void
      {
         var _loc3_:Block = null;
         if(param1 == param2)
         {
            return;
         }
         if(this.allSendersOfBroadcast(param2).length > 0 || this.allReceiversOfBroadcast(param2).length > 0)
         {
            DialogBox.notify("Cannot Rename","That name is already in use.");
            return;
         }
         for each(_loc3_ in this.allBroadcastBlocksWithMsg(param1))
         {
            Block(_loc3_).broadcastMsg = param2;
         }
         this.app.updatePalette();
      }
      
      private function sendsBroadcast(param1:ScratchObj, param2:String) : Boolean
      {
         var stack:Block = null;
         var found:Boolean = false;
         var obj:ScratchObj = param1;
         var msg:String = param2;
         for each(stack in obj.scripts)
         {
            stack.allBlocksDo(function(param1:Block):void
            {
               if(param1.op == "broadcast:" || param1.op == "doBroadcastAndWait")
               {
                  if(param1.broadcastMsg == msg)
                  {
                     found = true;
                  }
               }
            });
            if(found)
            {
               return true;
            }
         }
         return false;
      }
      
      private function receivesBroadcast(param1:ScratchObj, param2:String) : Boolean
      {
         var stack:Block = null;
         var found:Boolean = false;
         var obj:ScratchObj = param1;
         var msg:String = param2;
         msg = msg.toLowerCase();
         for each(stack in obj.scripts)
         {
            stack.allBlocksDo(function(param1:Block):void
            {
               if(param1.op == "whenIReceive")
               {
                  if(param1.broadcastMsg.toLowerCase() == msg)
                  {
                     found = true;
                  }
               }
            });
            if(found)
            {
               return true;
            }
         }
         return false;
      }
      
      private function allBroadcastBlocksWithMsg(param1:String) : Array
      {
         var result:Array = null;
         var o:ScratchObj = null;
         var stack:Block = null;
         var msg:String = param1;
         result = [];
         for each(o in this.app.stagePane.allObjects())
         {
            for each(stack in o.scripts)
            {
               stack.allBlocksDo(function(param1:Block):void
               {
                  if(param1.op == "broadcast:" || param1.op == "doBroadcastAndWait" || param1.op == "whenIReceive")
                  {
                     if(param1.broadcastMsg == msg)
                     {
                        result.push(param1);
                     }
                  }
               });
            }
         }
         return result;
      }
      
      public function allUsesOfBackdrop(param1:String) : Array
      {
         var result:Array = null;
         var backdropName:String = param1;
         result = [];
         this.allStacksAndOwnersDo(function(param1:Block, param2:ScratchObj):void
         {
            var stack:Block = param1;
            var target:ScratchObj = param2;
            stack.allBlocksDo(function(param1:Block):void
            {
               var _loc2_:* = undefined;
               for each(_loc2_ in param1.args)
               {
                  if(_loc2_ is BlockArg && _loc2_.menuName == "backdrop" && _loc2_.argValue == backdropName)
                  {
                     result.push(_loc2_);
                  }
               }
            });
         });
         return result;
      }
      
      public function allUsesOfCostume(param1:String) : Array
      {
         var result:Array = null;
         var stack:Block = null;
         var costumeName:String = param1;
         result = [];
         for each(stack in this.app.viewedObj().scripts)
         {
            stack.allBlocksDo(function(param1:Block):void
            {
               var _loc2_:* = undefined;
               for each(_loc2_ in param1.args)
               {
                  if(_loc2_ is BlockArg && _loc2_.menuName == "costume" && _loc2_.argValue == costumeName)
                  {
                     result.push(_loc2_);
                  }
               }
            });
         }
         return result;
      }
      
      public function allUsesOfSprite(param1:String) : Array
      {
         var spriteMenus:Array = null;
         var result:Array = null;
         var stack:Block = null;
         var spriteName:String = param1;
         spriteMenus = ["spriteOnly","spriteOrMouse","spriteOrStage","touching","location"];
         result = [];
         for each(stack in this.allStacks())
         {
            stack.allBlocksDo(function(param1:Block):void
            {
               var _loc2_:* = undefined;
               for each(_loc2_ in param1.args)
               {
                  if(_loc2_ is BlockArg && spriteMenus.indexOf(_loc2_.menuName) != -1 && _loc2_.argValue == spriteName)
                  {
                     result.push(_loc2_);
                  }
               }
            });
         }
         return result;
      }
      
      public function allUsesOfVariable(param1:String, param2:ScratchObj) : Array
      {
         var variableBlocks:Array = null;
         var result:Array = null;
         var stack:Block = null;
         var varName:String = param1;
         var owner:ScratchObj = param2;
         variableBlocks = [Specs.SET_VAR,Specs.CHANGE_VAR,"showVariable:","hideVariable:"];
         result = [];
         var stacks:Array = owner.isStage ? this.allStacks() : owner.scripts;
         for each(stack in stacks)
         {
            stack.allBlocksDo(function(param1:Block):void
            {
               if(param1.op == Specs.GET_VAR && param1.spec == varName)
               {
                  result.push(param1);
               }
               if(variableBlocks.indexOf(param1.op) != -1 && param1.args[0] is BlockArg && param1.args[0].argValue == varName)
               {
                  result.push(param1);
               }
            });
         }
         return result;
      }
      
      public function allUsesOfSoundDo(param1:String, param2:Function) : void
      {
         var stack:Block = null;
         var soundName:String = param1;
         var f:Function = param2;
         for each(stack in this.app.viewedObj().scripts)
         {
            stack.allBlocksDo(function(param1:Block):void
            {
               var _loc2_:* = undefined;
               for each(_loc2_ in param1.args)
               {
                  if(_loc2_ is BlockArg && _loc2_.menuName == "sound" && _loc2_.argValue == soundName)
                  {
                     f(_loc2_);
                  }
               }
            });
         }
      }
      
      public function allCallsOf(param1:String, param2:ScratchObj, param3:Boolean = true) : Array
      {
         var result:Array = null;
         var stack:Block = null;
         var callee:String = param1;
         var owner:ScratchObj = param2;
         var includeRecursive:Boolean = param3;
         result = [];
         for each(stack in owner.scripts)
         {
            if(!(!includeRecursive && stack.op == Specs.PROCEDURE_DEF && stack.spec == callee))
            {
               stack.allBlocksDo(function(param1:Block):void
               {
                  if(param1.op == Specs.CALL && param1.spec == callee)
                  {
                     result.push(param1);
                  }
               });
            }
         }
         return result;
      }
      
      public function updateCalls() : void
      {
         this.allStacksAndOwnersDo(function(param1:Block, param2:ScratchObj):void
         {
            if(param1.op == Specs.CALL)
            {
               if(param2.lookupProcedure(param1.spec) == null)
               {
                  param1.base.setColor(16711680);
                  param1.base.redraw();
               }
               else
               {
                  param1.base.setColor(Specs.procedureColor);
               }
            }
         });
         this.clearAllCaches();
      }
      
      public function allStacks() : Array
      {
         var result:Array = null;
         result = [];
         this.allStacksAndOwnersDo(function(param1:Block, param2:ScratchObj):void
         {
            result.push(param1);
         });
         return result;
      }
      
      public function allStacksAndOwnersDo(param1:Function, param2:Boolean = false) : void
      {
         var _loc4_:Block = null;
         var _loc6_:* = undefined;
         var _loc3_:ScratchStage = this.app.stagePane;
         var _loc5_:* = int(_loc3_.numChildren - 1);
         while(_loc5_ >= 0)
         {
            _loc6_ = _loc3_.getChildAt(_loc5_);
            if(_loc6_ is ScratchObj)
            {
               if(param2)
               {
                  this.currentDoObj = ScratchObj(_loc6_);
               }
               for each(_loc4_ in ScratchObj(_loc6_).scripts)
               {
                  param1(_loc4_,_loc6_);
               }
            }
            _loc5_--;
         }
         if(param2)
         {
            this.currentDoObj = _loc3_;
         }
         for each(_loc4_ in _loc3_.scripts)
         {
            param1(_loc4_,_loc3_);
         }
         this.currentDoObj = null;
      }
      
      public function clearAllCaches() : void
      {
         var _loc1_:ScratchObj = null;
         for each(_loc1_ in this.app.stagePane.allObjects())
         {
            _loc1_.clearCaches();
         }
      }
      
      public function showWatcher(param1:Object, param2:Boolean) : void
      {
         var _loc3_:Watcher = null;
         if("variable" == param1.type)
         {
            if(param2)
            {
               this.showVarOrListFor(param1.varName,param1.isList,param1.targetObj);
            }
            else
            {
               this.hideVarOrListFor(param1.varName,param1.isList,param1.targetObj);
            }
         }
         if("reporter" == param1.type)
         {
            _loc3_ = this.findReporterWatcher(param1);
            if(_loc3_)
            {
               _loc3_.visible = param2;
            }
            else if(param2)
            {
               _loc3_ = new Watcher();
               _loc3_.initWatcher(param1.targetObj,param1.cmd,param1.param,param1.color);
               this.showOnStage(_loc3_);
            }
         }
         this.app.setSaveNeeded();
      }
      
      public function showVarOrListFor(param1:String, param2:Boolean, param3:ScratchObj) : void
      {
         if(param3.isClone)
         {
            if(!param2 && param3.ownsVar(param1))
            {
               return;
            }
            if(param2 && param3.ownsList(param1))
            {
               return;
            }
         }
         var _loc4_:DisplayObject = param2 ? this.watcherForList(param3,param1) : this.watcherForVar(param3,param1);
         if(_loc4_ is ListWatcher)
         {
            ListWatcher(_loc4_).prepareToShow();
         }
         if(_loc4_ != null && (!_loc4_.visible || !_loc4_.parent))
         {
            this.showOnStage(_loc4_);
            this.app.updatePalette(false);
         }
      }
      
      private function showOnStage(param1:DisplayObject) : void
      {
         if(param1.parent == null)
         {
            this.setInitialPosition(param1);
         }
         param1.visible = true;
         this.app.stagePane.addChild(param1);
      }
      
      private function setInitialPosition(param1:DisplayObject) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:DisplayObject = null;
         var _loc2_:Array = this.app.stagePane.watchers();
         var _loc3_:int = param1.width;
         var _loc4_:int = param1.height;
         var _loc5_:int = 5;
         while(_loc5_ < 400)
         {
            _loc6_ = 0;
            _loc7_ = 5;
            while(_loc7_ < 320)
            {
               _loc8_ = this.watcherIntersecting(_loc2_,new Rectangle(_loc5_,_loc7_,_loc3_,_loc4_));
               if(!_loc8_)
               {
                  param1.x = _loc5_;
                  param1.y = _loc7_;
                  return;
               }
               _loc7_ = _loc8_.y + _loc8_.height + 5;
               _loc6_ = _loc8_.x + _loc8_.width;
            }
            _loc5_ = _loc6_ + 5;
         }
         param1.x = 5 + Math.floor(400 * Math.random());
         param1.y = 5 + Math.floor(320 * Math.random());
      }
      
      private function watcherIntersecting(param1:Array, param2:Rectangle) : DisplayObject
      {
         var _loc3_:DisplayObject = null;
         for each(_loc3_ in param1)
         {
            if(param2.intersects(_loc3_.getBounds(this.app.stagePane)))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function hideVarOrListFor(param1:String, param2:Boolean, param3:ScratchObj) : void
      {
         var _loc4_:DisplayObject = param2 ? this.watcherForList(param3,param1) : this.watcherForVar(param3,param1);
         if(_loc4_ != null && _loc4_.visible)
         {
            _loc4_.visible = false;
            this.app.updatePalette(false);
         }
      }
      
      public function watcherShowing(param1:Object) : Boolean
      {
         var _loc2_:ScratchObj = null;
         var _loc3_:String = null;
         var _loc4_:Sprite = null;
         var _loc5_:int = 0;
         var _loc6_:ListWatcher = null;
         var _loc7_:Watcher = null;
         var _loc8_:Watcher = null;
         if("variable" == param1.type)
         {
            _loc2_ = param1.targetObj;
            _loc3_ = param1.varName;
            _loc4_ = this.app.stagePane.getUILayer();
            if(param1.isList)
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.numChildren)
               {
                  _loc6_ = _loc4_.getChildAt(_loc5_) as ListWatcher;
                  if(Boolean(_loc6_) && Boolean(_loc6_.listName == _loc3_) && _loc6_.visible)
                  {
                     return true;
                  }
                  _loc5_++;
               }
            }
            else
            {
               _loc5_ = 0;
               while(_loc5_ < _loc4_.numChildren)
               {
                  _loc7_ = _loc4_.getChildAt(_loc5_) as Watcher;
                  if(Boolean(_loc7_) && Boolean(_loc7_.isVarWatcherFor(_loc2_,_loc3_)) && _loc7_.visible)
                  {
                     return true;
                  }
                  _loc5_++;
               }
            }
         }
         if("reporter" == param1.type)
         {
            _loc8_ = this.findReporterWatcher(param1);
            return Boolean(_loc8_) && _loc8_.visible;
         }
         return false;
      }
      
      private function findReporterWatcher(param1:Object) : Watcher
      {
         var _loc4_:Watcher = null;
         var _loc2_:Sprite = this.app.stagePane.getUILayer();
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            _loc4_ = _loc2_.getChildAt(_loc3_) as Watcher;
            if(Boolean(_loc4_) && _loc4_.isReporterWatcher(param1.targetObj,param1.cmd,param1.param))
            {
               return _loc4_;
            }
            _loc3_++;
         }
         return null;
      }
      
      private function watcherForVar(param1:ScratchObj, param2:String) : DisplayObject
      {
         var _loc4_:Watcher = null;
         var _loc3_:Variable = param1.lookupVar(param2);
         if(_loc3_ == null)
         {
            return null;
         }
         if(_loc3_.watcher == null)
         {
            if(this.app.stagePane.ownsVar(param2))
            {
               param1 = this.app.stagePane;
            }
            _loc4_ = this.existingWatcherForVar(param1,param2);
            if(_loc4_ != null)
            {
               _loc3_.watcher = _loc4_;
            }
            else
            {
               _loc3_.watcher = new Watcher();
               Watcher(_loc3_.watcher).initForVar(param1,param2);
            }
         }
         return _loc3_.watcher;
      }
      
      private function watcherForList(param1:ScratchObj, param2:String) : DisplayObject
      {
         var _loc3_:ListWatcher = null;
         for each(_loc3_ in param1.lists)
         {
            if(_loc3_.listName == param2)
            {
               return _loc3_;
            }
         }
         for each(_loc3_ in this.app.stagePane.lists)
         {
            if(_loc3_.listName == param2)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function existingWatcherForVar(param1:ScratchObj, param2:String) : Watcher
      {
         var _loc5_:* = undefined;
         var _loc3_:Sprite = this.app.stagePane.getUILayer();
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.numChildren)
         {
            _loc5_ = _loc3_.getChildAt(_loc4_);
            if(_loc5_ is Watcher && Boolean(_loc5_.isVarWatcherFor(param1,param2)))
            {
               return _loc5_;
            }
            _loc4_++;
         }
         return null;
      }
      
      public function canUndelete() : Boolean
      {
         return this.lastDelete != null;
      }
      
      public function clearLastDelete() : void
      {
         this.lastDelete = null;
      }
      
      public function recordForUndelete(param1:*, param2:int, param3:int, param4:int, param5:* = null) : void
      {
         var _loc6_:Array = null;
         var _loc7_:ScratchComment = null;
         if(param1 is Block)
         {
            _loc6_ = (param1 as Block).attachedCommentsIn(this.app.scriptsPane);
            if(_loc6_.length)
            {
               for each(_loc7_ in _loc6_)
               {
                  _loc7_.parent.removeChild(_loc7_);
               }
               this.app.scriptsPane.fixCommentLayout();
               param1 = [param1,_loc6_];
            }
         }
         this.lastDelete = [param1,param2,param3,param4,param5];
      }
      
      public function undelete() : void
      {
         if(!this.lastDelete)
         {
            return;
         }
         var _loc1_:* = this.lastDelete[0];
         var _loc2_:int = int(this.lastDelete[1]);
         var _loc3_:int = int(this.lastDelete[2]);
         var _loc4_:int = int(this.lastDelete[3]);
         var _loc5_:* = this.lastDelete[4];
         this.doUndelete(_loc1_,_loc2_,_loc3_,_loc5_);
         this.lastDelete = null;
      }
      
      protected function doUndelete(param1:*, param2:int, param3:int, param4:*) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:ScratchComment = null;
         if(param1 is MediaInfo)
         {
            if(param4 is ScratchObj)
            {
               this.app.selectSprite(param4);
               if(param1.mycostume)
               {
                  this.app.addCostume(param1.mycostume as ScratchCostume);
               }
               if(param1.mysound)
               {
                  this.app.addSound(param1.mysound as ScratchSound);
               }
            }
         }
         else if(param1 is ScratchSprite)
         {
            this.app.addNewSprite(param1);
            param1.setScratchXY(param2,param3);
            this.app.selectSprite(param1);
         }
         else if(param1 is Array || param1 is Block || param1 is ScratchComment)
         {
            this.app.selectSprite(param4);
            this.app.setTab("scripts");
            _loc5_ = param1 is Array ? param1[0] : param1;
            _loc5_.x = this.app.scriptsPane.padding;
            _loc5_.y = this.app.scriptsPane.padding;
            if(_loc5_ is Block)
            {
               _loc5_.cacheAsBitmap = true;
            }
            this.app.scriptsPane.addChild(_loc5_);
            if(param1 is Array)
            {
               for each(_loc6_ in param1[1])
               {
                  this.app.scriptsPane.addChild(_loc6_);
               }
            }
            this.app.scriptsPane.saveScripts();
            if(_loc5_ is Block)
            {
               this.app.updatePalette();
            }
         }
      }
   }
}

