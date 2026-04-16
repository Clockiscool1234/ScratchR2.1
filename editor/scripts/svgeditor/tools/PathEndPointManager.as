package svgeditor.tools
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.geom.Point;
   import svgeditor.ImageEdit;
   import svgeditor.objs.ISVGEditable;
   import svgeditor.objs.SVGGroup;
   import svgeditor.objs.SVGShape;
   import svgutils.SVGPath;
   
   public final class PathEndPointManager
   {
      
      private static var orb:Sprite;
      
      private static var endPoints:Array;
      
      private static var editor:ImageEdit;
      
      private static var toolsLayer:Sprite;
      
      public function PathEndPointManager()
      {
         super();
      }
      
      public static function init(param1:ImageEdit) : void
      {
         editor = param1;
         orb = new Sprite();
         orb.visible = false;
         orb.mouseEnabled = false;
         orb.mouseChildren = false;
         PathAnchorPoint.render(orb.graphics);
      }
      
      public static function updateOrb(param1:Boolean, param2:Point = null) : void
      {
         orb.visible = true;
         if(param2)
         {
            orb.x = param2.x;
            orb.y = param2.y;
         }
         PathAnchorPoint.render(orb.graphics,param1);
      }
      
      public static function toggleEndPoint(param1:Boolean, param2:Point = null) : void
      {
         orb.visible = param1;
         if(param1)
         {
            orb.x = param2.x;
            orb.y = param2.y;
            PathAnchorPoint.render(orb.graphics,false);
         }
         if(param1 && !orb.parent)
         {
            toolsLayer.addChildAt(orb,0);
         }
         else if(!param1 && Boolean(orb.parent))
         {
            toolsLayer.removeChild(orb);
         }
      }
      
      public static function makeEndPoints(param1:DisplayObject = null) : void
      {
         var _loc2_:Sprite = null;
         toolsLayer = editor.getToolsLayer();
         removeEndPoints();
         endPoints = [];
         editor.getToolsLayer().mouseEnabled = false;
         var _loc3_:DisplayObject = null;
         if(param1 is Sprite)
         {
            _loc2_ = param1 as Sprite;
         }
         else if(param1 is ISVGEditable)
         {
            _loc2_ = param1.parent as Sprite;
            _loc3_ = param1;
         }
         else
         {
            _loc2_ = editor.getContentLayer();
         }
         findEndPoints(_loc2_,_loc3_);
      }
      
      public static function removeEndPoints() : void
      {
         var _loc1_:PathEndPoint = null;
         for each(_loc1_ in endPoints)
         {
            if(_loc1_.parent == toolsLayer)
            {
               toolsLayer.removeChild(_loc1_);
            }
         }
         endPoints = null;
         editor.getToolsLayer().mouseEnabled = true;
      }
      
      private static function findEndPoints(param1:Sprite, param2:DisplayObject = null) : void
      {
         var _loc4_:* = undefined;
         var _loc5_:SVGShape = null;
         var _loc6_:SVGPath = null;
         var _loc7_:Array = null;
         var _loc8_:Point = null;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is SVGGroup)
            {
               findEndPoints(_loc4_ as Sprite);
            }
            else if(_loc4_ is SVGShape && _loc4_ != param2)
            {
               _loc5_ = _loc4_ as SVGShape;
               if(Boolean(_loc5_.getElement().tag == "path") && Boolean(_loc5_.getElement().path) && !_loc5_.getElement().path.isClosed())
               {
                  _loc6_ = _loc5_.getElement().path;
                  _loc7_ = _loc6_.getSegmentEndPoints(0);
                  if(!_loc7_[2])
                  {
                     _loc8_ = toolsLayer.globalToLocal(_loc5_.localToGlobal(_loc6_.getPos(_loc7_[0])));
                     endPoints.push(toolsLayer.addChild(new PathEndPoint(editor,_loc5_,_loc8_)));
                     _loc8_ = toolsLayer.globalToLocal(_loc5_.localToGlobal(_loc6_.getPos(_loc7_[1])));
                     endPoints.push(toolsLayer.addChild(new PathEndPoint(editor,_loc5_,_loc8_)));
                  }
               }
            }
            _loc3_++;
         }
      }
   }
}

