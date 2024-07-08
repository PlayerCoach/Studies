namespace PtLab11
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.textBoxN = new System.Windows.Forms.TextBox();
            this.textBoxK = new System.Windows.Forms.TextBox();
            this.CalculateNewtonSymbolTask = new System.Windows.Forms.Button();
            this.CalculateNewtonSymbolDelegate = new System.Windows.Forms.Button();
            this.CalculateNewtonSymbolAsyncAwait = new System.Windows.Forms.Button();
            this.textBoxIndex = new System.Windows.Forms.TextBox();
            this.CalculateFibonacci = new System.Windows.Forms.Button();
            this.progressBar = new System.Windows.Forms.ProgressBar();
            this.CompressFiles = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // textBoxN
            // 
            this.textBoxN.Location = new System.Drawing.Point(30, 20);
            this.textBoxN.Name = "textBoxN";
            this.textBoxN.Size = new System.Drawing.Size(100, 20);
            this.textBoxN.TabIndex = 0;
            // 
            // textBoxK
            // 
            this.textBoxK.Location = new System.Drawing.Point(150, 20);
            this.textBoxK.Name = "textBoxK";
            this.textBoxK.Size = new System.Drawing.Size(100, 20);
            this.textBoxK.TabIndex = 1;
            // 
            // CalculateNewtonSymbolTask
            // 
            this.CalculateNewtonSymbolTask.Location = new System.Drawing.Point(30, 60);
            this.CalculateNewtonSymbolTask.Name = "CalculateNewtonSymbolTask";
            this.CalculateNewtonSymbolTask.Size = new System.Drawing.Size(220, 23);
            this.CalculateNewtonSymbolTask.TabIndex = 2;
            this.CalculateNewtonSymbolTask.Text = "Calculate Newton (Task)";
            this.CalculateNewtonSymbolTask.UseVisualStyleBackColor = true;
            this.CalculateNewtonSymbolTask.Click += new System.EventHandler(this.CalculateNewtonSymbolTask_Click);
            // 
            // CalculateNewtonSymbolDelegate
            // 
            this.CalculateNewtonSymbolDelegate.Location = new System.Drawing.Point(30, 90);
            this.CalculateNewtonSymbolDelegate.Name = "CalculateNewtonSymbolDelegate";
            this.CalculateNewtonSymbolDelegate.Size = new System.Drawing.Size(220, 23);
            this.CalculateNewtonSymbolDelegate.TabIndex = 3;
            this.CalculateNewtonSymbolDelegate.Text = "Calculate Newton (Delegate)";
            this.CalculateNewtonSymbolDelegate.UseVisualStyleBackColor = true;
            this.CalculateNewtonSymbolDelegate.Click += new System.EventHandler(this.CalculateNewtonSymbolDelegate_Click);
            // 
            // CalculateNewtonSymbolAsyncAwait
            // 
            this.CalculateNewtonSymbolAsyncAwait.Location = new System.Drawing.Point(30, 120);
            this.CalculateNewtonSymbolAsyncAwait.Name = "CalculateNewtonSymbolAsyncAwait";
            this.CalculateNewtonSymbolAsyncAwait.Size = new System.Drawing.Size(220, 23);
            this.CalculateNewtonSymbolAsyncAwait.TabIndex = 4;
            this.CalculateNewtonSymbolAsyncAwait.Text = "Calculate Newton (Async-Await)";
            this.CalculateNewtonSymbolAsyncAwait.UseVisualStyleBackColor = true;
            this.CalculateNewtonSymbolAsyncAwait.Click += new System.EventHandler(this.CalculateNewtonSymbolAsyncAwait_Click);
            // 
            // textBoxIndex
            // 
            this.textBoxIndex.Location = new System.Drawing.Point(30, 160);
            this.textBoxIndex.Name = "textBoxIndex";
            this.textBoxIndex.Size = new System.Drawing.Size(100, 20);
            this.textBoxIndex.TabIndex = 5;
            // 
            // CalculateFibonacci
            // 
            this.CalculateFibonacci.Location = new System.Drawing.Point(30, 190);
            this.CalculateFibonacci.Name = "CalculateFibonacci";
            this.CalculateFibonacci.Size = new System.Drawing.Size(220, 23);
            this.CalculateFibonacci.TabIndex = 6;
            this.CalculateFibonacci.Text = "Calculate Fibonacci";
            this.CalculateFibonacci.UseVisualStyleBackColor = true;
            this.CalculateFibonacci.Click += new System.EventHandler(this.CalculateFibonacci_Click);
            // 
            // progressBar
            // 
            this.progressBar.Location = new System.Drawing.Point(30, 220);
            this.progressBar.Name = "progressBar";
            this.progressBar.Size = new System.Drawing.Size(220, 23);
            this.progressBar.TabIndex = 7;
            // 
            // CompressFiles
            // 
            this.CompressFiles.Location = new System.Drawing.Point(30, 250);
            this.CompressFiles.Name = "CompressFiles";
            this.CompressFiles.Size = new System.Drawing.Size(220, 23);
            this.CompressFiles.TabIndex = 8;
            this.CompressFiles.Text = "Compress Files";
            this.CompressFiles.UseVisualStyleBackColor = true;
            this.CompressFiles.Click += new System.EventHandler(this.CompressFiles_Click);
            // 
            // Form1
            // 
            this.ClientSize = new System.Drawing.Size(284, 291);
            this.Controls.Add(this.CompressFiles);
            this.Controls.Add(this.progressBar);
            this.Controls.Add(this.CalculateFibonacci);
            this.Controls.Add(this.textBoxIndex);
            this.Controls.Add(this.CalculateNewtonSymbolAsyncAwait);
            this.Controls.Add(this.CalculateNewtonSymbolDelegate);
            this.Controls.Add(this.CalculateNewtonSymbolTask);
            this.Controls.Add(this.textBoxK);
            this.Controls.Add(this.textBoxN);
            this.Name = "Form1";
            this.Text = "PtLab11";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.TextBox textBoxN;
        private System.Windows.Forms.TextBox textBoxK;
        private System.Windows.Forms.Button CalculateNewtonSymbolTask;
        private System.Windows.Forms.Button CalculateNewtonSymbolDelegate;
        private System.Windows.Forms.Button CalculateNewtonSymbolAsyncAwait;
        private System.Windows.Forms.Button CalculateFibonacci;
        private System.Windows.Forms.TextBox textBoxIndex;
        private System.Windows.Forms.ProgressBar progressBar;
        private System.Windows.Forms.Button CompressFiles;
    }
}
