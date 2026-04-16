package scratch
{
   import blocks.*;
   import extensions.ExtensionManager;
   import filters.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.ui.*;
   import sound.*;
   import translation.Translator;
   import ui.ProcedureSpecEditor;
   import uiwidgets.*;
   import util.*;
   
   public class BlockMenus implements DragClient
   {
      
      private static const basicMathOps:Array = ["+","-","*","/"];
      
      private static const comparisonOps:Array = ["<","=",">"];
      
      private static const spriteAttributes:Array = ["x position","y position","direction","costume #","costume name","size","volume"];
      
      private static const stageAttributes:Array = ["backdrop #","backdrop name","volume"];
      
      private var app:Scratch;
      
      private var startX:Number;
      
      private var startY:Number;
      
      private var block:Block;
      
      private var blockArg:BlockArg;
      
      private var pickingColor:Boolean = false;
      
      private var colorPickerSprite:Sprite;
      
      private var onePixel:BitmapData = new BitmapData(1,1);
      
      public function BlockMenus(param1:Block, param2:BlockArg)
      {
         super();
         this.app = Scratch.app;
         this.startX = this.app.mouseX;
         this.startY = this.app.mouseY;
         this.blockArg = param2;
         this.block = param1;
      }
      
      public static function BlockMenuHandler(param1:MouseEvent, param2:Block, param3:BlockArg = null, param4:String = null) : void
      {
         var _loc5_:BlockMenus = new BlockMenus(param2,param3);
         var _loc6_:String = param2.op;
         if(param4 == null)
         {
            if(_loc6_ == Specs.GET_LIST)
            {
               param4 = "list";
            }
            if(_loc6_ == Specs.GET_VAR)
            {
               param4 = "var";
            }
            if(_loc6_ == Specs.PROCEDURE_DEF || _loc6_ == Specs.CALL)
            {
               param4 = "procMenu";
            }
            if(_loc6_ == "broadcast:" || _loc6_ == "doBroadcastAndWait" || _loc6_ == "whenIReceive")
            {
               param4 = "broadcastInfoMenu";
            }
            if(basicMathOps.indexOf(_loc6_) > -1)
            {
               _loc5_.changeOpMenu(param1,basicMathOps);
               return;
            }
            if(comparisonOps.indexOf(_loc6_) > -1)
            {
               _loc5_.changeOpMenu(param1,comparisonOps);
               return;
            }
            if(param4 == null)
            {
               _loc5_.genericBlockMenu(param1);
               return;
            }
         }
         if(ExtensionManager.hasExtensionPrefix(_loc6_) && _loc5_.extensionMenu(param1,param4))
         {
            return;
         }
         if(param4 == "attribute")
         {
            _loc5_.attributeMenu(param1);
         }
         if(param4 == "backdrop")
         {
            _loc5_.backdropMenu(param1);
         }
         if(param4 == "booleanSensor")
         {
            _loc5_.booleanSensorMenu(param1);
         }
         if(param4 == "broadcast")
         {
            _loc5_.broadcastMenu(param1);
         }
         if(param4 == "broadcastInfoMenu")
         {
            _loc5_.broadcastInfoMenu(param1);
         }
         if(param4 == "colorPicker")
         {
            _loc5_.colorPicker(param1);
         }
         if(param4 == "costume")
         {
            _loc5_.costumeMenu(param1);
         }
         if(param4 == "direction")
         {
            _loc5_.dirMenu(param1);
         }
         if(param4 == "drum")
         {
            _loc5_.drumMenu(param1);
         }
         if(param4 == "effect")
         {
            _loc5_.effectMenu(param1);
         }
         if(param4 == "instrument")
         {
            _loc5_.instrumentMenu(param1);
         }
         if(param4 == "key")
         {
            _loc5_.keyMenu(param1);
         }
         if(param4 == "list")
         {
            _loc5_.listMenu(param1);
         }
         if(param4 == "listDeleteItem")
         {
            _loc5_.listItem(param1,true);
         }
         if(param4 == "listItem")
         {
            _loc5_.listItem(param1,false);
         }
         if(param4 == "mathOp")
         {
            _loc5_.mathOpMenu(param1);
         }
         if(param4 == "motorDirection")
         {
            _loc5_.motorDirectionMenu(param1);
         }
         if(param4 == "note")
         {
            _loc5_.notePicker(param1);
         }
         if(param4 == "procMenu")
         {
            _loc5_.procMenu(param1);
         }
         if(param4 == "rotationStyle")
         {
            _loc5_.rotationStyleMenu(param1);
         }
         if(param4 == "scrollAlign")
         {
            _loc5_.scrollAlignMenu(param1);
         }
         if(param4 == "sensor")
         {
            _loc5_.sensorMenu(param1);
         }
         if(param4 == "sound")
         {
            _loc5_.soundMenu(param1);
         }
         if(param4 == "spriteOnly")
         {
            _loc5_.spriteMenu(param1,false,false,false,true,false);
         }
         if(param4 == "spriteOrMouse")
         {
            _loc5_.spriteMenu(param1,true,false,false,false,false);
         }
         if(param4 == "location")
         {
            _loc5_.spriteMenu(param1,true,false,false,false,true);
         }
         if(param4 == "spriteOrStage")
         {
            _loc5_.spriteMenu(param1,false,false,true,false,false);
         }
         if(param4 == "touching")
         {
            _loc5_.spriteMenu(param1,true,true,false,false,false);
         }
         if(param4 == "stageOrThis")
         {
            _loc5_.stageOrThisSpriteMenu(param1);
         }
         if(param4 == "stop")
         {
            _loc5_.stopMenu(param1);
         }
         if(param4 == "timeAndDate")
         {
            _loc5_.timeAndDateMenu(param1);
         }
         if(param4 == "triggerSensor")
         {
            _loc5_.triggerSensorMenu(param1);
         }
         if(param4 == "var")
         {
            _loc5_.varMenu(param1);
         }
         if(param4 == "videoMotionType")
         {
            _loc5_.videoMotionTypeMenu(param1);
         }
         if(param4 == "videoState")
         {
            _loc5_.videoStateMenu(param1);
         }
      }
      
      public static function strings() : Array
      {
         var _loc3_:MouseEvent = null;
         var _loc1_:Array = [new MouseEvent("dummy"),new MouseEvent("shift-dummy")];
         _loc1_[1].shiftKey = true;
         var _loc2_:BlockMenus = new BlockMenus(new Block("dummy"),null);
         for each(_loc3_ in _loc1_)
         {
            _loc2_.attributeMenu(_loc3_);
            _loc2_.backdropMenu(_loc3_);
            _loc2_.booleanSensorMenu(_loc3_);
            _loc2_.broadcastMenu(_loc3_);
            _loc2_.broadcastInfoMenu(_loc3_);
            _loc2_.costumeMenu(_loc3_);
            _loc2_.dirMenu(_loc3_);
            _loc2_.drumMenu(_loc3_);
            _loc2_.effectMenu(_loc3_);
            _loc2_.genericBlockMenu(_loc3_);
            _loc2_.instrumentMenu(_loc3_);
            _loc2_.listMenu(_loc3_);
            _loc2_.listItem(_loc3_,true);
            _loc2_.listItem(_loc3_,false);
            _loc2_.mathOpMenu(_loc3_);
            _loc2_.motorDirectionMenu(_loc3_);
            _loc2_.procMenu(_loc3_);
            _loc2_.rotationStyleMenu(_loc3_);
            _loc2_.sensorMenu(_loc3_);
            _loc2_.soundMenu(_loc3_);
            _loc2_.spriteMenu(_loc3_,false,false,false,true,false);
            _loc2_.spriteMenu(_loc3_,true,false,false,false,false);
            _loc2_.spriteMenu(_loc3_,true,false,false,false,true);
            _loc2_.spriteMenu(_loc3_,false,false,true,false,false);
            _loc2_.spriteMenu(_loc3_,true,true,false,false,false);
            _loc2_.stageOrThisSpriteMenu(_loc3_);
            _loc2_.stopMenu(_loc3_);
            _loc2_.timeAndDateMenu(_loc3_);
            _loc2_.triggerSensorMenu(_loc3_);
            _loc2_.varMenu(_loc3_);
            _loc2_.videoMotionTypeMenu(_loc3_);
            _loc2_.videoStateMenu(_loc3_);
         }
         return ["up arrow","down arrow","right arrow","left arrow","space","any","other scripts in sprite","other scripts in stage","backdrop #","backdrop name","volume","OK","Cancel","Edit Block","Rename","New name","Delete","Broadcast","New Message","Message Name","delete variable","rename variable","video motion","video direction","Low C","Middle C","High C"];
      }
      
      public static function shouldTranslateItemForMenu(param1:String, param2:String) : Boolean
      {
         var item:String = param1;
         var menuName:String = param2;
         var isGeneric:Function = function(param1:String):Boolean
         {
            return ["duplicate","delete","add comment","clean up"].indexOf(param1) > -1;
         };
         switch(menuName)
         {
            case "attribute":
               return spriteAttributes.indexOf(item) > -1 || stageAttributes.indexOf(item) > -1;
            case "backdrop":
               return ["next backdrop","previous backdrop"].indexOf(item) > -1;
            case "broadcast":
               return ["new message..."].indexOf(item) > -1;
            case "costume":
               return false;
            case "list":
               if(isGeneric(item))
               {
                  return true;
               }
               return ["delete list"].indexOf(item) > -1;
               break;
            case "sound":
               return ["record..."].indexOf(item) > -1;
            case "sprite":
            case "spriteOnly":
            case "spriteOrMouse":
            case "location":
            case "spriteOrStage":
            case "touching":
               return false;
            case "var":
               if(isGeneric(item))
               {
                  return true;
               }
               return ["delete variable","rename variable"].indexOf(item) > -1;
               break;
            default:
               return true;
         }
      }
      
      private function showMenu(param1:Menu) : void
      {
         var _loc2_:Point = null;
         param1.color = this.block.base.color;
         param1.itemHeight = 22;
         if(this.blockArg)
         {
            _loc2_ = this.blockArg.localToGlobal(new Point(0,this.blockArg.height));
            param1.showOnStage(this.app.stage,_loc2_.x - 9,_loc2_.y);
         }
         else
         {
            param1.showOnStage(this.app.stage);
         }
      }
      
      private function setBlockArg(param1:*) : void
      {
         if(this.blockArg != null)
         {
            this.blockArg.setArgValue(param1);
         }
         Scratch.app.setSaveNeeded();
         Scratch.app.runtime.checkForGraphicEffects();
      }
      
      private function attributeMenu(param1:MouseEvent) : void
      {
         var _loc5_:String = null;
         var _loc6_:BlockArg = null;
         var _loc2_:* = this.app.stagePane;
         if(this.block)
         {
            _loc6_ = this.block.getNormalizedArg(1) as BlockArg;
            if(_loc6_)
            {
               _loc2_ = this.app.stagePane.objNamed(_loc6_.argValue);
            }
         }
         var _loc3_:Array = _loc2_ is ScratchStage ? stageAttributes : spriteAttributes;
         var _loc4_:Menu = new Menu(this.setBlockArg,"attribute");
         for each(_loc5_ in _loc3_)
         {
            _loc4_.addItem(_loc5_);
         }
         if(_loc2_ is ScratchObj)
         {
            _loc4_.addLine();
            for each(_loc5_ in _loc2_.varNames().sort())
            {
               _loc4_.addItem(_loc5_);
            }
         }
         this.showMenu(_loc4_);
      }
      
      private function backdropMenu(param1:MouseEvent) : void
      {
         var _loc3_:ScratchCostume = null;
         var _loc2_:Menu = new Menu(this.setBlockArg,"backdrop");
         for each(_loc3_ in this.app.stageObj().costumes)
         {
            _loc2_.addItem(_loc3_.costumeName);
         }
         if(Boolean(this.block) && Boolean(this.block.op.indexOf("startScene") > -1) || Menu.stringCollectionMode)
         {
            _loc2_.addLine();
            _loc2_.addItem("next backdrop");
            _loc2_.addItem("previous backdrop");
         }
         this.showMenu(_loc2_);
      }
      
      private function booleanSensorMenu(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:Array = ["button pressed","A connected","B connected","C connected","D connected"];
         var _loc3_:Menu = new Menu(this.setBlockArg,"booleanSensor");
         for each(_loc4_ in _loc2_)
         {
            _loc3_.addItem(_loc4_);
         }
         this.showMenu(_loc3_);
      }
      
      private function colorPicker(param1:MouseEvent) : void
      {
         this.app.gh.setDragClient(this,param1);
      }
      
      private function costumeMenu(param1:MouseEvent) : void
      {
         var _loc3_:ScratchCostume = null;
         var _loc2_:Menu = new Menu(this.setBlockArg,"costume");
         if(this.app.viewedObj() == null)
         {
            return;
         }
         for each(_loc3_ in this.app.viewedObj().costumes)
         {
            _loc2_.addItem(_loc3_.costumeName);
         }
         this.showMenu(_loc2_);
      }
      
      private function dirMenu(param1:MouseEvent) : void
      {
         var _loc2_:Menu = new Menu(this.setBlockArg,"direction");
         _loc2_.addItem("(90) " + Translator.map("right"),90);
         _loc2_.addItem("(-90) " + Translator.map("left"),-90);
         _loc2_.addItem("(0) " + Translator.map("up"),0);
         _loc2_.addItem("(180) " + Translator.map("down"),180);
         this.showMenu(_loc2_);
      }
      
      private function drumMenu(param1:MouseEvent) : void
      {
         var _loc2_:Menu = new Menu(this.setBlockArg,"drum");
         var _loc3_:int = 1;
         while(_loc3_ <= SoundBank.drumNames.length)
         {
            _loc2_.addItem("(" + _loc3_ + ") " + Translator.map(SoundBank.drumNames[_loc3_ - 1]),_loc3_);
            _loc3_++;
         }
         this.showMenu(_loc2_);
      }
      
      private function effectMenu(param1:MouseEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:Menu = new Menu(this.setBlockArg,"effect");
         if(this.app.viewedObj() == null)
         {
            return;
         }
         for each(_loc3_ in FilterPack.filterNames)
         {
            _loc2_.addItem(_loc3_);
         }
         this.showMenu(_loc2_);
      }
      
      private function extensionMenu(param1:MouseEvent, param2:String) : Boolean
      {
         var _loc5_:String = null;
         var _loc3_:Array = this.app.extensionManager.menuItemsFor(this.block.op,param2);
         if(!_loc3_)
         {
            return false;
         }
         var _loc4_:Menu = new Menu(this.setBlockArg);
         for each(_loc5_ in _loc3_)
         {
            _loc4_.addItem(_loc5_);
         }
         this.showMenu(_loc4_);
         return true;
      }
      
      private function instrumentMenu(param1:MouseEvent) : void
      {
         var _loc2_:Menu = new Menu(this.setBlockArg,"instrument");
         var _loc3_:int = 1;
         while(_loc3_ <= SoundBank.instrumentNames.length)
         {
            _loc2_.addItem("(" + _loc3_ + ") " + Translator.map(SoundBank.instrumentNames[_loc3_ - 1]),_loc3_);
            _loc3_++;
         }
         this.showMenu(_loc2_);
      }
      
      private function keyMenu(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         var _loc5_:String = null;
         var _loc3_:Array = ["space","up arrow","down arrow","right arrow","left arrow","any"];
         var _loc4_:Menu = new Menu(this.setBlockArg,"key");
         for each(_loc5_ in _loc3_)
         {
            _loc4_.addItem(_loc5_);
         }
         _loc2_ = 97;
         while(_loc2_ < 123)
         {
            _loc4_.addItem(String.fromCharCode(_loc2_));
            _loc2_++;
         }
         _loc2_ = 48;
         while(_loc2_ < 58)
         {
            _loc4_.addItem(String.fromCharCode(_loc2_));
            _loc2_++;
         }
         this.showMenu(_loc4_);
      }
      
      private function listItem(param1:MouseEvent, param2:Boolean) : void
      {
         var _loc3_:Menu = new Menu(this.setBlockArg,"listItem");
         _loc3_.addItem("1");
         _loc3_.addItem("last");
         if(param2)
         {
            _loc3_.addLine();
            _loc3_.addItem("all");
         }
         else
         {
            _loc3_.addItem("random");
         }
         this.showMenu(_loc3_);
      }
      
      private function mathOpMenu(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:Array = ["abs","floor","ceiling","sqrt","sin","cos","tan","asin","acos","atan","ln","log","e ^","10 ^"];
         var _loc3_:Menu = new Menu(this.setBlockArg,"mathOp");
         for each(_loc4_ in _loc2_)
         {
            _loc3_.addItem(_loc4_);
         }
         this.showMenu(_loc3_);
      }
      
      private function motorDirectionMenu(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:Array = ["this way","that way","reverse"];
         var _loc3_:Menu = new Menu(this.setBlockArg,"motorDirection");
         for each(_loc4_ in _loc2_)
         {
            _loc3_.addItem(_loc4_);
         }
         this.showMenu(_loc3_);
      }
      
      private function notePicker(param1:MouseEvent) : void
      {
         var p:Point;
         var pianoCallback:Function = null;
         var evt:MouseEvent = param1;
         pianoCallback = function(param1:int):void
         {
            setBlockArg(param1);
            block.demo();
         };
         var piano:Piano = new Piano(this.block.base.color,this.app.viewedObj().instrument,pianoCallback);
         if(!isNaN(this.blockArg.argValue))
         {
            piano.selectNote(int(this.blockArg.argValue));
         }
         p = this.blockArg.localToGlobal(new Point(this.blockArg.width,this.blockArg.height));
         piano.showOnStage(this.app.stage,int(p.x - piano.width / 2),p.y);
      }
      
      private function rotationStyleMenu(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:Array = ["left-right","don\'t rotate","all around"];
         var _loc3_:Menu = new Menu(this.setBlockArg,"rotationStyle");
         for each(_loc4_ in _loc2_)
         {
            _loc3_.addItem(_loc4_);
         }
         this.showMenu(_loc3_);
      }
      
      private function scrollAlignMenu(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:Array = ["bottom-left","bottom-right","middle","top-left","top-right"];
         var _loc3_:Menu = new Menu(this.setBlockArg,"scrollAlign");
         for each(_loc4_ in _loc2_)
         {
            _loc3_.addItem(_loc4_);
         }
         this.showMenu(_loc3_);
      }
      
      private function sensorMenu(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc2_:Array = ["slider","light","sound","resistance-A","resistance-B","resistance-B","resistance-C","resistance-D"];
         var _loc3_:Menu = new Menu(this.setBlockArg,"sensor");
         for each(_loc4_ in _loc2_)
         {
            _loc3_.addItem(_loc4_);
         }
         this.showMenu(_loc3_);
      }
      
      private function soundMenu(param1:MouseEvent) : void
      {
         var i:int;
         var setSoundArg:Function = null;
         var evt:MouseEvent = param1;
         setSoundArg = function(param1:*):void
         {
            if(param1 is Function)
            {
               param1();
            }
            else
            {
               setBlockArg(param1);
            }
         };
         var m:Menu = new Menu(setSoundArg,"sound");
         if(this.app.viewedObj() == null)
         {
            return;
         }
         i = 0;
         while(i < this.app.viewedObj().sounds.length)
         {
            m.addItem(this.app.viewedObj().sounds[i].soundName);
            i++;
         }
         m.addLine();
         m.addItem("record...",this.recordSound);
         this.showMenu(m);
      }
      
      private function recordSound() : void
      {
         this.app.setTab("sounds");
         this.app.soundsPart.recordSound();
      }
      
      private function spriteMenu(param1:MouseEvent, param2:Boolean, param3:Boolean, param4:Boolean, param5:Boolean, param6:Boolean) : void
      {
         var setSpriteArg:Function = null;
         var sprite:ScratchSprite = null;
         var spriteName:String = null;
         var evt:MouseEvent = param1;
         var includeMouse:Boolean = param2;
         var includeEdge:Boolean = param3;
         var includeStage:Boolean = param4;
         var includeSelf:Boolean = param5;
         var includeRandom:Boolean = param6;
         setSpriteArg = function(param1:*):void
         {
            var _loc2_:ScratchObj = null;
            var _loc3_:BlockArg = null;
            var _loc4_:String = null;
            var _loc5_:Array = null;
            if(blockArg == null)
            {
               return;
            }
            if(param1 == "edge")
            {
               blockArg.setArgValue("_edge_",Translator.map("edge"));
            }
            else if(param1 == "mouse-pointer")
            {
               blockArg.setArgValue("_mouse_",Translator.map("mouse-pointer"));
            }
            else if(param1 == "myself")
            {
               blockArg.setArgValue("_myself_",Translator.map("myself"));
            }
            else if(param1 == "Stage")
            {
               blockArg.setArgValue("_stage_",Translator.map("Stage"));
            }
            else if(param1 == "random position")
            {
               blockArg.setArgValue("_random_",Translator.map("random position"));
            }
            else
            {
               blockArg.setArgValue(param1);
            }
            if(block.op == "getAttribute:of:")
            {
               _loc2_ = app.stagePane.objNamed(param1);
               _loc3_ = block.getNormalizedArg(0);
               _loc4_ = _loc3_.argValue;
               _loc5_ = Boolean(_loc2_) && _loc2_.isStage ? stageAttributes : spriteAttributes;
               if(_loc5_.indexOf(_loc4_) == -1 && !_loc2_.ownsVar(_loc4_))
               {
                  _loc3_.setArgValue(_loc5_[0]);
               }
            }
            Scratch.app.setSaveNeeded();
         };
         var spriteNames:Array = [];
         var m:Menu = new Menu(setSpriteArg,"sprite");
         if(includeMouse)
         {
            m.addItem(Translator.map("mouse-pointer"),"mouse-pointer");
         }
         if(includeRandom)
         {
            m.addItem(Translator.map("random position"),"random position");
         }
         if(includeEdge)
         {
            m.addItem(Translator.map("edge"),"edge");
         }
         m.addLine();
         if(includeStage)
         {
            m.addItem(Translator.map("Stage"),"Stage");
            m.addLine();
         }
         if(includeSelf && !this.app.viewedObj().isStage)
         {
            m.addItem(Translator.map("myself"),"myself");
            m.addLine();
            spriteNames.push(this.app.viewedObj().objName);
         }
         for each(sprite in this.app.stagePane.sprites())
         {
            if(sprite != this.app.viewedObj())
            {
               spriteNames.push(sprite.objName);
            }
         }
         spriteNames.sort(Array.CASEINSENSITIVE);
         for each(spriteName in spriteNames)
         {
            m.addItem(spriteName);
         }
         this.showMenu(m);
      }
      
      private function stopMenu(param1:MouseEvent) : void
      {
         var setStopType:Function = null;
         var evt:MouseEvent = param1;
         setStopType = function(param1:*):void
         {
            blockArg.setArgValue(param1);
            block.setTerminal(param1 == "all" || param1 == "this script");
            block.type = block.isTerminal ? "f" : " ";
            Scratch.app.setSaveNeeded();
         };
         var m:Menu = new Menu(setStopType,"stop");
         if(!this.block.nextBlock)
         {
            m.addItem("all");
            m.addItem("this script");
         }
         m.addItem(this.app.viewedObj().isStage ? "other scripts in stage" : "other scripts in sprite");
         this.showMenu(m);
      }
      
      private function stageOrThisSpriteMenu(param1:MouseEvent) : void
      {
         var _loc2_:Menu = new Menu(this.setBlockArg,"stageOrThis");
         _loc2_.addItem(this.app.stagePane.objName);
         if(!this.app.viewedObj().isStage)
         {
            _loc2_.addItem("this sprite");
         }
         this.showMenu(_loc2_);
      }
      
      private function timeAndDateMenu(param1:MouseEvent) : void
      {
         var _loc2_:Menu = new Menu(this.setBlockArg,"timeAndDate");
         _loc2_.addItem("year");
         _loc2_.addItem("month");
         _loc2_.addItem("date");
         _loc2_.addItem("day of week");
         _loc2_.addItem("hour");
         _loc2_.addItem("minute");
         _loc2_.addItem("second");
         this.showMenu(_loc2_);
      }
      
      private function triggerSensorMenu(param1:MouseEvent) : void
      {
         var setTriggerType:Function = null;
         var evt:MouseEvent = param1;
         setTriggerType = function(param1:String):void
         {
            if("video motion" == param1)
            {
               app.libraryPart.showVideoButton();
            }
            setBlockArg(param1);
         };
         var m:Menu = new Menu(setTriggerType,"triggerSensor");
         m.addItem("loudness");
         m.addItem("timer");
         m.addItem("video motion");
         this.showMenu(m);
      }
      
      private function videoMotionTypeMenu(param1:MouseEvent) : void
      {
         var _loc2_:Menu = new Menu(this.setBlockArg,"videoMotion");
         _loc2_.addItem("motion");
         _loc2_.addItem("direction");
         this.showMenu(_loc2_);
      }
      
      private function videoStateMenu(param1:MouseEvent) : void
      {
         var _loc2_:Menu = new Menu(this.setBlockArg,"videoState");
         _loc2_.addItem("off");
         _loc2_.addItem("on");
         _loc2_.addItem("on-flipped");
         this.showMenu(_loc2_);
      }
      
      private function genericBlockMenu(param1:MouseEvent) : void
      {
         if(!this.block || this.block.isEmbeddedParameter())
         {
            return;
         }
         var _loc2_:Menu = new Menu(null,"genericBlock");
         this.addGenericBlockItems(_loc2_);
         this.showMenu(_loc2_);
      }
      
      private function addGenericBlockItems(param1:Menu) : void
      {
         if(!this.block)
         {
            return;
         }
         param1.addLine();
         if(!this.isInPalette(this.block))
         {
            if(!this.block.isProcDef())
            {
               param1.addItem("duplicate",this.duplicateStack);
            }
            param1.addItem("delete",this.block.deleteStack);
            param1.addLine();
            param1.addItem("add comment",this.block.addComment);
         }
         param1.addItem("help",this.block.showHelp);
         param1.addLine();
      }
      
      private function duplicateStack() : void
      {
         this.block.duplicateStack(this.app.mouseX - this.startX,this.app.mouseY - this.startY);
      }
      
      private function changeOpMenu(param1:MouseEvent, param2:Array) : void
      {
         var m:Menu;
         var opMenu:Function = null;
         var op:String = null;
         var evt:MouseEvent = param1;
         var opList:Array = param2;
         opMenu = function(param1:*):void
         {
            if(param1 is Function)
            {
               param1();
               return;
            }
            block.changeOperator(param1);
         };
         if(!this.block)
         {
            return;
         }
         m = new Menu(opMenu,"changeOp");
         this.addGenericBlockItems(m);
         if(!this.isInPalette(this.block))
         {
            for each(op in opList)
            {
               m.addItem(op);
            }
         }
         this.showMenu(m);
      }
      
      private function procMenu(param1:MouseEvent) : void
      {
         var _loc2_:Menu = new Menu(null,"proc");
         this.addGenericBlockItems(_loc2_);
         _loc2_.addItem("edit",this.editProcSpec);
         if(this.block.op == Specs.CALL)
         {
            _loc2_.addItem("define",this.jumpToProcDef);
         }
         this.showMenu(_loc2_);
      }
      
      private function jumpToProcDef() : void
      {
         var _loc2_:ScriptsPane = null;
         if(!this.app.editMode)
         {
            return;
         }
         if(this.block.op != Specs.CALL)
         {
            return;
         }
         var _loc1_:Block = this.app.viewedObj().lookupProcedure(this.block.spec);
         if(!_loc1_)
         {
            return;
         }
         _loc2_ = _loc1_.parent as ScriptsPane;
         if(!_loc2_)
         {
            return;
         }
         if(_loc2_.parent is ScrollFrame)
         {
            _loc2_.x = 5 - _loc1_.x * _loc2_.scaleX;
            _loc2_.y = 5 - _loc1_.y * _loc2_.scaleX;
            (_loc2_.parent as ScrollFrame).constrainScroll();
            (_loc2_.parent as ScrollFrame).updateScrollbars();
         }
      }
      
      private function editProcSpec() : void
      {
         var _loc2_:Block = null;
         if(this.block.op == Specs.CALL)
         {
            _loc2_ = this.app.viewedObj().lookupProcedure(this.block.spec);
            if(!_loc2_)
            {
               return;
            }
            this.block = _loc2_;
         }
         var _loc1_:DialogBox = new DialogBox(this.editSpec2);
         _loc1_.addTitle("Edit Block");
         _loc1_.addWidget(new ProcedureSpecEditor(this.block.spec,this.block.parameterNames,this.block.warpProcFlag));
         _loc1_.addAcceptCancelButtons("OK");
         _loc1_.showOnStage(this.app.stage,true);
         ProcedureSpecEditor(_loc1_.widget).setInitialFocus();
      }
      
      private function editSpec2(param1:DialogBox) : void
      {
         var oldSpec:String = null;
         var caller:Block = null;
         var oldArgs:Array = null;
         var i:int = 0;
         var arg:* = undefined;
         var dialog:DialogBox = param1;
         var newSpec:String = ProcedureSpecEditor(dialog.widget).spec();
         if(newSpec.length == 0)
         {
            return;
         }
         if(this.block != null)
         {
            oldSpec = this.block.spec;
            this.block.parameterNames = ProcedureSpecEditor(dialog.widget).inputNames();
            this.block.defaultArgValues = ProcedureSpecEditor(dialog.widget).defaultArgValues();
            this.block.warpProcFlag = ProcedureSpecEditor(dialog.widget).warpFlag();
            this.block.setSpec(newSpec);
            if(this.block.nextBlock)
            {
               this.block.nextBlock.allBlocksDo(function(param1:Block):void
               {
                  if(param1.op == Specs.GET_PARAM)
                  {
                     param1.parameterIndex = -1;
                  }
               });
            }
            for each(caller in this.app.runtime.allCallsOf(oldSpec,this.app.viewedObj()))
            {
               oldArgs = caller.args;
               caller.setSpec(newSpec,this.block.defaultArgValues);
               i = 0;
               while(i < oldArgs.length)
               {
                  arg = oldArgs[i];
                  if(arg is BlockArg)
                  {
                     arg = arg.argValue;
                  }
                  caller.setArg(i,arg);
                  i++;
               }
               caller.fixArgLayout();
            }
         }
         this.app.runtime.updateCalls();
         this.app.scriptsPane.fixCommentLayout();
         this.app.updatePalette();
      }
      
      private function listMenu(param1:MouseEvent) : void
      {
         var _loc5_:String = null;
         var _loc2_:Menu = new Menu(this.varOrListSelection,"list");
         var _loc3_:Boolean = this.block.op == Specs.GET_LIST;
         if(_loc3_)
         {
            if(this.isInPalette(this.block))
            {
               _loc2_.addItem("delete list",this.deleteVarOrList);
            }
            this.addGenericBlockItems(_loc2_);
            _loc2_.addLine();
         }
         var _loc4_:String = _loc3_ ? this.blockVarOrListName() : null;
         for each(_loc5_ in this.app.stageObj().listNames())
         {
            if(_loc5_ != _loc4_)
            {
               _loc2_.addItem(_loc5_);
            }
         }
         if(!this.app.viewedObj().isStage)
         {
            _loc2_.addLine();
            for each(_loc5_ in this.app.viewedObj().listNames())
            {
               if(_loc5_ != _loc4_)
               {
                  _loc2_.addItem(_loc5_);
               }
            }
         }
         this.showMenu(_loc2_);
      }
      
      private function varMenu(param1:MouseEvent) : void
      {
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc2_:Menu = new Menu(this.varOrListSelection,"var");
         var _loc3_:Boolean = this.block.op == Specs.GET_VAR;
         if(_loc3_ && this.isInPalette(this.block))
         {
            _loc2_.addItem("rename variable",this.renameVar);
            _loc2_.addItem("delete variable",this.deleteVarOrList);
            this.addGenericBlockItems(_loc2_);
         }
         else
         {
            if(_loc3_)
            {
               this.addGenericBlockItems(_loc2_);
            }
            _loc4_ = this.blockVarOrListName();
            for each(_loc5_ in this.app.stageObj().varNames())
            {
               if(!_loc3_ || _loc5_ != _loc4_)
               {
                  _loc2_.addItem(_loc5_);
               }
            }
            if(!this.app.viewedObj().isStage)
            {
               _loc2_.addLine();
               for each(_loc5_ in this.app.viewedObj().varNames())
               {
                  if(!_loc3_ || _loc5_ != _loc4_)
                  {
                     _loc2_.addItem(_loc5_);
                  }
               }
            }
         }
         this.showMenu(_loc2_);
      }
      
      private function isInPalette(param1:Block) : Boolean
      {
         var _loc2_:DisplayObject = param1;
         while(_loc2_ != null)
         {
            if(_loc2_ == this.app.palette)
            {
               return true;
            }
            _loc2_ = _loc2_.parent;
         }
         return false;
      }
      
      private function varOrListSelection(param1:*) : void
      {
         if(param1 is Function)
         {
            param1();
            return;
         }
         this.setBlockVarOrListName(param1);
      }
      
      private function renameVar() : void
      {
         var oldName:String = null;
         var doVarRename:Function = null;
         doVarRename = function(param1:DialogBox):void
         {
            var _loc2_:String = param1.getField("New name").replace(/^\s+|\s+$/g,"");
            if(_loc2_.length == 0 || block.op != Specs.GET_VAR)
            {
               return;
            }
            if(oldName.charAt(0) == "☁")
            {
               _loc2_ = "☁ " + _loc2_;
            }
            app.runtime.renameVariable(oldName,_loc2_);
         };
         oldName = this.blockVarOrListName();
         var d:DialogBox = new DialogBox(doVarRename);
         d.addTitle(Translator.map("Rename") + " " + this.blockVarOrListName());
         d.addField("New name",120,oldName);
         d.addAcceptCancelButtons("OK");
         d.showOnStage(this.app.stage);
      }
      
      private function deleteVarOrList() : void
      {
         var doDelete:Function = null;
         doDelete = function(param1:*):void
         {
            if(block.op == Specs.GET_VAR)
            {
               app.runtime.deleteVariable(blockVarOrListName());
            }
            else
            {
               app.runtime.deleteList(blockVarOrListName());
            }
            app.updatePalette();
            app.setSaveNeeded();
         };
         DialogBox.confirm(Translator.map("Delete") + " " + this.blockVarOrListName() + "?",this.app.stage,doDelete);
      }
      
      private function blockVarOrListName() : String
      {
         return this.blockArg != null ? this.blockArg.argValue : this.block.spec;
      }
      
      private function setBlockVarOrListName(param1:String) : void
      {
         if(param1.length == 0)
         {
            return;
         }
         if(this.block.op == Specs.GET_VAR || this.block.op == Specs.SET_VAR || this.block.op == Specs.CHANGE_VAR)
         {
            this.app.runtime.createVariable(param1);
         }
         if(this.blockArg != null)
         {
            this.blockArg.setArgValue(param1);
         }
         if(this.block != null && (this.block.op == Specs.GET_VAR || this.block.op == Specs.GET_LIST))
         {
            this.block.setSpec(param1);
            this.block.fixExpressionLayout();
         }
         Scratch.app.setSaveNeeded();
      }
      
      public function dragBegin(param1:MouseEvent) : void
      {
      }
      
      public function dragEnd(param1:MouseEvent) : void
      {
         if(this.pickingColor)
         {
            this.pickingColor = false;
            Mouse.cursor = MouseCursor.AUTO;
            this.app.stage.removeChild(this.colorPickerSprite);
            this.app.stage.removeEventListener(Event.RESIZE,this.fixColorPickerLayout);
         }
         else
         {
            this.pickingColor = true;
            this.app.gh.setDragClient(this,param1);
            Mouse.cursor = MouseCursor.BUTTON;
            this.app.stage.addEventListener(Event.RESIZE,this.fixColorPickerLayout);
            this.app.stage.addChild(this.colorPickerSprite = new Sprite());
            this.fixColorPickerLayout();
         }
      }
      
      public function dragMove(param1:MouseEvent) : void
      {
         if(this.pickingColor)
         {
            this.blockArg.setArgValue(this.pixelColorAt(param1.stageX,param1.stageY));
            Scratch.app.setSaveNeeded();
         }
      }
      
      private function fixColorPickerLayout(param1:Event = null) : void
      {
         var _loc2_:Graphics = this.colorPickerSprite.graphics;
         _loc2_.clear();
         _loc2_.beginFill(0,0);
         _loc2_.drawRect(0,0,this.app.stage.stageWidth,this.app.stage.stageHeight);
      }
      
      private function pixelColorAt(param1:int, param2:int) : int
      {
         var _loc3_:Matrix = new Matrix();
         _loc3_.translate(-param1,-param2);
         this.onePixel.fillRect(this.onePixel.rect,0);
         if(this.app.isIn3D)
         {
            this.app.stagePane.visible = true;
         }
         this.onePixel.draw(this.app,_loc3_);
         if(this.app.isIn3D)
         {
            this.app.stagePane.visible = false;
         }
         param1 = int(this.onePixel.getPixel32(0,0));
         return param1 ? param1 | 0xFF000000 : int(4294967295);
      }
      
      private function renameBroadcast() : void
      {
         var doVarRename:Function = null;
         doVarRename = function(param1:DialogBox):void
         {
            var _loc2_:String = param1.getField("New name").replace(/^\s+|\s+$/g,"");
            if(_loc2_.length == 0)
            {
               return;
            }
            var _loc3_:String = block.broadcastMsg;
            app.runtime.renameBroadcast(_loc3_,_loc2_);
         };
         var d:DialogBox = new DialogBox(doVarRename);
         d.addTitle(Translator.map("Rename") + " " + this.block.broadcastMsg);
         d.addField("New name",120,this.block.broadcastMsg);
         d.addAcceptCancelButtons("OK");
         d.showOnStage(this.app.stage);
      }
      
      private function broadcastMenu(param1:MouseEvent) : void
      {
         var broadcastMenuSelection:Function = null;
         var msg:String = null;
         var evt:MouseEvent = param1;
         broadcastMenuSelection = function(param1:*):void
         {
            if(param1 is Function)
            {
               param1();
            }
            else
            {
               setBlockArg(param1);
            }
         };
         var msgNames:Array = this.app.runtime.collectBroadcasts();
         var m:Menu = new Menu(broadcastMenuSelection,"broadcast");
         for each(msg in msgNames)
         {
            m.addItem(msg);
         }
         m.addLine();
         m.addItem("new message...",this.newBroadcast);
         this.showMenu(m);
      }
      
      private function newBroadcast() : void
      {
         var changeBroadcast:Function = null;
         changeBroadcast = function(param1:DialogBox):void
         {
            var _loc2_:String = param1.getField("Message Name");
            if(_loc2_.length == 0)
            {
               return;
            }
            setBlockArg(_loc2_);
         };
         var d:DialogBox = new DialogBox(changeBroadcast);
         d.addTitle("New Message");
         d.addField("Message Name",120);
         d.addAcceptCancelButtons("OK");
         d.showOnStage(this.app.stage);
      }
      
      private function broadcastInfoMenu(param1:MouseEvent) : void
      {
         var showBroadcasts:Function = null;
         var evt:MouseEvent = param1;
         showBroadcasts = function(param1:*):void
         {
            var _loc3_:String = null;
            if(param1 is Function)
            {
               param1();
               return;
            }
            var _loc2_:Array = null;
            if(block.args[0] is BlockArg)
            {
               _loc3_ = block.args[0].argValue;
               if(param1 == "show senders")
               {
                  _loc2_ = app.runtime.allSendersOfBroadcast(_loc3_);
               }
               if(param1 == "show receivers")
               {
                  _loc2_ = app.runtime.allReceiversOfBroadcast(_loc3_);
               }
            }
            if(param1 == "clear senders/receivers")
            {
               _loc2_ = [];
            }
            if(_loc2_ != null)
            {
               app.highlightSprites(_loc2_);
            }
         };
         var m:Menu = new Menu(showBroadcasts,"broadcastInfo");
         this.addGenericBlockItems(m);
         if(!this.isInPalette(this.block))
         {
            if(this.block.args[0] is BlockArg)
            {
               m.addItem("rename broadcast",this.renameBroadcast);
               m.addItem("show senders");
               m.addItem("show receivers");
            }
            m.addItem("clear senders/receivers");
         }
         this.showMenu(m);
      }
   }
}

