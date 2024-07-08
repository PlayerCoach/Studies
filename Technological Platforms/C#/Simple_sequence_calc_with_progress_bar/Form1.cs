using System;
using System.ComponentModel;
using System.IO;
using System.IO.Compression;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Numerics;

namespace PtLab11
{
    public partial class Form1 : Form
    {

        private BackgroundWorker backgroundWorker1;
        private FolderBrowserDialog folderBrowserDialog1;
        public Form1()
        {
            InitializeComponent();
            backgroundWorker1 = new BackgroundWorker
            {
                WorkerReportsProgress = true,
                WorkerSupportsCancellation = true
            };
            backgroundWorker1.DoWork += new DoWorkEventHandler(backgroundWorker1_DoWork);
            backgroundWorker1.ProgressChanged += new ProgressChangedEventHandler(backgroundWorker1_ProgressChanged);
            backgroundWorker1.RunWorkerCompleted += new RunWorkerCompletedEventHandler(backgroundWorker1_RunWorkerCompleted);

            folderBrowserDialog1 = new FolderBrowserDialog();
        }

        // Task and Task<T> Implementation for Newton Symbol
        private async void CalculateNewtonSymbolTask_Click(object sender, EventArgs e)
        {
            int n = int.Parse(textBoxN.Text);
            int k = int.Parse(textBoxK.Text);

            var result = await CalculateNewtonSymbolTaskAsync(n, k);
            MessageBox.Show($"Newton Symbol (Task) Result: {result}");
        }

        private async Task<BigInteger> CalculateNewtonSymbolTaskAsync(int n, int k)
        {
            BigInteger numerator = await Task.Run(() =>
            {
                BigInteger num = 1;
                for (int i = 0; i < k; i++)
                {
                    num *= (n - i);
                }
                return num;
            });

            BigInteger denominator = await Task.Run(() =>
            {
                BigInteger denom = 1;
                for (int i = 1; i <= k; i++)
                {
                    denom *= i;
                }
                return denom;
            });

            return BigInteger.Divide(numerator, denominator);
        }


        // Delegate Implementation for Newton Symbol
        private async void CalculateNewtonSymbolDelegate_Click(object sender, EventArgs e)
        {
            int n = int.Parse(textBoxN.Text);
            int k = int.Parse(textBoxK.Text);

            Func<int, int, Task<BigInteger>> calculateDelegate = CalculateNewtonSymbolDelegateAsync;
            var result = await calculateDelegate(n, k);
            MessageBox.Show($"Newton Symbol (Delegate) Result: {result}");
        }

        private async Task<BigInteger> CalculateNewtonSymbolDelegateAsync(int n, int k)
        {
            Func<BigInteger> calculateNumerator = () =>
            {
                BigInteger num = 1;
                for (int i = 0; i < k; i++)
                {
                    num *= (n - i);
                }
                return num;
            };

            Func<BigInteger> calculateDenominator = () =>
            {
                BigInteger denom = 1;
                for (int i = 1; i <= k; i++)
                {
                    denom *= i;
                }
                return denom;
            };

            Task<BigInteger> numeratorTask = Task.Run(calculateNumerator);
            Task<BigInteger> denominatorTask = Task.Run(calculateDenominator);

            await Task.WhenAll(numeratorTask, denominatorTask);

            return BigInteger.Divide(numeratorTask.Result, denominatorTask.Result);
        }

        // Async-Await Implementation for Newton Symbol
        private async void CalculateNewtonSymbolAsyncAwait_Click(object sender, EventArgs e)
        {
            int n = int.Parse(textBoxN.Text);
            int k = int.Parse(textBoxK.Text);
            var result = await CalculateNewtonSymbolAsyncAwaitMethod(n, k);
            MessageBox.Show($"Newton Symbol (Async-Await) Result: {result}");
        }

        private async Task<BigInteger> CalculateNewtonSymbolAsyncAwaitMethod(int n, int k)
        {
            Console.WriteLine("n: " + n);
            Console.WriteLine("k: " + k);

            BigInteger numerator = 1;
            BigInteger denominator = 1;

            for (int i = 0; i < k; i++)
            {
                numerator *= (n - i);
            }

            for (int i = 1; i <= k; i++)
            {
                denominator *= i;
            }

            return numerator / denominator;
        }

        // BackgroundWorker Implementation for Fibonacci Sequence
        private void CalculateFibonacci_Click(object sender, EventArgs e)
        {
            if (!backgroundWorker1.IsBusy)
            {
                int index = int.Parse(textBoxIndex.Text);
                progressBar.Maximum = index;
                backgroundWorker1.RunWorkerAsync(index);
            }
        }

        private void backgroundWorker1_DoWork(object sender, DoWorkEventArgs e)
        {
            int index = (int)e.Argument;
            BigInteger[] fib = new BigInteger[index + 1];

            for (int i = 0; i <= index; i++)
            {
                if (i == 0)
                    fib[i] = 0;
                else if (i == 1)
                    fib[i] = 1;
                else
                    fib[i] = fib[i - 1] + fib[i - 2];

                Thread.Sleep(5); // Simulate work
                backgroundWorker1.ReportProgress(i);
            }

            e.Result = fib[index];
        }

        private void backgroundWorker1_ProgressChanged(object sender, ProgressChangedEventArgs e)
        {
            progressBar.Value = e.ProgressPercentage;
        }

        private void backgroundWorker1_RunWorkerCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            MessageBox.Show($"Fibonacci Result: {e.Result}");
        }

        // Compression Implementation using GZipStream
        private void CompressFiles_Click(object sender, EventArgs e)
        {
            if (folderBrowserDialog1.ShowDialog() == DialogResult.OK)
            {
                string selectedPath = folderBrowserDialog1.SelectedPath;

                Parallel.ForEach(Directory.GetFiles(selectedPath), (filePath) =>
                {
                    string compressedFilePath = filePath + ".gz";

                    using (FileStream originalFileStream = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                    using (FileStream compressedFileStream = new FileStream(compressedFilePath, FileMode.Create))
                    using (GZipStream compressionStream = new GZipStream(compressedFileStream, CompressionMode.Compress))
                    {
                        originalFileStream.CopyTo(compressionStream);
                    }

                    // Remove the hidden attribute from the compressed file
                    File.SetAttributes(compressedFilePath, File.GetAttributes(compressedFilePath) & ~FileAttributes.Hidden);
                });

                MessageBox.Show("Compression Completed!");
            }
        }
    }
}
