package ui.media
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.text.*;
   import flash.utils.ByteArray;
   import scratch.*;
   import sound.ScratchSoundPlayer;
   import sound.mp3.MP3SoundPlayer;
   import svgutils.SVGImporter;
   import translation.Translator;
   import uiwidgets.*;
   import util.*;
   
   public class MediaLibraryItem extends Sprite
   {
      
      private static var spriteCache:Object = {};
      
      private static var thumbnailCache:Object = {};
      
      public var dbObj:Object;
      
      public var isSound:Boolean;
      
      public var frameWidth:int;
      
      public var frameHeight:int;
      
      private var thumbnailWidth:int;
      
      private var thumbnailHeight:int;
      
      private const labelFormat:TextFormat = new TextFormat(CSS.font,14,CSS.textColor);
      
      private const infoFormat:TextFormat = new TextFormat(CSS.font,10,CSS.textColor);
      
      private var frame:Shape;
      
      protected var thumbnail:Bitmap;
      
      protected var label:DisplayObject;
      
      private var info:TextField;
      
      private var playButton:IconButton;
      
      private var sndData:ByteArray;
      
      private var sndPlayer:ScratchSoundPlayer;
      
      private var loaders:Array = [];
      
      public function MediaLibraryItem(param1:Object = null)
      {
         super();
         this.dbObj = param1;
         if(this.dbObj.seconds)
         {
            this.isSound = true;
         }
         this.frameWidth = this.isSound ? 115 : 140;
         this.frameHeight = this.isSound ? 95 : 140;
         this.thumbnailWidth = this.isSound ? 68 : 120;
         this.thumbnailHeight = this.isSound ? 51 : 90;
         this.addFrame();
         this.addThumbnail();
         this.addLabel();
         this.addInfo();
         this.unhighlight();
         if(this.isSound)
         {
            this.addPlayButton();
         }
      }
      
      public static function strings() : Array
      {
         return ["Costumes:","Scripts:"];
      }
      
      public function loadThumbnail(param1:Function) : void
      {
         var _loc2_:String = this.fileType(this.dbObj.md5);
         if(["gif","png","jpg","jpeg","svg"].indexOf(_loc2_) > -1)
         {
            this.setImageThumbnail(this.dbObj.md5,param1);
         }
         else if(_loc2_ == "json")
         {
            this.setSpriteThumbnail(param1);
         }
      }
      
      public function stopLoading() : void
      {
         var _loc2_:URLLoader = null;
         var _loc1_:Scratch = root as Scratch;
         for each(_loc2_ in this.loaders)
         {
            if(_loc2_)
            {
               _loc2_.close();
            }
         }
         this.loaders = [];
      }
      
      private function fileType(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         var _loc2_:int = param1.lastIndexOf(".");
         return _loc2_ < 0 ? "" : param1.slice(_loc2_ + 1);
      }
      
      private function setImageThumbnail(param1:String, param2:Function, param3:String = null) : void
      {
         var forStage:Boolean = false;
         var importer:SVGImporter = null;
         var gotSVGData:Function = null;
         var svgImagesLoaded:Function = null;
         var setThumbnail:Function = null;
         var md5:String = param1;
         var done:Function = param2;
         var spriteMD5:String = param3;
         gotSVGData = function(param1:ByteArray):void
         {
            if(param1)
            {
               importer = new SVGImporter(XML(param1));
               importer.loadAllImages(svgImagesLoaded);
            }
            else
            {
               done();
            }
         };
         svgImagesLoaded = function():void
         {
            var _loc1_:ScratchCostume = new ScratchCostume("",null);
            _loc1_.setSVGRoot(importer.root,false);
            setThumbnail(_loc1_.thumbnail(thumbnailWidth,thumbnailHeight,forStage));
            done();
         };
         setThumbnail = function(param1:BitmapData):void
         {
            if(param1)
            {
               thumbnailCache[md5] = param1;
               if(spriteMD5)
               {
                  thumbnailCache[spriteMD5] = param1;
               }
               setThumbnailBM(param1);
            }
            done();
         };
         forStage = this.dbObj.width == 480;
         var cachedBM:BitmapData = thumbnailCache[md5];
         if(cachedBM)
         {
            this.setThumbnailBM(cachedBM);
            done();
            return;
         }
         if(this.fileType(md5) == "svg")
         {
            this.loaders.push(Scratch.app.server.getAsset(md5,gotSVGData));
         }
         else
         {
            this.loaders.push(Scratch.app.server.getThumbnail(md5,this.thumbnailWidth,this.thumbnailHeight,setThumbnail));
         }
      }
      
      private function setSpriteThumbnail(param1:Function) : void
      {
         var gotJSONData:Function = null;
         var spriteMD5:String = null;
         var done:Function = param1;
         gotJSONData = function(param1:String):void
         {
            var _loc2_:String = null;
            var _loc3_:Object = null;
            var _loc4_:Array = null;
            var _loc5_:Object = null;
            if(param1)
            {
               _loc3_ = util.JSON.parse(param1);
               spriteCache[spriteMD5] = param1;
               dbObj.scriptCount = _loc3_.scripts is Array ? _loc3_.scripts.length : 0;
               dbObj.costumeCount = _loc3_.costumes is Array ? _loc3_.costumes.length : 0;
               dbObj.soundCount = _loc3_.sounds is Array ? _loc3_.sounds.length : 0;
               if(dbObj.scriptCount > 0)
               {
                  setInfo(Translator.map("Scripts:") + " " + dbObj.scriptCount);
               }
               else if(dbObj.costumeCount > 1)
               {
                  setInfo(Translator.map("Costumes:") + " " + dbObj.costumeCount);
               }
               else
               {
                  setInfo("");
               }
               if(_loc3_.costumes is Array && _loc3_.currentCostumeIndex is Number)
               {
                  _loc4_ = _loc3_.costumes;
                  _loc5_ = _loc4_[Math.round(_loc3_.currentCostumeIndex) % _loc4_.length];
                  if(_loc5_)
                  {
                     _loc2_ = _loc5_.baseLayerMD5;
                  }
               }
            }
            if(_loc2_)
            {
               setImageThumbnail(_loc2_,done,spriteMD5);
            }
            else
            {
               done();
            }
         };
         spriteMD5 = this.dbObj.md5;
         var cachedBM:BitmapData = thumbnailCache[spriteMD5];
         if(cachedBM)
         {
            this.setThumbnailBM(cachedBM);
            done();
            return;
         }
         if(spriteCache[spriteMD5])
         {
            gotJSONData(spriteCache[spriteMD5]);
         }
         else
         {
            this.loaders.push(Scratch.app.server.getAsset(spriteMD5,gotJSONData));
         }
      }
      
      private function setThumbnailBM(param1:BitmapData) : void
      {
         this.thumbnail.bitmapData = param1;
         this.thumbnail.x = (this.frameWidth - this.thumbnail.width) / 2;
      }
      
      private function setInfo(param1:String) : void
      {
         this.info.text = param1;
         this.info.x = Math.max(0,(this.frameWidth - this.info.textWidth) / 2);
      }
      
      private function addFrame() : void
      {
         this.frame = new Shape();
         var _loc1_:Graphics = this.frame.graphics;
         _loc1_.lineStyle(3,CSS.overColor,1,true);
         _loc1_.beginFill(CSS.itemSelectedColor);
         _loc1_.drawRoundRect(0,0,this.frameWidth,this.frameHeight,12,12);
         _loc1_.endFill();
         addChild(this.frame);
      }
      
      protected function addThumbnail() : void
      {
         var _loc1_:BitmapData = null;
         if(this.isSound)
         {
            this.thumbnail = Resources.createBmp("speakerOff");
            this.thumbnail.x = 22;
            this.thumbnail.y = 25;
         }
         else
         {
            _loc1_ = new BitmapData(1,1,true,0);
            this.thumbnail = new Bitmap(_loc1_);
            this.thumbnail.x = (this.frameWidth - this.thumbnail.width) / 2;
            this.thumbnail.y = 13;
         }
         addChild(this.thumbnail);
      }
      
      protected function addLabel() : void
      {
         var _loc1_:String = this.dbObj.name ? this.dbObj.name : "";
         var _loc2_:TextField = Resources.makeLabel(_loc1_,this.labelFormat);
         this.label = _loc2_;
         this.label.x = (this.frameWidth - _loc2_.textWidth) / 2 - 2;
         this.label.y = this.frameHeight - 32;
         addChild(this.label);
      }
      
      private function addInfo() : void
      {
         this.info = Resources.makeLabel("",this.infoFormat);
         this.info.x = Math.max(0,(this.frameWidth - this.info.textWidth) / 2);
         this.info.y = this.frameHeight - 17;
         addChild(this.info);
      }
      
      private function addPlayButton() : void
      {
         this.playButton = new IconButton(this.toggleSoundPlay,"play");
         this.playButton.x = 75;
         this.playButton.y = 28;
         addChild(this.playButton);
      }
      
      private function setText(param1:TextField, param2:String) : void
      {
         var _loc3_:int = this.frame.width - 6;
         param1.text = param2;
         while(param1.textWidth > _loc3_ && param2.length > 0)
         {
            param2 = param2.substring(0,param2.length - 1);
            param1.text = param2 + "…";
         }
      }
      
      public function click(param1:MouseEvent) : void
      {
         if(!param1.shiftKey)
         {
            this.unhighlightAll();
         }
         this.toggleHighlight();
      }
      
      public function doubleClick(param1:MouseEvent) : void
      {
         if(!param1.shiftKey)
         {
            this.unhighlightAll();
         }
         this.highlight();
         var _loc2_:MediaLibrary = parent.parent.parent as MediaLibrary;
         if(_loc2_)
         {
            _loc2_.addSelected();
         }
      }
      
      public function isHighlighted() : Boolean
      {
         return this.frame.alpha == 1;
      }
      
      private function toggleHighlight() : void
      {
         if(this.frame.alpha == 1)
         {
            this.unhighlight();
         }
         else
         {
            this.highlight();
         }
      }
      
      private function highlight() : void
      {
         if(this.frame.alpha != 1)
         {
            this.frame.alpha = 1;
            this.info.visible = true;
         }
      }
      
      private function unhighlight() : void
      {
         if(this.frame.alpha != 0)
         {
            this.frame.alpha = 0;
            this.info.visible = false;
         }
      }
      
      private function unhighlightAll() : void
      {
         var _loc2_:int = 0;
         var _loc3_:MediaLibraryItem = null;
         var _loc1_:ScrollFrameContents = parent as ScrollFrameContents;
         if(_loc1_)
         {
            _loc2_ = 0;
            while(_loc2_ < _loc1_.numChildren)
            {
               _loc3_ = _loc1_.getChildAt(_loc2_) as MediaLibraryItem;
               if(_loc3_)
               {
                  _loc3_.unhighlight();
               }
               _loc2_++;
            }
         }
      }
      
      private function toggleSoundPlay(param1:IconButton) : void
      {
         if(this.sndPlayer)
         {
            this.stopPlayingSound(null);
         }
         else
         {
            this.startPlayingSound();
         }
      }
      
      private function stopPlayingSound(param1:*) : void
      {
         if(this.sndPlayer)
         {
            this.sndPlayer.stopPlaying();
         }
         this.sndPlayer = null;
         this.playButton.turnOff();
      }
      
      private function startPlayingSound() : void
      {
         if(this.sndData)
         {
            if(ScratchSound.isWAV(this.sndData))
            {
               this.sndPlayer = new ScratchSoundPlayer(this.sndData);
            }
            else
            {
               this.sndPlayer = new MP3SoundPlayer(this.sndData);
            }
         }
         if(this.sndPlayer)
         {
            this.sndPlayer.startPlaying(this.stopPlayingSound);
            this.playButton.turnOn();
         }
         else
         {
            this.downloadAndPlay();
         }
      }
      
      private function downloadAndPlay() : void
      {
         var gotSoundData:Function = null;
         gotSoundData = function(param1:ByteArray):void
         {
            if(!param1)
            {
               return;
            }
            sndData = param1;
            startPlayingSound();
         };
         Scratch.app.server.getAsset(this.dbObj.md5,gotSoundData);
      }
   }
}

