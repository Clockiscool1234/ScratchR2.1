package by.blooddy.crypto.image
{
   import flash.utils.getQualifiedClassName;
   
   public final class PNGFilter
   {
      
      public static const NONE:int = 0;
      
      public static const SUB:int = 1;
      
      public static const UP:int = 2;
      
      public static const AVERAGE:int = 3;
      
      public static const PAETH:int = 4;
      
      public function PNGFilter()
      {
         super();
         Error.throwError(ArgumentError,2012,getQualifiedClassName(this));
      }
   }
}

