package svgeditor.objs
{
   import flash.text.AntiAliasType;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import svgutils.SVGElement;
   
   public class SVGTextField extends TextField implements ISVGEditable
   {
      
      private var element:SVGElement;
      
      private var _editable:Boolean;
      
      public function SVGTextField(param1:SVGElement)
      {
         super();
         this.element = param1;
         if(this.element.text == null)
         {
            this.element.text = "";
         }
         this._editable = false;
         antiAliasType = AntiAliasType.ADVANCED;
         cacheAsBitmap = true;
         embedFonts = true;
         backgroundColor = 16777215;
         multiline = true;
      }
      
      public function getElement() : SVGElement
      {
         this.element.transform = transform.matrix.clone();
         return this.element;
      }
      
      public function redraw(param1:Boolean = false) : void
      {
         var _loc2_:Boolean = type == TextFieldType.INPUT && this.element.text.length < 4;
         var _loc3_:String = this.element.text;
         if(this.element.text == "")
         {
            this.element.text = " ";
         }
         this.element.renderTextOn(this);
         this.element.text = _loc3_;
         if(_loc2_)
         {
            width += 25;
         }
      }
      
      public function clone() : ISVGEditable
      {
         var _loc1_:SVGTextField = new SVGTextField(this.element.clone());
         _loc1_.transform.matrix = transform.matrix.clone();
         _loc1_.selectable = false;
         _loc1_.redraw();
         return _loc1_ as ISVGEditable;
      }
   }
}

