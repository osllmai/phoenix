using System;
using System.Windows.Forms;
using WixSharp;
using WixSharp.UI.Forms;

namespace Phoenix.Dialogs
{
    partial class LicenceDialog
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
            this.components = new System.ComponentModel.Container();
            this.contextMenuStrip1 = new System.Windows.Forms.ContextMenuStrip(this.components);
            this.copyToolStripMenuItem = new System.Windows.Forms.ToolStripMenuItem();
            this.topPanel = new System.Windows.Forms.Panel();
            this.logoPictureBox = new System.Windows.Forms.PictureBox();
            this.titleLbl = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.topBorder = new System.Windows.Forms.Panel();
            this.middlePanel = new System.Windows.Forms.Panel();
            this.agreement = new System.Windows.Forms.RichTextBox();
            this.accepted = new System.Windows.Forms.CheckBox();
            this.bottomPanel = new System.Windows.Forms.Panel();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.next = new System.Windows.Forms.Button();
            this.cancel = new System.Windows.Forms.Button();
            this.print = new System.Windows.Forms.Button();
            this.back = new System.Windows.Forms.Button();
            this.border1 = new System.Windows.Forms.Panel();
            this.contextMenuStrip1.SuspendLayout();
            this.topPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.logoPictureBox)).BeginInit();
            this.middlePanel.SuspendLayout();
            this.bottomPanel.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.SuspendLayout();
            // 
            // contextMenuStrip1
            // 
            this.contextMenuStrip1.Items.AddRange(new System.Windows.Forms.ToolStripItem[] {
            this.copyToolStripMenuItem});
            this.contextMenuStrip1.Name = "contextMenuStrip1";
            this.contextMenuStrip1.Font = new System.Drawing.Font("Times New Roman", 10F);
            this.contextMenuStrip1.Size = new System.Drawing.Size(103, 26);
            // 
            // copyToolStripMenuItem
            // 
            this.copyToolStripMenuItem.Name = "copyToolStripMenuItem";
            this.copyToolStripMenuItem.Size = new System.Drawing.Size(102, 22);
            this.copyToolStripMenuItem.Text = "Copy";
            this.copyToolStripMenuItem.Font = new System.Drawing.Font("Times New Roman", 10F);
            this.copyToolStripMenuItem.Click += new System.EventHandler(this.copyToolStripMenuItem_Click);
            // 
            // topPanel
            // 
            this.topPanel.BackColor = System.Drawing.Color.White;
            this.topPanel.Controls.Add(this.logoPictureBox);
            this.topPanel.Controls.Add(this.titleLbl);
            this.topPanel.Controls.Add(this.label2);
            this.topPanel.Dock = System.Windows.Forms.DockStyle.Top;
            this.topPanel.Location = new System.Drawing.Point(0, 0);
            this.topPanel.Name = "topPanel";
            this.topPanel.Size = new System.Drawing.Size(500, 59);
            this.topPanel.TabIndex = 3;
            // 
            // logoPictureBox
            // 
            this.logoPictureBox.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.logoPictureBox.Location = new System.Drawing.Point(452, 10);
            this.logoPictureBox.Name = "logoPictureBox";
            this.logoPictureBox.Size = new System.Drawing.Size(40, 40);
            this.logoPictureBox.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.logoPictureBox.TabIndex = 0;
            this.logoPictureBox.TabStop = false;
            // 
            // titleLbl
            // 
            this.titleLbl.AutoSize = true;
            this.titleLbl.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.titleLbl.ForeColor = System.Drawing.Color.Black;
            this.titleLbl.Location = new System.Drawing.Point(15, 10);
            this.titleLbl.Name = "titleLbl";
            this.titleLbl.Size = new System.Drawing.Size(0, 15);
            this.titleLbl.TabIndex = 1;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Times New Roman", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(68)))), ((int)(((byte)(84)))), ((int)(((byte)(111)))));
            this.label2.Location = new System.Drawing.Point(15, 35);
            this.label2.Font = new System.Drawing.Font("Times New Roman", 9F);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(0, 15);
            this.label2.TabIndex = 2;
            // 
            // topBorder
            // 
            this.topBorder.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(223)))), ((int)(((byte)(228)))));
            this.topBorder.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.topBorder.Dock = System.Windows.Forms.DockStyle.Top;
            this.topBorder.Location = new System.Drawing.Point(0, 59);
            this.topBorder.Name = "topBorder";
            this.topBorder.Size = new System.Drawing.Size(500, 1);
            this.topBorder.TabIndex = 2;
            // 
            // middlePanel
            // 
            this.middlePanel.Controls.Add(this.agreement);
            this.middlePanel.Controls.Add(this.accepted);
            this.middlePanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.middlePanel.Location = new System.Drawing.Point(0, 60);
            this.middlePanel.Name = "middlePanel";
            this.middlePanel.Size = new System.Drawing.Size(500, 240);
            this.middlePanel.TabIndex = 1;
            // 
            // agreement
            // 
            this.agreement.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.agreement.BackColor = System.Drawing.Color.White;
            this.agreement.ContextMenuStrip = this.contextMenuStrip1;
            this.agreement.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(0)))), ((int)(((byte)(0)))), ((int)(((byte)(0)))));
            this.agreement.Location = new System.Drawing.Point(12, 12);
            this.agreement.Font = new System.Drawing.Font("Times New Roman", 9F);
            this.agreement.Name = "agreement";
            this.agreement.ReadOnly = true;
            this.agreement.Size = new System.Drawing.Size(476, 192);
            this.agreement.TabIndex = 0;
            this.agreement.Text = "";
            // 
            // accepted
            // 
            this.accepted.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left)));
            this.accepted.Font = new System.Drawing.Font("Times New Roman", 9F);
            this.accepted.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(23)))), ((int)(((byte)(43)))), ((int)(((byte)(77)))));
            this.accepted.Location = new System.Drawing.Point(12, 210);
            this.accepted.Font = new System.Drawing.Font("Times New Roman", 9F);
            this.accepted.Name = "accepted";
            this.accepted.Size = new System.Drawing.Size(460, 24);
            this.accepted.TabIndex = 1;
            this.accepted.Text = "I accept the terms in the License Agreement";
            this.accepted.CheckedChanged += new System.EventHandler(this.accepted_CheckedChanged);
            // 
            // bottomPanel
            // 
            this.bottomPanel.BackColor = System.Drawing.SystemColors.Control;
            this.bottomPanel.Controls.Add(this.tableLayoutPanel1);
            this.bottomPanel.Controls.Add(this.border1);
            this.bottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.bottomPanel.Location = new System.Drawing.Point(0, 300);
            this.bottomPanel.Font = new System.Drawing.Font("Times New Roman", 10F);
            this.bottomPanel.Name = "bottomPanel";
            this.bottomPanel.Size = new System.Drawing.Size(500, 50);
            this.bottomPanel.TabIndex = 4;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 5;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 82F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 84F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 90F));
            this.tableLayoutPanel1.Controls.Add(this.next, 3, 0);
            this.tableLayoutPanel1.Controls.Add(this.cancel, 4, 0);
            this.tableLayoutPanel1.Controls.Add(this.print, 2, 0);
            this.tableLayoutPanel1.Controls.Add(this.back, 0, 0);
            this.tableLayoutPanel1.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 1);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.Font = new System.Drawing.Font("Times New Roman", 10F);
            this.tableLayoutPanel1.Padding = new System.Windows.Forms.Padding(5, 10, 5, 10);
            this.tableLayoutPanel1.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel1.Size = new System.Drawing.Size(500, 49);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // next
            // 
            this.next.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.next.Enabled = false;
            this.next.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.next.FlatAppearance.BorderSize = 0;
            this.next.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            this.next.Location = new System.Drawing.Point(324, 13);
            this.next.Font = new System.Drawing.Font("Times New Roman", 8F);
            this.next.Name = "next";
            this.next.Size = new System.Drawing.Size(75, 28);
            this.next.TabIndex = 2;
            this.next.Text = "Next";
            this.next.UseVisualStyleBackColor = false;
            this.next.Click += new System.EventHandler(this.next_Click);
            // 
            // cancel
            // 
            this.cancel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.cancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cancel.FlatAppearance.BorderSize = 0;
            this.cancel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            this.cancel.Location = new System.Drawing.Point(408, 13);
            this.cancel.Font = new System.Drawing.Font("Times New Roman", 8F);
            this.cancel.Name = "cancel";
            this.cancel.Size = new System.Drawing.Size(75, 28);
            this.cancel.TabIndex = 3;
            this.cancel.Text = "Cancel";
            this.cancel.UseVisualStyleBackColor = false;
            this.cancel.Click += new System.EventHandler(this.cancel_Click);
            // 
            // print
            // 
            this.print.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.print.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.print.FlatAppearance.BorderSize = 0;
            this.print.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            this.print.Location = new System.Drawing.Point(242, 13);
            this.print.Font = new System.Drawing.Font("Times New Roman", 8F);
            this.print.Name = "print";
            this.print.Size = new System.Drawing.Size(75, 28);
            this.print.TabIndex = 0;
            this.print.Text = "Print";
            this.print.UseVisualStyleBackColor = false;
            this.print.Click += new System.EventHandler(this.print_Click);
            // 
            // back
            // 
            this.back.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.back.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.back.FlatAppearance.BorderSize = 0;
            this.back.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            this.back.Location = new System.Drawing.Point(8, 13);
            this.back.Font = new System.Drawing.Font("Times New Roman", 8F);
            this.back.Name = "back";
            this.back.Size = new System.Drawing.Size(75, 28);
            this.back.TabIndex = 1;
            this.back.Text = "Back";
            this.back.UseVisualStyleBackColor = false;
            this.back.Click += new System.EventHandler(this.back_Click);
            // 
            // border1
            // 
            this.border1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(223)))), ((int)(((byte)(228)))));
            this.border1.BorderStyle = System.Windows.Forms.BorderStyle.FixedSingle;
            this.border1.Dock = System.Windows.Forms.DockStyle.Top;
            this.border1.Location = new System.Drawing.Point(0, 0);
            this.border1.Name = "border1";
            this.border1.Size = new System.Drawing.Size(500, 1);
            this.border1.TabIndex = 1;
            // 
            // LicenceDialog
            // 
            this.ClientSize = new System.Drawing.Size(500, 350);
            this.Controls.Add(this.middlePanel);
            this.Controls.Add(this.topBorder);
            this.Controls.Add(this.topPanel);
            this.Controls.Add(this.bottomPanel);
            this.Name = "LicenceDialog";
            this.Text = "License Agreement";
            this.Load += new System.EventHandler(this.LicenceDialog_Load);
            this.contextMenuStrip1.ResumeLayout(false);
            this.topPanel.ResumeLayout(false);
            this.topPanel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.logoPictureBox)).EndInit();
            this.middlePanel.ResumeLayout(false);
            this.bottomPanel.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        private ContextMenuStrip contextMenuStrip1;
        private ToolStripMenuItem copyToolStripMenuItem;
        private Panel topBorder;
        private Panel topPanel;
        private Label label2;
        private Label titleLbl;
        private PictureBox logoPictureBox;
        private CheckBox accepted;
        private Panel bottomPanel;
        private TableLayoutPanel tableLayoutPanel1;
        private Button cancel;
        private Button print;
        private Button back;
        private Button next;
        private Panel border1;
        private Panel middlePanel;
        private RichTextBox agreement;

        #endregion
    }
}
