package util
{
   public class ReadStream
   {
      
      private var src:String;
      
      private var i:int;
      
      public function ReadStream(param1:String)
      {
         super();
         this.src = param1;
         this.i = 0;
      }
      
      public static function tokenize(param1:String) : Array
      {
         var _loc4_:String = null;
         var _loc2_:ReadStream = new ReadStream(param1);
         var _loc3_:Array = [];
         while(!_loc2_.atEnd())
         {
            _loc4_ = _loc2_.nextToken();
            if(_loc4_.length > 0)
            {
               _loc3_.push(_loc4_);
            }
         }
         return _loc3_;
      }
      
      public static function escape(param1:String) : String
      {
         return param1.replace(/[\\%@]/g,"\\$&");
      }
      
      public static function unescape(param1:String) : String
      {
         var _loc4_:String = null;
         var _loc2_:String = "";
         var _loc3_:int = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1.charAt(_loc3_);
            if(_loc4_ == "\\")
            {
               _loc2_ += param1.charAt(_loc3_ + 1);
               _loc3_++;
            }
            else
            {
               _loc2_ += _loc4_;
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function atEnd() : Boolean
      {
         return this.i >= this.src.length;
      }
      
      public function next() : String
      {
         if(this.i >= this.src.length)
         {
            return "";
         }
         return this.src.charAt(this.i++);
      }
      
      public function peek() : String
      {
         return this.i < this.src.length ? this.src.charAt(this.i) : "";
      }
      
      public function peek2() : String
      {
         return this.i + 1 < this.src.length ? this.src.charAt(this.i + 1) : "";
      }
      
      public function peekString(param1:int) : String
      {
         return this.src.slice(this.i,this.i + param1);
      }
      
      public function nextString(param1:int) : String
      {
         this.i += param1;
         return this.src.slice(this.i - param1,this.i);
      }
      
      public function pos() : int
      {
         return this.i;
      }
      
      public function setPos(param1:int) : void
      {
         this.i = param1;
      }
      
      public function skip(param1:int) : void
      {
         this.i += param1;
      }
      
      public function skipWhiteSpace() : void
      {
         while(this.i < this.src.length && this.src.charCodeAt(this.i) <= 32)
         {
            ++this.i;
         }
      }
      
      public function upToEnd() : String
      {
         var _loc1_:String = this.i < this.src.length ? this.src.slice(this.i,this.src.length) : "";
         this.i = this.src.length;
         return _loc1_;
      }
      
      public function nextToken() : String
      {
         var _loc2_:Boolean = false;
         var _loc4_:String = null;
         this.skipWhiteSpace();
         if(this.atEnd())
         {
            return "";
         }
         var _loc1_:String = "";
         var _loc3_:int = this.i;
         while(this.i < this.src.length)
         {
            if(this.src.charCodeAt(this.i) <= 32)
            {
               break;
            }
            _loc4_ = this.src.charAt(this.i);
            if(_loc4_ == "\\")
            {
               _loc1_ += _loc4_ + this.src.charAt(this.i + 1);
               this.i += 2;
            }
            else
            {
               if(_loc4_ == "%")
               {
                  if(this.i > _loc3_)
                  {
                     break;
                  }
                  _loc2_ = true;
               }
               if(_loc2_ && (_loc4_ == "?" || _loc4_ == "-"))
               {
                  break;
               }
               _loc1_ += _loc4_;
               ++this.i;
            }
         }
         return _loc1_;
      }
   }
}

