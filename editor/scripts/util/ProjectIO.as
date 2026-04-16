package util
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.URLLoader;
   import flash.utils.*;
   import logging.LogLevel;
   import scratch.*;
   import sound.WAVFile;
   import sound.mp3.MP3Loader;
   import svgutils.*;
   import translation.Translator;
   import uiwidgets.DialogBox;
   
   public class ProjectIO
   {
      
      private static var translationStrings:Object = {
         "imageLoadingErrorTitle":"Image Loading Error",
         "imageLoadingErrorHeader":"At least one backdrop or costume failed to load:",
         "imageLoadingErrorBackdrop":"Backdrop: {costumeName}",
         "imageLoadingErrorSprite":"Sprite: {spriteName}",
         "imageLoadingErrorCostume":"Costume: {costumeName}"
      };
      
      protected var app:Scratch;
      
      protected var images:Array = [];
      
      protected var sounds:Array = [];
      
      public function ProjectIO(param1:Scratch)
      {
         super();
         this.app = param1;
      }
      
      public static function strings() : Array
      {
         var _loc2_:String = null;
         var _loc1_:Array = [];
         for each(_loc2_ in translationStrings)
         {
            if(translationStrings.hasOwnProperty(_loc2_))
            {
               _loc1_.push(translationStrings[_loc2_]);
            }
         }
         return _loc1_;
      }
      
      public function encodeProjectAsZipFile(param1:ScratchStage) : ByteArray
      {
         delete param1.info.penTrails;
         param1.savePenLayer();
         param1.updateInfo();
         this.recordImagesAndSounds(param1.allObjects(),false,param1);
         var _loc2_:ZipIO = new ZipIO();
         _loc2_.startWrite();
         this.addJSONData("project.json",param1,_loc2_);
         this.addImagesAndSounds(_loc2_);
         param1.clearPenLayer();
         return _loc2_.endWrite();
      }
      
      public function encodeSpriteAsZipFile(param1:ScratchSprite) : ByteArray
      {
         this.recordImagesAndSounds([param1],false);
         var _loc2_:ZipIO = new ZipIO();
         _loc2_.startWrite();
         this.addJSONData("sprite.json",param1,_loc2_);
         this.addImagesAndSounds(_loc2_);
         return _loc2_.endWrite();
      }
      
      protected function getScratchStage() : ScratchStage
      {
         return new ScratchStage();
      }
      
      private function addJSONData(param1:String, param2:*, param3:ZipIO) : void
      {
         var _loc4_:ByteArray = new ByteArray();
         _loc4_.writeUTFBytes(util.JSON.stringify(param2));
         param3.write(param1,_loc4_,true);
      }
      
      private function addImagesAndSounds(param1:ZipIO) : void
      {
         var _loc2_:int = 0;
         var _loc3_:String = null;
         var _loc4_:ByteArray = null;
         var _loc5_:ByteArray = null;
         _loc2_ = 0;
         while(_loc2_ < this.images.length)
         {
            _loc4_ = this.images[_loc2_][1];
            _loc3_ = ScratchCostume.fileExtension(_loc4_);
            param1.write(_loc2_ + _loc3_,_loc4_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.sounds.length)
         {
            _loc5_ = this.sounds[_loc2_][1];
            _loc3_ = ScratchSound.isWAV(_loc5_) ? ".wav" : ".mp3";
            param1.write(_loc2_ + _loc3_,_loc5_);
            _loc2_++;
         }
      }
      
      public function decodeProjectFromZipFile(param1:ByteArray) : ScratchStage
      {
         return this.decodeFromZipFile(param1) as ScratchStage;
      }
      
      public function decodeSpriteFromZipFile(param1:ByteArray, param2:Function, param3:Function = null) : void
      {
         var imagesDecoded:Function = null;
         var spr:ScratchSprite = null;
         var zipData:ByteArray = param1;
         var whenDone:Function = param2;
         var fail:Function = param3;
         imagesDecoded = function():void
         {
            spr.showCostume(spr.currentCostumeIndex);
            whenDone(spr);
         };
         spr = this.decodeFromZipFile(zipData) as ScratchSprite;
         if(spr)
         {
            this.decodeAllImages([spr],imagesDecoded,fail);
         }
         else if(fail != null)
         {
            fail();
         }
      }
      
      protected function decodeFromZipFile(param1:ByteArray) : ScratchObj
      {
         var jsonObj:Object;
         var jsonData:String = null;
         var f:Array = null;
         var files:Array = null;
         var fName:String = null;
         var fIndex:int = 0;
         var contents:ByteArray = null;
         var proj:ScratchStage = null;
         var sprite:ScratchSprite = null;
         var zipData:ByteArray = param1;
         this.images = [];
         this.sounds = [];
         try
         {
            files = new ZipIO().read(zipData);
         }
         catch(e:*)
         {
            app.log(LogLevel.WARNING,"Bad zip file; attempting to recover");
            try
            {
               files = new ZipIO().recover(zipData);
            }
            catch(e:*)
            {
               return null;
            }
         }
         for each(f in files)
         {
            fName = f[0];
            if(fName.indexOf("__MACOSX") <= -1)
            {
               fIndex = int(this.integerName(fName));
               contents = f[1];
               if(fName.slice(-4) == ".gif")
               {
                  this.images[fIndex] = contents;
               }
               if(fName.slice(-4) == ".jpg")
               {
                  this.images[fIndex] = contents;
               }
               if(fName.slice(-4) == ".png")
               {
                  this.images[fIndex] = contents;
               }
               if(fName.slice(-4) == ".svg")
               {
                  this.images[fIndex] = contents;
               }
               if(fName.slice(-4) == ".wav")
               {
                  this.sounds[fIndex] = contents;
               }
               if(fName.slice(-4) == ".mp3")
               {
                  this.sounds[fIndex] = contents;
               }
               if(fName.slice(-5) == ".json")
               {
                  jsonData = contents.readUTFBytes(contents.length);
               }
            }
         }
         if(jsonData == null)
         {
            return null;
         }
         jsonObj = util.JSON.parse(jsonData);
         if(jsonObj["children"])
         {
            proj = this.getScratchStage();
            proj.readJSON(jsonObj);
            if(proj.penLayerID >= 0)
            {
               proj.penLayerPNG = this.images[proj.penLayerID];
            }
            else if(proj.penLayerMD5)
            {
               proj.penLayerPNG = this.images[0];
            }
            this.installImagesAndSounds(proj.allObjects());
            return proj;
         }
         if(jsonObj["direction"] != null)
         {
            sprite = new ScratchSprite();
            sprite.readJSON(jsonObj);
            sprite.instantiateFromJSON(this.app.stagePane);
            this.installImagesAndSounds([sprite]);
            return sprite;
         }
         return null;
      }
      
      private function integerName(param1:String) : String
      {
         var _loc2_:String = "1234567890";
         var _loc3_:int = param1.lastIndexOf(".");
         if(_loc3_ < 0)
         {
            _loc3_ = param1.length;
         }
         var _loc4_:* = int(_loc3_ - 1);
         if(_loc4_ < 0)
         {
            return param1;
         }
         while(_loc4_ >= 0 && _loc2_.indexOf(param1.charAt(_loc4_)) >= 0)
         {
            _loc4_--;
         }
         return param1.slice(_loc4_ + 1,_loc3_);
      }
      
      private function installImagesAndSounds(param1:Array) : void
      {
         var _loc2_:ScratchObj = null;
         var _loc3_:ScratchCostume = null;
         var _loc4_:ScratchSound = null;
         var _loc5_:* = undefined;
         for each(_loc2_ in param1)
         {
            for each(_loc3_ in _loc2_.costumes)
            {
               if(this.images[_loc3_.baseLayerID] != undefined)
               {
                  _loc3_.baseLayerData = this.images[_loc3_.baseLayerID];
               }
               if(this.images[_loc3_.textLayerID] != undefined)
               {
                  _loc3_.textLayerData = this.images[_loc3_.textLayerID];
               }
            }
            for each(_loc4_ in _loc2_.sounds)
            {
               _loc5_ = this.sounds[_loc4_.soundID];
               if(_loc5_)
               {
                  _loc4_.soundData = _loc5_;
                  _loc4_.convertMP3IfNeeded();
               }
            }
         }
      }
      
      public function decodeAllImages(param1:Array, param2:Function, param3:Function = null) : void
      {
         var imageDone:Function = null;
         var imageDict:Dictionary = null;
         var obj:ScratchObj = null;
         var c:ScratchCostume = null;
         var objList:Array = param1;
         var whenDone:Function = param2;
         var fail:Function = param3;
         imageDone = function():void
         {
            if(--numImagesToDecode == 0)
            {
               allImagesLoaded(objList,imageDict,whenDone,fail);
            }
         };
         var numImagesToDecode:int = 1;
         imageDict = new Dictionary();
         for each(obj in objList)
         {
            for each(c in obj.costumes)
            {
               if(c.baseLayerData != null && c.baseLayerBitmap == null)
               {
                  numImagesToDecode++;
                  if(ScratchCostume.isSVGData(c.baseLayerData))
                  {
                     this.decodeSVG(c.baseLayerData,imageDict,imageDone);
                  }
                  else
                  {
                     this.decodeImage(c.baseLayerData,imageDict,imageDone,imageDone);
                  }
               }
               if(c.textLayerData != null && c.textLayerBitmap == null)
               {
                  numImagesToDecode++;
                  this.decodeImage(c.textLayerData,imageDict,imageDone,imageDone);
               }
            }
         }
         imageDone();
      }
      
      private function allImagesLoaded(param1:Array, param2:Dictionary, param3:Function, param4:Function) : void
      {
         var errorCostumes:Vector.<ScratchCostume> = null;
         var errorDialog:DialogBox = null;
         var img:* = undefined;
         var obj:ScratchObj = null;
         var c:ScratchCostume = null;
         var objList:Array = param1;
         var imageDict:Dictionary = param2;
         var whenDone:Function = param3;
         var fail:Function = param4;
         var makeErrorImage:Function = function(param1:ScratchObj, param2:ScratchCostume):*
         {
            var _loc3_:String = null;
            if(!errorDialog)
            {
               errorDialog = new DialogBox();
               errorDialog.addTitle(translationStrings.imageLoadingErrorTitle);
               errorDialog.addText(Translator.map(translationStrings.imageLoadingErrorHeader) + "\n");
            }
            if(param1.isStage)
            {
               _loc3_ = Translator.map(translationStrings.imageLoadingErrorBackdrop);
            }
            else
            {
               _loc3_ = Translator.map(translationStrings.imageLoadingErrorSprite) + "\n" + Translator.map(translationStrings.imageLoadingErrorCostume);
            }
            var _loc4_:Dictionary = new Dictionary();
            _loc4_["spriteName"] = param1.objName;
            _loc4_["costumeName"] = param2.costumeName;
            _loc3_ = StringUtils.substitute(_loc3_,_loc4_);
            errorDialog.addText(_loc3_ + "\n");
            var _loc5_:int = int(param1.isStage);
            var _loc6_:ScratchCostume = errorCostumes[_loc5_] = errorCostumes[_loc5_] || ScratchCostume.emptyBitmapCostume("",param1.isStage);
            return _loc6_.baseLayerBitmap;
         };
         errorCostumes = new Vector.<ScratchCostume>(2);
         var allCostumes:Vector.<ScratchCostume> = new Vector.<ScratchCostume>(0);
         for each(obj in objList)
         {
            for each(c in obj.costumes)
            {
               allCostumes.push(c);
               if(c.baseLayerData != null && c.baseLayerBitmap == null)
               {
                  img = imageDict[c.baseLayerData];
                  if(!img)
                  {
                     c.baseLayerBitmap = makeErrorImage(obj,c);
                     c.baseLayerData = null;
                  }
                  else if(img is BitmapData)
                  {
                     c.baseLayerBitmap = img;
                  }
                  else if(img is SVGElement)
                  {
                     c.setSVGRoot(img,false);
                  }
               }
               if(c.textLayerData != null && c.textLayerBitmap == null)
               {
                  img = imageDict[c.textLayerData];
                  if(img)
                  {
                     c.textLayerBitmap = imageDict[c.textLayerData];
                  }
                  else
                  {
                     c.textLayerBitmap = makeErrorImage(obj,c);
                     c.textLayerData = null;
                  }
               }
            }
         }
         for each(c in allCostumes)
         {
            c.generateOrFindComposite(allCostumes);
         }
         if(errorDialog)
         {
            errorDialog.addButton("OK",errorDialog.accept);
            errorDialog.showOnStage(Scratch.app.stage);
            if(fail != null)
            {
               fail();
            }
            else if(whenDone != null)
            {
               whenDone();
            }
         }
         else if(whenDone != null)
         {
            whenDone();
         }
      }
      
      private function decodeImage(param1:ByteArray, param2:Dictionary, param3:Function, param4:Function) : void
      {
         var loader:Loader;
         var loadDone:Function = null;
         var loadError:Function = null;
         var imageData:ByteArray = param1;
         var imageDict:Dictionary = param2;
         var doneFunction:Function = param3;
         var fail:Function = param4;
         loadDone = function(param1:Event):void
         {
            imageDict[imageData] = param1.target.content.bitmapData;
            doneFunction();
         };
         loadError = function(param1:Event):void
         {
            if(fail != null)
            {
               fail();
            }
         };
         if(imageDict[imageData] != null)
         {
            return;
         }
         if(!imageData || imageData.length == 0)
         {
            if(fail != null)
            {
               fail();
            }
            return;
         }
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadDone);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,loadError);
         loader.loadBytes(imageData);
      }
      
      private function decodeSVG(param1:ByteArray, param2:Dictionary, param3:Function) : void
      {
         var importer:SVGImporter;
         var loadDone:Function = null;
         var svgData:ByteArray = param1;
         var imageDict:Dictionary = param2;
         var doneFunction:Function = param3;
         loadDone = function(param1:SVGElement):void
         {
            imageDict[svgData] = param1;
            doneFunction();
         };
         if(imageDict[svgData] != null)
         {
            doneFunction();
            return;
         }
         importer = new SVGImporter(XML(svgData));
         if(importer.hasUnloadedImages())
         {
            importer.loadAllImages(loadDone);
         }
         else
         {
            loadDone(importer.root);
         }
      }
      
      public function downloadProjectAssets(param1:ByteArray) : void
      {
         var projObject:Object;
         var assetReceived:Function = null;
         var proj:ScratchStage = null;
         var assetsToFetch:Array = null;
         var assetDict:Object = null;
         var assetCount:int = 0;
         var md5:String = null;
         var projectData:ByteArray = param1;
         assetReceived = function(param1:String, param2:ByteArray):void
         {
            assetDict[param1] = param2;
            ++assetCount;
            if(!param2)
            {
               app.log(LogLevel.WARNING,"missing asset: " + param1);
            }
            if(app.lp)
            {
               app.lp.setProgress(assetCount / assetsToFetch.length);
               app.lp.setInfo(assetCount + " " + Translator.map("of") + " " + assetsToFetch.length + " " + Translator.map("assets loaded"));
            }
            if(assetCount == assetsToFetch.length)
            {
               installAssets(proj.allObjects(),assetDict);
               app.runtime.decodeImagesAndInstall(proj);
            }
         };
         projectData.position = 0;
         projObject = util.JSON.parse(projectData.readUTFBytes(projectData.length));
         proj = this.getScratchStage();
         proj.readJSON(projObject);
         assetsToFetch = this.collectAssetsToFetch(proj.allObjects());
         assetDict = new Object();
         assetCount = 0;
         for each(md5 in assetsToFetch)
         {
            this.fetchAsset(md5,assetReceived);
         }
      }
      
      public function fetchImage(param1:String, param2:String, param3:int, param4:Function, param5:Object = null) : URLLoader
      {
         var c:ScratchCostume = null;
         var gotCostumeData:Function = null;
         var imageError:Function = null;
         var imageLoaded:Function = null;
         var id:String = param1;
         var costumeName:String = param2;
         var width:int = param3;
         var whenDone:Function = param4;
         var otherData:Object = param5;
         gotCostumeData = function(param1:ByteArray):void
         {
            var _loc2_:Loader = null;
            if(!param1)
            {
               app.log(LogLevel.WARNING,"Image not found on server: " + id);
               return;
            }
            if(ScratchCostume.isSVGData(param1))
            {
               if(Boolean(otherData) && Boolean(otherData.centerX))
               {
                  c = new ScratchCostume(costumeName,param1,otherData.centerX,otherData.centerY,otherData.bitmapResolution);
               }
               else
               {
                  c = new ScratchCostume(costumeName,param1);
               }
               c.baseLayerMD5 = id;
               whenDone(c);
            }
            else
            {
               _loc2_ = new Loader();
               _loc2_.contentLoaderInfo.addEventListener(Event.COMPLETE,imageLoaded);
               _loc2_.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imageError);
               _loc2_.loadBytes(param1);
            }
         };
         imageError = function(param1:IOErrorEvent):void
         {
            app.log(LogLevel.WARNING,"ProjectIO failed to load image",{"id":id});
         };
         imageLoaded = function(param1:Event):void
         {
            if(Boolean(otherData) && Boolean(otherData.centerX))
            {
               c = new ScratchCostume(costumeName,param1.target.content.bitmapData,otherData.centerX,otherData.centerY,otherData.bitmapResolution);
            }
            else
            {
               c = new ScratchCostume(costumeName,param1.target.content.bitmapData);
            }
            if(width)
            {
               c.bitmapResolution = c.baseLayerBitmap.width / width;
            }
            c.baseLayerMD5 = id;
            whenDone(c);
         };
         return this.app.server.getAsset(id,gotCostumeData);
      }
      
      public function fetchSound(param1:String, param2:String, param3:Function) : void
      {
         var gotSoundData:Function = null;
         var id:String = param1;
         var sndName:String = param2;
         var whenDone:Function = param3;
         gotSoundData = function(param1:ByteArray):void
         {
            var _loc2_:ScratchSound = null;
            if(!param1)
            {
               app.log(LogLevel.WARNING,"Sound not found on server",{"id":id});
               return;
            }
            try
            {
               _loc2_ = new ScratchSound(sndName,param1);
            }
            catch(e:*)
            {
            }
            if(Boolean(_loc2_) && _loc2_.sampleCount > 0)
            {
               whenDone(_loc2_);
            }
            else
            {
               MP3Loader.convertToScratchSound(sndName,param1,whenDone);
            }
         };
         this.app.server.getAsset(id,gotSoundData);
      }
      
      public function fetchSprite(param1:String, param2:Function) : void
      {
         var jsonReceived:Function = null;
         var assetsReceived:Function = null;
         var done:Function = null;
         var spr:ScratchSprite = null;
         var md5AndExt:String = param1;
         var whenDone:Function = param2;
         jsonReceived = function(param1:ByteArray):void
         {
            if(!param1)
            {
               return;
            }
            spr.readJSON(util.JSON.parse(param1.readUTFBytes(param1.length)));
            spr.instantiateFromJSON(app.stagePane);
            fetchSpriteAssets([spr],assetsReceived);
         };
         assetsReceived = function(param1:Object):void
         {
            installAssets([spr],param1);
            decodeAllImages([spr],done);
         };
         done = function():void
         {
            spr.showCostume(spr.currentCostumeIndex);
            spr.setDirection(spr.direction);
            whenDone(spr);
         };
         spr = new ScratchSprite();
         this.app.server.getAsset(md5AndExt,jsonReceived);
      }
      
      private function fetchSpriteAssets(param1:Array, param2:Function) : void
      {
         var assetReceived:Function = null;
         var assetDict:Object = null;
         var assetCount:int = 0;
         var assetsToFetch:Array = null;
         var md5:String = null;
         var objList:Array = param1;
         var whenDone:Function = param2;
         assetReceived = function(param1:String, param2:ByteArray):void
         {
            if(!param2)
            {
               app.log(LogLevel.WARNING,"missing sprite asset",{"md5":param1});
            }
            assetDict[param1] = param2;
            ++assetCount;
            if(assetCount == assetsToFetch.length)
            {
               whenDone(assetDict);
            }
         };
         assetDict = new Object();
         assetCount = 0;
         assetsToFetch = this.collectAssetsToFetch(objList);
         for each(md5 in assetsToFetch)
         {
            this.fetchAsset(md5,assetReceived);
         }
      }
      
      private function collectAssetsToFetch(param1:Array) : Array
      {
         var _loc3_:ScratchObj = null;
         var _loc4_:ScratchCostume = null;
         var _loc5_:ScratchSound = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            for each(_loc4_ in _loc3_.costumes)
            {
               if(_loc2_.indexOf(_loc4_.baseLayerMD5) < 0)
               {
                  _loc2_.push(_loc4_.baseLayerMD5);
               }
               if(_loc4_.textLayerMD5)
               {
                  if(_loc2_.indexOf(_loc4_.textLayerMD5) < 0)
                  {
                     _loc2_.push(_loc4_.textLayerMD5);
                  }
               }
            }
            for each(_loc5_ in _loc3_.sounds)
            {
               if(_loc2_.indexOf(_loc5_.md5) < 0)
               {
                  _loc2_.push(_loc5_.md5);
               }
            }
         }
         return _loc2_;
      }
      
      private function installAssets(param1:Array, param2:Object) : void
      {
         var _loc3_:ByteArray = null;
         var _loc4_:ScratchObj = null;
         var _loc5_:ScratchCostume = null;
         var _loc6_:ScratchSound = null;
         var _loc7_:String = null;
         for each(_loc4_ in param1)
         {
            for each(_loc5_ in _loc4_.costumes)
            {
               _loc3_ = param2[_loc5_.baseLayerMD5];
               if(_loc3_)
               {
                  _loc5_.baseLayerData = _loc3_;
               }
               else
               {
                  _loc7_ = _loc5_.baseLayerMD5;
                  _loc5_.baseLayerData = ScratchCostume.emptySVG();
                  _loc5_.baseLayerMD5 = _loc7_;
               }
               if(_loc5_.textLayerMD5)
               {
                  _loc5_.textLayerData = param2[_loc5_.textLayerMD5];
               }
            }
            for each(_loc6_ in _loc4_.sounds)
            {
               _loc3_ = param2[_loc6_.md5];
               if(_loc3_)
               {
                  _loc6_.soundData = _loc3_;
                  _loc6_.convertMP3IfNeeded();
               }
               else
               {
                  _loc6_.soundData = WAVFile.empty();
               }
            }
         }
      }
      
      public function fetchAsset(param1:String, param2:Function) : URLLoader
      {
         var md5:String = param1;
         var whenDone:Function = param2;
         return this.app.server.getAsset(md5,function(param1:*):void
         {
            whenDone(md5,param1);
         });
      }
      
      protected function recordImagesAndSounds(param1:Array, param2:Boolean, param3:ScratchStage = null) : void
      {
         var _loc5_:ScratchObj = null;
         var _loc6_:ScratchCostume = null;
         var _loc7_:ScratchSound = null;
         var _loc4_:Object = {};
         this.images = [];
         this.sounds = [];
         this.app.clearCachedBitmaps();
         if(!param2 && Boolean(param3))
         {
            param3.penLayerID = this.recordImage(param3.penLayerPNG,param3.penLayerMD5,_loc4_,param2);
         }
         for each(_loc5_ in param1)
         {
            for each(_loc6_ in _loc5_.costumes)
            {
               _loc6_.prepareToSave();
               _loc6_.baseLayerID = this.recordImage(_loc6_.baseLayerData,_loc6_.baseLayerMD5,_loc4_,param2);
               if(_loc6_.textLayerBitmap)
               {
                  _loc6_.textLayerID = this.recordImage(_loc6_.textLayerData,_loc6_.textLayerMD5,_loc4_,param2);
               }
            }
            for each(_loc7_ in _loc5_.sounds)
            {
               _loc7_.prepareToSave();
               _loc7_.soundID = this.recordSound(_loc7_,_loc7_.md5,_loc4_,param2);
            }
         }
      }
      
      public function convertSqueakSounds(param1:ScratchObj, param2:Function) : void
      {
         var convertASound:Function = null;
         var soundsConverted:Function = null;
         var soundsToConvert:Array = null;
         var obj:ScratchObj = null;
         var i:int = 0;
         var snd:ScratchSound = null;
         var scratchObj:ScratchObj = param1;
         var done:Function = param2;
         convertASound = function():void
         {
            var _loc1_:ScratchSound = null;
            if(i < soundsToConvert.length)
            {
               _loc1_ = soundsToConvert[i++] as ScratchSound;
               _loc1_.prepareToSave();
               app.lp.setProgress(i / soundsToConvert.length);
               app.lp.setInfo(_loc1_.soundName);
               setTimeout(convertASound,50);
            }
            else
            {
               app.removeLoadProgressBox();
               DialogBox.notify("","Sounds converted",app.stage,false,soundsConverted);
            }
         };
         soundsConverted = function(param1:*):void
         {
            done();
         };
         soundsToConvert = [];
         for each(obj in scratchObj.allObjects())
         {
            for each(snd in obj.sounds)
            {
               if("squeak" == snd.format)
               {
                  soundsToConvert.push(snd);
               }
            }
         }
         if(soundsToConvert.length > 0)
         {
            this.app.addLoadProgressBox("Converting sounds...");
            setTimeout(convertASound,50);
         }
         else
         {
            done();
         }
      }
      
      private function recordImage(param1:*, param2:String, param3:Object, param4:Boolean) : int
      {
         var _loc5_:int = this.recordedAssetID(param2,param3,param4);
         if(_loc5_ > -2)
         {
            return _loc5_;
         }
         this.images.push([param2,param1]);
         _loc5_ = this.images.length - 1;
         param3[param2] = _loc5_;
         return _loc5_;
      }
      
      protected function recordedAssetID(param1:String, param2:Object, param3:Boolean) : int
      {
         var _loc4_:* = param2[param1];
         return _loc4_ != undefined ? int(_loc4_) : -2;
      }
      
      private function recordSound(param1:ScratchSound, param2:String, param3:Object, param4:Boolean) : int
      {
         var _loc5_:int = this.recordedAssetID(param2,param3,param4);
         if(_loc5_ > -2)
         {
            return _loc5_;
         }
         this.sounds.push([param2,param1.soundData]);
         _loc5_ = this.sounds.length - 1;
         param3[param2] = _loc5_;
         return _loc5_;
      }
   }
}

