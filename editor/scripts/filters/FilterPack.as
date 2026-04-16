package filters
{
   import flash.display.*;
   import flash.filters.*;
   import flash.system.Capabilities;
   import scratch.*;
   import util.*;
   
   public class FilterPack
   {
      
      public static var filterNames:Array = ["color","fisheye","whirl","pixelate","mosaic","brightness","ghost"];
      
      private static var emptyArray:Array = [];
      
      public var targetObj:ScratchObj;
      
      private var filterDict:Object;
      
      private var FisheyeKernel:Class = FilterPack_FisheyeKernel;
      
      private var fisheyeShader:Shader = new Shader(new this.FisheyeKernel());
      
      private var HSVKernel:Class = FilterPack_HSVKernel;
      
      private var hsvShader:Shader = new Shader(new this.HSVKernel());
      
      private var MosaicKernel:Class = FilterPack_MosaicKernel;
      
      private var mosaicShader:Shader = new Shader(new this.MosaicKernel());
      
      private var PixelateKernel:Class = FilterPack_PixelateKernel;
      
      private var pixelateShader:Shader = new Shader(new this.PixelateKernel());
      
      private var WhirlKernel:Class = FilterPack_WhirlKernel;
      
      private var whirlShader:Shader = new Shader(new this.WhirlKernel());
      
      private var newFilters:Array = [];
      
      public function FilterPack(param1:ScratchObj)
      {
         super();
         this.targetObj = param1;
         this.filterDict = new Object();
         this.resetAllFilters();
      }
      
      public function getAllSettings() : Object
      {
         return this.filterDict;
      }
      
      public function resetAllFilters() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < filterNames.length)
         {
            this.filterDict[filterNames[_loc1_]] = 0;
            _loc1_++;
         }
      }
      
      public function getFilterSetting(param1:String) : Number
      {
         var _loc2_:* = this.filterDict[param1];
         if(!(_loc2_ is Number))
         {
            return 0;
         }
         return _loc2_;
      }
      
      public function setFilter(param1:String, param2:Number) : Boolean
      {
         if(param2 != param2)
         {
            return false;
         }
         if(param1 == "brightness")
         {
            param2 = Math.max(-100,Math.min(param2,100));
         }
         if(param1 == "color")
         {
            param2 %= 200;
         }
         if(param1 == "ghost")
         {
            param2 = Math.max(0,Math.min(param2,100));
         }
         var _loc3_:Number = Number(this.filterDict[param1]);
         this.filterDict[param1] = param2;
         return param2 != _loc3_;
      }
      
      public function duplicateFor(param1:ScratchObj) : FilterPack
      {
         var _loc4_:String = null;
         var _loc2_:FilterPack = new FilterPack(param1);
         var _loc3_:int = 0;
         while(_loc3_ < filterNames.length)
         {
            _loc4_ = filterNames[_loc3_];
            _loc2_.setFilter(_loc4_,this.filterDict[_loc4_]);
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function buildFilters(param1:Boolean = false) : Array
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if((Scratch.app.isIn3D || Capabilities.cpuArchitecture != "x86") && !param1)
         {
            return emptyArray;
         }
         var _loc2_:Number = this.targetObj.isStage ? 1 : Scratch.app.stagePane.scaleX;
         var _loc3_:Number = this.targetObj.width * _loc2_;
         var _loc4_:Number = this.targetObj.height * _loc2_;
         this.newFilters.length = 0;
         if(this.filterDict["whirl"] != 0)
         {
            _loc6_ = Math.PI * this.filterDict["whirl"] / 180;
            if(_loc3_ > _loc4_)
            {
               _loc7_ = _loc4_ / _loc3_;
               _loc8_ = 1;
            }
            else
            {
               _loc7_ = 1;
               _loc8_ = _loc3_ / _loc4_;
            }
            this.whirlShader.data.whirlRadians.value = [_loc6_];
            this.whirlShader.data.center.value = [_loc3_ / 2,_loc4_ / 2];
            this.whirlShader.data.radius.value = [Math.min(_loc3_,_loc4_) / 2];
            this.whirlShader.data.scale.value = [_loc7_,_loc8_];
            this.newFilters.push(new ShaderFilter(this.whirlShader));
         }
         if(this.filterDict["fisheye"] != 0)
         {
            _loc5_ = Math.max(0,(this.filterDict["fisheye"] + 100) / 100);
            this.fisheyeShader.data.scaledPower.value = [_loc5_];
            this.fisheyeShader.data.center.value = [_loc3_ / 2,_loc4_ / 2];
            this.newFilters.push(new ShaderFilter(this.fisheyeShader));
         }
         if(this.filterDict["pixelate"] != 0)
         {
            _loc5_ = Math.abs(this.filterDict["pixelate"]) / 10 + 1;
            if(this.targetObj == Scratch.app.stagePane)
            {
               _loc5_ *= Scratch.app.stagePane.scaleX;
            }
            _loc5_ = Math.min(_loc5_,Math.min(_loc3_,_loc4_));
            this.pixelateShader.data.pixelSize.value = [_loc5_];
            this.newFilters.push(new ShaderFilter(this.pixelateShader));
         }
         if(this.filterDict["mosaic"] != 0)
         {
            _loc5_ = Math.round((Math.abs(this.filterDict["mosaic"]) + 10) / 10);
            _loc5_ = Math.max(1,Math.min(_loc5_,Math.min(_loc3_,_loc4_)));
            this.mosaicShader.data.count.value = [_loc5_];
            this.mosaicShader.data.widthAndHeight.value = [_loc3_,_loc4_];
            this.newFilters.push(new ShaderFilter(this.mosaicShader));
         }
         if(this.filterDict["color"] != 0)
         {
            this.hsvShader.data.brightnessShift.value = [0];
            _loc5_ = 360 * this.filterDict["color"] / 200 % 360;
            this.hsvShader.data.hueShift.value = [_loc5_];
            this.newFilters.push(new ShaderFilter(this.hsvShader));
         }
         return this.newFilters;
      }
   }
}

