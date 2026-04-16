package soundedit
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.SampleDataEvent;
   import flash.geom.Point;
   import flash.media.*;
   import flash.text.*;
   import scratch.ScratchSound;
   import ui.parts.SoundsPart;
   import util.DragClient;
   
   public class WaveformView extends Sprite implements DragClient
   {
      
      private static var PasteBuffer:Vector.<int> = new Vector.<int>();
      
      private const backgroundColor:int = 16185078;
      
      private const selectionColor:int = 13684991;
      
      private const shortSelectionColor:int = 10526928;
      
      private const waveformColor:int = 3158064;
      
      private const playCursorColor:int = 255;
      
      private var targetSound:ScratchSound;
      
      private var frame:Shape;
      
      private var wave:Shape;
      
      private var playCursor:Shape;
      
      private var recordingIndicator:TextField;
      
      private var soundsPart:SoundsPart;
      
      private var editor:SoundEditor;
      
      private var samples:Vector.<int> = new Vector.<int>();
      
      private var samplingRate:int = 22050;
      
      private var condensedSamples:Vector.<int> = new Vector.<int>();
      
      private var samplesPerCondensedSample:int = 32;
      
      private var scrollStart:int;
      
      private var selectionStart:int;
      
      private var selectionEnd:int;
      
      private var mic:Microphone;
      
      private var recordSamples:Vector.<int> = new Vector.<int>();
      
      private var soundChannel:SoundChannel;
      
      private var playIndex:int;
      
      private var playEndIndex:int;
      
      private var playStart:int;
      
      private var playbackStarting:Boolean;
      
      private var selectMode:String;
      
      private var startOffset:int;
      
      public function WaveformView(param1:SoundEditor, param2:SoundsPart)
      {
         super();
         this.editor = param1;
         this.soundsPart = param2;
         addChild(this.frame = new Shape());
         addChild(this.wave = new Shape());
         addChild(this.playCursor = new Shape());
         this.addRecordingMessage();
         this.playCursor.visible = false;
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(Event.ENTER_FRAME,this.step);
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         var _loc3_:Graphics = this.frame.graphics;
         _loc3_.clear();
         _loc3_.lineStyle(1,CSS.borderColor,1,true);
         _loc3_.beginFill(this.backgroundColor);
         _loc3_.drawRoundRect(0,0,param1,param2,13,13);
         _loc3_.endFill();
         _loc3_ = this.playCursor.graphics;
         _loc3_.clear();
         _loc3_.beginFill(this.playCursorColor);
         _loc3_.drawRect(0,1,1,param2 - 2);
         _loc3_.endFill();
         this.drawWave();
      }
      
      private function addRecordingMessage() : void
      {
         var _loc1_:TextFormat = new TextFormat(CSS.font,18,15571456);
         this.recordingIndicator = Resources.makeLabel("Recording...",_loc1_,15,12);
         this.recordingIndicator.visible = false;
         addChild(this.recordingIndicator);
      }
      
      public function editSound(param1:ScratchSound) : void
      {
         this.targetSound = param1;
         this.samplingRate = param1.rate;
         if(param1.editorData)
         {
            this.samples = param1.editorData.samples;
            this.condensedSamples = param1.editorData.condensedSamples;
            this.samplesPerCondensedSample = param1.editorData.samplesPerCondensedSample;
         }
         else
         {
            this.samples = this.targetSound.getSamples();
            this.adjustTimeScale();
            this.initEditorData();
         }
         this.selectionEnd = this.selectionStart = 0;
         this.scrollTo(0);
      }
      
      private function initEditorData() : void
      {
         this.targetSound.editorData = {
            "samples":this.samples,
            "condensedSamples":this.condensedSamples,
            "samplesPerCondensedSample":this.samplesPerCondensedSample,
            "undoList":[],
            "undoIndex":0
         };
      }
      
      public function setScroll(param1:Number) : void
      {
         var _loc2_:int = Math.max(0,this.condensedSamples.length - this.frame.width);
         this.scrollStart = this.clipTo(param1 * _loc2_,0,_loc2_);
         this.drawWave();
      }
      
      private function scrollTo(param1:int) : void
      {
         var _loc2_:int = Math.max(0,this.condensedSamples.length - this.frame.width);
         this.scrollStart = this.clipTo(param1,0,_loc2_);
         this.editor.scrollbar.update(this.scrollStart / _loc2_,this.frame.width / this.condensedSamples.length);
         this.drawWave();
      }
      
      public function zoomIn() : void
      {
         this.setCondensation(Math.max(this.samplesPerCondensedSample / 2,32));
      }
      
      public function zoomOut() : void
      {
         this.setCondensation(Math.min(this.samplesPerCondensedSample * 2,512));
      }
      
      private function adjustTimeScale() : void
      {
         var _loc1_:Number = this.samples.length / this.samplingRate;
         var _loc2_:int = 512;
         if(_loc1_ <= 120)
         {
            _loc2_ = 256;
         }
         if(_loc1_ <= 30)
         {
            _loc2_ = 128;
         }
         if(_loc1_ <= 10)
         {
            _loc2_ = 64;
         }
         if(_loc1_ <= 2)
         {
            _loc2_ = 32;
         }
         this.samplesPerCondensedSample = 0;
         this.setCondensation(_loc2_);
      }
      
      private function setCondensation(param1:int) : void
      {
         if(param1 == this.samplesPerCondensedSample)
         {
            return;
         }
         param1 = Math.max(1,param1);
         var _loc2_:Number = this.samplesPerCondensedSample / param1;
         this.samplesPerCondensedSample = param1;
         this.computeCondensedSamples();
         this.selectionStart *= _loc2_;
         this.selectionEnd *= _loc2_;
         this.scrollTo(this.scrollStart * _loc2_);
      }
      
      private function computeCondensedSamples() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:int = 0;
         this.condensedSamples = new Vector.<int>();
         var _loc3_:int = 0;
         while(_loc3_ < this.samples.length)
         {
            _loc4_ = this.samples[_loc3_];
            if(_loc4_ < 0)
            {
               _loc4_ = -_loc4_;
            }
            if(_loc4_ > _loc1_)
            {
               _loc1_ = _loc4_;
            }
            if(++_loc2_ == this.samplesPerCondensedSample)
            {
               this.condensedSamples.push(_loc1_);
               _loc1_ = _loc2_ = 0;
            }
            _loc3_++;
         }
         if(_loc2_ > 0)
         {
            this.condensedSamples.push(_loc1_);
         }
      }
      
      private function drawWave() : void
      {
         this.recordingIndicator.visible = this.isRecording();
         var _loc1_:Graphics = this.wave.graphics;
         _loc1_.clear();
         if(!this.isRecording())
         {
            this.drawSelection(_loc1_,1);
            this.drawSamples(_loc1_);
            this.drawSelection(_loc1_,0.3);
         }
      }
      
      private function drawSelection(param1:Graphics, param2:Number) : void
      {
         var _loc3_:int = this.clipTo(this.selectionStart - this.scrollStart,0,this.frame.width - 1);
         var _loc4_:int = this.clipTo(this.selectionEnd - this.scrollStart,0,this.frame.width - 1);
         var _loc5_:int = Math.max(1,_loc4_ - _loc3_);
         if(_loc5_ == 1)
         {
            param1.beginFill(this.shortSelectionColor,0.7);
            param1.drawRect(_loc3_ + 1,1,_loc5_,this.frame.height - 2);
         }
         else
         {
            param1.beginFill(this.selectionColor,param2);
            param1.drawRoundRect(_loc3_ + 1,1,_loc5_,this.frame.height - 2,11,11);
         }
         param1.endFill();
      }
      
      private function drawSamples(param1:Graphics) : void
      {
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(this.condensedSamples.length == 0)
         {
            return;
         }
         var _loc2_:int = this.frame.height - 2;
         var _loc3_:Number = _loc2_ / 2 / 32768;
         var _loc4_:int = _loc2_ / 2 + 1;
         var _loc5_:int = Math.min(this.condensedSamples.length,this.frame.width);
         param1.beginFill(this.waveformColor);
         if(this.samplesPerCondensedSample < 5)
         {
            _loc6_ = this.scrollStart * this.samplesPerCondensedSample;
            _loc7_ = 1;
            while(_loc7_ < this.frame.width)
            {
               if(_loc6_ >= this.samples.length)
               {
                  break;
               }
               _loc8_ = _loc3_ * this.samples[_loc6_];
               if(_loc8_ > 0)
               {
                  param1.drawRect(_loc7_,_loc4_ - _loc8_,1,_loc8_);
               }
               else
               {
                  param1.drawRect(_loc7_,_loc4_,1,-_loc8_);
               }
               _loc6_ += this.samplesPerCondensedSample;
               _loc7_++;
            }
         }
         else
         {
            _loc6_ = this.scrollStart;
            _loc7_ = 1;
            while(_loc7_ < this.frame.width)
            {
               if(_loc6_ >= this.condensedSamples.length)
               {
                  break;
               }
               _loc8_ = _loc3_ * this.condensedSamples[_loc6_];
               param1.drawRect(_loc7_,_loc4_ - _loc8_,1,2 * _loc8_ + 1);
               _loc6_++;
               _loc7_++;
            }
         }
         param1.endFill();
      }
      
      private function clipTo(param1:Number, param2:Number, param3:Number) : Number
      {
         if(param3 < param2)
         {
            param3 = param2;
         }
         if(param1 < param2)
         {
            return param2;
         }
         if(param1 > param3)
         {
            return param3;
         }
         return param1;
      }
      
      public function stopAll(param1:* = null) : void
      {
         this.stopPlaying();
         this.stopRecording();
         this.drawWave();
      }
      
      public function toggleRecording(param1:* = null) : void
      {
         if(this.isRecording())
         {
            this.stopRecording();
         }
         else
         {
            this.stopAll();
            this.openMicrophone();
            if(this.mic)
            {
               this.recordSamples = new Vector.<int>();
               this.mic.addEventListener(SampleDataEvent.SAMPLE_DATA,this.recordData);
            }
         }
         this.editor.updateIndicators();
         this.drawWave();
      }
      
      public function isRecording() : Boolean
      {
         return this.recordSamples != null;
      }
      
      private function stopRecording() : void
      {
         if(this.mic)
         {
            this.mic.removeEventListener(SampleDataEvent.SAMPLE_DATA,this.recordData);
         }
         this.editor.levelMeter.clear();
         if(Boolean(this.recordSamples) && this.recordSamples.length > 0)
         {
            this.appendRecording(this.recordSamples);
         }
         this.recordSamples = null;
         this.editor.updateIndicators();
         this.drawWave();
      }
      
      private function recordData(param1:SampleDataEvent) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:Number = 0;
         while(param1.data.bytesAvailable)
         {
            _loc3_ = param1.data.readFloat();
            _loc2_ = Math.max(_loc2_,Math.abs(_loc3_));
            this.recordSamples.push(_loc3_ * 32767);
         }
         this.editor.levelMeter.setLevel(100 * _loc2_);
      }
      
      private function appendRecording(param1:Vector.<int>) : void
      {
         var _loc2_:int = this.selectionStart == 0 && this.selectionEnd - this.selectionStart < 5 ? 0 : this.selectionEnd;
         var _loc3_:Vector.<int> = this.extract(0,_loc2_);
         var _loc4_:Vector.<int> = this.extract(_loc2_);
         this.updateContents(_loc3_.concat(param1).concat(_loc4_),false,128);
         this.selectionStart = _loc3_.length / this.samplesPerCondensedSample;
         this.selectionEnd = (_loc3_.length + param1.length) / this.samplesPerCondensedSample;
         this.scrollTo(this.selectionStart);
      }
      
      private function openMicrophone() : void
      {
         this.mic = Microphone.getMicrophone();
         if(!this.mic)
         {
            return;
         }
         this.mic.setSilenceLevel(0);
         this.mic.setLoopBack(true);
         this.mic.soundTransform = new SoundTransform(0,0);
         if(this.samplingRate == 22050)
         {
            this.mic.rate = 22;
         }
         if(this.samplingRate > 22050)
         {
            this.mic.rate = 44;
         }
         if(this.samplingRate < 22050)
         {
            this.mic.rate = 11;
         }
      }
      
      public function startPlaying(param1:* = null) : void
      {
         this.stopAll();
         if(!this.samples || this.samples.length == 0)
         {
            return;
         }
         this.playIndex = this.clipTo(this.selectionStart * this.samplesPerCondensedSample,0,this.samples.length);
         this.playEndIndex = this.clipTo(this.selectionEnd * this.samplesPerCondensedSample,0,this.samples.length);
         if(this.selectionEnd - this.selectionStart <= 1)
         {
            if(this.condensedSamples.length - this.selectionStart < 2)
            {
               this.playIndex = 0;
            }
            this.playEndIndex = this.samples.length;
         }
         this.playStart = this.playIndex / this.samplesPerCondensedSample;
         this.playbackStarting = true;
         var _loc2_:Sound = new Sound();
         _loc2_.addEventListener(SampleDataEvent.SAMPLE_DATA,this.playBuffer);
         this.soundChannel = _loc2_.play();
         this.soundChannel.addEventListener(Event.SOUND_COMPLETE,this.stopPlaying);
         this.playCursor.visible = true;
         this.editor.updateIndicators();
         this.drawWave();
      }
      
      public function isPlaying() : Boolean
      {
         return this.soundChannel != null;
      }
      
      private function stopPlaying(param1:* = null) : void
      {
         if(this.soundChannel)
         {
            this.soundChannel.stop();
         }
         this.soundChannel = null;
         this.editor.levelMeter.clear();
         this.playCursor.visible = false;
         this.editor.updateIndicators();
         this.drawWave();
      }
      
      public function togglePlaying(param1:* = null) : void
      {
         if(this.soundChannel)
         {
            this.stopPlaying();
         }
         else
         {
            this.startPlaying();
         }
      }
      
      private function playBuffer(param1:SampleDataEvent) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:int = 0;
         var _loc4_:int = 2 * (44100 / this.samplingRate);
         if(_loc4_ & 1)
         {
            _loc4_++;
         }
         if(this.playEndIndex > this.samples.length)
         {
            this.playEndIndex = this.samples.length;
         }
         var _loc5_:int = 6000 / _loc4_;
         _loc3_ = 0;
         while(_loc3_ < _loc5_ && this.playIndex < this.playEndIndex)
         {
            _loc6_ = this.samples[this.playIndex++] / 32767;
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               param1.data.writeFloat(_loc6_);
               _loc7_++;
            }
            _loc3_++;
         }
         if(this.playbackStarting)
         {
            if(_loc3_ < _loc5_)
            {
               _loc3_ = 0;
               while(_loc3_ < 2048)
               {
                  param1.data.writeFloat(0 / 32767);
                  _loc3_++;
               }
            }
            this.playbackStarting = false;
         }
      }
      
      public function leftArrow() : void
      {
         if(this.selectionStart > 0)
         {
            --this.selectionStart;
            --this.selectionEnd;
            this.drawWave();
         }
      }
      
      public function rightArrow() : void
      {
         if(this.selectionEnd < this.condensedSamples.length)
         {
            ++this.selectionStart;
            ++this.selectionEnd;
            this.drawWave();
         }
      }
      
      public function copy() : void
      {
         PasteBuffer = this.extract(this.selectionStart,this.selectionEnd);
      }
      
      public function cut() : void
      {
         this.copy();
         this.deleteSelection();
      }
      
      public function deleteSelection(param1:Boolean = false) : void
      {
         if(param1)
         {
            this.updateContents(this.extract(this.selectionStart,this.selectionEnd));
         }
         else
         {
            this.updateContents(this.extract(0,this.selectionStart).concat(this.extract(this.selectionEnd)));
         }
      }
      
      public function paste() : void
      {
         var _loc1_:Vector.<int> = this.extract(0,this.selectionStart);
         var _loc2_:Vector.<int> = this.extract(this.selectionEnd);
         this.updateContents(_loc1_.concat(PasteBuffer).concat(_loc2_));
      }
      
      public function selectAll() : void
      {
         this.selectionStart = 0;
         this.selectionEnd = Math.max(0,this.condensedSamples.length - 1);
         this.drawWave();
      }
      
      private function extract(param1:int, param2:int = -1) : Vector.<int>
      {
         if(param2 == -1)
         {
            param2 = int(this.condensedSamples.length);
         }
         var _loc3_:int = this.clipTo(param1 * this.samplesPerCondensedSample,0,this.samples.length);
         var _loc4_:int = this.clipTo(param2 * this.samplesPerCondensedSample,0,this.samples.length);
         return this.samples.slice(_loc3_,_loc4_);
      }
      
      private function updateContents(param1:Vector.<int>, param2:Boolean = false, param3:int = -1) : void
      {
         this.recordForUndo();
         this.samples = param1;
         if(param3 > 0)
         {
            this.samplesPerCondensedSample = param3;
         }
         this.computeCondensedSamples();
         var _loc4_:Object = this.targetSound.editorData;
         _loc4_.samples = this.samples;
         _loc4_.condensedSamples = this.condensedSamples;
         _loc4_.samplesPerCondensedSample = this.samplesPerCondensedSample;
         this.targetSound.setSamples(this.samples,this.samplingRate);
         this.editor.app.setSaveNeeded();
         var _loc5_:int = this.condensedSamples.length - 1;
         this.scrollStart = this.clipTo(this.scrollStart,0,_loc5_ - this.frame.width);
         if(param2)
         {
            this.selectionStart = this.clipTo(this.selectionStart,0,_loc5_);
            this.selectionEnd = this.clipTo(this.selectionEnd,0,_loc5_);
         }
         else
         {
            this.selectionEnd = this.selectionStart = this.clipTo(this.selectionStart,0,_loc5_);
         }
         this.drawWave();
      }
      
      public function applyEffect(param1:String, param2:Boolean) : void
      {
         if(this.emptySelection())
         {
            return;
         }
         var _loc3_:Vector.<int> = this.extract(0,this.selectionStart);
         var _loc4_:Vector.<int> = this.extract(this.selectionStart,this.selectionEnd);
         var _loc5_:Vector.<int> = this.extract(this.selectionEnd);
         switch(param1)
         {
            case "fade in":
               this.fadeIn(_loc4_);
               break;
            case "fade out":
               this.fadeOut(_loc4_);
               break;
            case "louder":
               this.louder(_loc4_,param2);
               break;
            case "softer":
               this.softer(_loc4_,param2);
               break;
            case "silence":
               this.silence(_loc4_);
               break;
            case "reverse":
               this.reverse(_loc4_);
         }
         this.updateContents(_loc3_.concat(_loc4_).concat(_loc5_),true);
      }
      
      private function fadeIn(param1:Vector.<int>) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            param1[_loc3_] = _loc3_ / _loc2_ * param1[_loc3_];
            _loc3_++;
         }
      }
      
      private function fadeOut(param1:Vector.<int>) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            param1[_loc3_] = (_loc2_ - _loc3_) / _loc2_ * param1[_loc3_];
            _loc3_++;
         }
      }
      
      private function louder(param1:Vector.<int>, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = Math.max(_loc4_,Math.abs(param1[_loc3_]));
            _loc3_++;
         }
         var _loc5_:Number = Math.min(this.loudnessScale(param2),32767 / _loc4_);
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            param1[_loc3_] = _loc5_ * param1[_loc3_];
            _loc3_++;
         }
      }
      
      private function softer(param1:Vector.<int>, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = Math.max(_loc4_,Math.abs(param1[_loc3_]));
            _loc3_++;
         }
         var _loc5_:Number = Math.max(1 / this.loudnessScale(param2),Math.min(1,512 / _loc4_));
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            param1[_loc3_] = _loc5_ * param1[_loc3_];
            _loc3_++;
         }
      }
      
      private function loudnessScale(param1:Boolean) : Number
      {
         return param1 ? 1.3 : 3;
      }
      
      private function silence(param1:Vector.<int>) : void
      {
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            param1[_loc2_] = 0;
            _loc2_++;
         }
      }
      
      private function reverse(param1:Vector.<int>) : void
      {
         var _loc2_:int = int(param1.length);
         var _loc3_:Vector.<int> = param1.slice(0,_loc2_);
         var _loc4_:int = 0;
         while(_loc4_ < _loc2_)
         {
            param1[_loc4_] = _loc3_[_loc2_ - 1 - _loc4_];
            _loc4_++;
         }
      }
      
      public function undo(param1:* = null) : void
      {
         var _loc2_:Object = this.targetSound.editorData;
         if(_loc2_.undoIndex == _loc2_.undoList.length)
         {
            _loc2_.undoList.push([this.samples,this.condensedSamples,this.samplesPerCondensedSample]);
         }
         if(_loc2_.undoIndex > 0)
         {
            this.installUndoRecord(_loc2_.undoList[--_loc2_.undoIndex]);
         }
         this.soundsPart.refreshUndoButtons();
      }
      
      public function redo(param1:* = null) : void
      {
         var _loc2_:Object = this.targetSound.editorData;
         if(_loc2_.undoIndex < _loc2_.undoList.length - 1)
         {
            this.installUndoRecord(_loc2_.undoList[++_loc2_.undoIndex]);
         }
         this.soundsPart.refreshUndoButtons();
      }
      
      public function canUndo() : Boolean
      {
         return Boolean(this.targetSound) && this.targetSound.editorData.undoIndex > 0;
      }
      
      public function canRedo() : Boolean
      {
         return Boolean(this.targetSound) && this.targetSound.editorData.undoIndex < this.targetSound.editorData.undoList.length - 1;
      }
      
      private function installUndoRecord(param1:Array) : void
      {
         this.stopAll();
         this.samples = param1[0];
         this.condensedSamples = param1[1];
         this.samplesPerCondensedSample = param1[2];
         this.selectionEnd = this.selectionStart = 0;
         this.scrollTo(0);
      }
      
      private function recordForUndo() : void
      {
         var _loc1_:Object = this.targetSound.editorData;
         if(_loc1_.undoList.length > _loc1_.undoIndex)
         {
            _loc1_.undoList = _loc1_.undoList.slice(0,_loc1_.undoIndex);
         }
         _loc1_.undoList.push([this.samples,this.condensedSamples,this.samplesPerCondensedSample]);
         _loc1_.undoIndex = _loc1_.undoList.length;
         this.soundsPart.refreshUndoButtons();
      }
      
      public function mouseDown(param1:MouseEvent) : void
      {
         Scratch(root).gh.setDragClient(this,param1);
      }
      
      public function dragBegin(param1:MouseEvent) : void
      {
         var _loc2_:int = 8;
         this.startOffset = Math.max(0,this.offsetAtMouse() - 1);
         this.selectMode = "new";
         if(this.emptySelection())
         {
            if(Math.abs(this.startOffset - this.selectionStart) < _loc2_)
            {
               this.startOffset = this.selectionStart;
            }
            if(this.mousePastEnd())
            {
               this.startOffset = this.condensedSamples.length;
            }
         }
         else if(Math.abs(this.startOffset - this.selectionStart) < _loc2_)
         {
            this.selectMode = "start";
         }
         else if(Math.abs(this.startOffset - this.selectionEnd) < _loc2_)
         {
            this.selectMode = "end";
         }
         this.dragMove(param1);
      }
      
      private function emptySelection() : Boolean
      {
         return this.selectionEnd - this.selectionStart <= 1;
      }
      
      public function dragMove(param1:MouseEvent) : void
      {
         var _loc2_:int = this.offsetAtMouse();
         if("start" == this.selectMode)
         {
            this.selectionStart = _loc2_;
            this.selectionEnd = Math.max(_loc2_,this.selectionEnd);
         }
         if("end" == this.selectMode)
         {
            this.selectionStart = Math.min(this.selectionStart,_loc2_);
            this.selectionEnd = _loc2_;
         }
         if("new" == this.selectMode)
         {
            if(_loc2_ < this.startOffset)
            {
               this.selectionStart = _loc2_;
               this.selectionEnd = this.startOffset;
            }
            else
            {
               this.selectionStart = this.startOffset;
               this.selectionEnd = _loc2_;
            }
         }
         this.drawWave();
      }
      
      public function dragEnd(param1:MouseEvent) : void
      {
         this.selectMode = null;
      }
      
      private function offsetAtMouse() : int
      {
         var _loc1_:int = globalToLocal(new Point(stage.mouseX,0)).x;
         return this.clipTo(this.scrollStart + _loc1_,0,this.condensedSamples.length);
      }
      
      private function mousePastEnd() : Boolean
      {
         var _loc1_:int = globalToLocal(new Point(stage.mouseX,0)).x;
         return this.scrollStart + _loc1_ > this.condensedSamples.length;
      }
      
      private function step(param1:Event) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         if(this.selectMode)
         {
            _loc2_ = globalToLocal(new Point(stage.mouseX,0)).x;
            if(_loc2_ < 0)
            {
               this.scrollTo(this.scrollStart + _loc2_ / 4);
            }
            else if(_loc2_ > this.frame.width)
            {
               this.scrollTo(this.scrollStart + (_loc2_ - this.frame.width) / 4);
            }
            this.dragMove(null);
         }
         if(this.soundChannel)
         {
            _loc3_ = this.playStart + this.soundChannel.position * this.samplingRate / (1000 * this.samplesPerCondensedSample);
            _loc3_ = Math.min(_loc3_,this.condensedSamples.length);
            if(_loc3_ < this.scrollStart)
            {
               this.scrollTo(_loc3_);
            }
            if(_loc3_ >= this.scrollStart + this.frame.width)
            {
               this.scrollTo(_loc3_);
            }
            this.playCursor.x = this.clipTo(_loc3_ - this.scrollStart + 1,1,this.frame.width - 1);
         }
      }
   }
}

