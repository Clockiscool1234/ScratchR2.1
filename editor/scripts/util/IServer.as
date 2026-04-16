package util
{
   import flash.net.URLLoader;
   
   public interface IServer
   {
      
      function getAsset(param1:String, param2:Function) : URLLoader;
      
      function getMediaLibrary(param1:String, param2:Function) : URLLoader;
      
      function getThumbnail(param1:String, param2:int, param3:int, param4:Function) : URLLoader;
      
      function getLanguageList(param1:Function) : void;
      
      function getPOFile(param1:String, param2:Function) : void;
      
      function getSelectedLang(param1:Function) : void;
      
      function setSelectedLang(param1:String) : void;
   }
}

