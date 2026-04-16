package primitives
{
   import blocks.*;
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.Dictionary;
   import interpreter.*;
   import scratch.*;
   
   public class MotionAndPenPrims
   {
      
      private var app:Scratch;
      
      private var interp:Interpreter;
      
      public function MotionAndPenPrims(param1:Scratch, param2:Interpreter)
      {
         super();
         this.app = param1;
         this.interp = param2;
      }
      
      public function addPrimsTo(param1:Dictionary) : void
      {
         param1["forward:"] = this.primMove;
         param1["turnRight:"] = this.primTurnRight;
         param1["turnLeft:"] = this.primTurnLeft;
         param1["heading:"] = this.primSetDirection;
         param1["pointTowards:"] = this.primPointTowards;
         param1["gotoX:y:"] = this.primGoTo;
         param1["gotoSpriteOrMouse:"] = this.primGoToSpriteOrMouse;
         param1["glideSecs:toX:y:elapsed:from:"] = this.primGlide;
         param1["changeXposBy:"] = this.primChangeX;
         param1["xpos:"] = this.primSetX;
         param1["changeYposBy:"] = this.primChangeY;
         param1["ypos:"] = this.primSetY;
         param1["bounceOffEdge"] = this.primBounceOffEdge;
         param1["xpos"] = this.primXPosition;
         param1["ypos"] = this.primYPosition;
         param1["heading"] = this.primDirection;
         param1["clearPenTrails"] = this.primClear;
         param1["putPenDown"] = this.primPenDown;
         param1["putPenUp"] = this.primPenUp;
         param1["penColor:"] = this.primSetPenColor;
         param1["setPenHueTo:"] = this.primSetPenHue;
         param1["changePenHueBy:"] = this.primChangePenHue;
         param1["setPenShadeTo:"] = this.primSetPenShade;
         param1["changePenShadeBy:"] = this.primChangePenShade;
         param1["penSize:"] = this.primSetPenSize;
         param1["changePenSizeBy:"] = this.primChangePenSize;
         param1["stampCostume"] = this.primStamp;
      }
      
      private function primMove(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:Number = Math.PI * (90 - _loc2_.direction) / 180;
         var _loc4_:Number = this.interp.numarg(param1,0);
         this.moveSpriteTo(_loc2_,_loc2_.scratchX + _loc4_ * Math.cos(_loc3_),_loc2_.scratchY + _loc4_ * Math.sin(_loc3_));
      }
      
      private function primTurnRight(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setDirection(_loc2_.direction + this.interp.numarg(param1,0));
            if(_loc2_.visible)
            {
               this.interp.redraw();
            }
         }
      }
      
      private function primTurnLeft(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setDirection(_loc2_.direction - this.interp.numarg(param1,0));
            if(_loc2_.visible)
            {
               this.interp.redraw();
            }
         }
      }
      
      private function primSetDirection(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setDirection(this.interp.numarg(param1,0));
            if(_loc2_.visible)
            {
               this.interp.redraw();
            }
         }
      }
      
      private function primPointTowards(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         var _loc3_:Point = this.mouseOrSpritePosition(this.interp.arg(param1,0));
         if(_loc2_ == null || _loc3_ == null)
         {
            return;
         }
         var _loc4_:Number = _loc3_.x - _loc2_.scratchX;
         var _loc5_:Number = _loc3_.y - _loc2_.scratchY;
         var _loc6_:Number = 90 - Math.atan2(_loc5_,_loc4_) * 180 / Math.PI;
         _loc2_.setDirection(_loc6_);
         if(_loc2_.visible)
         {
            this.interp.redraw();
         }
      }
      
      private function primGoTo(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            this.moveSpriteTo(_loc2_,this.interp.numarg(param1,0),this.interp.numarg(param1,1));
         }
      }
      
      private function primGoToSpriteOrMouse(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         var _loc3_:Point = this.mouseOrSpritePosition(this.interp.arg(param1,0));
         if(_loc2_ == null || _loc3_ == null)
         {
            return;
         }
         this.moveSpriteTo(_loc2_,_loc3_.x,_loc3_.y);
      }
      
      private function primGlide(param1:Block) : void
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:Array = null;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return;
         }
         if(this.interp.activeThread.firstTime)
         {
            _loc3_ = this.interp.numarg(param1,0);
            _loc4_ = this.interp.numarg(param1,1);
            _loc5_ = this.interp.numarg(param1,2);
            if(_loc3_ <= 0)
            {
               this.moveSpriteTo(_loc2_,_loc4_,_loc5_);
               return;
            }
            this.interp.activeThread.tmpObj = [this.interp.currentMSecs,1000 * _loc3_,_loc2_.scratchX,_loc2_.scratchY,_loc4_,_loc5_];
            this.interp.startTimer(_loc3_);
         }
         else
         {
            _loc6_ = this.interp.activeThread.tmpObj;
            if(!this.interp.checkTimer())
            {
               _loc7_ = (this.interp.currentMSecs - _loc6_[0]) / _loc6_[1];
               _loc8_ = _loc6_[2] + _loc7_ * (_loc6_[4] - _loc6_[2]);
               _loc9_ = _loc6_[3] + _loc7_ * (_loc6_[5] - _loc6_[3]);
               this.moveSpriteTo(_loc2_,_loc8_,_loc9_);
            }
            else
            {
               this.moveSpriteTo(_loc2_,_loc6_[4],_loc6_[5]);
               this.interp.activeThread.tmpObj = null;
            }
         }
      }
      
      private function mouseOrSpritePosition(param1:String) : Point
      {
         var _loc2_:ScratchStage = null;
         var _loc3_:ScratchSprite = null;
         if(param1 == "_mouse_")
         {
            _loc2_ = this.app.stagePane;
            return new Point(_loc2_.scratchMouseX(),_loc2_.scratchMouseY());
         }
         if(param1 == "_random_")
         {
            return new Point(Math.round(Math.random() * 480 - 240),Math.round(Math.random() * 360 - 180));
         }
         _loc3_ = this.app.stagePane.spriteNamed(param1);
         if(_loc3_ == null)
         {
            return null;
         }
         return new Point(_loc3_.scratchX,_loc3_.scratchY);
      }
      
      private function primChangeX(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            this.moveSpriteTo(_loc2_,_loc2_.scratchX + this.interp.numarg(param1,0),_loc2_.scratchY);
         }
      }
      
      private function primSetX(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            this.moveSpriteTo(_loc2_,this.interp.numarg(param1,0),_loc2_.scratchY);
         }
      }
      
      private function primChangeY(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            this.moveSpriteTo(_loc2_,_loc2_.scratchX,_loc2_.scratchY + this.interp.numarg(param1,0));
         }
      }
      
      private function primSetY(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            this.moveSpriteTo(_loc2_,_loc2_.scratchX,this.interp.numarg(param1,0));
         }
      }
      
      private function primBounceOffEdge(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return;
         }
         if(!this.turnAwayFromEdge(_loc2_))
         {
            return;
         }
         this.ensureOnStageOnBounce(_loc2_);
         if(_loc2_.visible)
         {
            this.interp.redraw();
         }
      }
      
      private function primXPosition(param1:Block) : Number
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         return _loc2_ != null ? this.snapToInteger(_loc2_.scratchX) : 0;
      }
      
      private function primYPosition(param1:Block) : Number
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         return _loc2_ != null ? this.snapToInteger(_loc2_.scratchY) : 0;
      }
      
      private function primDirection(param1:Block) : Number
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         return _loc2_ != null ? this.snapToInteger(_loc2_.direction) : 0;
      }
      
      private function snapToInteger(param1:Number) : Number
      {
         var _loc2_:Number = Math.round(param1);
         var _loc3_:Number = param1 - _loc2_;
         if(_loc3_ < 0)
         {
            _loc3_ = -_loc3_;
         }
         return _loc3_ < 1e-9 ? _loc2_ : param1;
      }
      
      private function primClear(param1:Block) : void
      {
         this.app.stagePane.clearPenStrokes();
         this.interp.redraw();
      }
      
      private function primPenDown(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.penIsDown = true;
         }
         this.touch(_loc2_,_loc2_.scratchX,_loc2_.scratchY);
         this.interp.redraw();
      }
      
      private function touch(param1:ScratchSprite, param2:Number, param3:Number) : void
      {
         var _loc4_:Graphics = this.app.stagePane.newPenStrokes.graphics;
         _loc4_.lineStyle();
         var _loc5_:Number = (0xFF & param1.penColorCache >> 24) / 255;
         if(_loc5_ == 0)
         {
            _loc5_ = 1;
         }
         _loc4_.beginFill(0xFFFFFF & param1.penColorCache,_loc5_);
         _loc4_.drawCircle(240 + param2,180 - param3,param1.penWidth / 2);
         _loc4_.endFill();
         this.app.stagePane.penActivity = true;
      }
      
      private function primPenUp(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.penIsDown = false;
         }
      }
      
      private function primSetPenColor(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setPenColor(this.interp.numarg(param1,0));
         }
      }
      
      private function primSetPenHue(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setPenHue(this.interp.numarg(param1,0));
         }
      }
      
      private function primChangePenHue(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setPenHue(_loc2_.penHue + this.interp.numarg(param1,0));
         }
      }
      
      private function primSetPenShade(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setPenShade(this.interp.numarg(param1,0));
         }
      }
      
      private function primChangePenShade(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setPenShade(_loc2_.penShade + this.interp.numarg(param1,0));
         }
      }
      
      private function primSetPenSize(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setPenSize(Math.max(1,Math.min(960,Math.round(this.interp.numarg(param1,0)))));
         }
      }
      
      private function primChangePenSize(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ != null)
         {
            _loc2_.setPenSize(_loc2_.penWidth + this.interp.numarg(param1,0));
         }
      }
      
      private function primStamp(param1:Block) : void
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         var _loc3_:Number = Scratch.app.isIn3D ? 1 - Math.max(0,Math.min(_loc2_.filterPack.getFilterSetting("ghost"),100)) / 100 : _loc2_.img.transform.colorTransform.alphaMultiplier;
         this.doStamp(_loc2_,_loc3_);
      }
      
      private function doStamp(param1:ScratchSprite, param2:Number) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.app.stagePane.stampSprite(param1,param2);
         this.interp.redraw();
      }
      
      private function moveSpriteTo(param1:ScratchSprite, param2:Number, param3:Number) : void
      {
         if(!(param1.parent is ScratchStage))
         {
            return;
         }
         var _loc4_:Number = param1.scratchX;
         var _loc5_:Number = param1.scratchY;
         param1.setScratchXY(param2,param3);
         param1.keepOnStage();
         if(param1.penIsDown)
         {
            this.stroke(param1,_loc4_,_loc5_,param1.scratchX,param1.scratchY);
         }
         if(param1.penIsDown || param1.visible)
         {
            this.interp.redraw();
         }
      }
      
      private function stroke(param1:ScratchSprite, param2:Number, param3:Number, param4:Number, param5:Number) : void
      {
         var _loc6_:Graphics = this.app.stagePane.newPenStrokes.graphics;
         var _loc7_:Number = (0xFF & param1.penColorCache >> 24) / 255;
         if(_loc7_ == 0)
         {
            _loc7_ = 1;
         }
         _loc6_.lineStyle(param1.penWidth,0xFFFFFF & param1.penColorCache,_loc7_);
         _loc6_.moveTo(240 + param2,180 - param3);
         _loc6_.lineTo(240 + param4,180 - param5);
         this.app.stagePane.penActivity = true;
      }
      
      private function turnAwayFromEdge(param1:ScratchSprite) : Boolean
      {
         var _loc2_:Rectangle = param1.bounds();
         var _loc3_:Number = Math.max(0,_loc2_.left);
         var _loc4_:Number = Math.max(0,_loc2_.top);
         var _loc5_:Number = Math.max(0,ScratchObj.STAGEW - _loc2_.right);
         var _loc6_:Number = Math.max(0,ScratchObj.STAGEH - _loc2_.bottom);
         var _loc7_:int = 0;
         var _loc8_:Number = 100000;
         if(_loc3_ < _loc8_)
         {
            _loc8_ = _loc3_;
            _loc7_ = 1;
         }
         if(_loc4_ < _loc8_)
         {
            _loc8_ = _loc4_;
            _loc7_ = 2;
         }
         if(_loc5_ < _loc8_)
         {
            _loc8_ = _loc5_;
            _loc7_ = 3;
         }
         if(_loc6_ < _loc8_)
         {
            _loc8_ = _loc6_;
            _loc7_ = 4;
         }
         if(_loc8_ > 0)
         {
            return false;
         }
         var _loc9_:Number = (90 - param1.direction) * Math.PI / 180;
         var _loc10_:Number = Math.cos(_loc9_);
         var _loc11_:Number = -Math.sin(_loc9_);
         if(_loc7_ == 1)
         {
            _loc10_ = Math.max(0.2,Math.abs(_loc10_));
         }
         if(_loc7_ == 2)
         {
            _loc11_ = Math.max(0.2,Math.abs(_loc11_));
         }
         if(_loc7_ == 3)
         {
            _loc10_ = 0 - Math.max(0.2,Math.abs(_loc10_));
         }
         if(_loc7_ == 4)
         {
            _loc11_ = 0 - Math.max(0.2,Math.abs(_loc11_));
         }
         var _loc12_:Number = 180 * Math.atan2(_loc11_,_loc10_) / Math.PI + 90;
         param1.setDirection(_loc12_);
         return true;
      }
      
      private function ensureOnStageOnBounce(param1:ScratchSprite) : void
      {
         var _loc2_:Rectangle = param1.bounds();
         if(_loc2_.left < 0)
         {
            this.moveSpriteTo(param1,param1.scratchX - _loc2_.left,param1.scratchY);
         }
         if(_loc2_.top < 0)
         {
            this.moveSpriteTo(param1,param1.scratchX,param1.scratchY + _loc2_.top);
         }
         if(_loc2_.right > ScratchObj.STAGEW)
         {
            this.moveSpriteTo(param1,param1.scratchX - (_loc2_.right - ScratchObj.STAGEW),param1.scratchY);
         }
         if(_loc2_.bottom > ScratchObj.STAGEH)
         {
            this.moveSpriteTo(param1,param1.scratchX,param1.scratchY + (_loc2_.bottom - ScratchObj.STAGEH));
         }
      }
   }
}

