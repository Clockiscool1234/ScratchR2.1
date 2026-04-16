package svgeditor.objs
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import svgutils.SVGElement;
   
   public class SVGBitmap extends Bitmap implements ISVGEditable
   {
      
      private var element:SVGElement;
      
      public function SVGBitmap(param1:SVGElement, param2:BitmapData = null)
      {
         this.element = param1;
         super(param2);
      }
      
      public function getElement() : SVGElement
      {
         this.element.transform = transform.matrix;
         return this.element;
      }
      
      public function redraw(param1:Boolean = false) : void
      {
         this.element.renderImageOn(this);
      }
      
      public function clone() : ISVGEditable
      {
         var _loc1_:ISVGEditable = new SVGBitmap(this.element.clone(),bitmapData);
         (_loc1_ as DisplayObject).transform.matrix = transform.matrix.clone();
         _loc1_.redraw();
         return _loc1_;
      }
   }
}

