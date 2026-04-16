package grabcut.vfs
{
   public class CheckPath
   {
      
      public static const PATH_VALID:String = "pathValid";
      
      public static const PATH_COMPONENT_DOES_NOT_EXIST:String = "pathComponentDoesNotExist";
      
      public static const PATH_COMPONENT_IS_NOT_DIRECTORY:String = "pathComponentIsNotDirectory";
      
      public function CheckPath()
      {
         super();
      }
   }
}

import grabcut.vfs.CheckPath;
import grabcut.vfs.FileHandle;
import grabcut.vfs.IVFS;

