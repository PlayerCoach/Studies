using Microsoft.VisualBasic;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel.Design.Serialization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Input;

namespace FileExplorer.MVVM.Model
{
    class MainWindowModel
    {
        private TreeViewItem? RootItem;
        private string? mainFolderPath; // useful for restroing the tree after deleting a file or folder
        private List<string> expandedDirectories = new List<string>();

        public TreeViewItem GetFolderTree(string path)
        {
            RootItem = createTree(path);
            mainFolderPath = path;
            return RootItem;
        }
        private TreeViewItem createTree(string path)
        {
            TreeViewItem item = new TreeViewItem();
            item.Header = System.IO.Path.GetFileName(path);
            item.Tag = path;

            foreach (string file in Directory.GetFiles(path))
            {
                TreeViewItem subItem = new TreeViewItem();
                subItem.Header = System.IO.Path.GetFileName(file);
                subItem.Tag = file;
                item.Items.Add(subItem);
            }

            foreach (string directory in Directory.GetDirectories(path))
            {
                item.Items.Add(createTree(directory));
            }
            return item;

        }
        public void DeleteItem(string path)
        {
            if (mainFolderPath == null)
            {
                System.Diagnostics.Debug.WriteLine("No folder selected.");
                return;
            }
            if (path == mainFolderPath)
            {
                System.Diagnostics.Debug.WriteLine("Cannot delete root folder.");
                return;
            }
            if (File.Exists(path))
            {
                SaveExpandedDirectories(RootItem);
                DeleteFile(path);
                var RootContext = createTree(mainFolderPath);
                ExpandDirectories(RootContext);
                RootItem = RootContext;
                expandedDirectories.Clear();
            }
            else if (Directory.Exists(path))
            {
                SaveExpandedDirectories(RootItem);
                DeleteFolder(path);
                var RootContext = createTree(mainFolderPath);
                ExpandDirectories(RootContext);
                RootItem = RootContext;
                expandedDirectories.Clear();
            }
            else
            {
                System.Diagnostics.Debug.WriteLine("Path does not exist.");
            }
        }

        static void DeleteFile(string filePath)
        {

            if ((File.GetAttributes(filePath) & FileAttributes.ReadOnly) == FileAttributes.ReadOnly)
            {
                File.SetAttributes(filePath, File.GetAttributes(filePath) & ~FileAttributes.ReadOnly);
            }

            try
            {
                File.Delete(filePath);
                System.Diagnostics.Debug.WriteLine("File deleted successfully.");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"An error occurred while deleting the file: {ex.Message}");
            }
        }

        static void DeleteFolder(string folderPath)
        {
            try
            {
                Directory.Delete(folderPath, true);
                System.Diagnostics.Debug.WriteLine("Folder and its contents deleted successfully.");
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine($"An error occurred while deleting the folder: {ex.Message}");
            }
        }

        public TreeViewItem GetRootItem()
        {
            return RootItem;
        }

        private void SaveExpandedDirectories(TreeViewItem root)
        {
            if (root.IsExpanded)
            {
                expandedDirectories.Add(root.Tag as string);
            }

            foreach (TreeViewItem item in root.Items)
            {
                SaveExpandedDirectories(item);
            }
        }

        private void ExpandDirectories(TreeViewItem root)
        {
            if (expandedDirectories.Contains(root.Tag as string))
            {
                root.IsExpanded = true;
            }

            foreach (TreeViewItem item in root.Items)
            {
                ExpandDirectories(item);
            }
        }

        public TreeViewItem ResetTree()
        {
            SaveExpandedDirectories(RootItem);
            RootItem = createTree(mainFolderPath);
            ExpandDirectories(RootItem);
            expandedDirectories.Clear();
            return RootItem;
        }

    }
}
