package uiwidgets
{
   import blocks.*;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.*;
   import flash.net.*;
   import flash.text.*;
   import flash.utils.ByteArray;
   import ui.parts.UIPart;
   import util.*;
   
   public class BlockColorEditor extends Sprite
   {
      
      private var base:Shape;
      
      private var blockShape:BlockShape;
      
      private var blockLabel:TextField;
      
      private var category:TextField;
      
      private var categoryName:TextField;
      
      private var hueBox:EditableLabel;
      
      private var satBox:EditableLabel;
      
      private var briBox:EditableLabel;
      
      private var hueSlider:Scrollbar;
      
      private var satSlider:Scrollbar;
      
      private var briSlider:Scrollbar;
      
      private var hue:Number;
      
      private var sat:Number;
      
      private var bri:Number;
      
      public function BlockColorEditor()
      {
         super();
         addChild(this.base = new Shape());
         this.setWidthHeight(250,430);
         this.addButtons();
         this.addCategorySelector();
         this.addBlockShape();
         this.addHSVControls();
         this.selectCategory("Motion");
      }
      
      private function setWidthHeight(param1:int, param2:int) : void
      {
         var _loc3_:Graphics = this.base.graphics;
         _loc3_.clear();
         _loc3_.beginFill(CSS.white);
         _loc3_.drawRect(0,0,param1,param2);
         _loc3_.endFill();
      }
      
      private function addButtons() : void
      {
         var _loc1_:IconButton = null;
         addChild(_loc1_ = UIPart.makeMenuButton("Load",this.loadColors,false,CSS.textColor));
         _loc1_.x = 5;
         _loc1_.y = 0;
         addChild(_loc1_ = UIPart.makeMenuButton("Save",this.saveColors,false,CSS.textColor));
         _loc1_.x = 45;
         _loc1_.y = 0;
         addChild(_loc1_ = UIPart.makeMenuButton("Apply",this.apply,false,CSS.textColor));
         _loc1_.x = 120;
         _loc1_.y = 31;
      }
      
      public function apply(param1:IconButton) : void
      {
         this.setCategoryColor(this.categoryName.text,Color.fromHSV(this.hue,this.sat,this.bri));
         Scratch.app.translationChanged();
      }
      
      private function setCategoryColor(param1:String, param2:int) : void
      {
         var _loc3_:Array = null;
         for each(_loc3_ in Specs.categories)
         {
            if(_loc3_[1] == param1)
            {
               _loc3_[2] = param2;
            }
            if("Data" == param1)
            {
               Specs.variableColor = param2;
            }
            if("List" == param1)
            {
               Specs.listColor = param2;
            }
            if("More Blocks" == param1)
            {
               Specs.procedureColor = param2;
            }
            if("Parameter" == param1)
            {
               Specs.parameterColor = param2;
            }
            if("Extension" == param1)
            {
               Specs.extensionsColor = param2;
            }
         }
      }
      
      public function loadColors(param1:IconButton) : void
      {
         var fileSelected:Function = null;
         var fileLoaded:Function = null;
         var fileList:FileReferenceList = null;
         var b:IconButton = param1;
         fileSelected = function(param1:Event):void
         {
            if(fileList.fileList.length == 0)
            {
               return;
            }
            var _loc2_:FileReference = FileReference(fileList.fileList[0]);
            _loc2_.addEventListener(Event.COMPLETE,fileLoaded);
            _loc2_.load();
         };
         fileLoaded = function(param1:Event):void
         {
            var _loc4_:String = null;
            var _loc2_:ByteArray = FileReference(param1.target).data;
            var _loc3_:Object = util.JSON.parse(_loc2_.toString());
            for(_loc4_ in _loc3_)
            {
               setCategoryColor(_loc4_,_loc3_[_loc4_]);
            }
            selectCategory(categoryName.text);
            Scratch.app.translationChanged();
         };
         fileList = new FileReferenceList();
         fileList.addEventListener(Event.SELECT,fileSelected);
         fileList.browse();
      }
      
      public function saveColors(param1:IconButton) : void
      {
         var _loc3_:Array = null;
         var _loc2_:String = "{\n";
         for each(_loc3_ in Specs.categories)
         {
            if(_loc3_[0] != 0)
            {
               _loc2_ += "  \"" + _loc3_[1] + "\": 0x" + _loc3_[2].toString(16) + ",\n";
            }
         }
         _loc2_ = _loc2_.slice(0,_loc2_.length - 2) + "\n}\n";
         new FileReference().save(_loc2_,"scratch.colors");
      }
      
      private function addCategorySelector() : void
      {
         this.category = this.makeLabel("Category:",12,120,0,true);
         this.category.addEventListener(MouseEvent.MOUSE_OVER,this.categoryRollover);
         this.category.addEventListener(MouseEvent.MOUSE_OUT,this.categoryRollover);
         this.category.addEventListener(MouseEvent.MOUSE_DOWN,this.categoryMenu);
         this.categoryName = this.makeLabel("More Blocks",12,185,0);
      }
      
      private function categoryRollover(param1:MouseEvent) : void
      {
         this.category.textColor = param1.type == MouseEvent.MOUSE_OVER ? uint(CSS.buttonLabelOverColor) : uint(CSS.textColor);
      }
      
      private function categoryMenu(param1:MouseEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Point = null;
         var _loc2_:Menu = new Menu(this.selectCategory);
         for each(_loc3_ in Specs.categories)
         {
            if(_loc3_[0] > 0 && _loc3_[0] <= 20)
            {
               _loc2_.addItem(_loc3_[1]);
            }
         }
         _loc4_ = this.category.localToGlobal(new Point(0,0));
         _loc2_.showOnStage(stage,_loc4_.x + 1,_loc4_.y + this.category.height - 1);
      }
      
      private function selectCategory(param1:String) : void
      {
         this.categoryName.text = param1;
         var _loc2_:Array = Specs.entryForCategory(param1);
         this.setColor(_loc2_[2]);
      }
      
      private function addBlockShape() : void
      {
         addChild(this.blockShape = new BlockShape(BlockShape.CmdShape,Specs.procedureColor));
         this.blockShape.setWidthAndTopHeight(95,22,true);
         this.blockShape.x = 5;
         this.blockShape.y = 30;
         this.blockLabel = this.makeLabel("",11,this.blockShape.x + 4,this.blockShape.y + 3);
         this.blockLabel.defaultTextFormat = new TextFormat("Arial",11,16777215,true);
         this.blockLabel.text = "block color test";
      }
      
      private function addHSVControls() : void
      {
         this.makeLabel("Hue",15,35,60,true);
         this.makeLabel("Sat.",15,110,60,true);
         this.makeLabel("Bri.",15,185,60,true);
         addChild(this.hueBox = new EditableLabel(this.hueTextChanged));
         addChild(this.satBox = new EditableLabel(this.satTextChanged));
         addChild(this.briBox = new EditableLabel(this.briTextChanged));
         addChild(this.hueSlider = new Scrollbar(10,300,this.setHue));
         addChild(this.satSlider = new Scrollbar(10,300,this.setSat));
         addChild(this.briSlider = new Scrollbar(10,300,this.setBri));
         this.hueBox.setWidth(50);
         this.satBox.setWidth(50);
         this.briBox.setWidth(50);
         this.hueBox.x = 25;
         this.satBox.x = 100;
         this.briBox.x = 175;
         this.hueBox.y = this.satBox.y = this.briBox.y = 85;
         this.hueSlider.x = this.hueBox.x + 20;
         this.satSlider.x = this.satBox.x + 20;
         this.briSlider.x = this.briBox.x + 20;
         this.hueSlider.y = this.satSlider.y = this.briSlider.y = this.hueBox.y + 30;
         this.setColor(3102117);
      }
      
      private function setColor(param1:int) : void
      {
         var _loc2_:Array = Color.rgb2hsv(param1);
         this.hue = _loc2_[0];
         this.sat = _loc2_[1];
         this.bri = _loc2_[2];
         this.update();
      }
      
      private function update() : void
      {
         this.hue %= 360;
         if(this.hue < 0)
         {
            this.hue += 360;
         }
         this.sat = Math.max(0,Math.min(this.sat,1));
         this.bri = Math.max(0,Math.min(this.bri,1));
         this.blockShape.setColor(Color.fromHSV(this.hue,this.sat,this.bri));
         this.blockShape.redraw();
         this.hueBox.setContents("" + Math.round(this.hue));
         this.satBox.setContents("" + Math.round(100 * this.sat));
         this.briBox.setContents("" + Math.round(100 * this.bri));
         this.hueSlider.update(this.hue / 360,0.08);
         this.satSlider.update(this.sat,0.08);
         this.briSlider.update(this.bri,0.08);
      }
      
      private function hueTextChanged() : void
      {
         var _loc1_:Number = Number(this.hueBox.contents());
         if(_loc1_ == _loc1_)
         {
            this.hue = _loc1_;
         }
         this.update();
      }
      
      private function satTextChanged() : void
      {
         var _loc1_:Number = Number(this.satBox.contents());
         if(_loc1_ == _loc1_)
         {
            this.sat = _loc1_ / 100;
         }
         this.update();
      }
      
      private function briTextChanged() : void
      {
         var _loc1_:Number = Number(this.briBox.contents());
         if(_loc1_ == _loc1_)
         {
            this.bri = _loc1_ / 100;
         }
         this.update();
      }
      
      private function setHue(param1:Number) : void
      {
         this.hue = 360 * param1;
         this.update();
      }
      
      private function setSat(param1:Number) : void
      {
         this.sat = param1;
         this.update();
      }
      
      private function setBri(param1:Number) : void
      {
         this.bri = param1;
         this.update();
      }
      
      private function makeLabel(param1:String, param2:int, param3:int = 0, param4:int = 0, param5:Boolean = false) : TextField
      {
         var _loc6_:TextField = new TextField();
         _loc6_.selectable = false;
         _loc6_.defaultTextFormat = new TextFormat(CSS.font,param2,CSS.textColor,param5);
         _loc6_.autoSize = TextFieldAutoSize.LEFT;
         _loc6_.text = param1;
         _loc6_.x = param3;
         _loc6_.y = param4;
         addChild(_loc6_);
         return _loc6_;
      }
   }
}

