package scratch
{
   import by.blooddy.crypto.MD5;
   import by.blooddy.crypto.image.PNG24Encoder;
   import by.blooddy.crypto.image.PNGFilter;
   import flash.display.*;
   import flash.geom.*;
   import flash.text.TextField;
   import flash.utils.*;
   import render3d.DisplayObjectContainerIn3D;
   import svgeditor.objs.SegmentationState;
   import svgutils.*;
   import util.*;
   
   public class ScratchCostume
   {
      
      public static const WasEdited:int = -10;
      
      public static const kCalculateCenter:int = 99999;
      
      private static var shapeDict:Object = {};
      
      public var costumeName:String;
      
      public var bitmap:BitmapData;
      
      public var bitmapResolution:int = 1;
      
      public var rotationCenterX:int;
      
      public var rotationCenterY:int;
      
      public var baseLayerBitmap:BitmapData;
      
      public var baseLayerID:int = -1;
      
      public var baseLayerMD5:String;
      
      private var __baseLayerData:ByteArray;
      
      public var svgRoot:SVGElement;
      
      public var svgLoading:Boolean;
      
      private var svgSprite:Sprite;
      
      private var svgWidth:Number;
      
      private var svgHeight:Number;
      
      public var oldComposite:BitmapData;
      
      public var textLayerBitmap:BitmapData;
      
      public var textLayerID:int = -1;
      
      public var textLayerMD5:String;
      
      private var __textLayerData:ByteArray;
      
      public var text:String;
      
      public var textRect:Rectangle;
      
      public var textColor:int;
      
      public var fontName:String;
      
      public var fontSize:int;
      
      public var undoList:Array = [];
      
      public var undoListIndex:int;
      
      private var segmentation:SegmentationState = new SegmentationState();
      
      public function ScratchCostume(param1:String, param2:*, param3:int = 99999, param4:int = 99999, param5:int = 1)
      {
         super();
         this.costumeName = param1;
         this.rotationCenterX = param3;
         this.rotationCenterY = param4;
         if(param2 == null)
         {
            this.rotationCenterX = this.rotationCenterY = 0;
         }
         else if(param2 is BitmapData)
         {
            this.bitmap = this.baseLayerBitmap = param2;
            this.bitmapResolution = param5;
            if(param3 == kCalculateCenter)
            {
               this.rotationCenterX = this.bitmap.rect.width / 2;
            }
            if(param4 == kCalculateCenter)
            {
               this.rotationCenterY = this.bitmap.rect.height / 2;
            }
            this.prepareToSave();
         }
         else if(param2 is ByteArray)
         {
            this.setSVGData(param2,param3 == kCalculateCenter);
            this.prepareToSave();
         }
      }
      
      public static function scaleForScratch(param1:BitmapData) : BitmapData
      {
         if(param1.width <= 480 && param1.height <= 360)
         {
            return param1;
         }
         var _loc2_:Number = Math.min(480 / param1.width,360 / param1.height);
         var _loc3_:BitmapData = new BitmapData(_loc2_ * param1.width,_loc2_ * param1.height,true,0);
         var _loc4_:Matrix = new Matrix();
         _loc4_.scale(_loc2_,_loc2_);
         _loc3_.draw(param1,_loc4_);
         return _loc3_;
      }
      
      public static function isSVGData(param1:ByteArray) : Boolean
      {
         var oldPosition:int;
         var s:String;
         var validXML:Boolean;
         var data:ByteArray = param1;
         if(!data || data.length < 10)
         {
            return false;
         }
         oldPosition = int(data.position);
         data.position = 0;
         s = data.readUTFBytes(10);
         data.position = oldPosition;
         validXML = true;
         try
         {
            XML(data);
         }
         catch(e:*)
         {
            validXML = false;
         }
         return (s.indexOf("<?xml") >= 0 || s.indexOf("<svg") >= 0) && validXML;
      }
      
      public static function emptySVG() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUTFBytes("<svg width=\"0\" height=\"0\"\n" + "  xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\"\n" + "  xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n" + "</svg>\n");
         return _loc1_;
      }
      
      public static function emptyBackdropSVG() : ByteArray
      {
         var _loc1_:ByteArray = new ByteArray();
         _loc1_.writeUTFBytes("<svg width=\"480\" height=\"360\"\n" + "  xmlns=\"http://www.w3.org/2000/svg\" version=\"1.1\"\n" + "  xmlns:xlink=\"http://www.w3.org/1999/xlink\">\n" + "\t<rect x=\"0\" y=\"0\" width=\"480\" height=\"360\" fill=\"#FFF\" scratch-type=\"backdrop-fill\"> </rect>\n" + "</svg>\n");
         return _loc1_;
      }
      
      public static function emptyBitmapCostume(param1:String, param2:Boolean) : ScratchCostume
      {
         var _loc3_:BitmapData = param2 ? new BitmapData(480,360,true,4294967295) : new BitmapData(1,1,true,0);
         return new ScratchCostume(param1,_loc3_);
      }
      
      public static function fileExtension(param1:ByteArray) : String
      {
         param1.position = 6;
         if(param1.readUTFBytes(4) == "JFIF")
         {
            return ".jpg";
         }
         param1.position = 0;
         var _loc2_:String = param1.readUTFBytes(4);
         if(_loc2_ == "GIF8")
         {
            return ".gif";
         }
         if(_loc2_ == "PNG")
         {
            return ".png";
         }
         if(_loc2_ == "<?xm" || _loc2_ == "<svg")
         {
            return ".svg";
         }
         return ".dat";
      }
      
      public function get baseLayerData() : ByteArray
      {
         return this.__baseLayerData;
      }
      
      public function set baseLayerData(param1:ByteArray) : void
      {
         this.__baseLayerData = param1;
         this.baseLayerMD5 = null;
      }
      
      public function get textLayerData() : ByteArray
      {
         return this.__textLayerData;
      }
      
      public function set textLayerData(param1:ByteArray) : void
      {
         this.__textLayerData = param1;
         this.textLayerMD5 = null;
      }
      
      public function get segmentationState() : SegmentationState
      {
         return this.segmentation;
      }
      
      public function nextSegmentationState() : void
      {
         this.segmentation = this.segmentation.next;
      }
      
      public function prevSegmentationState() : void
      {
         this.segmentation = this.segmentation.prev;
      }
      
      public function scaleAndCenter(param1:BitmapData, param2:Boolean) : Rectangle
      {
         var _loc3_:Number = 2 / this.bitmapResolution;
         var _loc4_:BitmapData = this.bitmapForEditor(param2);
         var _loc5_:Point = param2 ? new Point(0,0) : new Point(480 - _loc3_ * this.rotationCenterX,360 - _loc3_ * this.rotationCenterY);
         param1.copyPixels(_loc4_,_loc4_.rect,_loc5_);
         var _loc6_:Rectangle = _loc4_.rect;
         _loc6_.x = _loc5_.x;
         _loc6_.y = _loc5_.y;
         return _loc6_;
      }
      
      public function setBitmapData(param1:BitmapData, param2:int, param3:int) : void
      {
         this.clearOldCostume();
         this.bitmap = this.baseLayerBitmap = param1;
         this.baseLayerID = WasEdited;
         this.baseLayerMD5 = null;
         this.bitmapResolution = 2;
         this.rotationCenterX = param2;
         this.rotationCenterY = param3;
         if(Boolean(Scratch.app) && Boolean(Scratch.app.viewedObj()) && Scratch.app.viewedObj().currentCostume() == this)
         {
            Scratch.app.viewedObj().updateCostume();
            Scratch.app.refreshImageTab(true);
         }
      }
      
      public function setSVGData(param1:ByteArray, param2:Boolean, param3:Boolean = true) : void
      {
         var importer:SVGImporter;
         var refreshAfterImagesLoaded:Function = null;
         var thisC:ScratchCostume = null;
         var data:ByteArray = param1;
         var computeCenter:Boolean = param2;
         var fromEditor:Boolean = param3;
         refreshAfterImagesLoaded = function():void
         {
            svgSprite = new SVGDisplayRender().renderAsSprite(svgRoot,false,true);
            if(Boolean(Scratch.app) && Boolean(Scratch.app.viewedObj()) && Scratch.app.viewedObj().currentCostume() == thisC)
            {
               Scratch.app.viewedObj().updateCostume();
               Scratch.app.refreshImageTab(fromEditor);
            }
            svgLoading = false;
         };
         thisC = this;
         this.clearOldCostume();
         this.baseLayerData = data;
         this.baseLayerID = WasEdited;
         importer = new SVGImporter(XML(data));
         this.setSVGRoot(importer.root,computeCenter);
         this.svgLoading = true;
         importer.loadAllImages(refreshAfterImagesLoaded);
      }
      
      public function setSVGRoot(param1:SVGElement, param2:Boolean) : void
      {
         var _loc3_:Rectangle = null;
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         this.svgRoot = param1;
         this.svgSprite = new SVGDisplayRender().renderAsSprite(this.svgRoot,false,true);
         var _loc4_:Array = param1.getAttribute("viewBox","").split(" ");
         if(_loc4_.length == 4)
         {
            _loc3_ = new Rectangle(_loc4_[0],_loc4_[1],_loc4_[2],_loc4_[3]);
         }
         if(!_loc3_)
         {
            _loc5_ = param1.getAttribute("width",-1);
            _loc6_ = param1.getAttribute("height",-1);
            if(_loc5_ >= 0 && _loc6_ >= 0)
            {
               _loc3_ = new Rectangle(0,0,_loc5_,_loc6_);
            }
         }
         if(!_loc3_)
         {
            _loc3_ = this.svgSprite.getBounds(this.svgSprite);
         }
         this.svgWidth = _loc3_.x + _loc3_.width;
         this.svgHeight = _loc3_.y + _loc3_.height;
         if(param2)
         {
            this.rotationCenterX = _loc3_.x + _loc3_.width / 2;
            this.rotationCenterY = _loc3_.y + _loc3_.height / 2;
         }
      }
      
      private function clearOldCostume() : void
      {
         this.bitmap = null;
         this.baseLayerBitmap = null;
         this.bitmapResolution = 1;
         this.baseLayerID = -1;
         this.baseLayerData = null;
         this.svgRoot = null;
         this.svgSprite = null;
         this.svgWidth = this.svgHeight = 0;
         this.oldComposite = null;
         this.textLayerBitmap = null;
         this.textLayerID = -1;
         this.textLayerMD5 = null;
         this.textLayerData = null;
         this.text = null;
         this.textRect = null;
      }
      
      public function isBitmap() : Boolean
      {
         return this.baseLayerBitmap != null;
      }
      
      public function displayObj() : DisplayObject
      {
         if(this.svgRoot)
         {
            if(!this.svgSprite)
            {
               this.svgSprite = new SVGDisplayRender().renderAsSprite(this.svgRoot,false,true);
            }
            return this.svgSprite;
         }
         var _loc1_:Bitmap = new Bitmap(this.bitmap);
         _loc1_.scaleX = _loc1_.scaleY = 1 / this.bitmapResolution;
         return _loc1_;
      }
      
      public function getShape() : Shape
      {
         var _loc3_:Vector.<Point> = null;
         var _loc4_:Point = null;
         if(!this.baseLayerMD5)
         {
            this.prepareToSave();
         }
         var _loc1_:String = this.baseLayerMD5;
         if(Boolean(_loc1_) && Boolean(this.textLayerMD5))
         {
            _loc1_ += this.textLayerMD5;
         }
         else if(this.textLayerMD5)
         {
            _loc1_ = this.textLayerMD5;
         }
         var _loc2_:Shape = shapeDict[_loc1_];
         if(!_loc2_)
         {
            _loc2_ = new Shape();
            _loc3_ = this.RasterHull();
            _loc2_.graphics.clear();
            if(_loc3_.length)
            {
               _loc2_.graphics.lineStyle(1);
               _loc2_.graphics.moveTo(_loc3_[_loc3_.length - 1].x,_loc3_[_loc3_.length - 1].y);
               for each(_loc4_ in _loc3_)
               {
                  _loc2_.graphics.lineTo(_loc4_.x,_loc4_.y);
               }
            }
            if(_loc1_)
            {
               shapeDict[_loc1_] = _loc2_;
            }
         }
         return _loc2_;
      }
      
      private function CCW(param1:Point, param2:Point, param3:Point) : Number
      {
         return (param2.x - param1.x) * (param3.y - param1.y) - (param2.y - param1.y) * (param3.x - param1.x);
      }
      
      private function RasterHull() : Vector.<Point>
      {
         var _loc15_:uint = 0;
         var _loc19_:Number = NaN;
         var _loc20_:* = 0;
         var _loc1_:Vector.<Point> = new Vector.<Point>();
         var _loc2_:DisplayObject = this.displayObj();
         var _loc3_:Rectangle = _loc2_.getBounds(_loc2_);
         if(_loc3_.width < 1 || _loc3_.height < 1)
         {
            _loc1_.push(new Point());
            return _loc1_;
         }
         _loc3_.width += Math.floor(_loc3_.left) - _loc3_.left;
         _loc3_.left = Math.floor(_loc3_.left);
         _loc3_.height += Math.floor(_loc3_.top) - _loc3_.top;
         _loc3_.top = Math.floor(_loc3_.top);
         var _loc4_:int = Math.max(0,Math.ceil(_loc3_.width));
         var _loc5_:int = Math.max(0,Math.ceil(_loc3_.height));
         if(_loc4_ >= DisplayObjectContainerIn3D.texSizeMax || _loc5_ >= DisplayObjectContainerIn3D.texSizeMax)
         {
            _loc19_ = (DisplayObjectContainerIn3D.texSizeMax - 1) / Math.max(_loc4_,_loc5_);
            _loc4_ *= _loc19_;
            _loc5_ *= _loc19_;
         }
         var _loc6_:BitmapData = new BitmapData(_loc4_ + 1,_loc5_ + 1,true,0);
         var _loc7_:Matrix = new Matrix();
         _loc7_.translate(-_loc3_.left,-_loc3_.top);
         _loc7_.scale(_loc6_.width / _loc3_.width,_loc6_.height / _loc3_.height);
         _loc6_.draw(_loc2_,_loc7_);
         var _loc8_:Vector.<Point> = new Vector.<Point>(_loc6_.height);
         var _loc9_:Vector.<Point> = new Vector.<Point>(_loc6_.height);
         var _loc10_:* = -1;
         var _loc11_:* = -1;
         var _loc12_:Point = new Point();
         var _loc13_:int = _loc6_.width;
         var _loc14_:int = _loc6_.height;
         var _loc16_:int = 0;
         while(_loc16_ < _loc14_)
         {
            _loc20_ = 0;
            while(_loc20_ < _loc13_)
            {
               _loc15_ = uint(_loc6_.getPixel32(_loc20_,_loc16_) >> 24 & 0xFF);
               if(_loc15_ > 0)
               {
                  break;
               }
               _loc20_++;
            }
            if(_loc20_ != _loc13_)
            {
               _loc12_.x = _loc20_ + _loc3_.left;
               _loc12_.y = _loc16_ + _loc3_.top;
               while(_loc11_ > 0)
               {
                  if(this.CCW(_loc8_[_loc11_ - 1],_loc8_[_loc11_],_loc12_) < 0)
                  {
                     break;
                  }
                  _loc11_--;
               }
               _loc8_[++_loc11_] = _loc12_.clone();
               _loc20_ = int(_loc13_ - 1);
               while(_loc20_ >= 0)
               {
                  _loc15_ = uint(_loc6_.getPixel32(_loc20_,_loc16_) >> 24 & 0xFF);
                  if(_loc15_ > 0)
                  {
                     break;
                  }
                  _loc20_--;
               }
               _loc12_.x = _loc20_ + _loc3_.left;
               while(_loc10_ > 0)
               {
                  if(this.CCW(_loc9_[_loc10_ - 1],_loc9_[_loc10_],_loc12_) > 0)
                  {
                     break;
                  }
                  _loc10_--;
               }
               _loc9_[++_loc10_] = _loc12_.clone();
            }
            _loc16_++;
         }
         var _loc17_:* = 0;
         while(_loc17_ < _loc11_ + 1)
         {
            _loc1_[_loc17_] = _loc8_[_loc17_];
            _loc17_++;
         }
         var _loc18_:* = int(_loc10_);
         while(_loc18_ >= 0)
         {
            _loc1_[_loc17_++] = _loc9_[_loc18_];
            _loc18_--;
         }
         _loc9_.length = _loc8_.length = 0;
         _loc6_.dispose();
         return _loc1_;
      }
      
      public function width() : Number
      {
         return this.svgRoot ? this.svgWidth : (this.bitmap ? this.bitmap.width / this.bitmapResolution : 0);
      }
      
      public function height() : Number
      {
         return this.svgRoot ? this.svgHeight : (this.bitmap ? this.bitmap.height / this.bitmapResolution : 0);
      }
      
      public function duplicate() : ScratchCostume
      {
         if(this.oldComposite)
         {
            this.computeTextLayer();
         }
         var _loc1_:ScratchCostume = new ScratchCostume(this.costumeName,null);
         _loc1_.bitmap = this.bitmap;
         _loc1_.bitmapResolution = this.bitmapResolution;
         _loc1_.rotationCenterX = this.rotationCenterX;
         _loc1_.rotationCenterY = this.rotationCenterY;
         _loc1_.baseLayerBitmap = this.baseLayerBitmap;
         _loc1_.baseLayerData = this.baseLayerData;
         _loc1_.baseLayerMD5 = this.baseLayerMD5;
         _loc1_.svgRoot = this.svgRoot;
         _loc1_.svgWidth = this.svgWidth;
         _loc1_.svgHeight = this.svgHeight;
         _loc1_.textLayerBitmap = this.textLayerBitmap;
         _loc1_.textLayerData = this.textLayerData;
         _loc1_.textLayerMD5 = this.textLayerMD5;
         _loc1_.text = this.text;
         _loc1_.textRect = this.textRect;
         _loc1_.textColor = this.textColor;
         _loc1_.fontName = this.fontName;
         _loc1_.fontSize = this.fontSize;
         if(Boolean(this.svgRoot) && Boolean(this.svgSprite))
         {
            _loc1_.setSVGSprite(this.cloneSprite(this.svgSprite));
         }
         return _loc1_;
      }
      
      private function cloneSprite(param1:Sprite) : Sprite
      {
         var _loc4_:DisplayObject = null;
         var _loc5_:Shape = null;
         var _loc6_:Bitmap = null;
         var _loc7_:TextField = null;
         var _loc2_:Sprite = new Sprite();
         _loc2_.graphics.copyFrom(param1.graphics);
         _loc2_.x = param1.x;
         _loc2_.y = param1.y;
         _loc2_.scaleX = param1.scaleX;
         _loc2_.scaleY = param1.scaleY;
         _loc2_.rotation = param1.rotation;
         var _loc3_:int = 0;
         while(_loc3_ < param1.numChildren)
         {
            _loc4_ = param1.getChildAt(_loc3_);
            if(_loc4_ is Sprite)
            {
               _loc2_.addChild(this.cloneSprite(_loc4_ as Sprite));
            }
            else if(_loc4_ is Shape)
            {
               _loc5_ = new Shape();
               _loc5_.graphics.copyFrom((_loc4_ as Shape).graphics);
               _loc5_.transform = _loc4_.transform;
               _loc2_.addChild(_loc5_);
            }
            else if(_loc4_ is Bitmap)
            {
               _loc6_ = new Bitmap((_loc4_ as Bitmap).bitmapData);
               _loc6_.x = _loc4_.x;
               _loc6_.y = _loc4_.y;
               _loc6_.scaleX = _loc4_.scaleX;
               _loc6_.scaleY = _loc4_.scaleY;
               _loc6_.rotation = _loc4_.rotation;
               _loc6_.alpha = _loc4_.alpha;
               _loc2_.addChild(_loc6_);
            }
            else if(_loc4_ is TextField)
            {
               _loc7_ = new TextField();
               _loc7_.selectable = false;
               _loc7_.mouseEnabled = false;
               _loc7_.tabEnabled = false;
               _loc7_.textColor = (_loc4_ as TextField).textColor;
               _loc7_.defaultTextFormat = (_loc4_ as TextField).defaultTextFormat;
               _loc7_.embedFonts = (_loc4_ as TextField).embedFonts;
               _loc7_.antiAliasType = (_loc4_ as TextField).antiAliasType;
               _loc7_.text = (_loc4_ as TextField).text;
               _loc7_.alpha = _loc4_.alpha;
               _loc7_.width = _loc7_.textWidth + 6;
               _loc7_.height = _loc7_.textHeight + 4;
               _loc7_.x = _loc4_.x;
               _loc7_.y = _loc4_.y;
               _loc7_.scaleX = _loc4_.scaleX;
               _loc7_.scaleY = _loc4_.scaleY;
               _loc7_.rotation = _loc4_.rotation;
               _loc2_.addChild(_loc7_);
            }
            _loc3_++;
         }
         return _loc2_;
      }
      
      public function setSVGSprite(param1:Sprite) : void
      {
         this.svgSprite = param1;
      }
      
      public function thumbnail(param1:int, param2:int, param3:Boolean) : BitmapData
      {
         var _loc4_:DisplayObject = this.displayObj();
         var _loc5_:Rectangle = param3 ? new Rectangle(0,0,480 * this.bitmapResolution,360 * this.bitmapResolution) : _loc4_.getBounds(_loc4_);
         var _loc6_:Number = _loc5_.x + _loc5_.width / 2;
         var _loc7_:Number = _loc5_.y + _loc5_.height / 2;
         var _loc8_:BitmapData = new BitmapData(param1,param2,true,16777215);
         var _loc9_:Number = Math.min(param1 / _loc5_.width,param2 / _loc5_.height);
         if(this.bitmap)
         {
            _loc9_ = Math.min(1,_loc9_);
         }
         var _loc10_:Matrix = new Matrix();
         if(_loc9_ < 1 || !this.bitmap)
         {
            _loc10_.scale(_loc9_,_loc9_);
         }
         _loc10_.translate(param1 / 2 - _loc9_ * _loc6_,param2 / 2 - _loc9_ * _loc7_);
         _loc8_.draw(_loc4_,_loc10_);
         return _loc8_;
      }
      
      public function bitmapForEditor(param1:Boolean) : BitmapData
      {
         var _loc2_:DisplayObject = this.displayObj();
         var _loc3_:Rectangle = _loc2_.getBounds(_loc2_);
         var _loc4_:int = Math.ceil(Math.max(1,_loc3_.width));
         var _loc5_:int = Math.ceil(Math.max(1,_loc3_.height));
         if(param1)
         {
            _loc4_ = 480 * this.bitmapResolution;
            _loc5_ = 360 * this.bitmapResolution;
         }
         var _loc6_:Number = 2 / this.bitmapResolution;
         var _loc7_:int = param1 ? int(4294967295) : 0;
         var _loc8_:BitmapData = new BitmapData(_loc6_ * _loc4_,_loc6_ * _loc5_,true,_loc7_);
         var _loc9_:Matrix = new Matrix();
         if(!param1)
         {
            _loc9_.translate(-_loc3_.x,-_loc3_.y);
         }
         _loc9_.scale(_loc6_,_loc6_);
         _loc8_.drawWithQuality(_loc2_,_loc9_,null,null,null,false,StageQuality.LOW);
         return _loc8_;
      }
      
      public function toString() : String
      {
         var _loc1_:String = "ScratchCostume(" + this.costumeName + " ";
         _loc1_ += this.rotationCenterX + "," + this.rotationCenterY;
         return _loc1_ + (this.svgRoot ? " svg)" : " bitmap)");
      }
      
      public function writeJSON(param1:util.JSON) : void
      {
         param1.writeKeyValue("costumeName",this.costumeName);
         param1.writeKeyValue("baseLayerID",this.baseLayerID);
         param1.writeKeyValue("baseLayerMD5",this.baseLayerMD5);
         param1.writeKeyValue("bitmapResolution",this.bitmapResolution);
         param1.writeKeyValue("rotationCenterX",this.rotationCenterX);
         param1.writeKeyValue("rotationCenterY",this.rotationCenterY);
         if(this.text != null)
         {
            param1.writeKeyValue("text",this.text);
            param1.writeKeyValue("textRect",[this.textRect.x,this.textRect.y,this.textRect.width,this.textRect.height]);
            param1.writeKeyValue("textColor",this.textColor);
            param1.writeKeyValue("fontName",this.fontName);
            param1.writeKeyValue("fontSize",this.fontSize);
            param1.writeKeyValue("textLayerID",this.textLayerID);
            param1.writeKeyValue("textLayerMD5",this.textLayerMD5);
         }
      }
      
      public function readJSON(param1:Object) : void
      {
         this.costumeName = param1.costumeName;
         this.baseLayerID = param1.baseLayerID;
         if(param1.baseLayerID == undefined)
         {
            if(param1.imageID)
            {
               this.baseLayerID = param1.imageID;
            }
         }
         this.baseLayerMD5 = param1.baseLayerMD5;
         if(param1.bitmapResolution)
         {
            this.bitmapResolution = param1.bitmapResolution;
         }
         this.rotationCenterX = param1.rotationCenterX;
         this.rotationCenterY = param1.rotationCenterY;
         this.text = param1.text;
         if(this.text != null)
         {
            if(param1.textRect is Array)
            {
               this.textRect = new Rectangle(param1.textRect[0],param1.textRect[1],param1.textRect[2],param1.textRect[3]);
            }
            this.textColor = param1.textColor;
            this.fontName = param1.fontName;
            this.fontSize = param1.fontSize;
            this.textLayerID = param1.textLayerID;
            this.textLayerMD5 = param1.textLayerMD5;
         }
      }
      
      public function prepareToSave() : void
      {
         if(this.oldComposite)
         {
            this.computeTextLayer();
         }
         if(this.baseLayerID == WasEdited)
         {
            this.baseLayerMD5 = null;
         }
         this.baseLayerID = this.textLayerID = -1;
         if(this.baseLayerData == null)
         {
            this.baseLayerData = PNG24Encoder.encode(this.baseLayerBitmap,PNGFilter.PAETH);
         }
         if(this.baseLayerMD5 == null)
         {
            this.baseLayerMD5 = MD5.hashBytes(this.baseLayerData) + fileExtension(this.baseLayerData);
         }
         if(this.textLayerBitmap != null)
         {
            if(this.textLayerData == null)
            {
               this.textLayerData = PNG24Encoder.encode(this.textLayerBitmap,PNGFilter.PAETH);
            }
            if(this.textLayerMD5 == null)
            {
               this.textLayerMD5 = MD5.hashBytes(this.textLayerData) + ".png";
            }
         }
      }
      
      private function computeTextLayer() : void
      {
         var _loc2_:BitmapData = null;
         if(this.oldComposite == null || this.baseLayerBitmap == null)
         {
            return;
         }
         var _loc1_:* = this.oldComposite.compare(this.baseLayerBitmap);
         if(_loc1_ is BitmapData)
         {
            _loc2_ = new BitmapData(_loc1_.width,_loc1_.height,true,0);
            _loc2_.threshold(_loc1_,_loc1_.rect,new Point(0,0),"!=",0,4278190080);
            this.textLayerBitmap = new BitmapData(_loc1_.width,_loc1_.height,true,0);
            this.textLayerBitmap.copyPixels(this.oldComposite,this.oldComposite.rect,new Point(0,0),_loc2_,new Point(0,0),false);
         }
         else if(_loc1_ != 0)
         {
         }
         this.oldComposite = null;
      }
      
      public function generateOrFindComposite(param1:Vector.<ScratchCostume>) : void
      {
         var _loc2_:ScratchCostume = null;
         if(this.bitmap != null)
         {
            return;
         }
         if(this.textLayerBitmap == null)
         {
            this.bitmap = this.baseLayerBitmap;
            return;
         }
         for each(_loc2_ in param1)
         {
            if(_loc2_.baseLayerBitmap === this.baseLayerBitmap && _loc2_.textLayerBitmap === this.textLayerBitmap && _loc2_.bitmap != null)
            {
               this.bitmap = _loc2_.bitmap;
               return;
            }
         }
         this.bitmap = this.baseLayerBitmap.clone();
         this.bitmap.draw(this.textLayerBitmap);
      }
   }
}

