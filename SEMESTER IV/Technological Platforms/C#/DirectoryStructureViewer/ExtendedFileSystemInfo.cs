namespace DirectoryStructureViewer
{
    public static class ExtendedFileSystemInfo
    {
        public static string GetDOSInfo(this FileSystemInfo fileSystemInfo)
        {
           FileAttributes attributes = fileSystemInfo.Attributes;
           char r = (attributes & FileAttributes.ReadOnly) != 0 ? 'R' : '-';
           char a = (attributes & FileAttributes.Archive) != 0 ? 'A' : '-';
           char h = (attributes & FileAttributes.Hidden) != 0 ? 'H' : '-';
           char s = (attributes & FileAttributes.System) != 0 ? 'S' : '-';
           return r + "" + a + "" + h + "" + s;
          
           
        }
    }
    
}