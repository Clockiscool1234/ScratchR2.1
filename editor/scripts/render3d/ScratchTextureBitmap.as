package render3d
{
   import flash.display.BitmapData;
   import flash.display3D.*;
   import flash.display3D.textures.Texture;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import org.villekoskela.utils.RectanglePacker;
   
   public class ScratchTextureBitmap extends BitmapData
   {
      
      private static var indexOfIDs:Array;
      
      private var rectPacker:RectanglePacker;
      
      private var texture:Texture;
      
      private var rectangles:Object;
      
      private var dirty:Boolean;
      
      private var tmpPt:Point = new Point();
      
      public function ScratchTextureBitmap(param1:int, param2:int, param3:Boolean = true, param4:uint = 4294967295)
      {
         super(param1,param2,param3,param4);
         this.rectPacker = new RectanglePacker(param1,param2);
         this.rectangles = {};
         this.dirty = false;
      }
      
      public function getTexture(param1:Context3D) : Texture
      {
         if(!this.texture)
         {
            this.texture = param1.createTexture(width,height,Context3DTextureFormat.BGRA,true);
            this.dirty = true;
         }
         if(this.dirty)
         {
            this.texture.uploadFromBitmapData(this);
         }
         this.dirty = false;
         return this.texture;
      }
      
      public function disposeTexture() : void
      {
         if(this.texture)
         {
            this.texture.dispose();
            this.texture = null;
         }
      }
      
      public function packBitmaps(param1:Object) : Array
      {
         var _loc3_:Object = null;
         var _loc4_:Rectangle = null;
         var _loc5_:Matrix = null;
         var _loc6_:Array = null;
         var _loc7_:BitmapData = null;
         var _loc8_:String = null;
         fillRect(this.rect,0);
         this.rectPacker.reset(width,height);
         indexOfIDs = [];
         var _loc2_:uint = 0;
         for(_loc3_ in param1)
         {
            _loc7_ = param1[_loc3_];
            this.rectPacker.insertRectangle(_loc7_.width + 1,_loc7_.height + 1,_loc2_);
            indexOfIDs.push(_loc3_);
            _loc2_++;
         }
         this.rectPacker.packRectangles();
         _loc5_ = new Matrix();
         this.rectangles = {};
         _loc6_ = [];
         _loc2_ = 0;
         while(_loc2_ < this.rectPacker.rectangleCount)
         {
            _loc8_ = indexOfIDs[this.rectPacker.getRectangleId(_loc2_)];
            this.rectangles[_loc8_] = this.rectPacker.getRectangle(_loc2_,null);
            _loc4_ = this.rectangles[_loc8_];
            --_loc4_.width;
            --_loc4_.height;
            _loc4_ = _loc4_.clone();
            this.tmpPt.x = _loc4_.x;
            this.tmpPt.y = _loc4_.y;
            _loc4_.x = _loc4_.y = 0;
            _loc7_ = param1[_loc8_];
            _loc5_.tx = this.tmpPt.x;
            _loc5_.ty = this.tmpPt.y;
            draw(_loc7_,_loc5_);
            if(_loc7_ is ChildRender)
            {
               this.rectangles[_loc8_].width = (_loc7_ as ChildRender).renderWidth;
               this.rectangles[_loc8_].height = (_loc7_ as ChildRender).renderHeight;
            }
            delete param1[_loc8_];
            _loc6_.push(_loc8_);
            _loc2_++;
         }
         this.dirty = true;
         return _loc6_;
      }
      
      public function getRect(param1:String) : Rectangle
      {
         return this.rectangles[param1];
      }
      
      public function updateBitmap(param1:String, param2:BitmapData) : void
      {
         var _loc3_:Rectangle = this.rectangles[param1];
         if(!_loc3_)
         {
            throw new Error("bitmap id not found");
         }
         if(Math.ceil(_loc3_.width) != param2.width || Math.ceil(_loc3_.height) != param2.height)
         {
            throw new Error("bitmap dimensions don\'t match existing rectangle");
         }
         _loc3_ = _loc3_.clone();
         this.tmpPt.x = _loc3_.x;
         this.tmpPt.y = _loc3_.y;
         _loc3_.x = _loc3_.y = 0;
         copyPixels(param2,_loc3_,this.tmpPt,null,null,false);
         this.dirty = true;
      }
   }
}

import flash.utils.getQualifiedClassName;

final class Dbg
{
   
   public function Dbg()
   {
      super();
   }
   
   public static function printObj(param1:*) : String
   {
      var memoryHash:String = null;
      var obj:* = param1;
      try
      {
         FakeClass(obj);
      }
      catch(e:Error)
      {
         memoryHash = String(e).replace(/.*([@|\$].*?) to .*$/gi,"$1");
      }
      return getQualifiedClassName(obj) + memoryHash;
   }
}

final class FakeClass
{
   
   public function FakeClass()
   {
      super();
   }
}
