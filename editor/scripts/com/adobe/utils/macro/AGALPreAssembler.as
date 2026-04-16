package com.adobe.utils.macro
{
   public class AGALPreAssembler
   {
      
      public static const TRACE_VM:Boolean = false;
      
      public static const TRACE_AST:Boolean = false;
      
      public static const TRACE_PREPROC:Boolean = false;
      
      private var vm:VM = new VM();
      
      private var expressionParser:ExpressionParser = new ExpressionParser();
      
      public function AGALPreAssembler()
      {
         super();
      }
      
      public function processLine(param1:Vector.<String>, param2:String) : Boolean
      {
         var _loc4_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc3_:String = "";
         var _loc5_:Expression = null;
         var _loc7_:int = 0;
         if(param2.charAt(_loc7_) == "#")
         {
            _loc3_ = "";
            _loc4_ = Number.NaN;
            if(param1[_loc7_] == "#define")
            {
               if(param2.length >= 3 && param2.substr(_loc7_,3) == "#in")
               {
                  _loc3_ = param1[_loc7_ + 1];
                  this.vm.vars[_loc3_] = Number.NaN;
                  if(TRACE_PREPROC)
                  {
                  }
                  _loc7_ += 3;
               }
               else if(param2.length >= 3 && param2.substr(_loc7_,3) == "#i=")
               {
                  _loc5_ = this.expressionParser.parse(param1.slice(3),param2.substr(3));
                  _loc5_.exec(this.vm);
                  _loc6_ = this.vm.stack.pop();
                  _loc3_ = param1[_loc7_ + 1];
                  this.vm.vars[_loc3_] = _loc6_;
                  if(TRACE_PREPROC)
                  {
                  }
               }
               else
               {
                  _loc5_ = this.expressionParser.parse(param1.slice(2),param2.substr(2));
                  _loc5_.exec(this.vm);
                  _loc6_ = this.vm.stack.pop();
                  _loc3_ = param1[_loc7_ + 1];
                  this.vm.vars[_loc3_] = _loc6_;
                  if(TRACE_PREPROC)
                  {
                  }
               }
            }
            else if(param1[_loc7_] == "#undef")
            {
               _loc3_ = param1[_loc7_ + 1];
               this.vm.vars[_loc3_] = null;
               if(TRACE_PREPROC)
               {
               }
               _loc7_ += 3;
            }
            else if(param1[_loc7_] == "#if")
            {
               _loc7_++;
               _loc5_ = this.expressionParser.parse(param1.slice(1),param2.substr(1));
               this.vm.pushIf();
               _loc5_.exec(this.vm);
               _loc6_ = this.vm.stack.pop();
               this.vm.setIf(_loc6_);
               if(TRACE_PREPROC)
               {
               }
            }
            else if(param1[_loc7_] == "#elif")
            {
               _loc7_++;
               _loc5_ = this.expressionParser.parse(param1.slice(1),param2.substr(1));
               _loc5_.exec(this.vm);
               _loc6_ = this.vm.stack.pop();
               this.vm.setIf(_loc6_);
               if(TRACE_PREPROC)
               {
               }
            }
            else if(param1[_loc7_] == "#else")
            {
               _loc7_++;
               this.vm.setIf(this.vm.ifWasTrue() ? 0 : 1);
               if(TRACE_PREPROC)
               {
               }
            }
            else
            {
               if(param1[_loc7_] != "#endif")
               {
                  throw new Error("unrecognize processor directive.");
               }
               this.vm.popEndif();
               _loc7_++;
               if(TRACE_PREPROC)
               {
               }
            }
            while(_loc7_ < param2.length && param2.charAt(_loc7_) == "n")
            {
               _loc7_++;
            }
            return this.vm.ifIsTrue();
         }
         throw new Error("PreProcessor called without pre processor directive.");
      }
   }
}

