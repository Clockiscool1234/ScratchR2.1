package svgeditor.objs
{
   import flash.geom.Point;
   
   public class PathDrawContext
   {
      
      public var cmds:Array;
      
      public var acurve:Boolean;
      
      public var lastcxy:Point;
      
      public var adjust:Boolean;
      
      public function PathDrawContext()
      {
         super();
         this.cmds = new Array();
         this.acurve = false;
         this.adjust = false;
      }
   }
}

