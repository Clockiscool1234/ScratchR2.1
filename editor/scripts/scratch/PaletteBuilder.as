package scratch
{
   import blocks.*;
   import extensions.*;
   import flash.display.*;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.net.*;
   import flash.text.*;
   import translation.Translator;
   import ui.ProcedureSpecEditor;
   import ui.media.MediaLibrary;
   import ui.parts.UIPart;
   import uiwidgets.*;
   
   public class PaletteBuilder
   {
      
      private static const reloadIcon:Class = PaletteBuilder_reloadIcon;
      
      protected var app:Scratch;
      
      protected var nextY:int;
      
      protected const pwidth:int = 215;
      
      public function PaletteBuilder(param1:Scratch)
      {
         super();
         this.app = param1;
      }
      
      public static function strings() : Array
      {
         return ["Stage selected:","No motion blocks","Make a Block","Make a List","Make a Variable","New List","List name","New Variable","Variable name","New Block","Add an Extension"];
      }
      
      public function showBlocksForCategory(param1:int, param2:Boolean, param3:Boolean = false) : void
      {
         var _loc6_:Array = null;
         if(this.app.palette == null)
         {
            return;
         }
         this.app.palette.clear(param2);
         this.nextY = 7;
         if(param1 == Specs.dataCategory)
         {
            return this.showDataCategory();
         }
         if(param1 == Specs.myBlocksCategory)
         {
            return this.showMyBlocksPalette(param3);
         }
         var _loc4_:String = Specs.categories[param1][1];
         var _loc5_:int = Specs.blockColor(param1);
         if(Boolean(this.app.viewedObj()) && this.app.viewedObj().isStage)
         {
            _loc6_ = ["Control","Looks","Motion","Pen","Sensing"];
            if(_loc6_.indexOf(_loc4_) != -1)
            {
               param1 += 100;
            }
            if(_loc4_ == "Motion")
            {
               this.addItem(this.makeLabel(Translator.map("Stage selected:")));
               this.nextY -= 6;
               this.addItem(this.makeLabel(Translator.map("No motion blocks")));
               return;
            }
         }
         this.addBlocksForCategory(param1,_loc5_);
         this.updateCheckboxes();
      }
      
      private function addBlocksForCategory(param1:int, param2:int) : void
      {
         var _loc3_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:Array = null;
         var _loc8_:String = null;
         var _loc9_:Block = null;
         var _loc10_:Boolean = false;
         var _loc4_:ScratchObj = this.app.viewedObj();
         for each(_loc5_ in Specs.commands)
         {
            if(_loc5_.length > 3 && _loc5_[2] == param1)
            {
               _loc6_ = this.app.interp.isImplemented(_loc5_[3]) ? param2 : 5263440;
               _loc7_ = _loc4_.defaultArgsFor(_loc5_[3],_loc5_.slice(4));
               _loc8_ = _loc5_[0];
               if(_loc4_.isStage && _loc5_[3] == "whenClicked")
               {
                  _loc8_ = "when Stage clicked";
               }
               _loc9_ = new Block(_loc8_,_loc5_[1],_loc6_,_loc5_[3],_loc7_);
               _loc10_ = this.isCheckboxReporter(_loc5_[3]);
               if(_loc10_)
               {
                  this.addReporterCheckbox(_loc9_);
               }
               this.addItem(_loc9_,_loc10_);
               _loc3_++;
            }
            else
            {
               if(_loc5_.length == 1 && _loc3_ > 0)
               {
                  this.nextY += 10 * _loc5_[0].length;
               }
               _loc3_ = 0;
            }
         }
      }
      
      protected function addItem(param1:DisplayObject, param2:Boolean = false) : void
      {
         param1.x = param2 ? 23 : 6;
         param1.y = this.nextY;
         this.app.palette.addChild(param1);
         this.app.palette.updateSize();
         this.nextY += param1.height + 5;
      }
      
      private function makeLabel(param1:String) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.selectable = false;
         _loc2_.background = false;
         _loc2_.text = param1;
         _loc2_.setTextFormat(CSS.normalTextFormat);
         return _loc2_;
      }
      
      private function showMyBlocksPalette(param1:Boolean) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:Block = null;
         var _loc6_:Block = null;
         var _loc2_:int = Specs.blockColor(Specs.procedureColor);
         this.addItem(new Button(Translator.map("Make a Block"),this.makeNewBlock,false,"/help/studio/tips/blocks/make-a-block/"));
         var _loc3_:Array = this.app.viewedObj().procedureDefinitions();
         if(_loc3_.length > 0)
         {
            this.nextY += 5;
            for each(_loc5_ in _loc3_)
            {
               _loc6_ = new Block(_loc5_.spec," ",Specs.procedureColor,Specs.CALL,_loc5_.defaultArgValues);
               this.addItem(_loc6_);
            }
            this.nextY += 5;
         }
         this.addExtensionButtons();
         for each(_loc4_ in this.app.extensionManager.enabledExtensions())
         {
            this.addExtensionSeparator(_loc4_);
            this.addBlocksForExtension(_loc4_);
         }
         this.updateCheckboxes();
      }
      
      protected function addExtensionButtons() : void
      {
         var _loc1_:ExtensionDevManager = null;
         this.addAddExtensionButton();
         if(Scratch.app.isExtensionDevMode)
         {
            _loc1_ = Scratch.app.extensionManager as ExtensionDevManager;
            if(_loc1_)
            {
               this.addItem(_loc1_.makeLoadExperimentalExtensionButton());
            }
         }
      }
      
      protected function addAddExtensionButton() : void
      {
         this.addItem(new Button(Translator.map("Add an Extension"),this.showAnExtension,false,"/help/studio/tips/blocks/add-an-extension/"));
      }
      
      private function showDataCategory() : void
      {
         var _loc4_:String = null;
         var _loc1_:int = Specs.variableColor;
         this.addItem(new Button(Translator.map("Make a Variable"),this.makeVariable));
         var _loc2_:Array = this.app.runtime.allVarNames().sort();
         if(_loc2_.length > 0)
         {
            for each(_loc4_ in _loc2_)
            {
               this.addVariableCheckbox(_loc4_,false);
               this.addItem(new Block(_loc4_,"r",_loc1_,Specs.GET_VAR),true);
            }
            this.nextY += 10;
            this.addBlocksForCategory(Specs.dataCategory,_loc1_);
            this.nextY += 15;
         }
         _loc1_ = Specs.listColor;
         this.addItem(new Button(Translator.map("Make a List"),this.makeList));
         var _loc3_:Array = this.app.runtime.allListNames().sort();
         if(_loc3_.length > 0)
         {
            for each(_loc4_ in _loc3_)
            {
               this.addVariableCheckbox(_loc4_,true);
               this.addItem(new Block(_loc4_,"r",_loc1_,Specs.GET_LIST),true);
            }
            this.nextY += 10;
            this.addBlocksForCategory(Specs.listCategory,_loc1_);
         }
         this.updateCheckboxes();
      }
      
      protected function createVar(param1:String, param2:VariableSettings) : *
      {
         var _loc3_:ScratchObj = param2.isLocal ? this.app.viewedObj() : this.app.stageObj();
         if(_loc3_.hasName(param1))
         {
            DialogBox.notify("Cannot Add","That name is already in use.");
            return;
         }
         var _loc4_:* = param2.isList ? _loc3_.lookupOrCreateList(param1) : _loc3_.lookupOrCreateVar(param1);
         this.app.runtime.showVarOrListFor(param1,param2.isList,_loc3_);
         this.app.setSaveNeeded();
         return _loc4_;
      }
      
      private function makeVariable() : void
      {
         var makeVar2:Function = null;
         var d:DialogBox = null;
         var varSettings:VariableSettings = null;
         makeVar2 = function():void
         {
            var _loc1_:String = d.getField("Variable name").replace(/^\s+|\s+$/g,"");
            if(_loc1_.length == 0)
            {
               return;
            }
            createVar(_loc1_,varSettings);
         };
         d = new DialogBox(makeVar2);
         varSettings = this.makeVarSettings(false,this.app.viewedObj().isStage);
         d.addTitle("New Variable");
         d.addField("Variable name",150);
         d.addWidget(varSettings);
         d.addAcceptCancelButtons("OK");
         d.showOnStage(this.app.stage);
      }
      
      private function makeList() : void
      {
         var makeList2:Function = null;
         var varSettings:VariableSettings = null;
         makeList2 = function(param1:DialogBox):void
         {
            var _loc2_:String = param1.getField("List name").replace(/^\s+|\s+$/g,"");
            if(_loc2_.length == 0)
            {
               return;
            }
            createVar(_loc2_,varSettings);
         };
         var d:DialogBox = new DialogBox(makeList2);
         varSettings = this.makeVarSettings(true,this.app.viewedObj().isStage);
         d.addTitle("New List");
         d.addField("List name",150);
         d.addWidget(varSettings);
         d.addAcceptCancelButtons("OK");
         d.showOnStage(this.app.stage);
      }
      
      protected function makeVarSettings(param1:Boolean, param2:Boolean) : VariableSettings
      {
         return new VariableSettings(param1,param2);
      }
      
      private function makeNewBlock() : void
      {
         var addBlockHat:Function = null;
         var specEditor:ProcedureSpecEditor = null;
         addBlockHat = function(param1:DialogBox):void
         {
            var _loc3_:Block = null;
            var _loc2_:String = specEditor.spec().replace(/^\s+|\s+$/g,"");
            if(_loc2_.length == 0)
            {
               return;
            }
            _loc3_ = new Block(_loc2_,"p",Specs.procedureColor,Specs.PROCEDURE_DEF);
            _loc3_.parameterNames = specEditor.inputNames();
            _loc3_.defaultArgValues = specEditor.defaultArgValues();
            _loc3_.warpProcFlag = specEditor.warpFlag();
            _loc3_.setSpec(_loc2_);
            _loc3_.x = 10 - app.scriptsPane.x + Math.random() * 100;
            _loc3_.y = 10 - app.scriptsPane.y + Math.random() * 100;
            app.scriptsPane.addChild(_loc3_);
            app.scriptsPane.saveScripts();
            app.runtime.updateCalls();
            app.updatePalette();
            app.setSaveNeeded();
         };
         specEditor = new ProcedureSpecEditor("",[],false);
         var d:DialogBox = new DialogBox(addBlockHat);
         d.addTitle("New Block");
         d.addWidget(specEditor);
         d.addAcceptCancelButtons("OK");
         d.showOnStage(this.app.stage,true);
         specEditor.setInitialFocus();
      }
      
      private function showAnExtension() : void
      {
         var addExt:Function = null;
         addExt = function(param1:ScratchExtension):void
         {
            if(param1.isInternal)
            {
               app.extensionManager.setEnabled(param1.name,true);
            }
            else
            {
               app.extensionManager.loadCustom(param1);
            }
            app.updatePalette();
         };
         var lib:MediaLibrary = this.app.getMediaLibrary("extension",addExt);
         lib.open();
      }
      
      protected function addReporterCheckbox(param1:Block) : void
      {
         var _loc2_:IconButton = new IconButton(this.toggleWatcher,"checkbox");
         _loc2_.disableMouseover();
         var _loc3_:ScratchObj = this.isSpriteSpecific(param1.op) ? this.app.viewedObj() : this.app.stagePane;
         _loc2_.clientData = {
            "type":"reporter",
            "targetObj":_loc3_,
            "cmd":param1.op,
            "block":param1,
            "color":param1.base.color
         };
         _loc2_.x = 6;
         _loc2_.y = this.nextY + 5;
         this.app.palette.addChild(_loc2_);
      }
      
      protected function isCheckboxReporter(param1:String) : Boolean
      {
         var _loc2_:Array = ["xpos","ypos","heading","costumeIndex","scale","volume","timeAndDate","backgroundIndex","sceneName","tempo","answer","timer","soundLevel","isLoud","sensor:","sensorPressed:","senseVideoMotion","xScroll","yScroll","getDistance","getTilt"];
         return _loc2_.indexOf(param1) > -1;
      }
      
      private function isSpriteSpecific(param1:String) : Boolean
      {
         var _loc2_:Array = ["costumeIndex","xpos","ypos","heading","scale","volume"];
         return _loc2_.indexOf(param1) > -1;
      }
      
      private function getBlockArg(param1:Block, param2:int) : String
      {
         var _loc3_:BlockArg = param1.args[param2] as BlockArg;
         if(_loc3_)
         {
            return _loc3_.argValue;
         }
         return "";
      }
      
      private function addVariableCheckbox(param1:String, param2:Boolean) : void
      {
         var _loc3_:IconButton = new IconButton(this.toggleWatcher,"checkbox");
         _loc3_.disableMouseover();
         var _loc4_:ScratchObj = this.app.viewedObj();
         if(param2)
         {
            if(_loc4_.listNames().indexOf(param1) < 0)
            {
               _loc4_ = this.app.stagePane;
            }
         }
         else if(_loc4_.varNames().indexOf(param1) < 0)
         {
            _loc4_ = this.app.stagePane;
         }
         _loc3_.clientData = {
            "type":"variable",
            "isList":param2,
            "targetObj":_loc4_,
            "varName":param1
         };
         _loc3_.x = 6;
         _loc3_.y = this.nextY + 5;
         this.app.palette.addChild(_loc3_);
      }
      
      private function toggleWatcher(param1:IconButton) : void
      {
         var _loc2_:Object = param1.clientData;
         if(_loc2_.block)
         {
            switch(_loc2_.block.op)
            {
               case "senseVideoMotion":
                  _loc2_.targetObj = this.getBlockArg(_loc2_.block,1) == "Stage" ? this.app.stagePane : this.app.viewedObj();
               case "sensor:":
               case "sensorPressed:":
               case "timeAndDate":
                  _loc2_.param = this.getBlockArg(_loc2_.block,0);
            }
         }
         var _loc3_:Boolean = !this.app.runtime.watcherShowing(_loc2_);
         this.app.runtime.showWatcher(_loc2_,_loc3_);
         param1.setOn(_loc3_);
         this.app.setSaveNeeded();
      }
      
      private function updateCheckboxes() : void
      {
         var _loc2_:IconButton = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.app.palette.numChildren)
         {
            _loc2_ = this.app.palette.getChildAt(_loc1_) as IconButton;
            if(Boolean(_loc2_) && Boolean(_loc2_.clientData))
            {
               _loc2_.setOn(this.app.runtime.watcherShowing(_loc2_.clientData));
            }
            _loc1_++;
         }
      }
      
      protected function getExtensionMenu(param1:ScratchExtension) : Menu
      {
         var showAbout:Function = null;
         var hideExtension:Function = null;
         var extensionDevManager:ExtensionDevManager = null;
         var localFileName:String = null;
         var ext:ScratchExtension = param1;
         showAbout = function():void
         {
            if(ext.isInternal)
            {
               app.showTip("ext:" + ext.name);
            }
            else if(ext.url)
            {
               if(ext.url.indexOf("/info/") === 0)
               {
                  app.showTip(ext.url);
               }
               else if(ext.url.indexOf("http") === 0)
               {
                  navigateToURL(new URLRequest(ext.url));
               }
               else
               {
                  DialogBox.notify("Extensions","Unable to load about page: the URL given for extension \"" + ext.displayName + "\" is not formatted correctly.");
               }
            }
         };
         hideExtension = function():void
         {
            app.extensionManager.setEnabled(ext.name,false);
            app.updatePalette();
         };
         var m:Menu = new Menu();
         m.addItem(Translator.map("About") + " " + ext.displayName + " " + Translator.map("extension") + "...",showAbout,!!ext.url);
         m.addItem("Remove extension blocks",hideExtension);
         extensionDevManager = Scratch.app.extensionManager as ExtensionDevManager;
         if(!ext.isInternal && Boolean(extensionDevManager))
         {
            m.addLine();
            localFileName = extensionDevManager.getLocalFileName(ext);
            if(localFileName)
            {
               if(extensionDevManager.isLocalExtensionDirty())
               {
                  m.addItem("Load changes from " + localFileName,function():void
                  {
                     extensionDevManager.loadLocalCode();
                  });
               }
               m.addItem("Disconnect from " + localFileName,function():void
               {
                  extensionDevManager.stopWatchingExtensionFile();
               });
            }
         }
         return m;
      }
      
      protected function addExtensionSeparator(param1:ScratchExtension) : void
      {
         var titleButton:IconButton;
         var indicator:IndicatorLight;
         var extensionDevManager:ExtensionDevManager;
         var extensionMenu:Function = null;
         var fileName:String = null;
         var extensionEditStatus:TextField = null;
         var ext:ScratchExtension = param1;
         extensionMenu = function(param1:*):void
         {
            var _loc2_:Menu = getExtensionMenu(ext);
            _loc2_.showOnStage(app.stage);
         };
         this.nextY += 7;
         titleButton = UIPart.makeMenuButton(ext.displayName,extensionMenu,true,CSS.textColor);
         titleButton.x = 5;
         titleButton.y = this.nextY;
         this.app.palette.addChild(titleButton);
         this.addLineForExtensionTitle(titleButton,ext);
         indicator = new IndicatorLight(ext);
         indicator.addEventListener(MouseEvent.CLICK,function(param1:Event):void
         {
            Scratch.app.showTip("extensions");
         },false,0,true);
         this.app.extensionManager.updateIndicator(indicator,ext);
         indicator.x = this.pwidth - 40;
         indicator.y = this.nextY + 2;
         this.app.palette.addChild(indicator);
         this.nextY += titleButton.height + 10;
         extensionDevManager = Scratch.app.extensionManager as ExtensionDevManager;
         if(extensionDevManager)
         {
            fileName = extensionDevManager.getLocalFileName(ext);
            if(fileName)
            {
               extensionEditStatus = UIPart.makeLabel("Connected to " + fileName,CSS.normalTextFormat,8,this.nextY - 5);
               this.app.palette.addChild(extensionEditStatus);
               this.nextY += extensionEditStatus.textHeight + 3;
            }
         }
      }
      
      protected function addLineForExtensionTitle(param1:IconButton, param2:ScratchExtension) : void
      {
         var extensionDevManager:ExtensionDevManager = null;
         var reload:Bitmap = null;
         var reloadBtn:Sprite = null;
         var titleButton:IconButton = param1;
         var ext:ScratchExtension = param2;
         var x:int = titleButton.width + 12;
         var w:int = this.pwidth - x - 48;
         extensionDevManager = Scratch.app.extensionManager as ExtensionDevManager;
         var dirty:Boolean = Boolean(extensionDevManager) && extensionDevManager.isLocalExtensionDirty(ext);
         if(dirty)
         {
            w -= 15;
         }
         this.addLine(x,this.nextY + 9,w);
         if(dirty)
         {
            reload = new reloadIcon();
            reload.scaleX = 0.75;
            reload.scaleY = 0.75;
            reloadBtn = new Sprite();
            reloadBtn.addChild(reload);
            reloadBtn.x = x + w + 6;
            reloadBtn.y = this.nextY + 2;
            this.app.palette.addChild(reloadBtn);
            SimpleTooltips.add(reloadBtn,{
               "text":"Click to load changes (running old code from " + extensionDevManager.getLocalCodeDate() + ")",
               "direction":"top"
            });
            reloadBtn.addEventListener(MouseEvent.MOUSE_DOWN,function(param1:MouseEvent):void
            {
               SimpleTooltips.hideAll();
               extensionDevManager.loadLocalCode();
            });
            reloadBtn.addEventListener(MouseEvent.ROLL_OVER,function(param1:MouseEvent):void
            {
               reloadBtn.transform.colorTransform = new ColorTransform(2,2,2);
            });
            reloadBtn.addEventListener(MouseEvent.ROLL_OUT,function(param1:MouseEvent):void
            {
               reloadBtn.transform.colorTransform = new ColorTransform();
            });
         }
      }
      
      private function addBlocksForExtension(param1:ScratchExtension) : void
      {
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:Block = null;
         var _loc8_:Boolean = false;
         var _loc2_:int = Specs.extensionsColor;
         var _loc3_:String = param1.useScratchPrimitives ? "" : param1.name + ExtensionManager.extensionSeparator;
         for each(_loc4_ in param1.blockSpecs)
         {
            if(_loc4_.length >= 3)
            {
               _loc5_ = _loc3_ + _loc4_[2];
               _loc6_ = _loc4_.slice(3);
               _loc7_ = new Block(_loc4_[1],_loc4_[0],_loc2_,_loc5_,_loc6_);
               _loc8_ = _loc7_.isReporter && !_loc7_.isRequester && _loc6_.length == 0;
               if(_loc8_)
               {
                  this.addReporterCheckbox(_loc7_);
               }
               this.addItem(_loc7_,_loc8_);
            }
            else if(_loc4_.length == 1)
            {
               this.nextY += 10 * _loc4_[0].length;
            }
         }
      }
      
      protected function addLine(param1:int, param2:int, param3:int) : void
      {
         var _loc4_:int = 15921906;
         var _loc5_:int = CSS.borderColor - 1315860;
         var _loc6_:Shape = new Shape();
         var _loc7_:Graphics = _loc6_.graphics;
         _loc7_.lineStyle(1,_loc5_,1,true);
         _loc7_.moveTo(0,0);
         _loc7_.lineTo(param3,0);
         _loc7_.lineStyle(1,_loc4_,1,true);
         _loc7_.moveTo(0,1);
         _loc7_.lineTo(param3,1);
         _loc6_.x = param1;
         _loc6_.y = param2;
         this.app.palette.addChild(_loc6_);
      }
   }
}

