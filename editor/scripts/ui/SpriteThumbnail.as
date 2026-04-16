package ui
{
   import assets.Resources;
   import blocks.Block;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import scratch.ScratchCostume;
   import scratch.ScratchObj;
   import scratch.ScratchSound;
   import scratch.ScratchSprite;
   import translation.Translator;
   import ui.media.MediaInfo;
   import ui.parts.LibraryPart;
   import uiwidgets.IconButton;
   import uiwidgets.Menu;
   
   public class SpriteThumbnail extends Sprite
   {
      
      private const frameW:int = 73;
      
      private const frameH:int = 73;
      
      private const stageFrameH:int = 86;
      
      private const thumbnailW:int = 68;
      
      private const thumbnailH:int = 51;
      
      public var targetObj:ScratchObj;
      
      private var app:Scratch;
      
      private var thumbnail:Bitmap;
      
      private var label:TextField;
      
      private var sceneInfo:TextField;
      
      private var selectedFrame:Shape;
      
      private var highlightFrame:Shape;
      
      private var infoSprite:Sprite;
      
      private var detailsButton:IconButton;
      
      private var lastSrcImg:DisplayObject;
      
      private var lastName:String = "";
      
      private var lastSceneCount:int = 0;
      
      public function SpriteThumbnail(param1:ScratchObj, param2:Scratch)
      {
         super();
         this.targetObj = param1;
         this.app = param2;
         this.addFrame();
         this.addSelectedFrame();
         this.addHighlightFrame();
         this.thumbnail = new Bitmap();
         this.thumbnail.x = 3;
         this.thumbnail.y = 3;
         this.thumbnail.filters = [this.grayOutlineFilter()];
         addChild(this.thumbnail);
         this.label = Resources.makeLabel("",CSS.thumbnailFormat);
         this.label.width = this.frameW;
         addChild(this.label);
         if(param1.isStage)
         {
            this.sceneInfo = Resources.makeLabel("",CSS.thumbnailExtraInfoFormat);
            this.sceneInfo.width = this.frameW;
            addChild(this.sceneInfo);
         }
         this.addDetailsButton();
         this.updateThumbnail();
      }
      
      public static function strings() : Array
      {
         return ["backdrop","backdrops","hide","show","Stage"];
      }
      
      private function addDetailsButton() : void
      {
         this.detailsButton = new IconButton(this.showSpriteDetails,"spriteInfo");
         this.detailsButton.x = this.detailsButton.y = -2;
         this.detailsButton.isMomentary = true;
         this.detailsButton.visible = false;
         addChild(this.detailsButton);
      }
      
      private function addFrame() : void
      {
         if(this.targetObj.isStage)
         {
            return;
         }
         var _loc1_:Shape = new Shape();
         var _loc2_:Graphics = _loc1_.graphics;
         _loc2_.lineStyle(NaN);
         _loc2_.beginFill(16777215);
         _loc2_.drawRoundRect(0,0,this.frameW,this.frameH,12,12);
         _loc2_.endFill();
         addChild(_loc1_);
      }
      
      private function addSelectedFrame() : void
      {
         this.selectedFrame = new Shape();
         var _loc1_:Graphics = this.selectedFrame.graphics;
         var _loc2_:int = this.targetObj.isStage ? this.stageFrameH : this.frameH;
         _loc1_.lineStyle(3,CSS.overColor,1,true);
         _loc1_.beginFill(CSS.itemSelectedColor);
         _loc1_.drawRoundRect(0,0,this.frameW,_loc2_,12,12);
         _loc1_.endFill();
         this.selectedFrame.visible = false;
         addChild(this.selectedFrame);
      }
      
      private function addHighlightFrame() : void
      {
         var _loc1_:int = 14737408;
         this.highlightFrame = new Shape();
         var _loc2_:Graphics = this.highlightFrame.graphics;
         var _loc3_:int = this.targetObj.isStage ? this.stageFrameH : this.frameH;
         _loc2_.lineStyle(2,_loc1_,1,true);
         _loc2_.drawRoundRect(1,1,this.frameW - 1,_loc3_ - 1,12,12);
         this.highlightFrame.visible = false;
         addChild(this.highlightFrame);
      }
      
      public function setTarget(param1:ScratchObj) : void
      {
         this.targetObj = param1;
         this.updateThumbnail();
      }
      
      public function select(param1:Boolean) : void
      {
         if(this.selectedFrame.visible == param1)
         {
            return;
         }
         this.selectedFrame.visible = param1;
         this.detailsButton.visible = param1 && !this.targetObj.isStage;
      }
      
      public function showHighlight(param1:Boolean) : void
      {
         this.highlightFrame.visible = param1;
      }
      
      public function showInfo(param1:Boolean) : void
      {
         if(this.infoSprite)
         {
            removeChild(this.infoSprite);
            this.infoSprite = null;
         }
         if(param1)
         {
            this.infoSprite = this.makeInfoSprite();
            addChild(this.infoSprite);
         }
      }
      
      public function makeInfoSprite() : Sprite
      {
         var _loc1_:Sprite = null;
         var _loc2_:Bitmap = null;
         _loc1_ = new Sprite();
         _loc2_ = Resources.createBmp("hatshape");
         _loc2_.x = (this.frameW - _loc2_.width) / 2;
         _loc2_.y = 20;
         _loc1_.addChild(_loc2_);
         var _loc3_:TextField = Resources.makeLabel(String(this.targetObj.scripts.length),CSS.normalTextFormat);
         _loc3_.x = _loc2_.x + 20 - _loc3_.textWidth / 2;
         _loc3_.y = _loc2_.y + 4;
         _loc1_.addChild(_loc3_);
         return _loc1_;
      }
      
      public function updateThumbnail(param1:Boolean = false) : void
      {
         if(this.targetObj == null)
         {
            return;
         }
         if(param1)
         {
            this.lastSceneCount = -1;
         }
         this.updateName();
         if(this.targetObj.isStage)
         {
            this.updateSceneCount();
         }
         if(this.targetObj.img.numChildren == 0)
         {
            return;
         }
         if(this.targetObj.currentCostume().svgLoading)
         {
            return;
         }
         var _loc2_:DisplayObject = this.targetObj.img.getChildAt(0);
         if(_loc2_ == this.lastSrcImg)
         {
            return;
         }
         var _loc3_:ScratchCostume = this.targetObj.currentCostume();
         this.thumbnail.bitmapData = _loc3_.thumbnail(this.thumbnailW,this.thumbnailH,this.targetObj.isStage);
         this.lastSrcImg = _loc2_;
      }
      
      private function grayOutlineFilter() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter(CSS.onColor);
         _loc1_.strength = 1;
         _loc1_.blurX = _loc1_.blurY = 2;
         _loc1_.knockout = false;
         return _loc1_;
      }
      
      private function updateName() : void
      {
         var _loc1_:String = this.targetObj.isStage ? Translator.map("Stage") : this.targetObj.objName;
         if(_loc1_ == this.lastName)
         {
            return;
         }
         this.lastName = _loc1_;
         this.label.text = _loc1_;
         while(this.label.textWidth > 60 && _loc1_.length > 0)
         {
            _loc1_ = _loc1_.substring(0,_loc1_.length - 1);
            this.label.text = _loc1_ + "…";
         }
         this.label.x = (this.frameW - this.label.textWidth) / 2 - 2;
         this.label.y = 57;
      }
      
      private function updateSceneCount() : void
      {
         if(this.targetObj.costumes.length == this.lastSceneCount)
         {
            return;
         }
         var _loc1_:int = int(this.targetObj.costumes.length);
         this.sceneInfo.text = _loc1_ + " " + Translator.map(_loc1_ == 1 ? "backdrop" : "backdrops");
         this.sceneInfo.x = (this.frameW - this.sceneInfo.textWidth) / 2 - 2;
         this.sceneInfo.y = 70;
         this.lastSceneCount = _loc1_;
      }
      
      public function objToGrab(param1:MouseEvent) : MediaInfo
      {
         if(this.targetObj.isStage)
         {
            return null;
         }
         var _loc2_:MediaInfo = this.app.createMediaInfo(this.targetObj);
         _loc2_.removeDeleteButton();
         _loc2_.computeThumbnail();
         _loc2_.hideTextFields();
         return _loc2_;
      }
      
      public function handleDrop(param1:*) : Boolean
      {
         var copy:Block = null;
         var obj:* = param1;
         var addCostume:Function = function(param1:ScratchCostume):void
         {
            app.addCostume(param1,targetObj);
         };
         var addSound:Function = function(param1:ScratchSound):void
         {
            app.addSound(param1,targetObj);
         };
         var item:MediaInfo = obj as MediaInfo;
         if(item)
         {
            if(item.mycostume)
            {
               addCostume(item.mycostume.duplicate());
               return true;
            }
            if(item.mysound)
            {
               addSound(item.mysound.duplicate());
               return true;
            }
         }
         if(obj is Block)
         {
            if(this.targetObj == this.app.viewedObj())
            {
               return false;
            }
            copy = Block(obj).duplicate(false,this.targetObj.isStage);
            copy.x = this.app.scriptsPane.padding;
            copy.y = this.app.scriptsPane.padding;
            this.targetObj.scripts.push(copy);
            return false;
         }
         return false;
      }
      
      public function click(param1:Event) : void
      {
         if(!this.targetObj.isStage && this.targetObj is ScratchSprite)
         {
            this.app.flashSprite(this.targetObj as ScratchSprite);
         }
         this.app.selectSprite(this.targetObj);
      }
      
      public function menu(param1:MouseEvent) : Menu
      {
         var m:Menu;
         var hideInScene:Function = null;
         var showInScene:Function = null;
         var t:ScratchSprite = null;
         var evt:MouseEvent = param1;
         hideInScene = function():void
         {
            t.visible = false;
            t.updateBubble();
         };
         showInScene = function():void
         {
            t.visible = true;
            t.updateBubble();
         };
         if(this.targetObj.isStage)
         {
            return null;
         }
         t = this.targetObj as ScratchSprite;
         m = t.menu(evt);
         m.addLine();
         if(t.visible)
         {
            m.addItem("hide",hideInScene);
         }
         else
         {
            m.addItem("show",showInScene);
         }
         return m;
      }
      
      public function handleTool(param1:String, param2:MouseEvent) : void
      {
         if(param1 == "help")
         {
            Scratch.app.showTip("scratchUI");
         }
         var _loc3_:ScratchSprite = this.targetObj as ScratchSprite;
         if(!_loc3_)
         {
            return;
         }
         if(param1 == "copy")
         {
            _loc3_.duplicateSprite();
         }
         if(param1 == "cut")
         {
            _loc3_.deleteSprite();
         }
      }
      
      private function showSpriteDetails(param1:*) : void
      {
         var _loc2_:LibraryPart = parent.parent.parent as LibraryPart;
         if(_loc2_)
         {
            _loc2_.showSpriteDetails(true);
         }
      }
   }
}

