package primitives
{
   import blocks.Block;
   import flash.utils.Dictionary;
   import interpreter.*;
   import scratch.*;
   import sound.*;
   
   public class SoundPrims
   {
      
      private var app:Scratch;
      
      private var interp:Interpreter;
      
      private const instrumentMap:Array = [1,1,1,1,2,2,4,4,17,17,17,16,19,16,17,17,3,3,3,3,3,3,3,3,4,4,5,5,5,5,5,5,6,6,6,6,6,6,6,6,8,8,8,8,8,7,8,19,8,8,8,8,15,15,15,19,9,9,9,9,9,9,9,9,11,11,11,11,14,14,14,10,12,12,13,13,13,13,12,12,20,20,20,20,20,20,20,20,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,21,4,4,4,4,17,14,8,10,17,17,18,19,1,1,1,1,21,21,21,21,21,21,21,21];
      
      public function SoundPrims(param1:Scratch, param2:Interpreter)
      {
         super();
         this.app = param1;
         this.interp = param2;
      }
      
      public function addPrimsTo(param1:Dictionary) : void
      {
         var primTable:Dictionary = param1;
         primTable["playSound:"] = this.primPlaySound;
         primTable["doPlaySoundAndWait"] = this.primPlaySoundUntilDone;
         primTable["stopAllSounds"] = function(param1:*):*
         {
            ScratchSoundPlayer.stopAllSounds();
         };
         primTable["drum:duration:elapsed:from:"] = this.primPlayDrum;
         primTable["playDrum"] = this.primPlayDrum;
         primTable["rest:elapsed:from:"] = this.primPlayRest;
         primTable["noteOn:duration:elapsed:from:"] = this.primPlayNote;
         primTable["midiInstrument:"] = this.primSetInstrument;
         primTable["instrument:"] = this.primSetInstrument;
         primTable["changeVolumeBy:"] = this.primChangeVolume;
         primTable["setVolumeTo:"] = this.primSetVolume;
         primTable["volume"] = this.primVolume;
         primTable["changeTempoBy:"] = function(param1:*):*
         {
            app.stagePane.setTempo(app.stagePane.tempoBPM + interp.numarg(param1,0));
            interp.redraw();
         };
         primTable["setTempoTo:"] = function(param1:*):*
         {
            app.stagePane.setTempo(interp.numarg(param1,0));
            interp.redraw();
         };
         primTable["tempo"] = function(param1:*):*
         {
            return app.stagePane.tempoBPM;
         };
      }
      
      private function primPlaySound(param1:Block) : void
      {
         var _loc2_:ScratchSound = this.interp.targetObj().findSound(this.interp.arg(param1,0));
         if(_loc2_ != null)
         {
            this.playSound(_loc2_,this.interp.targetObj());
         }
      }
      
      private function primPlaySoundUntilDone(param1:Block) : void
      {
         var _loc4_:ScratchSound = null;
         var _loc2_:Thread = this.interp.activeThread;
         if(_loc2_.firstTime)
         {
            _loc4_ = this.interp.targetObj().findSound(this.interp.arg(param1,0));
            if(_loc4_ == null)
            {
               return;
            }
            _loc2_.tmpObj = this.playSound(_loc4_,this.interp.targetObj());
            _loc2_.firstTime = false;
         }
         var _loc3_:ScratchSoundPlayer = ScratchSoundPlayer(_loc2_.tmpObj);
         if(_loc3_ == null || _loc3_.atEnd())
         {
            _loc2_.tmp = 0;
            _loc2_.firstTime = true;
         }
         else
         {
            this.interp.doYield();
         }
      }
      
      private function primPlayNote(param1:Block) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_ == null)
         {
            return;
         }
         if(this.interp.activeThread.firstTime)
         {
            _loc3_ = this.interp.numarg(param1,0);
            _loc4_ = this.beatsToSeconds(this.interp.numarg(param1,1));
            this.interp.activeThread.tmpObj = this.playNote(_loc2_.instrument,_loc3_,_loc4_,_loc2_);
            this.interp.startTimer(_loc4_);
         }
         else
         {
            this.interp.checkTimer();
         }
      }
      
      private function primPlayDrum(param1:Block) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         var _loc5_:Number = NaN;
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_ == null)
         {
            return;
         }
         if(this.interp.activeThread.firstTime)
         {
            _loc3_ = Math.round(this.interp.numarg(param1,0));
            _loc4_ = param1.op == "drum:duration:elapsed:from:";
            _loc5_ = this.beatsToSeconds(this.interp.numarg(param1,1));
            this.playDrum(_loc3_,_loc4_,10,_loc2_);
            this.interp.startTimer(_loc5_);
         }
         else
         {
            this.interp.checkTimer();
         }
      }
      
      private function playSound(param1:ScratchSound, param2:ScratchObj) : ScratchSoundPlayer
      {
         var _loc3_:ScratchSoundPlayer = param1.sndplayer();
         _loc3_.client = param2;
         _loc3_.startPlaying();
         return _loc3_;
      }
      
      private function playDrum(param1:int, param2:Boolean, param3:Number, param4:ScratchObj) : ScratchSoundPlayer
      {
         var _loc5_:NotePlayer = SoundBank.getDrumPlayer(param1,param2,param3);
         if(_loc5_ == null)
         {
            return null;
         }
         _loc5_.client = param4;
         _loc5_.setDuration(param3);
         _loc5_.startPlaying();
         return _loc5_;
      }
      
      private function playNote(param1:int, param2:Number, param3:Number, param4:ScratchObj) : ScratchSoundPlayer
      {
         var _loc5_:NotePlayer = SoundBank.getNotePlayer(param1,param2);
         if(_loc5_ == null)
         {
            return null;
         }
         _loc5_.client = param4;
         _loc5_.setNoteAndDuration(param2,param3);
         _loc5_.startPlaying();
         return _loc5_;
      }
      
      private function primPlayRest(param1:Block) : void
      {
         var _loc3_:Number = NaN;
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_ == null)
         {
            return;
         }
         if(this.interp.activeThread.firstTime)
         {
            _loc3_ = this.beatsToSeconds(this.interp.numarg(param1,0));
            this.interp.startTimer(_loc3_);
         }
         else
         {
            this.interp.checkTimer();
         }
      }
      
      private function beatsToSeconds(param1:Number) : Number
      {
         return param1 * 60 / this.app.stagePane.tempoBPM;
      }
      
      private function primSetInstrument(param1:Block) : void
      {
         var _loc2_:int = this.interp.numarg(param1,0) - 1;
         if(param1.op == "midiInstrument:")
         {
            _loc2_ = this.instrumentMap[_loc2_] - 1;
         }
         _loc2_ = Math.max(0,Math.min(_loc2_,SoundBank.instrumentNames.length - 1));
         if(this.interp.targetObj())
         {
            this.interp.targetObj().instrument = _loc2_;
         }
      }
      
      private function primChangeVolume(param1:Block) : void
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_ != null)
         {
            _loc2_.setVolume(_loc2_.volume + this.interp.numarg(param1,0));
            this.interp.redraw();
         }
      }
      
      private function primSetVolume(param1:Block) : void
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_ != null)
         {
            _loc2_.setVolume(this.interp.numarg(param1,0));
            this.interp.redraw();
         }
      }
      
      private function primVolume(param1:Block) : Number
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         return _loc2_ != null ? _loc2_.volume : 0;
      }
   }
}

