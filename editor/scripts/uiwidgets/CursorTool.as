package uiwidgets
{
   import assets.Resources;
   import flash.display.*;
   import flash.events.*;
   import flash.geom.Point;
   import flash.system.Capabilities;
   import flash.ui.*;
   
   public class CursorTool
   {
      
      public static var tool:String;
      
      private static var app:Scratch;
      
      private static var currentCursor:Bitmap;
      
      private static var offsetX:int;
      
      private static var offsetY:int;
      
      private static var registeredCursors:Object = {};
      
      public function CursorTool()
      {
         super();
      }
      
      public static function setTool(param1:String) : void
      {
         hideSoftwareCursor();
         tool = param1;
         app.enableEditorTools(tool == null);
         if(tool == null)
         {
            return;
         }
         switch(tool)
         {
            case "copy":
               showSoftwareCursor(Resources.createBmp("copyCursor"));
               break;
            case "cut":
               showSoftwareCursor(Resources.createBmp("cutCursor"));
               break;
            case "grow":
               showSoftwareCursor(Resources.createBmp("growCursor"));
               break;
            case "shrink":
               showSoftwareCursor(Resources.createBmp("shrinkCursor"));
               break;
            case "help":
               showSoftwareCursor(Resources.createBmp("helpCursor"));
               break;
            case "draw":
               showSoftwareCursor(Resources.createBmp("pencilCursor"));
               break;
            default:
               tool = null;
         }
         mouseMove(null);
      }
      
      private static function hideSoftwareCursor() : void
      {
         if(Boolean(currentCursor) && Boolean(currentCursor.parent))
         {
            currentCursor.parent.removeChild(currentCursor);
         }
         currentCursor = null;
         Mouse.cursor = MouseCursor.AUTO;
         Mouse.show();
      }
      
      private static function showSoftwareCursor(param1:Bitmap, param2:int = 999, param3:int = 999) : void
      {
         if(param1)
         {
            if(Boolean(currentCursor) && Boolean(currentCursor.parent))
            {
               currentCursor.parent.removeChild(currentCursor);
            }
            currentCursor = new Bitmap(param1.bitmapData);
            CursorTool.offsetX = param2 <= param1.width ? param2 : int(param1.width / 2);
            CursorTool.offsetY = param3 <= param1.height ? param3 : int(param1.height / 2);
            app.stage.addChild(currentCursor);
            Mouse.hide();
            mouseMove(null);
         }
      }
      
      public static function init(param1:Scratch) : void
      {
         CursorTool.app = param1;
         param1.stage.addEventListener(MouseEvent.MOUSE_MOVE,mouseMove);
         param1.stage.addEventListener(Event.MOUSE_LEAVE,mouseLeave);
      }
      
      private static function mouseMove(param1:*) : void
      {
         if(currentCursor)
         {
            Mouse.hide();
            currentCursor.x = app.mouseX - offsetX;
            currentCursor.y = app.mouseY - offsetY;
         }
      }
      
      private static function mouseLeave(param1:*) : void
      {
         Mouse.cursor = MouseCursor.AUTO;
         Mouse.show();
      }
      
      public static function setCustomCursor(param1:String, param2:BitmapData = null, param3:Point = null, param4:Boolean = true) : void
      {
         var _loc5_:Array = ["arrow","auto","button","hand","ibeam"];
         if(tool)
         {
            return;
         }
         hideSoftwareCursor();
         if(_loc5_.indexOf(param1) != -1)
         {
            Mouse.cursor = param1;
            return;
         }
         if("" == param1 && !param4)
         {
            showSoftwareCursor(new Bitmap(param2),param3.x,param3.y);
            return;
         }
         var _loc6_:Array = registeredCursors[param1];
         if(Boolean(_loc6_) && param4)
         {
            if(isLinux())
            {
               showSoftwareCursor(new Bitmap(_loc6_[0]),_loc6_[1].x,_loc6_[1].y);
            }
            else
            {
               Mouse.cursor = param1;
            }
            return;
         }
         if(Boolean(param2) && Boolean(param3))
         {
            registeredCursors[param1] = [param2,param3];
            if(isLinux())
            {
               showSoftwareCursor(new Bitmap(param2),param3.x,param3.y);
            }
            else
            {
               registerHardwareCursor(param1,param2,param3);
            }
         }
      }
      
      private static function isLinux() : Boolean
      {
         var _loc1_:String = Capabilities.os;
         if(_loc1_.indexOf("Mac OS") > -1)
         {
            return false;
         }
         if(_loc1_.indexOf("Win") > -1)
         {
            return false;
         }
         return true;
      }
      
      private static function registerHardwareCursor(param1:String, param2:BitmapData, param3:Point) : void
      {
         var _loc4_:Vector.<BitmapData> = new Vector.<BitmapData>(1,true);
         _loc4_[0] = param2;
         var _loc5_:MouseCursorData = new MouseCursorData();
         _loc5_.data = _loc4_;
         _loc5_.hotSpot = param3;
         Mouse.registerCursor(param1,_loc5_);
      }
   }
}

