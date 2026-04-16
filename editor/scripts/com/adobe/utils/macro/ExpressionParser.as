package com.adobe.utils.macro
{
   public class ExpressionParser
   {
      
      private static const UNARY_PRECEDENCE:int = 5;
      
      private var pos:int = 0;
      
      private var newline:int = 0;
      
      private var tokens:Vector.<String>;
      
      private var types:String;
      
      public function ExpressionParser()
      {
         super();
      }
      
      private function expectTok(param1:String) : void
      {
         if(this.tokens[this.pos] != param1)
         {
            throw new Error("Unexpected token.");
         }
         ++this.pos;
      }
      
      private function parseSingle(param1:String, param2:String) : Expression
      {
         var _loc3_:VariableExpression = null;
         var _loc4_:NumberExpression = null;
         if(param2 == "i")
         {
            return new VariableExpression(param1);
         }
         if(param2 == "0")
         {
            return new NumberExpression(Number(param1));
         }
         return null;
      }
      
      private function parseChunk() : Expression
      {
         var _loc1_:UnaryExpression = null;
         var _loc2_:Expression = null;
         var _loc3_:VariableExpression = null;
         var _loc4_:NumberExpression = null;
         if(this.pos == this.newline)
         {
            throw new Error("parseBit out of tokens");
         }
         if(this.tokens[this.pos] == "!")
         {
            _loc1_ = new UnaryExpression();
            ++this.pos;
            _loc1_.right = this.parseExpression(UNARY_PRECEDENCE);
            return _loc1_;
         }
         if(this.tokens[this.pos] == "(")
         {
            ++this.pos;
            _loc2_ = this.parseExpression(0);
            this.expectTok(")");
            return _loc2_;
         }
         if(this.types.charAt(this.pos) == "i")
         {
            _loc3_ = new VariableExpression(this.tokens[this.pos]);
            ++this.pos;
            return _loc3_;
         }
         if(this.types.charAt(this.pos) == "0")
         {
            _loc4_ = new NumberExpression(Number(this.tokens[this.pos]));
            ++this.pos;
            return _loc4_;
         }
         throw new Error("end of parseChunk: token=" + this.tokens[this.pos] + " type=" + this.types.charAt(this.pos));
      }
      
      private function parseExpression(param1:int) : Expression
      {
         var _loc4_:BinaryExpression = null;
         var _loc2_:Expression = this.parseChunk();
         if(_loc2_ is NumberExpression)
         {
            return _loc2_;
         }
         var _loc3_:OpInfo = new OpInfo();
         if(this.pos < this.tokens.length)
         {
            this.calcOpInfo(this.tokens[this.pos],_loc3_);
         }
         while(_loc3_.order == 2 && _loc3_.precedence >= param1)
         {
            _loc4_ = new BinaryExpression();
            _loc4_.op = this.tokens[this.pos];
            ++this.pos;
            _loc4_.left = _loc2_;
            _loc4_.right = this.parseExpression(1 + _loc3_.precedence);
            _loc2_ = _loc4_;
            if(this.pos >= this.tokens.length)
            {
               break;
            }
            this.calcOpInfo(this.tokens[this.pos],_loc3_);
         }
         return _loc2_;
      }
      
      public function parse(param1:Vector.<String>, param2:String) : Expression
      {
         this.pos = 0;
         this.newline = param2.indexOf("n",this.pos + 1);
         if(this.newline < 0)
         {
            this.newline = param2.length;
         }
         this.tokens = param1;
         this.types = param2;
         var _loc3_:Expression = this.parseExpression(0);
         if(AGALPreAssembler.TRACE_AST)
         {
            _loc3_.print(0);
         }
         if(this.pos != this.newline)
         {
            throw new Error("parser didn\'t end");
         }
         return _loc3_;
      }
      
      private function calcOpInfo(param1:String, param2:OpInfo) : Boolean
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         param2.order = 0;
         param2.precedence = -1;
         var _loc3_:Array = [new Array("&&","||"),new Array("==","!="),new Array(">","<",">=","<="),new Array("+","-"),new Array("*","/"),new Array("!")];
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_.length)
         {
            _loc5_ = _loc3_[_loc4_];
            _loc6_ = _loc5_.indexOf(param1);
            if(_loc6_ >= 0)
            {
               param2.order = _loc4_ == UNARY_PRECEDENCE ? 1 : 2;
               param2.precedence = _loc4_;
               return true;
            }
            _loc4_++;
         }
         return false;
      }
   }
}

class OpInfo
{
   
   public var precedence:int;
   
   public var order:int;
   
   public function OpInfo()
   {
      super();
   }
}
