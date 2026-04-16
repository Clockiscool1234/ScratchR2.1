package translation
{
   import blocks.Block;
   import flash.events.Event;
   import flash.net.*;
   import flash.utils.ByteArray;
   import flash.utils.Dictionary;
   import logging.LogLevel;
   import mx.utils.StringUtil;
   import uiwidgets.Menu;
   import util.*;
   
   public class Translator
   {
      
      public static var rightToLeft:Boolean;
      
      public static var rightToLeftMath:Boolean;
      
      public static var languages:Array = [];
      
      public static var currentLang:String = "en";
      
      private static const font12:Array = ["fa","he","ja","ja_HIRA","zh_CN","zh-cn","zh_TW","zh-tw"];
      
      private static const font13:Array = ["ar"];
      
      private static var dictionary:Object = {};
      
      public function Translator()
      {
         super();
      }
      
      public static function initializeLanguageList() : void
      {
         var saveLanguageList:Function = null;
         saveLanguageList = function(param1:String):void
         {
            var _loc3_:String = null;
            var _loc4_:Array = null;
            var _loc2_:Array = [];
            if(param1)
            {
               for each(_loc3_ in param1.split("\n"))
               {
                  _loc4_ = _loc3_.split(",");
                  if(_loc4_.length >= 2)
                  {
                     _loc2_.push([StringUtil.trim(_loc4_[0]),StringUtil.trim(_loc4_[1])]);
                  }
               }
            }
            else
            {
               _loc2_.push(["en","English"]);
            }
            languages = _loc2_;
         };
         Scratch.app.server.getLanguageList(saveLanguageList);
      }
      
      public static function setLanguageValue(param1:String) : void
      {
         var gotPOFile:Function = null;
         var lang:String = param1;
         gotPOFile = function(param1:ByteArray):void
         {
            if(param1)
            {
               dictionary = parsePOData(param1);
               setFontsFor(lang);
               checkBlockTranslations();
            }
            Scratch.app.translationChanged();
         };
         dictionary = {};
         setFontsFor("en");
         if("en" == lang)
         {
            Scratch.app.translationChanged();
         }
         else
         {
            Scratch.app.server.getPOFile(lang,gotPOFile);
         }
      }
      
      public static function setLanguage(param1:String) : void
      {
         if("import translation file" == param1)
         {
            importTranslationFromFile();
            return;
         }
         if("set font size" == param1)
         {
            fontSizeMenu();
            return;
         }
         setLanguageValue(param1);
         Scratch.app.server.setSelectedLang(param1);
      }
      
      public static function importTranslationFromFile() : void
      {
         var fileLoaded:Function = null;
         fileLoaded = function(param1:Event):void
         {
            var _loc2_:FileReference = FileReference(param1.target);
            var _loc3_:int = _loc2_.name.lastIndexOf(".");
            var _loc4_:String = _loc2_.name.slice(0,_loc3_);
            var _loc5_:ByteArray = _loc2_.data;
            if(_loc5_)
            {
               dictionary = parsePOData(_loc5_);
               setFontsFor(_loc4_);
               checkBlockTranslations();
               Scratch.app.translationChanged();
            }
         };
         Scratch.loadSingleFile(fileLoaded);
      }
      
      private static function fontSizeMenu() : void
      {
         var setFontSize:Function = null;
         setFontSize = function(param1:int):void
         {
            var _loc2_:int = Math.round(0.9 * param1);
            var _loc3_:int = param1 > 13 ? 1 : 0;
            Block.setFonts(param1,_loc2_,false,_loc3_);
            Scratch.app.translationChanged();
         };
         var m:Menu = new Menu(setFontSize);
         var i:int = 8;
         while(i < 25)
         {
            m.addItem(i.toString(),i);
            i++;
         }
         m.showOnStage(Scratch.app.stage);
      }
      
      private static function setFontsFor(param1:String) : void
      {
         currentLang = param1;
         var _loc2_:Array = ["ar","fa","he"];
         rightToLeft = _loc2_.indexOf(param1) > -1;
         rightToLeftMath = "ar" == param1;
         Block.setFonts(10,9,true,0);
         if(font12.indexOf(param1) > -1)
         {
            Block.setFonts(12,11,false,0);
         }
         if(font13.indexOf(param1) > -1)
         {
            Block.setFonts(13,12,false,0);
         }
      }
      
      public static function map(param1:String, param2:Dictionary = null) : String
      {
         var _loc3_:* = dictionary[param1];
         if(_loc3_ == null || _loc3_.length == 0)
         {
            _loc3_ = param1;
         }
         if(param2)
         {
            _loc3_ = StringUtils.substitute(_loc3_,param2);
         }
         return _loc3_;
      }
      
      private static function parsePOData(param1:ByteArray) : Object
      {
         var _loc3_:String = null;
         skipBOM(param1);
         var _loc2_:Array = [];
         while(param1.bytesAvailable > 0)
         {
            _loc3_ = StringUtil.trim(nextLine(param1));
            if(_loc3_.length > 0 && _loc3_.charAt(0) != "#")
            {
               _loc2_.push(_loc3_);
            }
         }
         return makeDictionary(_loc2_);
      }
      
      private static function skipBOM(param1:ByteArray) : void
      {
         if(param1.bytesAvailable < 3)
         {
            return;
         }
         var _loc2_:int = int(param1.readUnsignedByte());
         var _loc3_:int = int(param1.readUnsignedByte());
         var _loc4_:int = int(param1.readUnsignedByte());
         if(_loc2_ == 239 && _loc3_ == 187 && _loc4_ == 191)
         {
            return;
         }
         param1.position -= 3;
      }
      
      private static function nextLine(param1:ByteArray) : String
      {
         var _loc3_:int = 0;
         var _loc2_:ByteArray = new ByteArray();
         while(param1.bytesAvailable > 0)
         {
            _loc3_ = int(param1.readUnsignedByte());
            if(_loc3_ == 13)
            {
               if(param1.readUnsignedByte() != 10)
               {
                  --param1.position;
               }
               break;
            }
            if(_loc3_ == 10)
            {
               break;
            }
            _loc2_.writeByte(_loc3_);
         }
         _loc2_.position = 0;
         return _loc2_.readUTFBytes(_loc2_.length);
      }
      
      private static function makeDictionary(param1:Array) : Object
      {
         var _loc6_:String = null;
         var _loc2_:Object = {};
         var _loc3_:String = "none";
         var _loc4_:String = "";
         var _loc5_:String = "";
         for each(_loc6_ in param1)
         {
            if(_loc6_.length >= 5 && _loc6_.slice(0,5).toLowerCase() == "msgid")
            {
               if(_loc3_ == "val")
               {
                  _loc2_[_loc4_] = _loc5_;
               }
               _loc3_ = "key";
               _loc4_ = "";
            }
            else if(_loc6_.length >= 6 && _loc6_.slice(0,6).toLowerCase() == "msgstr")
            {
               _loc3_ = "val";
               _loc5_ = "";
            }
            if(_loc3_ == "key")
            {
               _loc4_ += extractQuotedString(_loc6_);
            }
            if(_loc3_ == "val")
            {
               _loc5_ += extractQuotedString(_loc6_);
            }
         }
         if(_loc3_ == "val")
         {
            _loc2_[_loc4_] = _loc5_;
         }
         delete _loc2_[""];
         return _loc2_;
      }
      
      private static function extractQuotedString(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc2_:int = param1.indexOf("\"");
         if(_loc2_ < 0)
         {
            _loc2_ = param1.indexOf(" ");
         }
         var _loc3_:String = "";
         _loc2_ += 1;
         while(_loc2_ < param1.length)
         {
            _loc4_ = param1.charAt(_loc2_);
            if(_loc4_ == "\\" && _loc2_ < param1.length - 1)
            {
               _loc4_ = param1.charAt(++_loc2_);
               if(_loc4_ == "n")
               {
                  _loc4_ = "\n";
               }
               if(_loc4_ == "r")
               {
                  _loc4_ = "\r";
               }
               if(_loc4_ == "t")
               {
                  _loc4_ = "\t";
               }
            }
            if(_loc4_ == "\"")
            {
               return _loc3_;
            }
            _loc3_ += _loc4_;
            _loc2_++;
         }
         return _loc3_;
      }
      
      private static function checkBlockTranslations() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         for each(_loc1_ in Specs.commands)
         {
            checkBlockSpec(_loc1_[0]);
         }
         for each(_loc2_ in Scratch.app.extensionManager.getExtensionSpecs(false))
         {
            checkBlockSpec(_loc2_);
         }
      }
      
      private static function checkBlockSpec(param1:String) : void
      {
         var _loc2_:String = map(param1);
         if(_loc2_ == param1)
         {
            return;
         }
         if(!argsMatch(extractArgs(param1),extractArgs(_loc2_)))
         {
            Scratch.app.log(LogLevel.WARNING,"Block argument mismatch",{
               "language":currentLang,
               "spec":param1,
               "translated":_loc2_
            });
            delete dictionary[param1];
         }
      }
      
      private static function argsMatch(param1:Array, param2:Array) : Boolean
      {
         if(param1.length != param2.length)
         {
            return false;
         }
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            if(param1[_loc3_] != param2[_loc3_])
            {
               return false;
            }
            _loc3_++;
         }
         return true;
      }
      
      private static function extractArgs(param1:String) : Array
      {
         var _loc4_:String = null;
         var _loc2_:Array = [];
         var _loc3_:Array = ReadStream.tokenize(param1);
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.length > 1 && (_loc4_.charAt(0) == "%" || _loc4_.charAt(0) == "@"))
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
   }
}

