package svgutils
{
   import flash.display.*;
   import flash.geom.*;
   import flash.text.*;
   import svgeditor.DrawProperties;
   
   public class SVGElement
   {
      
      public var tag:String;
      
      public var id:String;
      
      public var attributes:Object;
      
      public var subElements:Array;
      
      public var bitmap:BitmapData;
      
      public var path:SVGPath;
      
      public var text:String;
      
      public var transform:Matrix;
      
      private const namedColors:Object = {
         "aliceblue":15792383,
         "antiquewhite":16444375,
         "aqua":65535,
         "aquamarine":8388564,
         "azure":15794175,
         "beige":16119260,
         "bisque":16770244,
         "black":0,
         "blanchedalmond":16772045,
         "blue":255,
         "blueviolet":9055202,
         "brown":10824234,
         "burlywood":14596231,
         "cadetblue":6266528,
         "chartreuse":8388352,
         "chocolate":13789470,
         "coral":16744272,
         "cornflowerblue":6591981,
         "cornsilk":16775388,
         "crimson":14423100,
         "cyan":65535,
         "darkblue":139,
         "darkcyan":35723,
         "darkgoldenrod":12092939,
         "darkgray":11119017,
         "darkgrey":11119017,
         "darkgreen":25600,
         "darkkhaki":12433259,
         "darkmagenta":9109643,
         "darkolivegreen":5597999,
         "darkorange":16747520,
         "darkorchid":10040012,
         "darkred":9109504,
         "darksalmon":15308410,
         "darkseagreen":9419919,
         "darkslateblue":4734347,
         "darkslategray":3100495,
         "darkslategrey":3100495,
         "darkturquoise":52945,
         "darkviolet":9699539,
         "deeppink":16716947,
         "deepskyblue":49151,
         "dimgray":6908265,
         "dimgrey":6908265,
         "dodgerblue":2003199,
         "firebrick":11674146,
         "floralwhite":16775920,
         "forestgreen":2263842,
         "fuchsia":16711935,
         "gainsboro":14474460,
         "ghostwhite":16316671,
         "gold":16766720,
         "goldenrod":14329120,
         "gray":8421504,
         "grey":8421504,
         "green":32768,
         "greenyellow":11403055,
         "honeydew":15794160,
         "hotpink":16738740,
         "indianred":13458524,
         "indigo":4915330,
         "ivory":16777200,
         "khaki":15787660,
         "lavender":15132410,
         "lavenderblush":16773365,
         "lawngreen":8190976,
         "lemonchiffon":16775885,
         "lightblue":11393254,
         "lightcoral":15761536,
         "lightcyan":14745599,
         "lightgoldenrodyellow":16448210,
         "lightgray":13882323,
         "lightgrey":13882323,
         "lightgreen":9498256,
         "lightpink":16758465,
         "lightsalmon":16752762,
         "lightseagreen":2142890,
         "lightskyblue":8900346,
         "lightslategray":7833753,
         "lightslategrey":7833753,
         "lightsteelblue":11584734,
         "lightyellow":16777184,
         "lime":65280,
         "limegreen":3329330,
         "linen":16445670,
         "magenta":16711935,
         "maroon":8388608,
         "mediumaquamarine":6737322,
         "mediumblue":205,
         "mediumorchid":12211667,
         "mediumpurple":9662680,
         "mediumseagreen":3978097,
         "mediumslateblue":8087790,
         "mediumspringgreen":64154,
         "mediumturquoise":4772300,
         "mediumvioletred":13047173,
         "midnightblue":1644912,
         "mintcream":16121850,
         "mistyrose":16770273,
         "moccasin":16770229,
         "navajowhite":16768685,
         "navy":128,
         "oldlace":16643558,
         "olive":8421376,
         "olivedrab":7048739,
         "orange":16753920,
         "orangered":16729344,
         "orchid":14315734,
         "palegoldenrod":15657130,
         "palegreen":10025880,
         "paleturquoise":11529966,
         "palevioletred":14184595,
         "papayawhip":16773077,
         "peachpuff":16767673,
         "peru":13468991,
         "pink":16761035,
         "plum":14524637,
         "powderblue":11591910,
         "purple":8388736,
         "red":16711680,
         "rosybrown":12357519,
         "royalblue":4286945,
         "saddlebrown":9127187,
         "salmon":16416882,
         "sandybrown":16032864,
         "seagreen":3050327,
         "seashell":16774638,
         "sienna":10506797,
         "silver":12632256,
         "skyblue":8900331,
         "slateblue":6970061,
         "slategray":7372944,
         "slategrey":7372944,
         "snow":16775930,
         "springgreen":65407,
         "steelblue":4620980,
         "tan":13808780,
         "teal":32896,
         "thistle":14204888,
         "tomato":16737095,
         "turquoise":4251856,
         "violet":15631086,
         "wheat":16113331,
         "white":16777215,
         "whitesmoke":16119285,
         "yellow":16776960,
         "yellowgreen":10145074
      };
      
      public function SVGElement(param1:String, param2:String = "")
      {
         super();
         if(!param2 || param2.length == 0)
         {
            param2 = "ID" + Math.random();
         }
         this.tag = param1;
         this.id = param2;
         this.attributes = {};
         this.subElements = [];
      }
      
      public static function makeBitmapEl(param1:BitmapData, param2:Number = 1) : SVGElement
      {
         var _loc3_:SVGElement = new SVGElement("image");
         _loc3_.bitmap = param1;
         _loc3_.setAttribute("x",0);
         _loc3_.setAttribute("y",0);
         _loc3_.setAttribute("width",param1.width);
         _loc3_.setAttribute("height",param1.height);
         if(param2 != 1)
         {
            _loc3_.transform = new Matrix();
            _loc3_.transform.scale(param2,param2);
         }
         return _loc3_;
      }
      
      public static function colorToHex(param1:uint) : String
      {
         var _loc2_:String = param1.toString(16).toUpperCase();
         while(_loc2_.length < 6)
         {
            _loc2_ = "0" + _loc2_;
         }
         return "#" + _loc2_;
      }
      
      public function allElements() : Array
      {
         var result:Array = null;
         var collectElements:Function = function(param1:SVGElement):void
         {
            var _loc2_:SVGElement = null;
            result.push(param1);
            for each(_loc2_ in param1.subElements)
            {
               collectElements(_loc2_);
            }
         };
         result = [];
         collectElements(this);
         return result;
      }
      
      public function clone() : SVGElement
      {
         var _loc2_:String = null;
         var _loc3_:* = undefined;
         var _loc1_:SVGElement = new SVGElement(this.tag,this.id);
         _loc1_.attributes = {};
         for(_loc2_ in this.attributes)
         {
            _loc3_ = this.attributes[_loc2_];
            if(_loc3_ is Array)
            {
               _loc3_ = _loc3_.concat();
            }
            _loc1_.attributes[_loc2_] = _loc3_;
         }
         _loc1_.bitmap = this.bitmap;
         if(this.path)
         {
            _loc1_.path = this.path.clone();
         }
         _loc1_.text = this.text;
         if(this.transform)
         {
            _loc1_.transform = this.transform.clone();
         }
         return _loc1_;
      }
      
      public function setShapeStroke(param1:DrawProperties) : void
      {
         if(param1.alpha > 0 && this.tag != "text")
         {
            this.setAttribute("stroke",colorToHex(param1.color & 0xFFFFFF));
            this.setAttribute("stroke-width",param1.strokeWidth);
         }
         else
         {
            this.setAttribute("stroke","none");
         }
      }
      
      public function setShapeFill(param1:DrawProperties) : void
      {
         var _loc2_:Boolean = param1.alpha > 0 && (this.tag != "path" || !this.path || Boolean(this.path.getSegmentEndPoints()[2]));
         this.setAttribute("fill",_loc2_ ? colorToHex(param1.color & 0xFFFFFF) : "none");
      }
      
      public function applyShapeProps(param1:DrawProperties) : void
      {
         var _loc2_:Boolean = this.tag == "path" || this.tag == "ellipse" || this.tag == "rect" || this.tag == "polylines";
         if(_loc2_ && this.getAttribute("stroke") != "none")
         {
            this.setAttribute("stroke-width",param1.strokeWidth);
         }
         if(this.tag == "text")
         {
            this.setAttribute("fill",colorToHex(param1.color & 0xFFFFFF));
         }
      }
      
      public function setFont(param1:String, param2:int = 0) : void
      {
         if(this.tag == "text")
         {
            this.setAttribute("font-family",param1);
            if(param2 > 0)
            {
               this.setAttribute("font-size",param2);
            }
         }
      }
      
      public function isBackDropBG() : Boolean
      {
         return "scratch-type" in this.attributes && this.attributes["scratch-type"].indexOf("backdrop-") === 0;
      }
      
      public function isBackDropFill() : Boolean
      {
         return "scratch-type" in this.attributes && this.attributes["scratch-type"] == "backdrop-fill";
      }
      
      public function alpha() : Number
      {
         var _loc1_:Number = Number(this.getAttribute("opacity",1));
         if(_loc1_ >= 1)
         {
            return 1;
         }
         return _loc1_ > 0 ? _loc1_ : 0;
      }
      
      public function getAttribute(param1:String, param2:* = undefined) : *
      {
         var _loc3_:* = undefined;
         if(this.attributes.hasOwnProperty(param1))
         {
            _loc3_ = this.attributes[param1];
            if(_loc3_ is String && _loc3_.indexOf("%") == _loc3_.length - 1)
            {
               return parseFloat(_loc3_) / 100;
            }
            if(param2 is Number && _loc3_ === "undefined")
            {
               return param2;
            }
            return _loc3_;
         }
         return param2;
      }
      
      public function setAttribute(param1:String, param2:*) : void
      {
         if(param2 === null || param2 === undefined)
         {
            delete this.attributes[param1];
         }
         else
         {
            this.attributes[param1] = param2;
         }
      }
      
      public function deleteAttributes(param1:Array) : void
      {
         var _loc2_:String = null;
         for each(_loc2_ in param1)
         {
            delete this.attributes[_loc2_];
         }
      }
      
      public function extractNumericArgs(param1:String) : Array
      {
         var _loc4_:String = null;
         var _loc2_:Array = [];
         var _loc3_:Array = param1.match(/(?:\+|-)?\d+(?:\.\d+)?(?:e(?:\+|-)?\d+)?/g);
         for each(_loc4_ in _loc3_)
         {
            _loc2_.push(Number(_loc4_));
         }
         return _loc2_;
      }
      
      public function convertToPath() : void
      {
         new SVGImportPath().generatePathCmds(this);
         this.deleteAttributes(["cx","cy","rx","ry","r"]);
         this.deleteAttributes(["x","y","width","height"]);
         this.deleteAttributes(["x1","y1","x2","y2"]);
         this.setAttribute("d",SVGExport.pathCmds(this.path));
         this.setAttribute("stroke-linecap","round");
         this.tag = "path";
      }
      
      public function setPath(param1:String) : void
      {
         this.setAttribute("d",param1);
         this.updatePath();
      }
      
      public function updatePath() : void
      {
         new SVGImportPath().generatePathCmds(this);
      }
      
      public function renderImageOn(param1:Bitmap) : void
      {
         var _loc3_:int = 0;
         var _loc4_:int = 0;
         var _loc2_:BitmapData = this.bitmap;
         if(_loc2_ == null)
         {
            _loc3_ = this.getAttribute("width",10);
            _loc4_ = this.getAttribute("height",10);
            _loc2_ = new BitmapData(_loc3_,_loc4_,false,16711935);
         }
         param1.bitmapData = _loc2_;
         param1.x = this.getAttribute("x",0);
         param1.y = this.getAttribute("y",0);
         param1.alpha = this.alpha();
         if(this.transform)
         {
            param1.transform.matrix = this.transform;
         }
      }
      
      public function renderPathOn(param1:Shape, param2:Boolean = false) : void
      {
         SVGPath.render(this,param1.graphics,param2);
      }
      
      public function renderTextOn(param1:TextField) : void
      {
         var _loc5_:Number = NaN;
         var _loc2_:Boolean = true;
         if(!this.text)
         {
            return;
         }
         var _loc3_:TextFormat = new TextFormat(this.getAttribute("font-family","Helvetica"),this.getAttribute("font-size",18),0,this.getAttribute("font-weight") == "bold",this.getAttribute("font-style") == "italic");
         if(_loc2_)
         {
            if(!this.hasEmbeddedFont(_loc3_.font))
            {
               this.setAttribute("font-family","Helvetica");
               _loc3_.font = "Helvetica";
            }
            param1.embedFonts = true;
            param1.antiAliasType = AntiAliasType.ADVANCED;
         }
         param1.defaultTextFormat = _loc3_;
         param1.text = this.text;
         param1.width = param1.textWidth + 6;
         param1.height = param1.textHeight + 4;
         var _loc4_:String = this.getAttribute("fill",null);
         if(!_loc4_)
         {
            _loc4_ = this.getAttribute("stroke","black");
         }
         param1.textColor = this.getColorValue(_loc4_);
         _loc5_ = param1.getLineMetrics(0).ascent;
         param1.x = this.getAttribute("x",0) - 2;
         param1.y = this.getAttribute("y",0) - _loc5_ - 2;
         param1.x += Number(this.getAttribute("dx",0));
         param1.y += Number(this.getAttribute("dy",0));
         var _loc6_:String = this.getAttribute("text-anchor","start");
         if("end" == _loc6_)
         {
            param1.x -= param1.textWidth;
         }
         if("middle" == _loc6_)
         {
            param1.x -= param1.textWidth / 2;
         }
         param1.alpha = this.alpha();
         if(this.transform)
         {
            param1.transform.matrix = this.transform;
         }
      }
      
      private function hasEmbeddedFont(param1:String) : Boolean
      {
         var _loc2_:Font = null;
         for each(_loc2_ in Font.enumerateFonts(false))
         {
            if(param1 == _loc2_.fontName)
            {
               return true;
            }
         }
         return false;
      }
      
      private function testColorValue() : void
      {
         var _loc2_:String = null;
         var _loc1_:Array = ["red","purple","#F70","#FF8000","rgb(255, 128, 0)","rgb(100%, 50%, 0%)"];
         for each(_loc2_ in _loc1_)
         {
         }
      }
      
      public function getColorValue(param1:*) : int
      {
         var _loc4_:Array = null;
         var _loc2_:String = param1 as String;
         if(!_loc2_ || _loc2_ == "none" || _loc2_ == "")
         {
            return 8421504;
         }
         if(_loc2_.charAt(0) == "#")
         {
            _loc2_ = _loc2_.slice(1);
            if(_loc2_.length < 6)
            {
               _loc2_ = _loc2_.charAt(0) + _loc2_.charAt(0) + _loc2_.charAt(1) + _loc2_.charAt(1) + _loc2_.charAt(2) + _loc2_.charAt(2);
            }
            return int("0x" + _loc2_);
         }
         var _loc3_:int = _loc2_.indexOf("rgb(");
         if(_loc3_ == 0)
         {
            _loc2_ = _loc2_.slice(4,_loc2_.length - 1);
            _loc4_ = _loc2_.split(",");
            if(_loc2_.indexOf("%") > -1)
            {
               return this.colorPercent(_loc4_[0]) << 16 | this.colorPercent(_loc4_[1]) << 8 | this.colorPercent(_loc4_[2]);
            }
            return this.colorComponent(_loc4_[0]) << 16 | this.colorComponent(_loc4_[1]) << 8 | this.colorComponent(_loc4_[2]);
         }
         return this.getColorByName(_loc2_);
      }
      
      private function colorPercent(param1:String) : int
      {
         var _loc2_:int = param1.indexOf("%");
         if(_loc2_ > -1)
         {
            param1 = param1.slice(0,_loc2_);
         }
         var _loc3_:Number = Math.max(0,Math.min(Number(param1) / 100,1));
         return 255 * _loc3_;
      }
      
      private function colorComponent(param1:String) : int
      {
         return Math.max(0,Math.min(Number(param1),255));
      }
      
      private function getColorByName(param1:String) : int
      {
         return this.namedColors[param1.toLowerCase()];
      }
   }
}

