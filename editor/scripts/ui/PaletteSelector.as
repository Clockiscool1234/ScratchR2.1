package ui
{
   import flash.display.*;
   import translation.Translator;
   
   public class PaletteSelector extends Sprite
   {
      
      private static const categories:Array = ["Motion","Looks","Sound","Pen","Data","Events","Control","Sensing","Operators","More Blocks"];
      
      public var selectedCategory:int = 0;
      
      private var app:Scratch;
      
      public function PaletteSelector(param1:Scratch)
      {
         super();
         this.app = param1;
         this.initCategories();
      }
      
      public static function strings() : Array
      {
         return categories.concat(["when Stage clicked"]);
      }
      
      public function updateTranslation() : void
      {
         this.initCategories();
      }
      
      public function select(param1:int, param2:Boolean = false) : void
      {
         var _loc5_:PaletteSelectorItem = null;
         var _loc3_:int = 0;
         while(_loc3_ < numChildren)
         {
            _loc5_ = getChildAt(_loc3_) as PaletteSelectorItem;
            _loc5_.setSelected(_loc5_.categoryID == param1);
            _loc3_++;
         }
         var _loc4_:int = this.selectedCategory;
         this.selectedCategory = param1;
         this.app.getPaletteBuilder().showBlocksForCategory(this.selectedCategory,param1 != _loc4_,param2);
      }
      
      private function initCategories() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc8_:Array = null;
         var _loc9_:PaletteSelectorItem = null;
         var _loc1_:int = 5;
         var _loc2_:int = 208;
         var _loc3_:int = 3;
         var _loc7_:int = _loc3_;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         _loc6_ = 0;
         while(_loc6_ < categories.length)
         {
            if(_loc6_ == _loc1_)
            {
               _loc5_ = _loc2_ / 2 - 3;
               _loc7_ = _loc3_;
            }
            _loc8_ = Specs.entryForCategory(categories[_loc6_]);
            _loc9_ = new PaletteSelectorItem(_loc8_[0],Translator.map(_loc8_[1]),_loc8_[2]);
            _loc4_ = _loc9_.height;
            _loc9_.x = _loc5_;
            _loc9_.y = _loc7_;
            addChild(_loc9_);
            _loc7_ += _loc4_;
            _loc6_++;
         }
         this.setWidthHeightColor(_loc2_,_loc3_ + _loc1_ * _loc4_ + 5);
      }
      
      private function setWidthHeightColor(param1:int, param2:int) : void
      {
         var _loc3_:Graphics = graphics;
         _loc3_.clear();
         _loc3_.beginFill(16776960,0);
         _loc3_.drawRect(0,0,param1,param2);
      }
   }
}

