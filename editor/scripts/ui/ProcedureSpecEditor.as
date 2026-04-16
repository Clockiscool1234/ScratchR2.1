package ui
{
   import assets.Resources;
   import blocks.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.text.*;
   import translation.Translator;
   import uiwidgets.*;
   import util.*;
   
   public class ProcedureSpecEditor extends Sprite
   {
      
      private var base:Shape;
      
      private var blockShape:BlockShape;
      
      private var row:Array = [];
      
      private var moreLabel:TextField;
      
      private var moreButton:IconButton;
      
      private var buttonLabels:Array = [];
      
      private var buttons:Array = [];
      
      private var warpCheckbox:IconButton;
      
      private var warpLabel:TextField;
      
      private var deleteButton:IconButton;
      
      private var focusItem:DisplayObject;
      
      private const labelColor:int = 8861887;
      
      private const selectedLabelColor:int = 15705855;
      
      public function ProcedureSpecEditor(param1:String, param2:Array, param3:Boolean)
      {
         super();
         addChild(this.base = new Shape());
         this.setWidthHeight(350,10);
         this.blockShape = new BlockShape(BlockShape.CmdShape,Specs.procedureColor);
         this.blockShape.setWidthAndTopHeight(100,25,true);
         addChild(this.blockShape);
         addChild(this.moreLabel = this.makeLabel("Options",12));
         this.moreLabel.addEventListener(MouseEvent.MOUSE_DOWN,this.toggleButtons);
         addChild(this.moreButton = new IconButton(this.toggleButtons,"reveal"));
         this.moreButton.disableMouseover();
         this.addButtonsAndLabels();
         this.addwarpCheckbox();
         addChild(this.deleteButton = new IconButton(this.deleteItem,Resources.createBmp("removeItem")));
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         addEventListener(Event.CHANGE,this.textChange);
         addEventListener(FocusEvent.FOCUS_OUT,this.focusChange);
         addEventListener(FocusEvent.FOCUS_IN,this.focusChange);
         this.addSpecElements(param1,param2);
         this.warpCheckbox.setOn(param3);
         this.showButtons(false);
      }
      
      public static function strings() : Array
      {
         return ["Options","Run without screen refresh","Add number input:","Add string input:","Add boolean input:","Add label text:","text"];
      }
      
      private function setWidthHeight(param1:int, param2:int) : void
      {
         var _loc3_:Graphics = this.base.graphics;
         _loc3_.clear();
         _loc3_.beginFill(CSS.white);
         _loc3_.drawRect(0,0,param1,param2);
         _loc3_.endFill();
      }
      
      private function clearRow() : void
      {
         var _loc1_:DisplayObject = null;
         for each(_loc1_ in this.row)
         {
            if(_loc1_.parent)
            {
               _loc1_.parent.removeChild(_loc1_);
            }
         }
         this.row = [];
      }
      
      private function addSpecElements(param1:String, param2:Array) : void
      {
         var i:int;
         var s:String = null;
         var argSpec:String = null;
         var arg:BlockArg = null;
         var tf:TextField = null;
         var spec:String = param1;
         var inputNames:Array = param2;
         var addElement:Function = function(param1:DisplayObject):void
         {
            row.push(param1);
            addChild(param1);
         };
         this.clearRow();
         i = 0;
         for each(s in ReadStream.tokenize(spec))
         {
            if(s.length >= 2 && s.charAt(0) == "%")
            {
               argSpec = s.charAt(1);
               arg = null;
               if(argSpec == "b")
               {
                  arg = this.makeBooleanArg();
               }
               if(argSpec == "n")
               {
                  arg = this.makeNumberArg();
               }
               if(argSpec == "s")
               {
                  arg = this.makeStringArg();
               }
               if(arg)
               {
                  arg.setArgValue(inputNames[i++]);
                  addElement(arg);
               }
            }
            else if(this.row.length > 0 && this.row[this.row.length - 1] is TextField)
            {
               tf = this.row[this.row.length - 1];
               tf.appendText(" " + ReadStream.unescape(s));
               this.fixLabelWidth(tf);
            }
            else
            {
               addElement(this.makeTextField(ReadStream.unescape(s)));
            }
         }
         if(this.row.length == 0 || this.row[this.row.length - 1] is BlockArg)
         {
            addElement(this.makeTextField(""));
         }
         this.fixLayout();
      }
      
      public function spec() : String
      {
         var _loc2_:* = undefined;
         var _loc1_:String = "";
         for each(_loc2_ in this.row)
         {
            if(_loc2_ is TextField)
            {
               _loc1_ += ReadStream.escape(TextField(_loc2_).text);
            }
            if(_loc2_ is BlockArg)
            {
               _loc1_ += "%" + BlockArg(_loc2_).type;
            }
            if(_loc1_.length > 0 && _loc1_.charAt(_loc1_.length - 1) != " ")
            {
               _loc1_ += " ";
            }
         }
         if(_loc1_.length > 0 && _loc1_.charAt(_loc1_.length - 1) == " ")
         {
            _loc1_ = _loc1_.slice(0,_loc1_.length - 1);
         }
         return _loc1_;
      }
      
      public function defaultArgValues() : Array
      {
         var _loc2_:* = undefined;
         var _loc3_:BlockArg = null;
         var _loc4_:* = undefined;
         var _loc1_:Array = [];
         for each(_loc2_ in this.row)
         {
            if(_loc2_ is BlockArg)
            {
               _loc3_ = BlockArg(_loc2_);
               _loc4_ = 0;
               if(_loc3_.type == "b")
               {
                  _loc4_ = false;
               }
               if(_loc3_.type == "n")
               {
                  _loc4_ = 1;
               }
               if(_loc3_.type == "s")
               {
                  _loc4_ = "";
               }
               _loc1_.push(_loc4_);
            }
         }
         return _loc1_;
      }
      
      public function warpFlag() : Boolean
      {
         return this.warpCheckbox.isOn();
      }
      
      public function inputNames() : Array
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = [];
         for each(_loc2_ in this.row)
         {
            if(_loc2_ is BlockArg)
            {
               _loc1_.push(this.uniqueName(_loc1_,BlockArg(_loc2_).field.text));
            }
         }
         return _loc1_;
      }
      
      private function addButtonsAndLabels() : void
      {
         var lightGray:int;
         var icon:BlockShape = null;
         var label:TextField = null;
         var b:Button = null;
         this.buttonLabels = [this.makeLabel("Add number input:",14),this.makeLabel("Add string input:",14),this.makeLabel("Add boolean input:",14),this.makeLabel("Add label text:",14)];
         this.buttons = [new Button("",function():void
         {
            appendObj(makeNumberArg());
         }),new Button("",function():void
         {
            appendObj(makeStringArg());
         }),new Button("",function():void
         {
            appendObj(makeBooleanArg());
         }),new Button(Translator.map("text"),function():void
         {
            appendObj(makeTextField(""));
         })];
         lightGray = 10526880;
         icon = new BlockShape(BlockShape.NumberShape,lightGray);
         icon.setWidthAndTopHeight(25,14,true);
         this.buttons[0].setIcon(icon);
         icon = new BlockShape(BlockShape.RectShape,lightGray);
         icon.setWidthAndTopHeight(22,14,true);
         this.buttons[1].setIcon(icon);
         icon = new BlockShape(BlockShape.BooleanShape,lightGray);
         icon.setWidthAndTopHeight(25,14,true);
         this.buttons[2].setIcon(icon);
         for each(label in this.buttonLabels)
         {
            addChild(label);
         }
         for each(b in this.buttons)
         {
            addChild(b);
         }
      }
      
      private function addwarpCheckbox() : void
      {
         addChild(this.warpCheckbox = new IconButton(null,"checkbox"));
         this.warpCheckbox.disableMouseover();
         addChild(this.warpLabel = this.makeLabel("Run without screen refresh",14));
      }
      
      private function makeLabel(param1:String, param2:int) : TextField
      {
         var _loc3_:TextField = new TextField();
         _loc3_.selectable = false;
         _loc3_.defaultTextFormat = new TextFormat(CSS.font,param2,CSS.textColor);
         _loc3_.autoSize = TextFieldAutoSize.LEFT;
         _loc3_.text = Translator.map(param1);
         addChild(_loc3_);
         return _loc3_;
      }
      
      private function toggleButtons(param1:*) : void
      {
         var _loc2_:Boolean = this.buttons[0].parent != null;
         this.showButtons(!_loc2_);
      }
      
      private function deleteItem(param1:*) : void
      {
         var _loc2_:int = 0;
         if(this.focusItem)
         {
            _loc2_ = this.row.indexOf(this.focusItem) - 1;
            removeChild(this.focusItem);
            if(_loc2_ > -1)
            {
               this.setFocus(this.row[_loc2_]);
            }
            this.fixLayout();
         }
         if(this.row.length == 0)
         {
            this.appendObj(this.makeTextField(""));
            TextField(this.row[0]).width = 27;
         }
      }
      
      private function showButtons(param1:Boolean) : void
      {
         var _loc2_:TextField = null;
         var _loc3_:Button = null;
         if(param1)
         {
            for each(_loc2_ in this.buttonLabels)
            {
               addChild(_loc2_);
            }
            for each(_loc3_ in this.buttons)
            {
               addChild(_loc3_);
            }
            addChild(this.warpCheckbox);
            addChild(this.warpLabel);
         }
         else
         {
            for each(_loc2_ in this.buttonLabels)
            {
               if(_loc2_.parent)
               {
                  removeChild(_loc2_);
               }
            }
            for each(_loc3_ in this.buttons)
            {
               if(_loc3_.parent)
               {
                  removeChild(_loc3_);
               }
            }
            if(this.warpCheckbox.parent)
            {
               removeChild(this.warpCheckbox);
            }
            if(this.warpLabel.parent)
            {
               removeChild(this.warpLabel);
            }
         }
         this.moreButton.setOn(param1);
         this.setWidthHeight(this.base.width,param1 ? 215 : 55);
         this.deleteButton.visible = param1 && this.row.length > 1;
         if(parent is DialogBox)
         {
            DialogBox(parent).fixLayout();
         }
      }
      
      private function makeBooleanArg() : BlockArg
      {
         var _loc1_:BlockArg = new BlockArg("b",16777215,true);
         _loc1_.setArgValue(this.unusedArgName("boolean"));
         return _loc1_;
      }
      
      private function makeNumberArg() : BlockArg
      {
         var _loc1_:BlockArg = new BlockArg("n",16777215,true);
         _loc1_.field.restrict = null;
         _loc1_.setArgValue(this.unusedArgName("number"));
         return _loc1_;
      }
      
      private function makeStringArg() : BlockArg
      {
         var _loc1_:BlockArg = new BlockArg("s",16777215,true);
         _loc1_.setArgValue(this.unusedArgName("string"));
         return _loc1_;
      }
      
      private function unusedArgName(param1:String) : String
      {
         var _loc3_:* = undefined;
         var _loc4_:int = 0;
         var _loc2_:Array = [];
         for each(_loc3_ in this.row)
         {
            if(_loc3_ is BlockArg)
            {
               _loc2_.push(_loc3_.field.text);
            }
         }
         _loc4_ = 1;
         while(_loc2_.indexOf(param1 + _loc4_) > -1)
         {
            _loc4_++;
         }
         return param1 + _loc4_;
      }
      
      private function appendObj(param1:DisplayObject) : void
      {
         this.row.push(param1);
         addChild(param1);
         if(stage)
         {
            if(param1 is TextField)
            {
               stage.focus = TextField(param1);
            }
            if(param1 is BlockArg)
            {
               BlockArg(param1).startEditing();
            }
         }
         this.fixLayout();
      }
      
      private function makeTextField(param1:String) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.borderColor = 0;
         _loc2_.backgroundColor = this.labelColor;
         _loc2_.background = true;
         _loc2_.type = TextFieldType.INPUT;
         _loc2_.defaultTextFormat = Block.blockLabelFormat;
         if(param1.length > 0)
         {
            _loc2_.width = 1000;
            _loc2_.text = param1;
            _loc2_.width = Math.max(10,_loc2_.textWidth + 2);
         }
         else
         {
            _loc2_.width = 27;
         }
         _loc2_.height = _loc2_.textHeight + 5;
         return _loc2_;
      }
      
      private function removeDeletedElementsFromRow() : void
      {
         var _loc1_:TextField = null;
         var _loc3_:DisplayObject = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.row)
         {
            if(_loc3_.parent)
            {
               _loc2_.push(_loc3_);
            }
         }
         this.row = _loc2_;
      }
      
      private function fixLayout(param1:Boolean = true) : void
      {
         var _loc5_:DisplayObject = null;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:TextField = null;
         var _loc10_:int = 0;
         var _loc11_:int = 0;
         var _loc12_:TextField = null;
         this.removeDeletedElementsFromRow();
         this.blockShape.x = 10;
         this.blockShape.y = 10;
         var _loc2_:int = this.blockShape.x + 6;
         var _loc3_:int = this.blockShape.y + 5;
         var _loc4_:int = 0;
         for each(_loc5_ in this.row)
         {
            _loc4_ = Math.max(_loc4_,_loc5_.height);
         }
         for each(_loc5_ in this.row)
         {
            _loc5_.x = _loc2_;
            _loc5_.y = _loc3_ + int((_loc4_ - _loc5_.height) / 2) + (_loc5_ is TextField ? 1 : 1);
            _loc2_ += _loc5_.width + 4;
            if(_loc5_ is BlockArg && BlockArg(_loc5_).type == "s")
            {
               _loc2_ -= 2;
            }
         }
         _loc6_ = Math.max(40,_loc2_ + 4 - this.blockShape.x);
         this.blockShape.setWidthAndTopHeight(_loc6_,_loc4_ + 11,true);
         this.moreButton.x = 0;
         this.moreButton.y = this.blockShape.y + this.blockShape.height + 12;
         this.moreLabel.x = 10;
         this.moreLabel.y = this.moreButton.y - 4;
         _loc7_ = this.blockShape.x + 45;
         _loc8_ = 240;
         for each(_loc9_ in this.buttonLabels)
         {
            _loc8_ = Math.max(_loc8_,_loc7_ + _loc9_.textWidth + 10);
         }
         _loc10_ = this.blockShape.y + this.blockShape.height + 30;
         _loc11_ = 0;
         while(_loc11_ < this.buttons.length)
         {
            _loc12_ = this.buttonLabels[_loc11_];
            this.buttonLabels[_loc11_].x = _loc7_;
            this.buttonLabels[_loc11_].y = _loc10_;
            this.buttons[_loc11_].x = _loc8_;
            this.buttons[_loc11_].y = _loc10_ - 4;
            _loc10_ += 30;
            _loc11_++;
         }
         this.warpCheckbox.x = this.blockShape.x + 46;
         this.warpCheckbox.y = _loc10_ + 4;
         this.warpLabel.x = this.warpCheckbox.x + 18;
         this.warpLabel.y = this.warpCheckbox.y - 3;
         if(param1)
         {
            this.updateDeleteButton();
         }
         if(parent is DialogBox)
         {
            DialogBox(parent).fixLayout();
         }
      }
      
      public function click(param1:MouseEvent) : void
      {
         this.editArg(param1);
      }
      
      public function doubleClick(param1:MouseEvent) : void
      {
         this.editArg(param1);
      }
      
      private function editArg(param1:MouseEvent) : void
      {
         var _loc2_:BlockArg = param1.target.parent as BlockArg;
         if(Boolean(_loc2_) && _loc2_.isEditable)
         {
            _loc2_.startEditing();
         }
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = null;
         if(param1.target == this && this.blockShape.hitTestPoint(param1.stageX,param1.stageY))
         {
            for each(_loc2_ in this.row)
            {
               if(_loc2_ is TextField)
               {
                  stage.focus = TextField(_loc2_);
                  return;
               }
            }
         }
      }
      
      private function textChange(param1:Event) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         if(_loc2_)
         {
            this.fixLabelWidth(_loc2_);
         }
         this.fixLayout();
      }
      
      private function fixLabelWidth(param1:TextField) : void
      {
         param1.width = 1000;
         param1.text = param1.text;
         param1.width = Math.max(10,param1.textWidth + 6);
      }
      
      public function setInitialFocus() : void
      {
         if(this.row.length == 0)
         {
            this.appendObj(this.makeTextField(""));
         }
         var _loc1_:TextField = this.row[0] as TextField;
         if(_loc1_)
         {
            if(_loc1_.text.length == 0)
            {
               _loc1_.width = 27;
            }
            else
            {
               this.fixLabelWidth(_loc1_);
            }
            this.fixLayout();
         }
         this.setFocus(this.row[0]);
      }
      
      private function setFocus(param1:DisplayObject) : void
      {
         if(!stage)
         {
            return;
         }
         if(param1 is TextField)
         {
            stage.focus = TextField(param1);
         }
         if(param1 is BlockArg)
         {
            BlockArg(param1).startEditing();
         }
      }
      
      private function uniqueName(param1:Array, param2:String) : String
      {
         if(param1.indexOf(param2) == -1)
         {
            return param2;
         }
         var _loc3_:Array = /\d+$/.exec(param2);
         var _loc4_:String = _loc3_ ? _loc3_[0] : "";
         var _loc5_:String = param2.slice(0,param2.length - _loc4_.length);
         var _loc6_:int = int(_loc4_ || "1") + 1;
         while(param1.indexOf(_loc5_ + _loc6_) != -1)
         {
            _loc6_++;
         }
         return _loc5_ + _loc6_;
      }
      
      private function focusChange(param1:FocusEvent) : void
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:TextField = null;
         var _loc6_:Boolean = false;
         var _loc2_:Array = [];
         var _loc3_:Boolean = false;
         for each(_loc4_ in this.row)
         {
            if(_loc4_ is TextField)
            {
               _loc5_ = TextField(_loc4_);
               _loc6_ = stage != null && _loc5_ == stage.focus;
               _loc5_.textColor = _loc6_ ? 0 : 16777215;
               _loc5_.backgroundColor = _loc6_ ? uint(this.selectedLabelColor) : uint(this.labelColor);
            }
            else if(_loc4_ is BlockArg)
            {
               _loc5_ = BlockArg(_loc4_).field;
               if(_loc2_.indexOf(_loc5_.text) != -1)
               {
                  BlockArg(_loc4_).setArgValue(this.uniqueName(_loc2_,_loc5_.text));
                  _loc3_ = true;
               }
               _loc2_.push(_loc5_.text);
            }
         }
         if(_loc3_)
         {
            this.fixLayout(false);
         }
         else if(param1.type == FocusEvent.FOCUS_IN)
         {
            this.updateDeleteButton();
         }
      }
      
      private function updateDeleteButton() : void
      {
         var _loc1_:Boolean = false;
         var _loc3_:DisplayObject = null;
         var _loc4_:Rectangle = null;
         var _loc2_:int = 0;
         if(stage == null)
         {
            return;
         }
         if(this.row.length > 0)
         {
            this.focusItem = this.row[0];
         }
         for each(_loc3_ in this.row)
         {
            if(_loc3_ is TextField)
            {
               if(stage.focus == _loc3_)
               {
                  this.focusItem = _loc3_;
               }
               _loc2_++;
            }
            if(_loc3_ is BlockArg)
            {
               if(stage.focus == BlockArg(_loc3_).field)
               {
                  this.focusItem = _loc3_;
               }
            }
         }
         if(this.focusItem)
         {
            _loc4_ = this.focusItem.getBounds(this);
            this.deleteButton.x = _loc4_.x + int(_loc4_.width / 2) - 6;
         }
         this.deleteButton.visible = this.row.length > 1;
         this.deleteButton.y = -6;
      }
   }
}

