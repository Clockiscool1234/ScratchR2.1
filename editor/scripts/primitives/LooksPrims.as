package primitives
{
   import blocks.*;
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   import interpreter.*;
   import scratch.*;
   
   public class LooksPrims
   {
      
      private var app:Scratch;
      
      private var interp:Interpreter;
      
      public function LooksPrims(param1:Scratch, param2:Interpreter)
      {
         super();
         this.app = param1;
         this.interp = param2;
      }
      
      public function addPrimsTo(param1:Dictionary) : void
      {
         var primTable:Dictionary = param1;
         primTable["lookLike:"] = this.primShowCostume;
         primTable["nextCostume"] = this.primNextCostume;
         primTable["costumeIndex"] = this.primCostumeIndex;
         primTable["costumeName"] = this.primCostumeName;
         primTable["showBackground:"] = this.primShowCostume;
         primTable["nextBackground"] = this.primNextCostume;
         primTable["backgroundIndex"] = this.primSceneIndex;
         primTable["sceneName"] = this.primSceneName;
         primTable["nextScene"] = function(param1:*):*
         {
            startScene("next backdrop",false);
         };
         primTable["startScene"] = function(param1:*):*
         {
            startScene(interp.arg(param1,0),false);
         };
         primTable["startSceneAndWait"] = function(param1:*):*
         {
            startScene(interp.arg(param1,0),true);
         };
         primTable["say:duration:elapsed:from:"] = function(param1:*):*
         {
            showBubbleAndWait(param1,"talk");
         };
         primTable["say:"] = function(param1:*):*
         {
            showBubble(param1,"talk");
         };
         primTable["think:duration:elapsed:from:"] = function(param1:*):*
         {
            showBubbleAndWait(param1,"think");
         };
         primTable["think:"] = function(param1:*):*
         {
            showBubble(param1,"think");
         };
         primTable["changeGraphicEffect:by:"] = this.primChangeEffect;
         primTable["setGraphicEffect:to:"] = this.primSetEffect;
         primTable["filterReset"] = this.primClearEffects;
         primTable["changeSizeBy:"] = this.primChangeSize;
         primTable["setSizeTo:"] = this.primSetSize;
         primTable["scale"] = this.primSize;
         primTable["show"] = this.primShow;
         primTable["hide"] = this.primHide;
         primTable["comeToFront"] = this.primGoFront;
         primTable["goBackByLayers:"] = this.primGoBack;
         primTable["setVideoState"] = this.primSetVideoState;
         primTable["setVideoTransparency"] = this.primSetVideoTransparency;
         primTable["setRotationStyle"] = this.primSetRotationStyle;
      }
      
      private function primNextCostume(param1:Block) : void
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_ != null)
         {
            _loc2_.showCostume(_loc2_.currentCostumeIndex + 1);
         }
         if(_loc2_.visible)
         {
            this.interp.redraw();
         }
      }
      
      private function primShowCostume(param1:Block) : void
      {
         var _loc4_:int = 0;
         var _loc5_:Number = NaN;
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:* = this.interp.arg(param1,0);
         if(typeof _loc3_ == "number")
         {
            _loc2_.showCostume(_loc3_ - 1);
         }
         else
         {
            _loc4_ = _loc2_.indexOfCostumeNamed(_loc3_);
            if(_loc4_ >= 0)
            {
               _loc2_.showCostume(_loc4_);
            }
            else if("previous costume" == _loc3_)
            {
               _loc2_.showCostume(_loc2_.currentCostumeIndex - 1);
            }
            else if("next costume" == _loc3_)
            {
               _loc2_.showCostume(_loc2_.currentCostumeIndex + 1);
            }
            else
            {
               _loc5_ = Interpreter.asNumber(_loc3_);
               if(isNaN(_loc5_))
               {
                  return;
               }
               _loc2_.showCostume(_loc5_ - 1);
            }
         }
         if(_loc2_.visible)
         {
            this.interp.redraw();
         }
      }
      
      private function primCostumeIndex(param1:Block) : Number
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         return _loc2_ == null ? 1 : _loc2_.costumeNumber();
      }
      
      private function primCostumeName(param1:Block) : String
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         return _loc2_ == null ? "" : _loc2_.currentCostume().costumeName;
      }
      
      private function primSceneIndex(param1:Block) : Number
      {
         return this.app.stagePane.costumeNumber();
      }
      
      private function primSceneName(param1:Block) : String
      {
         return this.app.stagePane.currentCostume().costumeName;
      }
      
      private function startScene(param1:*, param2:Boolean) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Number = NaN;
         if(typeof param1 == "number")
         {
            param1 = this.backdropNameAt(param1 - 1);
         }
         else if("next backdrop" == param1)
         {
            param1 = this.backdropNameAt(this.app.stagePane.currentCostumeIndex + 1);
         }
         else if("previous backdrop" == param1)
         {
            param1 = this.backdropNameAt(this.app.stagePane.currentCostumeIndex - 1);
         }
         else
         {
            _loc3_ = this.app.stagePane.indexOfCostumeNamed(param1);
            if(_loc3_ >= 0)
            {
               param1 = this.backdropNameAt(_loc3_);
            }
            else
            {
               _loc4_ = Interpreter.asNumber(param1);
               if(!isNaN(_loc4_))
               {
                  param1 = this.backdropNameAt(_loc4_ - 1);
               }
            }
         }
         this.interp.startScene(param1,param2);
      }
      
      private function backdropNameAt(param1:int) : String
      {
         var _loc2_:Array = this.app.stagePane.costumes;
         return _loc2_[(param1 + _loc2_.length) % _loc2_.length].costumeName;
      }
      
      private function showBubbleAndWait(param1:Block, param2:String) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Number = NaN;
         var _loc5_:ScratchSprite = this.interp.targetSprite();
         if(_loc5_ == null)
         {
            return;
         }
         if(this.interp.activeThread.firstTime)
         {
            _loc3_ = this.interp.arg(param1,0);
            _loc4_ = this.interp.numarg(param1,1);
            _loc5_.showBubble(_loc3_,param2,param1);
            if(_loc5_.visible)
            {
               this.interp.redraw();
            }
            this.interp.startTimer(_loc4_);
         }
         else if(Boolean(this.interp.checkTimer()) && Boolean(_loc5_.bubble) && _loc5_.bubble.getSource() == param1)
         {
            _loc5_.hideBubble();
         }
      }
      
      private function showBubble(param1:Block, param2:String = null) : void
      {
         var _loc3_:* = undefined;
         var _loc4_:Number = NaN;
         var _loc5_:ScratchSprite = this.interp.targetSprite();
         if(_loc5_ == null)
         {
            return;
         }
         if(param2 == null)
         {
            param2 = this.interp.arg(param1,0);
            _loc3_ = this.interp.arg(param1,1);
         }
         else
         {
            _loc3_ = this.interp.arg(param1,0);
         }
         _loc5_.showBubble(_loc3_,param2,param1);
         if(_loc5_.visible)
         {
            this.interp.redraw();
         }
      }
      
      private function primChangeEffect(param1:Block) : void
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:String = this.interp.arg(param1,0);
         var _loc4_:Number = this.interp.numarg(param1,1);
         if(_loc4_ == 0)
         {
            return;
         }
         var _loc5_:Number = _loc2_.filterPack.getFilterSetting(_loc3_) + _loc4_;
         _loc2_.filterPack.setFilter(_loc3_,_loc5_);
         _loc2_.applyFilters();
         if(_loc2_.visible || _loc2_ == Scratch.app.stagePane)
         {
            this.interp.redraw();
         }
      }
      
      private function primSetEffect(param1:Block) : void
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:String = this.interp.arg(param1,0);
         var _loc4_:Number = this.interp.numarg(param1,1);
         if(_loc2_.filterPack.setFilter(_loc3_,_loc4_))
         {
            _loc2_.applyFilters();
         }
         if(_loc2_.visible || _loc2_ == Scratch.app.stagePane)
         {
            this.interp.redraw();
         }
      }
      
      private function primClearEffects(param1:Block) : void
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         _loc2_.clearFilters();
         _loc2_.applyFilters();
         if(_loc2_.visible || _loc2_ == Scratch.app.stagePane)
         {
            this.interp.redraw();
         }
      }
      
      private function primChangeSize(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Number = _loc2_.scaleX;
         _loc2_.setSize(_loc2_.getSize() + this.interp.numarg(param1,0));
         if(_loc2_.visible && _loc2_.scaleX != _loc3_)
         {
            this.interp.redraw();
         }
      }
      
      private function primSetRotationStyle(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         var _loc3_:String = this.interp.arg(param1,0) as String;
         if(_loc2_ == null || _loc3_ == null)
         {
            return;
         }
         _loc2_.setRotationStyle(_loc3_);
      }
      
      private function primSetSize(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.setSize(this.interp.numarg(param1,0));
         if(_loc2_.visible)
         {
            this.interp.redraw();
         }
      }
      
      private function primSize(param1:Block) : Number
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return 100;
         }
         return Math.round(_loc2_.getSize());
      }
      
      private function primShow(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.visible = true;
         if(!this.app.isIn3D)
         {
            _loc2_.applyFilters();
         }
         _loc2_.updateBubble();
         if(_loc2_.visible)
         {
            this.interp.redraw();
         }
      }
      
      private function primHide(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null || !_loc2_.visible)
         {
            return;
         }
         _loc2_.visible = false;
         if(!this.app.isIn3D)
         {
            _loc2_.applyFilters();
         }
         _loc2_.updateBubble();
         this.interp.redraw();
      }
      
      private function primHideAll(param1:Block) : void
      {
         var _loc3_:* = undefined;
         if(!this.interp.targetObj().isStage)
         {
            return;
         }
         this.app.stagePane.deleteClones();
         var _loc2_:int = 0;
         while(_loc2_ < this.app.stagePane.numChildren)
         {
            _loc3_ = this.app.stagePane.getChildAt(_loc2_);
            if(_loc3_ is ScratchSprite)
            {
               _loc3_.visible = false;
               _loc3_.updateBubble();
            }
            _loc2_++;
         }
         this.interp.redraw();
      }
      
      private function primGoFront(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null || _loc2_.parent == null)
         {
            return;
         }
         _loc2_.parent.setChildIndex(_loc2_,_loc2_.parent.numChildren - 1);
         if(_loc2_.visible)
         {
            this.interp.redraw();
         }
      }
      
      private function primGoBack(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null || _loc2_.parent == null)
         {
            return;
         }
         var _loc3_:int = _loc2_.parent.getChildIndex(_loc2_) - this.interp.numarg(param1,0);
         _loc3_ = Math.max(this.minSpriteLayer(),Math.min(_loc3_,_loc2_.parent.numChildren - 1));
         if(_loc3_ > 0 && _loc3_ < _loc2_.parent.numChildren)
         {
            _loc2_.parent.setChildIndex(_loc2_,_loc3_);
            if(_loc2_.visible)
            {
               this.interp.redraw();
            }
         }
      }
      
      private function minSpriteLayer() : int
      {
         var _loc1_:ScratchStage = this.app.stagePane;
         return _loc1_.getChildIndex(_loc1_.videoImage ? _loc1_.videoImage : _loc1_.penLayer) + 1;
      }
      
      private function primSetVideoState(param1:Block) : void
      {
         this.app.stagePane.setVideoState(this.interp.arg(param1,0));
      }
      
      private function primSetVideoTransparency(param1:Block) : void
      {
         this.app.stagePane.setVideoTransparency(this.interp.numarg(param1,0));
         this.app.stagePane.setVideoState("on");
      }
      
      private function primScrollAlign(param1:Block) : void
      {
         if(!this.interp.targetObj().isStage)
         {
            return;
         }
         this.app.stagePane.scrollAlign(this.interp.arg(param1,0));
      }
      
      private function primScrollRight(param1:Block) : void
      {
         if(!this.interp.targetObj().isStage)
         {
            return;
         }
         this.app.stagePane.scrollRight(this.interp.numarg(param1,0));
      }
      
      private function primScrollUp(param1:Block) : void
      {
         if(!this.interp.targetObj().isStage)
         {
            return;
         }
         this.app.stagePane.scrollUp(this.interp.numarg(param1,0));
      }
   }
}

