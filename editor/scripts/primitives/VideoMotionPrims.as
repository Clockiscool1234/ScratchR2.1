package primitives
{
   import blocks.Block;
   import flash.display.*;
   import flash.geom.*;
   import flash.utils.*;
   import interpreter.*;
   import scratch.*;
   
   public class VideoMotionPrims
   {
      
      public static var readMotionSensor:Function;
      
      private const toDegree:Number = 57.29577951308232;
      
      private const WIDTH:int = 480;
      
      private const HEIGHT:int = 360;
      
      private const AMOUNT_SCALE:int = 100;
      
      private const THRESHOLD:int = 10;
      
      private const WINSIZE:int = 8;
      
      private var app:Scratch;
      
      private var interp:Interpreter;
      
      private var gradA2Array:Vector.<Number> = new Vector.<Number>(this.WIDTH * this.HEIGHT,true);
      
      private var gradA1B2Array:Vector.<Number> = new Vector.<Number>(this.WIDTH * this.HEIGHT,true);
      
      private var gradB1Array:Vector.<Number> = new Vector.<Number>(this.WIDTH * this.HEIGHT,true);
      
      private var gradC2Array:Vector.<Number> = new Vector.<Number>(this.WIDTH * this.HEIGHT,true);
      
      private var gradC1Array:Vector.<Number> = new Vector.<Number>(this.WIDTH * this.HEIGHT,true);
      
      private var motionAmount:int;
      
      private var motionDirection:int;
      
      private var analysisDone:Boolean;
      
      private var frameNum:int;
      
      private var frameBuffer:BitmapData;
      
      private var curr:Vector.<uint>;
      
      private var prev:Vector.<uint>;
      
      public function VideoMotionPrims(param1:Scratch, param2:Interpreter)
      {
         super();
         this.app = param1;
         this.interp = param2;
         this.frameBuffer = new BitmapData(this.WIDTH,this.HEIGHT);
      }
      
      public function addPrimsTo(param1:Dictionary) : void
      {
         param1["senseVideoMotion"] = this.primVideoMotion;
         readMotionSensor = this.getMotionOn;
      }
      
      private function primVideoMotion(param1:Block) : Number
      {
         var _loc2_:String = this.interp.arg(param1,0);
         var _loc3_:ScratchObj = this.app.stagePane.objNamed(String(this.interp.arg(param1,1)));
         if("this sprite" == this.interp.arg(param1,1))
         {
            _loc3_ = this.interp.targetObj();
         }
         return this.getMotionOn(_loc2_,_loc3_);
      }
      
      private function getMotionOn(param1:String, param2:ScratchObj) : Number
      {
         var _loc3_:ScratchSprite = null;
         if(!param2)
         {
            return 0;
         }
         this.startMotionDetector();
         if(!this.analysisDone)
         {
            this.analyzeFrame();
         }
         if(param2.isStage)
         {
            if(param1 == "direction")
            {
               return this.motionDirection;
            }
            if(param1 == "motion")
            {
               return Math.min(100,this.motionAmount);
            }
         }
         else
         {
            _loc3_ = param2 as ScratchSprite;
            if(this.analysisDone)
            {
               this.getLocalMotion(_loc3_);
            }
            if(param1 == "direction")
            {
               return _loc3_.localMotionDirection;
            }
            if(param1 == "motion")
            {
               return Math.min(100,_loc3_.localMotionAmount);
            }
         }
         return 0;
      }
      
      private function startMotionDetector() : void
      {
         this.app.runtime.motionDetector = this;
      }
      
      private function stopMotionDetector() : void
      {
         this.app.runtime.motionDetector = null;
      }
      
      public function step() : void
      {
         var _loc5_:int = 0;
         ++this.frameNum;
         var _loc1_:Array = this.app.stagePane.sprites();
         if(!(this.app.stagePane && this.app.stagePane.videoImage))
         {
            this.prev = this.curr = null;
            this.motionAmount = this.motionDirection = 0;
            _loc5_ = 0;
            while(_loc5_ < _loc1_.length)
            {
               _loc1_[_loc5_].localMotionAmount = 0;
               _loc1_[_loc5_].localMotionDirection = 0;
               _loc5_++;
            }
            this.analysisDone = true;
            this.stopMotionDetector();
            return;
         }
         var _loc2_:BitmapData = this.app.stagePane.videoImage.bitmapData;
         var _loc3_:Number = Math.min(this.WIDTH / _loc2_.width,this.HEIGHT / _loc2_.height);
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(_loc3_,_loc3_);
         this.frameBuffer.draw(_loc2_,_loc4_);
         this.prev = this.curr;
         this.curr = this.frameBuffer.getVector(this.frameBuffer.rect);
         this.analysisDone = false;
      }
      
      private function getLocalMotion(param1:ScratchSprite) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Rectangle = null;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         if(!this.curr || !this.prev)
         {
            param1.localMotionAmount = param1.localMotionDirection = -1;
            return;
         }
         if(param1.localFrameNum != this.frameNum)
         {
            _loc15_ = param1.bounds();
            _loc16_ = _loc15_.left;
            _loc17_ = _loc15_.right;
            _loc18_ = _loc15_.top;
            _loc19_ = _loc15_.bottom;
            _loc20_ = 0;
            _loc6_ = 0;
            _loc7_ = 0;
            _loc8_ = 0;
            _loc9_ = 0;
            _loc10_ = 0;
            _loc5_ = 0;
            _loc2_ = _loc18_;
            while(_loc2_ < _loc19_)
            {
               _loc3_ = _loc16_;
               while(_loc3_ < _loc17_)
               {
                  if(_loc3_ > 0 && _loc3_ < this.WIDTH - 1 && _loc2_ > 0 && _loc2_ < this.HEIGHT - 1 && (param1.bitmap().getPixel32(_loc3_ - _loc16_,_loc2_ - _loc18_) >> 24 & 0xFF) == 255)
                  {
                     _loc4_ = _loc2_ * this.WIDTH + _loc3_;
                     _loc6_ += this.gradA2Array[_loc4_];
                     _loc7_ += this.gradA1B2Array[_loc4_];
                     _loc8_ += this.gradB1Array[_loc4_];
                     _loc10_ += this.gradC2Array[_loc4_];
                     _loc9_ += this.gradC1Array[_loc4_];
                     _loc20_++;
                  }
                  _loc3_++;
               }
               _loc2_++;
            }
            _loc21_ = _loc7_ * _loc7_ - _loc6_ * _loc8_;
            if(_loc21_)
            {
               _loc22_ = -(_loc9_ * _loc7_ - _loc10_ * _loc8_);
               _loc23_ = -(_loc7_ * _loc10_ - _loc6_ * _loc9_);
               _loc24_ = 8 / _loc21_;
               _loc11_ = _loc22_ * _loc24_;
               _loc12_ = _loc23_ * _loc24_;
            }
            else
            {
               _loc25_ = (_loc7_ + _loc6_) * (_loc7_ + _loc6_) + (_loc8_ + _loc7_) * (_loc8_ + _loc7_);
               if(_loc25_)
               {
                  _loc26_ = 8 / _loc25_;
                  _loc27_ = -(_loc9_ + _loc10_) * _loc26_;
                  _loc11_ = (_loc7_ + _loc6_) * _loc27_;
                  _loc12_ = (_loc8_ + _loc7_) * _loc27_;
               }
               else
               {
                  _loc11_ = _loc12_ = 0;
               }
            }
            if(_loc20_ != 0)
            {
               _loc5_ = _loc20_;
               _loc20_ /= 2 * this.WINSIZE * 2 * this.WINSIZE;
               _loc11_ /= _loc20_;
               _loc12_ /= _loc20_;
            }
            param1.localMotionAmount = Math.round(this.AMOUNT_SCALE * 0.0002 * _loc5_ * Math.sqrt(_loc11_ * _loc11_ + _loc12_ * _loc12_));
            if(param1.localMotionAmount > 100)
            {
               param1.localMotionAmount = 100;
            }
            if(param1.localMotionAmount > this.THRESHOLD / 3)
            {
               param1.localMotionDirection = (Math.atan2(_loc12_,_loc11_) * this.toDegree + 270) % 360 - 180;
            }
            param1.localFrameNum = this.frameNum;
         }
      }
      
      private function analyzeFrame() : void
      {
         var _loc4_:int = 0;
         var _loc5_:int = 0;
         var _loc6_:int = 0;
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:int = 0;
         var _loc19_:Number = NaN;
         var _loc20_:int = 0;
         var _loc21_:int = 0;
         var _loc22_:int = 0;
         var _loc23_:Number = NaN;
         var _loc24_:Number = NaN;
         var _loc25_:Number = NaN;
         var _loc26_:Number = NaN;
         var _loc27_:Number = NaN;
         var _loc28_:Number = NaN;
         if(!this.curr || !this.prev)
         {
            this.motionAmount = this.motionDirection = -1;
            return;
         }
         var _loc1_:int = this.WINSIZE * 2 + 1;
         var _loc2_:int = this.WIDTH - this.WINSIZE - 1;
         var _loc3_:int = this.HEIGHT - this.WINSIZE - 1;
         _loc16_ = _loc17_ = _loc18_ = 0;
         _loc4_ = this.WINSIZE + 1;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = this.WINSIZE + 1;
            while(_loc5_ < _loc2_)
            {
               _loc9_ = 0;
               _loc10_ = 0;
               _loc11_ = 0;
               _loc12_ = 0;
               _loc13_ = 0;
               _loc6_ = -this.WINSIZE;
               while(_loc6_ <= this.WINSIZE)
               {
                  _loc7_ = -this.WINSIZE;
                  while(_loc7_ <= this.WINSIZE)
                  {
                     _loc8_ = (_loc4_ + _loc6_) * this.WIDTH + _loc5_ + _loc7_;
                     _loc20_ = (this.curr[_loc8_ - 1] & 0xFF) - (this.curr[_loc8_ + 1] & 0xFF);
                     _loc21_ = (this.curr[_loc8_ - this.WIDTH] & 0xFF) - (this.curr[_loc8_ + this.WIDTH] & 0xFF);
                     _loc22_ = (this.prev[_loc8_] & 0xFF) - (this.curr[_loc8_] & 0xFF);
                     this.gradA2Array[_loc8_] = _loc20_ * _loc20_;
                     this.gradA1B2Array[_loc8_] = _loc20_ * _loc21_;
                     this.gradB1Array[_loc8_] = _loc21_ * _loc21_;
                     this.gradC2Array[_loc8_] = _loc20_ * _loc22_;
                     this.gradC1Array[_loc8_] = _loc21_ * _loc22_;
                     _loc9_ += this.gradA2Array[_loc8_];
                     _loc10_ += this.gradA1B2Array[_loc8_];
                     _loc11_ += this.gradB1Array[_loc8_];
                     _loc13_ += this.gradC2Array[_loc8_];
                     _loc12_ += this.gradC1Array[_loc8_];
                     _loc7_++;
                  }
                  _loc6_++;
               }
               _loc19_ = _loc10_ * _loc10_ - _loc9_ * _loc11_;
               if(_loc19_)
               {
                  _loc23_ = -(_loc12_ * _loc10_ - _loc13_ * _loc11_);
                  _loc24_ = -(_loc10_ * _loc13_ - _loc9_ * _loc12_);
                  _loc25_ = 8 / _loc19_;
                  _loc14_ = _loc23_ * _loc25_;
                  _loc15_ = _loc24_ * _loc25_;
               }
               else
               {
                  _loc26_ = (_loc10_ + _loc9_) * (_loc10_ + _loc9_) + (_loc11_ + _loc10_) * (_loc11_ + _loc10_);
                  if(_loc26_)
                  {
                     _loc27_ = 8 / _loc26_;
                     _loc28_ = -(_loc12_ + _loc13_) * _loc27_;
                     _loc14_ = (_loc10_ + _loc9_) * _loc28_;
                     _loc15_ = (_loc11_ + _loc10_) * _loc28_;
                  }
                  else
                  {
                     _loc14_ = _loc15_ = 0;
                  }
               }
               if(-_loc1_ < _loc14_ && _loc14_ < _loc1_ && -_loc1_ < _loc15_ && _loc15_ < _loc1_)
               {
                  _loc16_ += _loc14_;
                  _loc17_ += _loc15_;
                  _loc18_++;
               }
               _loc5_ += _loc1_;
            }
            _loc4_ += _loc1_;
         }
         _loc16_ /= _loc18_;
         _loc17_ /= _loc18_;
         this.motionAmount = Math.round(this.AMOUNT_SCALE * Math.sqrt(_loc16_ * _loc16_ + _loc17_ * _loc17_));
         if(this.motionAmount > this.THRESHOLD)
         {
            this.motionDirection = (Math.atan2(_loc17_,_loc16_) * this.toDegree + 270) % 360 - 180;
         }
         this.analysisDone = true;
      }
   }
}

