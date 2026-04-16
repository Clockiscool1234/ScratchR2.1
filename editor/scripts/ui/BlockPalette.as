package ui
{
   import blocks.Block;
   import interpreter.Interpreter;
   import scratch.ScratchComment;
   import scratch.ScratchObj;
   import uiwidgets.ScrollFrameContents;
   
   public class BlockPalette extends ScrollFrameContents
   {
      
      public const isBlockPalette:Boolean = true;
      
      public function BlockPalette()
      {
         super();
         this.color = 14737632;
      }
      
      public static function strings() : Array
      {
         return ["Cannot Delete","To delete a block definition, first remove all uses of the block."];
      }
      
      override public function clear(param1:Boolean = true) : void
      {
         var _loc4_:Block = null;
         var _loc2_:Interpreter = Scratch.app.interp;
         var _loc3_:ScratchObj = Scratch.app.viewedObj();
         while(numChildren > 0)
         {
            _loc4_ = getChildAt(0) as Block;
            if(_loc2_.isRunning(_loc4_,_loc3_))
            {
               _loc2_.toggleThread(_loc4_,_loc3_);
            }
            removeChildAt(0);
         }
         if(param1)
         {
            x = y = 0;
         }
      }
      
      public function handleDrop(param1:*) : Boolean
      {
         var _loc2_:ScratchComment = param1 as ScratchComment;
         if(_loc2_)
         {
            _loc2_.x = _loc2_.y = 20;
            _loc2_.deleteComment();
            return true;
         }
         var _loc3_:Block = param1 as Block;
         if(_loc3_)
         {
            return _loc3_.deleteStack();
         }
         return false;
      }
   }
}

