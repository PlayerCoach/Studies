using FileExplorer.MVVM.ViewModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace FileExplorer.MVVM.View
{
    /// <summary>
    /// Interaction logic for CreateFileForm.xaml
    /// </summary>
    public partial class CreateFileForm : Window
    {
        private string path;
        public CreateFileForm(string path)
        {
            InitializeComponent();
            this.path = path;
            CreateFileFormViewModel createFileFormViewModel = new CreateFileFormViewModel(path);
            this.DataContext = createFileFormViewModel;
        }
    }
}
