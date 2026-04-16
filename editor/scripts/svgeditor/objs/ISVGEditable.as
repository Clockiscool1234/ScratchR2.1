package svgeditor.objs
{
   import svgutils.SVGElement;
   
   public interface ISVGEditable
   {
      
      function getElement() : SVGElement;
      
      function redraw(param1:Boolean = false) : void;
      
      function clone() : ISVGEditable;
   }
}

