package blocks
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.BevelFilter;
   import flash.text.*;
   import scratch.BlockMenus;
   import translation.Translator;
   import util.Color;
   
   public class BlockArg extends Sprite
   {
      
      public static const epsilon:Number = 1 / 4294967296;
      
      public static const NT_NOT_NUMBER:uint = 0;
      
      public static const NT_FLOAT:uint = 1;
      
      public static const NT_INT:uint = 2;
      
      public var type:String;
      
      public var base:BlockShape;
      
      public var argValue:* = "";
      
      public var numberType:uint = 0;
      
      public var isEditable:Boolean;
      
      public var field:TextField;
      
      public var menuName:String;
      
      private var menuIcon:Shape;
      
      public function BlockArg(param1:String, param2:int, param3:Boolean = false, param4:String = "")
      {
         var _loc6_:Graphics = null;
         super();
         this.type = param1;
         if(param2 == -1)
         {
            if(param1 == "d" || param1 == "n")
            {
               this.numberType = NT_FLOAT;
            }
            return;
         }
         var _loc5_:int = Color.scaleBrightness(param2,0.92);
         if(param1 == "b")
         {
            this.base = new BlockShape(BlockShape.BooleanShape,_loc5_);
            this.argValue = false;
         }
         else if(param1 == "c")
         {
            this.base = new BlockShape(BlockShape.RectShape,_loc5_);
            this.menuName = "colorPicker";
            addEventListener(MouseEvent.MOUSE_DOWN,this.invokeMenu);
         }
         else if(param1 == "d")
         {
            this.base = new BlockShape(BlockShape.NumberShape,_loc5_);
            this.numberType = NT_FLOAT;
            this.menuName = param4;
            addEventListener(MouseEvent.MOUSE_DOWN,this.invokeMenu);
         }
         else if(param1 == "m")
         {
            this.base = new BlockShape(BlockShape.RectShape,_loc5_);
            this.menuName = param4;
            addEventListener(MouseEvent.MOUSE_DOWN,this.invokeMenu);
         }
         else if(param1 == "n")
         {
            this.base = new BlockShape(BlockShape.NumberShape,_loc5_);
            this.numberType = NT_FLOAT;
            this.argValue = 0;
         }
         else
         {
            if(param1 != "s")
            {
               return;
            }
            this.base = new BlockShape(BlockShape.RectShape,_loc5_);
         }
         if(param1 == "c")
         {
            this.base.setWidthAndTopHeight(13,13);
            this.setArgValue(Color.random());
         }
         else
         {
            this.base.setWidthAndTopHeight(30,Block.argTextFormat.size + 6);
         }
         this.base.filters = this.blockArgFilters();
         addChild(this.base);
         if(param1 == "d" || param1 == "m")
         {
            this.menuIcon = new Shape();
            _loc6_ = this.menuIcon.graphics;
            _loc6_.beginFill(0,0.6);
            _loc6_.lineTo(7,0);
            _loc6_.lineTo(3.5,4);
            _loc6_.lineTo(0,0);
            _loc6_.endFill();
            this.menuIcon.y = 5;
            addChild(this.menuIcon);
         }
         if(Boolean(param3) || Boolean(this.numberType) || param1 == "m")
         {
            this.field = this.makeTextField();
            if(param1 == "m" && !param3)
            {
               this.field.textColor = 16777215;
            }
            else
            {
               this.base.setWidthAndTopHeight(30,Block.argTextFormat.size + 5);
            }
            this.field.text = this.numberType ? "10" : "";
            if(this.numberType)
            {
               this.field.restrict = "0-9e.\\-";
            }
            if(param3)
            {
               this.base.setColor(16777215);
               this.isEditable = true;
            }
            this.field.addEventListener(FocusEvent.FOCUS_OUT,this.stopEditing);
            addChild(this.field);
            this.textChanged(null);
         }
         else
         {
            this.base.redraw();
         }
      }
      
      public function labelOrNull() : String
      {
         return this.field ? this.field.text : null;
      }
      
      public function setArgValue(param1:*, param2:String = null) : void
      {
         var _loc3_:String = null;
         this.argValue = param1;
         if(this.field != null)
         {
            _loc3_ = param1 == null ? "" : param1;
            this.field.text = param2 ? param2 : _loc3_;
            if(Boolean(this.menuName && !param2) && Boolean(param1 is String) && param1 != "")
            {
               if(BlockMenus.shouldTranslateItemForMenu(param1,this.menuName))
               {
                  this.field.text = Translator.map(param1);
               }
            }
            this.textChanged(null);
            this.argValue = param1;
            return;
         }
         if(this.type == "c")
         {
            this.base.setColor(int(this.argValue) & 0xFFFFFF);
         }
         this.base.redraw();
      }
      
      public function startEditing() : void
      {
         if(this.isEditable)
         {
            this.field.type = TextFieldType.INPUT;
            this.field.selectable = true;
            if(this.field.text.length == 0)
            {
               this.field.text = "  ";
            }
            this.field.setSelection(0,this.field.text.length);
            root.stage.focus = this.field;
         }
      }
      
      private function stopEditing(param1:*) : void
      {
         this.field.type = TextFieldType.DYNAMIC;
         this.field.selectable = false;
      }
      
      private function blockArgFilters() : Array
      {
         var _loc1_:BevelFilter = new BevelFilter(1);
         _loc1_.blurX = _loc1_.blurY = 2;
         _loc1_.highlightAlpha = 0.3;
         _loc1_.shadowAlpha = 0.6;
         _loc1_.angle = 240;
         return [_loc1_];
      }
      
      private function makeTextField() : TextField
      {
         var _loc1_:TextField = new TextField();
         var _loc2_:Array = this.argTextInsets(this.type);
         _loc1_.x = _loc2_[0];
         _loc1_.y = _loc2_[1];
         _loc1_.autoSize = TextFieldAutoSize.LEFT;
         _loc1_.defaultTextFormat = Block.argTextFormat;
         _loc1_.selectable = false;
         _loc1_.addEventListener(Event.CHANGE,this.textChanged);
         return _loc1_;
      }
      
      private function argTextInsets(param1:String = "") : Array
      {
         if(param1 == "b")
         {
            return [5,0];
         }
         return this.numberType ? [3,0] : [2,-1];
      }
      
      private function textChanged(param1:*) : void
      {
         var _loc4_:Number = NaN;
         this.argValue = this.field.text;
         if(this.numberType)
         {
            _loc4_ = Number(this.argValue);
            if(!isNaN(_loc4_))
            {
               this.argValue = _loc4_;
               this.numberType = this.field.text.indexOf(".") == -1 && _loc4_ is int ? NT_INT : NT_FLOAT;
            }
            else
            {
               this.numberType = NT_FLOAT;
            }
         }
         var _loc2_:int = this.type == "n" ? 3 : 0;
         if(this.type == "b")
         {
            _loc2_ = 8;
         }
         if(this.menuIcon != null)
         {
            _loc2_ = this.type == "d" ? 10 : 13;
         }
         var _loc3_:int = Math.max(14,this.field.textWidth + 6 + _loc2_);
         if(this.menuIcon)
         {
            this.menuIcon.x = _loc3_ - this.menuIcon.width - 3;
         }
         this.base.setWidth(_loc3_);
         this.base.redraw();
         if(parent is Block)
         {
            Block(parent).fixExpressionLayout();
         }
         if(Boolean(param1) && Boolean(Scratch.app))
         {
            Scratch.app.setSaveNeeded();
         }
      }
      
      private function invokeMenu(param1:MouseEvent) : void
      {
         if(this.menuIcon != null && param1.localX <= this.menuIcon.x)
         {
            return;
         }
         if(Block.MenuHandlerFunction != null)
         {
            Block.MenuHandlerFunction(param1,parent,this,this.menuName);
            param1.stopImmediatePropagation();
         }
      }
   }
}

