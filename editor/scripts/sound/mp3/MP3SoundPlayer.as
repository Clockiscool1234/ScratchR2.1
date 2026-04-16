package sound.mp3
{
   import flash.events.Event;
   import flash.events.SampleDataEvent;
   import flash.media.Sound;
   import flash.utils.ByteArray;
   import sound.ScratchSoundPlayer;
   
   public class MP3SoundPlayer extends ScratchSoundPlayer
   {
      
      private var mp3Sound:Sound;
      
      private var isLoading:Boolean;
      
      public function MP3SoundPlayer(param1:ByteArray)
      {
         super(null);
         this.soundData = param1;
      }
      
      override public function atEnd() : Boolean
      {
         if(this.isLoading)
         {
            return false;
         }
         return soundChannel == null;
      }
      
      override public function startPlaying(param1:Function = null) : void
      {
         var loadDone:Function = null;
         var doneFunction:Function = param1;
         loadDone = function(param1:Sound):void
         {
            mp3Sound = param1;
            startChannel(doneFunction);
         };
         stopIfAlreadyPlaying();
         activeSounds.push(this);
         this.isLoading = true;
         if(this.mp3Sound == null)
         {
            MP3Loader.load(soundData,loadDone);
         }
         else
         {
            this.startChannel(doneFunction);
         }
      }
      
      private function startChannel(param1:Function) : void
      {
         var _loc2_:Sound = new Sound();
         _loc2_.addEventListener(SampleDataEvent.SAMPLE_DATA,this.writeSampleData);
         soundChannel = _loc2_.play();
         this.isLoading = false;
         if(param1 != null)
         {
            soundChannel.addEventListener(Event.SOUND_COMPLETE,param1);
         }
      }
      
      private function writeSampleData(param1:SampleDataEvent) : void
      {
         var _loc2_:ByteArray = new ByteArray();
         var _loc3_:int = this.mp3Sound.extract(_loc2_,4096);
         _loc2_.position = 0;
         updateVolume();
         while(_loc2_.bytesAvailable >= 4)
         {
            param1.data.writeFloat(volume * _loc2_.readFloat());
         }
         if(_loc3_ < 4096)
         {
            soundChannel = null;
            stopPlaying();
         }
      }
   }
}

