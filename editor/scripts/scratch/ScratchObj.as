package scratch
{
   import blocks.*;
   import filters.FilterPack;
   import flash.display.*;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.*;
   import interpreter.*;
   import translation.Translator;
   import util.*;
   import watchers.*;
   
   public class ScratchObj extends Sprite
   {
      
      protected static var Pop:Class = ScratchObj_Pop;
      
      public static const STAGEW:int = 480;
      
      public static const STAGEH:int = 360;
      
      private static var cTrans:ColorTransform = new ColorTransform();
      
      public static const clearColorTrans:ColorTransform = new ColorTransform();
      
      public var objName:String = "no name";
      
      public var isStage:Boolean = false;
      
      public var variables:Array = [];
      
      public var lists:Array = [];
      
      public var scripts:Array = [];
      
      public var scriptComments:Array = [];
      
      public var sounds:Array = [];
      
      public var costumes:Array = [];
      
      public var currentCostumeIndex:Number;
      
      public var volume:Number = 100;
      
      public var instrument:int = 0;
      
      public var filterPack:FilterPack;
      
      public var isClone:Boolean;
      
      public var img:Sprite;
      
      private var lastCostume:ScratchCostume;
      
      public var listCache:Object = {};
      
      public var procCache:Object = {};
      
      public var varCache:Object = {};
      
      private const DOUBLE_CLICK_MSECS:int = 300;
      
      private var lastClickTime:uint;
      
      public function ScratchObj()
      {
         super();
      }
      
      protected static function h1(param1:String, param2:String = "=") : String
      {
         return param1 + "\n" + new Array(param1.length + 1).join(param2) + "\n";
      }
      
      protected static function h2(param1:String) : String
      {
         return h1(param1,"-");
      }
      
      public function clearCaches() : void
      {
         this.listCache = {};
         this.procCache = {};
         this.varCache = {};
      }
      
      public function allObjects() : Array
      {
         return [this];
      }
      
      public function deleteCostume(param1:ScratchCostume) : void
      {
         if(this.costumes.length < 2)
         {
            return;
         }
         var _loc2_:int = this.costumes.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         this.costumes.splice(_loc2_,1);
         if(this.currentCostumeIndex >= _loc2_)
         {
            this.showCostume(this.currentCostumeIndex - 1);
         }
         if(Scratch.app)
         {
            Scratch.app.setSaveNeeded();
         }
      }
      
      public function deleteSound(param1:ScratchSound) : void
      {
         var _loc2_:int = this.sounds.indexOf(param1);
         if(_loc2_ < 0)
         {
            return;
         }
         this.sounds.splice(_loc2_,1);
         if(Scratch.app)
         {
            Scratch.app.setSaveNeeded();
         }
      }
      
      public function showCostumeNamed(param1:String) : void
      {
         var _loc2_:int = this.indexOfCostumeNamed(param1);
         if(_loc2_ >= 0)
         {
            this.showCostume(_loc2_);
         }
      }
      
      public function indexOfCostumeNamed(param1:String) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this.costumes.length)
         {
            if(ScratchCostume(this.costumes[_loc2_]).costumeName == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return -1;
      }
      
      public function showCostume(param1:Number) : void
      {
         if(this.isNaNOrInfinity(param1))
         {
            param1 = 0;
         }
         this.currentCostumeIndex = param1 % this.costumes.length;
         if(this.currentCostumeIndex < 0)
         {
            this.currentCostumeIndex += this.costumes.length;
         }
         var _loc2_:ScratchCostume = this.currentCostume();
         if(_loc2_ == this.lastCostume)
         {
            return;
         }
         this.lastCostume = _loc2_.isBitmap() ? _loc2_ : null;
         this.updateImage();
      }
      
      public function updateCostume() : void
      {
         this.updateImage();
      }
      
      public function currentCostume() : ScratchCostume
      {
         return this.costumes[Math.round(this.currentCostumeIndex) % this.costumes.length];
      }
      
      public function costumeNumber() : int
      {
         return this.currentCostumeIndex + 1;
      }
      
      public function unusedCostumeName(param1:String = "") : String
      {
         var _loc3_:ScratchCostume = null;
         var _loc4_:String = null;
         if(param1 == "")
         {
            param1 = Translator.map(this.isStage ? "backdrop1" : "costume1");
         }
         var _loc2_:Array = [];
         for each(_loc3_ in this.costumes)
         {
            _loc2_.push(_loc3_.costumeName.toLowerCase());
         }
         _loc4_ = param1.toLowerCase();
         if(_loc2_.indexOf(_loc4_) < 0)
         {
            return param1;
         }
         _loc4_ = this.withoutTrailingDigits(_loc4_);
         var _loc5_:int = 2;
         while(_loc2_.indexOf(_loc4_ + _loc5_) >= 0)
         {
            _loc5_++;
         }
         return this.withoutTrailingDigits(param1) + _loc5_;
      }
      
      public function unusedSoundName(param1:String = "") : String
      {
         var _loc3_:ScratchSound = null;
         var _loc4_:String = null;
         if(param1 == "")
         {
            param1 = "sound";
         }
         var _loc2_:Array = [];
         for each(_loc3_ in this.sounds)
         {
            _loc2_.push(_loc3_.soundName.toLowerCase());
         }
         _loc4_ = param1.toLowerCase();
         if(_loc2_.indexOf(_loc4_) < 0)
         {
            return param1;
         }
         _loc4_ = this.withoutTrailingDigits(_loc4_);
         var _loc5_:int = 2;
         while(_loc2_.indexOf(_loc4_ + _loc5_) >= 0)
         {
            _loc5_++;
         }
         return this.withoutTrailingDigits(param1) + _loc5_;
      }
      
      protected function withoutTrailingDigits(param1:String) : String
      {
         var _loc2_:* = int(param1.length - 1);
         while(_loc2_ >= 0 && "0123456789".indexOf(param1.charAt(_loc2_)) > -1)
         {
            _loc2_--;
         }
         return param1.slice(0,_loc2_ + 1);
      }
      
      protected function updateImage() : void
      {
         var _loc1_:DisplayObject = this.img.numChildren == 1 ? this.img.getChildAt(0) : null;
         var _loc2_:DisplayObject = this.currentCostume().displayObj();
         var _loc3_:Boolean = _loc1_ != _loc2_;
         if(_loc3_)
         {
            while(this.img.numChildren > 0)
            {
               this.img.removeChildAt(0);
            }
            this.img.addChild(_loc2_);
         }
         this.clearCachedBitmap();
         this.adjustForRotationCenter();
         this.updateRenderDetails(0);
      }
      
      protected function updateRenderDetails(param1:uint) : void
      {
         var _loc2_:Object = null;
         var _loc3_:ScratchCostume = null;
         var _loc4_:String = null;
         if(this is ScratchStage || this is ScratchSprite || Boolean(parent) && Boolean(parent is ScratchStage))
         {
            _loc2_ = {};
            _loc3_ = this.currentCostume();
            if(param1 == 0)
            {
               if(Boolean(_loc3_) && _loc3_.baseLayerID == ScratchCostume.WasEdited)
               {
                  _loc3_.prepareToSave();
               }
               _loc4_ = _loc3_ ? _loc3_.baseLayerMD5 : null;
               if(!_loc4_)
               {
                  _loc4_ = this.objName + (_loc3_ ? _loc3_.costumeName : "_" + this.currentCostumeIndex);
               }
               else if(Boolean(_loc3_) && Boolean(_loc3_.textLayerMD5))
               {
                  _loc4_ += _loc3_.textLayerMD5;
               }
               _loc2_.bitmap = Boolean(_loc3_) && Boolean(_loc3_.bitmap) ? _loc3_.bitmap : null;
            }
            if(param1 == 1)
            {
               _loc2_.costumeFlipped = this is ScratchSprite ? (this as ScratchSprite).isCostumeFlipped() : false;
            }
            if(param1 == 0)
            {
               if(this is ScratchSprite)
               {
                  _loc2_.bounds = (this as ScratchSprite).getVisibleBounds(this);
                  _loc2_.raw_bounds = getBounds(this);
               }
               else
               {
                  _loc2_.bounds = getBounds(this);
               }
            }
            if(Scratch.app.isIn3D)
            {
               Scratch.app.render3D.updateRender(this is ScratchStage ? this.img : this,_loc4_,_loc2_);
            }
         }
      }
      
      protected function adjustForRotationCenter() : void
      {
         var _loc2_:ScratchCostume = null;
         var _loc1_:DisplayObject = this.img.getChildAt(0);
         if(this.isStage)
         {
            if(_loc1_ is Bitmap)
            {
               this.img.x = (STAGEW - _loc1_.width) / 2;
               this.img.y = (STAGEH - _loc1_.height) / 2;
            }
            else
            {
               this.img.x = this.img.y = 0;
            }
         }
         else
         {
            _loc2_ = this.currentCostume();
            _loc1_.scaleX = 1 / _loc2_.bitmapResolution;
            this.img.x = -_loc2_.rotationCenterX / _loc2_.bitmapResolution;
            this.img.y = -_loc2_.rotationCenterY / _loc2_.bitmapResolution;
            if((this as ScratchSprite).isCostumeFlipped())
            {
               _loc1_.scaleX = -1 / _loc2_.bitmapResolution;
               this.img.x = -this.img.x;
            }
         }
      }
      
      public function clearCachedBitmap() : void
      {
      }
      
      public function applyFilters(param1:Boolean = false) : void
      {
         var _loc2_:Number = NaN;
         this.img.filters = this.filterPack.buildFilters(param1);
         this.clearCachedBitmap();
         if(!Scratch.app.isIn3D || param1)
         {
            _loc2_ = Math.max(0,Math.min(this.filterPack.getFilterSetting("ghost"),100));
            cTrans.alphaMultiplier = 1 - _loc2_ / 100;
            _loc2_ = 255 * Math.max(-100,Math.min(this.filterPack.getFilterSetting("brightness"),100)) / 100;
            cTrans.redOffset = cTrans.greenOffset = cTrans.blueOffset = _loc2_;
            this.img.transform.colorTransform = cTrans;
         }
         else
         {
            this.updateEffectsFor3D();
         }
      }
      
      public function updateEffectsFor3D() : void
      {
         if(Boolean(parent) && Boolean(parent is ScratchStage) || this is ScratchStage)
         {
            if(parent is ScratchStage)
            {
               (parent as ScratchStage).updateSpriteEffects(this,this.filterPack.getAllSettings());
            }
            else
            {
               (this as ScratchStage).updateSpriteEffects(this.img,this.filterPack.getAllSettings());
            }
         }
      }
      
      protected function shapeChangedByFilter() : Boolean
      {
         var _loc1_:Object = this.filterPack.getAllSettings();
         return _loc1_["fisheye"] !== 0 || _loc1_["whirl"] !== 0 || _loc1_["mosaic"] !== 0;
      }
      
      public function clearFilters() : void
      {
         this.filterPack.resetAllFilters();
         this.img.filters = [];
         this.img.transform.colorTransform = clearColorTrans;
         this.clearCachedBitmap();
         if(Boolean(parent) && parent is ScratchStage)
         {
            (parent as ScratchStage).updateSpriteEffects(this,null);
         }
      }
      
      public function setMedia(param1:Array, param2:ScratchCostume) : void
      {
         var _loc4_:* = undefined;
         var _loc3_:Array = [];
         this.sounds = [];
         for each(_loc4_ in param1)
         {
            if(_loc4_ is ScratchSound)
            {
               this.sounds.push(_loc4_);
            }
            if(_loc4_ is ScratchCostume)
            {
               _loc3_.push(_loc4_);
            }
         }
         if(_loc3_.length > 0)
         {
            this.costumes = _loc3_;
         }
         var _loc5_:int = this.costumes.indexOf(param2);
         this.currentCostumeIndex = _loc5_ < 0 ? 0 : _loc5_;
         this.showCostume(_loc5_);
      }
      
      public function defaultArgsFor(param1:String, param2:Array) : Array
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         if(["broadcast:","doBroadcastAndWait","whenIReceive"].indexOf(param1) > -1)
         {
            _loc4_ = Scratch.app.runtime.collectBroadcasts();
            return [_loc4_[0]];
         }
         if(["lookLike:","startScene","startSceneAndWait","whenSceneStarts"].indexOf(param1) > -1)
         {
            return [this.costumes[this.costumes.length - 1].costumeName];
         }
         if(["playSound:","doPlaySoundAndWait"].indexOf(param1) > -1)
         {
            return this.sounds.length > 0 ? [this.sounds[this.sounds.length - 1].soundName] : [""];
         }
         if("createCloneOf" == param1)
         {
            if(!this.isStage)
            {
               return ["_myself_"];
            }
            _loc3_ = Scratch.app.stagePane.sprites();
            return _loc3_.length > 0 ? [_loc3_[_loc3_.length - 1].objName] : [""];
         }
         if("getAttribute:of:" == param1)
         {
            _loc3_ = Scratch.app.stagePane.sprites();
            return _loc3_.length > 0 ? ["x position",_loc3_[_loc3_.length - 1].objName] : ["volume","_stage_"];
         }
         if("setVar:to:" == param1)
         {
            return [this.defaultVarName(),0];
         }
         if("changeVar:by:" == param1)
         {
            return [this.defaultVarName(),1];
         }
         if("showVariable:" == param1)
         {
            return [this.defaultVarName()];
         }
         if("hideVariable:" == param1)
         {
            return [this.defaultVarName()];
         }
         if("append:toList:" == param1)
         {
            return ["thing",this.defaultListName()];
         }
         if("deleteLine:ofList:" == param1)
         {
            return [1,this.defaultListName()];
         }
         if("insert:at:ofList:" == param1)
         {
            return ["thing",1,this.defaultListName()];
         }
         if("setLine:ofList:to:" == param1)
         {
            return [1,this.defaultListName(),"thing"];
         }
         if("getLine:ofList:" == param1)
         {
            return [1,this.defaultListName()];
         }
         if("lineCountOfList:" == param1)
         {
            return [this.defaultListName()];
         }
         if("list:contains:" == param1)
         {
            return [this.defaultListName(),"thing"];
         }
         if("showList:" == param1)
         {
            return [this.defaultListName()];
         }
         if("hideList:" == param1)
         {
            return [this.defaultListName()];
         }
         return param2;
      }
      
      public function defaultVarName() : String
      {
         if(this.variables.length > 0)
         {
            return this.variables[this.variables.length - 1].name;
         }
         return this.isStage ? "" : Scratch.app.stagePane.defaultVarName();
      }
      
      public function defaultListName() : String
      {
         if(this.lists.length > 0)
         {
            return this.lists[this.lists.length - 1].listName;
         }
         return this.isStage ? "" : Scratch.app.stagePane.defaultListName();
      }
      
      public function allBlocks() : Array
      {
         var result:Array = null;
         var script:Block = null;
         result = [];
         for each(script in this.scripts)
         {
            script.allBlocksDo(function(param1:Block):void
            {
               result.push(param1);
            });
         }
         return result;
      }
      
      public function findSound(param1:*) : ScratchSound
      {
         var _loc2_:int = 0;
         var _loc3_:ScratchSound = null;
         var _loc4_:Number = NaN;
         if(this.sounds.length == 0)
         {
            return null;
         }
         if(typeof param1 == "number")
         {
            _loc2_ = Math.round(param1 - 1) % this.sounds.length;
            if(_loc2_ < 0)
            {
               _loc2_ += this.sounds.length;
            }
            return this.sounds[_loc2_];
         }
         if(typeof param1 == "string")
         {
            for each(_loc3_ in this.sounds)
            {
               if(_loc3_.soundName == param1)
               {
                  return _loc3_;
               }
            }
            _loc4_ = Number(param1);
            if(isNaN(_loc4_))
            {
               return null;
            }
            return this.findSound(_loc4_);
         }
         return null;
      }
      
      public function setVolume(param1:Number) : void
      {
         this.volume = Math.max(0,Math.min(param1,100));
      }
      
      public function setInstrument(param1:Number) : void
      {
         this.instrument = Math.max(1,Math.min(Math.round(param1),128));
      }
      
      public function procedureDefinitions() : Array
      {
         var _loc3_:Block = null;
         var _loc1_:Array = [];
         var _loc2_:int = 0;
         while(_loc2_ < this.scripts.length)
         {
            _loc3_ = this.scripts[_loc2_] as Block;
            if(Boolean(_loc3_) && _loc3_.op == Specs.PROCEDURE_DEF)
            {
               _loc1_.push(_loc3_);
            }
            _loc2_++;
         }
         return _loc1_;
      }
      
      public function lookupProcedure(param1:String) : Block
      {
         var _loc3_:Block = null;
         var _loc2_:int = 0;
         while(_loc2_ < this.scripts.length)
         {
            _loc3_ = this.scripts[_loc2_] as Block;
            if(Boolean(_loc3_) && Boolean(_loc3_.op == Specs.PROCEDURE_DEF) && _loc3_.spec == param1)
            {
               return _loc3_;
            }
            _loc2_++;
         }
         return null;
      }
      
      public function varNames() : Array
      {
         var _loc2_:Variable = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.variables)
         {
            _loc1_.push(_loc2_.name);
         }
         return _loc1_;
      }
      
      public function setVarTo(param1:String, param2:*) : void
      {
         var _loc3_:Variable = this.lookupOrCreateVar(param1);
         _loc3_.value = param2;
         Scratch.app.runtime.updateVariable(_loc3_);
      }
      
      public function ownsVar(param1:String) : Boolean
      {
         var _loc2_:Variable = null;
         for each(_loc2_ in this.variables)
         {
            if(_loc2_.name == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function hasName(param1:String) : Boolean
      {
         var _loc2_:ScratchObj = parent as ScratchObj;
         return this.ownsVar(param1) || this.ownsList(param1) || Boolean(_loc2_) && (_loc2_.ownsVar(param1) || _loc2_.ownsList(param1));
      }
      
      public function lookupOrCreateVar(param1:String) : Variable
      {
         var _loc2_:Variable = this.lookupVar(param1);
         if(_loc2_ == null)
         {
            _loc2_ = new Variable(param1,0);
            this.variables.push(_loc2_);
            Scratch.app.updatePalette(false);
         }
         return _loc2_;
      }
      
      public function lookupVar(param1:String) : Variable
      {
         var _loc2_:Variable = null;
         for each(_loc2_ in this.variables)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         for each(_loc2_ in Scratch.app.stagePane.variables)
         {
            if(_loc2_.name == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function deleteVar(param1:String) : void
      {
         var _loc3_:Variable = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.variables)
         {
            if(_loc3_.name == param1)
            {
               if(_loc3_.watcher != null && _loc3_.watcher.parent != null)
               {
                  _loc3_.watcher.parent.removeChild(_loc3_.watcher);
               }
               _loc3_.watcher = _loc3_.value = null;
            }
            else
            {
               _loc2_.push(_loc3_);
            }
         }
         this.variables = _loc2_;
      }
      
      public function listNames() : Array
      {
         var _loc2_:ListWatcher = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.lists)
         {
            _loc1_.push(_loc2_.listName);
         }
         return _loc1_;
      }
      
      public function ownsList(param1:String) : Boolean
      {
         var _loc2_:ListWatcher = null;
         for each(_loc2_ in this.lists)
         {
            if(_loc2_.listName == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function lookupOrCreateList(param1:String) : ListWatcher
      {
         var _loc2_:ListWatcher = this.lookupList(param1);
         if(_loc2_ == null)
         {
            _loc2_ = new ListWatcher(param1,[],this);
            this.lists.push(_loc2_);
            Scratch.app.updatePalette(false);
         }
         return _loc2_;
      }
      
      public function lookupList(param1:String) : ListWatcher
      {
         var _loc2_:ListWatcher = null;
         for each(_loc2_ in this.lists)
         {
            if(_loc2_.listName == param1)
            {
               return _loc2_;
            }
         }
         for each(_loc2_ in Scratch.app.stagePane.lists)
         {
            if(_loc2_.listName == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function deleteList(param1:String) : void
      {
         var _loc3_:ListWatcher = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.lists)
         {
            if(_loc3_.listName == param1)
            {
               if(_loc3_.parent)
               {
                  _loc3_.parent.removeChild(_loc3_);
               }
            }
            else
            {
               _loc2_.push(_loc3_);
            }
         }
         this.lists = _loc2_;
      }
      
      public function click(param1:MouseEvent) : void
      {
         var _loc2_:Scratch = root as Scratch;
         if(!_loc2_)
         {
            return;
         }
         var _loc3_:uint = uint(CachedTimer.getCachedTimer());
         _loc2_.runtime.startClickedHats(this);
         if(_loc3_ - this.lastClickTime < this.DOUBLE_CLICK_MSECS)
         {
            if(this.isStage || ScratchSprite(this).isClone)
            {
               return;
            }
            _loc2_.selectSprite(this);
            this.lastClickTime = 0;
         }
         else
         {
            this.lastClickTime = _loc3_;
         }
      }
      
      public function updateScriptsAfterTranslation() : void
      {
         var _loc2_:Block = null;
         var _loc3_:Array = null;
         var _loc4_:ScratchComment = null;
         var _loc5_:Block = null;
         var _loc1_:Array = [];
         for each(_loc2_ in this.scripts)
         {
            _loc5_ = BlockIO.arrayToStack(BlockIO.stackToArray(_loc2_),this.isStage);
            _loc5_.x = _loc2_.x;
            _loc5_.y = _loc2_.y;
            _loc1_.push(_loc5_);
            if(_loc2_.parent)
            {
               _loc2_.parent.addChild(_loc5_);
               _loc2_.parent.removeChild(_loc2_);
            }
         }
         this.scripts = _loc1_;
         _loc3_ = this.allBlocks();
         for each(_loc4_ in this.scriptComments)
         {
            _loc4_.updateBlockRef(_loc3_);
         }
      }
      
      public function writeJSON(param1:util.JSON) : void
      {
         var _loc3_:Block = null;
         var _loc4_:Array = null;
         var _loc5_:ScratchComment = null;
         var _loc2_:Array = [];
         for each(_loc3_ in this.scripts)
         {
            _loc2_.push([_loc3_.x,_loc3_.y,BlockIO.stackToArray(_loc3_)]);
         }
         _loc4_ = [];
         for each(_loc5_ in this.scriptComments)
         {
            _loc4_.push(_loc5_.toArray());
         }
         param1.writeKeyValue("objName",this.objName);
         if(this.variables.length > 0)
         {
            param1.writeKeyValue("variables",this.variables);
         }
         if(this.lists.length > 0)
         {
            param1.writeKeyValue("lists",this.lists);
         }
         if(this.scripts.length > 0)
         {
            param1.writeKeyValue("scripts",_loc2_);
         }
         if(this.scriptComments.length > 0)
         {
            param1.writeKeyValue("scriptComments",_loc4_);
         }
         if(this.sounds.length > 0)
         {
            param1.writeKeyValue("sounds",this.sounds);
         }
         param1.writeKeyValue("costumes",this.costumes);
         param1.writeKeyValue("currentCostumeIndex",this.currentCostumeIndex);
      }
      
      public function readJSON(param1:Object) : void
      {
         var _loc3_:Object = null;
         this.objName = param1.objName;
         this.variables = param1.variables || [];
         var _loc2_:int = 0;
         while(_loc2_ < this.variables.length)
         {
            _loc3_ = this.variables[_loc2_];
            this.variables[_loc2_] = Scratch.app.runtime.makeVariable(_loc3_);
            _loc2_++;
         }
         this.lists = param1.lists || [];
         this.scripts = param1.scripts || [];
         this.scriptComments = param1.scriptComments || [];
         this.sounds = param1.sounds || [];
         this.costumes = param1.costumes || [];
         this.currentCostumeIndex = param1.currentCostumeIndex;
         if(this.isNaNOrInfinity(this.currentCostumeIndex))
         {
            this.currentCostumeIndex = 0;
         }
      }
      
      private function isNaNOrInfinity(param1:Number) : Boolean
      {
         if(param1 != param1)
         {
            return true;
         }
         if(param1 == Number.POSITIVE_INFINITY)
         {
            return true;
         }
         if(param1 == Number.NEGATIVE_INFINITY)
         {
            return true;
         }
         return false;
      }
      
      public function instantiateFromJSON(param1:ScratchStage) : void
      {
         var _loc2_:int = 0;
         var _loc3_:Object = null;
         var _loc4_:ListWatcher = null;
         var _loc5_:Array = null;
         var _loc6_:Block = null;
         _loc2_ = 0;
         while(_loc2_ < this.lists.length)
         {
            _loc3_ = this.lists[_loc2_];
            _loc4_ = new ListWatcher();
            _loc4_.readJSON(_loc3_);
            _loc4_.target = this;
            param1.addChild(_loc4_);
            _loc4_.updateTitleAndContents();
            this.lists[_loc2_] = _loc4_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.scripts.length)
         {
            _loc5_ = this.scripts[_loc2_];
            _loc6_ = BlockIO.arrayToStack(_loc5_[2],this.isStage);
            _loc6_.x = _loc5_[0];
            _loc6_.y = _loc5_[1];
            this.scripts[_loc2_] = _loc6_;
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.scriptComments.length)
         {
            this.scriptComments[_loc2_] = ScratchComment.fromArray(this.scriptComments[_loc2_]);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.sounds.length)
         {
            _loc3_ = this.sounds[_loc2_];
            this.sounds[_loc2_] = new ScratchSound("json temp",null);
            this.sounds[_loc2_].readJSON(_loc3_);
            _loc2_++;
         }
         _loc2_ = 0;
         while(_loc2_ < this.costumes.length)
         {
            _loc3_ = this.costumes[_loc2_];
            this.costumes[_loc2_] = new ScratchCostume("json temp",null);
            this.costumes[_loc2_].readJSON(_loc3_);
            _loc2_++;
         }
      }
      
      public function getSummary() : String
      {
         var _loc2_:ScratchCostume = null;
         var _loc3_:Variable = null;
         var _loc4_:ListWatcher = null;
         var _loc5_:* = undefined;
         var _loc6_:ScratchSound = null;
         var _loc7_:Block = null;
         var _loc1_:Array = [];
         _loc1_.push(h1(this.objName));
         if(this.variables.length)
         {
            _loc1_.push(h2(Translator.map("Variables")));
            for each(_loc3_ in this.variables)
            {
               _loc1_.push("- " + _loc3_.name + " = " + _loc3_.value);
            }
            _loc1_.push("");
         }
         if(this.lists.length)
         {
            _loc1_.push(h2(Translator.map("Lists")));
            for each(_loc4_ in this.lists)
            {
               _loc1_.push("- " + _loc4_.listName + (_loc4_.contents.length ? ":" : ""));
               for each(_loc5_ in _loc4_.contents)
               {
                  _loc1_.push("    - " + _loc5_);
               }
            }
            _loc1_.push("");
         }
         _loc1_.push(h2(Translator.map(this.isStage ? "Backdrops" : "Costumes")));
         for each(_loc2_ in this.costumes)
         {
            _loc1_.push("- " + _loc2_.costumeName);
         }
         _loc1_.push("");
         if(this.sounds.length)
         {
            _loc1_.push(h2(Translator.map("Sounds")));
            for each(_loc6_ in this.sounds)
            {
               _loc1_.push("- " + _loc6_.soundName);
            }
            _loc1_.push("");
         }
         if(this.scripts.length)
         {
            _loc1_.push(h2(Translator.map("Scripts")));
            for each(_loc7_ in this.scripts)
            {
               _loc1_.push(_loc7_.getSummary());
               _loc1_.push("");
            }
         }
         return _loc1_.join("\n");
      }
   }
}

