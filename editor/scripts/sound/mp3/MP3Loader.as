package sound.mp3
{
   import flash.display.*;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.media.Sound;
   import flash.system.*;
   import flash.utils.*;
   import scratch.ScratchSound;
   
   public class MP3Loader
   {
      
      private static const soundClassSwfBytes1:Array = [70,87,83,9];
      
      private static const soundClassSwfBytes2:Array = [120,0,5,95,0,0,15,160,0,0,12,1,0,68,17,8,0,0,0,67,2,255,255,255,191,21,11,0,0,0,1,0,83,99,101,110,101,32,49,0,0,191,20,200,0,0,0,0,0,0,0,0,16,0,46,0,0,0,0,8,10,83,111,117,110,100,67,108,97,115,115,0,11,102,108,97,115,104,46,109,101,100,105,97,5,83,111,117,110,100,6,79,98,106,101,99,116,15,69,118,101,110,116,68,105,115,112,97,116,99,104,101,114,12,102,108,97,115,104,46,101,118,101,110,116,115,6,5,1,22,2,22,3,24,1,22,7,0,5,7,2,1,7,3,4,7,2,5,7,5,6,3,0,0,2,0,0,0,2,0,0,0,2,0,0,1,1,2,8,4,0,1,0,0,0,1,2,1,1,4,1,0,3,0,1,1,5,6,3,208,48,71,0,0,1,1,1,6,7,6,208,48,208,73,0,71,0,0,2,2,1,1,5,31,208,48,101,0,93,3,102,3,48,93,4,102,4,48,93,2,102,2,48,93,2,102,2,88,0,29,29,29,104,1,71,0,0,191,3];
      
      private static const soundClassSwfBytes3:Array = [63,19,15,0,0,0,1,0,1,0,83,111,117,110,100,67,108,97,115,115,0,68,11,15,0,0,0,64,0,0,0];
      
      public function MP3Loader()
      {
         super();
      }
      
      public static function convertToScratchSound(param1:String, param2:ByteArray, param3:Function) : void
      {
         var loaded:Function = null;
         var mp3Info:Object = null;
         var sndName:String = param1;
         var sndData:ByteArray = param2;
         var whenDone:Function = param3;
         loaded = function(param1:Sound):void
         {
            extractSamples(sndName,param1,mp3Info.sampleCount,whenDone);
         };
         mp3Info = new MP3FileReader(sndData).getInfo();
         if(mp3Info.sampleCount == 0)
         {
            if(Scratch.app.lp)
            {
               Scratch.app.removeLoadProgressBox();
            }
            whenDone(null);
            return;
         }
         load(sndData,loaded);
      }
      
      public static function extractSamples(param1:String, param2:Sound, param3:int, param4:Function) : void
      {
         var extractedSamples:Vector.<int> = null;
         var buf:ByteArray = null;
         var convertedSamples:int = 0;
         var convertNextChunk:Function = null;
         var compressSamples:Function = null;
         var sndName:String = param1;
         var mp3Snd:Sound = param2;
         var mp3SampleCount:int = param3;
         var whenDone:Function = param4;
         convertNextChunk = function():void
         {
            var _loc3_:Number = NaN;
            buf.position = 0;
            var _loc1_:int = mp3Snd.extract(buf,4000);
            if(_loc1_ == 0 || convertedSamples >= mp3SampleCount)
            {
               if(Scratch.app.lp)
               {
                  Scratch.app.lp.setTitle("Compressing...");
               }
               setTimeout(compressSamples,50);
               return;
            }
            convertedSamples += _loc1_;
            buf.position = 0;
            _loc1_ /= 2;
            var _loc2_:int = 0;
            while(_loc2_ < _loc1_)
            {
               _loc3_ = buf.readFloat() + buf.readFloat();
               extractedSamples.push(16383 * _loc3_);
               buf.position += 8;
               _loc2_++;
            }
            if(Scratch.app.lp)
            {
               Scratch.app.lp.setProgress(Math.min(convertedSamples / mp3SampleCount,1));
            }
            setTimeout(convertNextChunk,1);
         };
         compressSamples = function():void
         {
            var _loc1_:ScratchSound = new ScratchSound(sndName,null);
            _loc1_.setSamples(extractedSamples,22050,true);
            whenDone(_loc1_);
         };
         extractedSamples = new Vector.<int>();
         buf = new ByteArray();
         mp3Snd.extract(buf,0,0);
         convertNextChunk();
      }
      
      public static function load(param1:ByteArray, param2:Function) : void
      {
         var mp3Parser:MP3FileReader;
         var originalEndian:String = null;
         var mp3Data:ByteArray = param1;
         var whenDone:Function = param2;
         var done:Function = function(param1:Sound):void
         {
            mp3Data.endian = originalEndian;
            whenDone(param1);
         };
         originalEndian = mp3Data.endian;
         mp3Data.endian = Endian.BIG_ENDIAN;
         mp3Parser = new MP3FileReader(mp3Data);
         generateSound(mp3Parser,whenDone);
      }
      
      private static function generateSound(param1:MP3FileReader, param2:Function) : void
      {
         var swfSizePosition:uint;
         var audioSizePosition:uint;
         var sampleSizePosition:uint;
         var frameCount:uint;
         var byteCount:uint;
         var loaderContext:LoaderContext;
         var swfBytesLoader:Loader;
         var swfCreated:Function = null;
         var frameSize:int = 0;
         var mp3Source:MP3FileReader = param1;
         var whenDone:Function = param2;
         swfCreated = function(param1:Event):void
         {
            var _loc2_:LoaderInfo = param1.currentTarget as LoaderInfo;
            var _loc3_:Class = _loc2_.applicationDomain.getDefinition("SoundClass") as Class;
            whenDone(new _loc3_());
         };
         var swfBytes:ByteArray = new ByteArray();
         swfBytes.endian = Endian.LITTLE_ENDIAN;
         appendBytes(swfBytes,soundClassSwfBytes1);
         swfSizePosition = swfBytes.position;
         swfBytes.writeInt(0);
         appendBytes(swfBytes,soundClassSwfBytes2);
         audioSizePosition = swfBytes.position;
         swfBytes.writeInt(0);
         swfBytes.writeByte(1);
         swfBytes.writeByte(0);
         swfBytes.writeByte(mp3Source.swfFormatByte());
         sampleSizePosition = swfBytes.position;
         swfBytes.writeInt(0);
         swfBytes.writeShort(0);
         frameCount = 0;
         byteCount = 0;
         while(true)
         {
            frameSize = mp3Source.appendFrame(swfBytes);
            if(frameSize == 0)
            {
               break;
            }
            byteCount += frameSize;
            frameCount++;
         }
         if(byteCount == 0)
         {
            return;
         }
         appendBytes(swfBytes,soundClassSwfBytes3);
         swfBytes.position = audioSizePosition;
         swfBytes.writeInt(byteCount + 9);
         swfBytes.position = sampleSizePosition;
         swfBytes.writeInt(frameCount * 1152);
         swfBytes.position = swfSizePosition;
         swfBytes.writeInt(swfBytes.length);
         swfBytes.position = 0;
         loaderContext = new LoaderContext();
         if(Capabilities.playerType == "Desktop")
         {
            loaderContext.allowLoadBytesCodeExecution = true;
         }
         swfBytesLoader = new Loader();
         swfBytesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,swfCreated);
         swfBytesLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(param1:Event):void
         {
            whenDone(null);
         });
         swfBytesLoader.loadBytes(swfBytes,loaderContext);
      }
      
      private static function appendBytes(param1:ByteArray, param2:Array) : void
      {
         var _loc3_:int = 0;
         while(_loc3_ < param2.length)
         {
            param1.writeByte(param2[_loc3_]);
            _loc3_++;
         }
      }
   }
}

