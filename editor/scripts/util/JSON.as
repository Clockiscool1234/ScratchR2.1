package util
{
   import flash.display.BitmapData;
   import flash.utils.*;
   
   public class JSON
   {
      
      private var src:ReadStream;
      
      private var buf:String = "";
      
      private var tabs:String = "";
      
      private var needsComma:Boolean = false;
      
      private var doFormatting:Boolean;
      
      public function JSON()
      {
         super();
      }
      
      public static function stringify(param1:*, param2:Boolean = true) : String
      {
         var _loc3_:util.JSON = new util.JSON();
         _loc3_.doFormatting = param2;
         _loc3_.write(param1);
         return _loc3_.buf;
      }
      
      public static function parse(param1:String) : Object
      {
         var _loc2_:util.JSON = new util.JSON();
         _loc2_.buf = param1;
         _loc2_.src = new ReadStream(param1);
         return _loc2_.readValue();
      }
      
      public static function escapeForJS(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc4_:int = 0;
         var _loc3_:String = "";
         while(_loc4_ < param1.length)
         {
            _loc3_ += _loc2_ = param1.charAt(_loc4_);
            if("\\" == _loc2_)
            {
               _loc3_ += "\\";
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function readValue() : Object
      {
         this.skipWhiteSpaceAndComments();
         var _loc1_:String = this.src.peek();
         if("0" <= _loc1_ && _loc1_ <= "9")
         {
            return this.readNumber();
         }
         switch(_loc1_)
         {
            case "\"":
               return this.readString();
            case "[":
               return this.readArray();
            case "{":
               return this.readObject();
            case "t":
               if(this.src.nextString(4) == "true")
               {
                  return true;
               }
               this.error("Expected \'true\'");
            case "f":
               if(this.src.nextString(5) == "false")
               {
                  return false;
               }
               this.error("Expected \'false\'");
            case "n":
               if(this.src.nextString(4) == "null")
               {
                  return null;
               }
               this.error("Expected \'null\'");
            case "-":
               if(this.src.peekString(9) == "-Infinity")
               {
                  this.src.skip(9);
                  return Number.NEGATIVE_INFINITY;
               }
               return this.readNumber();
               break;
            case "I":
               if(this.src.nextString(8) == "Infinity")
               {
                  return Number.POSITIVE_INFINITY;
               }
               this.error("Expected \'Infinity\'");
            case "N":
               if(this.src.nextString(3) == "NaN")
               {
                  return NaN;
               }
               this.error("Expected \'NaN\'");
            case "":
               this.error("Incomplete JSON data");
         }
         this.error("Bad character: " + _loc1_);
         return null;
      }
      
      private function readArray() : Array
      {
         var _loc1_:Array = [];
         this.src.skip(1);
         while(true)
         {
            if(this.src.atEnd())
            {
               return this.error("Incomplete array");
            }
            this.skipWhiteSpaceAndComments();
            if(this.src.peek() == "]")
            {
               break;
            }
            _loc1_.push(this.readValue());
            this.skipWhiteSpaceAndComments();
            if(this.src.peek() == ",")
            {
               this.src.skip(1);
            }
            else
            {
               if(this.src.peek() == "]")
               {
                  break;
               }
               this.error("Bad array syntax");
            }
         }
         this.src.skip(1);
         return _loc1_;
      }
      
      private function readObject() : Object
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc1_:Object = {};
         this.src.skip(1);
         while(true)
         {
            if(this.src.atEnd())
            {
               return this.error("Incomplete object");
            }
            this.skipWhiteSpaceAndComments();
            if(this.src.peek() == "}")
            {
               break;
            }
            if(this.src.peek() != "\"")
            {
               this.error("Bad object syntax");
            }
            _loc2_ = this.readString();
            this.skipWhiteSpaceAndComments();
            if(this.src.next() != ":")
            {
               this.error("Bad object syntax");
            }
            this.skipWhiteSpaceAndComments();
            _loc3_ = this.readValue();
            _loc1_[_loc2_] = _loc3_;
            this.skipWhiteSpaceAndComments();
            if(this.src.peek() == ",")
            {
               this.src.skip(1);
            }
            else
            {
               if(this.src.peek() == "}")
               {
                  break;
               }
               this.error("Bad object syntax");
            }
         }
         this.src.skip(1);
         return _loc1_;
      }
      
      private function readNumber() : Number
      {
         var _loc1_:String = "";
         var _loc2_:String = this.src.peek();
         if(_loc2_ == "0" && this.src.peek2() == "x")
         {
            _loc1_ = this.src.nextString(2) + this.readHexDigits();
            return Number(_loc1_);
         }
         if(_loc2_ == "-")
         {
            _loc1_ += this.src.next();
         }
         _loc1_ += this.readDigits();
         if(_loc1_ == "" || _loc1_ == "-")
         {
            this.error("At least one digit expected");
         }
         if(this.src.peek() == ".")
         {
            _loc1_ += this.src.next() + this.readDigits();
         }
         _loc2_ = this.src.peek();
         if(_loc2_ == "e" || _loc2_ == "E")
         {
            _loc1_ += this.src.next();
            _loc2_ = this.src.peek();
            if(_loc2_ == "+" || _loc2_ == "-")
            {
               _loc1_ += this.src.next();
            }
            _loc1_ += this.readDigits();
         }
         return Number(_loc1_);
      }
      
      private function readDigits() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         while(true)
         {
            _loc2_ = this.src.next();
            if(!("0" <= _loc2_ && _loc2_ <= "9"))
            {
               break;
            }
            _loc1_ += _loc2_;
         }
         if(_loc2_ != "")
         {
            this.src.skip(-1);
         }
         return _loc1_;
      }
      
      private function readHexDigits() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         while(true)
         {
            _loc2_ = this.src.next();
            if("0" <= _loc2_ && _loc2_ <= "9")
            {
               _loc1_ += _loc2_;
            }
            else if("a" <= _loc2_ && _loc2_ <= "f")
            {
               _loc1_ += _loc2_;
            }
            else
            {
               if(!("A" <= _loc2_ && _loc2_ <= "F"))
               {
                  break;
               }
               _loc1_ += _loc2_;
            }
         }
         if(!this.src.atEnd())
         {
            this.src.skip(-1);
         }
         return _loc1_;
      }
      
      private function readString() : String
      {
         var _loc2_:String = null;
         var _loc1_:String = "";
         this.src.skip(1);
         while(true)
         {
            _loc2_ = this.src.next();
            if(_loc2_ == "\"")
            {
               break;
            }
            if(_loc2_ == "")
            {
               return this.error("Incomplete string");
            }
            if(_loc2_ == "\\")
            {
               _loc1_ += this.readEscapedChar();
            }
            else
            {
               _loc1_ += _loc2_;
            }
         }
         return _loc1_;
      }
      
      private function readEscapedChar() : String
      {
         var _loc1_:String = this.src.next();
         switch(_loc1_)
         {
            case "b":
               return "\b";
            case "f":
               return "\f";
            case "n":
               return "\n";
            case "r":
               return "\r";
            case "t":
               return "\t";
            case "u":
               return String.fromCharCode(int("0x" + this.src.nextString(4)));
            default:
               return _loc1_;
         }
      }
      
      private function skipWhiteSpaceAndComments() : void
      {
         var _loc1_:int = 0;
         do
         {
            _loc1_ = this.src.pos();
            this.src.skipWhiteSpace();
            this.skipComment();
         }
         while(this.src.pos() != _loc1_);
      }
      
      private function skipComment() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         if(this.src.peek() == "/" && this.src.peek2() == "/")
         {
            this.src.skip(2);
            while(true)
            {
               _loc1_ = this.src.next();
               if(_loc1_ == "\n")
               {
                  break;
               }
               if(_loc1_ == "")
               {
                  return;
               }
            }
         }
         if(this.src.peek() == "/" && this.src.peek2() == "*")
         {
            this.src.skip(2);
            _loc2_ = false;
            while(true)
            {
               _loc1_ = this.src.next();
               if(_loc1_ == "")
               {
                  break;
               }
               if(_loc2_ && _loc1_ == "/")
               {
                  return;
               }
               if(_loc1_ == "*")
               {
                  _loc2_ = true;
               }
            }
            return;
         }
      }
      
      private function error(param1:String) : *
      {
         throw new Error(param1 + " [pos=" + this.src.pos()) + "] in " + this.buf;
      }
      
      public function writeKeyValue(param1:String, param2:*) : void
      {
         if(this.needsComma)
         {
            this.buf += this.doFormatting ? ",\n" : ", ";
         }
         this.buf += this.tabs + "\"" + param1 + "\": ";
         this.write(param2);
         this.needsComma = true;
      }
      
      private function write(param1:*) : void
      {
         if(param1 is Number)
         {
            this.buf += isFinite(param1) ? param1 : "0";
         }
         else if(param1 is Boolean)
         {
            this.buf += param1;
         }
         else if(param1 is String)
         {
            this.buf += "\"" + this.encodeString(param1) + "\"";
         }
         else if(param1 is ByteArray)
         {
            this.buf += "\"" + this.encodeString(param1.toString()) + "\"";
         }
         else if(param1 == null)
         {
            this.buf += "null";
         }
         else if(param1 is Array)
         {
            this.writeArray(param1);
         }
         else if(param1 is BitmapData)
         {
            this.buf += "null";
         }
         else
         {
            this.writeObject(param1);
         }
      }
      
      private function writeObject(param1:*) : void
      {
         var _loc3_:String = null;
         var _loc2_:Boolean = this.needsComma;
         this.needsComma = false;
         this.buf += "{";
         if(this.doFormatting)
         {
            this.buf += "\n";
         }
         this.indent();
         if(this.isClass(param1,"Object") || this.isClass(param1,"Dictonary"))
         {
            for(_loc3_ in param1)
            {
               this.writeKeyValue(_loc3_,param1[_loc3_]);
            }
         }
         else
         {
            param1.writeJSON(this);
         }
         if(this.doFormatting && this.needsComma)
         {
            this.buf += "\n";
         }
         this.outdent();
         this.buf += this.tabs + "}";
         this.needsComma = _loc2_;
      }
      
      private function isClass(param1:*, param2:String) : Boolean
      {
         var _loc3_:String = getQualifiedClassName(param1);
         var _loc4_:int = _loc3_.lastIndexOf(param2);
         return _loc4_ == _loc3_.length - param2.length;
      }
      
      private function writeArray(param1:Array) : void
      {
         var _loc2_:String = ", ";
         var _loc3_:Boolean = this.doFormatting && (param1.length > 13 || this.needsMultipleLines(param1,13));
         this.buf += "[";
         this.indent();
         if(_loc3_)
         {
            _loc2_ = ",\n" + this.tabs;
         }
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            this.write(param1[_loc4_]);
            if(_loc4_ < param1.length - 1)
            {
               this.buf += _loc2_;
            }
            _loc4_++;
         }
         this.outdent();
         this.buf += "]";
      }
      
      private function needsMultipleLines(param1:Array, param2:int) : Boolean
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc6_:Array = null;
         var _loc7_:* = undefined;
         var _loc5_:Array = [param1];
         while(_loc5_.length > 0)
         {
            _loc6_ = _loc5_.pop();
            _loc4_ += _loc6_.length;
            if(_loc4_ > param2)
            {
               return true;
            }
            _loc3_ = 0;
            while(_loc3_ < _loc6_.length)
            {
               _loc7_ = _loc6_[_loc3_];
               if(!(_loc7_ is Number || _loc7_ is Boolean || _loc7_ is String || _loc7_ == null))
               {
                  if(!(_loc7_ is Array))
                  {
                     return true;
                  }
                  _loc5_.push(_loc7_);
               }
               _loc3_++;
            }
         }
         return false;
      }
      
      private function encodeString(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.charAt(_loc3_);
            _loc5_ = param1.charCodeAt(_loc3_);
            if(_loc5_ < 32)
            {
               if(_loc5_ == 9)
               {
                  _loc2_ += "\\t";
               }
               else if(_loc5_ == 10)
               {
                  _loc2_ += "\\n";
               }
               else if(_loc5_ == 13)
               {
                  _loc2_ += "\\r";
               }
               else
               {
                  _loc6_ = _loc5_.toString(16);
                  while(_loc6_.length < 4)
                  {
                     _loc6_ = "0" + _loc6_;
                  }
                  _loc2_ += "\\u" + _loc6_;
               }
            }
            else if(_loc4_ == "\\")
            {
               _loc2_ += "\\\\";
            }
            else if(_loc4_ == "\"")
            {
               _loc2_ += "\\\"";
            }
            else if(_loc4_ == "/")
            {
               _loc2_ += "\\/";
            }
            else
            {
               _loc2_ += _loc4_;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      private function indent() : void
      {
         if(this.doFormatting)
         {
            this.tabs += "\t";
         }
      }
      
      private function outdent() : void
      {
         if(this.tabs.length == 0)
         {
            return;
         }
         this.tabs = this.tabs.slice(0,this.tabs.length - 1);
      }
   }
}

