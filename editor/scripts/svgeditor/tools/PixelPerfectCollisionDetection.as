package svgeditor.tools
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.BlendMode;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class PixelPerfectCollisionDetection
   {
      
      public function PixelPerfectCollisionDetection()
      {
         super();
      }
      
      public static function isColliding(param1:DisplayObject, param2:DisplayObject, param3:Boolean = false, param4:Sprite = null) : Boolean
      {
         var _loc5_:Rectangle = areaOfCollision(param1,param2,param3,param4);
         if(_loc5_ != null && _loc5_.size.length > 0)
         {
            return true;
         }
         return false;
      }
      
      public static function areaOfCollision(param1:DisplayObject, param2:DisplayObject, param3:Boolean = false, param4:Sprite = null) : Rectangle
      {
         var _loc5_:Rectangle = null;
         var _loc6_:Rectangle = null;
         var _loc7_:Rectangle = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:BitmapData = null;
         var _loc11_:Matrix = null;
         var _loc12_:BitmapData = null;
         var _loc13_:BitmapData = null;
         var _loc14_:Rectangle = null;
         var _loc15_:int = 0;
         var _loc16_:Bitmap = null;
         if(param1.hitTestObject(param2))
         {
            _loc5_ = param1.getBounds(param1.stage);
            _loc6_ = param2.getBounds(param2.stage);
            _loc7_ = _loc5_.intersection(_loc6_);
            _loc7_.x = Math.floor(_loc7_.x);
            _loc7_.y = Math.floor(_loc7_.y);
            _loc7_.width = Math.ceil(_loc7_.width);
            _loc7_.height = Math.ceil(_loc7_.height);
            if(_loc7_.width < 1 || _loc7_.height < 1)
            {
               return null;
            }
            _loc8_ = 1;
            _loc9_ = 1;
            if(_loc7_.width < 20)
            {
               _loc8_ = Math.floor(20 / _loc7_.width);
               _loc15_ = _loc7_.width;
               _loc7_.width *= _loc8_;
            }
            if(_loc7_.height < 20)
            {
               _loc9_ = Math.floor(20 / _loc7_.height);
               _loc7_.height *= _loc9_;
            }
            _loc10_ = new BitmapData(_loc7_.width,_loc7_.height,true);
            _loc10_.fillRect(_loc10_.rect,0);
            _loc11_ = param1.transform.concatenatedMatrix.clone();
            _loc11_.translate(-_loc7_.left,-_loc7_.top);
            _loc11_.scale(_loc8_,_loc9_);
            _loc10_.draw(param1,_loc11_,null,null,null,param3);
            _loc12_ = new BitmapData(_loc7_.width,_loc7_.height,false,0);
            _loc12_.copyChannel(_loc10_,_loc10_.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.RED);
            _loc10_.fillRect(_loc10_.rect,0);
            _loc11_ = param2.transform.concatenatedMatrix.clone();
            _loc11_.translate(-_loc7_.left,-_loc7_.top);
            _loc11_.scale(_loc8_,_loc9_);
            _loc10_.draw(param2,_loc11_,null,null,null,param3);
            _loc13_ = new BitmapData(_loc7_.width,_loc7_.height,false,0);
            _loc13_.copyChannel(_loc10_,_loc10_.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.GREEN);
            _loc12_.draw(_loc13_,null,null,BlendMode.LIGHTEN);
            _loc14_ = param3 ? _loc12_.getColorBoundsRect(65792,65792) : _loc12_.getColorBoundsRect(460544,460544);
            if(param4)
            {
               if(param4.width > param4.stage.stageWidth)
               {
                  while(param4.numChildren)
                  {
                     param4.removeChildAt(0);
                  }
               }
               _loc16_ = new Bitmap(_loc12_);
               _loc16_.alpha = _loc14_.width == 0 ? 0.5 : 1;
               _loc16_.x = param4.width + 2;
               param4.addChild(_loc16_);
            }
            if(_loc14_.width == 0)
            {
               return null;
            }
            _loc14_.offset(_loc7_.left,_loc7_.top);
            return _loc14_;
         }
         return null;
      }
   }
}

