package watchers
{
   import blocks.Block;
   import extensions.ExtensionManager;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.filters.BevelFilter;
   import flash.geom.Point;
   import flash.text.*;
   import interpreter.*;
   import scratch.*;
   import translation.Translator;
   import uiwidgets.*;
   import util.*;
   
   public class Watcher extends Sprite implements DragClient
   {
      
      private static const decimalPlaces:uint = 6;
      
      private const format:TextFormat = new TextFormat(CSS.font,11,0,true);
      
      private const NORMAL_MODE:int = 1;
      
      private const LARGE_MODE:int = 2;
      
      private const SLIDER_MODE:int = 3;
      
      private const TEXT_MODE:int = 4;
      
      public var target:ScratchObj;
      
      private var cmd:String;
      
      private var param:String;
      
      private var mode:int = 1;
      
      private var frame:ResizeableFrame;
      
      private var label:TextField;
      
      private var readout:WatcherReadout;
      
      private var slider:Shape;
      
      private var knob:Shape;
      
      private var lastValue:*;
      
      private var sliderMin:Number = 0;
      
      private var sliderMax:Number = 100;
      
      private var isDiscrete:Boolean = true;
      
      private var mouseMoved:Boolean;
      
      public function Watcher()
      {
         super();
         this.frame = new ResizeableFrame(9736593,12698823,8);
         addChild(this.frame);
         this.addLabel();
         this.readout = new WatcherReadout();
         addChild(this.readout);
         this.addSliderAndKnob();
         this.slider.visible = this.knob.visible = false;
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDown);
      }
      
      public static function formatValue(param1:*) : String
      {
         if(param1 is Number || param1 is String && String(parseFloat(param1)) === param1)
         {
            param1 = Number(Number(param1).toFixed(decimalPlaces));
         }
         return "" + param1;
      }
      
      public static function strings() : Array
      {
         return ["Max","Min","Slider Range","normal readout","large readout","slider","set slider min and max","hide"];
      }
      
      public function initWatcher(param1:ScratchObj, param2:String, param3:String, param4:int) : void
      {
         this.target = param1;
         this.cmd = param2;
         this.param = param3;
         this.mode = this.NORMAL_MODE;
         this.setColor(param4);
         this.updateLabel();
      }
      
      public function initForVar(param1:ScratchObj, param2:String) : void
      {
         this.target = param1;
         this.cmd = "getVar:";
         this.param = param2;
         this.mode = this.NORMAL_MODE;
         var _loc3_:Variable = param1.lookupVar(this.param);
         if(_loc3_ != null)
         {
            _loc3_.watcher = this;
         }
         this.setColor(Specs.variableColor);
         this.setLabel(param1.isStage ? param2 : param1.objName + ": " + param2);
      }
      
      public function changeVarName(param1:String) : void
      {
         if(this.cmd != "getVar:")
         {
            return;
         }
         this.param = param1;
         this.setLabel(this.target.isStage ? param1 : this.target.objName + ": " + param1);
      }
      
      public function isVarWatcherFor(param1:ScratchObj, param2:String) : Boolean
      {
         return this.cmd == "getVar:" && this.target == param1 && this.param == param2;
      }
      
      public function isReporterWatcher(param1:ScratchObj, param2:String, param3:String) : Boolean
      {
         return this.target == param1 && this.cmd == param2 && this.param == param3;
      }
      
      public function setMode(param1:int) : void
      {
         this.mode = param1;
         this.readout.beLarge(this.mode == this.LARGE_MODE);
         this.fixLayout();
      }
      
      public function setColor(param1:int) : void
      {
         this.readout.setColor(param1);
      }
      
      public function setSliderMinMax(param1:Number, param2:Number, param3:Number) : void
      {
         this.sliderMin = param1;
         this.sliderMax = param2;
         this.isDiscrete = int(param1) == param1 && int(param2) == param2 && int(param3) == param3;
      }
      
      override public function hitTestPoint(param1:Number, param2:Number, param3:Boolean = true) : Boolean
      {
         if(!visible)
         {
            return false;
         }
         if(this.frame.visible)
         {
            return this.frame.hitTestPoint(param1,param2,param3);
         }
         return this.readout.hitTestPoint(param1,param2,param3);
      }
      
      public function step(param1:ScratchRuntime) : void
      {
         var _loc2_:* = this.getValue(param1);
         if(_loc2_ !== this.lastValue)
         {
            this.showValue(_loc2_);
            param1.interp.redraw();
         }
         this.lastValue = _loc2_;
         this.updateLabel();
      }
      
      private function updateLabel() : void
      {
         if(this.cmd == "getVar:")
         {
            if(this.target.isStage)
            {
               this.setLabel(this.param);
            }
            else
            {
               this.setLabel(this.target.objName + ": " + this.param);
            }
         }
         else if(this.cmd == "sensor:")
         {
            this.setLabel(Translator.map(this.param + " sensor value"));
         }
         else if(this.cmd == "sensorPressed:")
         {
            this.setLabel(Translator.map("sensor " + this.param + "?"));
         }
         else if(this.cmd == "timeAndDate")
         {
            this.setLabel(Translator.map(this.param));
         }
         else if(this.cmd == "senseVideoMotion")
         {
            this.setLabel((this.target.isStage ? "" : this.target.objName + ": ") + Translator.map("video " + this.param));
         }
         else
         {
            this.setLabel((this.target.isStage ? "" : this.target.objName + ": ") + this.specForCmd());
         }
      }
      
      private function specForCmd() : String
      {
         var _loc2_:Array = null;
         var _loc3_:Array = null;
         var _loc1_:String = ExtensionManager.unpackExtensionName(this.cmd);
         if(_loc1_)
         {
            _loc3_ = Scratch.app.extensionManager.specForCmd(this.cmd);
            if(_loc3_)
            {
               return _loc1_ + ": " + _loc3_[0];
            }
         }
         for each(_loc2_ in Specs.commands)
         {
            if(_loc2_[3] == this.cmd)
            {
               return Translator.map(_loc2_[0]);
            }
         }
         return "";
      }
      
      private function showValue(param1:*) : void
      {
         this.readout.setContents(formatValue(param1));
         this.fixLayout();
      }
      
      private function getValue(param1:ScratchRuntime) : *
      {
         var _loc3_:Variable = null;
         var _loc4_:Function = null;
         var _loc5_:Block = null;
         var _loc6_:Array = null;
         if(this.target == null)
         {
            return "";
         }
         if(this.targetIsVariable())
         {
            _loc3_ = this.target.lookupVar(this.param);
            return _loc3_ == null ? "unknown var: " + this.param : _loc3_.value;
         }
         var _loc2_:Scratch = param1.app;
         if(this.cmd == "senseVideoMotion")
         {
            _loc4_ = _loc2_.interp.getPrim(this.cmd);
            if(_loc4_ == null)
            {
               return 0;
            }
            _loc5_ = new Block("video %s on %s","r",0,"senseVideoMotion",[this.param,this.target.objName]);
            return _loc4_(_loc5_);
         }
         if(this.target is ScratchSprite)
         {
            switch(this.cmd)
            {
               case "costumeIndex":
                  return ScratchSprite(this.target).costumeNumber();
               case "xpos":
                  return ScratchSprite(this.target).scratchX;
               case "ypos":
                  return ScratchSprite(this.target).scratchY;
               case "heading":
                  return ScratchSprite(this.target).direction;
               case "scale":
                  return Math.round(ScratchSprite(this.target).getSize());
            }
         }
         switch(this.cmd)
         {
            case "backgroundIndex":
               return _loc2_.stagePane.costumeNumber();
            case "sceneName":
               return _loc2_.stagePane.currentCostume().costumeName;
            case "tempo":
               return _loc2_.stagePane.tempoBPM;
            case "volume":
               return this.target.volume;
            case "answer":
               return param1.lastAnswer;
            case "timer":
               return Math.round(10 * param1.timer()) / 10;
            case "soundLevel":
               return param1.soundLevel();
            case "isLoud":
               return param1.isLoud();
            case "sensor:":
               return param1.getSensor(this.param);
            case "sensorPressed:":
               return param1.getBooleanSensor(this.param);
            case "timeAndDate":
               return param1.getTimeString(this.param);
            case "xScroll":
               return _loc2_.stagePane.xScroll;
            case "yScroll":
               return _loc2_.stagePane.yScroll;
            default:
               if(ExtensionManager.hasExtensionPrefix(this.cmd))
               {
                  _loc6_ = Scratch.app.extensionManager.specForCmd(this.cmd);
                  if(_loc6_)
                  {
                     _loc5_ = new Block(_loc6_[0],_loc6_[1],Specs.blockColor(_loc6_[2]),_loc6_[3]);
                     return Scratch.app.interp.evalCmd(_loc5_);
                  }
               }
               return "unknown: " + this.cmd;
         }
      }
      
      private function targetIsVariable() : Boolean
      {
         return this.cmd == "getVar:";
      }
      
      private function addLabel() : void
      {
         this.label = new TextField();
         this.label.type = "dynamic";
         this.label.selectable = false;
         this.label.defaultTextFormat = this.format;
         this.label.text = "";
         this.label.width = this.label.textWidth + 5;
         this.label.height = this.label.textHeight + 5;
         this.label.x = 4;
         this.label.y = 2;
         addChild(this.label);
      }
      
      private function setLabel(param1:String) : void
      {
         if(!this.label.visible || this.label.text == param1)
         {
            return;
         }
         this.label.text = param1;
         this.label.width = this.label.textWidth + 5;
         this.label.height = this.label.textHeight + 5;
         this.fixLayout();
      }
      
      private function addSliderAndKnob() : void
      {
         this.slider = new Shape();
         var _loc1_:BevelFilter = new BevelFilter(2);
         _loc1_.angle = 225;
         _loc1_.shadowAlpha = 0.5;
         _loc1_.highlightAlpha = 0.5;
         this.slider.filters = [_loc1_];
         addChild(this.slider);
         this.knob = new Shape();
         var _loc2_:Graphics = this.knob.graphics;
         _loc2_.lineStyle(1,8421504);
         _loc2_.beginFill(16777215);
         _loc2_.drawCircle(5,5,5);
         _loc1_ = new BevelFilter(2);
         _loc1_.blurX = _loc1_.blurY = 5;
         this.knob.filters = [_loc1_];
         addChild(this.knob);
      }
      
      private function fixLayout() : void
      {
         var _loc1_:Graphics = null;
         this.adjustReadoutSize();
         if(this.mode == this.LARGE_MODE)
         {
            this.frame.visible = this.label.visible = false;
            this.readout.x = 0;
            this.readout.y = 3;
         }
         else
         {
            this.frame.visible = this.label.visible = true;
            this.readout.x = this.label.width + 8;
            this.readout.y = 3;
         }
         if(this.mode == this.SLIDER_MODE)
         {
            this.slider.visible = this.knob.visible = true;
            this.slider.x = 6;
            this.slider.y = 22;
            _loc1_ = this.slider.graphics;
            _loc1_.clear();
            _loc1_.beginFill(12632256);
            _loc1_.drawRoundRect(0,0,this.frame.w - 12,5,5,5);
            this.setKnobPosition();
         }
         else
         {
            this.slider.visible = this.knob.visible = false;
         }
      }
      
      private function adjustReadoutSize() : void
      {
         this.frame.w = this.label.width + this.readout.width + 15;
         this.frame.h = this.mode == this.NORMAL_MODE ? 21 : 31;
         this.frame.setWidthHeight(this.frame.w,this.frame.h);
      }
      
      private function setKnobPosition() : void
      {
         var _loc1_:Number = (Number(this.readout.contents) - this.sliderMin) / (this.sliderMax - this.sliderMin);
         _loc1_ = Math.max(0,Math.min(_loc1_,1));
         var _loc2_:int = Math.round(_loc1_ * (this.slider.width - 10));
         this.knob.x = this.slider.x + _loc2_;
         this.knob.y = this.slider.y - 3;
      }
      
      public function objToGrab(param1:MouseEvent) : Watcher
      {
         return this;
      }
      
      public function doubleClick(param1:MouseEvent) : void
      {
         if(!Scratch.app.editMode)
         {
            return;
         }
         var _loc2_:int = this.mode + 1;
         if(this.targetIsVariable())
         {
            if(_loc2_ > 3)
            {
               _loc2_ = 1;
            }
         }
         else if(_loc2_ > 2)
         {
            _loc2_ = 1;
         }
         this.setMode(_loc2_);
      }
      
      public function menu(param1:MouseEvent) : Menu
      {
         var m:Menu;
         var handleMenu:Function = null;
         var evt:MouseEvent = param1;
         handleMenu = function(param1:int):void
         {
            if(1 <= param1 && param1 <= 3)
            {
               setMode(param1);
            }
            if(5 == param1)
            {
               sliderMinMaxDialog();
            }
            if(param1 == 10)
            {
               visible = false;
               Scratch.app.updatePalette(false);
            }
         };
         if(!Scratch.app.editMode)
         {
            return null;
         }
         m = new Menu(handleMenu);
         m.addItem("normal readout",1);
         m.addItem("large readout",2);
         if(this.targetIsVariable())
         {
            m.addItem("slider",3);
            if(this.mode == this.SLIDER_MODE)
            {
               m.addLine();
               m.addItem("set slider min and max",5);
            }
         }
         m.addLine();
         m.addItem("hide",10);
         return m;
      }
      
      private function sliderMinMaxDialog() : void
      {
         var setMinMax:Function = null;
         var d:DialogBox = null;
         setMinMax = function():void
         {
            var _loc1_:String = d.getField("Min");
            var _loc2_:String = d.getField("Max");
            var _loc3_:Number = Number(_loc1_);
            var _loc4_:Number = Number(_loc2_);
            if(isNaN(_loc3_) || isNaN(_loc4_))
            {
               return;
            }
            sliderMin = Math.min(_loc3_,_loc4_);
            sliderMax = Math.max(_loc3_,_loc4_);
            isDiscrete = _loc1_.indexOf(".") < 0 && _loc2_.indexOf(".") < 0;
            setSliderValue(sliderMin);
            Scratch.app.setSaveNeeded();
         };
         d = new DialogBox(setMinMax);
         d.addTitle("Slider Range");
         d.addField("Min",120,this.isDiscrete || int(this.sliderMin) != this.sliderMin ? this.sliderMin : int(this.sliderMin) + ".0");
         d.addField("Max",120,this.sliderMax);
         d.addAcceptCancelButtons("OK");
         d.showOnStage(stage);
      }
      
      private function mouseDown(param1:MouseEvent) : void
      {
         if(this.mode != this.SLIDER_MODE)
         {
            return;
         }
         var _loc2_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         if(_loc2_.y > 20)
         {
            Scratch(root).gh.setDragClient(this,param1);
         }
      }
      
      public function dragBegin(param1:MouseEvent) : void
      {
         this.mouseMoved = false;
      }
      
      public function dragMove(param1:MouseEvent) : void
      {
         var _loc2_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         var _loc3_:Number = _loc2_.x - this.slider.x - 4;
         this.setSliderValue(_loc3_ / (this.slider.width - 10) * (this.sliderMax - this.sliderMin) + this.sliderMin);
         this.mouseMoved = true;
      }
      
      public function dragEnd(param1:MouseEvent) : void
      {
         var _loc2_:Point = globalToLocal(new Point(param1.stageX,param1.stageY));
         if(!this.mouseMoved)
         {
            this.clickAt(_loc2_.x);
         }
      }
      
      private function clickAt(param1:Number) : void
      {
         var _loc2_:Number = param1 < this.knob.x ? -1 : 1;
         var _loc3_:Number = this.isDiscrete ? _loc2_ : _loc2_ * ((this.sliderMax - this.sliderMin) / 100);
         this.setSliderValue(Number(this.readout.contents) + _loc3_);
      }
      
      private function setSliderValue(param1:Number) : void
      {
         var _loc2_:Number = this.isDiscrete ? Math.round(param1) : Math.round(param1 * 100) / 100;
         _loc2_ = Math.max(this.sliderMin,Math.min(_loc2_,this.sliderMax));
         if(this.target != null)
         {
            this.target.setVarTo(this.param,_loc2_);
         }
         this.showValue(_loc2_);
      }
      
      public function writeJSON(param1:util.JSON) : void
      {
         param1.writeKeyValue("target",this.target.objName);
         param1.writeKeyValue("cmd",this.cmd);
         param1.writeKeyValue("param",this.param);
         param1.writeKeyValue("color",this.readout.getColor());
         param1.writeKeyValue("label",this.label.text);
         param1.writeKeyValue("mode",this.mode);
         param1.writeKeyValue("sliderMin",this.sliderMin);
         param1.writeKeyValue("sliderMax",this.sliderMax);
         param1.writeKeyValue("isDiscrete",this.isDiscrete);
         param1.writeKeyValue("x",x);
         param1.writeKeyValue("y",y);
         param1.writeKeyValue("visible",visible);
      }
      
      public function readJSON(param1:Object) : void
      {
         if(param1.cmd == "getVar:")
         {
            this.initForVar(param1.target,param1.param);
         }
         else
         {
            this.initWatcher(param1.target,param1.cmd,param1.param,param1.color);
         }
         this.sliderMin = param1.sliderMin;
         this.sliderMax = param1.sliderMax;
         this.isDiscrete = param1.isDiscrete;
         this.setMode(param1.mode);
         x = param1.x;
         y = param1.y;
         visible = param1.visible;
      }
   }
}

