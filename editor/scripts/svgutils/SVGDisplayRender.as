package svgutils
{
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   
   public class SVGDisplayRender
   {
      
      private var svgSprite:Sprite;
      
      private var currentShape:Shape;
      
      private var forHitTest:Boolean;
      
      public function SVGDisplayRender()
      {
         super();
      }
      
      public function renderAsSprite(param1:SVGElement, param2:Boolean = false, param3:Boolean = false) : Sprite
      {
         var _loc4_:SVGElement = null;
         var _loc5_:Rectangle = null;
         var _loc6_:int = 0;
         var _loc7_:DisplayObject = null;
         this.forHitTest = param3;
         this.svgSprite = new Sprite();
         if(!param1)
         {
            return this.svgSprite;
         }
         for each(_loc4_ in param1.allElements())
         {
            this.renderElement(_loc4_);
         }
         if(this.currentShape)
         {
            this.svgSprite.addChild(this.currentShape);
         }
         if(param2)
         {
            _loc5_ = this.svgSprite.getBounds(this.svgSprite);
            if(_loc5_.x != 0 || _loc5_.y != 0)
            {
               _loc6_ = 0;
               while(_loc6_ < this.svgSprite.numChildren)
               {
                  _loc7_ = this.svgSprite.getChildAt(_loc6_);
                  _loc7_.x += -_loc5_.x;
                  _loc7_.y += -_loc5_.y;
                  _loc6_++;
               }
            }
         }
         return this.svgSprite;
      }
      
      private function renderElement(param1:SVGElement) : void
      {
         var _loc2_:Bitmap = null;
         var _loc3_:TextField = null;
         var _loc4_:Shape = null;
         if("image" == param1.tag)
         {
            _loc2_ = new Bitmap();
            param1.renderImageOn(_loc2_);
            this.addLayer(_loc2_);
         }
         else if("text" == param1.tag)
         {
            _loc3_ = new TextField();
            _loc3_.selectable = false;
            _loc3_.mouseEnabled = false;
            _loc3_.tabEnabled = false;
            param1.renderTextOn(_loc3_);
            this.addLayer(_loc3_);
         }
         else if(param1.path)
         {
            _loc4_ = new Shape();
            param1.renderPathOn(_loc4_,this.forHitTest);
            if(param1.transform)
            {
               _loc4_.transform.matrix = param1.transform;
            }
            this.addLayer(_loc4_);
         }
      }
      
      private function addLayer(param1:DisplayObject) : void
      {
         if(this.currentShape)
         {
            this.svgSprite.addChild(this.currentShape);
            this.currentShape = null;
         }
         this.svgSprite.addChild(param1);
      }
   }
}

