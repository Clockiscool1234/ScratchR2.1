package
{
   import assets.Resources;
   import flash.text.TextFormat;
   
   public class CSS
   {
      
      public static const topBarColor_ScratchX:int = 3164255;
      
      public static const backgroundColor_ScratchX:int = 4151669;
      
      public static const white:int = 16777215;
      
      public static const backgroundColor_default:int = white;
      
      public static const topBarColor_default:int = 10264226;
      
      public static const tabColor:int = 15132904;
      
      public static const panelColor:int = 15921906;
      
      public static const itemSelectedColor:int = 13684944;
      
      public static const borderColor:int = 13685202;
      
      public static const textColor:int = 6053215;
      
      public static const buttonLabelColor:int = textColor;
      
      public static const buttonLabelOverColor:int = 16492857;
      
      public static const offColor:int = 9408915;
      
      public static const onColor:int = textColor;
      
      public static const overColor:int = 1548247;
      
      public static const arrowColor:int = 10922156;
      
      public static const font:String = Resources.chooseFont(["Arial","Verdana","DejaVu Sans"]);
      
      public static const menuFontSize:int = 12;
      
      public static const normalTextFormat:TextFormat = new TextFormat(font,12,textColor);
      
      public static const topBarButtonFormat:TextFormat = new TextFormat(font,12,white,true);
      
      public static const titleFormat:TextFormat = new TextFormat(font,14,textColor);
      
      public static const thumbnailFormat:TextFormat = new TextFormat(font,11,textColor);
      
      public static const thumbnailExtraInfoFormat:TextFormat = new TextFormat(font,9,textColor);
      
      public static const projectTitleFormat:TextFormat = new TextFormat(font,13,textColor);
      
      public static const projectInfoFormat:TextFormat = new TextFormat(font,12,textColor);
      
      public static const titleBarColors:Array = [white,tabColor];
      
      public static const titleBarH:int = 30;
      
      public function CSS()
      {
         super();
      }
      
      public static function topBarColor() : int
      {
         return Scratch.app.isExtensionDevMode ? topBarColor_ScratchX : topBarColor_default;
      }
      
      public static function backgroundColor() : int
      {
         return Scratch.app.isExtensionDevMode ? backgroundColor_ScratchX : backgroundColor_default;
      }
   }
}

