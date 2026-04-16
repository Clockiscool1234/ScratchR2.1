package primitives
{
   import blocks.*;
   import flash.utils.Dictionary;
   import interpreter.*;
   import scratch.ScratchSprite;
   
   public class Primitives
   {
      
      private static const emptyDict:Dictionary = new Dictionary();
      
      private static var lcDict:Dictionary = new Dictionary();
      
      private const MaxCloneCount:int = 300;
      
      protected var app:Scratch;
      
      protected var interp:Interpreter;
      
      private var counter:int;
      
      public function Primitives(param1:Scratch, param2:Interpreter)
      {
         super();
         this.app = param1;
         this.interp = param2;
      }
      
      public static function compare(param1:*, param2:*) : int
      {
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc3_:Number = Interpreter.asNumber(param1);
         var _loc4_:Number = Interpreter.asNumber(param2);
         if(_loc3_ != _loc3_ || _loc4_ != _loc4_)
         {
            if(param1 is String && Boolean(emptyDict[param1]))
            {
               param1 += "_";
            }
            if(param2 is String && Boolean(emptyDict[param2]))
            {
               param2 += "_";
            }
            _loc5_ = lcDict[param1];
            if(!_loc5_)
            {
               _loc5_ = lcDict[param1] = String(param1).toLowerCase();
            }
            _loc6_ = lcDict[param2];
            if(!_loc6_)
            {
               _loc6_ = lcDict[param2] = String(param2).toLowerCase();
            }
            return _loc5_.localeCompare(_loc6_);
         }
         if(_loc3_ < _loc4_)
         {
            return -1;
         }
         if(_loc3_ == _loc4_)
         {
            return 0;
         }
         if(_loc3_ > _loc4_)
         {
            return 1;
         }
         return 1;
      }
      
      public function addPrimsTo(param1:Dictionary) : void
      {
         var primTable:Dictionary = param1;
         primTable["+"] = function(param1:*):*
         {
            return interp.numarg(param1,0) + interp.numarg(param1,1);
         };
         primTable["-"] = function(param1:*):*
         {
            return interp.numarg(param1,0) - interp.numarg(param1,1);
         };
         primTable["*"] = function(param1:*):*
         {
            return interp.numarg(param1,0) * interp.numarg(param1,1);
         };
         primTable["/"] = function(param1:*):*
         {
            return interp.numarg(param1,0) / interp.numarg(param1,1);
         };
         primTable["randomFrom:to:"] = this.primRandom;
         primTable["<"] = function(param1:*):*
         {
            return compare(interp.arg(param1,0),interp.arg(param1,1)) < 0;
         };
         primTable["="] = function(param1:*):*
         {
            return compare(interp.arg(param1,0),interp.arg(param1,1)) == 0;
         };
         primTable[">"] = function(param1:*):*
         {
            return compare(interp.arg(param1,0),interp.arg(param1,1)) > 0;
         };
         primTable["&"] = function(param1:*):*
         {
            return interp.arg(param1,0) && interp.arg(param1,1);
         };
         primTable["|"] = function(param1:*):*
         {
            return interp.arg(param1,0) || interp.arg(param1,1);
         };
         primTable["not"] = function(param1:*):*
         {
            return !interp.arg(param1,0);
         };
         primTable["abs"] = function(param1:*):*
         {
            return Math.abs(interp.numarg(param1,0));
         };
         primTable["sqrt"] = function(param1:*):*
         {
            return Math.sqrt(interp.numarg(param1,0));
         };
         primTable["concatenate:with:"] = function(param1:*):*
         {
            return ("" + interp.arg(param1,0) + interp.arg(param1,1)).substr(0,10240);
         };
         primTable["letter:of:"] = this.primLetterOf;
         primTable["stringLength:"] = function(param1:*):*
         {
            return String(interp.arg(param1,0)).length;
         };
         primTable["%"] = this.primModulo;
         primTable["rounded"] = function(param1:*):*
         {
            return Math.round(interp.numarg(param1,0));
         };
         primTable["computeFunction:of:"] = this.primMathFunction;
         primTable["createCloneOf"] = this.primCreateCloneOf;
         primTable["deleteClone"] = this.primDeleteClone;
         primTable["whenCloned"] = this.interp.primNoop;
         primTable["NOOP"] = this.interp.primNoop;
         primTable["COUNT"] = function(param1:*):*
         {
            return counter;
         };
         primTable["INCR_COUNT"] = function(param1:*):*
         {
            ++counter;
         };
         primTable["CLR_COUNT"] = function(param1:*):*
         {
            counter = 0;
         };
         new LooksPrims(this.app,this.interp).addPrimsTo(primTable);
         new MotionAndPenPrims(this.app,this.interp).addPrimsTo(primTable);
         new SoundPrims(this.app,this.interp).addPrimsTo(primTable);
         new VideoMotionPrims(this.app,this.interp).addPrimsTo(primTable);
         this.addOtherPrims(primTable);
      }
      
      protected function addOtherPrims(param1:Dictionary) : void
      {
         new SensingPrims(this.app,this.interp).addPrimsTo(param1);
         new ListPrims(this.app,this.interp).addPrimsTo(param1);
      }
      
      private function primRandom(param1:Block) : Number
      {
         var _loc2_:Number = this.interp.numarg(param1,0);
         var _loc3_:Number = this.interp.numarg(param1,1);
         var _loc4_:Number = _loc2_ <= _loc3_ ? _loc2_ : _loc3_;
         var _loc5_:Number = _loc2_ <= _loc3_ ? _loc3_ : _loc2_;
         if(_loc4_ == _loc5_)
         {
            return _loc4_;
         }
         var _loc6_:BlockArg = param1.args[0] as BlockArg;
         var _loc7_:BlockArg = param1.args[1] as BlockArg;
         var _loc8_:Boolean = _loc6_ ? _loc6_.numberType == BlockArg.NT_INT : int(_loc2_) == _loc2_;
         var _loc9_:Boolean = _loc7_ ? _loc7_.numberType == BlockArg.NT_INT : int(_loc3_) == _loc3_;
         if(_loc8_ && _loc9_)
         {
            return _loc4_ + int(Math.random() * (_loc5_ + 1 - _loc4_));
         }
         return Math.random() * (_loc5_ - _loc4_) + _loc4_;
      }
      
      private function primLetterOf(param1:Block) : String
      {
         var _loc2_:String = this.interp.arg(param1,1);
         var _loc3_:int = this.interp.numarg(param1,0) - 1;
         if(_loc3_ < 0 || _loc3_ >= _loc2_.length)
         {
            return "";
         }
         return _loc2_.charAt(_loc3_);
      }
      
      private function primModulo(param1:Block) : Number
      {
         var _loc2_:Number = this.interp.numarg(param1,0);
         var _loc3_:Number = this.interp.numarg(param1,1);
         var _loc4_:Number = _loc2_ % _loc3_;
         if(_loc4_ / _loc3_ < 0)
         {
            _loc4_ += _loc3_;
         }
         return _loc4_;
      }
      
      private function primMathFunction(param1:Block) : Number
      {
         var _loc2_:* = this.interp.arg(param1,0);
         var _loc3_:Number = this.interp.numarg(param1,1);
         switch(_loc2_)
         {
            case "abs":
               return Math.abs(_loc3_);
            case "floor":
               return Math.floor(_loc3_);
            case "ceiling":
               return Math.ceil(_loc3_);
            case "int":
               return _loc3_ - _loc3_ % 1;
            case "sqrt":
               return Math.sqrt(_loc3_);
            case "sin":
               return Math.sin(Math.PI * _loc3_ / 180);
            case "cos":
               return Math.cos(Math.PI * _loc3_ / 180);
            case "tan":
               return Math.tan(Math.PI * _loc3_ / 180);
            case "asin":
               return Math.asin(_loc3_) * 180 / Math.PI;
            case "acos":
               return Math.acos(_loc3_) * 180 / Math.PI;
            case "atan":
               return Math.atan(_loc3_) * 180 / Math.PI;
            case "ln":
               return Math.log(_loc3_);
            case "log":
               return Math.log(_loc3_) / Math.LN10;
            case "e ^":
               return Math.exp(_loc3_);
            case "10 ^":
               return Math.pow(10,_loc3_);
            default:
               return 0;
         }
      }
      
      private function primCreateCloneOf(param1:Block) : void
      {
         var _loc5_:Block = null;
         var _loc2_:String = this.interp.arg(param1,0);
         var _loc3_:ScratchSprite = this.app.stagePane.spriteNamed(_loc2_);
         if("_myself_" == _loc2_)
         {
            _loc3_ = this.interp.activeThread.target;
         }
         if(!_loc3_)
         {
            return;
         }
         if(this.app.runtime.cloneCount > this.MaxCloneCount)
         {
            return;
         }
         var _loc4_:ScratchSprite = new ScratchSprite();
         if(_loc3_.parent == this.app.stagePane)
         {
            this.app.stagePane.addChildAt(_loc4_,this.app.stagePane.getChildIndex(_loc3_));
         }
         else
         {
            this.app.stagePane.addChild(_loc4_);
         }
         _loc4_.initFrom(_loc3_,true);
         _loc4_.objName = _loc3_.objName;
         _loc4_.isClone = true;
         for each(_loc5_ in _loc4_.scripts)
         {
            if(_loc5_.op == "whenCloned")
            {
               this.interp.startThreadForClone(_loc5_,_loc4_);
            }
         }
         ++this.app.runtime.cloneCount;
      }
      
      private function primDeleteClone(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null || !_loc2_.isClone || _loc2_.parent == null)
         {
            return;
         }
         if(Boolean(_loc2_.bubble) && Boolean(_loc2_.bubble.parent))
         {
            _loc2_.bubble.parent.removeChild(_loc2_.bubble);
            _loc2_.bubble = null;
         }
         _loc2_.parent.removeChild(_loc2_);
         this.app.interp.stopThreadsFor(_loc2_);
         --this.app.runtime.cloneCount;
      }
   }
}

