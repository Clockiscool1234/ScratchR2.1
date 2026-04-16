package svgeditor.tools
{
   import flash.display.DisplayObject;
   import flash.geom.Point;
   import svgeditor.DrawProperties;
   import svgeditor.ImageEdit;
   import svgeditor.objs.SVGShape;
   import svgutils.SVGElement;
   
   public final class EllipseTool extends SVGCreateTool
   {
      
      private var createOrigin:Point;
      
      private var newElement:SVGElement;
      
      public function EllipseTool(param1:ImageEdit)
      {
         super(param1);
         this.createOrigin = null;
         this.newElement = null;
      }
      
      override protected function mouseDown(param1:Point) : void
      {
         var _loc2_:DrawProperties = editor.getShapeProps();
         if(_loc2_.alpha == 0)
         {
            return;
         }
         this.createOrigin = param1;
         this.newElement = new SVGElement("ellipse",null);
         this.newElement.setAttribute("cx",contentLayer.mouseX);
         this.newElement.setAttribute("cy",contentLayer.mouseY);
         if(_loc2_.filledShape)
         {
            this.newElement.setShapeFill(_loc2_);
            this.newElement.setAttribute("stroke","none");
         }
         else
         {
            this.newElement.setShapeStroke(_loc2_);
            this.newElement.setAttribute("fill","none");
         }
         newObject = new SVGShape(this.newElement);
         contentLayer.addChild(newObject as DisplayObject);
      }
      
      override protected function mouseMove(param1:Point) : void
      {
         if(!this.createOrigin)
         {
            return;
         }
         var _loc2_:Point = this.createOrigin.subtract(param1);
         var _loc3_:Number = Math.abs(_loc2_.x);
         var _loc4_:Number = Math.abs(_loc2_.y);
         if(currentEvent.shiftKey)
         {
            _loc3_ = _loc4_ = Math.max(_loc3_,_loc4_);
            param1.x = this.createOrigin.x + (_loc2_.x < 0 ? _loc3_ : -_loc3_);
            param1.y = this.createOrigin.y + (_loc2_.y < 0 ? _loc4_ : -_loc4_);
         }
         var _loc5_:Number = _loc3_ / 2;
         var _loc6_:Number = _loc4_ / 2;
         this.newElement.setAttribute("cx",Math.min(param1.x,this.createOrigin.x) + _loc5_);
         this.newElement.setAttribute("cy",Math.min(param1.y,this.createOrigin.y) + _loc6_);
         this.newElement.setAttribute("rx",_loc5_);
         this.newElement.setAttribute("ry",_loc6_);
         this.newElement.updatePath();
         newObject.redraw();
      }
   }
}

