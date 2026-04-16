package
{
   import blocks.*;
   import com.adobe.utils.StringUtil;
   import extensions.ExtensionDevManager;
   import extensions.ExtensionManager;
   import flash.display.*;
   import flash.events.*;
   import flash.external.ExternalInterface;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.net.FileFilter;
   import flash.net.FileReference;
   import flash.net.FileReferenceList;
   import flash.net.LocalConnection;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.system.*;
   import flash.text.*;
   import flash.utils.*;
   import interpreter.*;
   import logging.Log;
   import logging.LogEntry;
   import logging.LogLevel;
   import mx.utils.URLUtil;
   import render3d.DisplayObjectContainerIn3D;
   import scratch.*;
   import svgeditor.tools.SVGTool;
   import translation.*;
   import ui.*;
   import ui.media.*;
   import ui.parts.*;
   import uiwidgets.*;
   import util.*;
   import watchers.ListWatcher;
   
   public class Scratch extends Sprite
   {
      
      public static var app:Scratch;
      
      public static const versionString:String = "v461.2";
      
      public var hostProtocol:String = "http";
      
      public var editMode:Boolean;
      
      public var isOffline:Boolean;
      
      public var isSmallPlayer:Boolean;
      
      public var stageIsContracted:Boolean;
      
      public var isIn3D:Boolean;
      
      public var render3D:DisplayObjectContainerIn3D;
      
      public var isArmCPU:Boolean;
      
      public var jsEnabled:Boolean = false;
      
      public var ignoreResize:Boolean = false;
      
      public var isExtensionDevMode:Boolean = false;
      
      public var isMicroworld:Boolean = false;
      
      public var presentationScale:Number;
      
      public var runtime:ScratchRuntime;
      
      public var interp:Interpreter;
      
      public var extensionManager:ExtensionManager;
      
      public var server:Server;
      
      public var gh:GestureHandler;
      
      public var projectID:String = "";
      
      public var projectOwner:String = "";
      
      public var projectIsPrivate:Boolean;
      
      public var oldWebsiteURL:String = "";
      
      public var loadInProgress:Boolean;
      
      public var debugOps:Boolean = false;
      
      public var debugOpCmd:String = "";
      
      protected var autostart:Boolean;
      
      private var viewedObject:ScratchObj;
      
      private var lastTab:String = "scripts";
      
      protected var wasEdited:Boolean;
      
      private var _usesUserNameBlock:Boolean = false;
      
      protected var languageChanged:Boolean;
      
      public var playerBG:Shape;
      
      public var palette:BlockPalette;
      
      public var scriptsPane:ScriptsPane;
      
      public var stagePane:ScratchStage;
      
      public var mediaLibrary:MediaLibrary;
      
      public var lp:LoadProgress;
      
      public var cameraDialog:CameraDialog;
      
      public var libraryPart:LibraryPart;
      
      protected var topBarPart:TopBarPart;
      
      protected var stagePart:StagePart;
      
      private var tabsPart:TabsPart;
      
      protected var scriptsPart:ScriptsPart;
      
      public var imagesPart:ImagesPart;
      
      public var soundsPart:SoundsPart;
      
      public const tipsBarClosedWidth:int = 17;
      
      public var logger:Log = new Log(16);
      
      private var pendingExtensionURLs:Array;
      
      private var debugRect:Shape;
      
      protected var wasEditing:Boolean;
      
      private var modalOverlay:Sprite;
      
      protected const kGitHashFieldWidth:int = 287;
      
      public var saveNeeded:Boolean;
      
      protected var originalProj:ByteArray;
      
      private var revertUndo:ByteArray;
      
      public function Scratch()
      {
         super();
         SVGTool.setStage(stage);
         loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR,this.uncaughtErrorHandler);
         app = this;
         this.determineJSAccess();
      }
      
      public static function fixFileName(param1:String) : String
      {
         var _loc5_:String = null;
         var _loc2_:String = "\\/:*?\"<>|%";
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1.charAt(_loc4_);
            if(_loc4_ == 0 && "." == _loc5_)
            {
               _loc5_ = "-";
            }
            _loc3_ += _loc2_.indexOf(_loc5_) > -1 ? "-" : _loc5_;
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function loadSingleFile(param1:Function, param2:FileFilter = null) : void
      {
         var fileSelected:Function = null;
         var fileList:FileReferenceList = null;
         var fileLoaded:Function = param1;
         var filter:FileFilter = param2;
         fileSelected = function(param1:Event):void
         {
            var _loc2_:FileReference = null;
            if(fileList.fileList.length > 0)
            {
               _loc2_ = FileReference(fileList.fileList[0]);
               _loc2_.addEventListener(Event.COMPLETE,fileLoaded);
               _loc2_.load();
            }
         };
         fileList = new FileReferenceList();
         fileList.addEventListener(Event.SELECT,fileSelected);
         try
         {
            fileList.browse(filter != null ? [filter] : null);
         }
         catch(e:*)
         {
         }
      }
      
      protected function determineJSAccess() : void
      {
         if(this.externalInterfaceAvailable())
         {
            try
            {
               this.externalCall("function(){return true;}",this.jsAccessDetermined);
               return;
            }
            catch(e:Error)
            {
            }
         }
         this.jsAccessDetermined(false);
      }
      
      private function jsAccessDetermined(param1:Boolean) : void
      {
         this.jsEnabled = param1;
         this.initialize();
      }
      
      protected function initialize() : void
      {
         this.isOffline = !URLUtil.isHttpURL(loaderInfo.url);
         this.hostProtocol = URLUtil.getProtocol(loaderInfo.url);
         this.isExtensionDevMode = loaderInfo.parameters["extensionDevMode"] == "true";
         this.isMicroworld = loaderInfo.parameters["microworldMode"] == "true";
         this.checkFlashVersion();
         this.initServer();
         stage.align = StageAlign.TOP_LEFT;
         stage.scaleMode = StageScaleMode.NO_SCALE;
         stage.frameRate = 30;
         if(stage.hasOwnProperty("color"))
         {
            stage["color"] = CSS.backgroundColor();
         }
         Block.setFonts(10,9,true,0);
         Block.MenuHandlerFunction = BlockMenus.BlockMenuHandler;
         CursorTool.init(this);
         app = this;
         this.stagePane = this.getScratchStage();
         this.gh = new GestureHandler(this,loaderInfo.parameters["inIE"] == "true");
         this.initInterpreter();
         this.initRuntime();
         this.initExtensionManager();
         Translator.initializeLanguageList();
         this.playerBG = new Shape();
         this.addParts();
         this.server.getSelectedLang(Translator.setLanguageValue);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.gh.mouseDown);
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.gh.mouseMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.gh.mouseUp);
         stage.addEventListener(MouseEvent.MOUSE_WHEEL,this.gh.mouseWheel);
         stage.addEventListener("rightClick",this.gh.rightMouseClick);
         stage.addEventListener(KeyboardEvent.KEY_UP,this.runtime.keyUp);
         stage.addEventListener(KeyboardEvent.KEY_DOWN,this.keyDown);
         stage.addEventListener(Event.ENTER_FRAME,this.step);
         stage.addEventListener(Event.RESIZE,this.onResize);
         this.setEditMode(this.startInEditMode());
         if(this.editMode)
         {
            this.runtime.installNewProject();
         }
         else
         {
            this.runtime.installEmptyProject();
         }
         this.fixLayout();
         this.handleStartupParameters();
      }
      
      protected function handleStartupParameters() : void
      {
         this.setupExternalInterface(false);
         this.jsEditorReady();
      }
      
      protected function setupExternalInterface(param1:Boolean) : void
      {
         if(!this.jsEnabled)
         {
            return;
         }
         this.addExternalCallback("ASloadExtension",this.extensionManager.loadRawExtension);
         this.addExternalCallback("ASextensionCallDone",this.extensionManager.callCompleted);
         this.addExternalCallback("ASextensionReporterDone",this.extensionManager.reporterCompleted);
         this.addExternalCallback("AScreateNewProject",this.createNewProjectScratchX);
         if(this.isExtensionDevMode)
         {
            this.addExternalCallback("ASloadGithubURL",this.loadGithubURL);
            this.addExternalCallback("ASloadBase64SBX",this.loadBase64SBX);
            this.addExternalCallback("ASsetModalOverlay",this.setModalOverlay);
         }
      }
      
      protected function jsEditorReady() : void
      {
         if(this.jsEnabled)
         {
            this.externalCall("JSeditorReady",function(param1:Boolean):void
            {
               if(!param1)
               {
                  jsThrowError("Calling JSeditorReady() failed.");
               }
            });
         }
      }
      
      private function loadSingleGithubURL(param1:String) : void
      {
         var request:URLRequest;
         var handleComplete:Function = null;
         var handleError:Function = null;
         var sbxLoader:URLLoader = null;
         var url:String = param1;
         handleComplete = function(param1:Event):void
         {
            var _loc2_:String = null;
            var _loc3_:int = 0;
            runtime.installProjectFromData(sbxLoader.data);
            if(StringUtil.trim(projectName()).length == 0)
            {
               _loc2_ = url;
               _loc3_ = _loc2_.indexOf("?");
               if(_loc3_ > 0)
               {
                  _loc2_ = _loc2_.slice(0,_loc3_);
               }
               _loc3_ = _loc2_.lastIndexOf("/");
               if(_loc3_ > 0)
               {
                  _loc2_ = _loc2_.substr(_loc3_ + 1);
               }
               _loc3_ = _loc2_.lastIndexOf(".sbx");
               if(_loc3_ > 0)
               {
                  _loc2_ = _loc2_.slice(0,_loc3_);
               }
               setProjectName(_loc2_);
            }
         };
         handleError = function(param1:ErrorEvent):void
         {
            jsThrowError("Failed to load SBX: " + param1.toString());
         };
         url = StringUtil.trim(unescape(url));
         var fileExtension:String = url.substr(url.lastIndexOf(".")).toLowerCase();
         if(fileExtension == ".js")
         {
            this.externalCall("ScratchExtensions.loadExternalJS",null,url);
            return;
         }
         this.loadInProgress = true;
         request = new URLRequest(url);
         sbxLoader = new URLLoader(request);
         sbxLoader.dataFormat = URLLoaderDataFormat.BINARY;
         sbxLoader.addEventListener(Event.COMPLETE,handleComplete);
         sbxLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,handleError);
         sbxLoader.addEventListener(IOErrorEvent.IO_ERROR,handleError);
         sbxLoader.load(request);
      }
      
      private function loadGithubURL(param1:*) : void
      {
         var _loc2_:String = null;
         var _loc4_:int = 0;
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc7_:int = 0;
         if(!this.isExtensionDevMode)
         {
            return;
         }
         var _loc3_:Array = param1 as Array;
         if(_loc3_)
         {
            _loc4_ = int(_loc3_.length);
            _loc5_ = [];
            _loc7_ = 0;
            while(_loc7_ < _loc4_)
            {
               _loc2_ = StringUtil.trim(unescape(_loc3_[_loc7_]));
               if(StringUtil.endsWith(_loc2_.toLowerCase(),".js"))
               {
                  _loc5_.push(_loc2_);
               }
               else if(_loc2_.length > 0)
               {
                  if(_loc6_)
                  {
                     this.jsThrowError("Ignoring extra project URL: " + _loc6_);
                  }
                  _loc6_ = StringUtil.trim(_loc2_);
               }
               _loc7_++;
            }
            if(_loc6_)
            {
               this.pendingExtensionURLs = _loc5_;
               this.loadSingleGithubURL(_loc6_);
            }
            else
            {
               _loc4_ = int(_loc5_.length);
               _loc7_ = 0;
               while(_loc7_ < _loc4_)
               {
                  this.loadSingleGithubURL(_loc5_[_loc7_]);
                  _loc7_++;
               }
               this.externalCall("JSshowWarning");
            }
         }
         else
         {
            _loc2_ = param1 as String;
            this.loadSingleGithubURL(_loc2_);
            this.externalCall("JSshowWarning");
         }
      }
      
      private function loadBase64SBX(param1:String) : void
      {
         var _loc2_:ByteArray = Base64Encoder.decode(param1);
         app.setProjectName("");
         this.runtime.installProjectFromData(_loc2_);
      }
      
      protected function initTopBarPart() : void
      {
         this.topBarPart = new TopBarPart(this);
      }
      
      protected function initScriptsPart() : void
      {
         this.scriptsPart = new ScriptsPart(this);
      }
      
      protected function initImagesPart() : void
      {
         this.imagesPart = new ImagesPart(this);
      }
      
      protected function initInterpreter() : void
      {
         this.interp = new Interpreter(this);
      }
      
      protected function initRuntime() : void
      {
         this.runtime = new ScratchRuntime(this,this.interp);
      }
      
      protected function initExtensionManager() : void
      {
         if(this.isExtensionDevMode)
         {
            this.extensionManager = new ExtensionDevManager(this);
         }
         else
         {
            this.extensionManager = new ExtensionManager(this);
         }
      }
      
      protected function initServer() : void
      {
         this.server = new Server();
      }
      
      public function showTip(param1:String) : void
      {
      }
      
      public function closeTips() : void
      {
      }
      
      public function reopenTips() : void
      {
      }
      
      public function tipsWidth() : int
      {
         return 0;
      }
      
      protected function startInEditMode() : Boolean
      {
         return this.isOffline || this.isExtensionDevMode;
      }
      
      public function getMediaLibrary(param1:String, param2:Function) : MediaLibrary
      {
         return new MediaLibrary(this,param1,param2);
      }
      
      public function getMediaPane(param1:Scratch, param2:String) : MediaPane
      {
         return new MediaPane(param1,param2);
      }
      
      public function getScratchStage() : ScratchStage
      {
         return new ScratchStage();
      }
      
      public function getPaletteBuilder() : PaletteBuilder
      {
         return new PaletteBuilder(this);
      }
      
      private function uncaughtErrorHandler(param1:UncaughtErrorEvent) : void
      {
         var _loc2_:Error = null;
         var _loc3_:ErrorEvent = null;
         if(param1.error is Error)
         {
            _loc2_ = param1.error as Error;
            this.logException(_loc2_);
         }
         else if(param1.error is ErrorEvent)
         {
            _loc3_ = param1.error as ErrorEvent;
            this.log(LogLevel.ERROR,_loc3_.toString());
         }
      }
      
      public function log(param1:String, param2:String, param3:Object = null) : LogEntry
      {
         return this.logger.log(param1,param2,param3);
      }
      
      public function logException(param1:Error) : void
      {
         this.log(LogLevel.ERROR,param1.toString());
      }
      
      public function logMessage(param1:String, param2:Object = null) : void
      {
         this.log(LogLevel.ERROR,param1,param2);
      }
      
      public function loadProjectFailed() : void
      {
         this.loadInProgress = false;
      }
      
      public function jsThrowError(param1:String) : void
      {
         var _loc2_:String = "SWF Error: " + param1;
         this.log(LogLevel.WARNING,_loc2_);
         if(this.jsEnabled)
         {
            this.externalCall("JSthrowError",null,_loc2_);
         }
      }
      
      protected function checkFlashVersion() : void
      {
         var _loc1_:String = null;
         var _loc2_:Array = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         if(Capabilities.playerType != "Desktop" || Capabilities.version.indexOf("IOS") === 0)
         {
            _loc1_ = Capabilities.version.substr(Capabilities.version.indexOf(" ") + 1);
            _loc2_ = _loc1_.split(",");
            _loc3_ = parseInt(_loc2_[0]);
            _loc4_ = parseInt(_loc2_[1]);
            if((_loc3_ > 11 || _loc3_ == 11 && _loc4_ >= 7) && !this.isArmCPU && Capabilities.cpuArchitecture == "x86")
            {
               this.render3D = new DisplayObjectContainerIn3D();
               this.render3D.setStatusCallback(this.handleRenderCallback);
               return;
            }
         }
         this.render3D = null;
      }
      
      protected function handleRenderCallback(param1:Boolean) : void
      {
         var _loc2_:int = 0;
         var _loc3_:ScratchSprite = null;
         if(!param1)
         {
            this.go2D();
            this.render3D = null;
         }
         else
         {
            _loc2_ = 0;
            while(_loc2_ < this.stagePane.numChildren)
            {
               _loc3_ = this.stagePane.getChildAt(_loc2_) as ScratchSprite;
               if(_loc3_)
               {
                  _loc3_.clearCachedBitmap();
                  _loc3_.updateCostume();
                  _loc3_.applyFilters();
               }
               _loc2_++;
            }
            this.stagePane.clearCachedBitmap();
            this.stagePane.updateCostume();
            this.stagePane.applyFilters();
         }
      }
      
      public function clearCachedBitmaps() : void
      {
         var _loc2_:ScratchSprite = null;
         var _loc1_:int = 0;
         while(_loc1_ < this.stagePane.numChildren)
         {
            _loc2_ = this.stagePane.getChildAt(_loc1_) as ScratchSprite;
            if(_loc2_)
            {
               _loc2_.clearCachedBitmap();
            }
            _loc1_++;
         }
         this.stagePane.clearCachedBitmap();
         try
         {
            new LocalConnection().connect("foo");
            new LocalConnection().connect("foo");
         }
         catch(e:Error)
         {
         }
      }
      
      public function go3D() : void
      {
         if(!this.render3D || this.isIn3D)
         {
            return;
         }
         var _loc1_:int = this.stagePart.getChildIndex(this.stagePane);
         this.stagePart.removeChild(this.stagePane);
         this.render3D.setStage(this.stagePane,this.stagePane.penLayer);
         this.stagePart.addChildAt(this.stagePane,_loc1_);
         this.isIn3D = true;
      }
      
      public function go2D() : void
      {
         var _loc2_:ScratchSprite = null;
         if(!this.render3D || !this.isIn3D)
         {
            return;
         }
         var _loc1_:int = this.stagePart.getChildIndex(this.stagePane);
         this.stagePart.removeChild(this.stagePane);
         this.render3D.setStage(null,null);
         this.stagePart.addChildAt(this.stagePane,_loc1_);
         this.isIn3D = false;
         _loc1_ = 0;
         while(_loc1_ < this.stagePane.numChildren)
         {
            _loc2_ = this.stagePane.getChildAt(_loc1_) as ScratchSprite;
            if(_loc2_)
            {
               _loc2_.clearCachedBitmap();
               _loc2_.updateCostume();
               _loc2_.applyFilters();
            }
            _loc1_++;
         }
         this.stagePane.clearCachedBitmap();
         this.stagePane.updateCostume();
         this.stagePane.applyFilters();
      }
      
      public function showDebugRect(param1:Rectangle) : void
      {
         var _loc2_:Point = this.stagePane.localToGlobal(new Point(0,0));
         if(!this.debugRect)
         {
            this.debugRect = new Shape();
         }
         var _loc3_:Graphics = this.debugRect.graphics;
         _loc3_.clear();
         if(param1)
         {
            _loc3_.lineStyle(2,16776960);
            _loc3_.drawRect(_loc2_.x + param1.x,_loc2_.y + param1.y,param1.width,param1.height);
            addChild(this.debugRect);
         }
      }
      
      public function strings() : Array
      {
         return ["a copy of the project file on your computer.","Project not saved!","Save now","Not saved; project did not load.","Save project?","Don\'t save","Save now","Saved","Revert","Undo Revert","Reverting...","Throw away all changes since opening this project?"];
      }
      
      public function viewedObj() : ScratchObj
      {
         return this.viewedObject;
      }
      
      public function stageObj() : ScratchStage
      {
         return this.stagePane;
      }
      
      public function projectName() : String
      {
         return this.stagePart.projectName();
      }
      
      public function highlightSprites(param1:Array) : void
      {
         this.libraryPart.highlight(param1);
      }
      
      public function refreshImageTab(param1:Boolean) : void
      {
         this.imagesPart.refresh(param1);
      }
      
      public function refreshSoundTab() : void
      {
         this.soundsPart.refresh();
      }
      
      public function selectCostume() : void
      {
         this.imagesPart.selectCostume();
      }
      
      public function selectSound(param1:ScratchSound) : void
      {
         this.soundsPart.selectSound(param1);
      }
      
      public function clearTool() : void
      {
         CursorTool.setTool(null);
         this.topBarPart.clearToolButtons();
      }
      
      public function tabsRight() : int
      {
         return this.tabsPart.x + this.tabsPart.w;
      }
      
      public function enableEditorTools(param1:Boolean) : void
      {
         this.imagesPart.editor.enableTools(param1);
      }
      
      public function get usesUserNameBlock() : Boolean
      {
         return this._usesUserNameBlock;
      }
      
      public function set usesUserNameBlock(param1:Boolean) : void
      {
         this._usesUserNameBlock = param1;
         this.stagePart.refresh();
      }
      
      public function updatePalette(param1:Boolean = true) : void
      {
         if(this.isShowing(this.scriptsPart))
         {
            this.scriptsPart.updatePalette();
         }
         if(param1)
         {
            this.runtime.clearAllCaches();
         }
      }
      
      public function setProjectName(param1:String) : void
      {
         while(true)
         {
            if(StringUtil.endsWith(param1,".sb"))
            {
               param1 = param1.slice(0,-3);
            }
            else if(StringUtil.endsWith(param1,".sb2"))
            {
               param1 = param1.slice(0,-4);
            }
            else
            {
               if(!StringUtil.endsWith(param1,".sbx"))
               {
                  break;
               }
               param1 = param1.slice(0,-4);
            }
         }
         this.stagePart.setProjectName(param1);
      }
      
      public function setPresentationMode(param1:Boolean) : void
      {
         if(this.stagePart.isInPresentationMode() != param1)
         {
            this.presentationModeWasChanged(param1);
         }
      }
      
      public function presentationModeWasChanged(param1:Boolean) : void
      {
         var _loc2_:ScratchObj = null;
         if(param1)
         {
            this.wasEditing = this.editMode;
            if(this.wasEditing)
            {
               this.setEditMode(false);
               if(this.jsEnabled)
               {
                  this.externalCall("tip_bar_api.hide");
               }
            }
         }
         else if(this.wasEditing)
         {
            this.setEditMode(true);
            if(this.jsEnabled)
            {
               this.externalCall("tip_bar_api.show");
            }
         }
         if(this.isOffline)
         {
            stage.displayState = param1 ? StageDisplayState.FULL_SCREEN_INTERACTIVE : StageDisplayState.NORMAL;
         }
         for each(_loc2_ in this.stagePane.allObjects())
         {
            _loc2_.applyFilters();
         }
         if(this.lp)
         {
            this.fixLoadProgressLayout();
         }
         this.stagePart.presentationModeWasChanged(param1);
         this.stagePane.updateCostume();
         if(this.isIn3D)
         {
            this.render3D.onStageResize();
         }
      }
      
      private function keyDown(param1:KeyboardEvent) : void
      {
         if(!param1.shiftKey && param1.charCode == 27)
         {
            this.gh.escKeyDown();
         }
         else if(param1.charCode == 27 && this.stagePart.isInPresentationMode())
         {
            this.setPresentationMode(false);
         }
         else if(param1.ctrlKey && param1.charCode == 109)
         {
            if(this.isIn3D)
            {
               this.go2D();
            }
            else
            {
               this.go3D();
            }
            param1.preventDefault();
            param1.stopImmediatePropagation();
         }
         else
         {
            this.runtime.keyDown(param1);
         }
      }
      
      private function setSmallStageMode(param1:Boolean) : void
      {
         this.stageIsContracted = param1;
         this.stagePart.updateRecordingTools();
         this.fixLayout();
         this.libraryPart.refresh();
         this.tabsPart.refresh();
         this.stagePane.applyFilters();
         this.stagePane.updateCostume();
      }
      
      public function projectLoaded() : void
      {
         var _loc1_:ScratchObj = null;
         this.removeLoadProgressBox();
         System.gc();
         if(this.autostart)
         {
            this.runtime.startGreenFlags(true);
         }
         this.loadInProgress = false;
         this.saveNeeded = false;
         for each(_loc1_ in this.stagePane.allObjects())
         {
            _loc1_.updateScriptsAfterTranslation();
         }
         if(this.jsEnabled && this.isExtensionDevMode)
         {
            if(this.pendingExtensionURLs)
            {
               this.loadGithubURL(this.pendingExtensionURLs);
               this.pendingExtensionURLs = null;
            }
            this.externalCall("JSprojectLoaded");
         }
      }
      
      public function resetPlugin(param1:Function) : void
      {
         if(this.jsEnabled)
         {
            this.externalCall("ScratchExtensions.resetPlugin");
         }
         if(param1 != null)
         {
            param1();
         }
      }
      
      protected function step(param1:Event) : void
      {
         CachedTimer.clearCachedTimer();
         this.gh.step();
         this.runtime.stepRuntime();
         Transition.step(null);
         this.stagePart.step();
         this.libraryPart.step();
         this.scriptsPart.step();
         this.imagesPart.step();
      }
      
      public function updateSpriteLibrary(param1:Boolean = false) : void
      {
         this.libraryPart.refresh();
      }
      
      public function updateTopBar() : void
      {
         this.topBarPart.refresh();
      }
      
      public function threadStarted() : void
      {
         this.stagePart.threadStarted();
      }
      
      public function selectSprite(param1:ScratchObj) : void
      {
         if(this.isShowing(this.imagesPart))
         {
            this.imagesPart.editor.shutdown();
         }
         if(this.isShowing(this.soundsPart))
         {
            this.soundsPart.editor.shutdown();
         }
         this.viewedObject = param1;
         this.libraryPart.refresh();
         this.tabsPart.refresh();
         if(this.isShowing(this.imagesPart))
         {
            this.imagesPart.refresh();
         }
         if(this.isShowing(this.soundsPart))
         {
            this.soundsPart.currentIndex = 0;
            this.soundsPart.refresh();
         }
         if(this.isShowing(this.scriptsPart))
         {
            this.scriptsPart.updatePalette();
            this.scriptsPane.viewScriptsFor(param1);
            this.scriptsPart.updateSpriteWatermark();
         }
      }
      
      public function setTab(param1:String) : void
      {
         if(this.isShowing(this.imagesPart))
         {
            this.imagesPart.editor.shutdown();
         }
         if(this.isShowing(this.soundsPart))
         {
            this.soundsPart.editor.shutdown();
         }
         this.hide(this.scriptsPart);
         this.hide(this.imagesPart);
         this.hide(this.soundsPart);
         if(!this.editMode)
         {
            return;
         }
         if(param1 == "images")
         {
            this.show(this.imagesPart);
            this.imagesPart.refresh();
         }
         else if(param1 == "sounds")
         {
            this.soundsPart.refresh();
            this.show(this.soundsPart);
         }
         else if(Boolean(param1) && param1.length > 0)
         {
            param1 = "scripts";
            this.scriptsPart.updatePalette();
            this.scriptsPane.viewScriptsFor(this.viewedObject);
            this.scriptsPart.updateSpriteWatermark();
            this.show(this.scriptsPart);
         }
         this.show(this.tabsPart);
         this.show(this.stagePart);
         this.tabsPart.selectTab(param1);
         this.lastTab = param1;
         if(this.saveNeeded)
         {
            this.setSaveNeeded(true);
         }
      }
      
      public function installStage(param1:ScratchStage) : void
      {
         var _loc2_:Boolean = this.shouldShowGreenFlag();
         this.stagePart.installStage(param1,_loc2_);
         this.selectSprite(param1);
         this.libraryPart.refresh();
         this.setTab("scripts");
         this.scriptsPart.resetCategory();
         this.wasEdited = false;
      }
      
      protected function shouldShowGreenFlag() : Boolean
      {
         return !(this.autostart || this.editMode);
      }
      
      protected function addParts() : void
      {
         this.initTopBarPart();
         this.stagePart = this.getStagePart();
         this.libraryPart = this.getLibraryPart();
         this.tabsPart = new TabsPart(this);
         this.initScriptsPart();
         this.initImagesPart();
         this.soundsPart = new SoundsPart(this);
         addChild(this.topBarPart);
         addChild(this.stagePart);
         addChild(this.libraryPart);
         addChild(this.tabsPart);
      }
      
      protected function getStagePart() : StagePart
      {
         return new StagePart(this);
      }
      
      protected function getLibraryPart() : LibraryPart
      {
         return new LibraryPart(this);
      }
      
      public function fixExtensionURL(param1:String) : String
      {
         return param1;
      }
      
      public function setEditMode(param1:Boolean) : void
      {
         Menu.removeMenusFrom(stage);
         this.editMode = param1;
         if(this.editMode)
         {
            this.interp.showAllRunFeedback();
            this.hide(this.playerBG);
            this.show(this.topBarPart);
            this.show(this.libraryPart);
            this.show(this.tabsPart);
            this.setTab(this.lastTab);
            this.stagePart.hidePlayButton();
            this.runtime.edgeTriggersEnabled = true;
         }
         else
         {
            addChildAt(this.playerBG,0);
            this.playerBG.visible = false;
            this.hide(this.topBarPart);
            this.hide(this.libraryPart);
            this.hide(this.tabsPart);
            this.setTab(null);
         }
         this.stagePane.updateListWatchers();
         this.show(this.stagePart);
         this.fixLayout();
         this.stagePart.refresh();
      }
      
      protected function hide(param1:DisplayObject) : void
      {
         if(param1.parent)
         {
            param1.parent.removeChild(param1);
         }
      }
      
      protected function show(param1:DisplayObject) : void
      {
         addChild(param1);
      }
      
      protected function isShowing(param1:DisplayObject) : Boolean
      {
         return param1.parent != null;
      }
      
      public function onResize(param1:Event) : void
      {
         if(!this.ignoreResize)
         {
            this.fixLayout();
         }
      }
      
      public function fixLayout() : void
      {
         var _loc1_:int = stage.stageWidth;
         var _loc2_:int = stage.stageHeight - 1;
         _loc1_ = Math.ceil(_loc1_ / scaleX);
         _loc2_ = Math.ceil(_loc2_ / scaleY);
         this.updateLayout(_loc1_,_loc2_);
      }
      
      public function updateRecordingTools(param1:Number) : void
      {
         this.stagePart.updateRecordingTools(param1);
      }
      
      public function removeRecordingTools() : void
      {
         this.stagePart.removeRecordingTools();
      }
      
      public function refreshStagePart() : void
      {
         this.stagePart.refresh();
      }
      
      protected function updateLayout(param1:int, param2:int) : void
      {
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         this.topBarPart.x = 0;
         this.topBarPart.y = 0;
         this.topBarPart.setWidthHeight(param1,28);
         var _loc3_:int = 2;
         var _loc4_:int = this.stagePart.computeTopBarHeight() + 1;
         if(this.editMode)
         {
            if(this.stageIsContracted)
            {
               this.stagePart.setWidthHeight(240 + _loc3_,180 + _loc4_,0.5);
            }
            else
            {
               this.stagePart.setWidthHeight(480 + _loc3_,360 + _loc4_,1);
            }
            this.stagePart.x = 5;
            this.stagePart.y = this.isMicroworld ? 5 : this.topBarPart.bottom() + 5;
            this.fixLoadProgressLayout();
            this.libraryPart.x = this.stagePart.x;
            this.libraryPart.y = this.stagePart.bottom() + 18;
            this.libraryPart.setWidthHeight(this.stagePart.w,param2 - this.libraryPart.y);
            this.tabsPart.x = this.stagePart.right() + 5;
            if(!this.isMicroworld)
            {
               this.tabsPart.y = this.topBarPart.bottom() + 5;
               this.tabsPart.fixLayout();
            }
            else
            {
               this.tabsPart.visible = false;
            }
            var _loc5_:int = this.tabsPart.y + 27;
            if(!this.isMicroworld)
            {
               param1 -= this.tipsWidth();
            }
            this.updateContentArea(this.tabsPart.x,_loc5_,param1 - this.tabsPart.x - 6,param2 - _loc5_ - 5,param2);
            return;
         }
         this.drawBG();
         _loc6_ = param1 > 550 ? 16 : 0;
         _loc7_ = Math.min((param1 - _loc3_ - _loc6_) / 480,(param2 - _loc4_ - _loc6_) / 360);
         _loc7_ = Math.max(0.01,_loc7_);
         _loc8_ = Math.floor(_loc7_ * 480 / 4) * 4;
         _loc7_ = _loc8_ / 480;
         this.presentationScale = _loc7_;
         _loc9_ = _loc7_ * 480 + _loc3_;
         _loc10_ = _loc7_ * 360 + _loc4_;
         this.stagePart.setWidthHeight(_loc9_,_loc10_,_loc7_);
         this.stagePart.x = int((param1 - _loc9_) / 2);
         this.stagePart.y = int((param2 - _loc10_) / 2);
         this.fixLoadProgressLayout();
      }
      
      protected function updateContentArea(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         this.imagesPart.x = this.soundsPart.x = this.scriptsPart.x = param1;
         this.imagesPart.y = this.soundsPart.y = this.scriptsPart.y = param2;
         this.imagesPart.setWidthHeight(param3,param4);
         this.soundsPart.setWidthHeight(param3,param4);
         this.scriptsPart.setWidthHeight(param3,param4);
         if(this.mediaLibrary)
         {
            this.mediaLibrary.setWidthHeight(this.topBarPart.w,param5);
         }
         if(this.isIn3D)
         {
            this.render3D.onStageResize();
         }
      }
      
      private function drawBG() : void
      {
         var _loc1_:Graphics = this.playerBG.graphics;
         _loc1_.clear();
         _loc1_.beginFill(0);
         _loc1_.drawRect(0,0,stage.stageWidth,stage.stageHeight);
      }
      
      public function setModalOverlay(param1:Boolean) : void
      {
         var eatEvent:Function;
         var enableOverlay:Boolean = param1;
         var currentlyEnabled:Boolean = !!this.modalOverlay;
         if(enableOverlay != currentlyEnabled)
         {
            if(enableOverlay)
            {
               eatEvent = function(param1:MouseEvent):void
               {
                  param1.stopImmediatePropagation();
                  param1.stopPropagation();
               };
               this.modalOverlay = new Sprite();
               this.modalOverlay.graphics.beginFill(CSS.backgroundColor_ScratchX,0.8);
               this.modalOverlay.graphics.drawRect(0,0,stage.width,stage.height);
               this.modalOverlay.addEventListener(MouseEvent.CLICK,eatEvent);
               this.modalOverlay.addEventListener(MouseEvent.MOUSE_DOWN,eatEvent);
               this.modalOverlay.addEventListener(MouseEvent.RIGHT_CLICK,eatEvent);
               this.modalOverlay.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,eatEvent);
               this.modalOverlay.addEventListener(MouseEvent.MIDDLE_CLICK,eatEvent);
               this.modalOverlay.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,eatEvent);
               stage.addChild(this.modalOverlay);
            }
            else
            {
               stage.removeChild(this.modalOverlay);
               this.modalOverlay = null;
            }
         }
      }
      
      public function logoButtonPressed(param1:IconButton) : void
      {
         if(this.isExtensionDevMode)
         {
            this.externalCall("showPage",null,"home");
         }
      }
      
      public function translationChanged() : void
      {
         var _loc1_:ScratchObj = null;
         var _loc2_:Sprite = null;
         var _loc3_:int = 0;
         var _loc4_:ListWatcher = null;
         for each(_loc1_ in this.stagePane.allObjects())
         {
            _loc1_.updateScriptsAfterTranslation();
         }
         _loc2_ = app.stagePane.getUILayer();
         _loc3_ = 0;
         while(_loc3_ < _loc2_.numChildren)
         {
            _loc4_ = _loc2_.getChildAt(_loc3_) as ListWatcher;
            if(_loc4_)
            {
               _loc4_.updateTranslation();
            }
            _loc3_++;
         }
         this.topBarPart.updateTranslation();
         this.stagePart.updateTranslation();
         this.libraryPart.updateTranslation();
         this.tabsPart.updateTranslation();
         this.updatePalette(false);
         this.imagesPart.updateTranslation();
         this.soundsPart.updateTranslation();
      }
      
      public function showFileMenu(param1:*) : void
      {
         var _loc2_:Menu = new Menu(null,"File",CSS.topBarColor(),28);
         _loc2_.addItem("New",this.createNewProject);
         _loc2_.addLine();
         this.addFileMenuItems(param1,_loc2_);
         _loc2_.showOnStage(stage,param1.x,this.topBarPart.bottom() - 1);
      }
      
      public function stopVideo(param1:*) : void
      {
         this.runtime.stopVideo();
      }
      
      protected function addFileMenuItems(param1:*, param2:Menu) : void
      {
         var b:* = param1;
         var m:Menu = param2;
         m.addItem("Load Project",this.runtime.selectProjectFile);
         m.addItem("Save Project",this.exportProjectToFile);
         if(this.runtime.recording || this.runtime.ready == ReadyLabel.COUNTDOWN || this.runtime.ready == ReadyLabel.READY)
         {
            m.addItem("Stop Video",this.runtime.stopVideo);
         }
         else
         {
            m.addItem("Record Project Video",this.runtime.exportToVideo);
         }
         if(this.canUndoRevert())
         {
            m.addLine();
            m.addItem("Undo Revert",this.undoRevert);
         }
         else if(this.canRevert())
         {
            m.addLine();
            m.addItem("Revert",this.revertToOriginalProject);
         }
         if(b.lastEvent.shiftKey)
         {
            m.addLine();
            m.addItem("Save Project Summary",this.saveSummary);
            m.addItem("Show version details",this.showVersionDetails);
         }
         if(Boolean(b.lastEvent.shiftKey) && this.jsEnabled)
         {
            m.addLine();
            m.addItem("Import experimental extension",function():void
            {
               var loadJSExtension:Function = null;
               loadJSExtension = function(param1:DialogBox):void
               {
                  var _loc2_:String = param1.getField("URL").replace(/^\s+|\s+$/g,"");
                  if(_loc2_.length == 0)
                  {
                     return;
                  }
                  externalCall("ScratchExtensions.loadExternalJS",null,_loc2_);
               };
               var d:DialogBox = new DialogBox(loadJSExtension);
               d.addTitle("Load Javascript Scratch Extension");
               d.addField("URL",120);
               d.addAcceptCancelButtons("Load");
               d.showOnStage(app.stage);
            });
         }
      }
      
      public function showEditMenu(param1:*) : void
      {
         var _loc2_:Menu = new Menu(null,"More",CSS.topBarColor(),28);
         _loc2_.addItem("Undelete",this.runtime.undelete,this.runtime.canUndelete());
         _loc2_.addLine();
         _loc2_.addItem("Small stage layout",this.toggleSmallStage,true,this.stageIsContracted);
         _loc2_.addItem("Turbo mode",this.toggleTurboMode,true,this.interp.turboMode);
         this.addEditMenuItems(param1,_loc2_);
         var _loc3_:Point = param1.localToGlobal(new Point(0,0));
         _loc2_.showOnStage(stage,param1.x,this.topBarPart.bottom() - 1);
      }
      
      protected function addEditMenuItems(param1:*, param2:Menu) : void
      {
         param2.addLine();
         param2.addItem("Edit block colors",this.editBlockColors);
      }
      
      protected function editBlockColors() : void
      {
         var _loc1_:DialogBox = new DialogBox();
         _loc1_.addTitle("Edit Block Colors");
         _loc1_.addWidget(new BlockColorEditor());
         _loc1_.addButton("Close",_loc1_.cancel);
         _loc1_.showOnStage(stage,true);
      }
      
      protected function canExportInternals() : Boolean
      {
         return false;
      }
      
      private function showAboutDialog() : void
      {
         DialogBox.notify("Scratch 2.0 " + versionString,"\n\nCopyright © 2012 MIT Media Laboratory" + "\nAll rights reserved." + "\n\nPlease do not distribute!",stage);
      }
      
      protected function onNewProject() : void
      {
      }
      
      protected function createNewProjectAndThen(param1:Function = null) : void
      {
         var clearProject:Function = null;
         var callback:Function = param1;
         clearProject = function():void
         {
            startNewProject("","");
            setProjectName("Untitled");
            onNewProject();
            topBarPart.refresh();
            stagePart.refresh();
            if(callback != null)
            {
               callback();
            }
         };
         this.saveProjectAndThen(clearProject);
      }
      
      protected function createNewProject(param1:* = null) : void
      {
         this.createNewProjectAndThen();
      }
      
      protected function createNewProjectScratchX(param1:Array) : void
      {
         var jsCallback:Array = param1;
         this.createNewProjectAndThen(function():void
         {
            externalCallArray(jsCallback);
         });
      }
      
      protected function saveProjectAndThen(param1:Function = null) : void
      {
         var doNothing:Function = null;
         var cancel:Function = null;
         var proceedWithoutSaving:Function = null;
         var save:Function = null;
         var d:DialogBox = null;
         var postSaveAction:Function = param1;
         doNothing = function():void
         {
         };
         cancel = function():void
         {
            d.cancel();
         };
         proceedWithoutSaving = function():void
         {
            d.cancel();
            postSaveAction();
         };
         save = function():void
         {
            d.cancel();
            exportProjectToFile(false,postSaveAction);
         };
         if(postSaveAction == null)
         {
            postSaveAction = doNothing;
         }
         if(!this.saveNeeded)
         {
            postSaveAction();
            return;
         }
         d = new DialogBox();
         d.addTitle("Save project?");
         d.addButton("Save",save);
         d.addButton("Don\'t save",proceedWithoutSaving);
         d.addButton("Cancel",cancel);
         d.showOnStage(stage);
      }
      
      public function exportProjectToFile(param1:Boolean = false, param2:Function = null) : void
      {
         var squeakSoundsConverted:Function = null;
         var fileSaved:Function = null;
         var projIO:ProjectIO = null;
         var fromJS:Boolean = param1;
         var saveCallback:Function = param2;
         squeakSoundsConverted = function():void
         {
            scriptsPane.saveScripts(false);
            var _loc1_:String = extensionManager.hasExperimentalExtensions() ? ".sbx" : ".sb2";
            var _loc2_:String = StringUtil.trim(projectName());
            _loc2_ = (_loc2_.length > 0 ? _loc2_ : "project") + _loc1_;
            var _loc3_:ByteArray = projIO.encodeProjectAsZipFile(stagePane);
            var _loc4_:FileReference = new FileReference();
            _loc4_.addEventListener(Event.COMPLETE,fileSaved);
            _loc4_.save(_loc3_,fixFileName(_loc2_));
         };
         fileSaved = function(param1:Event):void
         {
            if(!fromJS)
            {
               setProjectName(param1.target.name);
            }
            if(isExtensionDevMode)
            {
               saveNeeded = false;
            }
            if(saveCallback != null)
            {
               saveCallback();
            }
         };
         if(this.loadInProgress)
         {
            return;
         }
         projIO = new ProjectIO(this);
         projIO.convertSqueakSounds(this.stagePane,squeakSoundsConverted);
      }
      
      public function saveSummary() : void
      {
         var _loc1_:String = (this.projectName() || "project") + ".txt";
         var _loc2_:FileReference = new FileReference();
         _loc2_.save(this.stagePane.getSummary(),fixFileName(_loc1_));
      }
      
      public function toggleSmallStage() : void
      {
         this.setSmallStageMode(!this.stageIsContracted);
      }
      
      public function toggleTurboMode() : void
      {
         this.interp.turboMode = !this.interp.turboMode;
         this.stagePart.refresh();
      }
      
      public function handleTool(param1:String, param2:MouseEvent) : void
      {
      }
      
      public function showBubble(param1:String, param2:* = null, param3:* = null, param4:Number = 0) : void
      {
         if(param2 == null)
         {
            param2 = stage.mouseX;
         }
         if(param3 == null)
         {
            param3 = stage.mouseY;
         }
         this.gh.showBubble(param1,Number(param2),Number(param3),param4);
      }
      
      protected function makeVersionDetailsDialog() : DialogBox
      {
         var _loc1_:DialogBox = new DialogBox();
         _loc1_.addTitle("Version Details");
         _loc1_.addField("GPU enabled",this.kGitHashFieldWidth,true);
         _loc1_.addField("scratch-flash",this.kGitHashFieldWidth,"72e4729");
         return _loc1_;
      }
      
      protected function showVersionDetails() : void
      {
         var _loc1_:DialogBox = this.makeVersionDetailsDialog();
         _loc1_.addButton("OK",_loc1_.accept);
         _loc1_.showOnStage(stage);
      }
      
      public function setLanguagePressed(param1:IconButton) : void
      {
         var m:Menu;
         var setLanguage:Function = null;
         var entry:Array = null;
         var p:Point = null;
         var b:IconButton = param1;
         setLanguage = function(param1:String):void
         {
            Translator.setLanguage(param1);
            languageChanged = true;
         };
         if(Translator.languages.length == 0)
         {
            return;
         }
         m = new Menu(setLanguage,"Language",CSS.topBarColor(),28);
         if(b.lastEvent.shiftKey)
         {
            m.addItem("import translation file");
            m.addItem("set font size");
            m.addLine();
         }
         for each(entry in Translator.languages)
         {
            m.addItem(entry[1],entry[0]);
         }
         p = b.localToGlobal(new Point(0,0));
         m.showOnStage(stage,b.x,this.topBarPart.bottom() - 1);
      }
      
      public function startNewProject(param1:String, param2:String) : void
      {
         this.runtime.installNewProject();
         this.projectOwner = param1;
         this.projectID = param2;
         this.projectIsPrivate = true;
      }
      
      public function setSaveNeeded(param1:Boolean = false) : void
      {
         param1 = false;
         this.saveNeeded = true;
         if(!this.wasEdited)
         {
            param1 = true;
         }
         this.clearRevertUndo();
      }
      
      protected function clearSaveNeeded() : void
      {
         var twoDigits:Function = function(param1:int):String
         {
            return (param1 < 10 ? "0" : "") + param1;
         };
         this.saveNeeded = false;
         this.wasEdited = true;
      }
      
      public function saveForRevert(param1:ByteArray, param2:Boolean, param3:Boolean = false) : void
      {
         this.originalProj = param1;
         this.revertUndo = null;
      }
      
      protected function doRevert() : void
      {
         this.runtime.installProjectFromData(this.originalProj,false);
      }
      
      protected function revertToOriginalProject() : void
      {
         var preDoRevert:Function = null;
         preDoRevert = function():void
         {
            revertUndo = new ProjectIO(Scratch.app).encodeProjectAsZipFile(stagePane);
            doRevert();
         };
         if(!this.originalProj)
         {
            return;
         }
         DialogBox.confirm("Throw away all changes since opening this project?",stage,preDoRevert);
      }
      
      protected function undoRevert() : void
      {
         if(!this.revertUndo)
         {
            return;
         }
         this.runtime.installProjectFromData(this.revertUndo,false);
         this.revertUndo = null;
      }
      
      protected function canRevert() : Boolean
      {
         return this.originalProj != null;
      }
      
      protected function canUndoRevert() : Boolean
      {
         return this.revertUndo != null;
      }
      
      private function clearRevertUndo() : void
      {
         this.revertUndo = null;
      }
      
      public function addNewSprite(param1:ScratchSprite, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:ScratchCostume = null;
         var _loc5_:int = 0;
         for each(_loc4_ in param1.costumes)
         {
            if(!_loc4_.baseLayerData)
            {
               _loc4_.prepareToSave();
            }
            _loc5_ += _loc4_.baseLayerData.length;
         }
         if(!this.okayToAdd(_loc5_))
         {
            return;
         }
         param1.objName = this.stagePane.unusedSpriteName(param1.objName);
         param1.indexInLibrary = 1000000;
         param1.setScratchXY(int(200 * Math.random() - 100),int(100 * Math.random() - 50));
         if(param3)
         {
            param1.setScratchXY(this.stagePane.scratchMouseX(),this.stagePane.scratchMouseY());
         }
         this.stagePane.addChild(param1);
         param1.updateCostume();
         this.selectSprite(param1);
         this.setTab(param2 ? "images" : "scripts");
         this.setSaveNeeded(true);
         this.libraryPart.refresh();
         for each(_loc4_ in param1.costumes)
         {
            if(ScratchCostume.isSVGData(_loc4_.baseLayerData))
            {
               _loc4_.setSVGData(_loc4_.baseLayerData,false);
            }
         }
      }
      
      public function addSound(param1:ScratchSound, param2:ScratchObj = null) : void
      {
         if(Boolean(param1.soundData) && !this.okayToAdd(param1.soundData.length))
         {
            return;
         }
         if(!param2)
         {
            param2 = this.viewedObj();
         }
         param1.soundName = param2.unusedSoundName(param1.soundName);
         param2.sounds.push(param1);
         this.setSaveNeeded(true);
         if(param2 == this.viewedObj())
         {
            this.soundsPart.selectSound(param1);
            this.setTab("sounds");
         }
      }
      
      public function addCostume(param1:ScratchCostume, param2:ScratchObj = null) : void
      {
         if(!param1.baseLayerData)
         {
            param1.prepareToSave();
         }
         if(!this.okayToAdd(param1.baseLayerData.length))
         {
            return;
         }
         if(!param2)
         {
            param2 = this.viewedObj();
         }
         param1.costumeName = param2.unusedCostumeName(param1.costumeName);
         param2.costumes.push(param1);
         param2.showCostumeNamed(param1.costumeName);
         this.setSaveNeeded(true);
         if(param2 == this.viewedObj())
         {
            this.setTab("images");
         }
      }
      
      public function okayToAdd(param1:int) : Boolean
      {
         var _loc4_:ScratchObj = null;
         var _loc5_:ScratchCostume = null;
         var _loc6_:ScratchSound = null;
         var _loc7_:int = 0;
         var _loc2_:int = 50 * 1024 * 1024;
         var _loc3_:int = param1;
         for each(_loc4_ in this.stagePane.allObjects())
         {
            for each(_loc5_ in _loc4_.costumes)
            {
               if(!_loc5_.baseLayerData)
               {
                  _loc5_.prepareToSave();
               }
               _loc3_ += _loc5_.baseLayerData.length;
            }
            for each(_loc6_ in _loc4_.sounds)
            {
               _loc3_ += _loc6_.soundData.length;
            }
         }
         if(_loc3_ > _loc2_)
         {
            _loc7_ = Math.max(1,(_loc3_ - _loc2_) / 1024);
            DialogBox.notify("Sorry!","Adding that media asset would put this project over the size limit by " + _loc7_ + " KB\n" + "Please remove some costumes, backdrops, or sounds before adding additional media.",stage);
            return false;
         }
         return true;
      }
      
      public function flashSprite(param1:ScratchSprite) : void
      {
         var doFade:Function = null;
         var deleteBox:Function = null;
         var box:Shape = null;
         var spr:ScratchSprite = param1;
         doFade = function(param1:Number):void
         {
            box.alpha = param1;
         };
         deleteBox = function():void
         {
            if(box.parent)
            {
               box.parent.removeChild(box);
            }
         };
         var r:Rectangle = spr.getVisibleBounds(this);
         box = new Shape();
         box.graphics.lineStyle(3,CSS.overColor,1,true);
         box.graphics.beginFill(8421504);
         box.graphics.drawRoundRect(0,0,r.width,r.height,12,12);
         box.x = r.x;
         box.y = r.y;
         addChild(box);
         Transition.cubic(doFade,1,0,0.5,deleteBox);
      }
      
      public function addLoadProgressBox(param1:String) : void
      {
         this.removeLoadProgressBox();
         this.lp = new LoadProgress();
         this.lp.setTitle(param1);
         stage.addChild(this.lp);
         this.fixLoadProgressLayout();
      }
      
      public function removeLoadProgressBox() : void
      {
         if(Boolean(this.lp) && Boolean(this.lp.parent))
         {
            this.lp.parent.removeChild(this.lp);
         }
         this.lp = null;
      }
      
      private function fixLoadProgressLayout() : void
      {
         if(!this.lp)
         {
            return;
         }
         var _loc1_:Point = this.stagePane.localToGlobal(new Point(0,0));
         this.lp.scaleX = this.stagePane.scaleX;
         this.lp.scaleY = this.stagePane.scaleY;
         this.lp.x = int(_loc1_.x + (this.stagePane.width - this.lp.width) / 2);
         this.lp.y = int(_loc1_.y + (this.stagePane.height - this.lp.height) / 2);
      }
      
      public function openCameraDialog(param1:Function) : void
      {
         this.closeCameraDialog();
         this.cameraDialog = new CameraDialog(param1);
         this.cameraDialog.fixLayout();
         this.cameraDialog.x = (stage.stageWidth - this.cameraDialog.width) / 2;
         this.cameraDialog.y = (stage.stageHeight - this.cameraDialog.height) / 2;
         addChild(this.cameraDialog);
      }
      
      public function closeCameraDialog() : void
      {
         if(this.cameraDialog)
         {
            this.cameraDialog.closeDialog();
            this.cameraDialog = null;
         }
      }
      
      public function createMediaInfo(param1:*, param2:ScratchObj = null) : MediaInfo
      {
         return new MediaInfo(param1,param2);
      }
      
      public function externalInterfaceAvailable() : Boolean
      {
         return ExternalInterface.available;
      }
      
      public function externalCall(param1:String, param2:Function = null, ... rest) : void
      {
         var retVal:* = undefined;
         var functionName:String = param1;
         var returnValueCallback:Function = param2;
         var args:Array = rest;
         args.unshift(functionName);
         try
         {
            retVal = ExternalInterface.call.apply(ExternalInterface,args);
         }
         catch(e:Error)
         {
            logException(e);
         }
         if(returnValueCallback != null)
         {
            returnValueCallback(retVal);
         }
      }
      
      public function addExternalCallback(param1:String, param2:Function) : void
      {
         ExternalInterface.addCallback(param1,param2);
      }
      
      public function externalCallArray(param1:Array, param2:Function = null) : void
      {
         var _loc3_:Array = param1.concat();
         _loc3_.splice(1,0,param2);
         this.externalCall.apply(this,_loc3_);
      }
   }
}

