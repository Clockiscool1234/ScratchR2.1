package interpreter
{
   import util.JSON;
   
   public class Variable
   {
      
      public var name:String;
      
      public var value:*;
      
      public var watcher:*;
      
      public var isPersistent:Boolean;
      
      public function Variable(param1:String, param2:*)
      {
         super();
         this.name = param1;
         this.value = param2;
      }
      
      public function writeJSON(param1:util.JSON) : void
      {
         param1.writeKeyValue("name",this.name);
         param1.writeKeyValue("value",this.value);
         param1.writeKeyValue("isPersistent",this.isPersistent);
      }
   }
}

