package uiwidgets
{
   import flash.display.DisplayObject;
   
   public class SimpleTooltips
   {
      
      private static var instance:SimpleTooltip = null;
      
      public function SimpleTooltips()
      {
         super();
      }
      
      public static function add(param1:DisplayObject, param2:Object) : void
      {
         if(!instance)
         {
            instance = new SimpleTooltip();
         }
         if(!param1)
         {
            return;
         }
         instance.addTooltip(param1,param2);
      }
      
      public static function hideAll() : void
      {
         if(instance)
         {
            instance.forceHide();
         }
      }
      
      public static function showOnce(param1:DisplayObject, param2:Object) : void
      {
         if(!instance)
         {
            instance = new SimpleTooltip();
         }
         instance.showOnce(param1,param2);
      }
   }
}

import flash.display.*;
import flash.events.*;
import flash.filters.DropShadowFilter;
import flash.geom.*;
import flash.text.*;
import flash.utils.Dictionary;
import flash.utils.Timer;
import translation.Translator;

class SimpleTooltip
{
   
   private static var instance:*;
   
   private var tipObjs:Dictionary = new Dictionary();
   
   private var currentTipObj:DisplayObject;
   
   private var nextTipObj:DisplayObject;
   
   private const delay:uint = 500;
   
   private const linger:uint = 1000;
   
   private const fadeIn:uint = 200;
   
   private const fadeOut:uint = 500;
   
   private const bgColor:uint = 16580308;
   
   private var showTimer:Timer;
   
   private var hideTimer:Timer;
   
   private var animTimer:Timer;
   
   private var sprite:Sprite;
   
   private var textField:TextField;
   
   private var stage:Stage;
   
   public function SimpleTooltip()
   {
      super();
      this.showTimer = new Timer(this.delay);
      this.showTimer.addEventListener(TimerEvent.TIMER,this.eventHandler);
      this.hideTimer = new Timer(this.linger);
      this.hideTimer.addEventListener(TimerEvent.TIMER,this.eventHandler);
      this.sprite = new Sprite();
      this.sprite.mouseEnabled = false;
      this.sprite.mouseChildren = false;
      this.sprite.filters = [new DropShadowFilter(4,90,0,0.6,12,12,0.8)];
      this.textField = new TextField();
      this.textField.autoSize = TextFieldAutoSize.LEFT;
      this.textField.selectable = false;
      this.textField.background = false;
      this.textField.defaultTextFormat = CSS.normalTextFormat;
      this.textField.textColor = CSS.buttonLabelColor;
      this.sprite.addChild(this.textField);
   }
   
   public function addTooltip(param1:DisplayObject, param2:Object) : void
   {
      if(!param2.hasOwnProperty("text") || !param2.hasOwnProperty("direction") || ["top","bottom","left","right"].indexOf(param2.direction) == -1)
      {
         return;
      }
      if(this.tipObjs[param1] == null)
      {
         param1.addEventListener(MouseEvent.MOUSE_OVER,this.eventHandler);
      }
      this.tipObjs[param1] = param2;
   }
   
   private function eventHandler(param1:Event) : void
   {
      switch(param1.type)
      {
         case MouseEvent.MOUSE_OVER:
            this.startShowTimer(param1.currentTarget as DisplayObject);
            break;
         case MouseEvent.MOUSE_OUT:
            (param1.currentTarget as DisplayObject).removeEventListener(MouseEvent.MOUSE_OUT,this.eventHandler);
            if(this.showTimer.running)
            {
               this.showTimer.reset();
               this.nextTipObj = null;
            }
            this.startHideTimer(param1.currentTarget as DisplayObject);
            break;
         case TimerEvent.TIMER:
            if(param1.target == this.showTimer)
            {
               this.startShow();
            }
            else
            {
               this.startHide(param1.target as Timer);
               if(param1.target != this.hideTimer)
               {
                  (param1.target as Timer).removeEventListener(TimerEvent.TIMER,this.eventHandler);
               }
            }
      }
   }
   
   private function startShow() : void
   {
      this.showTimer.reset();
      this.hideTimer.reset();
      this.sprite.alpha = 0;
      var _loc1_:Object = this.tipObjs[this.nextTipObj];
      this.renderTooltip(_loc1_.text);
      this.currentTipObj = this.nextTipObj;
      this.sprite.alpha = 1;
      this.stage.addChild(this.sprite);
      var _loc2_:Point = this.getPos(_loc1_.direction);
      this.sprite.x = _loc2_.x;
      this.sprite.y = _loc2_.y;
   }
   
   public function showOnce(param1:DisplayObject, param2:Object) : void
   {
      if(!this.stage && Boolean(param1.stage))
      {
         this.stage = param1.stage;
      }
      this.forceHide();
      this.showTimer.reset();
      this.hideTimer.reset();
      this.sprite.alpha = 0;
      this.renderTooltip(param2.text);
      this.currentTipObj = param1;
      this.sprite.alpha = 1;
      this.stage.addChild(this.sprite);
      var _loc3_:Point = this.getPos(param2.direction);
      this.sprite.x = _loc3_.x;
      this.sprite.y = _loc3_.y;
      var _loc4_:Timer = new Timer(5000);
      _loc4_.addEventListener(TimerEvent.TIMER,this.eventHandler);
      _loc4_.reset();
      _loc4_.start();
   }
   
   private function getPos(param1:String) : Point
   {
      var _loc3_:Point = null;
      var _loc2_:Rectangle = this.currentTipObj.getBounds(this.stage);
      switch(param1)
      {
         case "right":
            _loc3_ = new Point(_loc2_.right + 5,Math.round((_loc2_.top + _loc2_.bottom - this.sprite.height) / 2));
            break;
         case "left":
            _loc3_ = new Point(_loc2_.left - 5 - this.sprite.width,Math.round((_loc2_.top + _loc2_.bottom - this.sprite.height) / 2));
            break;
         case "top":
            _loc3_ = new Point(Math.round((_loc2_.left + _loc2_.right - this.sprite.width) / 2),_loc2_.top - 4 - this.sprite.height);
            break;
         case "bottom":
            _loc3_ = new Point(Math.round((_loc2_.left + _loc2_.right - this.sprite.width) / 2),_loc2_.bottom + 4);
      }
      if(_loc3_.x < 0)
      {
         _loc3_.x = 0;
      }
      if(_loc3_.y < 0)
      {
         _loc3_.y = 0;
      }
      return _loc3_;
   }
   
   public function forceHide() : void
   {
      this.startHide(this.hideTimer);
   }
   
   private function startHide(param1:Timer) : void
   {
      this.hideTimer.reset();
      this.currentTipObj = null;
      this.sprite.alpha = 0;
      if(this.sprite.parent)
      {
         this.stage.removeChild(this.sprite);
      }
   }
   
   private function renderTooltip(param1:String) : void
   {
      var _loc2_:Graphics = this.sprite.graphics;
      this.textField.text = Translator.map(param1);
      _loc2_.clear();
      _loc2_.lineStyle(1,13421772);
      _loc2_.beginFill(this.bgColor);
      _loc2_.drawRect(0,0,this.textField.textWidth + 5,this.textField.textHeight + 3);
      _loc2_.endFill();
   }
   
   private function startShowTimer(param1:DisplayObject) : void
   {
      if(!this.stage && Boolean(param1.stage))
      {
         this.stage = param1.stage;
      }
      param1.addEventListener(MouseEvent.MOUSE_OUT,this.eventHandler);
      if(param1 === this.currentTipObj)
      {
         this.hideTimer.reset();
         return;
      }
      if(this.tipObjs[param1] is Object)
      {
         this.nextTipObj = param1;
         this.showTimer.reset();
         this.showTimer.start();
      }
   }
   
   private function startHideTimer(param1:DisplayObject) : void
   {
      if(param1 !== this.currentTipObj)
      {
         return;
      }
      this.hideTimer.reset();
      this.hideTimer.start();
   }
}
