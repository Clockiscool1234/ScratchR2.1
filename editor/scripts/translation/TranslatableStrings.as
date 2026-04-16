package translation
{
   import flash.net.FileReference;
   import scratch.*;
   import soundedit.SoundEditor;
   import svgeditor.*;
   import ui.*;
   import ui.media.*;
   import ui.parts.*;
   import uiwidgets.*;
   import util.*;
   import watchers.*;
   
   public class TranslatableStrings
   {
      
      private static const exclude:Array = ["1","%n * %n","%n + %n","%n - %n","%n / %n","%s < %s","%s = %s","%s > %s"];
      
      private static const uiExtras:Array = ["Backpack"];
      
      private static const commandExtras:Array = ["define","else"];
      
      private static var strings:Array = [];
      
      public function TranslatableStrings()
      {
         super();
      }
      
      public static function exportCommands() : void
      {
         var _loc1_:Array = null;
         var _loc2_:String = null;
         strings = commandExtras.concat();
         for each(_loc1_ in Specs.commands)
         {
            if(_loc1_[2] < 90 || _loc1_[2] > 100)
            {
               _loc2_ = _loc1_[0];
               if(_loc2_.length > 0 && _loc2_.charAt(0) != "-")
               {
                  add(_loc2_,true);
               }
            }
         }
         addAll(Scratch.app.extensionManager.getExtensionSpecs(true));
         addAll(PaletteSelector.strings());
         export("commands");
      }
      
      public static function exportHelpScreenNames() : void
      {
         var _loc3_:Array = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc1_:Object = {};
         var _loc2_:Array = [];
         _loc1_["variable reporter"] = "readVariable";
         _loc1_["set variable to"] = "setVar:to:";
         _loc1_["change variable by"] = "changeVar:by:";
         _loc1_["list reporter"] = "contentsOfList:";
         _loc1_["procedure definition hat"] = "procDef";
         _loc1_["procedure call block"] = "call";
         for each(_loc3_ in Specs.commands)
         {
            if(_loc3_.length > 3 && _loc3_[2] < 90 || _loc3_[2] > 100)
            {
               _loc6_ = _loc3_[0];
               _loc7_ = _loc3_[3];
               if(_loc2_.indexOf(_loc6_) < 0)
               {
                  _loc1_[_loc6_] = _loc7_;
                  _loc2_.push(_loc6_);
               }
            }
         }
         _loc4_ = "";
         _loc2_.sort(Array.CASEINSENSITIVE);
         for each(_loc5_ in _loc2_)
         {
            _loc4_ += "\t  \'" + _loc1_[_loc5_] + "\': \'/help/studio/tips/blocks/FILENAME\',\n";
         }
         new FileReference().save(_loc4_,"helpScreens.txt");
      }
      
      public static function exportUIStrings() : void
      {
         strings = uiExtras.concat();
         Menu.stringCollectionMode = true;
         addAll(BlockMenus.strings());
         addAll(BlockPalette.strings());
         addAll(ColorPicker.strings());
         addAll(DrawPropertyUI.strings());
         addAll(ImageEdit.strings());
         addAll(ImagesPart.strings());
         addAll(LibraryPart.strings());
         addAll(ListWatcher.strings());
         addAll(MediaInfo.strings());
         addAll(MediaLibrary.strings());
         addAll(PaletteBuilder.strings());
         addAll(ProcedureSpecEditor.strings());
         addAll(ProjectIO.strings());
         addAll(Scratch.app.strings());
         addAll(ScriptsPane.strings());
         addAll(SoundEditor.strings());
         addAll(SoundsPart.strings());
         addAll(SpriteInfoPart.strings());
         addAll(SpriteThumbnail.strings());
         addAll(StagePart.strings());
         addAll(TabsPart.strings());
         addAll(TopBarPart.strings());
         addAll(VariableSettings.strings());
         addAll(Watcher.strings());
         addAll(CameraDialog.strings());
         Menu.stringCollectionMode = false;
         export("uiStrings");
      }
      
      public static function addAll(param1:Array, param2:Boolean = false) : void
      {
         var _loc3_:String = null;
         for each(_loc3_ in param1)
         {
            add(_loc3_,param2);
         }
      }
      
      public static function add(param1:String, param2:Boolean = false) : void
      {
         if(param2)
         {
            param1 = removeParentheticals(param1);
         }
         param1 = removeWhitespace(param1);
         if(param1.length < 2 || exclude.indexOf(param1) > -1)
         {
            return;
         }
         if(strings.indexOf(param1) > -1)
         {
            return;
         }
         strings.push(param1);
      }
      
      public static function has(param1:String) : Boolean
      {
         return strings.indexOf(param1) > -1;
      }
      
      private static function export(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         strings.sort(Array.CASEINSENSITIVE);
         for each(_loc3_ in strings)
         {
            _loc2_ += _loc3_ + "\n";
         }
         _loc2_ += "\n";
         new FileReference().save(_loc2_,param1 + ".txt");
         Scratch.app.translationChanged();
      }
      
      private static function removeParentheticals(param1:String) : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(true)
         {
            _loc3_ = param1.indexOf(")");
            _loc2_ = param1.indexOf("(");
            if(!(_loc2_ > -1 && _loc3_ > -1))
            {
               break;
            }
            param1 = param1.slice(0,_loc2_) + param1.slice(_loc3_ + 1);
         }
         return param1;
      }
      
      private static function removeWhitespace(param1:String) : String
      {
         if(param1.length == 0)
         {
            return "";
         }
         var _loc2_:int = 0;
         while(_loc2_ < param1.length && param1.charCodeAt(_loc2_) <= 32)
         {
            _loc2_++;
         }
         if(_loc2_ == param1.length)
         {
            return "";
         }
         var _loc3_:* = int(param1.length - 1);
         while(_loc3_ > _loc2_ && param1.charCodeAt(_loc3_) <= 32)
         {
            _loc3_--;
         }
         return param1.slice(_loc2_,_loc3_ + 1);
      }
   }
}

