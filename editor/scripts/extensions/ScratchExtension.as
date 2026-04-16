package extensions
{
   import flash.utils.Dictionary;
   
   public class ScratchExtension
   {
      
      public var name:String = "";
      
      private var _displayName:String = "";
      
      public var host:String = "127.0.0.1";
      
      public var port:int = 0;
      
      public var id:uint = 0;
      
      public var blockSpecs:Array = [];
      
      public var isInternal:Boolean;
      
      public var useScratchPrimitives:Boolean;
      
      public var showBlocks:Boolean;
      
      public var menus:Object = {};
      
      public var thumbnailMD5:String = "";
      
      public var url:String = "";
      
      public var javascriptURL:String = "";
      
      public var tags:Array = [];
      
      public var stateVars:Object = {};
      
      public var lastPollResponseTime:int;
      
      public var problem:String = "";
      
      public var success:String = "Okay";
      
      public var nextID:int;
      
      public var busy:Array = [];
      
      public var waiting:Dictionary = new Dictionary(true);
      
      public function ScratchExtension(param1:String, param2:int)
      {
         super();
         this.name = param1;
         this.port = param2;
      }
      
      public static function PicoBoard() : ScratchExtension
      {
         var _loc1_:ScratchExtension = new ScratchExtension(ExtensionManager.picoBoardExt,0);
         _loc1_.isInternal = true;
         _loc1_.javascriptURL = Scratch.app.server.getOfficialExtensionURL("picoExtension.js");
         _loc1_.thumbnailMD5 = "82318df0f682b1de33f64da8726660dc.png";
         _loc1_.url = "http://wiki.scratch.mit.edu/wiki/PicoBoard_Blocks";
         _loc1_.tags = ["hardware"];
         return _loc1_;
      }
      
      public static function WeDo() : ScratchExtension
      {
         var _loc1_:ScratchExtension = new ScratchExtension(ExtensionManager.wedoExt,0);
         _loc1_.isInternal = true;
         _loc1_.javascriptURL = Scratch.app.server.getOfficialExtensionURL("wedoExtension.js");
         _loc1_.thumbnailMD5 = "9e5933c3b8b76596d1f889d44d3715a1.png";
         _loc1_.url = "http://wiki.scratch.mit.edu/wiki/LEGO_WeDo_Blocks";
         _loc1_.tags = ["hardware"];
         _loc1_.displayName = "LEGO WeDo 1.0";
         return _loc1_;
      }
      
      public static function WeDo2() : ScratchExtension
      {
         var _loc1_:ScratchExtension = new ScratchExtension(ExtensionManager.wedo2Ext,0);
         _loc1_.isInternal = true;
         _loc1_.javascriptURL = Scratch.app.server.getOfficialExtensionURL("wedo2Extension.js");
         _loc1_.thumbnailMD5 = "c14047e09787cd75a2bc6aba68ceb0de.png";
         _loc1_.url = "howto/wedo2setup-intro.html";
         _loc1_.tags = ["hardware"];
         return _loc1_;
      }
      
      public function get displayName() : String
      {
         return this._displayName ? this._displayName : this.name;
      }
      
      public function set displayName(param1:String) : void
      {
         this._displayName = param1;
      }
   }
}

