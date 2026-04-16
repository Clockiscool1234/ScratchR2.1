package util
{
   import blocks.*;
   import flash.display.DisplayObject;
   import interpreter.Variable;
   import scratch.*;
   import watchers.*;
   
   public class OldProjectReader
   {
      
      public function OldProjectReader()
      {
         super();
      }
      
      public function extractProject(param1:Array) : ScratchStage
      {
         var _loc5_:Array = null;
         var _loc6_:int = 0;
         var _loc7_:ScratchSprite = null;
         var _loc8_:Number = NaN;
         var _loc9_:ScratchCostume = null;
         var _loc2_:ScratchStage = new ScratchStage();
         var _loc3_:Array = [];
         this.recordSpriteNames(param1);
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            _loc6_ = int(_loc5_[1]);
            if(_loc6_ == 125)
            {
               _loc3_ = _loc5_[5];
               _loc2_ = _loc5_[0];
               _loc2_.objName = _loc5_[9];
               _loc2_.variables = this.buildVars(_loc5_[10]);
               _loc2_.scripts = this.buildScripts(_loc5_[11]);
               _loc2_.scriptComments = this.buildComments(_loc5_[11]);
               this.fixCommentRefs(_loc2_.scriptComments,_loc2_.scripts);
               _loc2_.setMedia(_loc5_[13],_loc5_[14]);
               if(_loc5_.length > 19)
               {
                  this.recordSpriteLibraryOrder(_loc5_[19]);
               }
               if(_loc5_.length > 21)
               {
                  _loc2_.tempoBPM = _loc5_[21];
               }
               if(_loc5_.length > 23)
               {
                  _loc2_.lists = this.buildLists(_loc5_[23],_loc2_);
               }
            }
            if(_loc6_ == 124)
            {
               _loc7_ = _loc5_[0];
               _loc7_.objName = _loc5_[9];
               _loc7_.variables = this.buildVars(_loc5_[10]);
               _loc7_.scripts = this.buildScripts(_loc5_[11]);
               _loc7_.scriptComments = this.buildComments(_loc5_[11]);
               this.fixCommentRefs(_loc7_.scriptComments,_loc7_.scripts);
               _loc7_.setMedia(_loc5_[13],_loc5_[14]);
               _loc7_.visible = (_loc5_[7] & 1) == 0;
               _loc7_.scaleX = _loc7_.scaleY = _loc5_[16][0];
               _loc7_.rotationStyle = _loc5_[18];
               _loc8_ = Math.round(_loc5_[17] * 1000000) / 1000000;
               _loc7_.setDirection(_loc8_ - 270);
               if(_loc5_.length > 21)
               {
                  _loc7_.isDraggable = _loc5_[21];
               }
               if(_loc5_.length > 23)
               {
                  _loc7_.lists = this.buildLists(_loc5_[23],_loc7_);
               }
               _loc9_ = _loc7_.currentCostume();
               _loc7_.setScratchXY(_loc5_[3][0] + _loc9_.rotationCenterX - 240,180 - (_loc5_[3][1] + _loc9_.rotationCenterY));
            }
            _loc4_++;
         }
         _loc4_ = int(_loc3_.length - 1);
         while(_loc4_ >= 0)
         {
            if(_loc3_[_loc4_] is DisplayObject)
            {
               _loc2_.addChild(_loc3_[_loc4_]);
            }
            _loc4_--;
         }
         this.fixWatchers(_loc2_);
         return _loc2_;
      }
      
      private function recordSpriteNames(param1:Array) : void
      {
         var _loc3_:Array = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            if(_loc3_[1] == 124)
            {
               ScratchSprite(_loc3_[0]).objName = _loc3_[9];
            }
            _loc2_++;
         }
      }
      
      private function fixWatchers(param1:ScratchStage) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Watcher = null;
         var _loc5_:ScratchObj = null;
         var _loc6_:Variable = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc2_);
            if(_loc3_ is Watcher)
            {
               _loc4_ = _loc3_ as Watcher;
               _loc5_ = _loc4_.target;
               for each(_loc6_ in _loc5_.variables)
               {
                  if(_loc4_.isVarWatcherFor(_loc5_,_loc6_.name))
                  {
                     _loc6_.watcher = _loc4_;
                  }
               }
            }
            if(_loc3_ is ListWatcher)
            {
               _loc3_.updateTitleAndContents();
            }
            _loc2_++;
         }
      }
      
      private function recordSpriteLibraryOrder(param1:Array) : void
      {
         var _loc3_:ScratchSprite = null;
         var _loc2_:int = 0;
         while(_loc2_ < param1.length)
         {
            _loc3_ = param1[_loc2_];
            _loc3_.indexInLibrary = _loc2_;
            _loc2_++;
         }
      }
      
      private function buildVars(param1:Array) : Array
      {
         if(param1 == null)
         {
            return [];
         }
         var _loc2_:Array = [];
         var _loc3_:int = 0;
         while(_loc3_ < param1.length - 1)
         {
            _loc2_.push(new Variable(param1[_loc3_],param1[_loc3_ + 1]));
            _loc3_ += 2;
         }
         return _loc2_;
      }
      
      private function buildLists(param1:Array, param2:ScratchObj) : Array
      {
         var _loc5_:ListWatcher = null;
         if(param1 == null)
         {
            return [];
         }
         var _loc3_:Array = [];
         var _loc4_:int = 0;
         while(_loc4_ < param1.length - 1)
         {
            _loc5_ = ListWatcher(param1[_loc4_ + 1]);
            _loc5_.target = param2;
            _loc3_.push(_loc5_);
            _loc4_ += 2;
         }
         return _loc3_;
      }
      
      private function buildScripts(param1:Array) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:Block = null;
         if(!(param1[0] is Array))
         {
            return [];
         }
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_[1][0];
            if(!(Boolean(_loc4_) && _loc4_[0] == "scratchComment"))
            {
               _loc5_ = BlockIO.arrayToStack(_loc3_[1]);
               _loc5_.x = _loc3_[0][0];
               _loc5_.y = _loc3_[0][1];
               _loc2_.push(_loc5_);
            }
         }
         return _loc2_;
      }
      
      private function buildComments(param1:Array) : Array
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:int = 0;
         var _loc6_:ScratchComment = null;
         if(!(param1[0] is Array))
         {
            return [];
         }
         _loc2_ = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_[1][0];
            if(!(Boolean(_loc4_) && _loc4_[0] != "scratchComment"))
            {
               _loc5_ = _loc4_[4] ? int(_loc4_[4]) : -1;
               _loc6_ = new ScratchComment(_loc4_[1],_loc4_[2],_loc4_[3],_loc5_);
               _loc6_.x = _loc3_[0][0];
               _loc6_.y = _loc3_[0][1];
               _loc2_.push(_loc6_);
            }
         }
         return _loc2_;
      }
      
      private function fixCommentRefs(param1:Array, param2:Array) : void
      {
         var _loc5_:Block = null;
         var _loc6_:ScratchComment = null;
         var _loc7_:Block = null;
         var _loc8_:int = 0;
         var _loc3_:Array = [null];
         var _loc4_:Array = [];
         for each(_loc5_ in param2)
         {
            _loc5_.fixStackLayout();
            this.oldAddAllBlocksTo(_loc5_,_loc3_);
            this.newAddAllBlocksTo(_loc5_,_loc4_);
         }
         for each(_loc6_ in param1)
         {
            if(_loc6_.blockID > 0 && _loc6_.blockID < _loc3_.length)
            {
               _loc7_ = _loc3_[_loc6_.blockID] as Block;
               _loc8_ = _loc4_.indexOf(_loc7_);
               _loc6_.blockID = _loc8_;
            }
         }
      }
      
      private function oldAddAllBlocksTo(param1:Block, param2:Array) : void
      {
         if(param1.subStack2)
         {
            this.oldAddAllBlocksTo(param1.subStack2,param2);
         }
         if(param1.subStack1)
         {
            this.oldAddAllBlocksTo(param1.subStack1,param2);
         }
         if(param1.nextBlock)
         {
            this.oldAddAllBlocksTo(param1.nextBlock,param2);
         }
         param2.push(param1);
      }
      
      private function newAddAllBlocksTo(param1:Block, param2:Array) : void
      {
         param2.push(param1);
         if(param1.subStack1)
         {
            this.newAddAllBlocksTo(param1.subStack1,param2);
         }
         if(param1.subStack2)
         {
            this.newAddAllBlocksTo(param1.subStack2,param2);
         }
         if(param1.nextBlock)
         {
            this.newAddAllBlocksTo(param1.nextBlock,param2);
         }
      }
      
      private function arrayToString(param1:Array) : String
      {
         var _loc3_:int = 0;
         var _loc2_:String = "[";
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc2_ += param1[_loc3_] is Array ? this.arrayToString(param1[_loc3_]) : param1[_loc3_];
            if(_loc3_ < param1.length - 1)
            {
               _loc2_ += " ";
            }
            _loc3_++;
         }
         return _loc2_ + "]";
      }
   }
}

