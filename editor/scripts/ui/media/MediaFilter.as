package ui.media
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.text.*;
   import translation.Translator;
   
   public class MediaFilter extends Sprite
   {
      
      private const titleFormat:TextFormat;
      
      private const selectorFormat:TextFormat;
      
      private const unselectedColor:int;
      
      private const selectedColor:int;
      
      private const rolloverColor:int;
      
      private var title:TextField;
      
      private var selectorNames:Array;
      
      private var selectors:Array;
      
      private var selection:String = "";
      
      private var whenChanged:Function;
      
      public function MediaFilter(param1:String, param2:Array, param3:Function = null)
      {
         var _loc4_:String = null;
         this.titleFormat = new TextFormat(CSS.font,15,CSS.buttonLabelOverColor,false);
         this.selectorFormat = new TextFormat(CSS.font,14,CSS.textColor);
         this.unselectedColor = CSS.overColor;
         this.selectedColor = CSS.textColor;
         this.rolloverColor = CSS.buttonLabelOverColor;
         this.selectorNames = [];
         this.selectors = [];
         super();
         addChild(this.title = Resources.makeLabel(Translator.map(param1),this.titleFormat));
         this.whenChanged = param3;
         for each(_loc4_ in param2)
         {
            this.addSelector(_loc4_);
         }
         this.select(0);
         this.fixLayout();
      }
      
      public function set currentSelection(param1:String) : void
      {
         this.select(this.selectorNames.indexOf(param1));
      }
      
      public function get currentSelection() : String
      {
         return this.selection;
      }
      
      private function fixLayout() : void
      {
         var _loc2_:TextField = null;
         this.title.x = this.title.y = 0;
         var _loc1_:int = this.title.height + 2;
         for each(_loc2_ in this.selectors)
         {
            _loc2_.x = 15;
            _loc2_.y = _loc1_;
            _loc1_ += _loc2_.height;
         }
      }
      
      private function addSelectors(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            this.addSelector(_loc2_);
         }
      }
      
      private function addSelector(param1:String) : void
      {
         var mouseDown:Function = null;
         var sel:TextField = null;
         var selName:String = param1;
         mouseDown = function(param1:*):void
         {
            select(selectorNames.indexOf(selName));
            if(whenChanged != null)
            {
               whenChanged(sel.parent);
            }
         };
         sel = Resources.makeLabel(Translator.map(selName),this.selectorFormat);
         sel.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOver);
         sel.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOver);
         sel.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown);
         this.selectorNames.push(selName);
         this.selectors.push(sel);
         addChild(sel);
      }
      
      private function mouseOver(param1:MouseEvent) : void
      {
         var _loc2_:TextField = param1.target as TextField;
         if(_loc2_.textColor != this.selectedColor)
         {
            _loc2_.textColor = param1.type == MouseEvent.MOUSE_OVER ? uint(this.rolloverColor) : uint(this.unselectedColor);
         }
      }
      
      private function select(param1:int) : void
      {
         this.selection = "";
         var _loc2_:TextFormat = new TextFormat();
         var _loc3_:int = 0;
         while(_loc3_ < this.selectors.length)
         {
            if(_loc3_ == param1)
            {
               this.selection = this.selectorNames[_loc3_];
               _loc2_.bold = true;
               this.selectors[_loc3_].setTextFormat(_loc2_);
               this.selectors[_loc3_].textColor = this.selectedColor;
            }
            else
            {
               _loc2_.bold = false;
               this.selectors[_loc3_].setTextFormat(_loc2_);
               this.selectors[_loc3_].textColor = this.unselectedColor;
            }
            _loc3_++;
         }
      }
   }
}

