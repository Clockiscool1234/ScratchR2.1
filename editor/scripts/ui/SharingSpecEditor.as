package ui
{
   import assets.Resources;
   import blocks.Block;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.TextEvent;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFieldType;
   import flash.text.TextFormat;
   import translation.Translator;
   import uiwidgets.DialogBox;
   import util.ReadStream;
   
   public class SharingSpecEditor extends Sprite
   {
      
      private var base:Shape;
      
      private var row:Array = [];
      
      private var playLabel:TextField;
      
      private var linkLabel:TextField;
      
      private var faqLabel:TextField;
      
      private var shareLabel:TextField;
      
      private var shareImage:DisplayObject;
      
      private var toggleOn:Boolean;
      
      private var slotColor:int = 12303807;
      
      private const labelColor:int = 8861887;
      
      public function SharingSpecEditor()
      {
         super();
         addChild(this.base = new Shape());
         this.setWidthHeight(400,260);
         addChild(this.playLabel = this.makeLabel("To play your video, download and install the",14));
         addChild(this.linkLabel = this.makeLinkLabel("VLC media player.",14,"http://www.videolan.org/vlc/index.html"));
         addChild(this.faqLabel = this.makeLinkLabel("Questions?",14,"https://scratch.mit.edu/info/faq/"));
         addChild(this.shareLabel = this.makeLabel("You can also share your video with others to let them see it!",14));
         addChild(this.shareImage = Resources.createDO("videoShare"));
         var _loc1_:Number = 160 / this.shareImage.width * this.shareImage.height;
         this.shareImage.width = 160;
         this.shareImage.height = _loc1_;
         this.fixLayout();
      }
      
      private function setWidthHeight(param1:int, param2:int) : void
      {
         var _loc3_:Graphics = this.base.graphics;
         _loc3_.clear();
         _loc3_.beginFill(CSS.white);
         _loc3_.drawRect(0,0,param1,param2);
         _loc3_.endFill();
      }
      
      public function spec() : String
      {
         var _loc2_:* = undefined;
         var _loc1_:String = "";
         for each(_loc2_ in this.row)
         {
            if(_loc2_ is TextField)
            {
               _loc1_ += ReadStream.escape(TextField(_loc2_).text);
            }
            if(_loc1_.length > 0 && _loc1_.charAt(_loc1_.length - 1) != " ")
            {
               _loc1_ += " ";
            }
         }
         if(_loc1_.length > 0 && _loc1_.charAt(_loc1_.length - 1) == " ")
         {
            _loc1_ = _loc1_.slice(0,_loc1_.length - 1);
         }
         return _loc1_;
      }
      
      private function makeLabel(param1:String, param2:int, param3:Boolean = false) : TextField
      {
         var _loc4_:TextField = new TextField();
         _loc4_.selectable = false;
         _loc4_.defaultTextFormat = new TextFormat(CSS.font,param2,CSS.textColor,param3);
         _loc4_.autoSize = TextFieldAutoSize.LEFT;
         _loc4_.text = Translator.map(param1);
         addChild(_loc4_);
         return _loc4_;
      }
      
      private function makeLinkLabel(param1:String, param2:int, param3:String = "") : TextField
      {
         var linkClicked:Function = null;
         var s:String = param1;
         var fontSize:int = param2;
         var linkUrl:String = param3;
         linkClicked = function(param1:TextEvent):void
         {
            navigateToURL(new URLRequest(param1.text),"_blank");
         };
         var tf:TextField = new TextField();
         tf.selectable = false;
         tf.defaultTextFormat = new TextFormat(CSS.font,fontSize,CSS.overColor);
         tf.autoSize = TextFieldAutoSize.LEFT;
         tf.htmlText = "<a href=\"event:" + linkUrl + "\">" + Translator.map(s) + "</a>";
         addChild(tf);
         tf.addEventListener(TextEvent.LINK,linkClicked);
         return tf;
      }
      
      private function appendObj(param1:DisplayObject) : void
      {
         this.row.push(param1);
         addChild(param1);
         if(stage)
         {
            if(param1 is TextField)
            {
               stage.focus = TextField(param1);
            }
         }
         this.fixLayout();
      }
      
      private function makeTextField(param1:String) : TextField
      {
         var _loc2_:TextField = new TextField();
         _loc2_.borderColor = 0;
         _loc2_.backgroundColor = this.labelColor;
         _loc2_.background = true;
         _loc2_.type = TextFieldType.INPUT;
         _loc2_.defaultTextFormat = Block.blockLabelFormat;
         if(param1.length > 0)
         {
            _loc2_.width = 1000;
            _loc2_.text = param1;
            _loc2_.width = Math.max(10,_loc2_.textWidth + 2);
         }
         else
         {
            _loc2_.width = 27;
         }
         _loc2_.height = _loc2_.textHeight + 5;
         return _loc2_;
      }
      
      private function fixLayout(param1:Boolean = true) : void
      {
         this.playLabel.x = (this.width - this.playLabel.width - this.linkLabel.width) / 2;
         this.playLabel.y = 0;
         this.linkLabel.x = this.playLabel.x + this.playLabel.width;
         this.linkLabel.y = 0;
         this.shareImage.x = (this.width - this.shareImage.width) / 2 - 25;
         this.shareImage.y = 30;
         this.shareLabel.x = (this.width - this.shareLabel.width) / 2;
         this.shareLabel.y = 24;
         this.faqLabel.x = (this.width - this.faqLabel.width) / 2;
         this.faqLabel.y = 230;
         if(parent is DialogBox)
         {
            DialogBox(parent).fixLayout();
         }
      }
   }
}

