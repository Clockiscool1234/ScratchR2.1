package com.adobe.utils
{
   import com.adobe.utils.macro.AGALPreAssembler;
   import com.adobe.utils.macro.AGALVar;
   import flash.utils.*;
   
   public class AGALMacroAssembler extends AGALMiniAssembler
   {
      
      private static const REGEXP_LINE_BREAKER:RegExp = /[\f\n\r\v;]+/g;
      
      private static const COMMENT:RegExp = /\/\/[^\n]*\n/g;
      
      public static const IDENTIFIER:RegExp = /((2d)|(3d)|[_a-zA-Z])+([_a-zA-Z0-9.]*)/;
      
      public static const NUMBER:RegExp = /[0-9]+(?:\.[0-9]*)?/;
      
      public static const OPERATOR:RegExp = /(==)|(!=)|(<=)|(>=)|(&&)|(\|\|)|[*=+-\/()\[\]{}!<>&|]/;
      
      public static const SEPERATOR:RegExp = /\n/;
      
      public static const PREPROC:RegExp = /\#[a-z]+/;
      
      public static const TOKEN:RegExp = new RegExp(IDENTIFIER.source + "|" + NUMBER.source + "|" + SEPERATOR.source + "|" + OPERATOR.source + "|" + PREPROC.source,"g");
      
      private static const MACRO:RegExp = /([\w.]+)(\s*)=(\s*)(\w+)(\s*)\(/;
      
      public static const STDLIB:String = "macro mul3x3( vec, mat ) {" + "\tm33 out, vec, mat; " + "}" + "macro mul4x4( vec, mat ) {" + "\tm44 out, vec, mat; " + "}\n";
      
      public var asmCode:String = "";
      
      private var isFrag:Boolean = false;
      
      public var profile:Boolean = false;
      
      public var profileTrace:String = "";
      
      private var stages:Vector.<PerfStage> = null;
      
      private var macros:Dictionary = new Dictionary();
      
      public var aliases:Dictionary = new Dictionary();
      
      private var tokens:Vector.<String> = null;
      
      private var types:String = "";
      
      private var preproc:AGALPreAssembler = new AGALPreAssembler();
      
      private var emptyStringVector:Vector.<String> = new Vector.<String>(0,true);
      
      public function AGALMacroAssembler(param1:Boolean = false)
      {
         super(param1);
      }
      
      public static function joinTokens(param1:Vector.<String>) : String
      {
         var _loc2_:* = 0;
         var _loc3_:int = 0;
         var _loc4_:String = "";
         var _loc5_:uint = param1.length;
         while(_loc2_ < _loc5_)
         {
            if(param1[_loc2_] == "\n")
            {
               _loc2_++;
            }
            else
            {
               _loc3_ = param1.indexOf("\n",_loc2_ + 1);
               if(_loc3_ < 0)
               {
                  _loc3_ = int(_loc5_);
               }
               _loc4_ += param1[_loc2_++];
               if(_loc2_ < _loc5_ && param1[_loc2_] != ".")
               {
                  _loc4_ += " ";
               }
               while(_loc2_ < _loc3_)
               {
                  _loc4_ += param1[_loc2_];
                  if(param1[_loc2_] == ",")
                  {
                     _loc4_ += " ";
                  }
                  _loc2_++;
               }
               _loc4_ += "\n";
               _loc2_ = int(_loc3_ + 1);
            }
         }
         return _loc4_;
      }
      
      private function cleanInput(param1:String) : String
      {
         var _loc3_:int = 0;
         var _loc2_:int = param1.indexOf("/*");
         while(_loc2_ >= 0)
         {
            _loc3_ = param1.indexOf("*/",_loc2_ + 1);
            if(_loc3_ < 0)
            {
               throw new Error("Comment end not found.");
            }
            param1 = param1.substr(0,_loc2_) + param1.substr(_loc3_ + 2);
            _loc2_ = param1.indexOf("/*");
         }
         param1 = param1.replace(COMMENT,"\n");
         return param1.replace(REGEXP_LINE_BREAKER,"\n");
      }
      
      private function tokenize(param1:String) : Vector.<String>
      {
         return Vector.<String>(param1.match(TOKEN));
      }
      
      private function tokenizeTypes(param1:Vector.<String>) : String
      {
         var _loc5_:String = null;
         var _loc2_:String = "";
         var _loc3_:uint = param1.length;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_.search(IDENTIFIER) == 0)
            {
               _loc2_ += "i";
            }
            else if(_loc5_.search(NUMBER) == 0)
            {
               _loc2_ += "0";
            }
            else if(_loc5_.search(SEPERATOR) == 0)
            {
               _loc2_ += "n";
            }
            else if(_loc5_.search(OPERATOR) == 0)
            {
               if(_loc5_.length == 1)
               {
                  _loc2_ += _loc5_;
               }
               else
               {
                  _loc2_ += "2";
               }
            }
            else
            {
               if(_loc5_.search(PREPROC) != 0)
               {
                  throw new Error("Unrecognized token: " + param1[_loc4_]);
               }
               _loc2_ += "#";
            }
            _loc4_++;
         }
         if(_loc2_.length != param1.length)
         {
            throw new Error("Tokens and types must have the same length.");
         }
         return _loc2_;
      }
      
      private function createMangledName(param1:String, param2:int) : String
      {
         return param1 + "-" + param2;
      }
      
      private function splice(param1:int, param2:int, param3:Vector.<String>, param4:String) : void
      {
         if(param3 == null)
         {
            param3 = this.emptyStringVector;
         }
         if(param4 == null)
         {
            param4 = "";
         }
         var _loc5_:Vector.<String> = this.tokens.slice(0,param1);
         _loc5_ = _loc5_.concat(param3);
         _loc5_ = _loc5_.concat(this.tokens.slice(param1 + param2));
         this.tokens = _loc5_;
         this.types = this.types.substr(0,param1) + param4 + this.types.substr(param1 + param2);
         if(this.types.length != this.tokens.length)
         {
            throw new Error("AGAL.splice internal error. types.length=" + this.types.length + " tokens.length=" + this.tokens.length);
         }
      }
      
      private function basicOp(param1:String, param2:String, param3:String, param4:String) : String
      {
         return param1 + " " + param2 + ", " + param3 + ", " + param4;
      }
      
      private function convertMath(param1:int) : Boolean
      {
         var _loc5_:Vector.<String> = null;
         var _loc6_:String = null;
         var _loc2_:int = this.types.indexOf("n",param1 + 1);
         if(_loc2_ < param1 + 1)
         {
            throw new Error("End of expression not found.");
         }
         var _loc3_:String = "";
         var _loc4_:String = this.types.substr(param1,_loc2_ - param1);
         switch(_loc4_)
         {
            case "i=i":
               _loc3_ = "mov " + this.tokens[param1 + 0] + ", " + this.tokens[param1 + 2];
               break;
            case "i=i+i":
               _loc3_ = this.basicOp("add",this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]);
               break;
            case "i=i-i":
               _loc3_ = this.basicOp("sub",this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]);
               break;
            case "i=i*i":
               _loc3_ = this.basicOp("mul",this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]);
               break;
            case "i=i/i":
               _loc3_ = this.basicOp("div",this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]);
               break;
            case "i=-i":
               _loc3_ = "neg " + this.tokens[param1 + 0] + ", " + this.tokens[param1 + 3];
               break;
            case "i*=i":
               _loc3_ = this.basicOp("mul",this.tokens[param1 + 0],this.tokens[param1 + 0],this.tokens[param1 + 3]);
               break;
            case "i/=i":
               _loc3_ = this.basicOp("div",this.tokens[param1 + 0],this.tokens[param1 + 0],this.tokens[param1 + 3]);
               break;
            case "i+=i":
               _loc3_ = this.basicOp("add",this.tokens[param1 + 0],this.tokens[param1 + 0],this.tokens[param1 + 3]);
               break;
            case "i-=i":
               _loc3_ = this.basicOp("sub",this.tokens[param1 + 0],this.tokens[param1 + 0],this.tokens[param1 + 3]);
               break;
            case "i=i*i+i":
               _loc3_ = this.basicOp("mul",this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]) + "\n" + this.basicOp("add",this.tokens[param1 + 0],this.tokens[param1 + 0],this.tokens[param1 + 6]);
               break;
            case "i=i+i*i":
               _loc3_ = this.basicOp("mul",this.tokens[param1 + 0],this.tokens[param1 + 4],this.tokens[param1 + 6]) + "\n" + this.basicOp("add",this.tokens[param1 + 0],this.tokens[param1 + 0],this.tokens[param1 + 2]);
               break;
            case "i=i<i":
               _loc3_ = this.basicOp("slt",this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]);
               break;
            case "i=i2i":
               switch(this.tokens[param1 + 3])
               {
                  case ">=":
                     _loc3_ = this.basicOp("sge",this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]);
                     break;
                  case "==":
                     _loc3_ = this.basicOp("seq",this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]);
                     break;
                  case "!=":
                     _loc3_ = this.basicOp("sne",this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]);
                     break;
                  default:
                     _loc3_ = this.basicOp(this.tokens[param1 + 3],this.tokens[param1 + 0],this.tokens[param1 + 2],this.tokens[param1 + 4]);
               }
               break;
            default:
               return false;
         }
         if(_loc3_.length > 0)
         {
            _loc5_ = this.tokenize(_loc3_);
            _loc6_ = this.tokenizeTypes(_loc5_);
            this.splice(param1,_loc2_ - param1,_loc5_,_loc6_);
         }
         return true;
      }
      
      private function processMacro(param1:int) : void
      {
         var _loc2_:int = 1;
         var _loc3_:int = 2;
         var _loc4_:int = 3;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:int = 0;
         if(this.tokens[param1] != "macro")
         {
            throw new Error("Expected \'macro\' not found.");
         }
         _loc5_ = param1 + _loc3_;
         if(this.tokens[_loc5_] != "(")
         {
            throw new Error("Macro open paren not found.");
         }
         _loc6_ = this.types.indexOf(")",_loc5_ + 1);
         _loc7_ = this.types.indexOf("{",_loc6_ + 1);
         _loc8_ = this.types.indexOf("}",_loc7_ + 1);
         var _loc10_:Macro = new Macro();
         _loc10_.name = this.tokens[param1 + _loc2_];
         var _loc11_:int = 0;
         _loc9_ = _loc5_ + 1;
         while(_loc9_ < _loc6_)
         {
            if(this.types.charAt(_loc9_) == "i")
            {
               _loc10_.args.push(this.tokens[_loc9_]);
               _loc11_++;
            }
            _loc9_++;
         }
         _loc10_.mangledName = this.createMangledName(_loc10_.name,_loc11_);
         _loc9_ = _loc7_ + 1;
         while(_loc9_ < _loc8_)
         {
            _loc10_.body.push(this.tokens[_loc9_]);
            _loc9_++;
         }
         _loc10_.types = this.types.substr(_loc7_ + 1,_loc8_ - _loc7_ - 1);
         this.splice(param1,_loc8_ - param1 + 1,this.emptyStringVector,"");
         this.macros[_loc10_.mangledName] = _loc10_;
      }
      
      private function expandTexture(param1:int) : int
      {
         var _loc2_:int = this.types.indexOf("(",param1);
         var _loc3_:int = this.types.indexOf(")",_loc2_ + 1);
         var _loc4_:int = this.types.indexOf("<",param1);
         var _loc5_:int = this.types.indexOf(">",_loc4_ + 1);
         var _loc6_:int = this.types.indexOf("n",param1);
         if(_loc6_ < 0)
         {
            _loc6_ = this.types.length;
         }
         var _loc7_:String = "tex " + this.tokens[param1] + "," + this.tokens[_loc2_ + 1] + "," + this.tokens[_loc2_ + 3] + "<" + this.tokens.slice(_loc4_ + 1,_loc5_).join("") + ">;";
         var _loc8_:Vector.<String> = this.tokenize(_loc7_);
         var _loc9_:String = this.tokenizeTypes(_loc8_);
         this.splice(param1,_loc6_ - param1,_loc8_,_loc9_);
         return param1 + _loc9_.length;
      }
      
      private function expandMacro(param1:int) : void
      {
         var _loc14_:Boolean = false;
         var _loc15_:int = 0;
         var _loc2_:int = 2;
         var _loc3_:int = 3;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         var _loc6_:String = this.tokens[param1 + _loc2_];
         _loc4_ = this.types.indexOf(")",param1 + _loc3_) - param1;
         var _loc7_:int = (_loc4_ - _loc3_) / 2;
         var _loc8_:String = this.createMangledName(_loc6_,_loc7_);
         if(this.macros[_loc8_] == null)
         {
            throw new Error("Macro \'" + _loc8_ + "\' not found.");
         }
         var _loc9_:Macro = this.macros[_loc8_];
         var _loc10_:String = this.tokens[param1];
         var _loc11_:Vector.<String> = this.tokens.slice(param1 + _loc3_ + 1,param1 + _loc4_);
         var _loc12_:Vector.<String> = new Vector.<String>();
         var _loc13_:uint = _loc9_.body.length;
         _loc5_ = 0;
         while(_loc5_ < _loc13_)
         {
            _loc14_ = false;
            if(_loc9_.types.charAt(_loc5_) == "i")
            {
               if(_loc9_.body[_loc5_].substr(0,3) == "out")
               {
                  _loc12_.push(_loc10_ + _loc9_.body[_loc5_].substr(3));
                  _loc14_ = true;
               }
               else
               {
                  _loc15_ = _loc9_.args.indexOf(_loc9_.body[_loc5_]);
                  if(_loc15_ >= 0)
                  {
                     _loc12_.push(_loc11_[2 * _loc15_]);
                     _loc14_ = true;
                  }
               }
            }
            if(!_loc14_)
            {
               _loc12_.push(_loc9_.body[_loc5_]);
            }
            _loc5_++;
         }
         this.splice(param1,_loc4_ + 1,_loc12_,_loc9_.types);
      }
      
      private function getConstant(param1:String) : String
      {
         var _loc3_:AGALVar = null;
         var _loc2_:Number = Number(param1);
         for each(_loc3_ in this.aliases)
         {
            if(_loc3_.isConstant())
            {
               if(_loc3_.x == _loc2_)
               {
                  return _loc3_.target + ".x";
               }
               if(_loc3_.y == _loc2_)
               {
                  return _loc3_.target + ".y";
               }
               if(_loc3_.z == _loc2_)
               {
                  return _loc3_.target + ".z";
               }
               if(_loc3_.w == _loc2_)
               {
                  return _loc3_.target + ".w";
               }
            }
         }
         throw new Error("Numeric constant used that is not declared in a constant register.");
      }
      
      private function readAlias(param1:int) : void
      {
         var _loc2_:AGALVar = null;
         var _loc3_:int = 0;
         if(this.tokens[param1] == "alias")
         {
            _loc2_ = new AGALVar();
            _loc2_.name = this.tokens[param1 + 3];
            _loc2_.target = this.tokens[param1 + 1];
            this.aliases[_loc2_.name] = _loc2_;
            if(this.tokens[param1 + 4] == "(")
            {
               _loc3_ = this.tokens.indexOf(")",param1 + 5);
               if(_loc3_ < 0)
               {
                  throw new Error("Closing paren of default alias value not found.");
               }
               _loc2_.x = 0;
               _loc2_.y = 0;
               _loc2_.z = 0;
               _loc2_.w = 0;
               if(_loc3_ > param1 + 5)
               {
                  _loc2_.x = Number(this.tokens[param1 + 5]);
               }
               if(_loc3_ > param1 + 7)
               {
                  _loc2_.y = Number(this.tokens[param1 + 7]);
               }
               if(_loc3_ > param1 + 9)
               {
                  _loc2_.z = Number(this.tokens[param1 + 9]);
               }
               if(_loc3_ > param1 + 11)
               {
                  _loc2_.w = Number(this.tokens[param1 + 11]);
               }
            }
         }
      }
      
      private function processTokens(param1:int, param2:int) : int
      {
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:AGALVar = null;
         var _loc3_:* = 0;
         if(this.types.length >= 4 && this.types.substr(param1,4) == "i=i(")
         {
            this.expandMacro(param1);
            return param1;
         }
         if(this.types.length >= 4 && this.types.substr(param1,4) == "i=i<" && this.tokens[param1 + 2] == "tex")
         {
            return this.expandTexture(param1);
         }
         if(this.tokens[param1] == "alias")
         {
            this.readAlias(param1);
            this.splice(param1,param2 - param1 + 1,null,null);
            return param1;
         }
         if(this.tokens[param1] == "macro")
         {
            this.processMacro(param1);
            return param1;
         }
         var _loc4_:int = param1;
         while(_loc4_ < param2)
         {
            _loc5_ = this.types.charAt(_loc4_);
            if(_loc5_ == "[")
            {
               _loc3_++;
            }
            else if(_loc5_ == "]")
            {
               _loc3_--;
            }
            else if(_loc5_ == "0")
            {
               if(_loc3_ == 0)
               {
                  this.tokens[_loc4_] = this.getConstant(this.tokens[_loc4_]);
                  this.types = this.types.substr(0,_loc4_) + "i" + this.types.substr(_loc4_ + 1);
               }
            }
            else if(_loc5_ == "i")
            {
               _loc6_ = this.tokens[_loc4_].indexOf(".");
               if(_loc6_ < 0)
               {
                  _loc6_ = this.tokens[_loc4_].length;
               }
               _loc7_ = this.aliases[this.tokens[_loc4_].substr(0,_loc6_)];
               if(_loc7_ != null)
               {
                  this.tokens[_loc4_] = _loc7_.target + this.tokens[_loc4_].substr(_loc6_);
               }
            }
            _loc4_++;
         }
         if(this.convertMath(param1))
         {
            param2 = this.types.indexOf("n",param1 + 1);
            if(param2 < 0)
            {
               param2 = this.types.length;
            }
         }
         return param2 + 1;
      }
      
      private function mainLoop() : void
      {
         var _loc4_:String = null;
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:Boolean = true;
         while(_loc1_ < this.tokens.length)
         {
            while(_loc1_ < this.tokens.length && this.types.charAt(_loc1_) == "n")
            {
               _loc1_++;
            }
            if(_loc1_ == this.tokens.length)
            {
               break;
            }
            _loc2_ = this.types.indexOf("n",_loc1_ + 1);
            if(_loc2_ < 0)
            {
               _loc2_ = this.types.length;
            }
            _loc4_ = this.types.charAt(_loc1_);
            if(_loc4_ == "#")
            {
               if(this.preproc == null)
               {
                  this.preproc = new AGALPreAssembler();
               }
               _loc3_ = this.preproc.processLine(this.tokens.slice(_loc1_,_loc2_),this.types.substr(_loc1_,_loc2_ - _loc1_));
               this.splice(_loc1_,_loc2_ - _loc1_ + 1,null,null);
            }
            else if(_loc3_)
            {
               _loc1_ = this.processTokens(_loc1_,_loc2_);
            }
            else
            {
               this.splice(_loc1_,_loc2_ - _loc1_ + 1,null,null);
            }
         }
      }
      
      override public function assemble(param1:String, param2:String) : ByteArray
      {
         var _loc4_:uint = 0;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         if(this.profile)
         {
            _loc4_ = uint(getTimer());
            this.stages = new Vector.<PerfStage>();
            this.stages.push(new PerfStage("start"));
         }
         this.isFrag = param1 == "fragment";
         param2 = STDLIB + param2;
         this.aliases = new Dictionary();
         param2 = this.cleanInput(param2);
         this.tokens = this.tokenize(param2);
         this.types = this.tokenizeTypes(this.tokens);
         this.mainLoop();
         if(this.profile)
         {
            this.stages.push(new PerfStage("join"));
         }
         this.asmCode = joinTokens(this.tokens);
         if(this.profile)
         {
            this.stages.push(new PerfStage("mini"));
         }
         var _loc3_:ByteArray = super.assemble(param1,this.asmCode);
         if(this.profile)
         {
            this.stages.push(new PerfStage("end"));
            _loc5_ = 0;
            while(_loc5_ < this.stages.length - 1)
            {
               _loc6_ = this.stages[_loc5_].name + " --> " + this.stages[_loc5_ + 1].name + " = " + (this.stages[_loc5_ + 1].time - this.stages[_loc5_].time) / 1000;
               this.profileTrace += _loc6_ + "\n";
               _loc5_++;
            }
         }
         return _loc3_;
      }
   }
}

import flash.utils.getTimer;

class Macro
{
   
   public var mangledName:String = "";
   
   public var name:String = "";
   
   public var args:Vector.<String> = new Vector.<String>();
   
   public var body:Vector.<String> = new Vector.<String>();
   
   public var types:String = "";
   
   public function Macro()
   {
      super();
   }
   
   public function traceMacro() : void
   {
      var _loc1_:String = AGALMacroAssembler.joinTokens(this.body);
   }
}

class PerfStage
{
   
   public var name:String;
   
   public var time:uint;
   
   public function PerfStage(param1:String)
   {
      super();
      this.name = param1;
      this.time = getTimer();
   }
}
