package sound
{
   import flash.utils.ByteArray;
   
   public class NotePlayer extends ScratchSoundPlayer
   {
      
      private var originalPitch:Number;
      
      private var index:Number = 0;
      
      private var samplesRemaining:int;
      
      private var isLooped:Boolean = false;
      
      private var loopPoint:int;
      
      private var loopLength:Number;
      
      private var envelopeValue:Number = 1;
      
      private var samplesSinceStart:int = 0;
      
      private var attackEnd:int = 0;
      
      private var attackRate:Number = 0;
      
      private var holdEnd:int = 0;
      
      private var decayRate:Number = 1;
      
      public function NotePlayer(param1:ByteArray, param2:Number, param3:int = -1, param4:int = -1, param5:Array = null)
      {
         var oneCycle:Number = NaN;
         var cycles:int = 0;
         var decayCount:int = 0;
         var soundData:ByteArray = param1;
         var originalPitch:Number = param2;
         var loopStart:int = param3;
         var loopEnd:int = param4;
         var env:Array = param5;
         super(null);
         if(soundData == null)
         {
            soundData = new ByteArray();
         }
         this.soundData = soundData;
         this.originalPitch = originalPitch;
         stepSize = 0.5;
         startOffset = 0;
         endOffset = soundData.length / 2;
         getSample = function():int
         {
            return 0;
         };
         if(loopStart >= 0 && loopStart < endOffset)
         {
            this.isLooped = true;
            this.loopPoint = loopStart;
            if(loopEnd > 0 && loopEnd <= endOffset)
            {
               endOffset = loopEnd;
            }
            this.loopLength = endOffset - this.loopPoint;
            oneCycle = 22050 / originalPitch;
            cycles = Math.round(this.loopLength / oneCycle);
            this.originalPitch = 22050 / (this.loopLength / cycles);
         }
         if(env)
         {
            this.attackEnd = env[0] * 44.1;
            if(this.attackEnd > 0)
            {
               this.attackRate = Math.pow(33000,1 / this.attackEnd);
            }
            this.holdEnd = this.attackEnd + env[1] * 44.1;
            decayCount = env[2] * 44100;
            this.decayRate = decayCount == 0 ? 1 : Math.pow(33000,-1 / decayCount);
         }
      }
      
      public function setNoteAndDuration(param1:Number, param2:Number) : void
      {
         param1 = Math.max(0,Math.min(param1,127));
         var _loc3_:Number = 440 * Math.pow(2,(param1 - 69) / 12);
         stepSize = _loc3_ / (2 * this.originalPitch);
         this.setDuration(param2);
      }
      
      public function setDuration(param1:Number) : void
      {
         this.samplesSinceStart = 0;
         this.samplesRemaining = 44100 * param1;
         if(!this.isLooped)
         {
            this.samplesRemaining = Math.min(this.samplesRemaining,endOffset / stepSize);
         }
         this.envelopeValue = this.attackEnd > 0 ? 1 / 33000 : 1;
      }
      
      override protected function interpolatedSample() : Number
      {
         var _loc8_:Number = NaN;
         if(this.samplesRemaining-- <= 0)
         {
            noteFinished();
            return 0;
         }
         this.index += stepSize;
         if(this.index >= endOffset)
         {
            if(!this.isLooped)
            {
               return 0;
            }
            _loc8_ = this.loopLength - (this.index - endOffset) % this.loopLength;
            if(_loc8_ == 0)
            {
               this.index = endOffset - this.loopLength;
            }
            else
            {
               this.index = endOffset - _loc8_;
            }
         }
         var _loc1_:int = int(this.index);
         var _loc2_:Number = this.index - _loc1_;
         var _loc3_:int = _loc1_ << 1;
         var _loc4_:int = (soundData[_loc3_ + 1] << 8) + soundData[_loc3_];
         var _loc5_:Number = _loc4_ <= 32767 ? _loc4_ : _loc4_ - 65536;
         _loc1_++;
         var _loc6_:Number = -1;
         if(_loc1_ >= endOffset)
         {
            if(this.isLooped)
            {
               _loc1_ = this.loopPoint;
            }
            else
            {
               _loc6_ = 0;
            }
         }
         if(_loc6_ < 0)
         {
            _loc3_ = _loc1_ << 1;
            _loc4_ = (soundData[_loc3_ + 1] << 8) + soundData[_loc3_];
            _loc6_ = _loc4_ <= 32767 ? _loc4_ : _loc4_ - 65536;
         }
         var _loc7_:Number = (_loc5_ + _loc2_ * (_loc6_ - _loc5_)) / 100000;
         if(this.samplesRemaining < 1000)
         {
            _loc7_ *= this.samplesRemaining / 1000;
         }
         this.updateEnvelope();
         return this.envelopeValue * volume * _loc7_;
      }
      
      private function updateEnvelope() : void
      {
         ++this.samplesSinceStart;
         if(this.samplesSinceStart < this.attackEnd)
         {
            this.envelopeValue *= this.attackRate;
         }
         else if(this.samplesSinceStart == this.attackEnd)
         {
            this.envelopeValue = 1;
         }
         else if(this.samplesSinceStart > this.holdEnd && this.decayRate < 1)
         {
            this.envelopeValue *= this.decayRate;
         }
      }
   }
}

