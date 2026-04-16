package primitives
{
   import blocks.Block;
   import flash.utils.Dictionary;
   import interpreter.Interpreter;
   import scratch.ScratchObj;
   import watchers.ListWatcher;
   
   public class ListPrims
   {
      
      private var app:Scratch;
      
      protected var interp:Interpreter;
      
      public function ListPrims(param1:Scratch, param2:Interpreter)
      {
         super();
         this.app = param1;
         this.interp = param2;
      }
      
      public function addPrimsTo(param1:Dictionary) : void
      {
         param1[Specs.GET_LIST] = this.primContents;
         param1["append:toList:"] = this.primAppend;
         param1["deleteLine:ofList:"] = this.primDelete;
         param1["insert:at:ofList:"] = this.primInsert;
         param1["setLine:ofList:to:"] = this.primReplace;
         param1["getLine:ofList:"] = this.primGetItem;
         param1["lineCountOfList:"] = this.primLength;
         param1["list:contains:"] = this.primContains;
      }
      
      private function primContents(param1:Block) : String
      {
         var _loc4_:* = undefined;
         var _loc2_:ListWatcher = this.interp.targetObj().lookupOrCreateList(param1.spec);
         if(!_loc2_)
         {
            return "";
         }
         var _loc3_:Boolean = true;
         for each(_loc4_ in _loc2_.contents)
         {
            if(!(_loc4_ is String && _loc4_.length == 1))
            {
               _loc3_ = false;
               break;
            }
         }
         return _loc2_.contents.join(_loc3_ ? "" : " ");
      }
      
      private function primAppend(param1:Block) : void
      {
         var _loc2_:ListWatcher = this.listarg(param1,1);
         if(!_loc2_)
         {
            return;
         }
         this.listAppend(_loc2_,this.interp.arg(param1,0));
         if(_loc2_.visible)
         {
            _loc2_.updateWatcher(_loc2_.contents.length,false,this.interp);
         }
      }
      
      protected function listAppend(param1:ListWatcher, param2:*) : void
      {
         param1.contents.push(param2);
      }
      
      private function primDelete(param1:Block) : void
      {
         var _loc2_:* = this.interp.arg(param1,0);
         var _loc3_:ListWatcher = this.listarg(param1,1);
         if(!_loc3_)
         {
            return;
         }
         var _loc4_:int = int(_loc3_.contents.length);
         if(_loc2_ == "all")
         {
            this.listSet(_loc3_,[]);
            if(_loc3_.visible)
            {
               _loc3_.updateWatcher(-1,false,this.interp);
            }
         }
         var _loc5_:Number = _loc2_ == "last" ? _loc4_ : Number(_loc2_);
         if(isNaN(_loc5_))
         {
            return;
         }
         var _loc6_:int = Math.round(_loc5_);
         if(_loc6_ < 1 || _loc6_ > _loc4_)
         {
            return;
         }
         this.listDelete(_loc3_,_loc6_);
         if(_loc3_.visible)
         {
            _loc3_.updateWatcher(_loc6_ == _loc4_ ? int(_loc6_ - 1) : _loc6_,false,this.interp);
         }
      }
      
      protected function listSet(param1:ListWatcher, param2:Array) : void
      {
         param1.contents = param2;
      }
      
      protected function listDelete(param1:ListWatcher, param2:int) : void
      {
         param1.contents.splice(param2 - 1,1);
      }
      
      private function primInsert(param1:Block) : void
      {
         var _loc5_:int = 0;
         var _loc2_:* = this.interp.arg(param1,0);
         var _loc3_:* = this.interp.arg(param1,1);
         var _loc4_:ListWatcher = this.listarg(param1,2);
         if(!_loc4_)
         {
            return;
         }
         if(_loc3_ == "last")
         {
            this.listAppend(_loc4_,_loc2_);
            if(_loc4_.visible)
            {
               _loc4_.updateWatcher(_loc4_.contents.length,false,this.interp);
            }
         }
         else
         {
            _loc5_ = this.computeIndex(_loc3_,_loc4_.contents.length + 1);
            if(_loc5_ < 0)
            {
               return;
            }
            this.listInsert(_loc4_,_loc5_,_loc2_);
            if(_loc4_.visible)
            {
               _loc4_.updateWatcher(_loc5_,false,this.interp);
            }
         }
      }
      
      protected function listInsert(param1:ListWatcher, param2:int, param3:*) : void
      {
         param1.contents.splice(param2 - 1,0,param3);
      }
      
      private function primReplace(param1:Block) : void
      {
         var _loc2_:ListWatcher = this.listarg(param1,1);
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = this.computeIndex(this.interp.arg(param1,0),_loc2_.contents.length);
         if(_loc3_ < 0)
         {
            return;
         }
         this.listReplace(_loc2_,_loc3_,this.interp.arg(param1,2));
         if(_loc2_.visible)
         {
            _loc2_.updateWatcher(_loc3_,false,this.interp);
         }
      }
      
      protected function listReplace(param1:ListWatcher, param2:int, param3:*) : void
      {
         param1.contents[param2 - 1] = param3;
      }
      
      private function primGetItem(param1:Block) : *
      {
         var _loc2_:ListWatcher = this.listarg(param1,1);
         if(!_loc2_)
         {
            return "";
         }
         var _loc3_:int = this.computeIndex(this.interp.arg(param1,0),_loc2_.contents.length);
         if(_loc3_ < 0)
         {
            return "";
         }
         if(_loc2_.visible)
         {
            _loc2_.updateWatcher(_loc3_,true,this.interp);
         }
         return _loc2_.contents[_loc3_ - 1];
      }
      
      private function primLength(param1:Block) : Number
      {
         var _loc2_:ListWatcher = this.listarg(param1,0);
         if(!_loc2_)
         {
            return 0;
         }
         return _loc2_.contents.length;
      }
      
      private function primContains(param1:Block) : Boolean
      {
         var _loc4_:* = undefined;
         var _loc2_:ListWatcher = this.listarg(param1,0);
         if(!_loc2_)
         {
            return false;
         }
         var _loc3_:* = this.interp.arg(param1,1);
         if(_loc2_.contents.indexOf(_loc3_) >= 0)
         {
            return true;
         }
         for each(_loc4_ in _loc2_.contents)
         {
            if(Primitives.compare(_loc4_,_loc3_) == 0)
            {
               return true;
            }
         }
         return false;
      }
      
      private function listarg(param1:Block, param2:int) : ListWatcher
      {
         var _loc3_:String = this.interp.arg(param1,param2);
         if(_loc3_.length == 0)
         {
            return null;
         }
         var _loc4_:ScratchObj = this.interp.targetObj();
         var _loc5_:ListWatcher = _loc4_.listCache[_loc3_];
         if(!_loc5_)
         {
            _loc5_ = _loc4_.listCache[_loc3_] = _loc4_.lookupOrCreateList(_loc3_);
         }
         return _loc5_;
      }
      
      private function computeIndex(param1:*, param2:int) : int
      {
         var _loc3_:int = 0;
         if(!(param1 is Number))
         {
            if(param1 == "last")
            {
               return param2 == 0 ? -1 : param2;
            }
            if(param1 == "any" || param1 == "random")
            {
               return param2 == 0 ? -1 : int(1 + Math.floor(Math.random() * param2));
            }
            param1 = Number(param1);
            if(isNaN(param1))
            {
               return -1;
            }
         }
         _loc3_ = param1 is int ? int(param1) : int(Math.floor(param1));
         if(_loc3_ < 1 || _loc3_ > param2)
         {
            return -1;
         }
         return _loc3_;
      }
   }
}

