package ui
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.media.Camera;
   import flash.media.Video;
   import translation.Translator;
   import uiwidgets.Button;
   import uiwidgets.DialogBox;
   
   public class CameraDialog extends DialogBox
   {
      
      private var saveFunc:Function;
      
      private var picture:Bitmap;
      
      private var video:Video;
      
      public function CameraDialog(param1:Function)
      {
         var _loc3_:Button = null;
         super();
         this.saveFunc = param1;
         addTitle(Translator.map("Camera"));
         var _loc2_:Sprite = new Sprite();
         addWidget(_loc2_);
         this.picture = new Bitmap();
         this.picture.bitmapData = new BitmapData(320,240,true);
         this.picture.visible = false;
         _loc2_.addChild(this.picture);
         this.video = new Video(320,240);
         this.video.smoothing = true;
         this.video.attachCamera(Camera.getCamera());
         _loc2_.addChild(this.video);
         addChild(_loc3_ = new Button(Translator.map("Save"),this.savePicture));
         buttons.push(_loc3_);
         addChild(_loc3_ = new Button(Translator.map("Close"),this.closeDialog));
         buttons.push(_loc3_);
      }
      
      public static function strings() : Array
      {
         return ["Camera","Save","Close"];
      }
      
      private function savePicture() : void
      {
         this.picture.bitmapData.draw(this.video);
         if(this.saveFunc != null)
         {
            this.saveFunc(this.picture.bitmapData.clone());
         }
      }
      
      public function closeDialog() : void
      {
         if(this.video)
         {
            this.video.attachCamera(null);
         }
         if(parent)
         {
            parent.removeChild(this);
         }
      }
   }
}

