package svgeditor.tools
{
   import flash.events.Event;
   import flash.events.MouseEvent;
   import svgeditor.ImageEdit;
   import svgeditor.Selection;
   import svgeditor.objs.ISVGEditable;
   
   public class SVGEditTool extends SVGTool
   {
      
      protected var object:ISVGEditable;
      
      private var editTag:Array;
      
      public function SVGEditTool(param1:ImageEdit, param2:* = null)
      {
         super(param1);
         touchesContent = true;
         this.object = null;
         this.editTag = param2 is String ? [param2] : param2;
      }
      
      public function editSelection(param1:Selection) : void
      {
         if(Boolean(param1) && param1.getObjs().length == 1)
         {
            this.setObject(param1.getObjs()[0] as ISVGEditable);
         }
      }
      
      public function setObject(param1:ISVGEditable) : void
      {
         this.edit(param1,null);
      }
      
      public function getObject() : ISVGEditable
      {
         return this.object;
      }
      
      protected function edit(param1:ISVGEditable, param2:MouseEvent) : void
      {
         if(param1 == this.object)
         {
            return;
         }
         if(!this.object)
         {
         }
         if(Boolean(param1) && (!this.editTag || this.editTag.indexOf(param1.getElement().tag) > -1))
         {
            this.object = param1;
            if(!this.object)
            {
            }
         }
         else
         {
            this.object = null;
         }
         dispatchEvent(new Event("select"));
      }
      
      override protected function init() : void
      {
         super.init();
         editor.getContentLayer().addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown,false,0,true);
      }
      
      override protected function shutdown() : void
      {
         editor.getContentLayer().removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
         super.shutdown();
         if(this.object)
         {
            this.setObject(null);
         }
      }
      
      public function mouseDown(param1:MouseEvent) : void
      {
         var _loc2_:ISVGEditable = getEditableUnderMouse(!(this is PathEditTool));
         currentEvent = param1;
         this.edit(_loc2_,param1);
         currentEvent = null;
         param1.stopPropagation();
      }
   }
}

