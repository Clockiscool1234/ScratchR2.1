package blocks
{
   import scratch.*;
   import translation.*;
   import util.*;
   
   public class BlockIO
   {
      
      private static const controlColor:int = Specs.blockColor(Specs.controlCategory);
      
      public function BlockIO()
      {
         super();
      }
      
      public static function stackToString(param1:Block) : String
      {
         return util.JSON.stringify(stackToArray(param1));
      }
      
      public static function stringToStack(param1:String, param2:Boolean = false) : Block
      {
         return arrayToStack(util.JSON.parse(param1) as Array,param2);
      }
      
      public static function stackToArray(param1:Block) : Array
      {
         if(param1 == null)
         {
            return null;
         }
         var _loc2_:Array = [];
         while(param1 != null)
         {
            _loc2_.push(blockToArray(param1));
            param1 = param1.nextBlock;
         }
         return _loc2_;
      }
      
      public static function arrayToStack(param1:Array, param2:Boolean = false) : Block
      {
         var topBlock:Block = null;
         var lastBlock:Block = null;
         var cmd:Array = null;
         var b:Block = null;
         var cmdList:Array = param1;
         var forStage:Boolean = param2;
         for each(cmd in cmdList)
         {
            b = null;
            try
            {
               b = arrayToBlock(cmd,"",forStage);
            }
            catch(e:*)
            {
               b = new Block("undefined");
            }
            if(topBlock == null)
            {
               topBlock = b;
            }
            if(lastBlock != null)
            {
               lastBlock.insertBlock(b);
            }
            lastBlock = b;
         }
         return topBlock;
      }
      
      private static function blockToArray(param1:Block) : Array
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc2_:Array = [param1.op];
         if(param1.op == Specs.GET_VAR)
         {
            return [Specs.GET_VAR,param1.spec];
         }
         if(param1.op == Specs.GET_LIST)
         {
            return [Specs.GET_LIST,param1.spec];
         }
         if(param1.op == Specs.GET_PARAM)
         {
            return [Specs.GET_PARAM,param1.spec,param1.type];
         }
         if(param1.op == Specs.PROCEDURE_DEF)
         {
            return [Specs.PROCEDURE_DEF,param1.spec,param1.parameterNames,param1.defaultArgValues,param1.warpProcFlag];
         }
         if(param1.op == Specs.CALL)
         {
            _loc2_ = [Specs.CALL,param1.spec];
         }
         for each(_loc3_ in param1.normalizedArgs())
         {
            if(_loc3_ is Block)
            {
               _loc2_.push(blockToArray(_loc3_));
            }
            if(_loc3_ is BlockArg)
            {
               _loc4_ = BlockArg(_loc3_).argValue;
               if(_loc4_ is ScratchObj)
               {
                  _loc4_ = ScratchObj(_loc4_).objName;
               }
               _loc2_.push(_loc4_);
            }
         }
         if(param1.base.canHaveSubstack1())
         {
            _loc2_.push(stackToArray(param1.subStack1));
         }
         if(param1.base.canHaveSubstack2())
         {
            _loc2_.push(stackToArray(param1.subStack2));
         }
         return _loc2_;
      }
      
      private static function arrayToBlock(param1:Array, param2:String, param3:Boolean = false) : Block
      {
         var _loc5_:Block = null;
         var _loc8_:Boolean = false;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:* = undefined;
         if(param1[0] == "getUserName")
         {
            Scratch.app.usesUserNameBlock = true;
         }
         var _loc4_:Block = specialCmd(param1,param3);
         if(_loc4_)
         {
            _loc4_.fixArgLayout();
            return _loc4_;
         }
         _loc5_ = convertOldCmd(param1);
         if(_loc5_)
         {
            _loc5_.fixArgLayout();
            return _loc5_;
         }
         if(param1[0] == Specs.CALL)
         {
            _loc5_ = new Block(param1[1],"",Specs.procedureColor,Specs.CALL);
            param1.splice(0,1);
         }
         else
         {
            _loc10_ = specForCmd(param1,param2);
            _loc11_ = _loc10_[0];
            if(param3 && _loc10_[3] == "whenClicked")
            {
               _loc11_ = "when Stage clicked";
            }
            _loc5_ = new Block(_loc11_,_loc10_[1],Specs.blockColor(_loc10_[2]),_loc10_[3]);
         }
         var _loc6_:Array = argsForCmd(param1,_loc5_.args.length,_loc5_.rightToLeft);
         var _loc7_:Array = substacksForCmd(param1,_loc5_.args.length);
         var _loc9_:int = 0;
         while(_loc9_ < _loc6_.length)
         {
            _loc12_ = _loc6_[_loc9_];
            if(_loc12_ is ScratchObj)
            {
               _loc12_ = ScratchObj(_loc12_).objName;
               _loc8_ = true;
            }
            _loc5_.setArg(_loc9_,_loc12_);
            _loc9_++;
         }
         if(Boolean(_loc7_[0]) && _loc5_.base.canHaveSubstack1())
         {
            _loc5_.insertBlockSub1(_loc7_[0]);
         }
         if(Boolean(_loc7_[1]) && _loc5_.base.canHaveSubstack2())
         {
            _loc5_.insertBlockSub2(_loc7_[1]);
         }
         if(!_loc8_)
         {
            fixMouseEdgeRefs(_loc5_);
         }
         _loc5_.fixArgLayout();
         return _loc5_;
      }
      
      public static function specForCmd(param1:Array, param2:String) : Array
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc3_:String = param1[0];
         if(_loc3_ == "\\\\")
         {
            _loc3_ = "%";
         }
         for each(_loc4_ in Specs.commands)
         {
            if(_loc4_[3] == _loc3_)
            {
               return _loc4_;
            }
         }
         _loc5_ = Scratch.app.extensionManager.specForCmd(_loc3_);
         if(_loc5_)
         {
            return _loc5_;
         }
         var _loc6_:String = "undefined";
         var _loc7_:int = 1;
         while(_loc7_ < param1.length)
         {
            _loc6_ += " %n";
            _loc7_++;
         }
         return [_loc6_,param2,0,_loc3_];
      }
      
      private static function argsForCmd(param1:Array, param2:uint, param3:Boolean) : Array
      {
         var _loc6_:* = undefined;
         var _loc4_:Array = [];
         var _loc5_:int = 1;
         while(_loc5_ <= param2)
         {
            _loc6_ = param1[_loc5_];
            if(_loc6_ is Array)
            {
               _loc4_.push(arrayToBlock(_loc6_,"r"));
            }
            else
            {
               _loc4_.push(_loc6_);
            }
            _loc5_++;
         }
         if(param3)
         {
            _loc4_.reverse();
         }
         return _loc4_;
      }
      
      private static function substacksForCmd(param1:Array, param2:uint) : Array
      {
         var _loc5_:* = undefined;
         var _loc3_:Array = [];
         var _loc4_:int = 1 + param2;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_ == null)
            {
               _loc3_.push(null);
            }
            else
            {
               _loc3_.push(arrayToStack(_loc5_));
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private static function specialCmd(param1:Array, param2:Boolean) : Block
      {
         var _loc3_:Block = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc7_:String = null;
         switch(param1[0])
         {
            case Specs.GET_VAR:
               return new Block(param1[1],"r",Specs.variableColor,Specs.GET_VAR);
            case Specs.GET_LIST:
               return new Block(param1[1],"r",Specs.listColor,Specs.GET_LIST);
            case Specs.PROCEDURE_DEF:
               _loc3_ = new Block("","p",Specs.procedureColor,Specs.PROCEDURE_DEF);
               _loc3_.parameterNames = param1[2];
               _loc3_.defaultArgValues = param1[3];
               if(param1.length > 4)
               {
                  _loc3_.warpProcFlag = param1[4];
               }
               _loc3_.setSpec(param1[1]);
               _loc3_.fixArgLayout();
               return _loc3_;
            case Specs.GET_PARAM:
               _loc4_ = param1.length >= 3 ? param1[2] : "r";
               return new Block(param1[1],_loc4_,Specs.parameterColor,Specs.GET_PARAM);
            case "changeVariable":
               _loc5_ = param1[2];
               if(_loc5_ == Specs.SET_VAR)
               {
                  _loc3_ = new Block("set %m.var to %s"," ",Specs.variableColor,Specs.SET_VAR);
               }
               else if(_loc5_ == Specs.CHANGE_VAR)
               {
                  _loc3_ = new Block("change %m.var by %n"," ",Specs.variableColor,Specs.CHANGE_VAR);
               }
               if(_loc3_ == null)
               {
                  return null;
               }
               _loc6_ = param1[3];
               if(_loc6_ is Array)
               {
                  _loc6_ = arrayToBlock(_loc6_,"r");
               }
               _loc3_.setArg(0,param1[1]);
               _loc3_.setArg(1,_loc6_);
               return _loc3_;
               break;
            case "EventHatMorph":
               if(param1[1] == "Scratch-StartClicked")
               {
                  return new Block("when @greenFlag clicked","h",controlColor,"whenGreenFlag");
               }
               _loc3_ = new Block("when I receive %m.broadcast","h",controlColor,"whenIReceive");
               _loc3_.setArg(0,param1[1]);
               return _loc3_;
               break;
            case "MouseClickEventHatMorph":
               return new Block("when I am clicked","h",controlColor,"whenClicked");
            case "KeyEventHatMorph":
               _loc3_ = new Block("when %m.key key pressed","h",controlColor,"whenKeyPressed");
               _loc3_.setArg(0,param1[1]);
               return _loc3_;
            case "stopScripts":
               _loc7_ = param1[1].indexOf("other scripts") == 0 ? " " : "f";
               _loc3_ = new Block("stop %m.stop",_loc7_,controlColor,"stopScripts");
               if(_loc7_ == " ")
               {
                  if(param2)
                  {
                     param1[1] = "other scripts in stage";
                  }
                  else
                  {
                     param1[1] = "other scripts in sprite";
                  }
               }
               _loc3_.setArg(0,param1[1]);
               return _loc3_;
            default:
               return null;
         }
      }
      
      private static function convertOldCmd(param1:Array) : Block
      {
         var _loc2_:Block = null;
         var _loc3_:int = 0;
         var _loc6_:Block = null;
         _loc3_ = Specs.blockColor(Specs.controlCategory);
         var _loc4_:int = Specs.blockColor(Specs.looksCategory);
         var _loc5_:int = Specs.blockColor(Specs.operatorsCategory);
         switch(param1[0])
         {
            case "abs":
               _loc2_ = new Block("%m.mathOp of %n","r",_loc5_,"computeFunction:of:");
               _loc2_.setArg(0,"abs");
               _loc2_.setArg(1,convertArg(param1[1]));
               return _loc2_;
            case "sqrt":
               _loc2_ = new Block("%m.mathOp of %n","r",_loc5_,"computeFunction:of:");
               _loc2_.setArg(0,"sqrt");
               _loc2_.setArg(1,convertArg(param1[1]));
               return _loc2_;
            case "doReturn":
               _loc2_ = new Block("stop %m.stop","f",_loc3_,"stopScripts");
               _loc2_.setArg(0,"this script");
               return _loc2_;
            case "stopAll":
               _loc2_ = new Block("stop %m.stop","f",_loc3_,"stopScripts");
               _loc2_.setArg(0,"all");
               return _loc2_;
            case "showBackground:":
               _loc2_ = new Block("switch backdrop to %m.backdrop"," ",_loc4_,"startScene");
               _loc2_.setArg(0,convertArg(param1[1]));
               return _loc2_;
            case "nextBackground":
               return new Block("next background"," ",_loc4_,"nextScene");
            case "doForeverIf":
               _loc6_ = new Block("if %b then","c",_loc3_,"doIf");
               _loc6_.setArg(0,convertArg(param1[1]));
               if(param1[2] is Array)
               {
                  _loc6_.insertBlockSub1(arrayToStack(param1[2]));
               }
               _loc6_.fixArgLayout();
               _loc2_ = new Block("forever","cf",_loc3_,"doForever");
               _loc2_.insertBlockSub1(_loc6_);
               return _loc2_;
            default:
               return null;
         }
      }
      
      private static function convertArg(param1:*) : *
      {
         return param1 is Array ? arrayToBlock(param1,"r") : param1;
      }
      
      private static function fixMouseEdgeRefs(param1:Block) : void
      {
         var _loc3_:BlockArg = null;
         var _loc4_:String = null;
         var _loc2_:Array = ["createCloneOf","distanceTo:","getAttribute:of:","gotoSpriteOrMouse:","pointTowards:","touching:"];
         if(_loc2_.indexOf(param1.op) < 0)
         {
            return;
         }
         if(param1.args.length == 1 && param1.getNormalizedArg(0) is BlockArg)
         {
            _loc3_ = param1.getNormalizedArg(0);
         }
         if(param1.args.length == 2 && param1.getNormalizedArg(1) is BlockArg)
         {
            _loc3_ = param1.getNormalizedArg(1);
         }
         if(_loc3_)
         {
            _loc4_ = _loc3_.argValue;
            if(_loc4_ == "edge" || _loc4_ == "_edge_")
            {
               _loc3_.setArgValue("_edge_",Translator.map("edge"));
            }
            if(_loc4_ == "mouse" || _loc4_ == "_mouse_")
            {
               _loc3_.setArgValue("_mouse_",Translator.map("mouse-pointer"));
            }
            if(_loc4_ == "_myself_")
            {
               _loc3_.setArgValue("_myself_",Translator.map("myself"));
            }
            if(_loc4_ == "_stage_")
            {
               _loc3_.setArgValue("_stage_",Translator.map("Stage"));
            }
            if(_loc4_ == "_random_")
            {
               _loc3_.setArgValue("_random_",Translator.map("random position"));
            }
         }
      }
   }
}

