package extensions
{
   import flash.events.*;
   import flash.net.*;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import translation.Translator;
   import uiwidgets.Button;
   import uiwidgets.DialogBox;
   
   public class ExtensionDevManager extends ExtensionManager
   {
      
      public var localExt:ScratchExtension = null;
      
      public var localFilePoller:uint = 0;
      
      protected var localFileRef:FileReference;
      
      private var rawExtensionLoaded:Boolean = false;
      
      protected var localFileDirty:Boolean;
      
      private var localExtCodeDate:Date = null;
      
      public function ExtensionDevManager(param1:Scratch)
      {
         super(param1);
      }
      
      public function getLocalFileName(param1:ScratchExtension = null) : String
      {
         if(Boolean(this.localFileRef) && (param1 === this.localExt || param1 == null))
         {
            return this.localFileRef.name;
         }
         return null;
      }
      
      public function isLocalExtensionDirty(param1:ScratchExtension = null) : Boolean
      {
         return (!param1 || param1 == this.localExt) && Boolean(this.localExt) && this.localFileDirty;
      }
      
      override public function loadRawExtension(param1:Object) : ScratchExtension
      {
         var _loc2_:ScratchExtension = extensionDict[param1.extensionName];
         var _loc3_:Boolean = Boolean(this.localExt) && _loc2_ == this.localExt || Boolean(this.localFilePoller) && !this.localExt;
         _loc2_ = super.loadRawExtension(param1);
         if(_loc3_)
         {
            if(!this.localExt)
            {
               DialogBox.notify("Extensions","Your local extension \"" + _loc2_.name + "\" is now loaded.The editor will notice when " + this.localFileRef.name + " is\nsaved and offer you to reload the extension. Reloading an extension will stop the project.");
            }
            this.localExt = _loc2_;
            this.localExtensionLoaded();
            app.updatePalette();
            app.setSaveNeeded();
         }
         this.rawExtensionLoaded = true;
         return _loc2_;
      }
      
      protected function localExtensionLoaded() : void
      {
      }
      
      public function makeLoadExperimentalExtensionButton() : Button
      {
         var showShiftMenu:Function = null;
         showShiftMenu = function(param1:MouseEvent):void
         {
            loadAndWatchExtensionFile();
         };
         var button:Button = new Button(Translator.map("Load Experimental Extension"));
         button.addEventListener(MouseEvent.RIGHT_CLICK,showShiftMenu);
         button.setEventAction(function(param1:MouseEvent):void
         {
            if(param1.shiftKey)
            {
               showShiftMenu(param1);
            }
            else
            {
               Scratch.app.setModalOverlay(true);
               Scratch.app.externalCall("JSshowExtensionDialog");
            }
         });
         return button;
      }
      
      public function loadAndWatchExtensionFile(param1:ScratchExtension = null) : void
      {
         var filter:FileFilter;
         var self:ExtensionDevManager = null;
         var msg:String = null;
         var ext:ScratchExtension = param1;
         if(Boolean(this.localExt) || this.localFilePoller > 0)
         {
            msg = "Sorry, a new extension cannot be created while another extension is connected to a file. " + "Please save the project and disconnect from " + this.localFileRef.name + " first.";
            DialogBox.notify("Extensions",msg);
            return;
         }
         filter = new FileFilter("Scratch 2.0 Javascript Extension","*.js");
         self = this;
         Scratch.loadSingleFile(function(param1:Event):void
         {
            FileReference(param1.target).removeEventListener(Event.COMPLETE,arguments.callee);
            FileReference(param1.target).addEventListener(Event.COMPLETE,self.extensionFileLoaded);
            self.localExt = ext;
            self.extensionFileLoaded(param1);
         },filter);
      }
      
      public function stopWatchingExtensionFile() : void
      {
         if(this.localFilePoller > 0)
         {
            clearInterval(this.localFilePoller);
         }
         this.localExt = null;
         this.localFilePoller = 0;
         this.localFileDirty = false;
         this.localFileRef = null;
         this.localExtCodeDate = null;
         app.updatePalette();
      }
      
      protected function extensionFileLoaded(param1:Event) : void
      {
         var lastModified:Date = null;
         var self:ExtensionDevManager = null;
         var e:Event = param1;
         this.localFileRef = FileReference(e.target);
         lastModified = this.localFileRef.modificationDate;
         self = this;
         this.localFilePoller = setInterval(function():void
         {
            if(lastModified.getTime() != self.localFileRef.modificationDate.getTime())
            {
               lastModified = self.localFileRef.modificationDate;
               self.localFileDirty = true;
               clearInterval(self.localFilePoller);
               self.localFileRef.load();
            }
         },200);
         if(this.localFileDirty && Boolean(this.localExt))
         {
            app.updatePalette();
         }
         else
         {
            this.loadLocalCode();
         }
      }
      
      public function getLocalCodeDate() : Date
      {
         return this.localExtCodeDate;
      }
      
      public function loadLocalCode(param1:DialogBox = null) : void
      {
         Scratch.app.runtime.stopAll();
         if(this.localExt)
         {
            app.externalCall("ScratchExtensions.unregister",null,this.localExt.name);
         }
         this.localFileDirty = false;
         this.rawExtensionLoaded = false;
         this.localExtCodeDate = this.localFileRef.modificationDate;
         app.externalCall("ScratchExtensions.loadLocalJS",null,this.localFileRef.data.toString());
         app.updatePalette();
      }
      
      override public function setEnabled(param1:String, param2:Boolean) : void
      {
         var _loc3_:ScratchExtension = extensionDict[param1];
         if(Boolean(_loc3_) && Boolean(this.localExt === _loc3_) && !param2)
         {
            this.stopWatchingExtensionFile();
         }
         super.setEnabled(param1,param2);
      }
      
      public function getExperimentalExtensionNames() : Array
      {
         var _loc2_:ScratchExtension = null;
         var _loc1_:Array = [];
         for each(_loc2_ in extensionDict)
         {
            if(!_loc2_.isInternal && Boolean(_loc2_.javascriptURL))
            {
               _loc1_.push(_loc2_.name);
            }
         }
         return _loc1_;
      }
   }
}

