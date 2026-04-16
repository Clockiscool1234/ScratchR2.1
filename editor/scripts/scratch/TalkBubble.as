package scratch
{
   import flash.display.*;
   import flash.text.*;
   
   public class TalkBubble extends Sprite
   {
      
      private static var textFormat:TextFormat = new TextFormat(CSS.font,14,0,true,null,null,null,null,TextFormatAlign.CENTER);
      
      private static var resultFormat:TextFormat = new TextFormat(CSS.font,12,CSS.textColor,null,null,null,null,null,TextFormatAlign.CENTER);
      
      public var pointsLeft:Boolean;
      
      public var style:String;
      
      private var type:String;
      
      private var shape:Shape;
      
      private var text:TextField;
      
      private var source:Object;
      
      private var outlineColor:int = 10526880;
      
      private var radius:int = 8;
      
      private var padding:int = 5;
      
      private var minWidth:int = 55;
      
      private var lastXY:Array;
      
      private var pInset1:int = 16;
      
      private var pInset2:int = 50;
      
      private var pDrop:int = 17;
      
      private var pDropX:int = 8;
      
      private var lineWidth:Number = 3;
      
      public function TalkBubble(param1:String, param2:String, param3:String, param4:Object)
      {
         super();
         this.type = param2;
         this.style = param3;
         this.source = param4;
         if(param3 == "ask")
         {
            this.outlineColor = 4894174;
         }
         else if(param3 == "result")
         {
            this.outlineColor = 8947848;
            this.minWidth = 16;
            this.padding = 3;
            this.radius = 5;
            this.pInset1 = 8;
            this.pInset2 = 16;
            this.pDrop = 5;
            this.pDropX = 4;
            this.lineWidth = 0.5;
         }
         this.pointsLeft = true;
         this.shape = new Shape();
         addChild(this.shape);
         this.text = this.makeText();
         addChild(this.text);
         this.setText(param1);
      }
      
      public function setDirection(param1:String) : void
      {
         var _loc2_:Boolean = param1 == "left";
         if(this.pointsLeft == _loc2_)
         {
            return;
         }
         this.pointsLeft = _loc2_;
         this.setWidthHeight(this.text.width + this.padding * 2,this.text.height + this.padding * 2);
      }
      
      public function getText() : String
      {
         return this.text.text;
      }
      
      public function getSource() : Object
      {
         return this.source;
      }
      
      private function setText(param1:String) : void
      {
         var _loc2_:int = 135;
         this.text.width = _loc2_ + 100;
         this.text.text = param1;
         this.text.width = Math.max(this.minWidth,Math.min(this.text.textWidth + 8,_loc2_));
         this.setWidthHeight(this.text.width + this.padding * 2,this.text.height + this.padding * 2);
      }
      
      private function setWidthHeight(param1:int, param2:int) : void
      {
         var _loc3_:Graphics = this.shape.graphics;
         _loc3_.clear();
         _loc3_.beginFill(16777215);
         _loc3_.lineStyle(this.lineWidth,this.outlineColor,1,true);
         if(this.type == "think")
         {
            this.drawThink(param1,param2);
         }
         else
         {
            this.drawTalk(param1,param2);
         }
      }
      
      private function makeText() : TextField
      {
         var _loc1_:TextField = new TextField();
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.defaultTextFormat = this.style == "result" ? resultFormat : textFormat;
         _loc1_.selectable = false;
         _loc1_.type = "dynamic";
         _loc1_.wordWrap = true;
         _loc1_.x = this.padding;
         _loc1_.y = this.padding;
         return _loc1_;
      }
      
      private function drawTalk(param1:int, param2:int) : void
      {
         var _loc3_:int = param1 - this.radius;
         var _loc4_:int = param2 - this.radius;
         this.startAt(this.radius,0);
         this.line(_loc3_,0);
         this.arc(param1,this.radius);
         this.line(param1,_loc4_);
         this.arc(_loc3_,param2);
         if(this.pointsLeft)
         {
            this.line(this.pInset2,param2);
            this.line(this.pDropX,param2 + this.pDrop);
            this.line(this.pInset1,param2);
         }
         else
         {
            this.line(param1 - this.pInset1,param2);
            this.line(param1 - this.pDropX,param2 + this.pDrop);
            this.line(param1 - this.pInset2,param2);
         }
         this.line(this.radius,param2);
         this.arc(0,_loc4_);
         this.line(0,this.radius);
         this.arc(this.radius,0);
      }
      
      private function drawThink(param1:int, param2:int) : void
      {
         var _loc3_:int = param1 - this.radius;
         var _loc4_:int = param2 - this.radius;
         this.startAt(this.radius,0);
         this.line(_loc3_,0);
         this.arc(param1,this.radius);
         this.line(param1,_loc4_);
         this.arc(_loc3_,param2);
         this.line(this.radius,param2);
         this.arc(0,_loc4_);
         this.line(0,this.radius);
         this.arc(this.radius,0);
         if(this.pointsLeft)
         {
            this.ellipse(16,param2 + 2,12,7,2);
            this.ellipse(12,param2 + 10,8,5,2);
            this.ellipse(6,param2 + 15,6,4,1);
         }
         else
         {
            this.ellipse(param1 - 29,param2 + 2,12,7,2);
            this.ellipse(param1 - 20,param2 + 10,8,5,2);
            this.ellipse(param1 - 12,param2 + 15,6,4,1);
         }
      }
      
      private function startAt(param1:int, param2:int) : void
      {
         this.shape.graphics.moveTo(param1,param2);
         this.lastXY = [param1,param2];
      }
      
      private function line(param1:int, param2:int) : void
      {
         this.shape.graphics.lineTo(param1,param2);
         this.lastXY = [param1,param2];
      }
      
      private function ellipse(param1:int, param2:int, param3:int, param4:int, param5:int) : void
      {
         this.shape.graphics.lineStyle(param5,this.outlineColor);
         this.shape.graphics.drawEllipse(param1,param2,param3,param4);
      }
      
      private function arc(param1:int, param2:int) : void
      {
         var _loc3_:Number = 0.42;
         var _loc4_:Number = (this.lastXY[0] + param1) / 2;
         var _loc5_:Number = (this.lastXY[1] + param2) / 2;
         var _loc6_:Number = _loc4_ + _loc3_ * (param2 - this.lastXY[1]);
         var _loc7_:Number = _loc5_ - _loc3_ * (param1 - this.lastXY[0]);
         this.shape.graphics.curveTo(_loc6_,_loc7_,param1,param2);
         this.lastXY = [param1,param2];
      }
   }
}

