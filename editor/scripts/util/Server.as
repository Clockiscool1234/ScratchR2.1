package util
{
   import by.blooddy.crypto.serialization.JSON;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.events.ErrorEvent;
   import flash.events.Event;
   import flash.events.HTTPStatusEvent;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.geom.Matrix;
   import flash.net.SharedObject;
   import flash.net.URLLoader;
   import flash.net.URLLoaderDataFormat;
   import flash.net.URLRequest;
   import flash.net.URLRequestHeader;
   import flash.net.URLRequestMethod;
   import flash.system.Capabilities;
   import flash.system.Security;
   import flash.utils.ByteArray;
   import logging.LogLevel;
   import mx.utils.URLUtil;
   
   public class Server implements IServer
   {
      
      protected var URLs:Object;
      
      public var callServerErrorInfo:Object;
      
      public function Server()
      {
         var _loc1_:String = null;
         this.URLs = {};
         super();
         this.setDefaultURLs();
         try
         {
            _loc1_ = Scratch.app.loaderInfo.parameters["urlOverrides"];
            if(_loc1_)
            {
               this.overrideURLs(by.blooddy.crypto.serialization.JSON.decode(_loc1_));
            }
         }
         catch(e:*)
         {
         }
      }
      
      private static function makeThumbnail(param1:BitmapData) : BitmapData
      {
         var _loc2_:int = 120;
         var _loc3_:int = 90;
         var _loc4_:BitmapData = new BitmapData(_loc2_,_loc3_,true,0);
         if(param1.width == 0 || param1.height == 0)
         {
            return _loc4_;
         }
         var _loc5_:Number = Math.min(_loc2_ / param1.width,_loc3_ / param1.height);
         var _loc6_:Matrix = new Matrix();
         _loc6_.scale(_loc5_,_loc5_);
         _loc6_.translate((_loc2_ - _loc5_ * param1.width) / 2,(_loc3_ - _loc5_ * param1.height) / 2);
         _loc4_.draw(param1,_loc6_);
         return _loc4_;
      }
      
      protected function setDefaultURLs() : void
      {
      }
      
      public function overrideURLs(param1:Object) : void
      {
         var _loc2_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc3_:String = Scratch.app.loaderInfo.url;
         if(Boolean(_loc3_) && URLUtil.isHttpURL(_loc3_))
         {
            _loc2_ = URLUtil.getProtocol(_loc3_);
         }
         for(_loc4_ in param1)
         {
            if(param1.hasOwnProperty(_loc4_))
            {
               _loc5_ = param1[_loc4_];
               if(Boolean(_loc2_) && URLUtil.isHttpURL(_loc5_))
               {
                  _loc5_ = URLUtil.replaceProtocol(_loc5_,_loc2_);
               }
               this.URLs[_loc4_] = _loc5_;
            }
         }
      }
      
      protected function getCdnStaticSiteURL() : String
      {
         return this.URLs.siteCdnPrefix + this.URLs.staticFiles;
      }
      
      public function getOfficialExtensionURL(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(Scratch.app.isOffline)
         {
            _loc2_ = "static/js/scratch_extensions/";
         }
         else if(Scratch.app.isExtensionDevMode)
         {
            _loc2_ = "scratch_extensions/";
         }
         else
         {
            _loc3_ = Capabilities.isDebugger ? this.URLs.sitePrefix : this.URLs.siteCdnPrefix;
            _loc2_ = _loc3_ + this.URLs.staticFiles + "js/scratch_extensions/";
         }
         return _loc2_ + param1;
      }
      
      protected function onCallServerHttpStatus(param1:String, param2:*, param3:HTTPStatusEvent) : void
      {
         if(param3.status < 200 || param3.status > 299)
         {
            Scratch.app.logMessage(param3.toString());
         }
      }
      
      protected function onCallServerError(param1:String, param2:*, param3:ErrorEvent) : void
      {
         var _loc4_:int = 0;
         var _loc5_:String = null;
         Scratch.app.log(LogLevel.WARNING,"Failed server request",{
            "event":param3,
            "url":param1,
            "data":param2
         });
         if(param3 is SecurityErrorEvent)
         {
            _loc4_ = param1.indexOf("/",10);
            _loc5_ = param1.substr(0,_loc4_) + "/crossdomain.xml?cb=" + Math.random();
            Security.loadPolicyFile(_loc5_);
            Scratch.app.log(LogLevel.WARNING,"Reloading policy file",{
               "policy":_loc5_,
               "initiator":param1
            });
         }
      }
      
      protected function onCallServerException(param1:String, param2:*, param3:*) : void
      {
         if(param3 is Error)
         {
            Scratch.app.logException(param3);
         }
      }
      
      protected function callServer(param1:String, param2:*, param3:String, param4:Function, param5:Object = null) : URLLoader
      {
         var nextSeparator:String;
         var completeHandler:Function = null;
         var httpStatus:int = 0;
         var errorHandler:Function = null;
         var statusHandler:Function = null;
         var loader:URLLoader = null;
         var key:String = null;
         var request:URLRequest = null;
         var csrfCookie:String = null;
         var url:String = param1;
         var data:* = param2;
         var mimeType:String = param3;
         var whenDone:Function = param4;
         var queryParams:Object = param5;
         var addListeners:Function = function():void
         {
            loader.addEventListener(Event.COMPLETE,completeHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR,errorHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS,statusHandler);
         };
         var removeListeners:Function = function():void
         {
            loader.removeEventListener(Event.COMPLETE,completeHandler);
            loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,errorHandler);
            loader.removeEventListener(IOErrorEvent.IO_ERROR,errorHandler);
            loader.removeEventListener(HTTPStatusEvent.HTTP_STATUS,statusHandler);
         };
         completeHandler = function(param1:Event):void
         {
            removeListeners();
            callServerErrorInfo = null;
            whenDone(loader.data);
         };
         errorHandler = function(param1:ErrorEvent):void
         {
            removeListeners();
            onCallServerError(url,data,param1);
            callServerErrorInfo = {
               "url":url,
               "httpStatus":httpStatus,
               "errorEvent":param1
            };
            whenDone(null);
            callServerErrorInfo = null;
         };
         var exceptionHandler:Function = function(param1:*):void
         {
            removeListeners();
            onCallServerException(url,data,param1);
            whenDone(null);
         };
         statusHandler = function(param1:HTTPStatusEvent):void
         {
            httpStatus = param1.status;
            onCallServerHttpStatus(url,data,param1);
         };
         httpStatus = 0;
         loader = new URLLoader();
         loader.dataFormat = URLLoaderDataFormat.BINARY;
         addListeners();
         nextSeparator = "?";
         if(Boolean(data) && url.indexOf("?") == -1)
         {
            url += "?v=" + Scratch.versionString + "&_rnd=" + Math.random();
            nextSeparator = "&";
         }
         for(key in queryParams)
         {
            if(queryParams.hasOwnProperty(key))
            {
               url += nextSeparator + encodeURIComponent(key) + "=" + encodeURIComponent(queryParams[key]);
               nextSeparator = "&";
            }
         }
         request = new URLRequest(url);
         if(data)
         {
            request.method = URLRequestMethod.POST;
            request.data = data;
            if(mimeType)
            {
               request.requestHeaders.push(new URLRequestHeader("content-type",mimeType));
            }
            csrfCookie = this.getCSRF();
            if(Boolean(csrfCookie) && csrfCookie.length > 0)
            {
               request.requestHeaders.push(new URLRequestHeader("x-csrftoken",csrfCookie));
            }
            if(data.length == 0)
            {
               this.onCallServerError(url,data,new ErrorEvent("Refusing to POST with empty body"));
               return loader;
            }
         }
         try
         {
            loader.load(request);
         }
         catch(e:*)
         {
            exceptionHandler(e);
         }
         return loader;
      }
      
      public function getCSRF() : String
      {
         return null;
      }
      
      public function serverGet(param1:String, param2:Function) : URLLoader
      {
         return this.callServer(param1,null,null,param2);
      }
      
      public function getAsset(param1:String, param2:Function) : URLLoader
      {
         var _loc3_:String = this.URLs.assetCdnPrefix + this.URLs.internalAPI + "asset/" + param1 + "/get/";
         return this.serverGet(_loc3_,param2);
      }
      
      public function getMediaLibrary(param1:String, param2:Function) : URLLoader
      {
         var _loc3_:String = this.getCdnStaticSiteURL() + "medialibraries/" + param1 + "Library.json";
         return this.serverGet(_loc3_,param2);
      }
      
      protected function downloadThumbnail(param1:String, param2:int, param3:int, param4:Function) : URLLoader
      {
         var decodeImage:Function = null;
         var imageError:Function = null;
         var imageDecoded:Function = null;
         var url:String = param1;
         var w:int = param2;
         var h:int = param3;
         var whenDone:Function = param4;
         decodeImage = function(param1:ByteArray):void
         {
            var decoder:Loader;
            var data:ByteArray = param1;
            if(!data || data.length == 0)
            {
               return;
            }
            decoder = new Loader();
            decoder.contentLoaderInfo.addEventListener(Event.COMPLETE,imageDecoded);
            decoder.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,imageError);
            try
            {
               decoder.loadBytes(data);
            }
            catch(e:*)
            {
               if(e is Error)
               {
                  Scratch.app.logException(e);
               }
               else
               {
                  Scratch.app.logMessage("Server caught exception decoding image: " + url);
               }
            }
         };
         imageError = function(param1:IOErrorEvent):void
         {
            Scratch.app.log(LogLevel.WARNING,"ServerOnline failed to decode image",{"url":url});
         };
         imageDecoded = function(param1:Event):void
         {
            whenDone(makeThumbnail(param1.target.content.bitmapData));
         };
         return this.serverGet(url,decodeImage);
      }
      
      public function getThumbnail(param1:String, param2:int, param3:int, param4:Function) : URLLoader
      {
         var _loc5_:String = this.getCdnStaticSiteURL() + "medialibrarythumbnails/" + param1;
         return this.downloadThumbnail(_loc5_,param2,param3,param4);
      }
      
      public function getLanguageList(param1:Function) : void
      {
         this.serverGet("locale/lang_list.txt",param1);
      }
      
      public function getPOFile(param1:String, param2:Function) : void
      {
         this.serverGet("locale/" + param1 + ".po",param2);
      }
      
      public function getSelectedLang(param1:Function) : void
      {
         var _loc2_:SharedObject = SharedObject.getLocal("Scratch");
         if(_loc2_.data.lang)
         {
            param1(_loc2_.data.lang);
         }
      }
      
      public function setSelectedLang(param1:String) : void
      {
         var _loc2_:SharedObject = SharedObject.getLocal("Scratch");
         if(param1 == "")
         {
            param1 = "en";
         }
         _loc2_.data.lang = param1;
         _loc2_.flush();
      }
   }
}

