package svgeditor.objs
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import svgutils.SVGElement;
   
   public class SVGGroup extends Sprite implements ISVGEditable
   {
      
      private var element:SVGElement;
      
      public function SVGGroup(param1:SVGElement)
      {
         super();
         this.element = param1;
      }
      
      public function getElement() : SVGElement
      {
         this.element.subElements = this.getSubElements();
         this.element.transform = transform.matrix;
         return this.element;
      }
      
      public function redraw(param1:Boolean = false) : void
      {
         var _loc3_:DisplayObject = null;
         if(this.element.transform)
         {
            transform.matrix = this.element.transform;
         }
         var _loc2_:uint = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ is ISVGEditable)
            {
               (_loc3_ as ISVGEditable).redraw();
            }
            _loc2_++;
         }
      }
      
      private function getSubElements() : Array
      {
         var _loc3_:DisplayObject = null;
         var _loc1_:Array = [];
         var _loc2_:uint = 0;
         while(_loc2_ < numChildren)
         {
            _loc3_ = getChildAt(_loc2_);
            if(_loc3_ is ISVGEditable)
            {
               _loc1_.push((_loc3_ as ISVGEditable).getElement());
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function clone() : ISVGEditable
      {
         var _loc4_:DisplayObject = null;
         var _loc1_:SVGGroup = new SVGGroup(this.element.clone());
         (_loc1_ as DisplayObject).transform.matrix = transform.matrix.clone();
         var _loc2_:Array = [];
         var _loc3_:uint = 0;
         while(_loc3_ < numChildren)
         {
            _loc4_ = getChildAt(_loc3_);
            if(_loc4_ is ISVGEditable)
            {
               _loc1_.addChild((_loc4_ as ISVGEditable).clone() as DisplayObject);
            }
            _loc3_++;
         }
         _loc1_.redraw();
         return _loc1_;
      }
   }
}

