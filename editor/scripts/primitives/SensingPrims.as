package primitives
{
   import blocks.Block;
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.Dictionary;
   import interpreter.*;
   import scratch.*;
   
   public class SensingPrims
   {
      
      private static var stageRect:Rectangle = new Rectangle(0,0,480,360);
      
      private var app:Scratch;
      
      private var interp:Interpreter;
      
      private var debugView:Bitmap;
      
      public function SensingPrims(param1:Scratch, param2:Interpreter)
      {
         super();
         this.app = param1;
         this.interp = param2;
      }
      
      public function addPrimsTo(param1:Dictionary) : void
      {
         var primTable:Dictionary = param1;
         primTable["touching:"] = this.primTouching;
         primTable["touchingColor:"] = this.primTouchingColor;
         primTable["color:sees:"] = this.primColorSees;
         primTable["doAsk"] = this.primAsk;
         primTable["answer"] = function(param1:*):*
         {
            return app.runtime.lastAnswer;
         };
         primTable["mousePressed"] = function(param1:*):*
         {
            return app.gh.mouseIsDown;
         };
         primTable["mouseX"] = function(param1:*):*
         {
            return app.stagePane.scratchMouseX();
         };
         primTable["mouseY"] = function(param1:*):*
         {
            return app.stagePane.scratchMouseY();
         };
         primTable["timer"] = function(param1:*):*
         {
            return app.runtime.timer();
         };
         primTable["timerReset"] = function(param1:*):*
         {
            app.runtime.timerReset();
         };
         primTable["keyPressed:"] = this.primKeyPressed;
         primTable["distanceTo:"] = this.primDistanceTo;
         primTable["getAttribute:of:"] = this.primGetAttribute;
         primTable["soundLevel"] = function(param1:*):*
         {
            return app.runtime.soundLevel();
         };
         primTable["isLoud"] = function(param1:*):*
         {
            return app.runtime.isLoud();
         };
         primTable["timestamp"] = this.primTimestamp;
         primTable["timeAndDate"] = function(param1:*):*
         {
            return app.runtime.getTimeString(interp.arg(param1,0));
         };
         primTable["getUserName"] = function(param1:*):*
         {
            return "";
         };
         primTable["sensor:"] = function(param1:*):*
         {
            return app.runtime.getSensor(interp.arg(param1,0));
         };
         primTable["sensorPressed:"] = function(param1:*):*
         {
            return app.runtime.getBooleanSensor(interp.arg(param1,0));
         };
         primTable["showVariable:"] = this.primShowWatcher;
         primTable["hideVariable:"] = this.primHideWatcher;
         primTable["showList:"] = this.primShowListWatcher;
         primTable["hideList:"] = this.primHideListWatcher;
      }
      
      private function primTouching(param1:Block) : Boolean
      {
         var _loc5_:ScratchSprite = null;
         var _loc6_:Rectangle = null;
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return false;
         }
         var _loc3_:* = this.interp.arg(param1,0);
         if("_edge_" == _loc3_)
         {
            if(stageRect.containsRect(_loc2_.getBounds(_loc2_.parent)))
            {
               return false;
            }
            _loc6_ = _loc2_.bounds();
            return _loc6_.left < 0 || _loc6_.right > ScratchObj.STAGEW || _loc6_.top < 0 || _loc6_.bottom > ScratchObj.STAGEH;
         }
         if("_mouse_" == _loc3_)
         {
            return this.mouseTouches(_loc2_);
         }
         if(!_loc2_.visible)
         {
            return false;
         }
         var _loc4_:BitmapData = _loc2_.bitmap(true);
         for each(_loc5_ in this.app.stagePane.spritesAndClonesNamed(_loc3_))
         {
            if(_loc5_.visible && _loc4_.hitTest(_loc2_.bounds().topLeft,1,_loc5_.bitmap(true),_loc5_.bounds().topLeft,1))
            {
               return true;
            }
         }
         return false;
      }
      
      public function mouseTouches(param1:ScratchSprite) : Boolean
      {
         if(!param1.parent)
         {
            return false;
         }
         if(!param1.getBounds(param1).contains(param1.mouseX,param1.mouseY))
         {
            return false;
         }
         var _loc2_:Rectangle = param1.bounds();
         if(!_loc2_.contains(param1.parent.mouseX,param1.parent.mouseY))
         {
            return false;
         }
         return param1.bitmap().hitTest(_loc2_.topLeft,1,new Point(param1.parent.mouseX,param1.parent.mouseY));
      }
      
      private function primTouchingColor(param1:Block) : Boolean
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return false;
         }
         var _loc3_:int = this.interp.arg(param1,0) | 0xFF000000;
         var _loc4_:BitmapData = _loc2_.bitmap(true);
         var _loc5_:BitmapData = this.stageBitmapWithoutSpriteFilteredByColor(_loc2_,_loc3_);
         return _loc4_.hitTest(new Point(0,0),1,_loc5_,new Point(0,0),1);
      }
      
      private function primColorSees(param1:Block) : Boolean
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         if(_loc2_ == null)
         {
            return false;
         }
         var _loc3_:int = this.interp.arg(param1,0) | 0xFF000000;
         var _loc4_:int = this.interp.arg(param1,1) | 0xFF000000;
         var _loc5_:BitmapData = this.bitmapFilteredByColor(_loc2_.bitmap(true),_loc3_);
         var _loc6_:BitmapData = this.stageBitmapWithoutSpriteFilteredByColor(_loc2_,_loc4_);
         return _loc5_.hitTest(new Point(0,0),1,_loc6_,new Point(0,0),1);
      }
      
      private function showBM(param1:BitmapData) : void
      {
         if(this.debugView == null)
         {
            this.debugView = new Bitmap();
            this.debugView.x = 100;
            this.debugView.y = 600;
            this.app.addChild(this.debugView);
         }
         this.debugView.bitmapData = param1;
      }
      
      private function bitmapFilteredByColor(param1:BitmapData, param2:int) : BitmapData
      {
         var _loc3_:BitmapData = new BitmapData(param1.width,param1.height,true,0);
         _loc3_.threshold(param1,param1.rect,param1.rect.topLeft,"==",param2,4278190080,4042848496);
         return _loc3_;
      }
      
      private function stageBitmapWithoutSpriteFilteredByColor(param1:ScratchSprite, param2:int) : BitmapData
      {
         return this.app.stagePane.getBitmapWithoutSpriteFilteredByColor(param1,param2);
      }
      
      private function primAsk(param1:Block) : void
      {
         var _loc3_:String = null;
         if(this.app.runtime.askPromptShowing())
         {
            this.interp.doYield();
            return;
         }
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(this.interp.activeThread.firstTime)
         {
            _loc3_ = this.interp.arg(param1,0);
            if(_loc2_ is ScratchSprite && _loc2_.visible)
            {
               ScratchSprite(_loc2_).showBubble(_loc3_,"talk",_loc2_,true);
               this.app.runtime.showAskPrompt("");
            }
            else
            {
               this.app.runtime.showAskPrompt(_loc3_);
            }
            this.interp.activeThread.firstTime = false;
            this.interp.doYield();
         }
         else
         {
            if(_loc2_ is ScratchSprite && _loc2_.visible)
            {
               ScratchSprite(_loc2_).hideBubble();
            }
            this.interp.activeThread.firstTime = true;
         }
      }
      
      private function primKeyPressed(param1:Block) : Boolean
      {
         var _loc4_:Boolean = false;
         var _loc2_:String = this.interp.arg(param1,0);
         if(_loc2_ == "any")
         {
            for each(_loc4_ in this.app.runtime.keyIsDown)
            {
               if(_loc4_)
               {
                  return true;
               }
            }
            return false;
         }
         var _loc3_:int = ScratchRuntime.getKeyCode(_loc2_);
         return Boolean(this.app.runtime.keyIsDown[_loc3_]);
      }
      
      private function primDistanceTo(param1:Block) : Number
      {
         var _loc2_:ScratchSprite = this.interp.targetSprite();
         var _loc3_:Point = this.mouseOrSpritePosition(this.interp.arg(param1,0));
         if(_loc2_ == null || _loc3_ == null)
         {
            return 10000;
         }
         var _loc4_:Number = _loc3_.x - _loc2_.scratchX;
         var _loc5_:Number = _loc3_.y - _loc2_.scratchY;
         return Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
      }
      
      private function primGetAttribute(param1:Block) : *
      {
         var _loc4_:ScratchSprite = null;
         var _loc2_:String = this.interp.arg(param1,0);
         var _loc3_:ScratchObj = this.app.stagePane.objNamed(String(this.interp.arg(param1,1)));
         if(!(_loc3_ is ScratchObj))
         {
            return 0;
         }
         if(_loc3_ is ScratchSprite)
         {
            _loc4_ = ScratchSprite(_loc3_);
            if("x position" == _loc2_)
            {
               return _loc4_.scratchX;
            }
            if("y position" == _loc2_)
            {
               return _loc4_.scratchY;
            }
            if("direction" == _loc2_)
            {
               return _loc4_.direction;
            }
            if("costume #" == _loc2_)
            {
               return _loc4_.costumeNumber();
            }
            if("costume name" == _loc2_)
            {
               return _loc4_.currentCostume().costumeName;
            }
            if("size" == _loc2_)
            {
               return _loc4_.getSize();
            }
            if("volume" == _loc2_)
            {
               return _loc4_.volume;
            }
         }
         if(_loc3_ is ScratchStage)
         {
            if("background #" == _loc2_)
            {
               return _loc3_.costumeNumber();
            }
            if("backdrop #" == _loc2_)
            {
               return _loc3_.costumeNumber();
            }
            if("backdrop name" == _loc2_)
            {
               return _loc3_.currentCostume().costumeName;
            }
            if("volume" == _loc2_)
            {
               return _loc3_.volume;
            }
         }
         if(_loc3_.ownsVar(_loc2_))
         {
            return _loc3_.lookupVar(_loc2_).value;
         }
         return 0;
      }
      
      private function mouseOrSpritePosition(param1:String) : Point
      {
         var _loc2_:ScratchStage = null;
         var _loc3_:ScratchSprite = null;
         if(param1 == "_mouse_")
         {
            _loc2_ = this.app.stagePane;
            return new Point(_loc2_.scratchMouseX(),_loc2_.scratchMouseY());
         }
         _loc3_ = this.app.stagePane.spriteNamed(param1);
         if(_loc3_ == null)
         {
            return null;
         }
         return new Point(_loc3_.scratchX,_loc3_.scratchY);
      }
      
      private function primShowWatcher(param1:Block) : *
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_)
         {
            this.app.runtime.showVarOrListFor(this.interp.arg(param1,0),false,_loc2_);
         }
      }
      
      private function primHideWatcher(param1:Block) : *
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_)
         {
            this.app.runtime.hideVarOrListFor(this.interp.arg(param1,0),false,_loc2_);
         }
      }
      
      private function primShowListWatcher(param1:Block) : *
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_)
         {
            this.app.runtime.showVarOrListFor(this.interp.arg(param1,0),true,_loc2_);
         }
      }
      
      private function primHideListWatcher(param1:Block) : *
      {
         var _loc2_:ScratchObj = this.interp.targetObj();
         if(_loc2_)
         {
            this.app.runtime.hideVarOrListFor(this.interp.arg(param1,0),true,_loc2_);
         }
      }
      
      private function primTimestamp(param1:Block) : *
      {
         var _loc2_:int = 24 * 60 * 60 * 1000;
         var _loc3_:Date = new Date(2000,0,1);
         var _loc4_:Date = new Date();
         var _loc5_:int = _loc4_.timezoneOffset - _loc3_.timezoneOffset;
         var _loc6_:Number = _loc4_.time - _loc3_.time;
         _loc6_ += (_loc4_.timezoneOffset - _loc5_) * 60 * 1000;
         return _loc6_ / _loc2_;
      }
   }
}

