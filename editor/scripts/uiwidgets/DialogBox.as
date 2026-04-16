package uiwidgets
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.DropShadowFilter;
   import flash.text.*;
   import flash.utils.Dictionary;
   import translation.Translator;
   import ui.parts.UIPart;
   
   public class DialogBox extends Sprite
   {
      
      private var fields:Dictionary = new Dictionary();
      
      private var booleanFields:Dictionary = new Dictionary();
      
      public var widget:DisplayObject;
      
      private var w:int;
      
      private var h:int;
      
      public var leftJustify:Boolean;
      
      private var context:Dictionary;
      
      private var title:TextField;
      
      private var xButton:IconButton;
      
      protected var buttons:Array = [];
      
      private var labelsAndFields:Array = [];
      
      private var booleanLabelsAndFields:Array = [];
      
      private var textLines:Array = [];
      
      private var maxLabelWidth:int = 0;
      
      private var maxFieldWidth:int = 0;
      
      private var heightPerField:int = Math.max(this.makeLabel("foo").height,this.makeField(10).height) + 10;
      
      private const spaceAfterText:int = 18;
      
      private const blankLineSpace:int = 7;
      
      private var acceptFunction:Function;
      
      private var cancelFunction:Function;
      
      public function DialogBox(param1:Function = null, param2:Function = null)
      {
         super();
         this.acceptFunction = param1;
         this.cancelFunction = param2;
         this.addFilters();
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUp);
         addEventListener(KeyboardEvent.KEY_DOWN,this.keyDown);
         addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.focusChange);
      }
      
      public static function ask(param1:String, param2:String, param3:Stage = null, param4:Function = null, param5:Dictionary = null) : void
      {
         var done:Function = null;
         var d:DialogBox = null;
         var question:String = param1;
         var defaultAnswer:String = param2;
         var stage:Stage = param3;
         var resultFunction:Function = param4;
         var context:Dictionary = param5;
         done = function():void
         {
            if(resultFunction != null)
            {
               resultFunction(d.fields["answer"].text);
            }
         };
         d = new DialogBox(done);
         d.addTitle(question);
         d.addField("answer",120,defaultAnswer,false);
         d.addButton("OK",d.accept);
         if(context)
         {
            d.updateContext(context);
         }
         d.showOnStage(stage ? stage : Scratch.app.stage);
      }
      
      public static function confirm(param1:String, param2:Stage = null, param3:Function = null, param4:Function = null, param5:Dictionary = null) : void
      {
         var _loc6_:DialogBox = new DialogBox(param3,param4);
         _loc6_.addTitle(param1);
         _loc6_.addAcceptCancelButtons("OK");
         if(param5)
         {
            _loc6_.updateContext(param5);
         }
         _loc6_.showOnStage(param2 ? param2 : Scratch.app.stage);
      }
      
      public static function notify(param1:String, param2:String, param3:Stage = null, param4:Boolean = false, param5:Function = null, param6:Function = null, param7:Dictionary = null) : void
      {
         var _loc8_:DialogBox = new DialogBox(param5,param6);
         _loc8_.leftJustify = param4;
         _loc8_.addTitle(param1);
         _loc8_.addText(param2);
         _loc8_.addButton("OK",_loc8_.accept);
         if(param7)
         {
            _loc8_.updateContext(param7);
         }
         _loc8_.showOnStage(param3 ? param3 : Scratch.app.stage);
      }
      
      public static function close(param1:String, param2:String = null, param3:DisplayObject = null, param4:String = "OK", param5:Stage = null, param6:Function = null, param7:Function = null, param8:Dictionary = null, param9:Boolean = false) : void
      {
         var _loc10_:DialogBox = new DialogBox(param6,param7);
         _loc10_.leftJustify = false;
         _loc10_.addTitle(param1);
         if(param3)
         {
            _loc10_.addWidget(param3);
         }
         if(param2)
         {
            _loc10_.addText(param2);
         }
         if(param9)
         {
            _loc10_.addInvertedButton(param4,_loc10_.accept);
         }
         else
         {
            _loc10_.addButton(param4,_loc10_.accept);
         }
         _loc10_.xButton = new IconButton(_loc10_.cancel,"close");
         _loc10_.addChild(_loc10_.xButton);
         if(param8)
         {
            _loc10_.updateContext(param8);
         }
         _loc10_.showOnStage(param5 ? param5 : Scratch.app.stage);
      }
      
      public static function findDialogBoxes(param1:String, param2:Stage) : Array
      {
         var _loc5_:DialogBox = null;
         var _loc3_:Array = [];
         if(param1)
         {
            param1 = Translator.map(param1);
         }
         var _loc4_:int = 0;
         while(_loc4_ < param2.numChildren)
         {
            _loc5_ = param2.getChildAt(_loc4_) as DialogBox;
            if(_loc5_)
            {
               if(param1)
               {
                  if(Boolean(_loc5_.title) && _loc5_.title.text == param1)
                  {
                     _loc3_.push(_loc5_);
                  }
               }
               else
               {
                  _loc3_.push(_loc5_);
               }
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public function updateContext(param1:Dictionary) : void
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:VariableTextField = null;
         if(!this.context)
         {
            this.context = new Dictionary();
         }
         for(_loc2_ in param1)
         {
            this.context[_loc2_] = param1[_loc2_];
         }
         _loc3_ = 0;
         while(_loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_) as VariableTextField;
            if(_loc4_)
            {
               _loc4_.applyContext(this.context);
            }
            _loc3_++;
         }
      }
      
      public function addTitle(param1:String) : void
      {
         this.title = this.makeLabel(Translator.map(param1),true);
         addChild(this.title);
      }
      
      public function addText(param1:String) : void
      {
         var _loc2_:String = null;
         var _loc3_:TextField = null;
         for each(_loc2_ in param1.split("\n"))
         {
            _loc3_ = this.makeLabel(Translator.map(_loc2_));
            addChild(_loc3_);
            this.textLines.push(_loc3_);
         }
      }
      
      public function addTextWithCustomFunction(param1:String, param2:Function) : void
      {
         var _loc3_:String = null;
         var _loc4_:TextField = null;
         for each(_loc3_ in param1.split("\n"))
         {
            _loc4_ = param2(Translator.map(_loc3_));
            addChild(_loc4_);
            this.textLines.push(_loc4_);
         }
      }
      
      public function addWidget(param1:DisplayObject) : void
      {
         this.widget = param1;
         addChild(param1);
      }
      
      public function addField(param1:String, param2:int, param3:* = null, param4:Boolean = true) : void
      {
         var _loc5_:TextField = null;
         if(param4)
         {
            _loc5_ = this.makeLabel(Translator.map(param1) + ":");
            addChild(_loc5_);
         }
         var _loc6_:TextField = this.makeField(param2);
         if(param3 != null)
         {
            _loc6_.text = param3;
         }
         addChild(_loc6_);
         this.fields[param1] = _loc6_;
         this.labelsAndFields.push([_loc5_,_loc6_]);
      }
      
      public function addBoolean(param1:String, param2:Boolean = false, param3:Boolean = false) : void
      {
         var _loc4_:TextField = this.makeLabel(Translator.map(param1) + ":");
         addChild(_loc4_);
         var _loc5_:IconButton = param3 ? new IconButton(null,null,null,true) : new IconButton(null,this.getCheckMark(true),this.getCheckMark(false));
         if(param2)
         {
            _loc5_.turnOn();
         }
         else
         {
            _loc5_.turnOff();
         }
         addChild(_loc5_);
         this.booleanFields[param1] = _loc5_;
         this.booleanLabelsAndFields.push([_loc4_,_loc5_]);
      }
      
      private function getCheckMark(param1:Boolean) : Sprite
      {
         var _loc2_:Sprite = new Sprite();
         var _loc3_:Graphics = _loc2_.graphics;
         _loc3_.clear();
         _loc3_.beginFill(16777215);
         _loc3_.lineStyle(1,9606295,1,true);
         _loc3_.drawRoundRect(0,0,17,17,3,3);
         _loc3_.endFill();
         if(param1)
         {
            _loc3_.lineStyle(2,5000527,1,true);
            _loc3_.moveTo(3,7);
            _loc3_.lineTo(5,7);
            _loc3_.lineTo(8,13);
            _loc3_.lineTo(14,3);
         }
         return _loc2_;
      }
      
      public function addAcceptCancelButtons(param1:String = null, param2:String = "Cancel") : void
      {
         if(param1 != null)
         {
            this.addButton(param1,this.accept);
         }
         this.addButton(param2,this.cancel);
      }
      
      public function addButton(param1:String, param2:Function) : void
      {
         var doAction:Function = null;
         var label:String = param1;
         var action:Function = param2;
         doAction = function():void
         {
            remove();
            if(action != null)
            {
               action();
            }
         };
         var b:Button = new Button(Translator.map(label),doAction);
         addChild(b);
         this.buttons.push(b);
      }
      
      public function addInvertedButton(param1:String, param2:Function) : void
      {
         var doAction:Function = null;
         var label:String = param1;
         var action:Function = param2;
         doAction = function():void
         {
            remove();
            if(action != null)
            {
               action();
            }
         };
         var b:ButtonInverted = new ButtonInverted(Translator.map(label),doAction);
         addChild(b);
         this.buttons.push(b);
      }
      
      public function showOnStage(param1:Stage, param2:Boolean = true, param3:Number = 0) : void
      {
         this.fixLayout(param3);
         if(param2)
         {
            x = (param1.stageWidth - width) / 2;
            y = (param1.stageHeight - height) / 2;
         }
         else
         {
            x = param1.mouseX + 10;
            y = param1.mouseY + 10;
         }
         x = Math.max(0,Math.min(x,param1.stageWidth - width));
         y = Math.max(0,Math.min(y,param1.stageHeight - height));
         param1.addChild(this);
         if(this.labelsAndFields.length > 0)
         {
            param1.focus = this.labelsAndFields[0][1];
         }
      }
      
      public function accept() : void
      {
         if(this.acceptFunction != null)
         {
            this.acceptFunction(this);
         }
         this.remove();
      }
      
      public function cancel(param1:* = null) : void
      {
         if(this.cancelFunction != null)
         {
            this.cancelFunction(this);
         }
         this.remove();
      }
      
      public function getField(param1:String) : *
      {
         if(this.fields[param1] != null)
         {
            return this.fields[param1].text;
         }
         if(this.booleanFields[param1] != null)
         {
            return this.booleanFields[param1].isOn();
         }
         return null;
      }
      
      public function setPasswordField(param1:String, param2:Boolean = true) : void
      {
         var _loc3_:* = this.fields[param1];
         if(_loc3_ is TextField)
         {
            (_loc3_ as TextField).displayAsPassword = param2;
         }
      }
      
      private function remove() : void
      {
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      private function makeLabel(param1:String, param2:Boolean = false) : TextField
      {
         var _loc3_:TextFormat = new TextFormat(CSS.font,14,CSS.textColor);
         var _loc4_:VariableTextField = new VariableTextField();
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.selectable = false;
         _loc4_.background = false;
         _loc4_.setText(param1,this.context);
         _loc4_.setTextFormat(param2 ? CSS.titleFormat : _loc3_);
         return _loc4_;
      }
      
      private function makeField(param1:int) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.selectable = true;
         _loc2_.type = TextFieldType.INPUT;
         _loc2_.background = true;
         _loc2_.border = true;
         _loc2_.defaultTextFormat = CSS.normalTextFormat;
         _loc2_.width = param1;
         _loc2_.height = _loc2_.defaultTextFormat.size + 8;
         _loc2_.backgroundColor = 16777215;
         _loc2_.borderColor = CSS.borderColor;
         return _loc2_;
      }
      
      public function fixLayout(param1:Number = 0) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc7_:TextField = null;
         var _loc8_:TextField = null;
         var _loc9_:IconButton = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         this.fixSize(param1);
         var _loc5_:int = this.maxLabelWidth + 17;
         var _loc6_:int = 15;
         if(this.title != null)
         {
            this.title.x = (this.w - this.title.width) / 2;
            this.title.y = 5;
            _loc6_ = this.title.y + this.title.height + 20;
            _loc6_ += param1;
         }
         if(this.xButton != null)
         {
            this.xButton.x = this.width - 20;
            this.xButton.y = 10;
         }
         _loc3_ = 0;
         while(_loc3_ < this.labelsAndFields.length)
         {
            _loc2_ = this.labelsAndFields[_loc3_][0];
            _loc8_ = this.labelsAndFields[_loc3_][1];
            if(_loc2_ != null)
            {
               _loc2_.x = _loc5_ - 5 - _loc2_.width;
               _loc2_.y = _loc6_;
            }
            _loc8_.x = _loc5_;
            _loc8_.y = _loc6_ + 1;
            _loc6_ += this.heightPerField;
            _loc3_++;
         }
         if(this.widget != null)
         {
            this.widget.x = (width - this.widget.width) / 2;
            this.widget.y = _loc6_;
            _loc6_ = this.widget.y + this.widget.height + 15;
         }
         _loc3_ = 0;
         while(_loc3_ < this.booleanLabelsAndFields.length)
         {
            _loc2_ = this.booleanLabelsAndFields[_loc3_][0];
            _loc9_ = this.booleanLabelsAndFields[_loc3_][1];
            if(_loc2_ != null)
            {
               _loc2_.x = _loc5_ - 5 - _loc2_.width;
               _loc2_.y = _loc6_ + 5;
            }
            _loc9_.x = _loc5_ - 2;
            _loc9_.y = _loc6_ + 5;
            _loc6_ += this.heightPerField;
            _loc3_++;
         }
         for each(_loc7_ in this.textLines)
         {
            _loc7_.x = this.leftJustify ? 15 : (this.w - _loc7_.width) / 2;
            _loc7_.y = _loc6_;
            _loc6_ += _loc7_.height;
            if(_loc7_.text.length == 0)
            {
               _loc6_ += this.blankLineSpace;
            }
         }
         if(this.textLines.length > 0)
         {
            _loc6_ += this.spaceAfterText;
         }
         if(this.buttons.length > 0)
         {
            _loc4_ = (this.buttons.length - 1) * 10;
            _loc3_ = 0;
            while(_loc3_ < this.buttons.length)
            {
               _loc4_ += this.buttons[_loc3_].width;
               _loc3_++;
            }
            _loc10_ = (this.w - _loc4_) / 2;
            _loc11_ = this.h - (this.buttons[0].height + 15);
            _loc3_ = 0;
            while(_loc3_ < this.buttons.length)
            {
               this.buttons[_loc3_].x = _loc10_;
               this.buttons[_loc3_].y = _loc11_;
               _loc10_ += this.buttons[_loc3_].width + 10;
               _loc3_++;
            }
         }
      }
      
      private function fixSize(param1:Number = 0) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:TextField = null;
         var _loc5_:Array = null;
         this.w = this.h = 0;
         if(this.title != null)
         {
            this.w = Math.max(this.w,this.title.width);
            this.h += 10 + this.title.height;
            this.h += param1;
         }
         this.maxLabelWidth = 0;
         this.maxFieldWidth = 0;
         _loc2_ = 0;
         while(_loc2_ < this.labelsAndFields.length)
         {
            _loc5_ = this.labelsAndFields[_loc2_];
            if(_loc5_[0] != null)
            {
               this.maxLabelWidth = Math.max(this.maxLabelWidth,_loc5_[0].width);
            }
            this.maxFieldWidth = Math.max(this.maxFieldWidth,_loc5_[1].width);
            this.h += this.heightPerField;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.booleanLabelsAndFields.length)
         {
            _loc5_ = this.booleanLabelsAndFields[_loc2_];
            if(_loc5_[0] != null)
            {
               this.maxLabelWidth = Math.max(this.maxLabelWidth,_loc5_[0].width);
            }
            this.maxFieldWidth = Math.max(this.maxFieldWidth,_loc5_[1].width);
            this.h += this.heightPerField;
            _loc2_++;
         }
         this.w = Math.max(this.w,this.maxLabelWidth + this.maxFieldWidth + 5);
         if(this.widget != null)
         {
            this.w = Math.max(this.w,this.widget.width);
            this.h += 10 + this.widget.height;
         }
         for each(_loc4_ in this.textLines)
         {
            this.w = Math.max(this.w,_loc4_.width);
            this.h += _loc4_.height;
            if(_loc4_.length == 0)
            {
               this.h += this.blankLineSpace;
            }
         }
         if(this.textLines.length > 0)
         {
            this.h += this.spaceAfterText;
         }
         _loc3_ = 0;
         _loc2_ = 0;
         while(_loc2_ < this.buttons.length)
         {
            _loc3_ += this.buttons[_loc2_].width + 10;
            _loc2_++;
         }
         this.w = Math.max(this.w,_loc3_);
         if(this.buttons.length > 0)
         {
            this.h += this.buttons[0].height + 15;
         }
         if(this.labelsAndFields.length > 0 || this.booleanLabelsAndFields.length > 0)
         {
            this.h += 15;
         }
         this.w += 30;
         this.h += 10;
         this.drawBackground();
      }
      
      private function drawBackground() : void
      {
         var _loc1_:Array = [14737632,13684944];
         var _loc2_:int = 11579568;
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         UIPart.drawTopBar(_loc3_,_loc1_,UIPart.getTopBarPath(this.w,this.h),this.w,CSS.titleBarH,_loc2_);
         _loc3_.lineStyle(0.5,_loc2_,1,true);
         _loc3_.beginFill(16777215);
         _loc3_.drawRect(0,CSS.titleBarH,this.w - 1,this.h - CSS.titleBarH - 1);
      }
      
      private function addFilters() : void
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         _loc1_.blurX = _loc1_.blurY = 8;
         _loc1_.distance = 5;
         _loc1_.alpha = 0.75;
         _loc1_.color = 3355443;
         filters = [_loc1_];
      }
      
      private function focusChange(param1:Event) : void
      {
         param1.preventDefault();
         if(this.labelsAndFields.length == 0)
         {
            return;
         }
         var _loc2_:int = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.labelsAndFields.length)
         {
            if(stage.focus == this.labelsAndFields[_loc3_][1])
            {
               _loc2_ = _loc3_;
            }
            _loc3_++;
         }
         if(++_loc2_ >= this.labelsAndFields.length)
         {
            _loc2_ = 0;
         }
         stage.focus = this.labelsAndFields[_loc2_][1];
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         if(param1.target == this || param1.target == this.title)
         {
            startDrag();
         }
      }
      
      private function mouseUp(param1:MouseEvent) : void
      {
         stopDrag();
      }
      
      private function keyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == 10 || param1.keyCode == 13)
         {
            this.accept();
         }
         if(param1.keyCode == 27)
         {
            this.cancel();
         }
      }
   }
}

