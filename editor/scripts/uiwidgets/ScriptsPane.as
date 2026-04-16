package uiwidgets
{
   import blocks.*;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import scratch.*;
   import ui.media.MediaInfo;
   
   public class ScriptsPane extends ScrollFrameContents
   {
      
      private const INSERT_NORMAL:int = 0;
      
      private const INSERT_ABOVE:int = 1;
      
      private const INSERT_SUB1:int = 2;
      
      private const INSERT_SUB2:int = 3;
      
      private const INSERT_WRAP:int = 4;
      
      public var app:Scratch;
      
      public var padding:int = 10;
      
      private var viewedObj:ScratchObj;
      
      private var commentLines:Shape;
      
      private var possibleTargets:Array = [];
      
      private var nearestTarget:Array = [];
      
      private var feedbackShape:BlockShape;
      
      public function ScriptsPane(param1:Scratch)
      {
         super();
         this.app = param1;
         addChild(this.commentLines = new Shape());
         hExtra = vExtra = 40;
         this.createTexture();
         this.addFeedbackShape();
      }
      
      public static function strings() : Array
      {
         return ["add comment","clean up"];
      }
      
      private function createTexture() : void
      {
         var _loc1_:int = 0;
         _loc1_ = 144 << 24;
         var _loc2_:int = _loc1_ | 0xD7D7D7;
         var _loc3_:int = _loc1_ | 0xCBCBCB;
         var _loc4_:int = _loc1_ | 0xC8C8C8;
         texture = new BitmapData(23,23,true,_loc2_);
         texture.setPixel(11,0,_loc3_);
         texture.setPixel(10,1,_loc3_);
         texture.setPixel(11,1,_loc4_);
         texture.setPixel(12,1,_loc3_);
         texture.setPixel(11,2,_loc3_);
         texture.setPixel(0,11,_loc3_);
         texture.setPixel(1,10,_loc3_);
         texture.setPixel(1,11,_loc4_);
         texture.setPixel(1,12,_loc3_);
         texture.setPixel(2,11,_loc3_);
      }
      
      public function viewScriptsFor(param1:ScratchObj) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Array = null;
         var _loc4_:Block = null;
         var _loc5_:ScratchComment = null;
         this.saveScripts(false);
         while(numChildren > 0)
         {
            _loc2_ = removeChildAt(0);
            _loc2_.cacheAsBitmap = false;
         }
         addChild(this.commentLines);
         this.viewedObj = param1;
         if(this.viewedObj != null)
         {
            _loc3_ = this.viewedObj.allBlocks();
            for each(_loc4_ in this.viewedObj.scripts)
            {
               _loc4_.cacheAsBitmap = true;
               addChild(_loc4_);
            }
            for each(_loc5_ in this.viewedObj.scriptComments)
            {
               _loc5_.updateBlockRef(_loc3_);
               addChild(_loc5_);
            }
         }
         this.fixCommentLayout();
         updateSize();
         x = y = 0;
         (parent as ScrollFrame).updateScrollbars();
      }
      
      public function saveScripts(param1:Boolean = true) : void
      {
         var _loc4_:ScratchComment = null;
         var _loc5_:* = undefined;
         if(this.viewedObj == null)
         {
            return;
         }
         this.viewedObj.scripts.splice(0);
         this.viewedObj.scriptComments.splice(0);
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc5_ = getChildAt(_loc2_);
            if(_loc5_ is Block)
            {
               this.viewedObj.scripts.push(_loc5_);
            }
            if(_loc5_ is ScratchComment)
            {
               this.viewedObj.scriptComments.push(_loc5_);
            }
            _loc2_++;
         }
         var _loc3_:Array = this.viewedObj.allBlocks();
         for each(_loc4_ in this.viewedObj.scriptComments)
         {
            _loc4_.updateBlockID(_loc3_);
         }
         if(param1)
         {
            this.app.setSaveNeeded();
         }
         this.fixCommentLayout();
      }
      
      public function prepareToDrag(param1:Block) : void
      {
         this.findTargetsFor(param1);
         this.nearestTarget = null;
         param1.scaleX = param1.scaleY = scaleX;
         this.addFeedbackShape();
      }
      
      public function prepareToDragComment(param1:ScratchComment) : void
      {
         param1.scaleX = param1.scaleY = scaleX;
      }
      
      public function draggingDone() : void
      {
         this.hideFeedbackShape();
         this.possibleTargets = [];
         this.nearestTarget = null;
      }
      
      public function updateFeedbackFor(param1:Block) : void
      {
         var b:Block = param1;
         var updateHeight:Function = function():void
         {
            var _loc2_:* = undefined;
            var _loc3_:Block = null;
            var _loc1_:int = BlockShape.EmptySubstackH;
            if(nearestTarget != null)
            {
               _loc2_ = nearestTarget[1];
               _loc3_ = null;
               switch(nearestTarget[2])
               {
                  case INSERT_NORMAL:
                     _loc3_ = _loc2_.nextBlock;
                     break;
                  case INSERT_WRAP:
                     _loc3_ = _loc2_;
                     break;
                  case INSERT_SUB1:
                     _loc3_ = _loc2_.subStack1;
                     break;
                  case INSERT_SUB2:
                     _loc3_ = _loc2_.subStack2;
               }
               if(_loc3_)
               {
                  _loc1_ = _loc3_.height;
                  if(!_loc3_.bottomBlock().isTerminal)
                  {
                     _loc1_ -= BlockShape.NotchDepth;
                  }
               }
            }
            b.previewSubstack1Height(_loc1_);
         };
         var updateFeedbackShape:Function = function():void
         {
            var _loc2_:Point = null;
            var _loc3_:int = 0;
            var _loc4_:int = 0;
            var _loc5_:Boolean = false;
            var _loc1_:* = nearestTarget[1];
            _loc2_ = globalToLocal(nearestTarget[0]);
            feedbackShape.x = _loc2_.x;
            feedbackShape.y = _loc2_.y;
            feedbackShape.visible = true;
            if(b.isReporter)
            {
               if(_loc1_ is Block)
               {
                  feedbackShape.copyFeedbackShapeFrom(_loc1_,true);
               }
               if(_loc1_ is BlockArg)
               {
                  feedbackShape.copyFeedbackShapeFrom(_loc1_,true);
               }
            }
            else
            {
               _loc3_ = int(nearestTarget[2]);
               _loc4_ = _loc3_ == INSERT_WRAP ? int(_loc1_.getRect(_loc1_).height) : 0;
               _loc5_ = _loc3_ != INSERT_ABOVE && _loc3_ != INSERT_WRAP;
               feedbackShape.copyFeedbackShapeFrom(b,false,_loc5_,_loc4_);
            }
         };
         if(mouseX + x >= 0)
         {
            this.nearestTarget = this.nearestTargetForBlockIn(b,this.possibleTargets);
            if(this.nearestTarget != null)
            {
               updateFeedbackShape();
            }
            else
            {
               this.hideFeedbackShape();
            }
            if(b.base.canHaveSubstack1() && !b.subStack1)
            {
               updateHeight();
            }
         }
         else
         {
            this.nearestTarget = null;
            this.hideFeedbackShape();
         }
         this.fixCommentLayout();
      }
      
      public function allStacks() : Array
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ is Block)
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      private function blockDropped(param1:Block) : void
      {
         var _loc2_:Block = null;
         if(this.nearestTarget == null)
         {
            param1.cacheAsBitmap = true;
         }
         else
         {
            if(this.app.editMode)
            {
               param1.hideRunFeedback();
            }
            param1.cacheAsBitmap = false;
            if(param1.isReporter)
            {
               Block(this.nearestTarget[1].parent).replaceArgWithBlock(this.nearestTarget[1],param1,this);
            }
            else
            {
               _loc2_ = this.nearestTarget[1];
               switch(this.nearestTarget[2])
               {
                  case this.INSERT_NORMAL:
                     _loc2_.insertBlock(param1);
                     break;
                  case this.INSERT_ABOVE:
                     _loc2_.insertBlockAbove(param1);
                     break;
                  case this.INSERT_SUB1:
                     _loc2_.insertBlockSub1(param1);
                     break;
                  case this.INSERT_SUB2:
                     _loc2_.insertBlockSub2(param1);
                     break;
                  case this.INSERT_WRAP:
                     _loc2_.insertBlockAround(param1);
               }
            }
         }
         if(param1.op == Specs.PROCEDURE_DEF)
         {
            this.app.updatePalette();
         }
         this.app.runtime.blockDropped(param1);
      }
      
      public function findTargetsFor(param1:Block) : void
      {
         var _loc4_:Point = null;
         var _loc6_:DisplayObject = null;
         var _loc7_:Block = null;
         this.possibleTargets = [];
         var _loc2_:Boolean = param1.bottomBlock().isTerminal;
         var _loc3_:Boolean = param1.base.canHaveSubstack1() && !param1.subStack1;
         var _loc5_:int = 0;
         while(_loc5_ < numChildren)
         {
            _loc6_ = getChildAt(_loc5_);
            if(_loc6_ is Block)
            {
               _loc7_ = Block(_loc6_);
               if(param1.isReporter)
               {
                  if(this.reporterAllowedInStack(param1,_loc7_))
                  {
                     this.findReporterTargetsIn(_loc7_);
                  }
               }
               else if(!_loc7_.isReporter)
               {
                  if(!_loc2_ && !_loc7_.isHat)
                  {
                     _loc4_ = _loc7_.localToGlobal(new Point(0,-(param1.height - BlockShape.NotchDepth)));
                     this.possibleTargets.push([_loc4_,_loc7_,this.INSERT_ABOVE]);
                  }
                  if(_loc3_ && !_loc7_.isHat)
                  {
                     _loc4_ = _loc7_.localToGlobal(new Point(-BlockShape.SubstackInset,-(param1.base.substack1y() - BlockShape.NotchDepth)));
                     this.possibleTargets.push([_loc4_,_loc7_,this.INSERT_WRAP]);
                  }
                  if(!param1.isHat)
                  {
                     this.findCommandTargetsIn(_loc7_,_loc2_ && !_loc3_);
                  }
               }
            }
            _loc5_++;
         }
      }
      
      private function reporterAllowedInStack(param1:Block, param2:Block) : Boolean
      {
         return true;
      }
      
      private function findCommandTargetsIn(param1:Block, param2:Boolean) : void
      {
         var _loc4_:Point = null;
         var _loc3_:Block = param1;
         while(_loc3_ != null)
         {
            _loc4_ = _loc3_.localToGlobal(new Point(0,0));
            if(!_loc3_.isTerminal && (!param2 || _loc3_.nextBlock == null))
            {
               _loc4_ = _loc3_.localToGlobal(new Point(0,_loc3_.base.nextBlockY() - 3));
               this.possibleTargets.push([_loc4_,_loc3_,this.INSERT_NORMAL]);
            }
            if(_loc3_.base.canHaveSubstack1() && (!param2 || _loc3_.subStack1 == null))
            {
               _loc4_ = _loc3_.localToGlobal(new Point(15,_loc3_.base.substack1y()));
               this.possibleTargets.push([_loc4_,_loc3_,this.INSERT_SUB1]);
            }
            if(_loc3_.base.canHaveSubstack2() && (!param2 || _loc3_.subStack2 == null))
            {
               _loc4_ = _loc3_.localToGlobal(new Point(15,_loc3_.base.substack2y()));
               this.possibleTargets.push([_loc4_,_loc3_,this.INSERT_SUB2]);
            }
            if(_loc3_.subStack1 != null)
            {
               this.findCommandTargetsIn(_loc3_.subStack1,param2);
            }
            if(_loc3_.subStack2 != null)
            {
               this.findCommandTargetsIn(_loc3_.subStack2,param2);
            }
            _loc3_ = _loc3_.nextBlock;
         }
      }
      
      private function findReporterTargetsIn(param1:Block) : void
      {
         var _loc3_:int = 0;
         var _loc4_:DisplayObject = null;
         var _loc5_:Point = null;
         var _loc2_:Block = param1;
         while(_loc2_ != null)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_.args.length)
            {
               _loc4_ = _loc2_.args[_loc3_];
               if(_loc4_ is Block || _loc4_ is BlockArg)
               {
                  _loc5_ = _loc4_.localToGlobal(new Point(0,0));
                  this.possibleTargets.push([_loc5_,_loc4_,this.INSERT_NORMAL]);
                  if(_loc4_ is Block)
                  {
                     this.findReporterTargetsIn(Block(_loc4_));
                  }
               }
               _loc3_++;
            }
            if(_loc2_.subStack1 != null)
            {
               this.findReporterTargetsIn(_loc2_.subStack1);
            }
            if(_loc2_.subStack2 != null)
            {
               this.findReporterTargetsIn(_loc2_.subStack2);
            }
            _loc2_ = _loc2_.nextBlock;
         }
      }
      
      private function addFeedbackShape() : void
      {
         if(this.feedbackShape == null)
         {
            this.feedbackShape = new BlockShape();
         }
         this.feedbackShape.setWidthAndTopHeight(10,10);
         this.hideFeedbackShape();
         addChild(this.feedbackShape);
      }
      
      private function hideFeedbackShape() : void
      {
         this.feedbackShape.visible = false;
      }
      
      private function nearestTargetForBlockIn(param1:Block, param2:Array) : Array
      {
         var _loc4_:int = 0;
         var _loc6_:Array = null;
         var _loc9_:Array = null;
         var _loc10_:Point = null;
         var _loc11_:Number = NaN;
         var _loc3_:int = param1.isReporter ? 15 : 30;
         var _loc5_:int = 100000;
         var _loc7_:Point = new Point(param1.x,param1.y);
         var _loc8_:Point = new Point(param1.x,param1.y + param1.height - 3);
         _loc4_ = 0;
         while(_loc4_ < param2.length)
         {
            _loc9_ = param2[_loc4_];
            _loc10_ = _loc7_.subtract(_loc9_[0]);
            _loc11_ = Math.abs(_loc10_.x / 2) + Math.abs(_loc10_.y);
            if(_loc11_ < _loc5_ && _loc11_ < _loc3_ && this.dropCompatible(param1,_loc9_[1]))
            {
               _loc5_ = _loc11_;
               _loc6_ = _loc9_;
            }
            _loc4_++;
         }
         return _loc5_ < _loc3_ ? _loc6_ : null;
      }
      
      private function dropCompatible(param1:Block, param2:DisplayObject) : Boolean
      {
         var _loc3_:Array = ["broadcast","costume","backdrop","scene","sound","spriteOnly","spriteOrMouse","location","spriteOrStage","touching"];
         if(!param1.isReporter)
         {
            return true;
         }
         if(param2 is Block)
         {
            if(Block(param2).isEmbeddedInProcHat())
            {
               return false;
            }
            if(Block(param2).isEmbeddedParameter())
            {
               return false;
            }
         }
         var _loc4_:String = param1.type;
         var _loc5_:String = param2 is Block ? Block(param2.parent).argType(param2).slice(1) : BlockArg(param2).type;
         if(_loc5_ == "m")
         {
            if(Block(param2.parent).type == "h")
            {
               return false;
            }
            return _loc3_.indexOf(BlockArg(param2).menuName) > -1;
         }
         if(_loc5_ == "b")
         {
            return _loc4_ == "b";
         }
         return true;
      }
      
      public function handleDrop(param1:*) : Boolean
      {
         var _loc2_:Point = globalToLocal(new Point(param1.x,param1.y));
         var _loc3_:MediaInfo = param1 as MediaInfo;
         if(_loc3_)
         {
            if(!_loc3_.scripts)
            {
               return false;
            }
            _loc2_.x += _loc3_.thumbnailX();
            _loc2_.y += _loc3_.thumbnailY();
            this.addStacksFromBackpack(_loc3_,_loc2_);
            return true;
         }
         var _loc4_:Block = param1 as Block;
         var _loc5_:ScratchComment = param1 as ScratchComment;
         if(!_loc4_ && !_loc5_)
         {
            return false;
         }
         param1.x = Math.max(5,_loc2_.x);
         param1.y = Math.max(5,_loc2_.y);
         param1.scaleX = param1.scaleY = 1;
         addChild(param1);
         if(_loc4_)
         {
            this.blockDropped(_loc4_);
         }
         if(_loc5_)
         {
            _loc5_.blockRef = this.blockAtPoint(_loc2_);
         }
         this.saveScripts();
         updateSize();
         if(_loc5_)
         {
            this.fixCommentLayout();
         }
         return true;
      }
      
      private function addStacksFromBackpack(param1:MediaInfo, param2:Point) : void
      {
         var _loc4_:Array = null;
         var _loc5_:* = undefined;
         if(!param1.scripts)
         {
            return;
         }
         var _loc3_:Boolean = Boolean(this.app.viewedObj()) && this.app.viewedObj().isStage;
         for each(_loc4_ in param1.scripts)
         {
            if(_loc4_.length >= 1)
            {
               _loc5_ = _loc4_[0] is Array ? BlockIO.arrayToStack(_loc4_,_loc3_) : ScratchComment.fromArray(_loc4_);
               _loc5_.x = param2.x;
               _loc5_.y = param2.y;
               addChild(_loc5_);
               if(_loc5_ is Block)
               {
                  this.blockDropped(_loc5_);
               }
            }
         }
         this.saveScripts();
         updateSize();
         this.fixCommentLayout();
      }
      
      private function blockAtPoint(param1:Point) : Block
      {
         var result:Block = null;
         var stack:Block = null;
         var p:Point = param1;
         for each(stack in this.allStacks())
         {
            stack.allBlocksDo(function(param1:Block):void
            {
               var _loc2_:Rectangle = null;
               if(!param1.isReporter)
               {
                  _loc2_ = param1.getBounds(parent);
                  if(_loc2_.containsPoint(p) && p.y - _loc2_.y < param1.base.substack1y())
                  {
                     result = param1;
                  }
               }
            });
         }
         return result;
      }
      
      public function menu(param1:MouseEvent) : Menu
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var newComment:Function = null;
         var evt:MouseEvent = param1;
         newComment = function():void
         {
            addComment(null,x,y);
         };
         x = mouseX;
         y = mouseY;
         var m:Menu = new Menu();
         m.addItem("clean up",this.cleanUp);
         m.addItem("add comment",newComment);
         return m;
      }
      
      public function setScale(param1:Number) : void
      {
         x *= param1 / scaleX;
         y *= param1 / scaleY;
         param1 = Math.max(1 / 6,Math.min(param1,6));
         scaleX = scaleY = param1;
         updateSize();
      }
      
      public function addComment(param1:Block = null, param2:Number = 50, param3:Number = 50) : void
      {
         var _loc4_:ScratchComment = new ScratchComment();
         _loc4_.blockRef = param1;
         _loc4_.x = param2;
         _loc4_.y = param3;
         addChild(_loc4_);
         this.saveScripts();
         updateSize();
         _loc4_.startEditText();
      }
      
      public function fixCommentLayout() : void
      {
         var _loc4_:ScratchComment = null;
         var _loc1_:int = 16777088;
         var _loc2_:Graphics = this.commentLines.graphics;
         _loc2_.clear();
         _loc2_.lineStyle(2,_loc1_);
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_) as ScratchComment;
            if(Boolean(_loc4_) && Boolean(_loc4_.blockRef))
            {
               this.updateCommentConnection(_loc4_,_loc2_);
            }
            _loc3_++;
         }
      }
      
      private function updateCommentConnection(param1:ScratchComment, param2:Graphics) : void
      {
         if(!param1.blockRef)
         {
            return;
         }
         var _loc3_:Point = globalToLocal(param1.blockRef.localToGlobal(new Point(0,0)));
         var _loc4_:Block = param1.blockRef.topBlock();
         var _loc5_:Point = globalToLocal(_loc4_.localToGlobal(new Point(0,0)));
         param1.x = param1.isExpanded() ? _loc5_.x + _loc4_.width + 15 : _loc3_.x + param1.blockRef.base.width + 10;
         param1.y = _loc3_.y + (param1.blockRef.base.substack1y() - 20) / 2;
         if(param1.blockRef.isHat)
         {
            param1.y = _loc3_.y + param1.blockRef.base.substack1y() - 25;
         }
         var _loc6_:int = param1.y + 10;
         param2.moveTo(_loc3_.x + param1.blockRef.base.width,_loc6_);
         param2.lineTo(param1.x,_loc6_);
      }
      
      private function cleanUp() : void
      {
         var _loc6_:Array = null;
         var _loc7_:int = 0;
         var _loc8_:Block = null;
         var _loc1_:Array = this.stacksSortedByX();
         var _loc2_:Array = this.assignStacksToColumns(_loc1_);
         var _loc3_:Array = this.computeColumnWidths(_loc2_);
         var _loc4_:int = this.padding;
         var _loc5_:int = 0;
         while(_loc5_ < _loc2_.length)
         {
            _loc6_ = _loc2_[_loc5_];
            _loc7_ = this.padding;
            for each(_loc8_ in _loc6_)
            {
               _loc8_.x = _loc4_;
               _loc8_.y = _loc7_;
               _loc7_ += _loc8_.height + this.padding;
            }
            _loc4_ += _loc3_[_loc5_] + this.padding;
            _loc5_++;
         }
         this.saveScripts();
      }
      
      private function stacksSortedByX() : Array
      {
         var o:* = undefined;
         var stacks:Array = [];
         var i:int = 0;
         while(i < numChildren)
         {
            o = getChildAt(i);
            if(o is Block)
            {
               stacks.push(o);
            }
            i++;
         }
         stacks.sort(function(param1:Block, param2:Block):int
         {
            return param1.x - param2.x;
         });
         return stacks;
      }
      
      private function assignStacksToColumns(param1:Array) : Array
      {
         var _loc3_:Block = null;
         var _loc4_:Boolean = false;
         var _loc5_:Array = null;
         var _loc2_:Array = [];
         for each(_loc3_ in param1)
         {
            _loc4_ = false;
            for each(_loc5_ in _loc2_)
            {
               if(this.fitsInColumn(_loc3_,_loc5_))
               {
                  _loc4_ = true;
                  _loc5_.push(_loc3_);
                  break;
               }
            }
            if(!_loc4_)
            {
               _loc2_.push([_loc3_]);
            }
         }
         return _loc2_;
      }
      
      private function fitsInColumn(param1:Block, param2:Array) : Boolean
      {
         var _loc5_:Block = null;
         var _loc3_:int = param1.y;
         var _loc4_:int = _loc3_ + param1.height;
         for each(_loc5_ in param2)
         {
            if(!(_loc5_.y > _loc4_ || _loc5_.y + _loc5_.height < _loc3_))
            {
               return false;
            }
         }
         return true;
      }
      
      private function computeColumnWidths(param1:Array) : Array
      {
         var c:Array = null;
         var w:int = 0;
         var b:Block = null;
         var columns:Array = param1;
         var widths:Array = [];
         for each(c in columns)
         {
            c.sort(function(param1:Block, param2:Block):int
            {
               return param1.y - param2.y;
            });
            w = 0;
            for each(b in c)
            {
               w = Math.max(w,b.width);
            }
            widths.push(w);
         }
         return widths;
      }
   }
}

