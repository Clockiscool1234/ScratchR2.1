package svgutils
{
   import by.blooddy.crypto.image.PNG24Encoder;
   import by.blooddy.crypto.image.PNGFilter;
   import flash.display.BitmapData;
   import flash.display.Sprite;
   import flash.geom.*;
   import flash.utils.ByteArray;
   import util.Base64Encoder;
   
   public class SVGExport
   {
      
      private var rootEl:SVGElement;
      
      private var rootNode:XML;
      
      private var defsNode:XML;
      
      private var nextID:int;
      
      public function SVGExport(param1:SVGElement)
      {
         super();
         this.rootEl = param1;
      }
      
      public static function pathCmds(param1:Array) : String
      {
         var _loc3_:Array = null;
         var _loc4_:Array = null;
         var _loc5_:String = null;
         var _loc6_:int = 0;
         var _loc7_:Number = NaN;
         var _loc2_:String = "";
         for each(_loc3_ in param1)
         {
            _loc4_ = _loc3_.slice(1);
            _loc5_ = "";
            _loc6_ = 0;
            while(_loc6_ < _loc4_.length)
            {
               _loc7_ = Number(_loc4_[_loc6_]);
               _loc5_ += " " + (_loc7_ == int(_loc7_) ? _loc7_ : Number(_loc7_).toFixed(3));
               _loc6_++;
            }
            _loc2_ += _loc3_[0] + _loc5_ + " ";
         }
         return _loc2_;
      }
      
      public function svgData() : ByteArray
      {
         var _loc1_:String = this.svgString();
         var _loc2_:ByteArray = new ByteArray();
         _loc2_.writeUTFBytes(_loc1_);
         return _loc2_;
      }
      
      public function svgString() : String
      {
         var _loc1_:SVGElement = null;
         this.defsNode = null;
         this.nextID = 1;
         XML.ignoreComments = false;
         this.rootNode = new XML("<svg xmlns=\'http://www.w3.org/2000/svg\' version=\'1.1\' " + "xmlns:xlink=\'http://www.w3.org/1999/xlink\'>\n" + "<!-- Exported by Scratch - http://scratch.mit.edu/ -->\n" + "</svg>");
         this.setSVGWidthAndHeight();
         for each(_loc1_ in this.rootEl.subElements)
         {
            this.addNodeTo(_loc1_,this.rootNode);
         }
         if(this.defsNode)
         {
            this.rootNode.prependChild(this.defsNode);
         }
         return this.rootNode.toXMLString();
      }
      
      private function setSVGWidthAndHeight() : void
      {
         var _loc1_:Sprite = new SVGDisplayRender().renderAsSprite(this.rootEl);
         var _loc2_:Rectangle = _loc1_.getBounds(_loc1_);
         var _loc3_:Matrix = new Matrix();
         var _loc4_:BitmapData = new BitmapData(Math.max(int(_loc2_.width),1),Math.max(int(_loc2_.height),1),true,0);
         _loc3_.translate(-_loc2_.left,-_loc2_.top);
         _loc4_.draw(_loc1_,_loc3_);
         var _loc5_:Rectangle = _loc4_.getColorBoundsRect(4278190080,0,false);
         _loc4_.dispose();
         var _loc6_:int = Math.ceil(_loc5_.width + 2);
         var _loc7_:int = Math.ceil(_loc5_.height + 2);
         this.rootNode.@width = _loc6_;
         this.rootNode.@height = _loc7_;
         this.rootNode.@viewBox = "" + Math.floor(_loc5_.x - 1) + " " + Math.floor(_loc5_.y - 1) + " " + _loc6_ + " " + _loc7_;
      }
      
      private function addNodeTo(param1:SVGElement, param2:XML) : void
      {
         if("g" == param1.tag)
         {
            this.addGroupNodeTo(param1,param2);
         }
         else if("image" == param1.tag)
         {
            this.addImageNodeTo(param1,param2);
         }
         else if("text" == param1.tag)
         {
            this.addTextNodeTo(param1,param2);
         }
         else if(param1.path)
         {
            this.addPathNodeTo(param1,param2);
         }
      }
      
      private function addGroupNodeTo(param1:SVGElement, param2:XML) : void
      {
         var _loc4_:SVGElement = null;
         if(param1.subElements.length == 0)
         {
            return;
         }
         var _loc3_:XML = this.createNode(param1,[]);
         for each(_loc4_ in param1.subElements)
         {
            this.addNodeTo(_loc4_,_loc3_);
         }
         this.setTransform(param1,_loc3_);
         param2.appendChild(_loc3_);
      }
      
      private function addImageNodeTo(param1:SVGElement, param2:XML) : void
      {
         if(param1.bitmap == null)
         {
            return;
         }
         var _loc3_:Array = ["x","y","width","height","opacity","scratch-type"];
         var _loc4_:XML = this.createNode(param1,_loc3_);
         var _loc5_:ByteArray = PNG24Encoder.encode(param1.bitmap,PNGFilter.PAETH);
         _loc4_["xlink:href"] = "data:image/png;base64," + Base64Encoder.encode(_loc5_);
         this.setTransform(param1,_loc4_);
         param2.appendChild(_loc4_);
      }
      
      private function addPathNodeTo(param1:SVGElement, param2:XML) : void
      {
         if(param1.path == null)
         {
            return;
         }
         var _loc3_:Array = ["fill","stroke","stroke-width","stroke-linecap","stroke-linejoin","opacity","scratch-type"];
         var _loc4_:XML = this.createNode(param1,_loc3_);
         _loc4_.setName("path");
         _loc4_["d"] = pathCmds(param1.path);
         this.setTransform(param1,_loc4_);
         param2.appendChild(_loc4_);
      }
      
      private function addTextNodeTo(param1:SVGElement, param2:XML) : void
      {
         if(!param1.text)
         {
            return;
         }
         var _loc3_:String = param1.text.replace(/\s+$/g,"");
         if(_loc3_.length == 0)
         {
            return;
         }
         var _loc4_:* = param1.getAttribute("stroke",null);
         if(_loc4_)
         {
            param1.setAttribute("fill",_loc4_);
         }
         var _loc5_:Array = ["fill","stroke","opacity","x","y","dx","dy","text-anchor","font-family","font-size","font-style","font-weight"];
         var _loc6_:XML = this.createNode(param1,_loc5_);
         _loc6_.text()[0] = _loc3_;
         this.setTransform(param1,_loc6_);
         param2.appendChild(_loc6_);
      }
      
      private function createNode(param1:SVGElement, param2:Array = null) : XML
      {
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc3_:Array = ["fill","stroke"];
         var _loc4_:XML = <placeholder> </placeholder>;
         _loc4_.setName(param1.tag);
         _loc4_.@id = param1.id;
         for each(_loc5_ in param2)
         {
            _loc6_ = param1.getAttribute(_loc5_);
            if(_loc6_ is Number && _loc3_.indexOf(_loc5_) > -1)
            {
               _loc6_ = SVGElement.colorToHex(_loc6_);
            }
            if(_loc6_ is SVGElement)
            {
               if("fill" == _loc5_ || "stroke" == _loc5_)
               {
                  _loc6_ = this.defineGradient(_loc6_);
               }
               else
               {
                  _loc6_ = null;
               }
            }
            if(_loc6_)
            {
               _loc4_[_loc5_] = _loc6_;
            }
         }
         return _loc4_;
      }
      
      private function setTransform(param1:SVGElement, param2:XML) : void
      {
         if(!param1.transform)
         {
            return;
         }
         var _loc3_:Matrix = param1.transform;
         if(_loc3_.a == 1 && _loc3_.b == 0 && _loc3_.c == 0 && _loc3_.d == 1 && _loc3_.tx == 0 && _loc3_.ty == 0)
         {
            return;
         }
         param2["transform"] = "matrix(" + _loc3_.a + ", " + _loc3_.b + ", " + _loc3_.c + ", " + _loc3_.d + ", " + _loc3_.tx + ", " + _loc3_.ty + ")";
      }
      
      private function defineGradient(param1:SVGElement) : String
      {
         var _loc2_:XML = null;
         var _loc3_:SVGElement = null;
         var _loc4_:XML = null;
         var _loc5_:* = undefined;
         if(param1.tag == "linearGradient")
         {
            _loc2_ = this.createNode(param1,["x1","y1","x2","y2","gradientUnits"]);
         }
         else
         {
            if(param1.tag != "radialGradient")
            {
               return null;
            }
            _loc2_ = this.createNode(param1,["cx","cy","r","fx","fy","gradientUnits"]);
         }
         _loc2_.@id = "grad_" + this.nextID++;
         for each(_loc3_ in param1.subElements)
         {
            _loc4_ = <stop> </stop>;
            _loc4_["offset"] = _loc3_.getAttribute("offset",0);
            _loc4_["stop-color"] = _loc3_.getAttribute("stop-color",0);
            _loc5_ = _loc3_.getAttribute("stop-opacity");
            if(typeof _loc5_ != "undefined" && _loc5_ !== null)
            {
               _loc4_["stop-opacity"] = _loc5_;
            }
            _loc2_.appendChild(_loc4_);
         }
         this.addDefinition(_loc2_);
         return "url(#" + _loc2_.@id + ")";
      }
      
      private function addDefinition(param1:XML) : void
      {
         if(!this.defsNode)
         {
            this.defsNode = <defs> </defs>;
         }
         this.defsNode.appendChild(param1);
      }
   }
}

