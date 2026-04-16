package ui.media
{
   import assets.Resources;
   import flash.display.Sprite;
   import flash.geom.Point;
   import flash.text.TextField;
   import scratch.*;
   import ui.parts.SoundsPart;
   import uiwidgets.*;
   
   public class MediaPane extends ScrollFrameContents
   {
      
      public var app:Scratch;
      
      private var isSound:Boolean;
      
      private var lastCostume:ScratchCostume;
      
      public function MediaPane(param1:Scratch, param2:String)
      {
         super();
         this.app = param1;
         this.isSound = param2 == "sounds";
         this.refresh();
      }
      
      public function refresh() : void
      {
         if(this.app.viewedObj() == null)
         {
            return;
         }
         this.replaceContents(this.isSound ? this.soundItems() : this.costumeItems());
         this.updateSelection();
      }
      
      public function updateSelection() : Boolean
      {
         if(this.isSound)
         {
            this.updateSoundSelection();
            return true;
         }
         return this.updateCostumeSelection();
      }
      
      private function replaceContents(param1:Array) : void
      {
         var _loc2_:int = 0;
         var _loc4_:Sprite = null;
         var _loc5_:TextField = null;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         _loc2_ = 3;
         var _loc3_:* = 1;
         for each(_loc4_ in param1)
         {
            _loc5_ = Resources.makeLabel("" + _loc3_++,CSS.thumbnailExtraInfoFormat);
            _loc5_.x = 9;
            _loc5_.y = _loc2_ + 1;
            _loc4_.x = 7;
            _loc4_.y = _loc2_;
            _loc2_ += _loc4_.height + 3;
            addChild(_loc4_);
            addChild(_loc5_);
         }
         updateSize();
         this.lastCostume = null;
         x = y = 0;
      }
      
      private function costumeItems() : Array
      {
         var _loc3_:ScratchCostume = null;
         var _loc1_:Array = [];
         var _loc2_:ScratchObj = this.app.viewedObj();
         for each(_loc3_ in _loc2_.costumes)
         {
            _loc1_.push(Scratch.app.createMediaInfo(_loc3_,_loc2_));
         }
         return _loc1_;
      }
      
      private function soundItems() : Array
      {
         var _loc3_:ScratchSound = null;
         var _loc1_:Array = [];
         var _loc2_:ScratchObj = this.app.viewedObj();
         for each(_loc3_ in _loc2_.sounds)
         {
            _loc1_.push(Scratch.app.createMediaInfo(_loc3_,_loc2_));
         }
         return _loc1_;
      }
      
      private function updateCostumeSelection() : Boolean
      {
         var _loc5_:MediaInfo = null;
         var _loc1_:ScratchObj = this.app.viewedObj();
         if(_loc1_ == null || this.isSound)
         {
            return false;
         }
         var _loc2_:ScratchCostume = _loc1_.currentCostume();
         if(_loc2_ == this.lastCostume)
         {
            return false;
         }
         var _loc3_:ScratchCostume = this.lastCostume;
         var _loc4_:int = 0;
         while(_loc4_ < numChildren)
         {
            _loc5_ = getChildAt(_loc4_) as MediaInfo;
            if(_loc5_ != null)
            {
               if(_loc5_.mycostume == _loc2_)
               {
                  _loc5_.highlight();
                  this.scrollToItem(_loc5_);
               }
               else
               {
                  _loc5_.unhighlight();
               }
            }
            _loc4_++;
         }
         this.lastCostume = _loc2_;
         return _loc3_ != null;
      }
      
      private function scrollToItem(param1:MediaInfo) : void
      {
         var _loc2_:ScrollFrame = parent as ScrollFrame;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:int = param1.y + y - 1;
         var _loc4_:int = _loc3_ + param1.height;
         y -= Math.max(0,_loc4_ - _loc2_.visibleH());
         y -= Math.min(0,_loc3_);
         _loc2_.updateScrollbars();
      }
      
      private function updateSoundSelection() : void
      {
         var _loc5_:MediaInfo = null;
         var _loc1_:ScratchObj = this.app.viewedObj();
         if(_loc1_ == null || !this.isSound)
         {
            return;
         }
         if(_loc1_.sounds.length < 1)
         {
            return;
         }
         if(!this.parent || !this.parent.parent)
         {
            return;
         }
         var _loc2_:SoundsPart = this.parent.parent as SoundsPart;
         if(_loc2_ == null)
         {
            return;
         }
         _loc2_.currentIndex = Math.min(_loc2_.currentIndex,_loc1_.sounds.length - 1);
         var _loc3_:ScratchSound = _loc1_.sounds[_loc2_.currentIndex] as ScratchSound;
         var _loc4_:int = 0;
         while(_loc4_ < numChildren)
         {
            _loc5_ = getChildAt(_loc4_) as MediaInfo;
            if(_loc5_ != null)
            {
               if(_loc5_.mysound == _loc3_)
               {
                  _loc5_.highlight();
               }
               else
               {
                  _loc5_.unhighlight();
               }
            }
            _loc4_++;
         }
      }
      
      public function handleDrop(param1:*) : Boolean
      {
         var _loc2_:MediaInfo = param1 as MediaInfo;
         if(Boolean(_loc2_) && _loc2_.owner == this.app.viewedObj())
         {
            this.changeMediaOrder(_loc2_);
            return true;
         }
         return false;
      }
      
      private function changeMediaOrder(param1:MediaInfo) : void
      {
         var _loc6_:MediaInfo = null;
         var _loc2_:Boolean = false;
         var _loc3_:Array = [];
         var _loc4_:int = globalToLocal(new Point(param1.x,param1.y)).y;
         var _loc5_:int = 0;
         while(_loc5_ < numChildren)
         {
            _loc6_ = getChildAt(_loc5_) as MediaInfo;
            if(_loc6_)
            {
               if(!_loc2_ && _loc4_ < _loc6_.y)
               {
                  _loc3_.push(param1);
                  _loc2_ = true;
               }
               if(!this.sameMedia(_loc6_,param1))
               {
                  _loc3_.push(_loc6_);
               }
            }
            _loc5_++;
         }
         if(!_loc2_)
         {
            _loc3_.push(param1);
         }
         this.replacedMedia(_loc3_);
      }
      
      private function sameMedia(param1:MediaInfo, param2:MediaInfo) : Boolean
      {
         if(Boolean(param1.mycostume) && param1.mycostume == param2.mycostume)
         {
            return true;
         }
         if(Boolean(param1.mysound) && param1.mysound == param2.mysound)
         {
            return true;
         }
         return false;
      }
      
      private function replacedMedia(param1:Array) : void
      {
         var _loc2_:MediaInfo = null;
         var _loc4_:ScratchCostume = null;
         var _loc5_:int = 0;
         var _loc3_:ScratchObj = this.app.viewedObj();
         if(this.isSound)
         {
            _loc3_.sounds.splice(0);
            for each(_loc2_ in param1)
            {
               if(_loc2_.mysound)
               {
                  _loc3_.sounds.push(_loc2_.mysound);
               }
            }
         }
         else
         {
            _loc4_ = _loc3_.currentCostume();
            _loc3_.costumes.splice(0);
            for each(_loc2_ in param1)
            {
               if(_loc2_.mycostume)
               {
                  _loc3_.costumes.push(_loc2_.mycostume);
               }
            }
            _loc5_ = _loc3_.costumes.indexOf(_loc4_);
            if(_loc5_ > -1)
            {
               _loc3_.currentCostumeIndex = _loc5_;
            }
         }
         this.app.setSaveNeeded();
         this.refresh();
      }
   }
}

