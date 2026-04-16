package ui.media
{
   import assets.Resources;
   import blocks.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import scratch.*;
   import translation.Translator;
   import ui.parts.*;
   import uiwidgets.*;
   
   public class MediaInfo extends Sprite
   {
      
      public var frameWidth:int = 81;
      
      private var frameHeight:int = 94;
      
      protected var thumbnailWidth:int = 68;
      
      protected var thumbnailHeight:int = 51;
      
      public var mycostume:ScratchCostume;
      
      public var mysprite:ScratchSprite;
      
      public var mysound:ScratchSound;
      
      public var scripts:Array;
      
      public var objType:String = "unknown";
      
      public var objName:String = "";
      
      public var objWidth:int = 0;
      
      public var bitmapResolution:int = 1;
      
      public var md5:String;
      
      public var owner:ScratchObj;
      
      public var isBackdrop:Boolean;
      
      public var forBackpack:Boolean;
      
      private var frame:Shape;
      
      private var thumbnail:Bitmap;
      
      private var label:TextField;
      
      private var info:TextField;
      
      private var deleteButton:IconButton;
      
      public function MediaInfo(param1:*, param2:ScratchObj = null)
      {
         super();
         this.owner = param2;
         this.mycostume = param1 as ScratchCostume;
         this.mysound = param1 as ScratchSound;
         this.mysprite = param1 as ScratchSprite;
         if(this.mycostume)
         {
            this.objType = "image";
            this.objName = this.mycostume.costumeName;
            this.md5 = this.mycostume.baseLayerMD5;
         }
         else if(this.mysound)
         {
            this.objType = "sound";
            this.objName = this.mysound.soundName;
            this.md5 = this.mysound.md5;
            if(this.owner)
            {
               this.frameHeight = 75;
            }
         }
         else if(this.mysprite)
         {
            this.objType = "sprite";
            this.objName = this.mysprite.objName;
            this.md5 = null;
         }
         else if(param1 is Block || param1 is Array)
         {
            this.objType = "script";
            this.objName = "";
            this.scripts = param1 is Block ? [BlockIO.stackToArray(param1)] : param1;
            this.md5 = null;
         }
         else
         {
            this.objType = param1.type ? param1.type : "";
            this.objName = param1.name ? param1.name : "";
            this.objWidth = param1.width ? int(param1.width) : 0;
            this.bitmapResolution = param1.bitmapResolution ? int(param1.bitmapResolution) : 1;
            this.scripts = param1.scripts;
            this.md5 = "script" != this.objType ? param1.md5 : null;
         }
         this.addFrame();
         this.addThumbnail();
         this.addLabelAndInfo();
         this.unhighlight();
         this.addDeleteButton();
         this.updateLabelAndInfo(false);
      }
      
      public static function strings() : Array
      {
         return ["Backdrop","Costume","Script","Sound","Sprite","save to local file"];
      }
      
      public function highlight() : void
      {
         if(this.frame.alpha != 1)
         {
            this.frame.alpha = 1;
            this.showDeleteButton(true);
         }
      }
      
      public function unhighlight() : void
      {
         if(this.frame.alpha != 0)
         {
            this.frame.alpha = 0;
            this.showDeleteButton(false);
         }
      }
      
      private function showDeleteButton(param1:Boolean) : void
      {
         if(this.deleteButton)
         {
            this.deleteButton.visible = param1;
            if(Boolean(param1 && this.mycostume) && Boolean(this.owner) && this.owner.costumes.length < 2)
            {
               this.deleteButton.visible = false;
            }
         }
      }
      
      public function updateMediaThumbnail() : void
      {
      }
      
      public function thumbnailX() : int
      {
         return this.thumbnail.x;
      }
      
      public function thumbnailY() : int
      {
         return this.thumbnail.y;
      }
      
      public function computeThumbnail() : Boolean
      {
         if(this.mycostume)
         {
            this.setLocalCostumeThumbnail();
         }
         else if(this.mysprite)
         {
            this.setLocalSpriteThumbnail();
         }
         else
         {
            if(!this.scripts)
            {
               return false;
            }
            this.setScriptThumbnail();
         }
         return true;
      }
      
      private function setLocalCostumeThumbnail() : void
      {
         var _loc1_:Boolean = Boolean(this.owner) && this.owner.isStage;
         var _loc2_:BitmapData = this.mycostume.thumbnail(this.thumbnailWidth,this.thumbnailHeight,_loc1_);
         this.isBackdrop = _loc1_;
         this.setThumbnailBM(_loc2_);
      }
      
      private function setLocalSpriteThumbnail() : void
      {
         this.setThumbnailBM(this.mysprite.currentCostume().thumbnail(this.thumbnailWidth,this.thumbnailHeight,false));
      }
      
      protected function fileType(param1:String) : String
      {
         if(!param1)
         {
            return "";
         }
         var _loc2_:int = param1.lastIndexOf(".");
         return _loc2_ < 0 ? "" : param1.slice(_loc2_ + 1);
      }
      
      private function setScriptThumbnail() : void
      {
         if(!this.scripts || this.scripts.length < 1)
         {
            return;
         }
         var _loc1_:Block = BlockIO.arrayToStack(this.scripts[0]);
         var _loc2_:Number = Math.min(this.thumbnailWidth / _loc1_.width,this.thumbnailHeight / _loc1_.height);
         var _loc3_:BitmapData = new BitmapData(this.thumbnailWidth,this.thumbnailHeight,true,0);
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(_loc2_,_loc2_);
         _loc3_.draw(_loc1_,_loc4_);
         this.setThumbnailBM(_loc3_);
      }
      
      protected function setThumbnailBM(param1:BitmapData) : void
      {
         this.thumbnail.bitmapData = param1;
         this.thumbnail.x = (this.frameWidth - this.thumbnail.width) / 2;
      }
      
      protected function setInfo(param1:String) : void
      {
         this.info.text = param1;
         this.info.x = Math.max(0,(this.frameWidth - this.info.textWidth) / 2);
      }
      
      public function updateLabelAndInfo(param1:Boolean) : void
      {
         this.forBackpack = param1;
         this.setText(this.label,param1 ? this.backpackTitle() : this.objName);
         this.label.x = (this.frameWidth - this.label.textWidth) / 2 - 2;
         this.setText(this.info,param1 ? this.objName : this.infoString());
         this.info.x = Math.max(0,(this.frameWidth - this.info.textWidth) / 2);
      }
      
      public function hideTextFields() : void
      {
         this.setText(this.label,"");
         this.setText(this.info,"");
      }
      
      private function backpackTitle() : String
      {
         if("image" == this.objType)
         {
            return Translator.map(this.isBackdrop ? "Backdrop" : "Costume");
         }
         if("script" == this.objType)
         {
            return Translator.map("Script");
         }
         if("sound" == this.objType)
         {
            return Translator.map("Sound");
         }
         if("sprite" == this.objType)
         {
            return Translator.map("Sprite");
         }
         return this.objType;
      }
      
      private function infoString() : String
      {
         if(this.mycostume)
         {
            return this.costumeInfoString();
         }
         if(this.mysound)
         {
            return this.soundInfoString(this.mysound.getLengthInMsec());
         }
         return "";
      }
      
      private function costumeInfoString() : String
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc4_:Rectangle = null;
         var _loc3_:DisplayObject = this.mycostume.displayObj();
         if(_loc3_ is Bitmap)
         {
            _loc1_ = _loc3_.width;
            _loc2_ = _loc3_.height;
         }
         else
         {
            _loc4_ = _loc3_.getBounds(_loc3_);
            _loc1_ = Math.ceil(_loc4_.width);
            _loc2_ = Math.ceil(_loc4_.height);
         }
         return _loc1_ + "x" + _loc2_;
      }
      
      private function soundInfoString(param1:Number) : String
      {
         var msecs:Number = param1;
         var twoDigits:Function = function(param1:int):String
         {
            return param1 < 10 ? "0" + param1 : "" + param1;
         };
         var secs:int = msecs / 1000;
         var hundredths:int = msecs % 1000 / 10;
         return twoDigits(secs / 60) + ":" + twoDigits(secs % 60) + "." + twoDigits(hundredths);
      }
      
      public function objToGrab(param1:MouseEvent) : *
      {
         var _loc2_:MediaInfo = Scratch.app.createMediaInfo({
            "type":this.objType,
            "name":this.objName,
            "width":this.objWidth,
            "md5":this.md5
         });
         if(this.mycostume)
         {
            _loc2_ = Scratch.app.createMediaInfo(this.mycostume,this.owner);
         }
         if(this.mysound)
         {
            _loc2_ = Scratch.app.createMediaInfo(this.mysound,this.owner);
         }
         if(this.mysprite)
         {
            _loc2_ = Scratch.app.createMediaInfo(this.mysprite);
         }
         if(this.scripts)
         {
            _loc2_ = Scratch.app.createMediaInfo(this.scripts);
         }
         _loc2_.removeDeleteButton();
         if(this.thumbnail.bitmapData)
         {
            _loc2_.thumbnail.bitmapData = this.thumbnail.bitmapData;
         }
         _loc2_.hideTextFields();
         return _loc2_;
      }
      
      public function addDeleteButton() : void
      {
         this.removeDeleteButton();
         this.deleteButton = new IconButton(this.deleteMe,Resources.createBmp("removeItem"));
         this.deleteButton.x = this.frame.width - this.deleteButton.width + 5;
         this.deleteButton.y = 3;
         this.deleteButton.visible = false;
         addChild(this.deleteButton);
      }
      
      public function removeDeleteButton() : void
      {
         if(this.deleteButton)
         {
            removeChild(this.deleteButton);
            this.deleteButton = null;
         }
      }
      
      public function backpackRecord() : Object
      {
         var _loc1_:Object = {
            "type":this.objType,
            "name":this.objName,
            "md5":this.md5
         };
         if(this.mycostume)
         {
            _loc1_.width = this.mycostume.width();
            _loc1_.height = this.mycostume.height();
            if(this.mycostume.bitmapResolution != 1)
            {
               _loc1_.bitmapResolution = this.mycostume.bitmapResolution;
            }
         }
         if(this.mysound)
         {
            _loc1_.seconds = this.mysound.getLengthInMsec() / 1000;
         }
         if(this.scripts)
         {
            _loc1_.scripts = this.scripts;
            delete _loc1_.md5;
         }
         return _loc1_;
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
      
      private function addThumbnail() : void
      {
         if("sound" == this.objType)
         {
            this.thumbnail = Resources.createBmp("speakerOff");
            this.thumbnail.x = 18;
            this.thumbnail.y = 16;
         }
         else
         {
            this.thumbnail = Resources.createBmp("questionMark");
            this.thumbnail.x = (this.frameWidth - this.thumbnail.width) / 2;
            this.thumbnail.y = 13;
         }
         addChild(this.thumbnail);
         if(this.owner)
         {
            this.computeThumbnail();
         }
      }
      
      private function addLabelAndInfo() : void
      {
         this.label = Resources.makeLabel("",CSS.thumbnailFormat);
         this.label.y = this.frameHeight - 28;
         addChild(this.label);
         this.info = Resources.makeLabel("",CSS.thumbnailExtraInfoFormat);
         this.info.y = this.frameHeight - 14;
         addChild(this.info);
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
         var _loc2_:Scratch = null;
         if(!this.getBackpack())
         {
            _loc2_ = Scratch.app;
            if(this.mycostume)
            {
               _loc2_.viewedObj().showCostumeNamed(this.mycostume.costumeName);
               _loc2_.selectCostume();
            }
            if(this.mysound)
            {
               _loc2_.selectSound(this.mysound);
            }
         }
      }
      
      public function handleTool(param1:String, param2:MouseEvent) : void
      {
         if(param1 == "copy")
         {
            this.duplicateMe();
         }
         if(param1 == "cut")
         {
            this.deleteMe();
         }
         if(param1 == "help")
         {
            Scratch.app.showTip("scratchUI");
         }
      }
      
      public function menu(param1:MouseEvent) : Menu
      {
         var _loc2_:Menu = new Menu();
         this.addMenuItems(_loc2_);
         return _loc2_;
      }
      
      protected function addMenuItems(param1:Menu) : void
      {
         if(!this.getBackpack())
         {
            param1.addItem("duplicate",this.duplicateMe);
         }
         param1.addItem("delete",this.deleteMe);
         param1.addLine();
         if(this.mycostume)
         {
            param1.addItem("save to local file",this.exportCostume);
         }
         if(this.mysound)
         {
            param1.addItem("save to local file",this.exportSound);
         }
      }
      
      protected function duplicateMe() : void
      {
         if(Boolean(this.owner) && !this.getBackpack())
         {
            if(this.mycostume)
            {
               Scratch.app.addCostume(this.mycostume.duplicate());
            }
            if(this.mysound)
            {
               Scratch.app.addSound(this.mysound.duplicate());
            }
         }
      }
      
      protected function deleteMe(param1:* = null) : void
      {
         if(this.owner)
         {
            Scratch.app.runtime.recordForUndelete(this,0,0,0,this.owner);
            if(this.mycostume)
            {
               this.owner.deleteCostume(this.mycostume);
               Scratch.app.refreshImageTab(false);
            }
            if(this.mysound)
            {
               this.owner.deleteSound(this.mysound);
               Scratch.app.refreshSoundTab();
            }
         }
      }
      
      private function exportCostume() : void
      {
         if(!this.mycostume)
         {
            return;
         }
         this.mycostume.prepareToSave();
         var _loc1_:String = ScratchCostume.fileExtension(this.mycostume.baseLayerData);
         var _loc2_:String = this.mycostume.costumeName + _loc1_;
         new FileReference().save(this.mycostume.baseLayerData,_loc2_);
      }
      
      private function exportSound() : void
      {
         if(!this.mysound)
         {
            return;
         }
         this.mysound.prepareToSave();
         var _loc1_:String = this.mysound.soundName + ".wav";
         new FileReference().save(this.mysound.soundData,_loc1_);
      }
      
      protected function getBackpack() : UIPart
      {
         return null;
      }
   }
}

