using FileExplorer.Commands;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Runtime.CompilerServices;
using System.Windows.Controls;
using System.Windows.Input;
using FileExplorer.MVVM.View;
using FileExplorer.MVVM.Model;
using System.Windows;
using System.Diagnostics;
using System.Windows.Media;
using TreeView = System.Windows.Controls.TreeView;
using TextBlock = System.Windows.Controls.TextBlock;
using System.Net.WebSockets;

namespace FileExplorer.MVVM.ViewModel
{
    public class MainWindowViewModel : INotifyPropertyChanged
    {
        //references from view
        private TreeView FileTree;
        private TextBlock FilePreviewTextBlock;

        private TreeViewItem? _selectedItem; // node from tree that is currently selected

        private TreeViewItem? _rootDirectory;
        public TreeViewItem? RootDirectory
        {
            get { return _rootDirectory; }
            set
            {
                _rootDirectory = value;
                OnPropertyChanged();
            }
        }


        private string _statusBarText;
        public string StatusBarText
        {
            get { return _statusBarText; }
            set
            {
                _statusBarText = value;
                OnPropertyChanged();
            }
        }

        public ICommand OpenFileCommand { get; set; }
        public ICommand CloseAppCommand { get; set; }
        public ICommand DeleteFileCommand { get; set; }
        public ICommand CreateFileCommand { get; set; }
        public ICommand ReadFileCommand { get; set; }

        private MainWindowModel mainWindowModel = new MainWindowModel(); // reference to  model for the main window


        public event PropertyChangedEventHandler? PropertyChanged;
        protected virtual void OnPropertyChanged([CallerMemberName] string propertyName = "")
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
   

        public MainWindowViewModel(TreeView thisFileTree, TextBlock thisFilepreviewTextBlock)
        {
            OpenFileCommand = new RelayCommand(OpenFile,_ => true);
            CloseAppCommand = new RelayCommand(CloseApp, _ => true);
            DeleteFileCommand = new RelayCommand(DeleteFile, CanDeleteFile);
            CreateFileCommand = new RelayCommand(CreateFile, CanCreateFile);
            ReadFileCommand = new RelayCommand(ReadFile, CanReadFile);
            FileTree = thisFileTree;
            FilePreviewTextBlock = thisFilepreviewTextBlock;
            FileTree.PreviewMouseRightButtonDown += TreeView_PreviewMouseRightButtonDown;
            FileTree.PreviewMouseLeftButtonDown += TreeView_PreviewMouseLeftButtonDown; 
        }

        private void TreeView_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            if (e.OriginalSource is FrameworkElement originalSource)
            {
                TreeViewItem item = GetNearestContainer(originalSource);
                if (item == null && _selectedItem != null)
                {
                    // If the clicked element is not a TreeViewItem, clear the selection
                    _selectedItem.IsSelected = false;
                    _selectedItem = null;
                    StatusBarText = "";
                }
                else if (item != null)
                {
                    _selectedItem = item;
                    var filePath = item.Tag as string;
                    if (File.Exists(filePath) || Directory.Exists(filePath))
                    {
                        ShowFileAttributes(filePath);
                    }
                }
            }
        }

        private void ShowFileAttributes(string filePath)
        {
            var attributes = File.GetAttributes(filePath);
            var isReadOnly = attributes.HasFlag(FileAttributes.ReadOnly) ? "R" : "-";
            var isArchive = attributes.HasFlag(FileAttributes.Archive) ? "A" : "-";
            var isHidden = attributes.HasFlag(FileAttributes.Hidden) ? "H" : "-";
            var isSystem = attributes.HasFlag(FileAttributes.System) ? "S" : "-";
            StatusBarText = $"Attributes: {isReadOnly}{isArchive}{isHidden}{isSystem}";
        }

        private void TreeView_PreviewMouseRightButtonDown(object sender, MouseButtonEventArgs e)
        {
            if (e.OriginalSource is FrameworkElement originalSource)
            {
                TreeViewItem item = GetNearestContainer(originalSource);
                if (item != null)
                {
                    item.IsSelected = true;
                    _selectedItem = item;
                    ShowContextMenu(item);
                    e.Handled = true;
                   
                }
            }
        }

        private TreeViewItem GetNearestContainer(FrameworkElement element)
        {
            while (element != null && !(element is TreeViewItem))
            {
                element = VisualTreeHelper.GetParent(element) as FrameworkElement;
            }
            return element as TreeViewItem;
        }

        private void ShowContextMenu(TreeViewItem item)
        {
            ContextMenu contextMenu = new ContextMenu();

            var path = item.Tag as string;

            if(File.Exists(path))
            {
                MenuItem ReadFileItem = new MenuItem
                {
                    Header = "Read File",
                    Command = ReadFileCommand,
                    CommandParameter = item.Tag

                };
                contextMenu.Items.Add(ReadFileItem);
            }
           
            if(Directory.Exists(path))
            {
                MenuItem createFileItem = new MenuItem
                {
                    Header = "Create File",
                    Command = CreateFileCommand,
                    CommandParameter = item.Tag
                };
                contextMenu.Items.Add(createFileItem);
            }
            MenuItem deleteFileItem = new MenuItem
            {
                Header = "Delete File",
                Command = DeleteFileCommand,
                CommandParameter = item.Tag
            };
            contextMenu.Items.Add(deleteFileItem);
            contextMenu.IsOpen = true;
        }
        private void OpenFile(object obj)
        {
            var dlg = new FolderBrowserDialog() { Description = "Select directory to open" };
            dlg.ShowDialog();
            if (string.IsNullOrEmpty(dlg.SelectedPath))
            {
                return;
            }
            FileTree.Items.Clear();
            RootDirectory = mainWindowModel.GetFolderTree(dlg.SelectedPath);
            FileTree.Items.Add(RootDirectory);
            FilePreviewTextBlock.Text = "";
        }

        private void CloseApp(object obj)
        {
            System.Windows.Application.Current.Shutdown();
        }
        private bool CanReadFile(object obj)
        {
            var path = _selectedItem?.Tag as string;
            if (path == null)
            {
                return false;
            }
            if (File.Exists(path))
            {
             return true;
            }
            return false;
            
        }

        private void ReadFile(object obj)
        {
            var path = _selectedItem?.Tag as string;
            if (File.Exists(path))
            {
                var content = File.ReadAllText(path);
                FilePreviewTextBlock.Text = content;

            }
            else
            {
                FilePreviewTextBlock.Text = "No available preview for this file";
            }
        }

        private bool CanDeleteFile(object obj)
        {
            var path = _selectedItem?.Tag as string;
            if (path == null)
            {
                return false;
            }
            if ((File.Exists(path) || Directory.Exists(path)))
                return true;
            else return false;
        }

        private void DeleteFile(object tag)
        {
            var path = _selectedItem?.Tag as string;
            if (path == null)
            {
                return;
            }
            mainWindowModel.DeleteItem(path);
            FileTree.Items.Clear();
            FileTree.Items.Add(mainWindowModel.GetRootItem());
        }
        private bool CanCreateFile(object obj)
        {
            var path = _selectedItem?.Tag as string;
            if (Directory.Exists(path))
            {
                return true;
            }
            return false;
        }

        private void CreateFile(object obj)
        {
            var path = _selectedItem?.Tag as string;
            if (path == null)
            {
                return;
            }
            CreateFileForm createFileForm = new CreateFileForm(path);
            createFileForm.ShowDialog();
            FileTree.Items.Clear();

            FileTree.Items.Add(mainWindowModel.ResetTree());
        }
    }
}
