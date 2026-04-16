package uiwidgets
{
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.utils.Dictionary;
   import util.StringUtils;
   
   public class VariableTextField extends TextField
   {
      
      private var originalText:String;
      
      public function VariableTextField()
      {
         super();
      }
      
      override public function set text(param1:String) : void
      {
         throw Error("Call setText() instead");
      }
      
      public function setText(param1:String, param2:Dictionary = null) : void
      {
         this.originalText = param1;
         this.applyContext(param2);
      }
      
      public function applyContext(param1:Dictionary) : void
      {
         var _loc2_:TextFormat = this.getTextFormat();
         super.text = param1 ? StringUtils.substitute(this.originalText,param1) : this.originalText;
         setTextFormat(_loc2_);
      }
   }
}

