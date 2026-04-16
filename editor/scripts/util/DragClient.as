package util
{
   import flash.events.MouseEvent;
   
   public interface DragClient
   {
      
      function dragBegin(param1:MouseEvent) : void;
      
      function dragMove(param1:MouseEvent) : void;
      
      function dragEnd(param1:MouseEvent) : void;
   }
}

