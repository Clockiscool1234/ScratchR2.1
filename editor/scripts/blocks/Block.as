package blocks
{
   import assets.Resources;
   import extensions.ExtensionManager;
   import flash.display.*;
   import flash.events.*;
   import flash.filters.GlowFilter;
   import flash.geom.*;
   import flash.net.URLLoader;
   import flash.text.*;
   import scratch.*;
   import translation.Translator;
   import uiwidgets.*;
   import util.*;
   
   public class Block extends Sprite
   {
      
      public static var argTextFormat:TextFormat;
      
      public static var blockLabelFormat:TextFormat;
      
      private static var vOffset:int;
      
      public static var MenuHandlerFunction:Function;
      
      private static var useEmbeddedFont:Boolean = false;
      
      private static var ROLE_NONE:int = 0;
      
      private static var ROLE_ABSOLUTE:int = 1;
      
      private static var ROLE_EMBEDDED:int = 2;
      
      private static var ROLE_NEXT:int = 3;
      
      private static var ROLE_SUBSTACK1:int = 4;
      
      private static var ROLE_SUBSTACK2:int = 5;
      
      private const minCommandWidth:int = 36;
      
      private const minHatWidth:int = 80;
      
      private const minLoopWidth:int = 80;
      
      public var spec:String;
      
      public var type:String;
      
      public var op:String = "";
      
      public var opFunction:Function;
      
      public var args:Array;
      
      public var defaultArgValues:Array;
      
      public var parameterIndex:int = -1;
      
      public var parameterNames:Array;
      
      public var warpProcFlag:Boolean;
      
      public var rightToLeft:Boolean;
      
      public var isHat:Boolean = false;
      
      public var isAsyncHat:Boolean = false;
      
      public var isReporter:Boolean = false;
      
      public var isTerminal:Boolean = false;
      
      public var isRequester:Boolean = false;
      
      public var forceAsync:Boolean = false;
      
      public var requestState:int = 0;
      
      public var response:* = null;
      
      public var requestLoader:URLLoader = null;
      
      public var nextBlock:Block;
      
      public var subStack1:Block;
      
      public var subStack2:Block;
      
      public var base:BlockShape;
      
      private var suppressLayout:Boolean;
      
      private var labelsAndArgs:Array;
      
      private var argTypes:Array;
      
      private var elseLabel:TextField;
      
      private var indentTop:int = 2;
      
      private var indentBottom:int = 3;
      
      private var indentLeft:int = 4;
      
      private var indentRight:int = 3;
      
      private var originalParent:DisplayObjectContainer;
      
      private var originalRole:int;
      
      private var originalIndex:int;
      
      private var originalPosition:Point;
      
      public function Block(param1:String, param2:String = " ", param3:int = 13631488, param4:* = 0, param5:Array = null)
      {
         var _loc6_:int = 0;
         this.args = [];
         this.defaultArgValues = [];
         this.labelsAndArgs = [];
         this.argTypes = [];
         super();
         this.spec = Translator.map(param1);
         this.type = param2;
         this.op = param4;
         if(Specs.CALL == param4 || Specs.GET_LIST == param4 || Specs.GET_PARAM == param4 || Specs.GET_VAR == param4 || Specs.PROCEDURE_DEF == param4 || "proc_declaration" == param4)
         {
            this.spec = param1;
         }
         if(param3 == -1)
         {
            return;
         }
         if(param2 == " " || param2 == "" || param2 == "w")
         {
            this.base = new BlockShape(BlockShape.CmdShape,param3);
            this.indentTop = 3;
         }
         else if(param2 == "b")
         {
            this.base = new BlockShape(BlockShape.BooleanShape,param3);
            this.isReporter = true;
            this.forceAsync = Scratch.app.extensionManager.shouldForceAsync(param4);
            this.isRequester = this.forceAsync;
            this.indentLeft = 9;
            this.indentRight = 7;
         }
         else if(param2 == "r" || param2 == "R")
         {
            this.type = "r";
            this.base = new BlockShape(BlockShape.NumberShape,param3);
            this.isReporter = true;
            this.forceAsync = param2 == "r" && Scratch.app.extensionManager.shouldForceAsync(param4);
            this.isRequester = param2 == "R" || this.forceAsync;
            this.indentTop = 2;
            this.indentBottom = 2;
            this.indentLeft = 6;
            this.indentRight = 4;
         }
         else if(param2 == "h" || param2 == "H")
         {
            this.base = new BlockShape(BlockShape.HatShape,param3);
            this.isHat = true;
            this.forceAsync = param2 == "h" && Scratch.app.extensionManager.shouldForceAsync(param4);
            this.isAsyncHat = param2 == "H" || this.forceAsync;
            this.indentTop = 12;
         }
         else if(param2 == "c")
         {
            this.base = new BlockShape(BlockShape.LoopShape,param3);
         }
         else if(param2 == "cf")
         {
            this.base = new BlockShape(BlockShape.FinalLoopShape,param3);
            this.isTerminal = true;
         }
         else if(param2 == "e")
         {
            this.base = new BlockShape(BlockShape.IfElseShape,param3);
            addChild(this.elseLabel = this.makeLabel(Translator.map("else")));
         }
         else if(param2 == "f")
         {
            this.base = new BlockShape(BlockShape.FinalCmdShape,param3);
            this.isTerminal = true;
            this.indentTop = 5;
         }
         else if(param2 == "o")
         {
            this.base = new BlockShape(BlockShape.CmdOutlineShape,param3);
            this.base.filters = [];
            this.indentTop = 3;
         }
         else if(param2 == "p")
         {
            this.base = new BlockShape(BlockShape.ProcHatShape,param3);
            this.isHat = true;
         }
         else
         {
            this.base = new BlockShape(BlockShape.RectShape,param3);
         }
         addChildAt(this.base,0);
         this.setSpec(this.spec,param5);
         addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.focusChange);
      }
      
      public static function setFonts(param1:int, param2:int, param3:Boolean, param4:int) : void
      {
         var _loc5_:String = Resources.chooseFont(["Lucida Grande","Verdana","Arial","DejaVu Sans"]);
         blockLabelFormat = new TextFormat(_loc5_,param1,16777215,param3);
         argTextFormat = new TextFormat(_loc5_,param2,5263440,false);
         Block.vOffset = param4;
      }
      
      protected static function indent(param1:String) : String
      {
         return param1.replace(/^/gm,"    ");
      }
      
      public function setSpec(param1:String, param2:Array = null) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:* = undefined;
         var _loc5_:TextField = null;
         var _loc6_:Block = null;
         var _loc7_:Array = null;
         for each(_loc3_ in this.labelsAndArgs)
         {
            if(_loc3_.parent != null)
            {
               _loc3_.parent.removeChild(_loc3_);
            }
         }
         this.spec = param1;
         if(this.op == Specs.PROCEDURE_DEF)
         {
            this.indentTop = 20;
            this.indentBottom = 5;
            this.indentLeft = 5;
            this.indentRight = 5;
            this.labelsAndArgs = [];
            this.argTypes = [];
            _loc5_ = this.makeLabel(Translator.map("define"));
            this.labelsAndArgs.push(_loc5_);
            this.labelsAndArgs.push(_loc6_ = this.declarationBlock());
         }
         else if(this.op == Specs.GET_VAR || this.op == Specs.GET_LIST)
         {
            this.labelsAndArgs = [this.makeLabel(this.spec)];
         }
         else
         {
            _loc7_ = ["doForever","doForeverIf","doRepeat","doUntil"];
            this.base.hasLoopArrow = _loc7_.indexOf(this.op) >= 0;
            this.addLabelsAndArgs(this.spec,this.base.color);
         }
         this.rightToLeft = Translator.rightToLeft;
         if(this.rightToLeft)
         {
            if(["+","-","*","/","%"].indexOf(this.op) > -1)
            {
               this.rightToLeft = Translator.rightToLeftMath;
            }
            if([">","<"].indexOf(this.op) > -1)
            {
               this.rightToLeft = false;
            }
         }
         if(this.rightToLeft)
         {
            this.labelsAndArgs.reverse();
            this.argTypes.reverse();
            if(param2)
            {
               param2.reverse();
            }
         }
         for each(_loc4_ in this.labelsAndArgs)
         {
            addChild(_loc4_);
         }
         if(param2)
         {
            this.setDefaultArgs(param2);
         }
         this.fixArgLayout();
      }
      
      public function get broadcastMsg() : String
      {
         var _loc1_:Object = null;
         for each(_loc1_ in this.args)
         {
            if(_loc1_ is BlockArg && _loc1_.menuName == "broadcast")
            {
               return _loc1_.argValue;
            }
         }
         return null;
      }
      
      public function set broadcastMsg(param1:String) : void
      {
         var _loc2_:Object = null;
         for each(_loc2_ in this.args)
         {
            if(_loc2_ is BlockArg && _loc2_.menuName == "broadcast")
            {
               _loc2_.setArgValue(param1);
            }
         }
      }
      
      public function getNormalizedArgIndex(param1:int) : int
      {
         return this.rightToLeft ? int(this.args.length - 1 - param1) : param1;
      }
      
      public function getNormalizedArg(param1:int) : *
      {
         return this.args[this.getNormalizedArgIndex(param1)];
      }
      
      public function normalizedArgs() : Array
      {
         return this.rightToLeft ? this.args.concat().reverse() : this.args;
      }
      
      public function changeOperator(param1:String) : void
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in this.labelsAndArgs)
         {
            if(_loc2_ is TextField && _loc2_.text == this.op)
            {
               _loc2_.text = param1;
            }
         }
         this.op = param1;
         this.opFunction = null;
         this.fixArgLayout();
      }
      
      private function declarationBlock() : Block
      {
         var _loc3_:String = null;
         var _loc4_:Block = null;
         var _loc1_:Block = new Block(this.spec,"o",Specs.procedureColor,"proc_declaration");
         if(!this.parameterNames)
         {
            this.parameterNames = [];
         }
         var _loc2_:int = 0;
         while(_loc2_ < this.parameterNames.length)
         {
            _loc3_ = typeof this.defaultArgValues[_loc2_] == "boolean" ? "b" : "r";
            _loc4_ = new Block(this.parameterNames[_loc2_],_loc3_,Specs.parameterColor,Specs.GET_PARAM);
            _loc4_.parameterIndex = _loc2_;
            _loc1_.setArg(_loc2_,_loc4_);
            _loc2_++;
         }
         _loc1_.fixArgLayout();
         return _loc1_;
      }
      
      public function isProcDef() : Boolean
      {
         return this.op == Specs.PROCEDURE_DEF;
      }
      
      public function isEmbeddedInProcHat() : Boolean
      {
         return parent is Block && Block(parent).op == Specs.PROCEDURE_DEF && this != Block(parent).nextBlock;
      }
      
      public function isEmbeddedParameter() : Boolean
      {
         if(this.op != Specs.GET_PARAM || !(parent is Block))
         {
            return false;
         }
         return Block(parent).op == "proc_declaration";
      }
      
      public function isInPalette() : Boolean
      {
         var _loc1_:DisplayObject = parent;
         while(_loc1_)
         {
            if("isBlockPalette" in _loc1_)
            {
               return true;
            }
            _loc1_ = _loc1_.parent;
         }
         return false;
      }
      
      public function setTerminal(param1:Boolean) : void
      {
         removeChild(this.base);
         this.isTerminal = param1;
         var _loc2_:int = this.isTerminal ? BlockShape.FinalCmdShape : BlockShape.CmdShape;
         this.base = new BlockShape(_loc2_,this.base.color);
         addChildAt(this.base,0);
         this.fixArgLayout();
      }
      
      private function addLabelsAndArgs(param1:String, param2:int) : void
      {
         var _loc4_:int = 0;
         var _loc5_:DisplayObject = null;
         var _loc6_:String = null;
         var _loc3_:Array = ReadStream.tokenize(param1);
         this.labelsAndArgs = [];
         this.argTypes = [];
         _loc4_ = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = this.argOrLabelFor(_loc3_[_loc4_],param2);
            this.labelsAndArgs.push(_loc5_);
            _loc6_ = "icon";
            if(_loc5_ is BlockArg)
            {
               _loc6_ = _loc3_[_loc4_];
            }
            if(_loc5_ is TextField)
            {
               _loc6_ = "label";
            }
            this.argTypes.push(_loc6_);
            _loc4_++;
         }
      }
      
      public function argType(param1:DisplayObject) : String
      {
         var _loc2_:int = this.labelsAndArgs.indexOf(param1);
         return _loc2_ == -1 ? "" : this.argTypes[_loc2_];
      }
      
      public function allBlocksDo(param1:Function) : void
      {
         var _loc2_:* = undefined;
         param1(this);
         for each(_loc2_ in this.args)
         {
            if(_loc2_ is Block)
            {
               _loc2_.allBlocksDo(param1);
            }
         }
         if(this.subStack1 != null)
         {
            this.subStack1.allBlocksDo(param1);
         }
         if(this.subStack2 != null)
         {
            this.subStack2.allBlocksDo(param1);
         }
         if(this.nextBlock != null)
         {
            this.nextBlock.allBlocksDo(param1);
         }
      }
      
      public function showRunFeedback() : void
      {
         var _loc1_:* = undefined;
         if(Boolean(filters) && filters.length > 0)
         {
            for each(_loc1_ in filters)
            {
               if(_loc1_ is GlowFilter)
               {
                  return;
               }
            }
         }
         filters = this.runFeedbackFilters().concat(filters || []);
      }
      
      public function hideRunFeedback() : void
      {
         var _loc1_:Array = null;
         var _loc2_:* = undefined;
         if(Boolean(filters) && filters.length > 0)
         {
            _loc1_ = [];
            for each(_loc2_ in filters)
            {
               if(!(_loc2_ is GlowFilter))
               {
                  _loc1_.push(_loc2_);
               }
            }
            filters = _loc1_;
         }
      }
      
      private function runFeedbackFilters() : Array
      {
         var _loc1_:GlowFilter = new GlowFilter(16711584);
         _loc1_.strength = 2;
         _loc1_.blurX = _loc1_.blurY = 12;
         _loc1_.quality = 3;
         return [_loc1_];
      }
      
      public function saveOriginalState() : void
      {
         var _loc1_:Block = null;
         this.originalParent = parent;
         if(parent)
         {
            _loc1_ = parent as Block;
            if(_loc1_ == null)
            {
               this.originalRole = ROLE_ABSOLUTE;
            }
            else if(this.isReporter)
            {
               this.originalRole = ROLE_EMBEDDED;
               this.originalIndex = _loc1_.args.indexOf(this);
            }
            else if(_loc1_.nextBlock == this)
            {
               this.originalRole = ROLE_NEXT;
            }
            else if(_loc1_.subStack1 == this)
            {
               this.originalRole = ROLE_SUBSTACK1;
            }
            else if(_loc1_.subStack2 == this)
            {
               this.originalRole = ROLE_SUBSTACK2;
            }
            this.originalPosition = localToGlobal(new Point(0,0));
         }
         else
         {
            this.originalRole = ROLE_NONE;
            this.originalPosition = null;
         }
      }
      
      public function restoreOriginalState() : void
      {
         var _loc2_:Point = null;
         var _loc1_:Block = this.originalParent as Block;
         scaleX = scaleY = 1;
         switch(this.originalRole)
         {
            case ROLE_NONE:
               if(parent)
               {
                  parent.removeChild(this);
               }
               break;
            case ROLE_ABSOLUTE:
               this.originalParent.addChild(this);
               _loc2_ = this.originalParent.globalToLocal(this.originalPosition);
               x = _loc2_.x;
               y = _loc2_.y;
               break;
            case ROLE_EMBEDDED:
               _loc1_.replaceArgWithBlock(_loc1_.args[this.originalIndex],this,Scratch.app.scriptsPane);
               break;
            case ROLE_NEXT:
               _loc1_.insertBlock(this);
               break;
            case ROLE_SUBSTACK1:
               _loc1_.insertBlockSub1(this);
               break;
            case ROLE_SUBSTACK2:
               _loc1_.insertBlockSub2(this);
         }
      }
      
      public function originalPositionIn(param1:DisplayObject) : Point
      {
         return this.originalPosition && param1.globalToLocal(this.originalPosition);
      }
      
      private function setDefaultArgs(param1:Array) : void
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         this.collectArgs();
         var _loc2_:int = 0;
         while(_loc2_ < Math.min(this.args.length,param1.length))
         {
            _loc3_ = null;
            _loc4_ = param1[_loc2_];
            if(_loc4_ is BlockArg)
            {
               _loc4_ = BlockArg(_loc4_).argValue;
            }
            if("_edge_" == _loc4_)
            {
               _loc3_ = Translator.map("edge");
            }
            if("_mouse_" == _loc4_)
            {
               _loc3_ = Translator.map("mouse-pointer");
            }
            if("_myself_" == _loc4_)
            {
               _loc3_ = Translator.map("myself");
            }
            if("_stage_" == _loc4_)
            {
               _loc3_ = Translator.map("Stage");
            }
            if("_random_" == _loc4_)
            {
               _loc3_ = Translator.map("random position");
            }
            if(this.args[_loc2_] is BlockArg)
            {
               this.args[_loc2_].setArgValue(_loc4_,_loc3_);
            }
            _loc2_++;
         }
         this.defaultArgValues = param1;
      }
      
      public function setArg(param1:int, param2:*) : void
      {
         this.collectArgs();
         if(param1 >= this.args.length)
         {
            return;
         }
         var _loc3_:BlockArg = this.args[param1];
         if(param2 is Block)
         {
            this.labelsAndArgs[this.labelsAndArgs.indexOf(_loc3_)] = param2;
            this.args[param1] = param2;
            removeChild(_loc3_);
            addChild(param2);
         }
         else
         {
            _loc3_.setArgValue(param2);
         }
      }
      
      public function fixExpressionLayout() : void
      {
         var _loc1_:Block = this;
         while(_loc1_.isReporter)
         {
            _loc1_.fixArgLayout();
            if(!(_loc1_.parent is Block))
            {
               return;
            }
            _loc1_ = Block(_loc1_.parent);
         }
         if(_loc1_ is Block)
         {
            _loc1_.fixArgLayout();
         }
      }
      
      public function fixArgLayout() : void
      {
         var _loc1_:DisplayObject = null;
         var _loc2_:int = 0;
         if(this.suppressLayout)
         {
            return;
         }
         var _loc3_:int = this.indentLeft - this.indentAjustmentFor(this.labelsAndArgs[0]);
         var _loc4_:int = 0;
         _loc2_ = 0;
         while(_loc2_ < this.labelsAndArgs.length)
         {
            _loc1_ = this.labelsAndArgs[_loc2_];
            if(_loc2_ == 1 && this.argTypes[_loc2_] != "label")
            {
               _loc3_ = Math.max(_loc3_,30);
            }
            _loc1_.x = _loc3_;
            _loc4_ = Math.max(_loc4_,_loc1_.height);
            _loc3_ += _loc1_.width + 2;
            if(this.argTypes[_loc2_] == "icon")
            {
               _loc3_ += 3;
            }
            _loc2_++;
         }
         _loc3_ -= this.indentAjustmentFor(this.labelsAndArgs[this.labelsAndArgs.length - 1]);
         _loc2_ = 0;
         while(_loc2_ < this.labelsAndArgs.length)
         {
            _loc1_ = this.labelsAndArgs[_loc2_];
            _loc1_.y = this.indentTop + (_loc4_ - _loc1_.height) / 2 + vOffset;
            if(_loc1_ is BlockArg && !BlockArg(_loc1_).numberType)
            {
               _loc1_.y += 1;
            }
            _loc2_++;
         }
         if([" ","","o"].indexOf(this.type) >= 0)
         {
            _loc3_ = Math.max(_loc3_,this.minCommandWidth);
         }
         if(["c","cf","e"].indexOf(this.type) >= 0)
         {
            _loc3_ = Math.max(_loc3_,this.minLoopWidth);
         }
         if(["h"].indexOf(this.type) >= 0)
         {
            _loc3_ = Math.max(_loc3_,this.minHatWidth);
         }
         if(this.elseLabel)
         {
            _loc3_ = Math.max(_loc3_,this.indentLeft + this.elseLabel.width + 2);
         }
         this.base.setWidthAndTopHeight(_loc3_ + this.indentRight,this.indentTop + _loc4_ + this.indentBottom);
         if(this.type == "c" || this.type == "e")
         {
            this.fixStackLayout();
         }
         this.base.redraw();
         this.fixElseLabel();
         this.collectArgs();
      }
      
      private function indentAjustmentFor(param1:*) : int
      {
         var _loc2_:String = "";
         if(param1 is Block)
         {
            _loc2_ = Block(param1).type;
         }
         if(param1 is BlockArg)
         {
            _loc2_ = BlockArg(param1).type;
         }
         if(this.type == "b" && _loc2_ == "b")
         {
            return 4;
         }
         if(this.type == "r" && (_loc2_ == "r" || _loc2_ == "d" || _loc2_ == "n"))
         {
            return 2;
         }
         return 0;
      }
      
      public function fixStackLayout() : void
      {
         var _loc2_:int = 0;
         var _loc1_:Block = this;
         while(_loc1_ != null)
         {
            if(_loc1_.base.canHaveSubstack1())
            {
               _loc2_ = BlockShape.EmptySubstackH;
               if(_loc1_.subStack1)
               {
                  _loc1_.subStack1.fixStackLayout();
                  _loc1_.subStack1.x = BlockShape.SubstackInset;
                  _loc1_.subStack1.y = _loc1_.base.substack1y();
                  _loc2_ = _loc1_.subStack1.getRect(_loc1_).height;
                  if(_loc1_.subStack1.bottomBlock().isTerminal)
                  {
                     _loc2_ += BlockShape.NotchDepth;
                  }
               }
               _loc1_.base.setSubstack1Height(_loc2_);
               _loc2_ = BlockShape.EmptySubstackH;
               if(_loc1_.subStack2)
               {
                  _loc1_.subStack2.fixStackLayout();
                  _loc1_.subStack2.x = BlockShape.SubstackInset;
                  _loc1_.subStack2.y = _loc1_.base.substack2y();
                  _loc2_ = _loc1_.subStack2.getRect(_loc1_).height;
                  if(_loc1_.subStack2.bottomBlock().isTerminal)
                  {
                     _loc2_ += BlockShape.NotchDepth;
                  }
               }
               _loc1_.base.setSubstack2Height(_loc2_);
               _loc1_.base.redraw();
               _loc1_.fixElseLabel();
            }
            if(_loc1_.nextBlock != null)
            {
               _loc1_.nextBlock.x = 0;
               _loc1_.nextBlock.y = _loc1_.base.nextBlockY();
            }
            _loc1_ = _loc1_.nextBlock;
         }
      }
      
      private function fixElseLabel() : void
      {
         var _loc1_:TextLineMetrics = null;
         var _loc2_:int = 0;
         if(this.elseLabel)
         {
            _loc1_ = this.elseLabel.getLineMetrics(0);
            _loc2_ = (_loc1_.ascent + _loc1_.descent) / 2;
            this.elseLabel.x = 4;
            this.elseLabel.y = this.base.substack2y() - 11 - _loc2_ + vOffset;
         }
      }
      
      public function previewSubstack1Height(param1:int) : void
      {
         this.base.setSubstack1Height(param1);
         this.base.redraw();
         this.fixElseLabel();
         if(this.nextBlock)
         {
            this.nextBlock.y = this.base.nextBlockY();
         }
      }
      
      public function duplicate(param1:Boolean, param2:Boolean = false) : Block
      {
         var _loc3_:String = this.spec;
         if(this.op == "whenClicked")
         {
            _loc3_ = param2 ? "when Stage clicked" : "when this sprite clicked";
         }
         var _loc4_:Block = new Block(_loc3_,this.type,int(param1 ? -1 : this.base.color),this.op);
         _loc4_.isRequester = this.isRequester;
         _loc4_.forceAsync = this.forceAsync;
         _loc4_.parameterNames = this.parameterNames;
         _loc4_.defaultArgValues = this.defaultArgValues;
         _loc4_.warpProcFlag = this.warpProcFlag;
         if(param1)
         {
            _loc4_.copyArgsForClone(this.args);
         }
         else
         {
            _loc4_.copyArgs(this.args);
            if(this.op == "stopScripts" && this.args[0] is BlockArg)
            {
               if(this.args[0].argValue.indexOf("other scripts") == 0)
               {
                  if(param2)
                  {
                     _loc4_.args[0].setArgValue("other scripts in stage");
                  }
                  else
                  {
                     _loc4_.args[0].setArgValue("other scripts in sprite");
                  }
               }
            }
         }
         if(this.nextBlock != null)
         {
            _loc4_.addChild(_loc4_.nextBlock = this.nextBlock.duplicate(param1,param2));
         }
         if(this.subStack1 != null)
         {
            _loc4_.addChild(_loc4_.subStack1 = this.subStack1.duplicate(param1,param2));
         }
         if(this.subStack2 != null)
         {
            _loc4_.addChild(_loc4_.subStack2 = this.subStack2.duplicate(param1,param2));
         }
         if(!param1)
         {
            _loc4_.x = x;
            _loc4_.y = y;
            _loc4_.fixExpressionLayout();
            _loc4_.fixStackLayout();
         }
         return _loc4_;
      }
      
      private function copyArgs(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc3_:* = undefined;
         var _loc4_:BlockArg = null;
         var _loc5_:Block = null;
         var _loc6_:* = undefined;
         this.collectArgs();
         _loc2_ = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            if(_loc3_ is BlockArg)
            {
               _loc4_ = _loc3_;
               BlockArg(this.args[_loc2_]).setArgValue(_loc4_.argValue,_loc4_.labelOrNull());
            }
            if(_loc3_ is Block)
            {
               _loc5_ = Block(_loc3_).duplicate(false);
               _loc6_ = this.args[_loc2_];
               this.labelsAndArgs[this.labelsAndArgs.indexOf(_loc6_)] = _loc5_;
               this.args[_loc2_] = _loc5_;
               removeChild(_loc6_);
               addChild(_loc5_);
            }
            _loc2_++;
         }
      }
      
      private function copyArgsForClone(param1:Array) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:* = undefined;
         var _loc5_:BlockArg = null;
         this.args = [];
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc4_ = param1[_loc2_];
            if(_loc4_ is BlockArg)
            {
               _loc5_ = new BlockArg(_loc4_.type,-1);
               _loc5_.argValue = _loc4_.argValue;
               this.args.push(_loc5_);
            }
            if(_loc4_ is Block)
            {
               this.args.push(Block(_loc4_).duplicate(true));
            }
            _loc2_++;
         }
         for each(_loc3_ in this.args)
         {
            addChild(_loc3_);
         }
      }
      
      private function collectArgs() : void
      {
         var _loc1_:int = 0;
         var _loc2_:* = undefined;
         this.args = [];
         if(this.isRequester && this.requestState == 2)
         {
            this.requestState = 0;
         }
         _loc1_ = 0;
         while(_loc1_ < this.labelsAndArgs.length)
         {
            _loc2_ = this.labelsAndArgs[_loc1_];
            if(_loc2_ is Block || _loc2_ is BlockArg)
            {
               this.args.push(_loc2_);
            }
            _loc1_++;
         }
      }
      
      public function removeBlock(param1:Block) : void
      {
         var _loc2_:int = 0;
         var _loc3_:DisplayObject = null;
         if(param1.parent == this)
         {
            removeChild(param1);
         }
         if(param1 == this.nextBlock)
         {
            this.nextBlock = null;
         }
         if(param1 == this.subStack1)
         {
            this.subStack1 = null;
         }
         if(param1 == this.subStack2)
         {
            this.subStack2 = null;
         }
         if(param1.isReporter)
         {
            _loc2_ = this.labelsAndArgs.indexOf(param1);
            if(_loc2_ < 0)
            {
               return;
            }
            _loc3_ = this.argOrLabelFor(this.argTypes[_loc2_],this.base.color);
            this.labelsAndArgs[_loc2_] = _loc3_;
            addChild(_loc3_);
            this.fixExpressionLayout();
            if(param1.requestLoader)
            {
               param1.requestLoader.close();
            }
         }
         this.topBlock().fixStackLayout();
         Scratch.app.runtime.checkForGraphicEffects();
      }
      
      public function insertBlock(param1:Block) : void
      {
         var _loc2_:Block = this.nextBlock;
         if(_loc2_ != null)
         {
            removeChild(_loc2_);
         }
         addChild(param1);
         this.nextBlock = param1;
         if(_loc2_ != null)
         {
            param1.appendBlock(_loc2_);
         }
         this.topBlock().fixStackLayout();
      }
      
      public function insertBlockAbove(param1:Block) : void
      {
         param1.x = this.x;
         param1.y = this.y - param1.height + BlockShape.NotchDepth;
         parent.addChild(param1);
         param1.bottomBlock().insertBlock(this);
      }
      
      public function insertBlockAround(param1:Block) : void
      {
         param1.x = this.x - BlockShape.SubstackInset;
         param1.y = this.y - param1.base.substack1y();
         parent.addChild(param1);
         parent.removeChild(this);
         param1.addChild(this);
         param1.subStack1 = this;
         param1.fixStackLayout();
      }
      
      public function insertBlockSub1(param1:Block) : void
      {
         var _loc2_:Block = this.subStack1;
         if(_loc2_ != null)
         {
            _loc2_.parent.removeChild(_loc2_);
         }
         addChild(param1);
         this.subStack1 = param1;
         if(_loc2_ != null)
         {
            param1.appendBlock(_loc2_);
         }
         this.topBlock().fixStackLayout();
      }
      
      public function insertBlockSub2(param1:Block) : void
      {
         var _loc2_:Block = this.subStack2;
         if(_loc2_ != null)
         {
            removeChild(_loc2_);
         }
         addChild(param1);
         this.subStack2 = param1;
         if(_loc2_ != null)
         {
            param1.appendBlock(_loc2_);
         }
         this.topBlock().fixStackLayout();
      }
      
      public function replaceArgWithBlock(param1:DisplayObject, param2:Block, param3:DisplayObjectContainer) : void
      {
         var _loc5_:Block = null;
         var _loc6_:Point = null;
         var _loc4_:int = this.labelsAndArgs.indexOf(param1);
         if(_loc4_ < 0)
         {
            return;
         }
         removeChild(param1);
         this.labelsAndArgs[_loc4_] = param2;
         addChild(param2);
         this.fixExpressionLayout();
         if(param1 is Block)
         {
            _loc5_ = this.owningBlock();
            _loc6_ = param3.globalToLocal(_loc5_.localToGlobal(new Point(_loc5_.width + 5,(_loc5_.height - param1.height) / 2)));
            param1.x = _loc6_.x;
            param1.y = _loc6_.y;
            param3.addChild(param1);
         }
         this.topBlock().fixStackLayout();
      }
      
      private function appendBlock(param1:Block) : void
      {
         var _loc2_:Block = null;
         if(this.base.canHaveSubstack1() && !this.subStack1)
         {
            this.insertBlockSub1(param1);
         }
         else
         {
            _loc2_ = this.bottomBlock();
            _loc2_.addChild(param1);
            _loc2_.nextBlock = param1;
         }
      }
      
      private function owningBlock() : Block
      {
         var _loc1_:Block = this;
         while(_loc1_.parent is Block)
         {
            _loc1_ = Block(_loc1_.parent);
            if(!_loc1_.isReporter)
            {
               return _loc1_;
            }
         }
         return _loc1_;
      }
      
      public function topBlock() : Block
      {
         var _loc1_:DisplayObject = this;
         while(_loc1_.parent is Block)
         {
            _loc1_ = _loc1_.parent;
         }
         return Block(_loc1_);
      }
      
      public function bottomBlock() : Block
      {
         var _loc1_:Block = this;
         while(_loc1_.nextBlock != null)
         {
            _loc1_ = _loc1_.nextBlock;
         }
         return _loc1_;
      }
      
      private function argOrLabelFor(param1:String, param2:int) : DisplayObject
      {
         var _loc3_:String = null;
         var _loc4_:* = undefined;
         if(param1.length >= 2 && param1.charAt(0) == "%")
         {
            _loc3_ = param1.charAt(1);
            if(_loc3_ == "b")
            {
               return new BlockArg("b",param2);
            }
            if(_loc3_ == "c")
            {
               return new BlockArg("c",param2);
            }
            if(_loc3_ == "d")
            {
               return new BlockArg("d",param2,true,param1.slice(3));
            }
            if(_loc3_ == "m")
            {
               return new BlockArg("m",param2,false,param1.slice(3));
            }
            if(_loc3_ == "n")
            {
               return new BlockArg("n",param2,true);
            }
            if(_loc3_ == "s")
            {
               return new BlockArg("s",param2,true);
            }
         }
         else if(param1.length >= 2 && param1.charAt(0) == "@")
         {
            _loc4_ = Specs.IconNamed(param1.slice(1));
            return _loc4_ ? _loc4_ : this.makeLabel(param1);
         }
         return this.makeLabel(ReadStream.unescape(param1));
      }
      
      private function makeLabel(param1:String) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.autoSize = TextFieldAutoSize.LEFT;
         _loc2_.selectable = false;
         _loc2_.background = false;
         _loc2_.defaultTextFormat = blockLabelFormat;
         _loc2_.text = param1;
         if(useEmbeddedFont)
         {
            _loc2_.antiAliasType = AntiAliasType.ADVANCED;
            _loc2_.embedFonts = true;
         }
         _loc2_.mouseEnabled = false;
         return _loc2_;
      }
      
      public function menu(param1:MouseEvent) : void
      {
         if(MenuHandlerFunction == null)
         {
            return;
         }
         if(this.isEmbeddedInProcHat())
         {
            MenuHandlerFunction(null,parent);
         }
         else
         {
            MenuHandlerFunction(null,this);
         }
      }
      
      public function handleTool(param1:String, param2:MouseEvent) : void
      {
         if(this.isEmbeddedParameter())
         {
            return;
         }
         if(!this.isInPalette())
         {
            if("copy" == param1)
            {
               this.duplicateStack(10,5);
            }
            if("cut" == param1)
            {
               this.deleteStack();
            }
         }
         if(param1 == "help")
         {
            this.showHelp();
         }
      }
      
      public function showHelp() : void
      {
         var _loc1_:String = ExtensionManager.unpackExtensionName(this.op);
         if(_loc1_)
         {
            if(Scratch.app.extensionManager.isInternal(_loc1_))
            {
               Scratch.app.showTip("ext:" + _loc1_);
            }
            else
            {
               DialogBox.notify("Help Missing","There is no documentation available for experimental extension \"" + _loc1_ + "\".",Scratch.app.stage);
            }
         }
         else
         {
            Scratch.app.showTip(this.op);
         }
      }
      
      public function duplicateStack(param1:Number, param2:Number) : void
      {
         if(this.isProcDef() || this.op == "proc_declaration")
         {
            return;
         }
         var _loc3_:Boolean = Boolean(Scratch.app.viewedObj()) && Scratch.app.viewedObj().isStage;
         var _loc4_:Block = BlockIO.stringToStack(BlockIO.stackToString(this),_loc3_);
         var _loc5_:Point = localToGlobal(new Point(0,0));
         _loc4_.x = _loc5_.x + param1;
         _loc4_.y = _loc5_.y + param2;
         Scratch.app.gh.grabOnMouseUp(_loc4_);
      }
      
      public function deleteStack() : Boolean
      {
         if(this.op == "proc_declaration")
         {
            return (parent as Block).deleteStack();
         }
         var _loc1_:Scratch = Scratch.app;
         var _loc2_:Block = this.topBlock();
         if(this.op == Specs.PROCEDURE_DEF && Boolean(_loc1_.runtime.allCallsOf(this.spec,_loc1_.viewedObj(),false).length))
         {
            DialogBox.notify("Cannot Delete","To delete a block definition, first remove all uses of the block.",stage);
            return false;
         }
         if(_loc2_ == this && _loc1_.interp.isRunning(_loc2_,_loc1_.viewedObj()))
         {
            _loc1_.interp.toggleThread(_loc2_,_loc1_.viewedObj());
         }
         if(parent is Block)
         {
            Block(parent).removeBlock(this);
         }
         else if(parent)
         {
            parent.removeChild(this);
         }
         this.cacheAsBitmap = false;
         x = _loc2_.x;
         y = _loc2_.y;
         if(_loc2_ != this)
         {
            x += _loc2_.width + 5;
         }
         _loc1_.runtime.recordForUndelete(this,x,y,0,_loc1_.viewedObj());
         _loc1_.scriptsPane.saveScripts();
         _loc1_.runtime.checkForGraphicEffects();
         _loc1_.updatePalette();
         return true;
      }
      
      public function attachedCommentsIn(param1:ScriptsPane) : Array
      {
         var result:Array;
         var i:int;
         var allBlocks:Array = null;
         var c:ScratchComment = null;
         var scriptsPane:ScriptsPane = param1;
         allBlocks = [];
         this.allBlocksDo(function(param1:Block):void
         {
            allBlocks.push(param1);
         });
         result = [];
         if(!scriptsPane)
         {
            return result;
         }
         i = 0;
         while(i < scriptsPane.numChildren)
         {
            c = scriptsPane.getChildAt(i) as ScratchComment;
            if(Boolean(c) && Boolean(c.blockRef) && allBlocks.indexOf(c.blockRef) != -1)
            {
               result.push(c);
            }
            i++;
         }
         return result;
      }
      
      public function addComment() : void
      {
         var _loc1_:ScriptsPane = this.topBlock().parent as ScriptsPane;
         if(_loc1_)
         {
            _loc1_.addComment(this);
         }
      }
      
      public function objToGrab(param1:MouseEvent) : Block
      {
         if(this.isEmbeddedParameter() || this.isInPalette())
         {
            return this.duplicate(false,Scratch.app.viewedObj() is ScratchStage);
         }
         return this;
      }
      
      public function click(param1:MouseEvent) : void
      {
         if(this.editArg(param1))
         {
            return;
         }
         Scratch.app.runtime.interp.toggleThread(this.topBlock(),Scratch.app.viewedObj(),1);
      }
      
      public function demo() : void
      {
         var _loc1_:Block = this.duplicate(false);
         _loc1_.nextBlock = null;
         _loc1_.visible = false;
         Scratch.app.runtime.interp.toggleThread(_loc1_,Scratch.app.viewedObj(),1);
      }
      
      public function doubleClick(param1:MouseEvent) : void
      {
         if(this.editArg(param1))
         {
            return;
         }
         Scratch.app.runtime.interp.toggleThread(this.topBlock(),Scratch.app.viewedObj(),1);
      }
      
      private function editArg(param1:MouseEvent) : Boolean
      {
         var _loc2_:BlockArg = param1.target as BlockArg;
         if(!_loc2_)
         {
            _loc2_ = param1.target.parent as BlockArg;
         }
         if(Boolean(_loc2_) && Boolean(_loc2_.isEditable) && _loc2_.parent == this)
         {
            _loc2_.startEditing();
            return true;
         }
         return false;
      }
      
      private function focusChange(param1:FocusEvent) : void
      {
         var _loc2_:int = 0;
         var _loc6_:Block = null;
         var _loc7_:Block = null;
         var _loc8_:Block = null;
         var _loc9_:Block = null;
         var _loc10_:Block = null;
         var _loc11_:Block = null;
         var _loc12_:BlockArg = null;
         param1.preventDefault();
         if(param1.target.parent.parent != this)
         {
            return;
         }
         if(this.args.length == 0)
         {
            return;
         }
         var _loc3_:int = -1;
         _loc2_ = 0;
         while(_loc2_ < this.args.length)
         {
            if(this.args[_loc2_] is BlockArg && stage.focus == this.args[_loc2_].field)
            {
               _loc3_ = _loc2_;
            }
            _loc2_++;
         }
         var _loc4_:Block = this;
         var _loc5_:int = param1.shiftKey ? -1 : 1;
         _loc2_ = _loc3_ + _loc5_;
         while(true)
         {
            if(_loc2_ >= _loc4_.args.length)
            {
               _loc6_ = _loc4_.parent as Block;
               if(_loc6_)
               {
                  _loc2_ = _loc6_.args.indexOf(_loc4_);
                  if(_loc2_ != -1)
                  {
                     _loc2_ += _loc5_;
                     _loc4_ = _loc6_;
                     continue;
                  }
               }
               if(_loc4_.subStack1)
               {
                  _loc4_ = _loc4_.subStack1;
               }
               else if(_loc4_.subStack2)
               {
                  _loc4_ = _loc4_.subStack2;
               }
               else
               {
                  _loc7_ = _loc4_;
                  _loc4_ = _loc7_.nextBlock;
                  while(!_loc4_)
                  {
                     _loc8_ = _loc7_.parent as Block;
                     _loc9_ = _loc7_;
                     while(Boolean(_loc8_) && _loc8_.nextBlock == _loc9_)
                     {
                        _loc9_ = _loc8_;
                        _loc8_ = _loc8_.parent as Block;
                     }
                     if(!_loc8_)
                     {
                        return;
                     }
                     _loc4_ = _loc8_.subStack1 == _loc9_ && Boolean(_loc8_.subStack2) ? _loc8_.subStack2 : _loc8_.nextBlock;
                     _loc7_ = _loc8_;
                  }
               }
               _loc2_ = 0;
            }
            else if(_loc2_ < 0)
            {
               _loc6_ = _loc4_.parent as Block;
               if(!_loc6_)
               {
                  break;
               }
               _loc2_ = _loc6_.args.indexOf(_loc4_);
               if(_loc2_ != -1)
               {
                  _loc2_ += _loc5_;
                  _loc4_ = _loc6_;
               }
               else
               {
                  _loc10_ = _loc6_.nextBlock == _loc4_ ? _loc6_.subStack2 || _loc6_.subStack1 : (_loc6_.subStack2 == _loc4_ ? _loc6_.subStack1 : null);
                  if(_loc10_)
                  {
                     while(true)
                     {
                        _loc10_ = _loc10_.bottomBlock();
                        _loc11_ = _loc10_.subStack1 || _loc10_.subStack2;
                        if(!_loc11_)
                        {
                           break;
                        }
                        _loc10_ = _loc11_;
                     }
                     _loc4_ = _loc10_;
                  }
                  else
                  {
                     _loc4_ = _loc6_;
                  }
                  _loc2_ = _loc4_.args.length - 1;
               }
            }
            else if(_loc4_.args[_loc2_] is Block)
            {
               _loc4_ = _loc4_.args[_loc2_];
               _loc2_ = param1.shiftKey ? int(_loc4_.args.length - 1) : 0;
            }
            else
            {
               _loc12_ = _loc4_.args[_loc2_] as BlockArg;
               if(Boolean(_loc12_) && Boolean(_loc12_.field) && _loc12_.isEditable)
               {
                  _loc12_.startEditing();
                  return;
               }
               _loc2_ += _loc5_;
            }
         }
      }
      
      public function getSummary() : String
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:BlockArg = null;
         var _loc5_:Block = null;
         var _loc6_:TextField = null;
         var _loc1_:String = this.type == "r" ? "(" : (this.type == "b" ? "<" : "");
         var _loc2_:Boolean = false;
         for each(_loc3_ in this.labelsAndArgs)
         {
            if(_loc2_)
            {
               _loc1_ += " ";
            }
            _loc2_ = true;
            _loc4_ = _loc3_ as BlockArg;
            if(_loc4_)
            {
               _loc1_ += _loc4_.numberType ? "(" : "[";
               _loc1_ += _loc4_.argValue;
               if(!_loc4_.isEditable)
               {
                  _loc1_ += " v";
               }
               _loc1_ += _loc4_.numberType ? ")" : "]";
            }
            else
            {
               _loc5_ = _loc3_ as Block;
               if(_loc5_)
               {
                  _loc1_ += _loc5_.getSummary();
               }
               else
               {
                  _loc6_ = _loc3_ as TextField;
                  if(_loc6_)
                  {
                     _loc1_ += TextField(_loc3_).text;
                  }
                  else
                  {
                     _loc1_ += "@";
                  }
               }
            }
         }
         if(this.base.canHaveSubstack1())
         {
            _loc1_ += "\n" + (this.subStack1 ? indent(this.subStack1.getSummary()) : "");
            if(this.base.canHaveSubstack2())
            {
               _loc1_ += "\n" + this.elseLabel.text;
               _loc1_ += "\n" + (this.subStack2 ? indent(this.subStack2.getSummary()) : "");
            }
            _loc1_ += "\n" + Translator.map("end");
         }
         if(this.nextBlock)
         {
            _loc1_ += "\n" + this.nextBlock.getSummary();
         }
         return _loc1_ + (this.type == "r" ? ")" : (this.type == "b" ? ">" : ""));
      }
   }
}

