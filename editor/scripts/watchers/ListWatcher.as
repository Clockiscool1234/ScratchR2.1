package watchers
{
   import flash.display.*;
   import flash.events.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.*;
   import interpreter.Interpreter;
   import scratch.ScratchObj;
   import translation.Translator;
   import uiwidgets.*;
   import util.CachedTimer;
   import util.JSON;
   
   public class ListWatcher extends Sprite
   {
      
      private const titleFont:TextFormat = new TextFormat(CSS.font,12,0,true);
      
      private const cellNumFont:TextFormat = new TextFormat(CSS.font,11,0,false);
      
      private const SCROLLBAR_W:int = 10;
      
      public var listName:String = "";
      
      public var target:ScratchObj;
      
      public var contents:Array = [];
      
      public var isPersistent:Boolean = false;
      
      private var frame:ResizeableFrame;
      
      private var title:TextField;
      
      private var elementCount:TextField;
      
      private var cellPane:Sprite;
      
      private var scrollbar:Scrollbar;
      
      private var addItemButton:IconButton;
      
      private var firstVisibleIndex:int;
      
      private var visibleCells:Array = [];
      
      private var visibleCellNums:Array = [];
      
      private var insertionIndex:int = -1;
      
      private var cellPool:Array = [];
      
      private var cellNumPool:Array = [];
      
      private var tempCellNum:TextField;
      
      private var lastAccess:Vector.<uint> = new Vector.<uint>();
      
      private var lastActiveIndex:int;
      
      private var contentsChanged:Boolean;
      
      private var isIdle:Boolean;
      
      private var limitedView:Boolean;
      
      public function ListWatcher(param1:String = "List Title", param2:Array = null, param3:ScratchObj = null, param4:Boolean = false)
      {
         super();
         this.listName = param1;
         this.target = param3;
         this.contents = param2 == null ? [] : param2;
         this.limitedView = param4;
         this.frame = new ResizeableFrame(9736593,12698823,14,false,2);
         this.frame.setWidthHeight(50,100);
         this.frame.showResizer();
         this.frame.minWidth = 80;
         this.frame.minHeight = 62;
         addChild(this.frame);
         this.title = this.createTextField(param1,this.titleFont);
         this.frame.addChild(this.title);
         this.cellPane = new Sprite();
         this.cellPane.mask = new Shape();
         this.cellPane.addChild(this.cellPane.mask);
         addChild(this.cellPane);
         this.scrollbar = new Scrollbar(10,10,this.scrollToFraction);
         addChild(this.scrollbar);
         this.addItemButton = new IconButton(this.addItem,"addItem");
         addChild(this.addItemButton);
         this.elementCount = this.createTextField(Translator.map("length") + ": 0",this.cellNumFont);
         this.frame.addChild(this.elementCount);
         this.setWidthHeight(100,200);
         addEventListener(FocusEvent.FOCUS_IN,this.gotFocus);
         addEventListener(FocusEvent.FOCUS_OUT,this.lostFocus);
      }
      
      public static function strings() : Array
      {
         return ["length","import","export","hide","Which column do you want to import"];
      }
      
      public function toggleLimitedView(param1:Boolean) : void
      {
         this.limitedView = param1;
      }
      
      public function updateTitleAndContents() : void
      {
         this.updateTitle();
         this.scrollToIndex(0);
      }
      
      public function updateTranslation() : void
      {
         this.updateElementCount();
      }
      
      public function objToGrab(param1:MouseEvent) : ListWatcher
      {
         return this;
      }
      
      public function menu(param1:MouseEvent) : Menu
      {
         var _loc2_:Menu = new Menu();
         _loc2_.addItem("import",this.importList);
         _loc2_.addItem("export",this.exportList);
         _loc2_.addLine();
         _loc2_.addItem("hide",this.hide);
         return _loc2_;
      }
      
      private function importList() : void
      {
         var fileLoaded:Function = null;
         fileLoaded = function(param1:Event):void
         {
            var _loc2_:FileReference = FileReference(param1.target);
            var _loc3_:String = _loc2_.data.readUTFBytes(_loc2_.data.length);
            importLines(removeTrailingEmptyLines(_loc3_.split(/\r\n|[\r\n]/)));
         };
         Scratch.loadSingleFile(fileLoaded);
      }
      
      private function exportList() : void
      {
         var _loc1_:FileReference = new FileReference();
         var _loc2_:String = this.contents.join("\n") + "\n";
         _loc1_.save(_loc2_,this.listName + ".txt");
      }
      
      private function hide() : void
      {
         visible = false;
         Scratch.app.updatePalette(false);
      }
      
      private function removeTrailingEmptyLines(param1:Array) : Array
      {
         while(Boolean(param1.length) && !param1[param1.length - 1])
         {
            param1.pop();
         }
         return param1;
      }
      
      private function importLines(param1:Array) : void
      {
         var gotColumn:Function = null;
         var delimiter:String = null;
         var columnCount:int = 0;
         var lines:Array = param1;
         gotColumn = function(param1:String):void
         {
            var _loc2_:Number = parseInt(param1);
            if(isNaN(_loc2_) || _loc2_ < 1 || _loc2_ > columnCount)
            {
               contents = lines;
            }
            else
            {
               contents = extractColumn(_loc2_,lines,delimiter);
            }
            scrollToIndex(0);
         };
         delimiter = this.guessDelimiter(lines);
         if(delimiter == null)
         {
            this.contents = lines;
            this.scrollToIndex(0);
            return;
         }
         columnCount = int(lines[0].split(delimiter).length);
         DialogBox.ask(Translator.map("Which column do you want to import") + "(1-" + columnCount + ")?","1",Scratch.app.stage,gotColumn);
      }
      
      private function guessDelimiter(param1:Array) : String
      {
         var _loc2_:String = null;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         if(param1.length == 0)
         {
            return null;
         }
         for each(_loc2_ in [",","\t"])
         {
            _loc3_ = int(param1[0].split(_loc2_).length);
            _loc4_ = int(param1[Math.floor(param1.length / 2)].split(_loc2_).length);
            _loc5_ = int(param1[param1.length - 1].split(_loc2_).length);
            if(_loc3_ > 1 && _loc3_ == _loc4_ && _loc3_ == _loc5_)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      private function extractColumn(param1:int, param2:Array, param3:String) : Array
      {
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc4_:Array = [];
         for each(_loc5_ in param2)
         {
            _loc6_ = _loc5_.split(param3);
            _loc4_.push(param1 <= _loc6_.length ? _loc6_[param1 - 1] : "");
         }
         return _loc4_;
      }
      
      public function updateWatcher(param1:int, param2:Boolean, param3:Interpreter) : void
      {
         this.isIdle = false;
         if(!param2)
         {
            this.contentsChanged = true;
         }
         if(parent == null)
         {
            visible = false;
         }
         if(!visible)
         {
            return;
         }
         this.adjustLastAccessSize();
         if(param1 < 1 || param1 > this.lastAccess.length)
         {
            return;
         }
         this.lastAccess[param1 - 1] = CachedTimer.getCachedTimer();
         this.lastActiveIndex = param1 - 1;
         param3.redraw();
      }
      
      public function prepareToShow() : void
      {
         this.updateTitle();
         this.contentsChanged = true;
         this.isIdle = false;
         this.step();
      }
      
      public function step() : void
      {
         if(this.isIdle)
         {
            return;
         }
         if(this.contentsChanged)
         {
            this.updateContents();
            this.updateScrollbar();
            this.contentsChanged = false;
         }
         if(this.contents.length == 0)
         {
            this.isIdle = true;
            return;
         }
         this.ensureVisible();
         this.updateIndexHighlights();
      }
      
      private function ensureVisible() : void
      {
         var _loc1_:int = Math.max(0,Math.min(this.lastActiveIndex,this.contents.length - 1));
         if(this.firstVisibleIndex <= _loc1_ && _loc1_ < this.firstVisibleIndex + this.visibleCells.length)
         {
            return;
         }
         this.firstVisibleIndex = _loc1_;
         this.updateContents();
         this.updateScrollbar();
      }
      
      private function updateIndexHighlights() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc1_:int = 800;
         this.adjustLastAccessSize();
         var _loc2_:int = CachedTimer.getCachedTimer();
         this.isIdle = true;
         var _loc3_:int = 0;
         while(_loc3_ < this.visibleCellNums.length)
         {
            _loc4_ = int(this.lastAccess[this.firstVisibleIndex + _loc3_]);
            if(_loc4_ > 0)
            {
               this.isIdle = false;
               _loc5_ = _loc2_ - _loc4_;
               if(_loc5_ < _loc1_)
               {
                  _loc6_ = 255 * ((_loc1_ - _loc5_) / _loc1_);
                  this.visibleCellNums[_loc3_].textColor = _loc6_ << 16 | _loc6_ << 8;
               }
               else
               {
                  this.visibleCellNums[_loc3_].textColor = 0;
                  this.lastAccess[this.firstVisibleIndex + _loc3_] = 0;
               }
            }
            _loc3_++;
         }
      }
      
      private function adjustLastAccessSize() : void
      {
         if(this.lastAccess.length == this.contents.length)
         {
            return;
         }
         if(this.lastAccess.length < this.contents.length)
         {
            this.lastAccess = this.lastAccess.concat(new Vector.<uint>(this.contents.length - this.lastAccess.length));
         }
         else if(this.lastAccess.length > this.contents.length)
         {
            this.lastAccess = this.lastAccess.slice(0,this.contents.length);
         }
      }
      
      private function addItem(param1:IconButton = null) : void
      {
         if(root is Scratch && !(root as Scratch).editMode)
         {
            return;
         }
         if(this.insertionIndex < 0)
         {
            this.insertionIndex = this.contents.length;
         }
         this.contents.splice(this.insertionIndex,0,"");
         this.updateContents();
         this.updateScrollbar();
         this.selectCell(this.insertionIndex);
      }
      
      private function gotFocus(param1:FocusEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         if(_loc2_ == null)
         {
            return;
         }
         this.insertionIndex = -1;
         var _loc3_:int = 0;
         while(_loc3_ < this.visibleCells.length)
         {
            if(this.visibleCells[_loc3_] == _loc2_.parent)
            {
               this.insertionIndex = this.firstVisibleIndex + _loc3_ + 1;
               return;
            }
            _loc3_++;
         }
      }
      
      private function lostFocus(param1:FocusEvent) : void
      {
         if(param1.relatedObject != null)
         {
            this.insertionIndex = -1;
         }
      }
      
      private function deleteItem(param1:IconButton) : void
      {
         var _loc4_:ListCell = null;
         var _loc5_:int = 0;
         var _loc2_:ListCell = param1.lastEvent.target.parent as ListCell;
         if(_loc2_ == null)
         {
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < this.visibleCells.length)
         {
            _loc4_ = this.visibleCells[_loc3_];
            if(_loc4_ == _loc2_)
            {
               _loc5_ = this.firstVisibleIndex + _loc3_;
               this.contents.splice(_loc5_,1);
               if(_loc5_ == this.contents.length && this.visibleCells.length == 1)
               {
                  this.scrollToIndex(_loc5_ - 1);
               }
               else
               {
                  this.updateContents();
                  this.updateScrollbar();
               }
               if(this.visibleCells.length)
               {
                  this.selectCell(Math.min(_loc5_,this.contents.length - 1));
               }
               return;
            }
            _loc3_++;
         }
      }
      
      public function setWidthHeight(param1:int, param2:int) : void
      {
         var _loc3_:Object = this.parent || Scratch.app.stagePane || {
            "width":480,
            "height":360
         };
         x = Math.max(0,Math.min(x,_loc3_.width - this.frame.minWidth));
         y = Math.max(0,Math.min(y,_loc3_.height - this.frame.minHeight));
         param1 = Math.max(this.frame.minWidth,Math.min(param1,_loc3_.width - x));
         param2 = Math.max(this.frame.minHeight,Math.min(param2,_loc3_.height - y));
         this.frame.setWidthHeight(param1,param2);
         this.fixLayout();
      }
      
      public function fixLayout() : void
      {
         this.title.x = Math.floor((this.frame.w - this.title.width) / 2);
         this.title.y = 2;
         this.elementCount.x = Math.floor((this.frame.w - this.elementCount.width) / 2);
         this.elementCount.y = this.frame.h - this.elementCount.height + 1;
         this.cellPane.x = 1;
         this.cellPane.y = 22;
         this.addItemButton.x = 2;
         this.addItemButton.y = this.frame.h - this.addItemButton.height - 2;
         var _loc1_:Graphics = (this.cellPane.mask as Shape).graphics;
         _loc1_.clear();
         _loc1_.beginFill(0);
         _loc1_.drawRect(0,0,this.frame.w - 17,this.frame.h - 42);
         _loc1_.endFill();
         this.scrollbar.setWidthHeight(this.SCROLLBAR_W,this.cellPane.mask.height);
         this.scrollbar.x = this.frame.w - this.SCROLLBAR_W - 2;
         this.scrollbar.y = 20;
         this.updateContents();
         this.updateScrollbar();
      }
      
      private function scrollToFraction(param1:Number) : void
      {
         var _loc2_:int = this.firstVisibleIndex;
         param1 = Math.floor(param1 * this.contents.length);
         this.firstVisibleIndex = Math.max(0,Math.min(param1,this.contents.length - 1));
         this.lastActiveIndex = this.firstVisibleIndex;
         if(this.firstVisibleIndex != _loc2_)
         {
            this.updateContents();
         }
      }
      
      private function scrollToIndex(param1:int) : void
      {
         var _loc2_:Number = param1 / (this.contents.length - 1);
         this.firstVisibleIndex = -1;
         this.scrollToFraction(_loc2_);
         this.updateScrollbar();
      }
      
      private function updateScrollbar() : void
      {
         var _loc1_:Number = (this.firstVisibleIndex - 1) / (this.contents.length - 1);
         this.scrollbar.update(_loc1_,this.visibleCells.length / this.contents.length);
      }
      
      public function updateContents() : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc8_:String = null;
         var _loc9_:ListCell = null;
         var _loc10_:TextField = null;
         var _loc11_:TextField = null;
         var _loc1_:Boolean = Scratch.app.editMode && !this.limitedView;
         this.updateElementCount();
         this.removeAllCells();
         this.visibleCells = [];
         this.visibleCellNums = [];
         _loc2_ = this.cellPane.height;
         _loc3_ = this.cellNumWidth() + 14;
         var _loc4_:int = _loc3_;
         var _loc5_:int = this.cellPane.width - _loc4_ - 1;
         var _loc6_:int = 0;
         var _loc7_:int = this.firstVisibleIndex;
         while(_loc7_ < this.contents.length)
         {
            _loc8_ = Watcher.formatValue(this.contents[_loc7_]);
            if(this.limitedView && _loc8_.length > 8)
            {
               _loc8_ = _loc8_.slice(0,8) + "...";
            }
            _loc9_ = this.allocateCell(_loc8_,_loc5_);
            _loc9_.x = _loc4_;
            _loc9_.y = _loc6_;
            _loc9_.setEditable(_loc1_);
            this.visibleCells.push(_loc9_);
            this.cellPane.addChild(_loc9_);
            _loc10_ = this.allocateCellNum(String(_loc7_ + 1));
            _loc10_.x = _loc3_ - _loc10_.width - 3;
            _loc10_.y = _loc6_ + int((_loc9_.height - _loc10_.height) / 2);
            _loc10_.textColor = 0;
            this.visibleCellNums.push(_loc10_);
            this.cellPane.addChild(_loc10_);
            _loc6_ += _loc9_.height - 1;
            if(_loc6_ > _loc2_)
            {
               break;
            }
            _loc7_++;
         }
         if(!this.contents.length)
         {
            _loc11_ = this.createTextField(Translator.map("(empty)"),this.cellNumFont);
            _loc11_.x = (this.frame.w - this.SCROLLBAR_W - _loc11_.textWidth) / 2;
            _loc11_.y = (_loc2_ - _loc11_.textHeight) / 2;
            this.cellPane.addChild(_loc11_);
         }
      }
      
      private function cellNumWidth() : int
      {
         if(this.tempCellNum == null)
         {
            this.tempCellNum = this.createTextField("",this.cellNumFont);
         }
         var _loc1_:int = Math.log(this.firstVisibleIndex + 20) / Math.log(10);
         this.tempCellNum.text = "000000000000000".slice(0,_loc1_);
         return this.tempCellNum.textWidth;
      }
      
      private function removeAllCells() : void
      {
         var _loc1_:DisplayObject = null;
         while(this.cellPane.numChildren > 1)
         {
            _loc1_ = this.cellPane.getChildAt(1);
            if(_loc1_ is ListCell)
            {
               this.cellPool.push(_loc1_);
            }
            if(_loc1_ is TextField)
            {
               this.cellNumPool.push(_loc1_);
            }
            this.cellPane.removeChildAt(1);
         }
      }
      
      private function allocateCell(param1:String, param2:int) : ListCell
      {
         if(this.cellPool.length == 0)
         {
            return new ListCell(param1,param2,this.textChanged,this.keyPress,this.deleteItem);
         }
         var _loc3_:ListCell = this.cellPool.pop();
         _loc3_.setText(param1,param2);
         return _loc3_;
      }
      
      private function allocateCellNum(param1:String) : TextField
      {
         if(this.cellNumPool.length == 0)
         {
            return this.createTextField(param1,this.cellNumFont);
         }
         var _loc2_:TextField = this.cellNumPool.pop();
         _loc2_.text = param1;
         _loc2_.width = _loc2_.textWidth + 5;
         return _loc2_;
      }
      
      private function createTextField(param1:String, param2:TextFormat) : TextField
      {
         var _loc3_:TextField = new TextField();
         _loc3_.type = "dynamic";
         _loc3_.selectable = false;
         _loc3_.defaultTextFormat = param2;
         _loc3_.text = param1;
         _loc3_.height = _loc3_.textHeight + 5;
         _loc3_.width = _loc3_.textWidth + 5;
         return _loc3_;
      }
      
      public function updateTitle() : void
      {
         this.title.text = this.target == null || this.target.isStage ? this.listName : this.target.objName + ": " + this.listName;
         this.title.width = this.title.textWidth + 5;
         this.title.x = Math.floor((this.frame.w - this.title.width) / 2);
      }
      
      private function updateElementCount() : void
      {
         this.elementCount.text = Translator.map("length") + ": " + this.contents.length;
         this.elementCount.width = this.elementCount.textWidth + 5;
         this.elementCount.x = Math.floor((this.frame.w - this.elementCount.width) / 2);
      }
      
      private function textChanged(param1:Event) : void
      {
         var _loc4_:ListCell = null;
         var _loc2_:TextField = param1.target as TextField;
         var _loc3_:int = 0;
         while(_loc3_ < this.visibleCells.length)
         {
            _loc4_ = this.visibleCells[_loc3_];
            if(_loc4_.tf == _loc2_)
            {
               this.contents[this.firstVisibleIndex + _loc3_] = _loc2_.text;
               return;
            }
            _loc3_++;
         }
      }
      
      private function selectCell(param1:int, param2:Boolean = true) : void
      {
         var _loc3_:int = param1 - this.firstVisibleIndex;
         if(_loc3_ >= 0 && _loc3_ < this.visibleCells.length)
         {
            this.visibleCells[_loc3_].select();
            this.insertionIndex = param1 + 1;
         }
         else if(param2)
         {
            this.scrollToIndex(param1);
            this.selectCell(param1,false);
         }
      }
      
      private function keyPress(param1:KeyboardEvent) : void
      {
         var _loc5_:ListCell = null;
         if(param1.keyCode == 13)
         {
            if(param1.shiftKey)
            {
               --this.insertionIndex;
            }
            this.addItem();
            return;
         }
         if(this.contents.length < 2)
         {
            return;
         }
         var _loc2_:int = param1.keyCode == 38 ? -1 : (param1.keyCode == 40 ? 1 : (param1.keyCode == 9 ? (param1.shiftKey ? -1 : 1) : 0));
         if(_loc2_ == 0)
         {
            return;
         }
         var _loc3_:TextField = param1.target as TextField;
         var _loc4_:int = 0;
         while(_loc4_ < this.visibleCells.length)
         {
            _loc5_ = this.visibleCells[_loc4_];
            if(_loc5_.tf == _loc3_)
            {
               this.selectCell((this.firstVisibleIndex + _loc4_ + _loc2_ + this.contents.length) % this.contents.length);
               return;
            }
            _loc4_++;
         }
      }
      
      public function writeJSON(param1:util.JSON) : void
      {
         param1.writeKeyValue("listName",this.listName);
         param1.writeKeyValue("contents",this.contents);
         param1.writeKeyValue("isPersistent",this.isPersistent);
         param1.writeKeyValue("x",x);
         param1.writeKeyValue("y",y);
         param1.writeKeyValue("width",width);
         param1.writeKeyValue("height",height);
         param1.writeKeyValue("visible",visible && parent != null);
      }
      
      public function readJSON(param1:Object) : void
      {
         this.listName = param1.listName;
         this.contents = param1.contents;
         this.isPersistent = param1.isPersistent == undefined ? false : Boolean(param1.isPersistent);
         x = param1.x;
         y = param1.y;
         this.setWidthHeight(param1.width,param1.height);
         visible = param1.visible;
         this.updateTitleAndContents();
      }
   }
}

