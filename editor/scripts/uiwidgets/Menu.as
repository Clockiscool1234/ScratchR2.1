package uiwidgets
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.DropShadowFilter;
   import flash.geom.Point;
   import translation.TranslatableStrings;
   import util.CachedTimer;
   
   public class Menu extends Sprite
   {
      
      public static var stringCollectionMode:Boolean;
      
      private static var menuJustCreated:Boolean;
      
      public static var line:Object = new Object();
      
      public var clientFunction:Function;
      
      public var color:int;
      
      public var minWidth:int;
      
      public var itemHeight:int;
      
      private var menuName:String = "";
      
      private var allItems:Array = [];
      
      private var firstItemIndex:int = 0;
      
      private var maxHeight:int;
      
      private var maxScrollIndex:int;
      
      private var upArrow:Shape;
      
      private var downArrow:Shape;
      
      private var scrollMSecs:int = 40;
      
      private var lastTime:int;
      
      public function Menu(param1:Function = null, param2:String = "", param3:int = 10526880, param4:int = 28)
      {
         super();
         this.clientFunction = param1;
         this.menuName = param2;
         this.color = param3;
         this.itemHeight = param4;
      }
      
      public static function dummyButton() : IconButton
      {
         var _loc1_:IconButton = new IconButton(null,null);
         _loc1_.lastEvent = new MouseEvent("dummy");
         return _loc1_;
      }
      
      public static function removeMenusFrom(param1:DisplayObjectContainer) : void
      {
         var _loc2_:int = 0;
         var _loc4_:Menu = null;
         if(menuJustCreated)
         {
            menuJustCreated = false;
            return;
         }
         var _loc3_:Array = [];
         _loc2_ = 0;
         while(_loc2_ < param1.numChildren)
         {
            if(param1.getChildAt(_loc2_) is Menu)
            {
               _loc3_.push(param1.getChildAt(_loc2_));
            }
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < _loc3_.length)
         {
            _loc4_ = Menu(_loc3_[_loc2_]);
            if(_loc4_.parent != null)
            {
               _loc4_.parent.removeChild(_loc4_);
            }
            _loc2_++;
         }
      }
      
      public function addItem(param1:*, param2:* = null, param3:Boolean = true, param4:Boolean = false) : void
      {
         var _loc5_:MenuItem = this.allItems.length ? this.allItems[this.allItems.length - 1] : null;
         var _loc6_:MenuItem = new MenuItem(this,param1,param2,param3);
         if((!_loc5_ || _loc5_.isLine()) && _loc6_.isLine())
         {
            return;
         }
         _loc6_.showCheckmark(param4);
         this.allItems.push(_loc6_);
      }
      
      public function addLine() : void
      {
         this.addItem(line);
      }
      
      public function showOnStage(param1:Stage, param2:int = -1, param3:int = -1) : void
      {
         var _loc4_:MenuItem = null;
         var _loc5_:int = 0;
         if(stringCollectionMode)
         {
            for each(_loc4_ in this.allItems)
            {
               TranslatableStrings.add(_loc4_.getLabel(),true);
            }
            return;
         }
         removeMenusFrom(param1);
         if(this.allItems.length == 0)
         {
            return;
         }
         menuJustCreated = true;
         this.prepMenu(param1);
         this.scrollBy(0);
         this.x = param2 > 0 ? param2 : param1.mouseX + 5;
         this.y = param3 > 0 ? param3 : param1.mouseY - 5;
         this.x = Math.max(5,Math.min(this.x,param1.stageWidth - this.width - 8));
         this.y = Math.max(5,Math.min(this.y,param1.stageHeight - this.height - 8));
         if(this.x < param1.mouseX && this.y < param1.mouseY)
         {
            _loc5_ = param1.mouseX + 6;
            if(_loc5_ < param1.stageWidth - this.width)
            {
               this.x = _loc5_;
            }
         }
         param1.addChild(this);
         addEventListener(Event.ENTER_FRAME,this.step);
      }
      
      public function selected(param1:*) : void
      {
         stage.focus = null;
         if(this.clientFunction != null)
         {
            this.clientFunction(param1);
         }
         else if(param1 is Function)
         {
            param1();
         }
         if(parent != null)
         {
            parent.removeChild(this);
         }
      }
      
      private function prepMenu(param1:Stage) : void
      {
         var _loc2_:int = 0;
         var _loc4_:MenuItem = null;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc3_:int = this.minWidth;
         while(Boolean(this.allItems.length) && Boolean(this.allItems[this.allItems.length - 1].isLine()))
         {
            this.allItems.pop();
         }
         for each(_loc4_ in this.allItems)
         {
            _loc4_.translate(this.menuName);
         }
         for each(_loc4_ in this.allItems)
         {
            _loc3_ = Math.max(_loc3_,_loc4_.width);
         }
         _loc5_ = 0;
         for each(_loc4_ in this.allItems)
         {
            _loc4_.setWidthHeight(_loc3_,this.itemHeight);
            _loc4_.y = _loc5_;
            _loc5_ += _loc4_.height;
         }
         this.maxHeight = Math.min(500,param1.stageHeight - 50);
         this.maxScrollIndex = this.allItems.length - 1;
         while(this.maxScrollIndex > 0)
         {
            _loc6_ += this.allItems[this.maxScrollIndex].height;
            if(_loc6_ > this.maxHeight)
            {
               break;
            }
            --this.maxScrollIndex;
         }
         this.makeArrows(_loc3_);
         this.addShadowFilter();
      }
      
      private function makeArrows(param1:int) : void
      {
         this.upArrow = this.makeArrow(true);
         this.downArrow = this.makeArrow(false);
         this.upArrow.x = this.downArrow.x = param1 / 2 - 2;
         this.upArrow.y = 2;
      }
      
      private function makeArrow(param1:Boolean) : Shape
      {
         var _loc2_:Shape = new Shape();
         var _loc3_:Graphics = _loc2_.graphics;
         _loc3_.beginFill(16777215);
         if(param1)
         {
            _loc3_.moveTo(0,5);
            _loc3_.lineTo(5,0);
            _loc3_.lineTo(10,5);
         }
         else
         {
            _loc3_.moveTo(0,0);
            _loc3_.lineTo(10,0);
            _loc3_.lineTo(5,5);
         }
         _loc3_.endFill();
         return _loc2_;
      }
      
      private function step(param1:Event) : void
      {
         var _loc2_:int = 6;
         if(parent == null)
         {
            removeEventListener(Event.ENTER_FRAME,this.step);
            return;
         }
         if(CachedTimer.getCachedTimer() - this.lastTime < this.scrollMSecs)
         {
            return;
         }
         this.lastTime = CachedTimer.getCachedTimer();
         var _loc3_:int = this.globalToLocal(new Point(stage.mouseX,stage.mouseY)).y;
         if(_loc3_ < 2 + _loc2_ && this.firstItemIndex > 0)
         {
            this.scrollBy(-1);
         }
         if(_loc3_ > this.height - _loc2_ && this.firstItemIndex < this.maxScrollIndex)
         {
            this.scrollBy(1);
         }
      }
      
      private function scrollBy(param1:int) : void
      {
         var _loc5_:MenuItem = null;
         this.firstItemIndex += param1;
         var _loc2_:int = 1;
         while(this.numChildren > 0)
         {
            this.removeChildAt(0);
         }
         var _loc3_:int = this.firstItemIndex;
         while(_loc3_ < this.allItems.length)
         {
            _loc5_ = this.allItems[_loc3_];
            addChild(_loc5_);
            _loc5_.x = 1;
            _loc5_.y = _loc2_;
            _loc2_ += _loc5_.height;
            if(_loc2_ > this.maxHeight)
            {
               break;
            }
            _loc3_++;
         }
         if(this.firstItemIndex > 0)
         {
            addChild(this.upArrow);
         }
         var _loc4_:Boolean = this.allItems.length > 0 && !this.allItems[this.allItems.length - 1].parent;
         if(_loc4_)
         {
            this.downArrow.y = this.height - 5;
            addChild(this.downArrow);
         }
      }
      
      private function addShadowFilter() : void
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         _loc1_.blurX = _loc1_.blurY = 5;
         _loc1_.distance = 3;
         _loc1_.color = 3355443;
         filters = [_loc1_];
      }
   }
}

