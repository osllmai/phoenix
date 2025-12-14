using System.Windows.Forms;
using System.Drawing;

namespace Phoenix.Dialogs
{
    partial class ProgressDialog
    {
        private System.ComponentModel.IContainer components = null;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
                components.Dispose();
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        private void InitializeComponent()
        {
            this.topPanel = new Panel();
            this.dialogText = new Label();
            this.logoPictureBox = new PictureBox();
            this.topBorder = new Panel();
            this.description = new Label();
            this.currentActionLabel = new Label();
            this.progress = new ProgressBar();
            this.waitPrompt = new Label();
            this.bottomPanel = new Panel();
            this.tableLayoutPanel1 = new TableLayoutPanel();
            this.back = new Button();
            this.next = new Button();
            this.cancel = new Button();
            this.bottomBorder = new Panel();
            this.currentAction = new Label();

            this.topPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.logoPictureBox)).BeginInit();
            this.bottomPanel.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();

            // 
            // topPanel
            // 
            this.topPanel.Anchor = ((AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right));
            this.topPanel.BackColor = Color.FromArgb(247, 248, 249);
            this.topPanel.Controls.Add(this.dialogText);
            this.topPanel.Controls.Add(this.logoPictureBox);
            this.topPanel.Location = new Point(0, 0);
            this.topPanel.Name = "topPanel";
            this.topPanel.Size = new Size(494, 60);
            this.topPanel.TabIndex = 0;

            // 
            // dialogText
            // 
            this.dialogText.AutoSize = true;
            this.dialogText.BackColor = Color.Transparent;
            this.dialogText.Font = new Font("Times New Roman", 12F, FontStyle.Bold);
            this.dialogText.ForeColor = Color.Black;
            this.dialogText.Location = new Point(12, 20);
            this.dialogText.Name = "dialogText";
            this.dialogText.Size = new Size(250, 19);
            this.dialogText.TabIndex = 1;
            this.dialogText.Text = "Installing Phoenix - Please wait";

            // 
            // logoPictureBox
            // 
            this.logoPictureBox.Anchor = ((AnchorStyles.Top | AnchorStyles.Right));
            this.logoPictureBox.Location = new Point(440, 10);
            this.logoPictureBox.Name = "logoPictureBox";
            this.logoPictureBox.Size = new Size(42, 42);
            this.logoPictureBox.SizeMode = PictureBoxSizeMode.Zoom;
            this.logoPictureBox.TabIndex = 2;
            this.logoPictureBox.TabStop = false;

            // 
            // topBorder
            // 
            this.topBorder.Anchor = ((AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right));
            this.topBorder.BackColor = Color.FromArgb(220, 223, 228);
            this.topBorder.BorderStyle = BorderStyle.FixedSingle;
            this.topBorder.Location = new Point(0, 60);
            this.topBorder.Name = "topBorder";
            this.topBorder.Size = new Size(494, 1);
            this.topBorder.TabIndex = 3;

            // 
            // description
            // 
            this.description.AutoSize = false;
            this.description.BackColor = Color.Transparent;
            this.description.Font = new Font("Times New Roman", 10F);
            this.description.ForeColor = Color.FromArgb(68, 84, 111);
            this.description.Location = new Point(30, 80);
            this.description.Name = "description";
            this.description.Size = new Size(440, 30);
            this.description.TabIndex = 4;
            this.description.Text = "Phoenix is being installed on your computer...";

            // 
            // currentActionLabel
            // 
            this.currentActionLabel.BackColor = Color.Transparent;
            this.currentActionLabel.Font = new Font("Times New Roman", 9F);
            this.currentActionLabel.ForeColor = Color.FromArgb(68, 84, 111);
            this.currentActionLabel.Location = new Point(30, 120);
            this.currentActionLabel.Name = "currentActionLabel";
            this.currentActionLabel.Size = new Size(100, 20);
            this.currentActionLabel.TabIndex = 5;
            this.currentActionLabel.Text = "Status:";

            // 
            // progress
            // 
            this.progress.Anchor = ((AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right));
            this.progress.Location = new Point(30, 145);
            this.progress.Name = "progress";
            this.progress.Size = new Size(434, 14);
            this.progress.Style = ProgressBarStyle.Continuous;
            this.progress.TabIndex = 6;

            // 
            // waitPrompt
            // 
            this.waitPrompt.Anchor = AnchorStyles.Top;
            this.waitPrompt.AutoSize = true;
            this.waitPrompt.Font = new Font("Times New Roman", 9F, FontStyle.Italic);
            this.waitPrompt.ForeColor = Color.FromArgb(53, 44, 99);
            this.waitPrompt.Location = new Point(110, 175);
            this.waitPrompt.Name = "waitPrompt";
            this.waitPrompt.Size = new Size(270, 15);
            this.waitPrompt.TabIndex = 7;
            this.waitPrompt.Text = "Please wait while Phoenix completes the installation...";

            // 
            // bottomPanel
            // 
            this.bottomPanel.Anchor = ((AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right));
            this.bottomPanel.BackColor = Color.FromArgb(247, 248, 249);
            this.bottomPanel.Controls.Add(this.tableLayoutPanel1);
            this.bottomPanel.Controls.Add(this.bottomBorder);
            this.bottomPanel.Location = new Point(0, 312);
            this.bottomPanel.Name = "bottomPanel";
            this.bottomPanel.Size = new Size(494, 49);
            this.bottomPanel.TabIndex = 8;

            // 
            // bottomBorder
            // 
            this.bottomBorder.Anchor = ((AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right));
            this.bottomBorder.BackColor = Color.FromArgb(220, 223, 228);
            this.bottomBorder.BorderStyle = BorderStyle.FixedSingle;
            this.bottomBorder.Location = new Point(0, 0);
            this.bottomBorder.Name = "bottomBorder";
            this.bottomBorder.Size = new Size(494, 1);
            this.bottomBorder.TabIndex = 9;

            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.Anchor = ((AnchorStyles.Left | AnchorStyles.Right));
            this.tableLayoutPanel1.ColumnCount = 5;
            this.tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle(SizeType.Percent, 100F));
            this.tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle(SizeType.Absolute, 14F));
            this.tableLayoutPanel1.ColumnStyles.Add(new ColumnStyle());
            this.tableLayoutPanel1.Controls.Add(this.back, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.next, 2, 0);
            this.tableLayoutPanel1.Controls.Add(this.cancel, 4, 0);
            this.tableLayoutPanel1.Location = new Point(0, 3);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.RowCount = 1;
            this.tableLayoutPanel1.RowStyles.Add(new RowStyle(SizeType.Percent, 100F));
            this.tableLayoutPanel1.Size = new Size(491, 43);
            this.tableLayoutPanel1.TabIndex = 10;

            // 
            // back
            // 
            this.back.Anchor = AnchorStyles.Right;
            this.back.AutoSize = true;
            this.back.Enabled = false;
            this.back.FlatStyle = FlatStyle.Flat;
            this.back.BackColor = Color.FromArgb(159, 143, 239);
            this.back.ForeColor = Color.White;
            this.back.Font = new Font("Times New Roman", 9F);
            this.back.Text = "[WixUIBack]";
            this.back.Size = new Size(90, 26);
            this.back.UseVisualStyleBackColor = false;

            // 
            // next
            // 
            this.next.Anchor = AnchorStyles.Right;
            this.next.AutoSize = true;
            this.next.Enabled = false;
            this.next.FlatStyle = FlatStyle.Flat;
            this.next.BackColor = Color.FromArgb(159, 143, 239);
            this.next.ForeColor = Color.White;
            this.next.Font = new Font("Times New Roman", 9F);
            this.next.Text = "[WixUINext]";
            this.next.Size = new Size(90, 26);
            this.next.UseVisualStyleBackColor = false;

            // 
            // cancel
            // 
            this.cancel.Anchor = AnchorStyles.Right;
            this.cancel.AutoSize = true;
            this.cancel.FlatStyle = FlatStyle.Flat;
            this.cancel.BackColor = Color.FromArgb(159, 143, 239);
            this.cancel.ForeColor = Color.White;
            this.cancel.Font = new Font("Times New Roman", 9F);
            this.cancel.Text = "[WixUICancel]";
            this.cancel.Size = new Size(90, 26);
            this.cancel.UseVisualStyleBackColor = false;
            this.cancel.Click += new System.EventHandler(this.cancel_Click);

            // 
            // currentAction
            // 
            this.currentAction.AutoSize = true;
            this.currentAction.ForeColor = Color.FromArgb(68, 84, 111);
            this.currentAction.Location = new Point(90, 120);
            this.currentAction.Name = "currentAction";
            this.currentAction.Size = new Size(0, 15);
            this.currentAction.TabIndex = 11;

            // 
            // ProgressDialog
            // 
            this.AutoScaleMode = AutoScaleMode.Font;
            this.BackColor = Color.White;
            this.ClientSize = new Size(494, 361);
            this.Controls.Add(this.currentAction);
            this.Controls.Add(this.bottomPanel);
            this.Controls.Add(this.waitPrompt);
            this.Controls.Add(this.progress);
            this.Controls.Add(this.currentActionLabel);
            this.Controls.Add(this.description);
            this.Controls.Add(this.topBorder);
            this.Controls.Add(this.topPanel);
            this.Font = new Font("Times New Roman", 9F);
            this.Name = "ProgressDialog";
            this.Text = "Phoenix Setup Progress";
            this.Load += new System.EventHandler(this.ProgressDialog_Load);

            this.topPanel.ResumeLayout(false);
            this.topPanel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.logoPictureBox)).EndInit();
            this.bottomPanel.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.tableLayoutPanel1.PerformLayout();
            this.ResumeLayout(false);
            this.PerformLayout();
        }

        #endregion

        private Panel topPanel;
        private Label dialogText;
        private PictureBox logoPictureBox;
        private Panel topBorder;
        private Label description;
        private Label currentActionLabel;
        private ProgressBar progress;
        private Label waitPrompt;
        private Panel bottomPanel;
        private TableLayoutPanel tableLayoutPanel1;
        private Button back;
        private Button next;
        private Button cancel;
        private Panel bottomBorder;
        private Label currentAction;
    }
}
