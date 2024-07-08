using FileExplorer.Commands;
using System;
using System.IO;
using System.Text.RegularExpressions;
using System.Windows;
using System.Windows.Input;
using System.Text.RegularExpressions;

namespace FileExplorer.MVVM.ViewModel
{
    internal class CreateFileFormViewModel
    {
        private string path;
        public string FileName { get; set; }
        public bool IsFile { get; set; }
        public bool IsReadOnly { get; set; }
        public bool IsArchive { get; set; }
        public bool IsHidden { get; set; }
        public bool IsSystem { get; set; }

        public ICommand CreateCommand { get; set; }
        public ICommand CancelCommand { get; set; }

        public CreateFileFormViewModel(string path)
        {
            this.path = path;
            CreateCommand = new RelayCommand(CreateFile, _ => true);
            CancelCommand = new RelayCommand(Cancel, _ => true);
        }

        private void CreateFile(object parameter)
        {
            if(string.IsNullOrEmpty(FileName))
            {
                System.Windows.MessageBox.Show("Please enter a file name.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                return;
            }
            string fullPath = Path.Combine(path, FileName);
            if (IsFile)
            {
                if (!CheckIfValidFileName())
                {
                    System.Windows.MessageBox.Show("Invalid file name. \n Please enter a valid file name.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
                File.Create(fullPath);
            }
            else
            {
                if (!CHeckIfValidDirectoryName())
                {
                    System.Windows.MessageBox.Show("Invalid directory name. \n Please enter a valid directory name.", "Error", MessageBoxButton.OK, MessageBoxImage.Error);
                    return;
                }
                Directory.CreateDirectory(fullPath);
            }

            FileAttributes attributes = File.GetAttributes(fullPath);
            if (IsReadOnly) attributes |= FileAttributes.ReadOnly;
            if (IsArchive) attributes |= FileAttributes.Archive;
            if (IsHidden) attributes |= FileAttributes.Hidden;
            if (IsSystem) attributes |= FileAttributes.System;
            File.SetAttributes(fullPath, attributes);
            Cancel(parameter);
        }

        private void Cancel(object parameter)
        {
            try
            {
                Window window = parameter as Window;
                if (window != null)
                {
                    window.Close();
                }
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.WriteLine("An error occurred while closing the window: " + ex.Message);
            }
        }

        private bool CheckIfValidFileName()
        {
            string pattern = @"^[a-zA-Z0-9_~-]{1,8}\.(txt|php|html)$";
            return Regex.IsMatch(FileName, pattern);
        }

        private bool CHeckIfValidDirectoryName()
        {
            string pattern = @"^[a-zA-Z0-9_~-]{1,8}$";
            return Regex.IsMatch(FileName, pattern);
        }
    }
}
