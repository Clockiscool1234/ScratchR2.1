package uiwidgets
{
   import flash.display.*;
   import flash.events.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.text.*;
   import sound.*;
   import translation.*;
   
   public class Piano extends Sprite
   {
      
      private static var noteNames:Array = ["C","C#","D","Eb","E","F","F#","G","G#","A","Bb","B"];
      
      private static var octaveNames:Array = ["Low C","Middle C","High C"];
      
      private var color:int;
      
      private var instrument:int;
      
      private var callback:Function;
      
      private var selectedKey:PianoKey;
      
      private var selectedNote:int;
      
      private var hasSelection:Boolean;
      
      private var keys:Array = [];
      
      private var shape:Shape;
      
      private var label:TextField;
      
      private var mousePressed:Boolean;
      
      private var notePlayer:NotePlayer;
      
      public function Piano(param1:int, param2:int = 0, param3:Function = null, param4:int = 48, param5:int = 72)
      {
         super();
         this.color = param1;
         this.instrument = param2;
         this.callback = param3;
         this.addShape();
         this.addLabel();
         this.addKeys(param4,param5);
         this.addEventListeners();
         this.fixLayout();
      }
      
      public static function isBlack(param1:int) : Boolean
      {
         param1 = getNoteOffset(param1);
         return param1 < 4 && param1 % 2 === 1 || param1 > 4 && param1 % 2 === 0;
      }
      
      private static function getNoteLabel(param1:int) : String
      {
         return getNoteName(param1) + " (" + param1 + ")";
      }
      
      private static function getNoteName(param1:int) : String
      {
         var _loc2_:int = getNoteOffset(param1);
         return _loc2_ ? noteNames[_loc2_] : getOctaveName(param1 / 12);
      }
      
      private static function getOctaveName(param1:int) : String
      {
         return param1 >= 4 && param1 <= 6 ? Translator.map(octaveNames[param1 - 4]) : "C";
      }
      
      private static function getNoteOffset(param1:int) : int
      {
         param1 %= 12;
         if(param1 < 0)
         {
            param1 += 12;
         }
         return param1;
      }
      
      private function addShape() : void
      {
         addChild(this.shape = new Shape());
      }
      
      private function addLabel() : void
      {
         addChild(this.label = new TextField());
         this.label.selectable = false;
         this.label.defaultTextFormat = new TextFormat(CSS.font,12,16777215);
      }
      
      private function addKeys(param1:int, param2:int) : void
      {
         var _loc4_:PianoKey = null;
         var _loc3_:int = param1;
         while(_loc3_ <= param2)
         {
            this.addKey(_loc3_);
            _loc3_++;
         }
         for each(_loc4_ in this.keys)
         {
            if(_loc4_.isBlack)
            {
               addChild(_loc4_);
            }
         }
      }
      
      private function addKey(param1:int) : void
      {
         var _loc2_:PianoKey = new PianoKey(param1);
         addChild(_loc2_);
         this.keys.push(_loc2_);
      }
      
      private function addEventListeners() : void
      {
         addEventListener(MouseEvent.MOUSE_DOWN,this.pianoMouseDown);
      }
      
      private function addStageEventListeners() : void
      {
         stage.addEventListener(MouseEvent.MOUSE_MOVE,this.stageMouseMove);
         stage.addEventListener(MouseEvent.MOUSE_UP,this.stageMouseUp);
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.stageMouseDown,true);
      }
      
      private function removeStageEventListeners() : void
      {
         stage.removeEventListener(MouseEvent.MOUSE_MOVE,this.stageMouseMove);
         stage.removeEventListener(MouseEvent.MOUSE_UP,this.stageMouseUp);
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.stageMouseDown,true);
      }
      
      private function pianoMouseDown(param1:MouseEvent) : void
      {
         this.mousePressed = true;
         this.deselect();
         this.updateKey(param1);
      }
      
      private function stageMouseDown(param1:MouseEvent) : void
      {
         var _loc2_:DisplayObject = param1.target as DisplayObject;
         while(_loc2_)
         {
            if(_loc2_ is Piano)
            {
               return;
            }
            _loc2_ = _loc2_.parent;
         }
         this.hide();
      }
      
      private function stageMouseMove(param1:MouseEvent) : void
      {
         this.updateKey(param1);
      }
      
      private function stageMouseUp(param1:MouseEvent) : void
      {
         if(this.mousePressed)
         {
            if(this.callback != null && this.hasSelection)
            {
               this.callback(this.selectedNote);
            }
            this.hide();
         }
      }
      
      private function updateKey(param1:MouseEvent) : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:int = 0;
         var _loc2_:Array = getObjectsUnderPoint(new Point(param1.stageX,param1.stageY));
         for each(_loc3_ in _loc2_.reverse())
         {
            if(_loc3_ is PianoKey)
            {
               _loc4_ = PianoKey(_loc3_).note;
               if(!this.mousePressed)
               {
                  this.setLabel(getNoteLabel(_loc4_));
                  return;
               }
               if(this.isNoteSelected(_loc4_))
               {
                  return;
               }
               this.selectNote(_loc4_);
               return;
            }
         }
         if(this.mousePressed)
         {
            this.deselect();
         }
      }
      
      public function selectNote(param1:int) : void
      {
         if(this.isNoteSelected(param1))
         {
            return;
         }
         this.deselect();
         this.hasSelection = true;
         this.selectedNote = param1;
         this.setLabel(getNoteLabel(param1));
         this.selectKeyForNote(param1);
      }
      
      public function deselect() : void
      {
         this.hasSelection = false;
         this.deselectKey();
      }
      
      public function isNoteSelected(param1:int) : Boolean
      {
         return this.hasSelection && this.selectedNote === param1;
      }
      
      private function deselectKey() : void
      {
         if(this.selectedKey)
         {
            this.selectedKey.deselect();
            this.selectedKey = null;
         }
      }
      
      private function selectKeyForNote(param1:int) : void
      {
         var _loc2_:PianoKey = null;
         for each(_loc2_ in this.keys)
         {
            if(_loc2_.note === param1)
            {
               this.selectedKey = _loc2_;
               _loc2_.select();
               return;
            }
         }
      }
      
      private function stopPlaying() : void
      {
         if(this.notePlayer)
         {
            this.notePlayer.stopPlaying();
            this.notePlayer = null;
         }
      }
      
      private function playSoundForNote(param1:int) : void
      {
         this.stopPlaying();
         this.notePlayer = SoundBank.getNotePlayer(this.instrument,param1);
         if(!this.notePlayer)
         {
            return;
         }
         this.notePlayer.setNoteAndDuration(param1,3);
         this.notePlayer.startPlaying();
      }
      
      public function showOnStage(param1:Stage, param2:Number = NaN, param3:Number = NaN) : void
      {
         this.addShadowFilter();
         this.x = int(param2 === param2 ? param2 : param1.mouseX);
         this.y = int(param3 === param3 ? param3 : param1.mouseY);
         param1.addChild(this);
         this.addStageEventListeners();
      }
      
      public function hide() : void
      {
         if(!stage)
         {
            return;
         }
         this.removeStageEventListeners();
         stage.removeChild(this);
      }
      
      private function addShadowFilter() : void
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         _loc1_.blurX = _loc1_.blurY = 5;
         _loc1_.distance = 3;
         _loc1_.color = 3355443;
         filters = [_loc1_];
      }
      
      private function fixLayout() : void
      {
         this.fixKeyLayout();
         this.fixLabelLayout();
         this.redraw();
      }
      
      private function fixKeyLayout() : void
      {
         var _loc2_:PianoKey = null;
         var _loc1_:int = 1;
         for each(_loc2_ in this.keys)
         {
            if(_loc2_.isBlack)
            {
               _loc2_.x = int(_loc1_ - _loc2_.width / 2);
               _loc2_.y = 0;
            }
            else
            {
               _loc2_.x = _loc1_;
               _loc2_.y = 1;
               _loc1_ += _loc2_.width;
            }
         }
      }
      
      private function redraw() : void
      {
         var _loc1_:Graphics = this.shape.graphics;
         _loc1_.beginFill(this.color,1);
         _loc1_.drawRect(0,0,width + 1,64);
         _loc1_.endFill();
      }
      
      private function setLabel(param1:String) : void
      {
         this.label.text = param1;
         this.fixLabelLayout();
      }
      
      private function fixLabelLayout() : void
      {
         this.label.x = int((width - this.label.textWidth) / 2);
         this.label.y = int(52 - this.label.textHeight / 2);
      }
   }
}

import flash.display.Sprite;

class PianoKey extends Sprite
{
   
   public const keyHeight:int = 44;
   
   public const blackKeyHeight:int = 26;
   
   public const keyWidth:int = 14;
   
   public const blackKeyWidth:int = 7;
   
   public var note:int;
   
   public var isBlack:Boolean;
   
   public var isSelected:Boolean;
   
   public function PianoKey(param1:int)
   {
      super();
      this.note = param1;
      this.isBlack = Piano.isBlack(param1);
      this.redraw();
   }
   
   public function select() : void
   {
      this.setSelected(true);
   }
   
   public function deselect() : void
   {
      this.setSelected(false);
   }
   
   public function setSelected(param1:Boolean) : void
   {
      this.isSelected = param1;
      this.redraw();
   }
   
   private function redraw() : void
   {
      var _loc1_:int = this.isBlack ? int(this.blackKeyHeight) : int(this.keyHeight);
      var _loc2_:int = this.isBlack ? int(this.blackKeyWidth) : int(this.keyWidth);
      graphics.beginFill(this.isSelected ? 16776960 : (this.isBlack ? 0 : 16777215));
      if(Boolean(this.isSelected) && Boolean(this.isBlack))
      {
         graphics.lineStyle(1,0,1,true);
      }
      graphics.drawRect(0,0,_loc2_,_loc1_);
      graphics.endFill();
      if(!this.isBlack)
      {
         graphics.beginFill(0,0);
         graphics.drawRect(_loc2_,0,1,_loc1_);
         graphics.endFill();
      }
   }
}
