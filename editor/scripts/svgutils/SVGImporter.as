package svgutils
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.geom.*;
   import logging.LogLevel;
   import util.Base64Encoder;
   
   public class SVGImporter
   {
      
      private static const degToRadians:Number = Math.PI / 180;
      
      public var root:SVGElement;
      
      public var elements:Object = {};
      
      private const ignoredTags:Array = ["filter","foreignObject","marker","metadata","namedview","pattern","perspective","pgf","title","use"];
      
      public function SVGImporter(param1:XML)
      {
         super();
         this.elements = {};
         if(param1.localName() != "svg")
         {
            return;
         }
         this.root = this.extractElement(param1,[]);
         if(!this.root)
         {
            Scratch.app.log(LogLevel.WARNING,"No SVG root (empty file?)");
            this.root = new SVGElement("svg");
         }
         this.resolveGradientLinks();
         this.resolveURLRefs();
         this.computeTransforms(this.root,null);
      }
      
      private function extractElement(param1:XML, param2:Array) : SVGElement
      {
         var _loc3_:String = param1.localName();
         if(this.ignoredTags.indexOf(_loc3_) >= 0)
         {
            return null;
         }
         switch(_loc3_)
         {
            case "circle":
            case "clipPath":
            case "ellipse":
            case "image":
            case "line":
            case "path":
            case "polygon":
            case "polyline":
            case "rect":
            case "text":
               return this.readBasic(param1,param2);
            case "defs":
               return this.readDefs(param1,param2);
            case "g":
               return this.readGroup(param1,param2);
            case "linearGradient":
            case "radialGradient":
               return this.readGradient(param1,param2);
            case "stop":
               return this.readBasic(param1,param2);
            case "svg":
               return this.readSVG(param1,param2);
            case "switch":
               return this.readSwitch(param1,param2);
            default:
               return null;
         }
      }
      
      private function readBasic(param1:XML, param2:Array) : SVGElement
      {
         var _loc4_:XML = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc3_:SVGElement = new SVGElement(param1.localName(),param1.attribute("id"));
         if("text" == param1.localName())
         {
            _loc3_.text = param1.text()[0];
         }
         for each(_loc4_ in param1.attributes())
         {
            _loc5_ = _loc4_.namespace();
            if(_loc5_ == "" || _loc5_ == "http://www.w3.org/1999/xlink")
            {
               _loc6_ = _loc4_.localName();
               _loc7_ = _loc4_.toString();
               if(_loc6_ == "style")
               {
                  this.addStyleAttributes(_loc3_,_loc7_);
               }
               else
               {
                  _loc3_.attributes[_loc6_] = this.convertUnits(_loc7_);
               }
            }
         }
         this.inheritAttributes(_loc3_,param2);
         new SVGImportPath().generatePathCmds(_loc3_);
         this.elements[_loc3_.id] = _loc3_;
         return _loc3_;
      }
      
      private function readDefs(param1:XML, param2:Array) : SVGElement
      {
         var _loc4_:XML = null;
         var _loc5_:SVGElement = null;
         var _loc3_:SVGElement = this.readBasic(param1,param2);
         for each(_loc4_ in param1.elements())
         {
            _loc5_ = this.extractElement(_loc4_,[]);
            if(_loc5_)
            {
               this.elements[_loc5_.id] = _loc5_;
            }
         }
         return null;
      }
      
      private function readGradient(param1:XML, param2:Array) : SVGElement
      {
         var _loc4_:XML = null;
         var _loc5_:SVGElement = null;
         var _loc3_:SVGElement = this.readBasic(param1,[]);
         for each(_loc4_ in param1.elements())
         {
            _loc5_ = this.extractElement(_loc4_,[]);
            if(_loc5_)
            {
               _loc3_.subElements.push(_loc5_);
            }
         }
         return _loc3_;
      }
      
      private function readGroup(param1:XML, param2:Array) : SVGElement
      {
         var _loc4_:XML = null;
         var _loc5_:SVGElement = null;
         var _loc3_:SVGElement = this.readBasic(param1,param2);
         param2 = [_loc3_].concat(param2);
         for each(_loc4_ in param1.elements())
         {
            _loc5_ = this.extractElement(_loc4_,param2);
            if(_loc5_)
            {
               _loc3_.subElements.push(_loc5_);
            }
         }
         if(_loc3_.subElements.length == 0)
         {
            return null;
         }
         return _loc3_;
      }
      
      private function readText(param1:XML, param2:Array) : SVGElement
      {
         var _loc5_:XML = null;
         var _loc6_:SVGElement = null;
         var _loc3_:SVGElement = this.readBasic(param1,param2);
         param2 = [_loc3_].concat(param2);
         var _loc4_:String = Boolean(param1.text().length) ? param1.text()[0] : "";
         for each(_loc5_ in param1.elements())
         {
            if(_loc5_.localName() == "tspan")
            {
               if(_loc4_.length > 0)
               {
                  _loc4_ += "\n";
               }
               _loc4_ += _loc5_.text()[0];
            }
            _loc6_ = this.extractElement(_loc5_,param2);
            if(_loc6_)
            {
               _loc3_.subElements.push(_loc6_);
            }
         }
         return _loc3_;
      }
      
      private function readSVG(param1:XML, param2:Array) : SVGElement
      {
         var _loc4_:XML = null;
         var _loc5_:SVGElement = null;
         var _loc3_:SVGElement = this.readBasic(param1,param2);
         for each(_loc4_ in param1.elements())
         {
            _loc5_ = this.extractElement(_loc4_,[]);
            if(_loc5_)
            {
               _loc3_.subElements.push(_loc5_);
            }
         }
         return _loc3_;
      }
      
      private function readSwitch(param1:XML, param2:Array) : SVGElement
      {
         var _loc4_:XML = null;
         var _loc5_:SVGElement = null;
         var _loc3_:SVGElement = this.readBasic(param1,param2);
         _loc3_.tag = "g";
         param2 = [_loc3_].concat(param2);
         for each(_loc4_ in param1.elements())
         {
            _loc5_ = this.extractElement(_loc4_,param2);
            if(_loc5_)
            {
               _loc3_.subElements.push(_loc5_);
               return _loc3_;
            }
         }
         return null;
      }
      
      private function inheritAttributes(param1:SVGElement, param2:Array) : void
      {
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:SVGElement = null;
         var _loc7_:* = undefined;
         var _loc3_:Array = ["fill","fill-rule","stroke","stroke-width","text-anchor","font-family","font-size","font-style","font-weight"];
         for each(_loc4_ in _loc3_)
         {
            if(param1.attributes[_loc4_] == undefined)
            {
               _loc7_ = this.inheritedValue(_loc4_,param2);
               if(_loc7_)
               {
                  param1.attributes[_loc4_] = _loc7_;
               }
            }
         }
         _loc5_ = param1.getAttribute("opacity",1);
         for each(_loc6_ in param2)
         {
            _loc5_ *= _loc6_.getAttribute("opacity",1);
         }
         if(_loc5_ != 1)
         {
            param1.attributes["opacity"] = _loc5_;
         }
      }
      
      private function inheritedValue(param1:String, param2:Array) : *
      {
         var _loc3_:SVGElement = null;
         var _loc4_:* = undefined;
         for each(_loc3_ in param2)
         {
            _loc4_ = _loc3_.attributes[param1];
            if(_loc4_)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      public function hasUnloadedImages() : Boolean
      {
         var _loc1_:SVGElement = null;
         for each(_loc1_ in this.root.allElements())
         {
            if("image" == _loc1_.tag && _loc1_.bitmap == null)
            {
               return true;
            }
         }
         return false;
      }
      
      public function loadAllImages(param1:Function = null) : void
      {
         var imageLoaded:Function = null;
         var imageCount:int = 0;
         var imagesLoaded:int = 0;
         var el:SVGElement = null;
         var whenDone:Function = param1;
         imageLoaded = function():void
         {
            ++imagesLoaded;
            if(imagesLoaded == imageCount && whenDone != null)
            {
               whenDone(root);
            }
         };
         imageCount = 0;
         imagesLoaded = 0;
         for each(el in this.root.allElements())
         {
            if("image" == el.tag && el.bitmap == null)
            {
               imageCount++;
               this.loadImage(el,imageLoaded);
            }
         }
         if(imageCount == 0 && whenDone != null)
         {
            whenDone(this.root);
         }
      }
      
      private function loadImage(param1:SVGElement, param2:Function) : void
      {
         var loader:Loader;
         var loadDone:Function = null;
         var el:SVGElement = param1;
         var whenDone:Function = param2;
         loadDone = function(param1:Event):void
         {
            el.bitmap = param1.target.content.bitmapData;
            whenDone();
         };
         var data:String = el.getAttribute("href");
         if(!data)
         {
            whenDone();
            return;
         }
         data = data.slice(data.indexOf(",") + 1);
         loader = new Loader();
         loader.contentLoaderInfo.addEventListener(Event.COMPLETE,loadDone);
         loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(param1:Event):void
         {
            whenDone();
         });
         loader.loadBytes(Base64Encoder.decode(data));
      }
      
      private function resolveGradientLinks() : void
      {
         var _loc1_:SVGElement = null;
         var _loc2_:String = null;
         var _loc3_:SVGElement = null;
         var _loc4_:SVGElement = null;
         for each(_loc1_ in this.elements)
         {
            if("linearGradient" == _loc1_.tag || "radialGradient" == _loc1_.tag)
            {
               _loc2_ = _loc1_.getAttribute("href");
               if(!(!_loc2_ || _loc2_.length < 2))
               {
                  _loc2_ = _loc2_.slice(1);
                  _loc3_ = this.elements[_loc2_];
                  for each(_loc4_ in _loc3_.subElements)
                  {
                     _loc1_.subElements.push(_loc4_.clone());
                  }
               }
            }
         }
      }
      
      private function resolveURLRefs() : void
      {
         var _loc1_:SVGElement = null;
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:SVGElement = null;
         for each(_loc1_ in this.root.allElements())
         {
            for(_loc2_ in _loc1_.attributes)
            {
               _loc3_ = _loc1_.getAttribute(_loc2_) as String;
               if(Boolean(_loc3_) && _loc3_.indexOf("url(#") == 0)
               {
                  _loc4_ = _loc3_.slice(5,_loc3_.indexOf(")"));
                  _loc5_ = this.elements[_loc4_];
                  if(_loc5_)
                  {
                     _loc1_.attributes[_loc2_] = _loc5_;
                  }
               }
            }
         }
      }
      
      private function computeTransforms(param1:SVGElement, param2:Matrix) : void
      {
         var _loc4_:SVGElement = null;
         var _loc5_:Matrix = null;
         var _loc3_:Matrix = this.localXForm(param1);
         if(_loc3_ == null)
         {
            param1.transform = param2;
         }
         else if(param2 == null)
         {
            param1.transform = _loc3_;
         }
         else
         {
            _loc5_ = _loc3_.clone();
            _loc5_.concat(param2);
            param1.transform = _loc5_;
         }
         for each(_loc4_ in param1.subElements)
         {
            this.computeTransforms(_loc4_,param1.transform);
         }
         if(param1.subElements.length > 0)
         {
            param1.transform = null;
         }
         if(false && Boolean(param1.transform))
         {
            if(param1.path)
            {
               this.applyTransformToPath(param1,param1.transform);
               param1.transform = null;
            }
            if(this.isTranslationMatrix(param1.transform))
            {
               if("image" == param1.tag)
               {
                  param1.setAttribute("x",param1.getAttribute("x",0) + param1.transform.tx);
                  param1.setAttribute("y",param1.getAttribute("y",0) + param1.transform.ty);
                  param1.transform = null;
               }
            }
         }
      }
      
      private function localXForm(param1:SVGElement) : Matrix
      {
         var _loc6_:Matrix = null;
         var _loc7_:String = null;
         var _loc8_:Array = null;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:String = param1.attributes["transform"];
         if(_loc2_ == null)
         {
            return null;
         }
         var _loc3_:Matrix = new Matrix();
         var _loc4_:RegExp = /(\w+)\s*\(([^)]*)\)/g;
         var _loc5_:Object = _loc4_.exec(_loc2_);
         while(_loc5_)
         {
            _loc6_ = new Matrix();
            _loc7_ = _loc5_[1].toLowerCase();
            _loc8_ = param1.extractNumericArgs(_loc5_[2]);
            switch(_loc7_)
            {
               case "translate":
                  _loc6_.translate(_loc8_[0],_loc8_.length > 1 ? Number(_loc8_[1]) : 0);
                  break;
               case "scale":
                  _loc6_.scale(_loc8_[0],_loc8_.length > 1 ? Number(_loc8_[1]) : Number(_loc8_[0]));
                  break;
               case "rotate":
                  if(_loc8_.length > 1)
                  {
                     _loc9_ = _loc8_.length > 1 ? Number(_loc8_[1]) : 0;
                     _loc10_ = _loc8_.length > 2 ? Number(_loc8_[2]) : 0;
                     _loc6_.translate(-_loc9_,-_loc10_);
                     _loc6_.rotate(_loc8_[0] * degToRadians);
                     _loc6_.translate(_loc9_,_loc10_);
                  }
                  else
                  {
                     _loc6_.rotate(_loc8_[0] * degToRadians);
                  }
                  break;
               case "skewx":
                  _loc6_.c = Math.tan(_loc8_[0] * degToRadians);
                  break;
               case "skewy":
                  _loc6_.b = Math.tan(_loc8_[0] * degToRadians);
                  break;
               case "matrix":
                  _loc6_ = new Matrix(_loc8_[0],_loc8_[1],_loc8_[2],_loc8_[3],_loc8_[4],_loc8_[5]);
            }
            _loc6_.concat(_loc3_);
            _loc3_ = _loc6_;
            _loc5_ = _loc4_.exec(_loc2_);
         }
         return _loc3_;
      }
      
      private function applyTransformToPath(param1:SVGElement, param2:Matrix) : void
      {
         var _loc3_:Array = null;
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:int = 0;
         var _loc7_:Point = null;
         var _loc8_:Number = NaN;
         for each(_loc3_ in param1.path)
         {
            _loc6_ = 1;
            while(_loc6_ + 1 < _loc3_.length)
            {
               _loc7_ = param2.transformPoint(new Point(_loc3_[_loc6_],_loc3_[_loc6_ + 1]));
               _loc3_[_loc6_] = _loc7_.x;
               _loc3_[_loc6_ + 1] = _loc7_.y;
               _loc6_ += 2;
            }
         }
         param1.setAttribute("d",SVGExport.pathCmds(param1.path));
         _loc4_ = Math.sqrt(param2.a * param2.a + param2.b * param2.b);
         _loc5_ = Math.sqrt(param2.c * param2.c + param2.d * param2.d);
         if(!(_loc4_ == 1 && _loc5_ == 1))
         {
            _loc8_ = Math.max(_loc4_,_loc5_) * param1.getAttribute("stroke-width",1);
            param1.setAttribute("stroke-width",_loc8_);
         }
      }
      
      private function isTranslationMatrix(param1:Matrix) : Boolean
      {
         if(!param1)
         {
            return false;
         }
         return param1.a == 1 && param1.b == 0 && param1.c == 0 && param1.d == 1;
      }
      
      private function addStyleAttributes(param1:SVGElement, param2:String) : void
      {
         var _loc4_:String = null;
         var _loc5_:Array = null;
         var _loc3_:Array = this.removeWhitespace(param2).split(";");
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.length != 0)
            {
               _loc5_ = _loc4_.split(":");
               if(_loc5_.length == 2)
               {
                  param1.attributes[_loc5_[0]] = this.convertUnits(_loc5_[1]);
               }
            }
         }
      }
      
      private function removeWhitespace(param1:String) : String
      {
         return param1.replace(/[\s\t\r\n]*/g,"");
      }
      
      private function convertUnits(param1:String) : *
      {
         var _loc2_:Number = NaN;
         var _loc3_:String = null;
         if("xtcmn".indexOf(param1.slice(-1)) > -1 && ".0123456789".indexOf(param1.slice(-3,-2)) > -1)
         {
            _loc3_ = param1.slice(-2);
            _loc2_ = Number(param1.slice(0,-2));
            switch(_loc3_)
            {
               case "px":
                  return _loc2_;
               case "pt":
                  return _loc2_ * 1.25;
               case "pc":
                  return _loc2_ * 15;
               case "mm":
                  return _loc2_ * 3.543307;
               case "cm":
                  return _loc2_ * 35.43307;
               case "in":
                  return _loc2_ * 90;
            }
         }
         if(param1.slice(-1) == "%")
         {
            _loc2_ = Number(param1.slice(0,-1));
            if(!isNaN(_loc2_))
            {
               return _loc2_ / 100;
            }
         }
         return param1;
      }
   }
}

