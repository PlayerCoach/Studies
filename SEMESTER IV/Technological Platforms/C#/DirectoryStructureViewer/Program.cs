// microsoft documentation: https://learn.microsoft.com/pl-pl/dotnet/api/system.io.directory.getfiles?view=net-8.0
using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace DirectoryStructureViewer;

internal abstract class Program
{
    public static void Main(string[] args)
    {
        if (args.Length == 0)
        {
            Console.WriteLine("No directory specified.");
            return;
        }
        
        if(!Directory.Exists(args[0]))
        {
            Console.WriteLine("Directory does not exist.");
            return;
        }
        
        
        
        string path = args[0];
        DateTime maxValue = DateTime.MaxValue;
        DirectoryInfo directoryInfo = new DirectoryInfo(path);
        
        IComparer<string> comparer = new CustomStringComparer();
        SortedDictionary<string, long> filesAndSizes = new SortedDictionary<string, long>(comparer);
        AddFilesToCollection(directoryInfo, filesAndSizes);
        SerializeCollection(filesAndSizes);
        filesAndSizes = DeserializeCollection();
        
        
        
        string directoryName = directoryInfo.Name;
        string dosInfo = directoryInfo.GetDOSInfo();
        string fileCount = "(" + CountAllFilesInDirectory(directoryInfo).ToString() + ")";
        Console.WriteLine("=> {0} {1} {2}", directoryName, fileCount, dosInfo);
        ProcessDirectory(path, 0);
        Console.WriteLine("Collection: ");
        printCollection(filesAndSizes);
        (DateTime oldestFileCreation, string oldestFileName) = directoryInfo.GetOldestFileCreationTime(maxValue);
        Console.WriteLine("Oldest file in {0} is {1} created at {2}", directoryInfo.Name, oldestFileName, oldestFileCreation);
        
    }
    
    private static void ProcessDirectory(string targetDirectory, int level)
    {
        level++;
        string[] fileEntries = Directory.GetFiles(targetDirectory);
        foreach (string fileName in fileEntries)
            ProcessFile(fileName, level);
                
        string[] subdirectoryEntries = Directory.GetDirectories(targetDirectory);
        foreach (string subdirectory in subdirectoryEntries)
        {
            DirectoryInfo directoryInfo = new DirectoryInfo(subdirectory);
            string subdirectoryName = directoryInfo.Name;
            string dosInfo = directoryInfo.GetDOSInfo();
            string fileCount = "(" + CountAllFilesInDirectory(directoryInfo).ToString() + ")";
            Console.WriteLine("{0} -> {1} {2} {3}", new string(' ', level * 3), subdirectoryName,fileCount, dosInfo);
            ProcessDirectory(subdirectory, level );
        }
    }
    
    private static void ProcessFile(string path, int level)
    {
       
        FileInfo fileInfo = new FileInfo(path);
        string name = fileInfo.Name;
        string dosInfo = fileInfo.GetDOSInfo();
        long fileSize = fileInfo.Length;
        string size = fileSize < 1024 ? fileSize + " B" : fileSize < 1024 * 1024 ? fileSize / 1024 + " KB" : fileSize / 1024 / 1024 + " MB";
        Console.WriteLine("{0} -> {1} {2} {3}", new string(' ', level * 3), name, size, dosInfo);
    }
    
    private static int CountAllFilesInDirectory(DirectoryInfo directoryInfo, int fileCount=0)
    {
        fileCount += directoryInfo.GetFiles().Length;
        foreach (DirectoryInfo unused in directoryInfo.GetDirectories())
            fileCount++;
        return fileCount;
    }
    
    private static void AddFilesToCollection(DirectoryInfo directoryInfo, SortedDictionary<string, long> filesAndSizes)
    {
        foreach (FileInfo fileInfo in directoryInfo.GetFiles())
        {
            filesAndSizes.Add(fileInfo.Name, fileInfo.Length);
        }
        foreach (DirectoryInfo subdirectory in directoryInfo.GetDirectories())
        {
            filesAndSizes.Add(subdirectory.Name, CountAllFilesInDirectory(subdirectory));
        }
    }
    
    private static void SerializeCollection(SortedDictionary<string, long> filesAndSizes)
    {
       BinaryFormatter formatter = new BinaryFormatter();
       using (FileStream fileStream = new FileStream("filesAndSizes.bin", FileMode.Create, FileAccess.Write))
       {
           formatter.Serialize(fileStream, filesAndSizes);
       }
       
    }
    
    private static SortedDictionary<string, long> DeserializeCollection()
    {
        BinaryFormatter formatter = new BinaryFormatter();
        using (FileStream fileStream = new FileStream("filesAndSizes.bin", FileMode.Open, FileAccess.Read))
        {
            return (SortedDictionary<string, long>) formatter.Deserialize(fileStream);
        }
    }
    
    private static void printCollection(SortedDictionary<string, long> filesAndSizes)
    {
        foreach (KeyValuePair<string, long> keyValuePair in filesAndSizes)
        {
            Console.WriteLine("{0} -> {1}", keyValuePair.Key, keyValuePair.Value);
        }
    }
}