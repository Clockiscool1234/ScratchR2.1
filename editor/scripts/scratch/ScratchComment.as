package scratch
{
   import blocks.Block;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.*;
   import translation.*;
   import uiwidgets.*;
   
   public class ScratchComment extends Sprite
   {
      
      public var blockID:int;
      
      public var blockRef:Block;
      
      private const contentsFormat:TextFormat = new TextFormat(CSS.font,12,CSS.textColor,false);
      
      private const titleFormat:TextFormat = new TextFormat(CSS.font,12,CSS.textColor,true);
      
      private const arrowColor:int = 8421504;
      
      private const bodyColor:int = 16777170;
      
      private const titleBarColor:int = 16777125;
      
      private var frame:ResizeableFrame;
      
      private var titleBar:Shape;
      
      private var expandButton:IconButton;
      
      private var title:TextField;
      
      private var contents:TextField;
      
      private var clipMask:Shape;
      
      private var isOpen:Boolean;
      
      private var expandedSize:Point;
      
      public function ScratchComment(param1:String = null, param2:Boolean = true, param3:int = 150, param4:int = -1)
      {
         super();
         this.isOpen = param2;
         this.blockID = param4;
         this.addFrame();
         addChild(this.titleBar = new Shape());
         addChild(this.clipMask = new Shape());
         this.addExpandButton();
         this.addTitle();
         this.addContents();
         this.contents.text = param1 || Translator.map("add comment here...");
         this.contents.mask = this.clipMask;
         this.frame.setWidthHeight(param3,200);
         this.expandedSize = new Point(param3,200);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         this.fixLayout();
         this.setExpanded(param2);
      }
      
      public static function fromArray(param1:Array) : ScratchComment
      {
         var _loc2_:ScratchComment = null;
         _loc2_ = new ScratchComment();
         _loc2_.x = param1[0];
         _loc2_.y = param1[1];
         _loc2_.blockID = param1[5];
         _loc2_.contents.text = param1[6];
         if(param1[4])
         {
            _loc2_.expandedSize = new Point(param1[2],param1[3]);
         }
         else
         {
            _loc2_.frame.setWidthHeight(param1[2],param1[3] == 19 ? 200 : int(param1[3]));
         }
         _loc2_.setExpanded(param1[4]);
         return _loc2_;
      }
      
      public function objToGrab(param1:*) : *
      {
         return this;
      }
      
      public function fixLayout() : void
      {
         this.contents.x = 5;
         this.contents.y = 20;
         var _loc1_:int = this.frame.w - this.contents.x - 6;
         var _loc2_:int = this.frame.h - this.contents.y - 2;
         this.contents.width = _loc1_;
         this.contents.height = _loc2_;
         var _loc3_:Graphics = this.clipMask.graphics;
         _loc3_.clear();
         _loc3_.beginFill(16776960);
         _loc3_.drawRect(this.contents.x,this.contents.y,_loc1_,_loc2_);
         this.drawTitleBar();
      }
      
      public function startEditText() : void
      {
         this.contents.setSelection(0,this.contents.text.length);
         stage.focus = this.contents;
      }
      
      private function drawTitleBar() : void
      {
         var _loc1_:Graphics = this.titleBar.graphics;
         _loc1_.clear();
         _loc1_.lineStyle();
         _loc1_.beginFill(this.titleBarColor);
         _loc1_.drawRoundRect(1,1,this.frame.w - 1,21,11,11);
         _loc1_.beginFill(this.bodyColor);
         _loc1_.drawRect(1,18,this.frame.w - 1,4);
      }
      
      public function toArray() : Array
      {
         return [x,y,this.isOpen ? this.frame.width : this.expandedSize.x,this.isOpen ? this.frame.height : this.expandedSize.y,this.isOpen,this.blockID,this.contents.text];
      }
      
      public function updateBlockID(param1:Array) : void
      {
         if(this.blockRef)
         {
            this.blockID = param1.indexOf(this.blockRef);
         }
      }
      
      public function updateBlockRef(param1:Array) : void
      {
         if(this.blockID >= 0 && this.blockID < param1.length)
         {
            this.blockRef = param1[this.blockID];
         }
      }
      
      public function isExpanded() : Boolean
      {
         return this.isOpen;
      }
      
      public function setExpanded(param1:Boolean) : void
      {
         this.isOpen = param1;
         this.contents.visible = this.isOpen;
         this.titleBar.visible = this.isOpen;
         this.title.visible = !this.isOpen;
         this.expandButton.setOn(this.isOpen);
         if(param1)
         {
            this.frame.showResizer();
            this.frame.setColor(this.bodyColor);
            this.frame.setWidthHeight(this.expandedSize.x,this.expandedSize.y);
            if(parent)
            {
               parent.addChild(this);
            }
            this.fixLayout();
         }
         else
         {
            if(Boolean(stage) && stage.focus == this.contents)
            {
               stage.focus = null;
            }
            this.expandedSize = new Point(this.frame.w,this.frame.h);
            this.updateTitleText();
            this.frame.hideResizer();
            this.frame.setWidthHeight(this.frame.w,19);
            this.frame.setColor(this.titleBarColor);
         }
         var _loc2_:ScriptsPane = parent as ScriptsPane;
         if(_loc2_)
         {
            _loc2_.fixCommentLayout();
         }
      }
      
      private function updateTitleText() : void
      {
         var _loc1_:String = "...";
         var _loc2_:int = this.frame.w - this.title.x - 5;
         var _loc3_:String = this.contents.text;
         var _loc4_:int = _loc3_.indexOf("\r");
         if(_loc4_ > -1)
         {
            _loc3_ = _loc3_.slice(0,_loc4_);
         }
         _loc4_ = _loc3_.indexOf("\n");
         if(_loc4_ > -1)
         {
            _loc3_ = _loc3_.slice(0,_loc4_);
         }
         _loc4_ = 1;
         while(_loc4_ < _loc3_.length)
         {
            this.title.text = _loc3_.slice(0,_loc4_) + _loc1_;
            if(this.title.textWidth > _loc2_)
            {
               this.title.text = _loc3_.slice(0,_loc4_ - 1) + _loc1_;
               return;
            }
            _loc4_++;
         }
         this.title.text = _loc3_;
      }
      
      public function menu(param1:MouseEvent) : Menu
      {
         var startX:Number = NaN;
         var startY:Number = NaN;
         var evt:MouseEvent = param1;
         var m:Menu = new Menu();
         startX = stage.mouseX;
         startY = stage.mouseY;
         m.addItem("duplicate",function():void
         {
            duplicateComment(stage.mouseX - startX,stage.mouseY - startY);
         });
         m.addItem("delete",this.deleteComment);
         return m;
      }
      
      public function handleTool(param1:String, param2:MouseEvent) : void
      {
         if(param1 == "copy")
         {
            this.duplicateComment(10,5);
         }
         if(param1 == "cut")
         {
            this.deleteComment();
         }
      }
      
      public function deleteComment() : void
      {
         if(parent)
         {
            parent.removeChild(this);
         }
         Scratch.app.runtime.recordForUndelete(this,x,y,0,Scratch.app.viewedObj());
         Scratch.app.scriptsPane.saveScripts();
      }
      
      public function duplicateComment(param1:Number, param2:Number) : void
      {
         var _loc3_:ScratchComment = null;
         if(!parent)
         {
            return;
         }
         _loc3_ = new ScratchComment(this.contents.text,this.isOpen);
         _loc3_.x = x + param1;
         _loc3_.y = y + param2;
         parent.addChild(_loc3_);
         Scratch.app.gh.grabOnMouseUp(_loc3_);
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         var _loc2_:int = 0;
         if(this.isOpen && param1.localY > 20)
         {
            _loc2_ = this.contents.text.length;
            this.contents.setSelection(_loc2_,_loc2_);
            stage.focus = this.contents;
         }
      }
      
      private function addFrame() : void
      {
         this.frame = new ResizeableFrame(CSS.borderColor,this.bodyColor,11,false,1);
         this.frame.minWidth = 100;
         this.frame.minHeight = 34;
         this.frame.showResizer();
         addChild(this.frame);
      }
      
      private function addTitle() : void
      {
         this.title = new TextField();
         this.title.autoSize = TextFieldAutoSize.LEFT;
         this.title.selectable = false;
         this.title.defaultTextFormat = this.titleFormat;
         this.title.visible = false;
         this.title.x = 14;
         this.title.y = 1;
         addChild(this.title);
      }
      
      private function addContents() : void
      {
         this.contents = new TextField();
         this.contents.type = "input";
         this.contents.wordWrap = true;
         this.contents.multiline = true;
         this.contents.autoSize = TextFieldAutoSize.LEFT;
         this.contents.defaultTextFormat = this.contentsFormat;
         addChild(this.contents);
      }
      
      private function addExpandButton() : void
      {
         var toggleExpand:Function = null;
         toggleExpand = function(param1:IconButton):void
         {
            setExpanded(!isOpen);
         };
         this.expandButton = new IconButton(toggleExpand,this.expandIcon(true),this.expandIcon(false));
         this.expandButton.setOn(true);
         this.expandButton.disableMouseover();
         this.expandButton.x = 4;
         this.expandButton.y = 4;
         addChild(this.expandButton);
      }
      
      private function expandIcon(param1:Boolean) : Shape
      {
         var _loc2_:Shape = new Shape();
         var _loc3_:Graphics = _loc2_.graphics;
         _loc3_.lineStyle();
         _loc3_.beginFill(this.arrowColor);
         if(param1)
         {
            _loc3_.moveTo(0,2);
            _loc3_.lineTo(5.5,8);
            _loc3_.lineTo(11,2);
         }
         else
         {
            _loc3_.moveTo(2,0);
            _loc3_.lineTo(8,5.5);
            _loc3_.lineTo(2,11);
         }
         _loc3_.endFill();
         return _loc2_;
      }
   }
}

