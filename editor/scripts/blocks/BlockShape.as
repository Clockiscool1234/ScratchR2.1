package blocks
{
   import flash.display.*;
   import flash.filters.*;
   
   public class BlockShape extends Shape
   {
      
      public static const RectShape:int = 1;
      
      public static const BooleanShape:int = 2;
      
      public static const NumberShape:int = 3;
      
      public static const CmdShape:int = 4;
      
      public static const FinalCmdShape:int = 5;
      
      public static const CmdOutlineShape:int = 6;
      
      public static const HatShape:int = 7;
      
      public static const ProcHatShape:int = 8;
      
      public static const LoopShape:int = 9;
      
      public static const FinalLoopShape:int = 10;
      
      public static const IfElseShape:int = 11;
      
      public static const NotchDepth:int = 3;
      
      public static const EmptySubstackH:int = 12;
      
      public static const SubstackInset:int = 15;
      
      private const CornerInset:int = 3;
      
      private const InnerCornerInset:int = 2;
      
      private const BottomBarH:int = 16;
      
      private const DividerH:int = 18;
      
      private const NotchL1:int = 13;
      
      private const NotchL2:int = 16;
      
      private const NotchR1:int = 24;
      
      private const NotchR2:int = 27;
      
      public var color:uint;
      
      public var hasLoopArrow:Boolean;
      
      private var shape:int;
      
      private var w:int;
      
      private var topH:int;
      
      private var substack1H:int = 12;
      
      private var substack2H:int = 12;
      
      private var drawFunction:Function;
      
      private var redrawNeeded:Boolean = true;
      
      public function BlockShape(param1:int = 1, param2:int = 16777215)
      {
         this.drawFunction = this.drawRectShape;
         super();
         this.color = param2;
         this.shape = param1;
         this.setShape(param1);
         filters = this.blockShapeFilters();
      }
      
      public function setWidthAndTopHeight(param1:int, param2:int, param3:Boolean = false) : void
      {
         if(param1 == this.w && param2 == this.topH)
         {
            return;
         }
         this.w = param1;
         this.topH = param2;
         this.redrawNeeded = true;
         if(param3)
         {
            this.redraw();
         }
      }
      
      public function setWidth(param1:int) : void
      {
         if(param1 == this.w)
         {
            return;
         }
         this.w = param1;
         this.redrawNeeded = true;
      }
      
      public function copyFeedbackShapeFrom(param1:*, param2:Boolean, param3:Boolean = false, param4:int = 0) : void
      {
         var _loc5_:BlockShape = param1.base;
         this.color = 37887;
         this.setShape(_loc5_.shape);
         this.w = _loc5_.w;
         this.topH = _loc5_.topH;
         this.substack1H = _loc5_.substack1H;
         this.substack2H = _loc5_.substack2H;
         if(!param2)
         {
            if(param3)
            {
               this.setShape(CmdShape);
               this.topH = 6;
            }
            else
            {
               if(!this.canHaveSubstack1() && !param1.isHat)
               {
                  this.topH = param1.height;
               }
               if(param4)
               {
                  this.substack1H = param4 - NotchDepth;
               }
            }
         }
         filters = this.dropFeedbackFilters(param2);
         this.redrawNeeded = true;
         this.redraw();
      }
      
      public function setColor(param1:int) : void
      {
         this.color = param1;
         this.redrawNeeded = true;
      }
      
      public function nextBlockY() : int
      {
         if(ProcHatShape == this.shape)
         {
            return this.topH;
         }
         return height - NotchDepth;
      }
      
      public function setSubstack1Height(param1:int) : void
      {
         param1 = Math.max(param1,EmptySubstackH);
         if(param1 != this.substack1H)
         {
            this.substack1H = param1;
            this.redrawNeeded = true;
         }
      }
      
      public function setSubstack2Height(param1:int) : void
      {
         param1 = Math.max(param1,EmptySubstackH);
         if(param1 != this.substack2H)
         {
            this.substack2H = param1;
            this.redrawNeeded = true;
         }
      }
      
      public function canHaveSubstack1() : Boolean
      {
         return this.shape >= LoopShape;
      }
      
      public function canHaveSubstack2() : Boolean
      {
         return this.shape == IfElseShape;
      }
      
      public function substack1y() : int
      {
         return this.topH;
      }
      
      public function substack2y() : int
      {
         return this.topH + this.substack1H + this.DividerH - NotchDepth;
      }
      
      public function redraw() : void
      {
         if(!this.redrawNeeded)
         {
            return;
         }
         var _loc1_:Graphics = this.graphics;
         _loc1_.clear();
         _loc1_.beginFill(this.color);
         this.drawFunction(_loc1_);
         _loc1_.endFill();
         this.redrawNeeded = false;
      }
      
      private function blockShapeFilters() : Array
      {
         var _loc1_:BevelFilter = new BevelFilter(1);
         _loc1_.blurX = _loc1_.blurY = 3;
         _loc1_.highlightAlpha = 0.3;
         _loc1_.shadowAlpha = 0.6;
         return [_loc1_];
      }
      
      private function dropFeedbackFilters(param1:Boolean) : Array
      {
         var _loc2_:GlowFilter = null;
         if(param1)
         {
            _loc2_ = new GlowFilter(16777215);
            _loc2_.strength = 5;
            _loc2_.blurX = _loc2_.blurY = 8;
            _loc2_.quality = 2;
         }
         else
         {
            _loc2_ = new GlowFilter(16777215);
            _loc2_.strength = 12;
            _loc2_.blurX = _loc2_.blurY = 6;
            _loc2_.inner = true;
         }
         _loc2_.knockout = true;
         return [_loc2_];
      }
      
      private function setShape(param1:int) : void
      {
         this.shape = param1;
         switch(param1)
         {
            case RectShape:
               this.drawFunction = this.drawRectShape;
               break;
            case BooleanShape:
               this.drawFunction = this.drawBooleanShape;
               break;
            case NumberShape:
               this.drawFunction = this.drawNumberShape;
               break;
            case CmdShape:
            case FinalCmdShape:
               this.drawFunction = this.drawCmdShape;
               break;
            case CmdOutlineShape:
               this.drawFunction = this.drawCmdOutlineShape;
               break;
            case LoopShape:
            case FinalLoopShape:
               this.drawFunction = this.drawLoopShape;
               break;
            case IfElseShape:
               this.drawFunction = this.drawIfElseShape;
               break;
            case HatShape:
               this.drawFunction = this.drawHatShape;
               break;
            case ProcHatShape:
               this.drawFunction = this.drawProcHatShape;
         }
      }
      
      private function drawRectShape(param1:Graphics) : void
      {
         param1.drawRect(0,0,this.w,this.topH);
      }
      
      private function drawBooleanShape(param1:Graphics) : void
      {
         var _loc2_:int = this.topH / 2;
         param1.moveTo(_loc2_,this.topH);
         param1.lineTo(0,_loc2_);
         param1.lineTo(_loc2_,0);
         param1.lineTo(this.w - _loc2_,0);
         param1.lineTo(this.w,_loc2_);
         param1.lineTo(this.w - _loc2_,this.topH);
      }
      
      private function drawNumberShape(param1:Graphics) : void
      {
         var _loc2_:int = this.topH / 2;
         param1.moveTo(_loc2_,this.topH);
         this.curve(_loc2_,this.topH,0,_loc2_);
         this.curve(0,_loc2_,_loc2_,0);
         param1.lineTo(this.w - _loc2_,0);
         this.curve(this.w - _loc2_,0,this.w,_loc2_);
         this.curve(this.w,_loc2_,this.w - _loc2_,this.topH);
      }
      
      private function drawCmdShape(param1:Graphics) : void
      {
         this.drawTop(param1);
         this.drawRightAndBottom(param1,this.topH,this.shape != FinalCmdShape);
      }
      
      private function drawCmdOutlineShape(param1:Graphics) : void
      {
         param1.endFill();
         param1.lineStyle(2,16777215,0.2);
         this.drawTop(param1);
         this.drawRightAndBottom(param1,this.topH,this.shape != FinalCmdShape);
         param1.lineTo(0,this.CornerInset);
      }
      
      private function drawTop(param1:Graphics) : void
      {
         param1.moveTo(0,this.CornerInset);
         param1.lineTo(this.CornerInset,0);
         param1.lineTo(this.NotchL1,0);
         param1.lineTo(this.NotchL2,NotchDepth);
         param1.lineTo(this.NotchR1,NotchDepth);
         param1.lineTo(this.NotchR2,0);
         param1.lineTo(this.w - this.CornerInset,0);
         param1.lineTo(this.w,this.CornerInset);
      }
      
      private function drawRightAndBottom(param1:Graphics, param2:int, param3:Boolean, param4:int = 0) : void
      {
         param1.lineTo(this.w,param2 - this.CornerInset);
         param1.lineTo(this.w - this.CornerInset,param2);
         if(param3)
         {
            param1.lineTo(param4 + this.NotchR2,param2);
            param1.lineTo(param4 + this.NotchR1,param2 + NotchDepth);
            param1.lineTo(param4 + this.NotchL2,param2 + NotchDepth);
            param1.lineTo(param4 + this.NotchL1,param2);
         }
         if(param4 > 0)
         {
            param1.lineTo(param4 + this.InnerCornerInset,param2);
            param1.lineTo(param4,param2 + this.InnerCornerInset);
         }
         else
         {
            param1.lineTo(param4 + this.CornerInset,param2);
            param1.lineTo(0,param2 - this.CornerInset);
         }
      }
      
      private function drawHatShape(param1:Graphics) : void
      {
         param1.moveTo(0,12);
         this.curve(0,12,40,0,0.15);
         this.curve(40,0,80,10,0.12);
         param1.lineTo(this.w - this.CornerInset,10);
         param1.lineTo(this.w,10 + this.CornerInset);
         this.drawRightAndBottom(param1,this.topH,true);
      }
      
      private function drawProcHatShape(param1:Graphics) : void
      {
         var _loc2_:int = 9318082;
         var _loc3_:Number = Math.min(0.2,35 / this.w);
         param1.beginFill(Specs.procedureColor);
         param1.moveTo(0,15);
         this.curve(0,15,this.w,15,_loc3_);
         this.drawRightAndBottom(param1,this.topH,true);
         param1.beginFill(_loc2_);
         param1.lineStyle(1,Specs.procedureColor);
         param1.moveTo(-1,13);
         this.curve(-1,13,this.w + 1,13,_loc3_);
         this.curve(this.w + 1,13,this.w,16,0.6);
         this.curve(this.w,16,0,16,-_loc3_);
         this.curve(0,16,-1,13,0.6);
      }
      
      private function drawLoopShape(param1:Graphics) : void
      {
         var _loc2_:int = this.topH + this.substack1H - NotchDepth;
         this.drawTop(param1);
         this.drawRightAndBottom(param1,this.topH,true,SubstackInset);
         this.drawArm(param1,_loc2_);
         this.drawRightAndBottom(param1,_loc2_ + this.BottomBarH,this.shape == LoopShape);
         if(this.hasLoopArrow)
         {
            this.drawLoopArrow(param1,_loc2_ + this.BottomBarH);
         }
      }
      
      private function drawLoopArrow(param1:Graphics, param2:int) : void
      {
         var _loc3_:Array = [[8,0],[2,-2],[0,-3],[3,0],[-4,-5],[-4,5],[3,0],[0,3],[-8,0],[0,2]];
         param1.beginFill(0,0.3);
         this.drawPath(param1,this.w - 15,param2 - 3,_loc3_);
         param1.beginFill(16777215,0.9);
         this.drawPath(param1,this.w - 16,param2 - 4,_loc3_);
         param1.endFill();
      }
      
      private function drawPath(param1:Graphics, param2:Number, param3:Number, param4:Array) : void
      {
         var _loc7_:Array = null;
         var _loc5_:Number = param2;
         var _loc6_:Number = param3;
         param1.moveTo(_loc5_,_loc6_);
         for each(_loc7_ in param4)
         {
            param1.lineTo(_loc5_ = _loc5_ + _loc7_[0],_loc6_ = _loc6_ + _loc7_[1]);
         }
      }
      
      private function drawIfElseShape(param1:Graphics) : void
      {
         var _loc2_:int = this.topH + this.substack1H - NotchDepth;
         var _loc3_:int = _loc2_ + this.DividerH + this.substack2H - NotchDepth;
         this.drawTop(param1);
         this.drawRightAndBottom(param1,this.topH,true,SubstackInset);
         this.drawArm(param1,_loc2_);
         this.drawRightAndBottom(param1,_loc2_ + this.DividerH,true,SubstackInset);
         this.drawArm(param1,_loc3_);
         this.drawRightAndBottom(param1,_loc3_ + this.BottomBarH,true);
      }
      
      private function drawArm(param1:Graphics, param2:int) : void
      {
         param1.lineTo(SubstackInset,param2 - this.InnerCornerInset);
         param1.lineTo(SubstackInset + this.InnerCornerInset,param2);
         param1.lineTo(this.w - this.CornerInset,param2);
         param1.lineTo(this.w,param2 + this.CornerInset);
      }
      
      private function curve(param1:int, param2:int, param3:int, param4:int, param5:Number = 0.42) : void
      {
         var _loc6_:Number = (param1 + param3) / 2;
         var _loc7_:Number = (param2 + param4) / 2;
         var _loc8_:Number = _loc6_ + param5 * (param4 - param2);
         var _loc9_:Number = _loc7_ - param5 * (param3 - param1);
         graphics.curveTo(_loc8_,_loc9_,param3,param4);
      }
   }
}

