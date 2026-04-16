package ui.media
{
   import assets.Resources;
   import extensions.ScratchExtension;
   import flash.display.*;
   import flash.events.*;
   import flash.media.Sound;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import scratch.*;
   import sound.mp3.MP3Loader;
   import translation.Translator;
   import uiwidgets.*;
   import util.*;
   
   public class MediaLibrary extends Sprite
   {
      
      private static const backdropCategories:Array = ["All","Indoors","Outdoors","Other"];
      
      private static const costumeCategories:Array = ["All","Animals","Fantasy","Letters","People","Things","Transportation"];
      
      private static const extensionCategories:Array = ["All","Hardware"];
      
      private static const soundCategories:Array = ["All","Animal","Effects","Electronic","Human","Instruments","Music Loops","Musical Notes","Percussion","Vocals"];
      
      private static const backdropThemes:Array = ["Castle","City","Flying","Holiday","Music and Dance","Nature","Space","Sports","Underwater"];
      
      private static const costumeThemes:Array = ["Castle","City","Dance","Dress-Up","Flying","Holiday","Music","Space","Sports","Underwater","Walking"];
      
      private static const imageTypes:Array = ["All","Bitmap","Vector"];
      
      private static const spriteFeatures:Array = ["All","Scripts","Costumes > 1","Sounds"];
      
      private static var libraryCache:Object = {};
      
      private const titleFormat:TextFormat = new TextFormat(CSS.font,24,4473155);
      
      protected var app:Scratch;
      
      private var assetType:String;
      
      protected var whenDone:Function;
      
      protected var allItems:Array = [];
      
      private var title:TextField;
      
      private var outerFrame:Shape;
      
      private var innerFrame:Shape;
      
      private var resultsFrame:ScrollFrame;
      
      protected var resultsPane:ScrollFrameContents;
      
      protected var categoryFilter:MediaFilter;
      
      protected var themeFilter:MediaFilter;
      
      protected var imageTypeFilter:MediaFilter;
      
      protected var spriteFeaturesFilter:MediaFilter;
      
      private var closeButton:IconButton;
      
      private var okayButton:Button;
      
      private var cancelButton:Button;
      
      public function MediaLibrary(param1:Scratch, param2:String, param3:Function)
      {
         super();
         this.app = param1;
         this.assetType = param2;
         this.whenDone = param3;
         addChild(this.outerFrame = new Shape());
         addChild(this.innerFrame = new Shape());
         this.addTitle();
         this.addFilters();
         this.addResultsFrame();
         this.addButtons();
      }
      
      public static function strings() : Array
      {
         var _loc1_:Array = ["Backdrop Library","Costume Library","Sprite Library","Sound Library","Category","Theme","Type","Features","Uploading image...","Uploading sprite...","Uploading sound...","Importing sound...","Converting mp3..."];
         _loc1_ = _loc1_.concat(backdropCategories);
         _loc1_ = _loc1_.concat(costumeCategories);
         _loc1_ = _loc1_.concat(extensionCategories);
         _loc1_ = _loc1_.concat(soundCategories);
         _loc1_ = _loc1_.concat(backdropThemes);
         _loc1_ = _loc1_.concat(costumeThemes);
         _loc1_ = _loc1_.concat(imageTypes);
         return _loc1_.concat(spriteFeatures);
      }
      
      public function open() : void
      {
         this.app.closeTips();
         this.app.mediaLibrary = this;
         this.setWidthHeight(this.app.stage.stageWidth,this.app.stage.stageHeight);
         this.app.addChild(this);
         this.viewLibrary();
      }
      
      public function importFromDisk() : void
      {
         if(parent)
         {
            this.close();
         }
         if(this.assetType == "sound")
         {
            this.importSoundsFromDisk();
         }
         else
         {
            this.importImagesOrSpritesFromDisk();
         }
      }
      
      public function close(param1:* = null) : void
      {
         this.stopLoadingThumbnails();
         parent.removeChild(this);
         this.app.mediaLibrary = null;
         this.app.reopenTips();
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         var _loc3_:int = 30;
         var _loc4_:int = 15;
         this.title.x = _loc3_ + 20;
         this.title.y = _loc3_ + 15;
         this.closeButton.x = param1 - (_loc3_ + this.closeButton.width + 10);
         this.closeButton.y = _loc3_ + 10;
         this.cancelButton.x = param1 - (_loc3_ + this.cancelButton.width + _loc4_);
         this.cancelButton.y = param2 - (_loc3_ + this.cancelButton.height + 10);
         this.okayButton.x = this.cancelButton.x - (this.okayButton.width + 10);
         this.okayButton.y = this.cancelButton.y;
         this.drawBackground(param1,param2);
         this.outerFrame.x = _loc3_;
         this.outerFrame.y = _loc3_;
         this.drawOuterFrame(param1 - 2 * _loc3_,param2 - 2 * _loc3_);
         this.innerFrame.x = this.title.x + this.title.textWidth + 25;
         this.innerFrame.y = _loc3_ + 35;
         this.drawInnerFrame(param1 - (this.innerFrame.x + _loc3_ + _loc4_),param2 - (this.innerFrame.y + _loc3_ + this.cancelButton.height + 20));
         this.resultsFrame.x = this.innerFrame.x + 5;
         this.resultsFrame.y = this.innerFrame.y + 5;
         this.resultsFrame.setWidthHeight(this.innerFrame.width - 10,this.innerFrame.height - 10);
         var _loc5_:int = this.title.x + 3;
         var _loc6_:int = _loc3_ + 60;
         var _loc7_:int = 12;
         this.categoryFilter.x = _loc5_;
         this.categoryFilter.y = _loc6_;
         _loc6_ += this.categoryFilter.height + _loc7_;
         if(this.themeFilter.visible)
         {
            this.themeFilter.x = _loc5_;
            this.themeFilter.y = _loc6_;
            _loc6_ += this.themeFilter.height + _loc7_;
         }
         if(this.imageTypeFilter.visible)
         {
            this.imageTypeFilter.x = _loc5_;
            this.imageTypeFilter.y = _loc6_;
            _loc6_ += this.imageTypeFilter.height + _loc7_;
         }
         if(this.spriteFeaturesFilter.visible)
         {
            this.spriteFeaturesFilter.x = _loc5_;
            this.spriteFeaturesFilter.y = _loc6_;
         }
      }
      
      private function drawBackground(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = 0.6;
         var _loc5_:Graphics = this.graphics;
         _loc5_.clear();
         _loc5_.beginFill(_loc3_,_loc4_);
         _loc5_.drawRect(0,0,param1,param2);
         _loc5_.endFill();
      }
      
      private function drawOuterFrame(param1:int, param2:int) : void
      {
         var _loc3_:Graphics = this.outerFrame.graphics;
         _loc3_.clear();
         _loc3_.beginFill(CSS.tabColor);
         _loc3_.drawRoundRect(0,0,param1,param2,12,12);
         _loc3_.endFill();
      }
      
      private function drawInnerFrame(param1:int, param2:int) : void
      {
         var _loc3_:Graphics = this.innerFrame.graphics;
         _loc3_.clear();
         _loc3_.beginFill(CSS.white,1);
         _loc3_.drawRoundRect(0,0,param1,param2,8,8);
         _loc3_.endFill();
      }
      
      private function addTitle() : void
      {
         var _loc1_:String = this.assetType;
         if("backdrop" == _loc1_)
         {
            _loc1_ = "Backdrop Library";
         }
         if("costume" == _loc1_)
         {
            _loc1_ = "Costume Library";
         }
         if("extension" == _loc1_)
         {
            _loc1_ = "Extension Library";
         }
         if("sprite" == _loc1_)
         {
            _loc1_ = "Sprite Library";
         }
         if("sound" == _loc1_)
         {
            _loc1_ = "Sound Library";
         }
         addChild(this.title = Resources.makeLabel(Translator.map(_loc1_),this.titleFormat));
      }
      
      private function addFilters() : void
      {
         var _loc1_:Array = [];
         if("backdrop" == this.assetType)
         {
            _loc1_ = backdropCategories;
         }
         if("costume" == this.assetType)
         {
            _loc1_ = costumeCategories;
         }
         if("extension" == this.assetType)
         {
            _loc1_ = extensionCategories;
         }
         if("sprite" == this.assetType)
         {
            _loc1_ = costumeCategories;
         }
         if("sound" == this.assetType)
         {
            _loc1_ = soundCategories;
         }
         this.categoryFilter = new MediaFilter("Category",_loc1_,this.filterChanged);
         addChild(this.categoryFilter);
         this.themeFilter = new MediaFilter("Theme","backdrop" == this.assetType ? backdropThemes : costumeThemes,this.filterChanged);
         this.themeFilter.currentSelection = "";
         addChild(this.themeFilter);
         this.imageTypeFilter = new MediaFilter("Type",imageTypes,this.filterChanged);
         addChild(this.imageTypeFilter);
         this.spriteFeaturesFilter = new MediaFilter("Features",spriteFeatures,this.filterChanged);
         addChild(this.spriteFeaturesFilter);
         this.themeFilter.visible = ["sprite","costume","backdrop"].indexOf(this.assetType) > -1;
         this.imageTypeFilter.visible = ["sprite","costume"].indexOf(this.assetType) > -1;
         this.spriteFeaturesFilter.visible = "sprite" == this.assetType;
         this.spriteFeaturesFilter.visible = false;
      }
      
      private function filterChanged(param1:MediaFilter) : void
      {
         if(param1 == this.categoryFilter)
         {
            this.themeFilter.currentSelection = "";
         }
         if(param1 == this.themeFilter)
         {
            this.categoryFilter.currentSelection = "";
         }
         this.showFilteredItems();
         this.resultsPane.y = 0;
         this.resultsFrame.updateScrollbars();
      }
      
      private function addResultsFrame() : void
      {
         this.resultsPane = new ScrollFrameContents();
         this.resultsPane.color = CSS.white;
         this.resultsPane.hExtra = 0;
         this.resultsPane.vExtra = 5;
         this.resultsFrame = new ScrollFrame();
         this.resultsFrame.setContents(this.resultsPane);
         addChild(this.resultsFrame);
      }
      
      private function addButtons() : void
      {
         addChild(this.closeButton = new IconButton(this.close,"close"));
         addChild(this.okayButton = new Button(Translator.map("OK"),this.addSelected));
         addChild(this.cancelButton = new Button(Translator.map("Cancel"),this.close));
      }
      
      private function viewLibrary() : void
      {
         var gotLibraryData:Function = null;
         gotLibraryData = function(param1:ByteArray):void
         {
            if(!param1)
            {
               return;
            }
            var _loc2_:String = param1.readUTFBytes(param1.length);
            libraryCache[assetType] = util.JSON.parse(stripComments(_loc2_)) as Array;
            collectEntries();
         };
         var collectEntries:Function = function():void
         {
            var _loc1_:Object = null;
            var _loc2_:Array = null;
            allItems = [];
            for each(_loc1_ in libraryCache[assetType])
            {
               if(_loc1_.type == assetType)
               {
                  if(_loc1_.tags is Array)
                  {
                     _loc1_.category = _loc1_.tags[0];
                  }
                  _loc2_ = _loc1_.info as Array;
                  if(_loc2_)
                  {
                     if(_loc1_.type == "backdrop")
                     {
                        _loc1_.width = _loc2_[0];
                        _loc1_.height = _loc2_[1];
                     }
                     if(_loc1_.type == "sound")
                     {
                        _loc1_.seconds = _loc2_[0];
                     }
                     if(_loc1_.type == "sprite")
                     {
                        _loc1_.scriptCount = _loc2_[0];
                        _loc1_.costumeCount = _loc2_[1];
                        _loc1_.soundCount = _loc2_[2];
                     }
                  }
                  allItems.push(new MediaLibraryItem(_loc1_));
               }
            }
            showFilteredItems();
            startLoadingThumbnails();
         };
         if("extension" == this.assetType)
         {
            this.addScratchExtensions();
            return;
         }
         if(!libraryCache[this.assetType])
         {
            this.app.server.getMediaLibrary(this.assetType,gotLibraryData);
         }
         else
         {
            collectEntries();
         }
      }
      
      protected function addScratchExtensions() : void
      {
         var _loc2_:ScratchExtension = null;
         var _loc1_:Array = [ScratchExtension.PicoBoard(),ScratchExtension.WeDo(),ScratchExtension.WeDo2()];
         this.allItems = [];
         for each(_loc2_ in _loc1_)
         {
            this.allItems.push(new MediaLibraryItem({
               "extension":_loc2_,
               "name":_loc2_.displayName,
               "md5":_loc2_.thumbnailMD5,
               "tags":_loc2_.tags
            }));
         }
         this.showFilteredItems();
         this.startLoadingThumbnails();
      }
      
      private function stripComments(param1:String) : String
      {
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc2_:String = "";
         for each(_loc3_ in param1.split("\n"))
         {
            _loc4_ = false;
            if(_loc3_.length > 0 && _loc3_.charAt(0) == "<")
            {
               _loc4_ = true;
            }
            if(_loc3_.length > 1 && _loc3_.charAt(0) == "/" && _loc3_.charAt(1) == "/")
            {
               _loc4_ = true;
            }
            if(!_loc4_)
            {
               _loc2_ += _loc3_ + "\n";
            }
         }
         return _loc2_;
      }
      
      protected function showFilteredItems() : void
      {
         var _loc4_:MediaLibraryItem = null;
         var _loc1_:String = "";
         if(this.categoryFilter.currentSelection != "")
         {
            _loc1_ = this.categoryFilter.currentSelection;
         }
         if(this.themeFilter.currentSelection != "")
         {
            _loc1_ = this.themeFilter.currentSelection;
         }
         _loc1_ = _loc1_.replace(/ /g,"-");
         _loc1_ = _loc1_.toLowerCase();
         var _loc2_:Boolean = "all" == _loc1_;
         var _loc3_:Array = [];
         for each(_loc4_ in this.allItems)
         {
            if((_loc2_ || _loc4_.dbObj.tags.indexOf(_loc1_) > -1) && this.hasSelectedFeatures(_loc4_.dbObj))
            {
               _loc3_.push(_loc4_);
            }
         }
         while(this.resultsPane.numChildren > 0)
         {
            this.resultsPane.removeChildAt(0);
         }
         this.appendItems(_loc3_);
      }
      
      private function hasSelectedFeatures(param1:Object) : Boolean
      {
         var _loc2_:String = this.imageTypeFilter.currentSelection;
         if(this.imageTypeFilter.visible && _loc2_ != "All")
         {
            if(_loc2_ == "Vector")
            {
               if(param1.tags.indexOf("vector") == -1)
               {
                  return false;
               }
            }
            else if(param1.tags.indexOf("vector") != -1)
            {
               return false;
            }
         }
         var _loc3_:String = this.spriteFeaturesFilter.currentSelection;
         if(this.spriteFeaturesFilter.visible && _loc3_ != "All")
         {
            if("Scripts" == _loc3_ && param1.scriptCount == 0)
            {
               return false;
            }
            if("Costumes > 1" == _loc3_ && param1.costumeCount <= 1)
            {
               return false;
            }
            if("Sounds" == _loc3_ && param1.soundCount == 0)
            {
               return false;
            }
         }
         return true;
      }
      
      protected function appendItems(param1:Array) : void
      {
         var _loc9_:MediaLibraryItem = null;
         if(param1.length == 0)
         {
            return;
         }
         var _loc2_:int = (param1[0] as MediaLibraryItem).frameWidth + 6;
         var _loc3_:int = this.resultsFrame.width - 15;
         var _loc4_:int = _loc3_ / _loc2_;
         var _loc5_:int = (_loc3_ - _loc4_ * _loc2_) / _loc4_;
         var _loc6_:int = 0;
         var _loc7_:int = 2;
         var _loc8_:int = 2;
         for each(_loc9_ in param1)
         {
            _loc9_.x = _loc7_;
            _loc9_.y = _loc8_;
            this.resultsPane.addChild(_loc9_);
            _loc7_ += _loc9_.frameWidth + 6 + _loc5_;
            if(++_loc6_ == _loc4_)
            {
               _loc6_ = 0;
               _loc7_ = 2;
               _loc8_ += _loc9_.frameHeight + 5;
            }
         }
         if(_loc7_ > 5)
         {
            _loc8_ += _loc9_.frameHeight + 2;
         }
         this.resultsPane.updateSize();
      }
      
      public function addSelected() : void
      {
         var _loc3_:MediaLibraryItem = null;
         var _loc4_:String = null;
         var _loc5_:Object = null;
         var _loc1_:ProjectIO = new ProjectIO(this.app);
         this.close();
         var _loc2_:int = 0;
         while(_loc2_ < this.resultsPane.numChildren)
         {
            _loc3_ = this.resultsPane.getChildAt(_loc2_) as MediaLibraryItem;
            if(Boolean(_loc3_) && _loc3_.isHighlighted())
            {
               _loc4_ = _loc3_.dbObj.md5;
               _loc5_ = null;
               if(this.assetType == "extension")
               {
                  this.whenDone(_loc3_.dbObj.extension);
               }
               else if(_loc4_.slice(-5) == ".json")
               {
                  _loc1_.fetchSprite(_loc4_,this.whenDone);
               }
               else if(this.assetType == "sound")
               {
                  _loc1_.fetchSound(_loc4_,_loc3_.dbObj.name,this.whenDone);
               }
               else if(this.assetType == "costume")
               {
                  _loc5_ = {
                     "centerX":_loc3_.dbObj.info[0],
                     "centerY":_loc3_.dbObj.info[1],
                     "bitmapResolution":1
                  };
                  if(_loc3_.dbObj.info.length == 3)
                  {
                     _loc5_.bitmapResolution = _loc3_.dbObj.info[2];
                  }
                  _loc1_.fetchImage(_loc4_,_loc3_.dbObj.name,0,this.whenDone,_loc5_);
               }
               else
               {
                  if(_loc3_.dbObj.info.length == 3)
                  {
                     _loc5_ = {
                        "centerX":ScratchCostume.kCalculateCenter,
                        "centerY":ScratchCostume.kCalculateCenter,
                        "bitmapResolution":_loc3_.dbObj.info[2]
                     };
                  }
                  else if(_loc3_.dbObj.info.length == 2 && _loc3_.dbObj.info[0] == 960 && _loc3_.dbObj.info[1] == 720)
                  {
                     _loc5_ = {
                        "centerX":ScratchCostume.kCalculateCenter,
                        "centerY":ScratchCostume.kCalculateCenter,
                        "bitmapResolution":2
                     };
                  }
                  _loc1_.fetchImage(_loc4_,_loc3_.dbObj.name,0,this.whenDone,_loc5_);
               }
            }
            _loc2_++;
         }
      }
      
      protected function startLoadingThumbnails() : void
      {
         var loadSomeThumbnails:Function = null;
         var loadDone:Function = null;
         var next:int = 0;
         var inProgress:int = 0;
         loadSomeThumbnails = function():void
         {
            var _loc1_:* = int(10 - inProgress);
            while(next < allItems.length && _loc1_-- > 0)
            {
               ++inProgress;
               allItems[next++].loadThumbnail(loadDone);
            }
            if(next < allItems.length || Boolean(inProgress))
            {
               setTimeout(loadSomeThumbnails,40);
            }
         };
         loadDone = function():void
         {
            --inProgress;
         };
         next = 0;
         inProgress = 0;
         loadSomeThumbnails();
      }
      
      private function stopLoadingThumbnails() : void
      {
         var _loc2_:MediaLibraryItem = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.resultsPane.numChildren)
         {
            _loc2_ = this.resultsPane.getChildAt(_loc1_) as MediaLibraryItem;
            if(_loc2_)
            {
               _loc2_.stopLoading();
            }
            _loc1_++;
         }
      }
      
      private function importImagesOrSpritesFromDisk() : void
      {
         var fileSelected:Function = null;
         var fileLoaded:Function = null;
         var costumeOrSprite:* = undefined;
         var files:FileReferenceList = null;
         fileSelected = function(param1:Event):void
         {
            var _loc3_:FileReference = null;
            var _loc2_:int = 0;
            while(_loc2_ < files.fileList.length)
            {
               _loc3_ = FileReference(files.fileList[_loc2_]);
               _loc3_.addEventListener(Event.COMPLETE,fileLoaded);
               _loc3_.load();
               _loc2_++;
            }
         };
         fileLoaded = function(param1:Event):void
         {
            var _loc2_:FileReference = param1.target as FileReference;
            if(_loc2_)
            {
               convertAndUploadImageOrSprite(_loc2_.name,_loc2_.data);
            }
         };
         files = new FileReferenceList();
         files.addEventListener(Event.SELECT,fileSelected);
         try
         {
            files.browse();
         }
         catch(e:*)
         {
         }
      }
      
      protected function uploadCostume(param1:ScratchCostume, param2:Function) : void
      {
         param2();
      }
      
      protected function uploadSprite(param1:ScratchSprite, param2:Function) : void
      {
         param2();
      }
      
      private function convertAndUploadImageOrSprite(param1:String, param2:ByteArray) : void
      {
         var imageDecoded:Function = null;
         var spriteDecoded:Function = null;
         var imagesDecoded:Function = null;
         var uploadComplete:Function = null;
         var spriteError:Function = null;
         var costumeOrSprite:* = undefined;
         var loader:Loader = null;
         var info:Object = null;
         var objTable:Array = null;
         var reader:ObjReader = null;
         var newProject:ScratchStage = null;
         var sprite:ScratchSprite = null;
         var fName:String = param1;
         var data:ByteArray = param2;
         imageDecoded = function(param1:Event):void
         {
            var _loc2_:BitmapData = ScratchCostume.scaleForScratch(param1.target.content.bitmapData);
            costumeOrSprite = new ScratchCostume(fName,_loc2_);
            uploadCostume(costumeOrSprite,uploadComplete);
         };
         spriteDecoded = function(param1:ScratchSprite):void
         {
            costumeOrSprite = param1;
            uploadSprite(param1,uploadComplete);
         };
         imagesDecoded = function():void
         {
            sprite.updateScriptsAfterTranslation();
            spriteDecoded(sprite);
         };
         uploadComplete = function():void
         {
            app.removeLoadProgressBox();
            whenDone(costumeOrSprite);
         };
         var decodeError:Function = function():void
         {
            DialogBox.notify("Error decoding image","Sorry, Scratch was unable to load the image " + fName + ".",Scratch.app.stage);
         };
         spriteError = function():void
         {
            DialogBox.notify("Error decoding sprite","Sorry, Scratch was unable to load the sprite " + fName + ".",Scratch.app.stage);
         };
         var fExt:String = "";
         var i:int = fName.lastIndexOf(".");
         if(i > 0)
         {
            fExt = fName.slice(i).toLowerCase();
            fName = fName.slice(0,i);
         }
         if(fExt == ".png" || fExt == ".jpg" || fExt == ".jpeg")
         {
            loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,imageDecoded);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(param1:Event):void
            {
               decodeError();
            });
            try
            {
               loader.loadBytes(data);
            }
            catch(e:*)
            {
               decodeError();
            }
         }
         else if(fExt == ".gif")
         {
            try
            {
               this.importGIF(fName,data);
            }
            catch(e:*)
            {
               decodeError();
            }
         }
         else if(ScratchCostume.isSVGData(data))
         {
            data = this.svgAddGroupIfNeeded(data);
            costumeOrSprite = new ScratchCostume(fName,null);
            costumeOrSprite.setSVGData(data,true);
            this.uploadCostume(costumeOrSprite as ScratchCostume,uploadComplete);
         }
         else
         {
            data.position = 0;
            if(data.bytesAvailable > 4 && data.readUTFBytes(4) == "ObjS")
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
                  spriteError();
                  return;
               }
               newProject = new OldProjectReader().extractProject(objTable);
               sprite = newProject.numChildren > 3 ? newProject.getChildAt(3) as ScratchSprite : null;
               if(!sprite)
               {
                  spriteError();
                  return;
               }
               new ProjectIO(this.app).decodeAllImages(newProject.allObjects(),imagesDecoded,spriteError);
            }
            else
            {
               data.position = 0;
               new ProjectIO(this.app).decodeSpriteFromZipFile(data,spriteDecoded,spriteError);
            }
         }
      }
      
      private function importGIF(param1:String, param2:ByteArray) : void
      {
         var _loc3_:GIFDecoder = new GIFDecoder();
         _loc3_.read(param2);
         if(_loc3_.frames.length == 0)
         {
            return;
         }
         var _loc4_:Array = [];
         var _loc5_:int = 0;
         while(_loc5_ < _loc3_.frames.length)
         {
            _loc4_.push(new ScratchCostume(param1 + "-" + _loc5_,_loc3_.frames[_loc5_]));
            _loc5_++;
         }
         this.gifImported(_loc4_);
      }
      
      protected function gifImported(param1:Array) : void
      {
         this.whenDone(param1);
      }
      
      private function svgAddGroupIfNeeded(param1:ByteArray) : ByteArray
      {
         var _loc4_:XML = null;
         var _loc5_:* = undefined;
         var _loc6_:XML = null;
         var _loc7_:ByteArray = null;
         var _loc2_:XML = XML(param1);
         if(!this.svgNeedsGroup(_loc2_))
         {
            return param1;
         }
         var _loc3_:XML = <g></g>;
         for each(_loc4_ in _loc2_.elements())
         {
            if(_loc4_.localName() != "defs")
            {
               delete _loc2_.children()[_loc4_.childIndex()];
               _loc3_.appendChild(_loc4_);
            }
         }
         _loc2_.appendChild(_loc3_);
         for each(_loc5_ in _loc2_.attributes())
         {
            if(_loc5_.localName() == "space")
            {
               delete _loc2_[_loc5_.name()];
            }
         }
         _loc2_["xml:space"] = "preserve";
         _loc6_ = _loc2_;
         _loc7_ = new ByteArray();
         _loc7_.writeUTFBytes(_loc6_.toXMLString());
         return _loc7_;
      }
      
      private function svgNeedsGroup(param1:XML) : Boolean
      {
         var _loc2_:int = 0;
         var _loc3_:XML = null;
         for each(_loc3_ in param1.elements())
         {
            if(_loc3_.localName() != "defs")
            {
               _loc2_++;
            }
         }
         return _loc2_ > 1;
      }
      
      private function importSoundsFromDisk() : void
      {
         var fileSelected:Function = null;
         var fileLoaded:Function = null;
         var files:FileReferenceList = null;
         fileSelected = function(param1:Event):void
         {
            var _loc3_:FileReference = null;
            var _loc2_:int = 0;
            while(_loc2_ < files.fileList.length)
            {
               _loc3_ = FileReference(files.fileList[_loc2_]);
               _loc3_.addEventListener(Event.COMPLETE,fileLoaded);
               _loc3_.load();
               _loc2_++;
            }
         };
         fileLoaded = function(param1:Event):void
         {
            convertAndUploadSound(FileReference(param1.target).name,FileReference(param1.target).data);
         };
         files = new FileReferenceList();
         files.addEventListener(Event.SELECT,fileSelected);
         try
         {
            files.browse();
         }
         catch(e:*)
         {
         }
      }
      
      protected function startSoundUpload(param1:ScratchSound, param2:String, param3:Function) : void
      {
         if(!param1)
         {
            DialogBox.notify("Sorry!","The sound file " + param2 + " is not recognized by Scratch.  Please use MP3 or WAV sound files.",stage);
            return;
         }
         param3();
      }
      
      private function convertAndUploadSound(param1:String, param2:ByteArray) : void
      {
         var uploadComplete:Function = null;
         var snd:ScratchSound = null;
         var origName:String = null;
         var sound:Sound = null;
         var uploadConvertedSound:Function = null;
         var sndName:String = param1;
         var data:ByteArray = param2;
         uploadComplete = function():void
         {
            app.removeLoadProgressBox();
            whenDone(snd);
         };
         origName = sndName;
         var i:int = sndName.lastIndexOf(".");
         if(i > 0)
         {
            sndName = sndName.slice(0,i);
         }
         this.app.addLoadProgressBox("Importing sound...");
         try
         {
            snd = new ScratchSound(sndName,data);
         }
         catch(e:Error)
         {
         }
         if(Boolean(snd) && snd.sampleCount > 0)
         {
            this.startSoundUpload(snd,origName,uploadComplete);
         }
         else
         {
            uploadConvertedSound = function(param1:ScratchSound):void
            {
               snd = param1;
               if(Boolean(snd) && snd.sampleCount > 0)
               {
                  startSoundUpload(param1,origName,uploadComplete);
               }
               else
               {
                  app.removeLoadProgressBox();
                  DialogBox.notify("Error decoding sound","Sorry, Scratch was unable to load the sound " + sndName + ".",Scratch.app.stage);
               }
            };
            if(this.app.lp)
            {
               this.app.lp.setTitle("Converting mp3 file...");
            }
            sound = new Sound();
            try
            {
               data.position = 0;
               sound.loadCompressedDataFromByteArray(data,data.length);
               MP3Loader.extractSamples(origName,sound,sound.length * 44.1,uploadConvertedSound);
            }
            catch(e:Error)
            {
               uploadComplete();
            }
            if(!sound)
            {
               setTimeout(function():void
               {
                  MP3Loader.convertToScratchSound(sndName,data,uploadConvertedSound);
               },1);
            }
         }
      }
   }
}

