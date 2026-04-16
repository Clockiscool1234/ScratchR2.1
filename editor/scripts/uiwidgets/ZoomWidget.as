package uiwidgets
{
   import flash.display.Sprite;
   
   public class ZoomWidget extends Sprite
   {
      
      private var scriptsPane:ScriptsPane;
      
      private var zoom:int;
      
      private var smaller:IconButton;
      
      private var normal:IconButton;
      
      private var bigger:IconButton;
      
      public function ZoomWidget(param1:ScriptsPane)
      {
         super();
         this.scriptsPane = param1;
         addChild(this.smaller = new IconButton(this.zoomOut,"zoomOut"));
         addChild(this.normal = new IconButton(this.noZoom,"noZoom"));
         addChild(this.bigger = new IconButton(this.zoomIn,"zoomIn"));
         this.smaller.x = 0;
         this.normal.x = 24;
         this.bigger.x = 48;
         this.smaller.isMomentary = true;
         this.normal.isMomentary = true;
         this.bigger.isMomentary = true;
      }
      
      private function zoomOut(param1:IconButton) : void
      {
         this.changeZoomBy(-1);
      }
      
      private function noZoom(param1:IconButton) : void
      {
         this.zoom = 0;
         this.changeZoomBy(0);
      }
      
      private function zoomIn(param1:IconButton) : void
      {
         this.changeZoomBy(1);
      }
      
      private function changeZoomBy(param1:int) : void
      {
         var _loc2_:Array = [25,50,75,100,125,150,200];
         this.zoom += param1;
         this.zoom = Math.max(-3,Math.min(this.zoom,3));
         this.smaller.setDisabled(this.zoom < -2,0.5);
         this.bigger.setDisabled(this.zoom > 2,0.5);
         this.scriptsPane.setScale(_loc2_[3 + this.zoom] / 100);
      }
   }
}

