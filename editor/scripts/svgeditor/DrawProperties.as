package svgeditor
{
   public class DrawProperties
   {
      
      public var rawColor:uint = 4278190080;
      
      public var rawSecondColor:uint = 4294967295;
      
      public var smoothness:Number = 1;
      
      private var rawStrokeWidth:Number = 1;
      
      private var rawEraserWidth:Number = 4;
      
      public var fillType:String = "solid";
      
      public var filledShape:Boolean = false;
      
      public var fontName:String = "Helvetica";
      
      public function DrawProperties()
      {
         super();
      }
      
      private static function adjustWidth(param1:int) : int
      {
         if(Boolean(Scratch.app.imagesPart) && Scratch.app.imagesPart.editor is SVGEdit)
         {
            return param1;
         }
         var _loc2_:Number = Math.max(1,Math.round(param1));
         switch(_loc2_)
         {
            case 11:
               return 13;
            case 12:
               return 19;
            case 13:
               return 29;
            case 14:
               return 47;
            case 15:
               return 75;
            default:
               return _loc2_;
         }
      }
      
      public function set color(param1:uint) : void
      {
         this.rawColor = param1;
      }
      
      public function get color() : uint
      {
         return this.rawColor & 0xFFFFFF;
      }
      
      public function get alpha() : Number
      {
         return (this.rawColor >> 24 & 0xFF) / 255;
      }
      
      public function set secondColor(param1:uint) : void
      {
         this.rawSecondColor = param1;
      }
      
      public function get secondColor() : uint
      {
         return this.rawSecondColor & 0xFFFFFF;
      }
      
      public function get secondAlpha() : Number
      {
         return (this.rawSecondColor >> 24 & 0xFF) / 255;
      }
      
      public function set strokeWidth(param1:int) : void
      {
         this.rawStrokeWidth = param1;
      }
      
      public function set eraserWidth(param1:int) : void
      {
         this.rawEraserWidth = param1;
      }
      
      public function get strokeWidth() : int
      {
         return adjustWidth(this.rawStrokeWidth);
      }
      
      public function get eraserWidth() : int
      {
         return adjustWidth(this.rawEraserWidth);
      }
   }
}

