package ui.parts
{
   import flash.display.*;
   import flash.text.*;
   import flash.utils.*;
   import scratch.*;
   import translation.Translator;
   import ui.SpriteThumbnail;
   import ui.media.*;
   import uiwidgets.*;
   import util.CachedTimer;
   
   public class LibraryPart extends UIPart
   {
      
      private const smallTextFormat:TextFormat = new TextFormat(CSS.font,10,CSS.textColor);
      
      private const bgColor:int = 15132904;
      
      private const stageAreaWidth:int = 77;
      
      private const updateInterval:int = 200;
      
      private var lastUpdate:uint;
      
      private var shape:Shape;
      
      private var stageThumbnail:SpriteThumbnail;
      
      private var spritesFrame:ScrollFrame;
      
      protected var spritesPane:ScrollFrameContents;
      
      private var spriteDetails:SpriteInfoPart;
      
      private var spritesTitle:TextField;
      
      private var newSpriteLabel:TextField;
      
      private var paintButton:IconButton;
      
      private var libraryButton:IconButton;
      
      private var importButton:IconButton;
      
      private var photoButton:IconButton;
      
      private var newBackdropLabel:TextField;
      
      private var backdropLibraryButton:IconButton;
      
      private var backdropPaintButton:IconButton;
      
      private var backdropImportButton:IconButton;
      
      private var backdropCameraButton:IconButton;
      
      private var videoLabel:TextField;
      
      private var videoButton:IconButton;
      
      public function LibraryPart(param1:Scratch)
      {
         super();
         this.app = param1;
         this.shape = new Shape();
         addChild(this.shape);
         this.spritesTitle = makeLabel(Translator.map("Sprites"),CSS.titleFormat,param1.isMicroworld ? 10 : int(this.stageAreaWidth + 10),5);
         addChild(this.spritesTitle);
         addChild(this.newSpriteLabel = makeLabel(Translator.map("New sprite:"),CSS.titleFormat,10,5));
         addChild(this.libraryButton = this.makeButton(this.spriteFromLibrary,"library"));
         addChild(this.paintButton = this.makeButton(this.paintSprite,"paintbrush"));
         addChild(this.importButton = this.makeButton(this.spriteFromComputer,"import"));
         addChild(this.photoButton = this.makeButton(this.spriteFromCamera,"camera"));
         if(!param1.isMicroworld)
         {
            this.addStageArea();
            this.addNewBackdropButtons();
            this.addVideoControl();
         }
         this.addSpritesArea();
         this.spriteDetails = new SpriteInfoPart(param1);
         addChild(this.spriteDetails);
         this.spriteDetails.visible = false;
         this.updateTranslation();
      }
      
      public static function strings() : Array
      {
         return ["Sprites","New sprite:","New backdrop:","Video on:","backdrop1","costume1","photo1","pop","Choose sprite from library","Paint new sprite","Upload sprite from file","New sprite from camera","Choose backdrop from library","Paint new backdrop","Upload backdrop from file","New backdrop from camera"];
      }
      
      public function updateTranslation() : void
      {
         this.spritesTitle.text = Translator.map("Sprites");
         this.newSpriteLabel.text = Translator.map("New sprite:");
         if(this.newBackdropLabel)
         {
            this.newBackdropLabel.text = Translator.map("New backdrop:");
         }
         if(this.videoLabel)
         {
            this.videoLabel.text = Translator.map("Video on:");
         }
         if(this.stageThumbnail)
         {
            this.stageThumbnail.updateThumbnail(true);
         }
         this.spriteDetails.updateTranslation();
         SimpleTooltips.add(this.libraryButton,{
            "text":"Choose sprite from library",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.paintButton,{
            "text":"Paint new sprite",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.importButton,{
            "text":"Upload sprite from file",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.photoButton,{
            "text":"New sprite from camera",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.backdropLibraryButton,{
            "text":"Choose backdrop from library",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.backdropPaintButton,{
            "text":"Paint new backdrop",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.backdropImportButton,{
            "text":"Upload backdrop from file",
            "direction":"bottom"
         });
         SimpleTooltips.add(this.backdropCameraButton,{
            "text":"New backdrop from camera",
            "direction":"bottom"
         });
         this.fixLayout();
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         this.w = param1;
         this.h = param2;
         var _loc3_:Graphics = this.shape.graphics;
         _loc3_.clear();
         drawTopBar(_loc3_,CSS.titleBarColors,getTopBarPath(param1,CSS.titleBarH),param1,CSS.titleBarH);
         _loc3_.lineStyle(1,CSS.borderColor,1,true);
         _loc3_.drawRect(0,CSS.titleBarH,param1,param2 - CSS.titleBarH);
         _loc3_.lineStyle(1,CSS.borderColor);
         if(!app.isMicroworld)
         {
            _loc3_.moveTo(this.stageAreaWidth,0);
            _loc3_.lineTo(this.stageAreaWidth,param2);
            _loc3_.lineStyle();
            _loc3_.beginFill(CSS.tabColor);
            _loc3_.drawRect(1,CSS.titleBarH + 1,this.stageAreaWidth - 1,param2 - CSS.titleBarH - 1);
            _loc3_.endFill();
         }
         this.fixLayout();
         if(app.viewedObj())
         {
            this.refresh();
         }
      }
      
      private function fixLayout() : void
      {
         var _loc1_:int = 4;
         if(!app.isMicroworld)
         {
            this.libraryButton.x = 380;
            if(app.stageIsContracted)
            {
               this.libraryButton.x = 138;
            }
            this.libraryButton.y = _loc1_ + 0;
            this.paintButton.x = this.libraryButton.x + this.libraryButton.width + 3;
            this.paintButton.y = _loc1_ + 1;
            this.importButton.x = this.paintButton.x + this.paintButton.width + 4;
            this.importButton.y = _loc1_ + 0;
            this.photoButton.x = this.importButton.x + this.importButton.width + 8;
            this.photoButton.y = _loc1_ + 2;
            this.stageThumbnail.x = 2;
            this.stageThumbnail.y = CSS.titleBarH + 2;
            this.spritesFrame.x = this.stageAreaWidth + 1;
            this.newSpriteLabel.x = this.libraryButton.x - this.newSpriteLabel.width - 6;
            this.newSpriteLabel.y = 6;
         }
         else
         {
            this.libraryButton.visible = false;
            this.paintButton.visible = false;
            this.importButton.visible = false;
            this.photoButton.visible = false;
            this.newSpriteLabel.visible = false;
            this.spritesFrame.x = 1;
         }
         this.spritesFrame.y = CSS.titleBarH + 1;
         this.spritesFrame.allowHorizontalScrollbar = false;
         this.spritesFrame.setWidthHeight(w - this.spritesFrame.x,h - this.spritesFrame.y);
         this.spriteDetails.x = this.spritesFrame.x;
         this.spriteDetails.y = this.spritesFrame.y;
         this.spriteDetails.setWidthHeight(w - this.spritesFrame.x,h - this.spritesFrame.y);
      }
      
      public function highlight(param1:Array) : void
      {
         var _loc2_:SpriteThumbnail = null;
         for each(_loc2_ in this.allThumbnails())
         {
            _loc2_.showHighlight(param1.indexOf(_loc2_.targetObj) >= 0);
         }
      }
      
      public function refresh() : void
      {
         var sortedSprites:Array;
         var inset:int;
         var nextX:int;
         var nextY:int;
         var index:int;
         var rightEdge:int = 0;
         var spr:ScratchSprite = null;
         var tn:SpriteThumbnail = null;
         this.newSpriteLabel.visible = !app.stageIsContracted && !app.isMicroworld;
         this.spritesTitle.visible = !app.stageIsContracted;
         if(app.viewedObj().isStage)
         {
            this.showSpriteDetails(false);
         }
         if(this.spriteDetails.visible)
         {
            this.spriteDetails.refresh();
         }
         if(this.stageThumbnail)
         {
            this.stageThumbnail.setTarget(app.stageObj());
         }
         this.spritesPane.clear(false);
         sortedSprites = app.stageObj().sprites();
         sortedSprites.sort(function(param1:ScratchSprite, param2:ScratchSprite):int
         {
            return param1.indexInLibrary - param2.indexInLibrary;
         });
         inset = 2;
         rightEdge = w - this.spritesFrame.x;
         nextX = inset;
         nextY = inset;
         index = 1;
         for each(spr in sortedSprites)
         {
            spr.indexInLibrary = index++;
            tn = new SpriteThumbnail(spr,app);
            tn.x = nextX;
            tn.y = nextY;
            this.spritesPane.addChild(tn);
            nextX += tn.width;
            if(nextX + tn.width > rightEdge)
            {
               nextX = inset;
               nextY += tn.height;
            }
         }
         this.spritesPane.updateSize();
         this.scrollToSelectedSprite();
         this.step();
      }
      
      private function scrollToSelectedSprite() : void
      {
         var _loc2_:SpriteThumbnail = null;
         var _loc4_:SpriteThumbnail = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:ScratchObj = app.viewedObj();
         var _loc3_:int = 0;
         while(_loc3_ < this.spritesPane.numChildren)
         {
            _loc4_ = this.spritesPane.getChildAt(_loc3_) as SpriteThumbnail;
            if(Boolean(_loc4_) && _loc4_.targetObj == _loc1_)
            {
               _loc2_ = _loc4_;
            }
            _loc3_++;
         }
         if(_loc2_)
         {
            _loc5_ = _loc2_.y + this.spritesPane.y - 1;
            _loc6_ = _loc5_ + _loc2_.height;
            this.spritesPane.y -= Math.max(0,_loc6_ - this.spritesFrame.visibleH());
            this.spritesPane.y -= Math.min(0,_loc5_);
            this.spritesFrame.updateScrollbars();
         }
      }
      
      public function showSpriteDetails(param1:Boolean) : void
      {
         this.spriteDetails.visible = param1;
         if(this.spriteDetails.visible)
         {
            this.spriteDetails.refresh();
         }
      }
      
      public function step() : void
      {
         var _loc3_:SpriteThumbnail = null;
         var _loc1_:ScratchObj = app.viewedObj();
         var _loc2_:Boolean = CachedTimer.getCachedTimer() - this.lastUpdate > this.updateInterval;
         for each(_loc3_ in this.allThumbnails())
         {
            if(_loc2_)
            {
               _loc3_.updateThumbnail();
            }
            _loc3_.select(_loc3_.targetObj == _loc1_);
         }
         if(_loc2_)
         {
            this.lastUpdate = CachedTimer.getCachedTimer();
         }
         if(this.spriteDetails.visible)
         {
            this.spriteDetails.step();
         }
         if(Boolean(this.videoButton) && this.videoButton.visible)
         {
            this.updateVideoButton();
         }
      }
      
      private function addStageArea() : void
      {
         this.stageThumbnail = new SpriteThumbnail(app.stagePane,app);
         addChild(this.stageThumbnail);
      }
      
      private function addNewBackdropButtons() : void
      {
         var _loc1_:int = 0;
         addChild(this.newBackdropLabel = makeLabel(Translator.map("New backdrop:"),this.smallTextFormat,3,126));
         addChild(this.backdropLibraryButton = this.makeButton(this.backdropFromLibrary,"landscapeSmall"));
         addChild(this.backdropPaintButton = this.makeButton(this.paintBackdrop,"paintbrushSmall"));
         addChild(this.backdropImportButton = this.makeButton(this.backdropFromComputer,"importSmall"));
         addChild(this.backdropCameraButton = this.makeButton(this.backdropFromCamera,"cameraSmall"));
         _loc1_ = 145;
         this.backdropLibraryButton.x = 4;
         this.backdropLibraryButton.y = _loc1_ + 3;
         this.backdropPaintButton.x = this.backdropLibraryButton.right() + 4;
         this.backdropPaintButton.y = _loc1_ + 1;
         this.backdropImportButton.x = this.backdropPaintButton.right() + 1;
         this.backdropImportButton.y = _loc1_ + 0;
         this.backdropCameraButton.x = this.backdropImportButton.right() + 5;
         this.backdropCameraButton.y = _loc1_ + 3;
      }
      
      private function addSpritesArea() : void
      {
         this.spritesPane = new ScrollFrameContents();
         this.spritesPane.color = this.bgColor;
         this.spritesPane.hExtra = this.spritesPane.vExtra = 0;
         this.spritesFrame = new ScrollFrame();
         this.spritesFrame.setContents(this.spritesPane);
         addChild(this.spritesFrame);
      }
      
      private function makeButton(param1:Function, param2:String) : IconButton
      {
         var _loc3_:IconButton = new IconButton(param1,param2);
         _loc3_.isMomentary = true;
         return _loc3_;
      }
      
      public function showVideoButton() : void
      {
         if(this.videoButton.visible)
         {
            return;
         }
         this.videoButton.visible = true;
         this.videoLabel.visible = true;
         if(!app.stagePane.isVideoOn())
         {
            app.stagePane.setVideoState("on");
         }
      }
      
      private function updateVideoButton() : void
      {
         var _loc1_:Boolean = app.stagePane.isVideoOn();
         if(this.videoButton.isOn() != _loc1_)
         {
            this.videoButton.setOn(_loc1_);
         }
      }
      
      private function addVideoControl() : void
      {
         var turnVideoOn:Function = null;
         turnVideoOn = function(param1:IconButton):void
         {
            app.stagePane.setVideoState(param1.isOn() ? "on" : "off");
            app.setSaveNeeded();
         };
         addChild(this.videoLabel = makeLabel(Translator.map("Video on:"),this.smallTextFormat,1,this.backdropLibraryButton.y + 22));
         this.videoButton = this.makeButton(turnVideoOn,"checkbox");
         this.videoButton.x = this.videoLabel.x + this.videoLabel.width + 1;
         this.videoButton.y = this.videoLabel.y + 3;
         this.videoButton.disableMouseover();
         this.videoButton.isMomentary = false;
         addChild(this.videoButton);
         this.videoLabel.visible = this.videoButton.visible = false;
      }
      
      private function paintSprite(param1:IconButton) : void
      {
         var _loc2_:ScratchSprite = new ScratchSprite();
         _loc2_.setInitialCostume(ScratchCostume.emptyBitmapCostume(Translator.map("costume1"),false));
         app.addNewSprite(_loc2_,true);
      }
      
      protected function spriteFromCamera(param1:IconButton) : void
      {
         var savePhoto:Function = null;
         var b:IconButton = param1;
         savePhoto = function(param1:BitmapData):void
         {
            var _loc2_:ScratchSprite = new ScratchSprite();
            _loc2_.setInitialCostume(new ScratchCostume(Translator.map("photo1"),param1));
            app.addNewSprite(_loc2_);
            app.closeCameraDialog();
         };
         app.openCameraDialog(savePhoto);
      }
      
      private function spriteFromComputer(param1:IconButton) : void
      {
         this.importSprite(true);
      }
      
      private function spriteFromLibrary(param1:IconButton) : void
      {
         this.importSprite(false);
      }
      
      private function importSprite(param1:Boolean) : void
      {
         var addSprite:Function = null;
         var fromComputer:Boolean = param1;
         addSprite = function(param1:*):void
         {
            var _loc2_:ScratchSprite = null;
            var _loc5_:String = null;
            var _loc3_:ScratchCostume = param1 as ScratchCostume;
            if(_loc3_)
            {
               _loc2_ = new ScratchSprite(_loc3_.costumeName);
               _loc2_.setInitialCostume(_loc3_);
               app.addNewSprite(_loc2_);
               return;
            }
            _loc2_ = param1 as ScratchSprite;
            if(_loc2_)
            {
               app.addNewSprite(_loc2_);
               return;
            }
            var _loc4_:Array = param1 as Array;
            if(_loc4_)
            {
               _loc5_ = _loc4_[0].costumeName;
               if(_loc5_.length > 3)
               {
                  _loc5_ = _loc5_.slice(0,_loc5_.length - 2);
               }
               _loc2_ = new ScratchSprite(_loc5_);
               for each(_loc3_ in _loc4_)
               {
                  _loc2_.costumes.push(_loc3_);
               }
               if(_loc2_.costumes.length > 1)
               {
                  _loc2_.costumes.shift();
               }
               _loc2_.showCostumeNamed(_loc4_[0].costumeName);
               app.addNewSprite(_loc2_);
            }
         };
         var lib:MediaLibrary = app.getMediaLibrary("sprite",addSprite);
         if(fromComputer)
         {
            lib.importFromDisk();
         }
         else
         {
            lib.open();
         }
      }
      
      protected function backdropFromCamera(param1:IconButton) : void
      {
         var savePhoto:Function = null;
         var b:IconButton = param1;
         savePhoto = function(param1:BitmapData):void
         {
            addBackdrop(new ScratchCostume(Translator.map("photo1"),param1));
            app.closeCameraDialog();
         };
         app.openCameraDialog(savePhoto);
      }
      
      private function backdropFromComputer(param1:IconButton) : void
      {
         var _loc2_:MediaLibrary = app.getMediaLibrary("backdrop",this.addBackdrop);
         _loc2_.importFromDisk();
      }
      
      private function backdropFromLibrary(param1:IconButton) : void
      {
         var _loc2_:MediaLibrary = app.getMediaLibrary("backdrop",this.addBackdrop);
         _loc2_.open();
      }
      
      private function paintBackdrop(param1:IconButton) : void
      {
         this.addBackdrop(ScratchCostume.emptyBitmapCostume(Translator.map("backdrop1"),true));
      }
      
      protected function addBackdrop(param1:*) : void
      {
         var _loc2_:ScratchCostume = param1 as ScratchCostume;
         if(_loc2_)
         {
            if(!_loc2_.baseLayerData)
            {
               _loc2_.prepareToSave();
            }
            if(!app.okayToAdd(_loc2_.baseLayerData.length))
            {
               return;
            }
            _loc2_.costumeName = app.stagePane.unusedCostumeName(_loc2_.costumeName);
            app.stagePane.costumes.push(_loc2_);
            app.stagePane.showCostumeNamed(_loc2_.costumeName);
         }
         var _loc3_:Array = param1 as Array;
         if(_loc3_)
         {
            for each(_loc2_ in _loc3_)
            {
               if(!_loc2_.baseLayerData)
               {
                  _loc2_.prepareToSave();
               }
               if(!app.okayToAdd(_loc2_.baseLayerData.length))
               {
                  return;
               }
               app.stagePane.costumes.push(_loc2_);
            }
            app.stagePane.showCostumeNamed(_loc3_[0].costumeName);
         }
         app.setTab("images");
         app.selectSprite(app.stagePane);
         app.setSaveNeeded(true);
      }
      
      public function handleDrop(param1:*) : Boolean
      {
         return false;
      }
      
      protected function changeThumbnailOrder(param1:ScratchSprite, param2:int, param3:int) : void
      {
         var _loc7_:SpriteThumbnail = null;
         var _loc8_:ScratchSprite = null;
         param1.indexInLibrary = -1;
         var _loc4_:Boolean = false;
         var _loc5_:* = 1;
         var _loc6_:int = 0;
         while(_loc6_ < this.spritesPane.numChildren)
         {
            _loc7_ = this.spritesPane.getChildAt(_loc6_) as SpriteThumbnail;
            _loc8_ = _loc7_.targetObj as ScratchSprite;
            if(!_loc4_)
            {
               if(param3 < _loc7_.y - _loc7_.height / 2)
               {
                  param1.indexInLibrary = _loc5_++;
                  _loc4_ = true;
               }
               else if(param3 < _loc7_.y + _loc7_.height / 2)
               {
                  if(param2 < _loc7_.x)
                  {
                     param1.indexInLibrary = _loc5_++;
                     _loc4_ = true;
                  }
               }
            }
            if(_loc8_ != param1)
            {
               _loc8_.indexInLibrary = _loc5_++;
            }
            _loc6_++;
         }
         if(param1.indexInLibrary < 0)
         {
            param1.indexInLibrary = _loc5_++;
         }
         this.refresh();
      }
      
      private function allThumbnails() : Array
      {
         var _loc1_:Array = this.stageThumbnail ? [this.stageThumbnail] : [];
         var _loc2_:int = 0;
         while(_loc2_ < this.spritesPane.numChildren)
         {
            _loc1_.push(this.spritesPane.getChildAt(_loc2_));
            _loc2_++;
         }
         return _loc1_;
      }
   }
}

