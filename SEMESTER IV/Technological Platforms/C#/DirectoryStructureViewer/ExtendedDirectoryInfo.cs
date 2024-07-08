namespace DirectoryStructureViewer
{
    public static class ExtendedDirectoryInfo 
    {
        public static (DateTime, string) GetOldestFileCreationTime(this DirectoryInfo directoryInfo, DateTime maxValue, string fileName = "")
        {
            
            foreach (FileInfo fileInfo in directoryInfo.GetFiles())
            {
                if (fileInfo.CreationTime < maxValue)
                {
                    maxValue = fileInfo.CreationTime;
                    fileName = fileInfo.Name;
                }
                
            }
            foreach(DirectoryInfo subDirectoryInfo in directoryInfo.GetDirectories())
                (maxValue, fileName) = subDirectoryInfo.GetOldestFileCreationTime(maxValue, fileName);
            
            return (maxValue, fileName);
            
            
        }
       
    
    }
}

