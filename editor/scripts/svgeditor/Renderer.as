package svgeditor
{
   import flash.display.Sprite;
   import svgeditor.objs.SVGBitmap;
   import svgeditor.objs.SVGGroup;
   import svgeditor.objs.SVGShape;
   import svgeditor.objs.SVGTextField;
   import svgutils.SVGElement;
   
   public class Renderer
   {
      
      public function Renderer()
      {
         super();
      }
      
      public static function renderToSprite(param1:Sprite, param2:SVGElement) : void
      {
         var _loc3_:SVGElement = null;
         if(!param2)
         {
            return;
         }
         for each(_loc3_ in param2.subElements)
         {
            appendElementToSprite(_loc3_,param1);
         }
      }
      
      private static function appendElementToSprite(param1:SVGElement, param2:Sprite) : void
      {
         var _loc3_:SVGGroup = null;
         var _loc4_:SVGBitmap = null;
         var _loc5_:SVGTextField = null;
         var _loc6_:SVGShape = null;
         if("g" == param1.tag)
         {
            _loc3_ = new SVGGroup(param1);
            renderToSprite(_loc3_,param1);
            if(param1.transform)
            {
               _loc3_.transform.matrix = param1.transform;
            }
            param2.addChild(_loc3_);
         }
         else if("image" == param1.tag)
         {
            _loc4_ = new SVGBitmap(param1);
            _loc4_.redraw();
            if(param1.transform)
            {
               _loc4_.transform.matrix = param1.transform;
            }
            param2.addChild(_loc4_);
         }
         else if("text" == param1.tag)
         {
            _loc5_ = new SVGTextField(param1);
            _loc5_.selectable = false;
            param1.renderTextOn(_loc5_);
            if(param1.transform)
            {
               _loc5_.transform.matrix = param1.transform;
            }
            param2.addChild(_loc5_);
         }
         else if(param1.path)
         {
            _loc6_ = new SVGShape(param1);
            _loc6_.redraw();
            if(param1.transform)
            {
               _loc6_.transform.matrix = param1.transform;
            }
            param2.addChild(_loc6_);
         }
      }
   }
}

