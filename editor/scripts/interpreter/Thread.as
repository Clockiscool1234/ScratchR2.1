package interpreter
{
   import blocks.Block;
   
   public class Thread
   {
      
      public var target:*;
      
      public var topBlock:Block;
      
      public var tmpObj:*;
      
      public var startDelayCount:int;
      
      public var block:Block;
      
      public var isLoop:Boolean;
      
      public var firstTime:Boolean;
      
      public var tmp:int;
      
      public var args:Array;
      
      private var stack:Vector.<StackFrame>;
      
      private var sp:int;
      
      public function Thread(param1:Block, param2:*, param3:int = 0)
      {
         super();
         this.target = param2;
         this.stop();
         this.topBlock = param1;
         this.startDelayCount = param3;
         this.block = param1;
         this.isLoop = false;
         this.firstTime = true;
         this.tmp = 0;
      }
      
      public function pushStateForBlock(param1:Block) : void
      {
         if(this.sp >= this.stack.length - 1)
         {
            this.growStack();
         }
         var _loc2_:StackFrame = this.stack[this.sp++];
         _loc2_.block = this.block;
         _loc2_.isLoop = this.isLoop;
         _loc2_.firstTime = this.firstTime;
         _loc2_.tmp = this.tmp;
         _loc2_.args = this.args;
         this.block = param1;
         this.isLoop = false;
         this.firstTime = true;
         this.tmp = 0;
      }
      
      public function popState() : Boolean
      {
         if(this.sp == 0)
         {
            return false;
         }
         var _loc1_:StackFrame = this.stack[--this.sp];
         this.block = _loc1_.block;
         this.isLoop = _loc1_.isLoop;
         this.firstTime = _loc1_.firstTime;
         this.tmp = _loc1_.tmp;
         this.args = _loc1_.args;
         return true;
      }
      
      public function stackEmpty() : Boolean
      {
         return this.sp == 0;
      }
      
      public function stop() : void
      {
         this.block = null;
         this.stack = new Vector.<StackFrame>(4);
         this.stack[0] = new StackFrame();
         this.stack[1] = new StackFrame();
         this.stack[2] = new StackFrame();
         this.stack[3] = new StackFrame();
         this.sp = 0;
      }
      
      public function isRecursiveCall(param1:Block, param2:Block) : Boolean
      {
         var _loc5_:Block = null;
         var _loc3_:int = 5;
         var _loc4_:* = int(this.sp - 1);
         while(_loc4_ >= 0)
         {
            _loc5_ = this.stack[_loc4_].block;
            if(_loc5_.op == Specs.CALL)
            {
               if(param1 == _loc5_)
               {
                  return true;
               }
               if(param2 == this.target.procCache[_loc5_.spec])
               {
                  return true;
               }
            }
            if(--_loc3_ < 0)
            {
               return false;
            }
            _loc4_--;
         }
         return false;
      }
      
      public function returnFromProcedure() : Boolean
      {
         var _loc1_:* = int(this.sp - 1);
         while(_loc1_ >= 0)
         {
            if(this.stack[_loc1_].block.op == Specs.CALL)
            {
               this.sp = _loc1_ + 1;
               this.block = null;
               return true;
            }
            _loc1_--;
         }
         return false;
      }
      
      private function initForBlock(param1:Block) : void
      {
         this.block = param1;
         this.isLoop = false;
         this.firstTime = true;
         this.tmp = 0;
      }
      
      private function growStack() : void
      {
         var _loc1_:int = int(this.stack.length);
         var _loc2_:int = _loc1_ + _loc1_;
         this.stack.length = _loc2_;
         var _loc3_:int = _loc1_;
         while(_loc3_ < _loc2_)
         {
            this.stack[_loc3_] = new StackFrame();
            _loc3_++;
         }
      }
   }
}

import blocks.Block;

class StackFrame
{
   
   internal var block:Block;
   
   internal var isLoop:Boolean;
   
   internal var firstTime:Boolean;
   
   internal var tmp:int;
   
   internal var args:Array;
   
   public function StackFrame()
   {
      super();
   }
}
