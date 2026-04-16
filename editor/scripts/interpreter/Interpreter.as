package interpreter
{
   import blocks.*;
   import extensions.ExtensionManager;
   import flash.geom.Point;
   import flash.utils.Dictionary;
   import primitives.*;
   import scratch.*;
   import sound.*;
   import util.CachedTimer;
   
   public class Interpreter
   {
      
      public var activeThread:Thread;
      
      public var currentMSecs:int;
      
      public var turboMode:Boolean = false;
      
      private var app:Scratch;
      
      private var primTable:Dictionary;
      
      private var threads:Array = [];
      
      private var yield:Boolean;
      
      private var startTime:int;
      
      private var doRedraw:Boolean;
      
      private var isWaiting:Boolean;
      
      private const warpMSecs:int = 500;
      
      private var warpThread:Thread;
      
      private var warpBlock:Block;
      
      private var bubbleThread:Thread;
      
      public var askThread:Thread;
      
      protected var debugFunc:Function;
      
      private const workTimeCheckIntervalFactor:Number = 0.3333333333333333;
      
      private const maxIterationCountSamples:uint = 10;
      
      private var iterationCountSamples:Vector.<uint> = new <uint>[500];
      
      public function Interpreter(param1:Scratch)
      {
         super();
         this.app = param1;
         this.initPrims();
      }
      
      public static function asNumber(param1:*) : Number
      {
         var _loc2_:String = null;
         var _loc3_:uint = 0;
         var _loc4_:int = 0;
         var _loc5_:uint = 0;
         if(typeof param1 == "string")
         {
            _loc2_ = param1 as String;
            _loc3_ = uint(_loc2_.length);
            _loc4_ = 0;
            while(_loc4_ < _loc3_)
            {
               _loc5_ = _loc2_.charCodeAt(_loc4_);
               if(_loc5_ >= 48 && _loc5_ <= 57)
               {
                  return Number(_loc2_);
               }
               _loc4_++;
            }
            return NaN;
         }
         return Number(param1);
      }
      
      public function targetObj() : ScratchObj
      {
         return this.app.runtime.currentDoObj ? this.app.runtime.currentDoObj : this.activeThread.target;
      }
      
      public function targetSprite() : ScratchSprite
      {
         return (this.app.runtime.currentDoObj ? this.app.runtime.currentDoObj : this.activeThread.target) as ScratchSprite;
      }
      
      public function doYield() : void
      {
         this.isWaiting = true;
         this.yield = true;
      }
      
      public function redraw() : void
      {
         if(!this.turboMode)
         {
            this.doRedraw = true;
         }
      }
      
      public function yieldOneCycle() : void
      {
         if(this.activeThread == this.warpThread)
         {
            return;
         }
         if(this.activeThread.firstTime)
         {
            this.redraw();
            this.yield = true;
            this.activeThread.firstTime = false;
         }
      }
      
      public function threadCount() : int
      {
         return this.threads.length;
      }
      
      public function toggleThread(param1:Block, param2:*, param3:int = 0, param4:Boolean = false) : void
      {
         var i:int = 0;
         var topBlock:Block = null;
         var t:Thread = null;
         var reporter:Block = null;
         var interp:Interpreter = null;
         var b:Block = param1;
         var targetObj:* = param2;
         var startupDelay:int = param3;
         var isBackground:Boolean = param4;
         var newThreads:Array = [];
         var wasRunning:Boolean = false;
         i = 0;
         while(i < this.threads.length)
         {
            if(this.threads[i].topBlock == b && this.threads[i].target == targetObj)
            {
               wasRunning = true;
            }
            else
            {
               newThreads.push(this.threads[i]);
            }
            i++;
         }
         this.threads = newThreads;
         if(wasRunning)
         {
            if(this.app.editMode)
            {
               b.hideRunFeedback();
            }
            this.clearWarpBlock();
         }
         else
         {
            topBlock = b;
            if(b.isReporter)
            {
               if(this.bubbleThread)
               {
                  this.toggleThread(this.bubbleThread.topBlock,this.bubbleThread.target);
               }
               reporter = b;
               interp = this;
               b = new Block("%s","",-1);
               b.opFunction = function(param1:Block):void
               {
                  var _loc2_:Point = reporter.localToGlobal(new Point(0,0));
                  app.showBubble(String(interp.arg(param1,0)),_loc2_.x,_loc2_.y,reporter.getRect(app.stage).width);
               };
               b.args[0] = reporter;
            }
            if(this.app.editMode && !isBackground)
            {
               topBlock.showRunFeedback();
            }
            t = new Thread(b,targetObj,startupDelay);
            if(topBlock.isReporter)
            {
               this.bubbleThread = t;
            }
            t.topBlock = topBlock;
            this.threads.push(t);
            this.app.threadStarted();
         }
      }
      
      public function showAllRunFeedback() : void
      {
         var _loc1_:Thread = null;
         for each(_loc1_ in this.threads)
         {
            _loc1_.topBlock.showRunFeedback();
         }
      }
      
      public function isRunning(param1:Block, param2:ScratchObj) : Boolean
      {
         var _loc3_:Thread = null;
         for each(_loc3_ in this.threads)
         {
            if(_loc3_.topBlock == param1 && _loc3_.target == param2)
            {
               return true;
            }
         }
         return false;
      }
      
      public function startThreadForClone(param1:Block, param2:*) : void
      {
         this.threads.push(new Thread(param1,param2));
      }
      
      public function stopThreadsFor(param1:*, param2:Boolean = false) : void
      {
         var _loc4_:Thread = null;
         var _loc3_:int = 0;
         while(_loc3_ < this.threads.length)
         {
            _loc4_ = this.threads[_loc3_];
            if(!(param2 && _loc4_ == this.activeThread))
            {
               if(_loc4_.target == param1)
               {
                  if(_loc4_.tmpObj is ScratchSoundPlayer)
                  {
                     (_loc4_.tmpObj as ScratchSoundPlayer).stopPlaying();
                  }
                  if(this.askThread == _loc4_)
                  {
                     this.app.runtime.clearAskPrompts();
                  }
                  _loc4_.stop();
               }
            }
            _loc3_++;
         }
         if(this.activeThread.target == param1 && !param2)
         {
            this.yield = true;
         }
      }
      
      public function restartThread(param1:Block, param2:*) : Thread
      {
         var _loc3_:Thread = new Thread(param1,param2);
         var _loc4_:Boolean = false;
         var _loc5_:int = 0;
         while(_loc5_ < this.threads.length)
         {
            if(this.threads[_loc5_].topBlock == param1 && this.threads[_loc5_].target == param2)
            {
               if(this.askThread == this.threads[_loc5_])
               {
                  this.app.runtime.clearAskPrompts();
               }
               this.threads[_loc5_] = _loc3_;
               _loc4_ = true;
            }
            _loc5_++;
         }
         if(!_loc4_)
         {
            this.threads.push(_loc3_);
            if(this.app.editMode)
            {
               param1.showRunFeedback();
            }
            this.app.threadStarted();
         }
         return _loc3_;
      }
      
      public function stopAllThreads() : void
      {
         this.threads = [];
         if(this.activeThread != null)
         {
            this.activeThread.stop();
         }
         this.app.runtime.clearAskPrompts();
         this.clearWarpBlock();
         this.app.runtime.clearRunFeedback();
         this.doRedraw = true;
      }
      
      private function addIterationCountSample(param1:uint) : void
      {
         this.iterationCountSamples.push(param1);
         while(this.iterationCountSamples.length > this.maxIterationCountSamples)
         {
            this.iterationCountSamples.shift();
         }
      }
      
      private function getAverageIterationCount() : Number
      {
         var _loc2_:uint = 0;
         var _loc1_:uint = 0;
         for each(_loc2_ in this.iterationCountSamples)
         {
            _loc1_ += _loc2_;
         }
         return Number(_loc1_) / this.iterationCountSamples.length;
      }
      
      public function stepThreads() : void
      {
         var _loc7_:Boolean = false;
         var _loc8_:int = 0;
         var _loc9_:Array = null;
         var _loc10_:Thread = null;
         var _loc1_:int = 0.75 * 1000 / this.app.stage.frameRate;
         this.doRedraw = false;
         this.startTime = this.currentMSecs = CachedTimer.getFreshTimer();
         if(this.threads.length == 0)
         {
            return;
         }
         var _loc2_:Number = this.getAverageIterationCount();
         var _loc3_:uint = 0;
         var _loc4_:uint = Math.round(this.workTimeCheckIntervalFactor * _loc2_);
         var _loc5_:uint = 0;
         while(this.currentMSecs - this.startTime < _loc1_)
         {
            if(Boolean(this.warpThread) && this.warpThread.block == null)
            {
               this.clearWarpBlock();
            }
            _loc7_ = false;
            _loc8_ = 0;
            for each(this.activeThread in this.threads)
            {
               this.isWaiting = false;
               this.stepActiveThread();
               if(this.activeThread.block == null)
               {
                  _loc7_ = true;
               }
               if(!this.isWaiting)
               {
                  _loc8_++;
               }
            }
            if(_loc7_)
            {
               _loc9_ = [];
               for each(_loc10_ in this.threads)
               {
                  if(_loc10_.block != null)
                  {
                     _loc9_.push(_loc10_);
                  }
                  else if(this.app.editMode)
                  {
                     if(_loc10_ == this.bubbleThread)
                     {
                        this.bubbleThread = null;
                     }
                     _loc10_.topBlock.hideRunFeedback();
                  }
               }
               this.threads = _loc9_;
               if(this.threads.length == 0)
               {
                  return;
               }
            }
            if(this.doRedraw || _loc8_ == 0)
            {
               return;
            }
            _loc3_++;
            _loc5_++;
            if(_loc5_ >= _loc4_)
            {
               this.currentMSecs = CachedTimer.getFreshTimer();
               _loc5_ = 0;
            }
         }
         var _loc6_:uint = Math.round(_loc1_ * _loc3_ / Number(this.currentMSecs - this.startTime));
         this.addIterationCountSample(_loc6_);
      }
      
      private function stepActiveThread() : void
      {
         if(this.activeThread.block == null)
         {
            return;
         }
         if(this.activeThread.startDelayCount > 0)
         {
            --this.activeThread.startDelayCount;
            this.doRedraw = true;
            return;
         }
         if(!(this.activeThread.target.isStage || this.activeThread.target.parent is ScratchStage))
         {
            if(this.app.editMode)
            {
               this.doRedraw = true;
               return;
            }
         }
         this.yield = false;
         var _loc1_:int = CachedTimer.getCachedTimer();
         while(true)
         {
            if(this.activeThread == this.warpThread)
            {
               this.currentMSecs = _loc1_;
            }
            this.evalCmd(this.activeThread.block);
            if(this.yield)
            {
               if(this.activeThread != this.warpThread)
               {
                  break;
               }
               if(this.currentMSecs - this.startTime > this.warpMSecs)
               {
                  return;
               }
               this.yield = false;
               _loc1_ = CachedTimer.getFreshTimer();
            }
            else
            {
               if(this.activeThread.block != null)
               {
                  this.activeThread.block = this.activeThread.block.nextBlock;
               }
               while(this.activeThread.block == null)
               {
                  if(!this.activeThread.popState())
                  {
                     return;
                  }
                  if(this.activeThread.block == this.warpBlock && this.activeThread.firstTime)
                  {
                     this.clearWarpBlock();
                     this.activeThread.block = this.activeThread.block.nextBlock;
                  }
                  else if(this.activeThread.isLoop)
                  {
                     if(this.activeThread != this.warpThread)
                     {
                        return;
                     }
                     if(this.currentMSecs - this.startTime > this.warpMSecs)
                     {
                        return;
                     }
                  }
                  else
                  {
                     if(this.activeThread.block.op == Specs.CALL)
                     {
                        this.activeThread.firstTime = true;
                     }
                     this.activeThread.block = this.activeThread.block.nextBlock;
                  }
               }
            }
         }
      }
      
      private function clearWarpBlock() : void
      {
         this.warpThread = null;
         this.warpBlock = null;
      }
      
      public function evalCmd(param1:Block) : *
      {
         if(!param1)
         {
            return 0;
         }
         var _loc2_:String = param1.op;
         if(param1.opFunction == null)
         {
            if(ExtensionManager.hasExtensionPrefix(_loc2_))
            {
               param1.opFunction = this.app.extensionManager.primExtensionOp;
            }
            else
            {
               param1.opFunction = this.primTable[_loc2_] == undefined ? this.primNoop : this.primTable[_loc2_];
            }
         }
         if(Boolean(param1.args.length) && this.checkBlockingArgs(param1))
         {
            this.doYield();
            return null;
         }
         if(this.debugFunc != null)
         {
            this.debugFunc(param1);
         }
         return param1.opFunction(param1);
      }
      
      public function checkBlockingArgs(param1:Block) : Boolean
      {
         var _loc5_:Block = null;
         var _loc2_:Boolean = false;
         var _loc3_:Array = param1.args;
         var _loc4_:uint = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_] as Block;
            if(_loc5_)
            {
               if(this.checkBlockingArgs(_loc5_))
               {
                  _loc2_ = true;
               }
               else if(_loc5_.isRequester && _loc5_.requestState < 2)
               {
                  if(_loc5_.requestState == 0)
                  {
                     this.evalCmd(_loc5_);
                  }
                  _loc2_ = true;
               }
            }
            _loc4_++;
         }
         return _loc2_;
      }
      
      public function arg(param1:Block, param2:int) : *
      {
         var _loc3_:Array = param1.args;
         if(param1.rightToLeft)
         {
            param2 = _loc3_.length - param2 - 1;
         }
         return param1.args[param2] is BlockArg ? BlockArg(_loc3_[param2]).argValue : this.evalCmd(Block(_loc3_[param2]));
      }
      
      public function numarg(param1:Block, param2:int) : Number
      {
         var _loc3_:Array = param1.args;
         if(param1.rightToLeft)
         {
            param2 = _loc3_.length - param2 - 1;
         }
         var _loc4_:Number = _loc3_[param2] is BlockArg ? Number(BlockArg(_loc3_[param2]).argValue) : Number(this.evalCmd(Block(_loc3_[param2])));
         if(_loc4_ != _loc4_)
         {
            return 0;
         }
         return _loc4_;
      }
      
      public function boolarg(param1:Block, param2:int) : Boolean
      {
         var _loc4_:String = null;
         if(param1.rightToLeft)
         {
            param2 = param1.args.length - param2 - 1;
         }
         var _loc3_:* = param1.args[param2] is BlockArg ? BlockArg(param1.args[param2]).argValue : this.evalCmd(Block(param1.args[param2]));
         if(_loc3_ is Boolean)
         {
            return _loc3_;
         }
         if(_loc3_ is String)
         {
            _loc4_ = _loc3_;
            if(_loc4_ == "" || _loc4_ == "0" || _loc4_.toLowerCase() == "false")
            {
               return false;
            }
            return true;
         }
         return Boolean(_loc3_);
      }
      
      private function startCmdList(param1:Block, param2:Boolean = false, param3:Array = null) : void
      {
         if(param1 == null)
         {
            if(param2)
            {
               this.yield = true;
            }
            return;
         }
         this.activeThread.isLoop = param2;
         this.activeThread.pushStateForBlock(param1);
         if(param3)
         {
            this.activeThread.args = param3;
         }
         this.evalCmd(this.activeThread.block);
      }
      
      public function startTimer(param1:Number) : void
      {
         var _loc2_:int = 1000 * param1;
         if(_loc2_ < 0)
         {
            _loc2_ = 0;
         }
         this.activeThread.tmp = this.currentMSecs + _loc2_;
         this.activeThread.firstTime = false;
         this.doYield();
      }
      
      public function checkTimer() : Boolean
      {
         if(this.currentMSecs >= this.activeThread.tmp)
         {
            this.activeThread.tmp = 0;
            this.activeThread.tmpObj = null;
            this.activeThread.firstTime = true;
            return true;
         }
         this.doYield();
         return false;
      }
      
      public function isImplemented(param1:String) : Boolean
      {
         return this.primTable[param1] != undefined;
      }
      
      public function getPrim(param1:String) : Function
      {
         return this.primTable[param1];
      }
      
      private function initPrims() : void
      {
         this.primTable = new Dictionary();
         this.primTable["whenGreenFlag"] = this.primNoop;
         this.primTable["whenKeyPressed"] = this.primNoop;
         this.primTable["whenClicked"] = this.primNoop;
         this.primTable["whenSceneStarts"] = this.primNoop;
         this.primTable["wait:elapsed:from:"] = this.primWait;
         this.primTable["doForever"] = function(param1:*):*
         {
            startCmdList(param1.subStack1,true);
         };
         this.primTable["doRepeat"] = this.primRepeat;
         this.primTable["broadcast:"] = function(param1:*):*
         {
            broadcast(arg(param1,0),false);
         };
         this.primTable["doBroadcastAndWait"] = function(param1:*):*
         {
            broadcast(arg(param1,0),true);
         };
         this.primTable["whenIReceive"] = this.primNoop;
         this.primTable["doForeverIf"] = function(param1:*):*
         {
            if(arg(param1,0))
            {
               startCmdList(param1.subStack1,true);
            }
            else
            {
               yield = true;
            }
         };
         this.primTable["doForLoop"] = this.primForLoop;
         this.primTable["doIf"] = function(param1:*):*
         {
            if(arg(param1,0))
            {
               startCmdList(param1.subStack1);
            }
         };
         this.primTable["doIfElse"] = function(param1:*):*
         {
            if(arg(param1,0))
            {
               startCmdList(param1.subStack1);
            }
            else
            {
               startCmdList(param1.subStack2);
            }
         };
         this.primTable["doWaitUntil"] = function(param1:*):*
         {
            if(!arg(param1,0))
            {
               yield = true;
            }
         };
         this.primTable["doWhile"] = function(param1:*):*
         {
            if(arg(param1,0))
            {
               startCmdList(param1.subStack1,true);
            }
         };
         this.primTable["doUntil"] = function(param1:*):*
         {
            if(!arg(param1,0))
            {
               startCmdList(param1.subStack1,true);
            }
         };
         this.primTable["doReturn"] = this.primReturn;
         this.primTable["stopAll"] = function(param1:*):*
         {
            app.runtime.stopAll();
            yield = true;
         };
         this.primTable["stopScripts"] = this.primStop;
         this.primTable["warpSpeed"] = this.primOldWarpSpeed;
         this.primTable[Specs.CALL] = this.primCall;
         this.primTable[Specs.GET_VAR] = this.primVarGet;
         this.primTable[Specs.SET_VAR] = this.primVarSet;
         this.primTable[Specs.CHANGE_VAR] = this.primVarChange;
         this.primTable[Specs.GET_PARAM] = this.primGetParam;
         this.primTable["whenDistanceLessThan"] = this.primNoop;
         this.primTable["whenSensorConnected"] = this.primNoop;
         this.primTable["whenSensorGreaterThan"] = this.primNoop;
         this.primTable["whenTiltIs"] = this.primNoop;
         this.addOtherPrims(this.primTable);
      }
      
      protected function addOtherPrims(param1:Dictionary) : void
      {
         new Primitives(this.app,this).addPrimsTo(param1);
      }
      
      private function checkPrims() : void
      {
         var _loc1_:String = null;
         var _loc3_:Array = null;
         var _loc2_:Array = ["CALL","GET_VAR","NOOP"];
         for each(_loc3_ in Specs.commands)
         {
            if(_loc3_.length > 3)
            {
               _loc1_ = _loc3_[3];
               _loc2_.push(_loc1_);
               if(this.primTable[_loc1_] == undefined)
               {
               }
            }
         }
         for(_loc1_ in this.primTable)
         {
            if(_loc2_.indexOf(_loc1_) < 0)
            {
            }
         }
      }
      
      public function primNoop(param1:Block) : void
      {
      }
      
      private function primForLoop(param1:Block) : void
      {
         var _loc3_:Variable = null;
         var _loc4_:* = undefined;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc2_:Array = [];
         if(this.activeThread.firstTime)
         {
            if(!(this.arg(param1,0) is String))
            {
               return;
            }
            _loc4_ = this.arg(param1,1);
            if(_loc4_ is Array)
            {
               _loc2_ = _loc4_ as Array;
            }
            if(_loc4_ is String)
            {
               _loc5_ = Number(_loc4_);
               if(!isNaN(_loc5_))
               {
                  _loc4_ = _loc5_;
               }
            }
            if(_loc4_ is Number && !isNaN(_loc4_))
            {
               _loc6_ = int(_loc4_);
               if(_loc6_ >= 1)
               {
                  _loc2_ = new Array(_loc6_ - 1);
                  _loc7_ = 0;
                  while(_loc7_ < _loc6_)
                  {
                     _loc2_[_loc7_] = _loc7_ + 1;
                     _loc7_++;
                  }
               }
            }
            _loc3_ = this.activeThread.target.lookupOrCreateVar(this.arg(param1,0));
            this.activeThread.args = [_loc2_,_loc3_];
            this.activeThread.tmp = 0;
            this.activeThread.firstTime = false;
         }
         _loc2_ = this.activeThread.args[0];
         _loc3_ = this.activeThread.args[1];
         if(this.activeThread.tmp < _loc2_.length)
         {
            _loc3_.value = _loc2_[this.activeThread.tmp++];
            this.startCmdList(param1.subStack1,true);
         }
         else
         {
            this.activeThread.args = null;
            this.activeThread.tmp = 0;
            this.activeThread.firstTime = true;
         }
      }
      
      private function primOldWarpSpeed(param1:Block) : void
      {
         if(param1.subStack1 == null)
         {
            return;
         }
         this.startCmdList(param1.subStack1);
      }
      
      private function primRepeat(param1:Block) : void
      {
         var _loc2_:Number = NaN;
         if(this.activeThread.firstTime)
         {
            _loc2_ = Math.max(0,Math.min(Math.round(this.numarg(param1,0)),2147483647));
            this.activeThread.tmp = _loc2_;
            this.activeThread.firstTime = false;
         }
         if(this.activeThread.tmp > 0)
         {
            --this.activeThread.tmp;
            this.startCmdList(param1.subStack1,true);
         }
         else
         {
            this.activeThread.firstTime = true;
         }
      }
      
      private function primStop(param1:Block) : void
      {
         var _loc2_:String = this.arg(param1,0);
         if(_loc2_ == "all")
         {
            this.app.runtime.stopAll();
            this.yield = true;
         }
         if(_loc2_ == "this script")
         {
            this.primReturn(param1);
         }
         if(_loc2_ == "other scripts in sprite")
         {
            this.stopThreadsFor(this.activeThread.target,true);
         }
         if(_loc2_ == "other scripts in stage")
         {
            this.stopThreadsFor(this.activeThread.target,true);
         }
      }
      
      private function primWait(param1:Block) : void
      {
         if(this.activeThread.firstTime)
         {
            this.startTimer(this.numarg(param1,0));
            this.redraw();
         }
         else
         {
            this.checkTimer();
         }
      }
      
      public function broadcast(param1:String, param2:Boolean) : void
      {
         var done:Boolean;
         var pair:Array = null;
         var t:Thread = null;
         var receivers:Array = null;
         var newThreads:Array = null;
         var findReceivers:Function = null;
         var msg:String = param1;
         var waitFlag:Boolean = param2;
         if(this.activeThread.firstTime)
         {
            receivers = [];
            newThreads = [];
            msg = msg.toLowerCase();
            findReceivers = function(param1:Block, param2:ScratchObj):void
            {
               if(param1.op == "whenIReceive" && param1.args[0].argValue.toLowerCase() == msg)
               {
                  receivers.push([param1,param2]);
               }
            };
            this.app.runtime.allStacksAndOwnersDo(findReceivers);
            for each(pair in receivers)
            {
               newThreads.push(this.restartThread(pair[0],pair[1]));
            }
            if(!waitFlag)
            {
               return;
            }
            this.activeThread.tmpObj = newThreads;
            this.activeThread.firstTime = false;
         }
         done = true;
         for each(t in this.activeThread.tmpObj)
         {
            if(this.threads.indexOf(t) >= 0)
            {
               done = false;
            }
         }
         if(done)
         {
            this.activeThread.tmpObj = null;
            this.activeThread.firstTime = true;
         }
         else
         {
            this.yield = true;
         }
      }
      
      public function startScene(param1:String, param2:Boolean) : void
      {
         var done:Boolean;
         var findSceneHats:Function;
         var pair:Array = null;
         var t:Thread = null;
         var receivers:Array = null;
         var newThreads:Array = null;
         var sceneName:String = param1;
         var waitFlag:Boolean = param2;
         if(this.activeThread.firstTime)
         {
            findSceneHats = function(param1:Block, param2:ScratchObj):void
            {
               if(param1.op == "whenSceneStarts" && param1.args[0].argValue == sceneName)
               {
                  receivers.push([param1,param2]);
               }
            };
            receivers = [];
            this.app.stagePane.showCostumeNamed(sceneName);
            this.redraw();
            this.app.runtime.allStacksAndOwnersDo(findSceneHats);
            newThreads = [];
            for each(pair in receivers)
            {
               newThreads.push(this.restartThread(pair[0],pair[1]));
            }
            if(!waitFlag)
            {
               return;
            }
            this.activeThread.tmpObj = newThreads;
            this.activeThread.firstTime = false;
         }
         done = true;
         for each(t in this.activeThread.tmpObj)
         {
            if(this.threads.indexOf(t) >= 0)
            {
               done = false;
            }
         }
         if(done)
         {
            this.activeThread.tmpObj = null;
            this.activeThread.firstTime = true;
         }
         else
         {
            this.yield = true;
         }
      }
      
      private function primCall(param1:Block) : void
      {
         var _loc2_:ScratchObj = this.activeThread.target;
         var _loc3_:String = param1.spec;
         var _loc4_:Block = _loc2_.procCache[_loc3_];
         if(!_loc4_)
         {
            _loc4_ = _loc2_.lookupProcedure(_loc3_);
            _loc2_.procCache[_loc3_] = _loc4_;
         }
         if(!_loc4_)
         {
            return;
         }
         if(this.warpThread)
         {
            this.activeThread.firstTime = false;
            if(this.currentMSecs - this.startTime > this.warpMSecs)
            {
               this.yield = true;
            }
         }
         else if(_loc4_.warpProcFlag)
         {
            this.warpBlock = param1;
            this.warpThread = this.activeThread;
            this.activeThread.firstTime = true;
         }
         else if(this.activeThread.isRecursiveCall(param1,_loc4_))
         {
            this.yield = true;
         }
         var _loc5_:int = int(_loc4_.parameterNames.length);
         var _loc6_:Array = [];
         var _loc7_:int = 0;
         while(_loc7_ < _loc5_)
         {
            _loc6_.push(this.arg(param1,_loc7_));
            _loc7_++;
         }
         this.startCmdList(_loc4_,false,_loc6_);
      }
      
      private function primReturn(param1:Block) : void
      {
         if(!this.activeThread.returnFromProcedure())
         {
            this.activeThread.stop();
            this.yield = true;
         }
      }
      
      private function primVarGet(param1:Block) : *
      {
         var _loc2_:ScratchObj = this.app.runtime.currentDoObj ? this.app.runtime.currentDoObj : this.activeThread.target;
         var _loc3_:Variable = _loc2_.varCache[param1.spec];
         if(_loc3_ == null)
         {
            _loc3_ = _loc2_.varCache[param1.spec] = _loc2_.lookupOrCreateVar(param1.spec);
            if(_loc3_ == null)
            {
               return 0;
            }
         }
         return _loc3_.value;
      }
      
      protected function primVarSet(param1:Block) : Variable
      {
         var _loc2_:String = this.arg(param1,0);
         var _loc3_:Variable = this.activeThread.target.varCache[_loc2_];
         if(!_loc3_)
         {
            _loc3_ = this.activeThread.target.varCache[_loc2_] = this.activeThread.target.lookupOrCreateVar(_loc2_);
            if(!_loc3_)
            {
               return null;
            }
         }
         var _loc4_:* = _loc3_.value;
         _loc3_.value = this.arg(param1,1);
         return _loc3_;
      }
      
      protected function primVarChange(param1:Block) : Variable
      {
         var _loc2_:String = this.arg(param1,0);
         var _loc3_:Variable = this.activeThread.target.varCache[_loc2_];
         if(!_loc3_)
         {
            _loc3_ = this.activeThread.target.varCache[_loc2_] = this.activeThread.target.lookupOrCreateVar(_loc2_);
            if(!_loc3_)
            {
               return null;
            }
         }
         _loc3_.value = Number(_loc3_.value) + this.numarg(param1,1);
         return _loc3_;
      }
      
      private function primGetParam(param1:Block) : *
      {
         var _loc2_:Block = null;
         if(param1.parameterIndex < 0)
         {
            _loc2_ = param1.topBlock();
            if(_loc2_.parameterNames)
            {
               param1.parameterIndex = _loc2_.parameterNames.indexOf(param1.spec);
            }
            if(param1.parameterIndex < 0)
            {
               return 0;
            }
         }
         if(this.activeThread.args == null || param1.parameterIndex >= this.activeThread.args.length)
         {
            return 0;
         }
         return this.activeThread.args[param1.parameterIndex];
      }
   }
}

