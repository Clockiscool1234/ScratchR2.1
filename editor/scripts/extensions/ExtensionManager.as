package extensions
{
   import blocks.Block;
   import com.adobe.utils.StringUtil;
   import flash.errors.IllegalOperationError;
   import flash.events.*;
   import flash.net.*;
   import flash.utils.Dictionary;
   import interpreter.*;
   import mx.utils.URLUtil;
   import uiwidgets.DialogBox;
   import uiwidgets.IndicatorLight;
   import util.*;
   
   public class ExtensionManager
   {
      
      public static const extensionSeparator:String = "\x1f";
      
      public static const extensionSeparatorLegacy:String = ".";
      
      public static const picoBoardExt:String = "PicoBoard";
      
      public static const wedoExt:String = "LEGO WeDo";
      
      public static const wedo2Ext:String = "LEGO WeDo 2.0";
      
      public static const allowedDomains:Vector.<String> = new <String>[".github.io",".coding.me"];
      
      protected var app:Scratch;
      
      protected var extensionDict:Object = new Object();
      
      private var justStartedWait:Boolean;
      
      private var pollInProgress:Dictionary = new Dictionary(true);
      
      public function ExtensionManager(param1:Scratch)
      {
         super();
         this.app = param1;
         this.clearImportedExtensions();
      }
      
      public static function hasExtensionPrefix(param1:String) : Boolean
      {
         return param1.indexOf(extensionSeparator) >= 0;
      }
      
      public static function unpackExtensionName(param1:String) : String
      {
         var _loc2_:int = param1.indexOf(extensionSeparator);
         if(_loc2_ < 0)
         {
            return null;
         }
         return param1.substr(0,_loc2_);
      }
      
      public static function unpackExtensionAndOp(param1:String) : Array
      {
         var _loc2_:int = param1.indexOf(extensionSeparator);
         if(_loc2_ < 0)
         {
            return [null,param1];
         }
         return [param1.substr(0,_loc2_),param1.substr(_loc2_ + 1)];
      }
      
      public function extensionActive(param1:String) : Boolean
      {
         return this.extensionDict.hasOwnProperty(param1);
      }
      
      public function isInternal(param1:String) : Boolean
      {
         return this.extensionDict.hasOwnProperty(param1) && Boolean(this.extensionDict[param1].isInternal);
      }
      
      public function clearImportedExtensions() : void
      {
         var _loc1_:ScratchExtension = null;
         for each(_loc1_ in this.extensionDict)
         {
            if(_loc1_.showBlocks)
            {
               this.setEnabled(_loc1_.name,false);
            }
         }
         this.extensionDict = {};
         this.extensionDict[picoBoardExt] = ScratchExtension.PicoBoard();
         this.extensionDict[wedoExt] = ScratchExtension.WeDo();
         this.extensionDict[wedo2Ext] = ScratchExtension.WeDo2();
      }
      
      public function shouldForceAsync(param1:String) : Boolean
      {
         var _loc2_:String = unpackExtensionName(param1);
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:ScratchExtension = this.extensionDict[_loc2_];
         if(Boolean(_loc3_) && _loc3_.port != 0)
         {
            return false;
         }
         return this.app.isOffline;
      }
      
      public function specForCmd(param1:String) : Array
      {
         var _loc2_:ScratchExtension = null;
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         for each(_loc2_ in this.extensionDict)
         {
            for each(_loc3_ in _loc2_.blockSpecs)
            {
               if(_loc3_.length > 2)
               {
                  _loc4_ = _loc2_.useScratchPrimitives ? _loc3_[2] : _loc2_.name + extensionSeparator + _loc3_[2];
                  _loc5_ = _loc2_.useScratchPrimitives ? _loc3_[2] : _loc2_.name + extensionSeparatorLegacy + _loc3_[2];
                  if(param1 == _loc4_ || param1 == _loc5_)
                  {
                     return [_loc3_[1],_loc3_[0],Specs.extensionsCategory,_loc4_,_loc3_.slice(3)];
                  }
               }
            }
         }
         return null;
      }
      
      public function getExtensionSpecs(param1:Boolean) : Array
      {
         var specs:Array = null;
         var extName:String = null;
         var ext:ScratchExtension = null;
         var warnIfMissing:Boolean = param1;
         var missingExtensions:Array = [];
         specs = [];
         for(extName in this.extensionDict)
         {
            ext = this.extensionDict[extName];
            if(ext.blockSpecs.length > 0)
            {
               ext.blockSpecs.forEach(function(param1:Array, ... rest):void
               {
                  specs.push(param1[1]);
               });
            }
            else
            {
               missingExtensions.push(extName);
            }
         }
         if(warnIfMissing && missingExtensions.length > 0)
         {
            DialogBox.notify("Missing block specs","Block specs were missing for some extensions.\n" + "Please load these extensions and try again:\n" + missingExtensions.join(", "));
         }
         return specs;
      }
      
      public function setEnabled(param1:String, param2:Boolean) : void
      {
         var _loc4_:String = null;
         var _loc3_:ScratchExtension = this.extensionDict[param1];
         if(Boolean(_loc3_) && _loc3_.showBlocks != param2)
         {
            _loc3_.showBlocks = param2;
            if(this.app.jsEnabled && Boolean(_loc3_.javascriptURL))
            {
               if(param2)
               {
                  _loc4_ = _loc3_.isInternal ? Scratch.app.fixExtensionURL(_loc3_.javascriptURL) : _loc3_.javascriptURL;
                  this.app.externalCall("ScratchExtensions.loadExternalJS",null,_loc4_);
                  _loc3_.showBlocks = false;
               }
               else
               {
                  this.app.externalCall("ScratchExtensions.unregister",null,param1);
                  if(!_loc3_.isInternal)
                  {
                     delete this.extensionDict[param1];
                  }
                  this.app.updateTopBar();
               }
            }
         }
      }
      
      public function isEnabled(param1:String) : Boolean
      {
         var _loc2_:ScratchExtension = this.extensionDict[param1];
         return _loc2_ ? _loc2_.showBlocks : false;
      }
      
      public function enabledExtensions() : Array
      {
         var _loc2_:ScratchExtension = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.extensionDict)
         {
            if(_loc2_.showBlocks)
            {
               _loc1_.push(_loc2_);
            }
         }
         _loc1_.sortOn("name");
         return _loc1_;
      }
      
      public function stopButtonPressed() : *
      {
         var _loc1_:ScratchExtension = null;
         for each(_loc1_ in this.enabledExtensions())
         {
            this.call(_loc1_.name,"reset_all",[]);
         }
      }
      
      public function extensionsToSave() : Array
      {
         var _loc2_:ScratchExtension = null;
         var _loc3_:Object = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.extensionDict)
         {
            if(_loc2_.showBlocks)
            {
               _loc3_ = {};
               _loc3_.extensionName = _loc2_.name;
               _loc3_.blockSpecs = _loc2_.blockSpecs;
               _loc3_.menus = _loc2_.menus;
               if(_loc2_.url)
               {
                  _loc3_.url = _loc2_.url;
               }
               if(_loc2_.port)
               {
                  _loc3_.extensionPort = _loc2_.port;
               }
               else if(_loc2_.javascriptURL)
               {
                  _loc3_.javascriptURL = _loc2_.javascriptURL;
               }
               _loc1_.push(_loc3_);
            }
         }
         return _loc1_;
      }
      
      public function callCompleted(param1:String, param2:Number) : void
      {
         var _loc3_:ScratchExtension = this.extensionDict[param1];
         if(_loc3_ == null)
         {
            return;
         }
         var _loc4_:int = _loc3_.busy.indexOf(param2);
         if(_loc4_ > -1)
         {
            _loc3_.busy.splice(_loc4_,1);
         }
      }
      
      public function reporterCompleted(param1:String, param2:Number, param3:*) : void
      {
         var _loc6_:Object = null;
         var _loc4_:ScratchExtension = this.extensionDict[param1];
         if(_loc4_ == null)
         {
            return;
         }
         this.app.updateTopBar();
         var _loc5_:int = _loc4_.busy.indexOf(param2);
         if(_loc5_ > -1)
         {
            _loc4_.busy.splice(_loc5_,1);
            for(_loc6_ in _loc4_.waiting)
            {
               if(_loc4_.waiting[_loc6_] == param2)
               {
                  delete _loc4_.waiting[_loc6_];
                  (_loc6_ as Block).response = param3;
                  (_loc6_ as Block).requestState = 2;
               }
            }
         }
      }
      
      public function loadCustom(param1:ScratchExtension) : void
      {
         if(!this.extensionDict[param1.name] && Boolean(param1.javascriptURL))
         {
            this.extensionDict[param1.name] = param1;
            param1.showBlocks = false;
            this.setEnabled(param1.name,true);
         }
      }
      
      public function loadRawExtension(param1:Object) : ScratchExtension
      {
         var _loc4_:IndicatorLight = null;
         var _loc2_:ScratchExtension = this.extensionDict[param1.extensionName];
         if(!_loc2_)
         {
            _loc2_ = new ScratchExtension(param1.extensionName,param1.extensionPort);
         }
         _loc2_.port = param1.extensionPort;
         _loc2_.blockSpecs = param1.blockSpecs;
         if(param1.url)
         {
            _loc2_.url = param1.url;
         }
         _loc2_.showBlocks = true;
         _loc2_.menus = param1.menus;
         _loc2_.javascriptURL = param1.javascriptURL;
         if(param1.host)
         {
            _loc2_.host = param1.host;
         }
         this.extensionDict[param1.extensionName] = _loc2_;
         Scratch.app.translationChanged();
         Scratch.app.updatePalette();
         var _loc3_:int = 0;
         while(_loc3_ < this.app.palette.numChildren)
         {
            _loc4_ = this.app.palette.getChildAt(_loc3_) as IndicatorLight;
            if(Boolean(_loc4_) && _loc4_.target === _loc2_)
            {
               this.updateIndicator(_loc4_,_loc4_.target,true);
               break;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function loadSavedExtensions(param1:Array) : void
      {
         var extObj:Object = null;
         var ext:ScratchExtension = null;
         var domainAllowed:Boolean = false;
         var url:String = null;
         var i:int = 0;
         var savedExtensions:Array = param1;
         var extensionRefused:Function = function(param1:Object, param2:String):void
         {
            Scratch.app.jsThrowError("Refusing to load project extension \"" + param1.extensionName + "\": " + param2);
         };
         if(!savedExtensions)
         {
            return;
         }
         for each(extObj in savedExtensions)
         {
            if(this.isInternal(extObj.extensionName))
            {
               this.setEnabled(extObj.extensionName,true);
            }
            else if(!("extensionName" in extObj))
            {
               Scratch.app.jsThrowError("Refusing to load project extension without a name.");
            }
            else if(!("extensionPort" in extObj) && !("javascriptURL" in extObj))
            {
               extensionRefused(extObj,"No location specified.");
            }
            else if(!("blockSpecs" in extObj))
            {
               extensionRefused(extObj,"No blockSpecs.");
            }
            else
            {
               ext = new ScratchExtension(extObj.extensionName,int(extObj.extensionPort) || 0);
               ext.blockSpecs = extObj.blockSpecs;
               if(extObj.url)
               {
                  ext.url = extObj.url;
               }
               ext.showBlocks = true;
               ext.isInternal = false;
               ext.menus = extObj.menus;
               if(extObj.javascriptURL)
               {
                  if(!Scratch.app.isExtensionDevMode)
                  {
                     extensionRefused(extObj,"Experimental extensions are only supported on ScratchX.");
                     continue;
                  }
                  domainAllowed = false;
                  url = URLUtil.getServerName(extObj.javascriptURL).toLowerCase();
                  i = 0;
                  while(i < allowedDomains.length)
                  {
                     if(StringUtil.endsWith(url,allowedDomains[i]))
                     {
                        domainAllowed = true;
                        break;
                     }
                     i++;
                  }
                  if(!domainAllowed)
                  {
                     extensionRefused(extObj,"Experimental extensions must be hosted on an approved domain. Approved domains are: " + allowedDomains.join(", "));
                     continue;
                  }
                  ext.javascriptURL = extObj.javascriptURL;
                  ext.showBlocks = false;
                  if(extObj.id)
                  {
                     ext.id = extObj.id;
                  }
               }
               this.extensionDict[extObj.extensionName] = ext;
               this.setEnabled(extObj.extensionName,true);
            }
         }
         Scratch.app.updatePalette();
         Scratch.app.translationChanged();
      }
      
      public function menuItemsFor(param1:String, param2:String) : Array
      {
         var _loc3_:String = unpackExtensionName(param1);
         if(!_loc3_)
         {
            return null;
         }
         var _loc4_:ScratchExtension = this.extensionDict[_loc3_];
         if(!_loc4_ || !_loc4_.menus)
         {
            return null;
         }
         return _loc4_.menus[param2];
      }
      
      public function updateIndicator(param1:IndicatorLight, param2:ScratchExtension, param3:Boolean = false) : void
      {
         var statusCallback:Function;
         var msecsSinceLastResponse:uint = 0;
         var indicator:IndicatorLight = param1;
         var ext:ScratchExtension = param2;
         var firstTime:Boolean = param3;
         if(ext.port > 0)
         {
            msecsSinceLastResponse = CachedTimer.getCachedTimer() - ext.lastPollResponseTime;
            if(msecsSinceLastResponse > 500)
            {
               indicator.setColorAndMsg(14680064,"Cannot find helper app");
            }
            else if(ext.problem != "")
            {
               indicator.setColorAndMsg(14737408,ext.problem);
            }
            else
            {
               indicator.setColorAndMsg(49152,ext.success);
            }
         }
         else if(this.app.jsEnabled)
         {
            statusCallback = function(param1:Object):void
            {
               var _loc2_:uint = 0;
               if(!param1)
               {
                  param1 = {
                     "status":0,
                     "msg":"Cannot communicate with extension."
                  };
               }
               if(param1.status == 2)
               {
                  _loc2_ = 49152;
               }
               else if(param1.status == 1)
               {
                  _loc2_ = 14737408;
               }
               else
               {
                  _loc2_ = 14680064;
                  if(firstTime)
                  {
                     Scratch.app.showTip("extensions");
                     DialogBox.notify("Extension Problem","See the Tips window (on the right) to install the plug-in and get the extension working.");
                  }
               }
               indicator.setColorAndMsg(_loc2_,param1.msg);
            };
            this.app.externalCall("ScratchExtensions.getStatus",statusCallback,ext.name);
         }
      }
      
      public function primExtensionOp(param1:Block) : *
      {
         var primOrVarName:String;
         var args:Array;
         var i:int;
         var value:* = undefined;
         var responseObj:Object = null;
         var sensorName:String = null;
         var a:* = undefined;
         var activeThread:Thread = null;
         var id:int = 0;
         var b:Block = param1;
         var unpackedOp:Array = unpackExtensionAndOp(b.op);
         var extName:String = unpackedOp[0];
         var ext:ScratchExtension = this.extensionDict[extName];
         if(ext == null)
         {
            return 0;
         }
         primOrVarName = unpackedOp[1];
         args = [];
         i = 0;
         while(i < b.args.length)
         {
            args.push(this.app.interp.arg(b,i));
            i++;
         }
         if(b.isHat && b.isAsyncHat)
         {
            if(b.requestState == 0)
            {
               this.request(extName,primOrVarName,args,b);
               this.app.interp.doYield();
               return null;
            }
            if(b.requestState == 2)
            {
               b.requestState = 0;
               if(b.forceAsync)
               {
                  value = b.response as Boolean;
               }
               else
               {
                  responseObj = b.response as Object;
                  args.push(responseObj);
                  if(Boolean(responseObj) && responseObj.hasOwnProperty("predicate"))
                  {
                     this.app.externalCall("ScratchExtensions.getReporter",function(param1:*):void
                     {
                        value = param1;
                     },ext.name,responseObj.predicate,args);
                  }
                  else
                  {
                     value = true;
                  }
               }
               if(value)
               {
                  if(!this.app.runtime.waitingHatFired(b,true))
                  {
                     this.app.interp.doYield();
                  }
               }
               else
               {
                  this.app.interp.doYield();
                  this.app.runtime.waitingHatFired(b,false);
               }
            }
            else
            {
               this.app.interp.doYield();
            }
            return;
         }
         if(b.isReporter)
         {
            if(b.isRequester)
            {
               if(b.requestState == 2)
               {
                  b.requestState = 0;
                  return b.response;
               }
               if(b.requestState == 0)
               {
                  this.request(extName,primOrVarName,args,b);
               }
               return null;
            }
            sensorName = primOrVarName;
            if(ext.port > 0)
            {
               sensorName = encodeURIComponent(sensorName);
               for each(a in args)
               {
                  sensorName += "/" + encodeURIComponent(a);
               }
               value = ext.stateVars[sensorName];
            }
            else if(Scratch.app.jsEnabled)
            {
               if(Scratch.app.isOffline)
               {
                  throw new IllegalOperationError("JS reporters must be requesters in Offline.");
               }
               this.app.externalCall("ScratchExtensions.getReporter",function(param1:*):void
               {
                  value = param1;
               },ext.name,sensorName,args);
            }
            if(value == undefined)
            {
               value = 0;
            }
            if("b" == b.type)
            {
               value = ext.port > 0 ? "true" == value : true == value;
            }
            return value;
         }
         if("w" == b.type)
         {
            activeThread = this.app.interp.activeThread;
            if(!activeThread.firstTime)
            {
               if(ext.busy.indexOf(activeThread.tmp) > -1)
               {
                  this.app.interp.doYield();
               }
               else
               {
                  activeThread.tmp = 0;
                  activeThread.firstTime = true;
               }
               return;
            }
            id = ++ext.nextID;
            ext.busy.push(id);
            activeThread.tmp = id;
            this.app.interp.doYield();
            this.justStartedWait = true;
            if(ext.port == 0)
            {
               activeThread.firstTime = false;
               if(this.app.jsEnabled)
               {
                  this.app.externalCall("ScratchExtensions.runAsync",null,ext.name,primOrVarName,args,id);
               }
               else
               {
                  ext.busy.pop();
               }
               return;
            }
            args.unshift(id);
         }
         this.call(extName,primOrVarName,args);
      }
      
      public function call(param1:String, param2:String, param3:Array) : void
      {
         var _loc5_:Thread = null;
         var _loc4_:ScratchExtension = this.extensionDict[param1];
         if(_loc4_ == null)
         {
            return;
         }
         if(_loc4_.port > 0)
         {
            _loc5_ = this.app.interp.activeThread;
            if(Boolean(_loc5_) && param2 != "reset_all")
            {
               if(_loc5_.firstTime)
               {
                  this.httpCall(_loc4_,param2,param3);
                  _loc5_.firstTime = false;
                  this.app.interp.doYield();
               }
               else
               {
                  _loc5_.firstTime = true;
               }
            }
            else
            {
               this.httpCall(_loc4_,param2,param3);
            }
         }
         else
         {
            if(Scratch.app.jsEnabled)
            {
               if(param2 == "reset_all")
               {
                  this.app.externalCall("ScratchExtensions.stop",null,_loc4_.name);
               }
               else
               {
                  this.app.externalCall("ScratchExtensions.runCommand",null,_loc4_.name,param2,param3);
               }
            }
            this.app.interp.redraw();
         }
      }
      
      public function request(param1:String, param2:String, param3:Array, param4:Block) : void
      {
         var _loc5_:ScratchExtension = this.extensionDict[param1];
         if(_loc5_ == null)
         {
            param4.requestState = 2;
            return;
         }
         if(_loc5_.port > 0)
         {
            this.httpRequest(_loc5_,param2,param3,param4);
         }
         else if(Scratch.app.jsEnabled)
         {
            param4.requestState = 1;
            ++_loc5_.nextID;
            _loc5_.busy.push(_loc5_.nextID);
            _loc5_.waiting[param4] = _loc5_.nextID;
            if(param4.forceAsync)
            {
               this.app.externalCall("ScratchExtensions.getReporterForceAsync",null,_loc5_.name,param2,param3,_loc5_.nextID);
            }
            else
            {
               this.app.externalCall("ScratchExtensions.getReporterAsync",null,_loc5_.name,param2,param3,_loc5_.nextID);
            }
         }
      }
      
      private function httpRequest(param1:ScratchExtension, param2:String, param3:Array, param4:Block) : void
      {
         var url:String;
         var responseHandler:Function = null;
         var loader:URLLoader = null;
         var arg:* = undefined;
         var ext:ScratchExtension = param1;
         var op:String = param2;
         var args:Array = param3;
         var b:Block = param4;
         responseHandler = function(param1:Event):void
         {
            if(param1.type == Event.COMPLETE)
            {
               b.response = loader.data;
            }
            else
            {
               b.response = "";
            }
            b.requestState = 2;
            b.requestLoader = null;
         };
         loader = new URLLoader();
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,responseHandler);
         loader.addEventListener(IOErrorEvent.IO_ERROR,responseHandler);
         loader.addEventListener(Event.COMPLETE,responseHandler);
         b.requestState = 1;
         b.requestLoader = loader;
         url = "http://" + ext.host + ":" + ext.port + "/" + encodeURIComponent(op);
         for each(arg in args)
         {
            url += "/" + (arg is String ? encodeURIComponent(arg) : arg);
         }
         loader.load(new URLRequest(url));
      }
      
      private function httpCall(param1:ScratchExtension, param2:String, param3:Array) : void
      {
         var errorHandler:Function = null;
         var arg:* = undefined;
         var loader:URLLoader = null;
         var ext:ScratchExtension = param1;
         var op:String = param2;
         var args:Array = param3;
         errorHandler = function(param1:Event):void
         {
         };
         var url:String = "http://" + ext.host + ":" + ext.port + "/" + encodeURIComponent(op);
         for each(arg in args)
         {
            url += "/" + (arg is String ? encodeURIComponent(arg) : arg);
         }
         loader = new URLLoader();
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
         loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
         loader.load(new URLRequest(url));
      }
      
      public function getStateVar(param1:String, param2:String, param3:*) : *
      {
         var _loc4_:ScratchExtension = this.extensionDict[param1];
         if(_loc4_ == null)
         {
            return param3;
         }
         var _loc5_:* = _loc4_.stateVars[encodeURIComponent(param2)];
         return _loc5_ == undefined ? param3 : _loc5_;
      }
      
      public function step() : void
      {
         var _loc1_:ScratchExtension = null;
         for each(_loc1_ in this.extensionDict)
         {
            if(_loc1_.showBlocks)
            {
               if(!_loc1_.isInternal && _loc1_.port > 0)
               {
                  if(_loc1_.blockSpecs.length == 0)
                  {
                     this.httpGetSpecs(_loc1_);
                  }
                  this.httpPoll(_loc1_);
               }
            }
         }
      }
      
      private function httpGetSpecs(param1:ScratchExtension) : void
      {
         var completeHandler:Function = null;
         var errorHandler:Function = null;
         var loader:URLLoader = null;
         var ext:ScratchExtension = param1;
         completeHandler = function(param1:Event):void
         {
            var _loc2_:Object = null;
            try
            {
               _loc2_ = util.JSON.parse(loader.data);
            }
            catch(e:*)
            {
            }
            if(!_loc2_)
            {
               return;
            }
            if(_loc2_.blockSpecs)
            {
               ext.blockSpecs = _loc2_.blockSpecs;
            }
            if(_loc2_.menus)
            {
               ext.menus = _loc2_.menus;
            }
         };
         errorHandler = function(param1:Event):void
         {
         };
         var url:String = "http://" + ext.host + ":" + ext.port + "/get_specs";
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,completeHandler);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
         loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
         loader.load(new URLRequest(url));
      }
      
      private function httpPoll(param1:ScratchExtension) : void
      {
         var url:String;
         var completeHandler:Function = null;
         var errorHandler:Function = null;
         var loader:URLLoader = null;
         var ext:ScratchExtension = param1;
         completeHandler = function(param1:Event):void
         {
            delete pollInProgress[ext];
            processPollResponse(ext,loader.data);
         };
         errorHandler = function(param1:Event):void
         {
            delete pollInProgress[ext];
         };
         if(this.pollInProgress[ext])
         {
            return;
         }
         url = "http://" + ext.host + ":" + ext.port + "/poll";
         loader = new URLLoader();
         loader.addEventListener(Event.COMPLETE,completeHandler);
         loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
         loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
         this.pollInProgress[ext] = true;
         loader.load(new URLRequest(url));
      }
      
      private function processPollResponse(param1:ScratchExtension, param2:String) : void
      {
         var _loc3_:int = 0;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc8_:Number = NaN;
         var _loc9_:Array = null;
         var _loc10_:String = null;
         var _loc11_:int = 0;
         if(param2 == null)
         {
            return;
         }
         param1.lastPollResponseTime = CachedTimer.getCachedTimer();
         param1.problem = "";
         if(this.justStartedWait)
         {
            this.justStartedWait = false;
         }
         else
         {
            param1.busy = [];
         }
         var _loc4_:Array = param2.split("\n");
         for each(_loc5_ in _loc4_)
         {
            _loc3_ = _loc5_.indexOf(" ");
            if(_loc3_ == -1)
            {
               _loc3_ = _loc5_.length;
            }
            _loc6_ = _loc5_.slice(0,_loc3_);
            _loc7_ = decodeURIComponent(_loc5_.slice(_loc3_ + 1));
            switch(_loc6_)
            {
               case "_busy":
                  for each(_loc10_ in _loc7_.split(" "))
                  {
                     _loc11_ = parseInt(_loc10_);
                     if(param1.busy.indexOf(_loc11_) == -1)
                     {
                        param1.busy.push(_loc11_);
                     }
                  }
                  break;
               case "_problem":
                  param1.problem = _loc7_;
                  break;
               case "_success":
                  param1.success = _loc7_;
                  break;
               default:
                  _loc8_ = Interpreter.asNumber(_loc7_);
                  _loc9_ = _loc6_.split("/");
                  _loc3_ = 0;
                  while(_loc3_ < _loc9_.length)
                  {
                     _loc9_[_loc3_] = encodeURIComponent(decodeURIComponent(_loc9_[_loc3_]));
                     _loc3_++;
                  }
                  param1.stateVars[_loc9_.join("/")] = _loc8_ == _loc8_ ? _loc8_ : _loc7_;
            }
         }
      }
      
      public function hasExperimentalExtensions() : Boolean
      {
         var _loc1_:ScratchExtension = null;
         for each(_loc1_ in this.extensionDict)
         {
            if(!_loc1_.isInternal && Boolean(_loc1_.javascriptURL))
            {
               return true;
            }
         }
         return false;
      }
   }
}

