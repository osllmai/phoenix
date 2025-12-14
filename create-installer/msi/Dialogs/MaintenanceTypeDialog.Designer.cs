using System;
using System.Windows.Forms;
using System.Drawing;
using WixSharp;
using WixSharp.UI.Forms;

namespace Phoenix.Dialogs
{
	partial class MaintenanceTypeDialog
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
            this.topBorder = new System.Windows.Forms.Panel();
            this.topPanel = new System.Windows.Forms.Panel();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.banner = new System.Windows.Forms.PictureBox();
            this.bottomPanel = new System.Windows.Forms.Panel();
            this.tableLayoutPanel1 = new System.Windows.Forms.TableLayoutPanel();
            this.back = new System.Windows.Forms.Button();
            this.next = new System.Windows.Forms.Button();
            this.cancel = new System.Windows.Forms.Button();
            this.border1 = new System.Windows.Forms.Panel();
            this.middlePanel = new System.Windows.Forms.TableLayoutPanel();
            this.panel3 = new System.Windows.Forms.Panel();
            this.change = new System.Windows.Forms.Button();
            this.label3 = new System.Windows.Forms.Label();
            this.panel4 = new System.Windows.Forms.Panel();
            this.repair = new System.Windows.Forms.Button();
            this.label4 = new System.Windows.Forms.Label();
            this.panel5 = new System.Windows.Forms.Panel();
            this.remove = new System.Windows.Forms.Button();
            this.label5 = new System.Windows.Forms.Label();
            this.topPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.banner)).BeginInit();
            this.bottomPanel.SuspendLayout();
            this.tableLayoutPanel1.SuspendLayout();
            this.middlePanel.SuspendLayout();
            this.panel3.SuspendLayout();
            this.panel4.SuspendLayout();
            this.panel5.SuspendLayout();
            this.SuspendLayout();
            // 
            // topBorder
            // 
            this.topBorder.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(223)))), ((int)(((byte)(228)))));
            this.topBorder.Location = new System.Drawing.Point(0, 70);
            this.topBorder.Name = "topBorder";
            this.topBorder.Size = new System.Drawing.Size(494, 1);
            this.topBorder.TabIndex = 1;
            // 
            // topPanel
            // 
            this.topPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(243)))), ((int)(((byte)(240)))), ((int)(((byte)(255)))));
            this.topPanel.Controls.Add(this.label2);
            this.topPanel.Controls.Add(this.label1);
            this.topPanel.Controls.Add(this.banner);
            this.topPanel.Location = new System.Drawing.Point(0, 0);
            this.topPanel.Name = "topPanel";
            this.topPanel.Size = new System.Drawing.Size(494, 64);
            this.topPanel.TabIndex = 2;
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Times New Roman", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(68)))), ((int)(((byte)(84)))), ((int)(((byte)(111)))));
            this.label2.Location = new System.Drawing.Point(12, 38);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(258, 15);
            this.label2.TabIndex = 0;
            this.label2.Text = "Modify, repair, or remove your Phoenix installation.";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Times New Roman", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(23)))), ((int)(((byte)(43)))), ((int)(((byte)(77)))));
            this.label1.Location = new System.Drawing.Point(11, 11);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(210, 19);
            this.label1.TabIndex = 1;
            this.label1.Text = "Phoenix Maintenance Options";
            // 
            // banner
            // 
            this.banner.BackColor = System.Drawing.Color.Transparent;
            this.banner.Location = new System.Drawing.Point(442, 11);
            this.banner.Name = "banner";
            this.banner.Size = new System.Drawing.Size(40, 40);
            this.banner.SizeMode = System.Windows.Forms.PictureBoxSizeMode.StretchImage;
            this.banner.TabIndex = 2;
            this.banner.TabStop = false;
            // 
            // bottomPanel
            // 
            this.bottomPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(243)))), ((int)(((byte)(240)))), ((int)(((byte)(255)))));
            this.bottomPanel.Controls.Add(this.tableLayoutPanel1);
            this.bottomPanel.Controls.Add(this.border1);
            this.bottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.bottomPanel.Location = new System.Drawing.Point(0, 312);
            this.bottomPanel.Name = "bottomPanel";
            this.bottomPanel.Size = new System.Drawing.Size(494, 49);
            this.bottomPanel.TabIndex = 3;
            // 
            // tableLayoutPanel1
            // 
            this.tableLayoutPanel1.ColumnCount = 5;
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 14F));
            this.tableLayoutPanel1.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel1.Controls.Add(this.back, 1, 0);
            this.tableLayoutPanel1.Controls.Add(this.next, 2, 0);
            this.tableLayoutPanel1.Controls.Add(this.cancel, 4, 0);
            this.tableLayoutPanel1.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel1.Name = "tableLayoutPanel1";
            this.tableLayoutPanel1.Size = new System.Drawing.Size(491, 43);
            this.tableLayoutPanel1.TabIndex = 0;
            // 
            // back
            // 
            this.back.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.back.Cursor = System.Windows.Forms.Cursors.Hand;
            this.back.FlatAppearance.BorderSize = 0;
            this.back.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.back.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.back.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.back.Font = new System.Drawing.Font("Times New Roman", 9F, System.Drawing.FontStyle.Bold);
            this.back.ForeColor = System.Drawing.Color.White;
            this.back.Location = new System.Drawing.Point(0, 0);
            this.back.Name = "back";
            this.back.Padding = new System.Windows.Forms.Padding(6, 3, 6, 3);
            this.back.Size = new System.Drawing.Size(75, 30);
            this.back.TabIndex = 0;
            this.back.Text = "Back";
            this.back.UseVisualStyleBackColor = false;
            this.back.Click += new System.EventHandler(this.back_Click);
            // 
            // next
            // 
            this.next.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.next.Cursor = System.Windows.Forms.Cursors.Hand;
            this.next.FlatAppearance.BorderSize = 0;
            this.next.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.next.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.next.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.next.Font = new System.Drawing.Font("Times New Roman", 9F, System.Drawing.FontStyle.Bold);
            this.next.ForeColor = System.Drawing.Color.White;
            this.next.Location = new System.Drawing.Point(0, 0);
            this.next.Name = "next";
            this.next.Padding = new System.Windows.Forms.Padding(6, 3, 6, 3);
            this.next.Size = new System.Drawing.Size(75, 23);
            this.next.TabIndex = 1;
            this.next.Text = "Next";
            this.next.UseVisualStyleBackColor = false;
            this.next.Click += new System.EventHandler(this.next_Click);
            // 
            // cancel
            // 
            this.cancel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.cancel.Cursor = System.Windows.Forms.Cursors.Hand;
            this.cancel.FlatAppearance.BorderSize = 0;
            this.cancel.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.cancel.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.cancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cancel.Font = new System.Drawing.Font("Times New Roman", 9F, System.Drawing.FontStyle.Bold);
            this.cancel.ForeColor = System.Drawing.Color.White;
            this.cancel.Location = new System.Drawing.Point(0, 0);
            this.cancel.Name = "cancel";
            this.cancel.Padding = new System.Windows.Forms.Padding(6, 3, 6, 3);
            this.cancel.Size = new System.Drawing.Size(75, 23);
            this.cancel.TabIndex = 2;
            this.cancel.Text = "Cancel";
            this.cancel.UseVisualStyleBackColor = false;
            this.cancel.Click += new System.EventHandler(this.cancel_Click);
            // 
            // border1
            // 
            this.border1.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(220)))), ((int)(((byte)(223)))), ((int)(((byte)(228)))));
            this.border1.Location = new System.Drawing.Point(0, 0);
            this.border1.Name = "border1";
            this.border1.Size = new System.Drawing.Size(494, 1);
            this.border1.TabIndex = 1;
            // 
            // middlePanel
            // 
            this.middlePanel.ColumnCount = 1;
            this.middlePanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.middlePanel.Controls.Add(this.panel3, 0, 0);
            this.middlePanel.Controls.Add(this.panel4, 0, 1);
            this.middlePanel.Controls.Add(this.panel5, 0, 2);
            this.middlePanel.Location = new System.Drawing.Point(15, 80);
            this.middlePanel.Name = "middlePanel";
            this.middlePanel.Size = new System.Drawing.Size(479, 230);
            this.middlePanel.TabIndex = 0;
            // 
            // panel3
            // 
            this.panel3.Controls.Add(this.change);
            this.panel3.Controls.Add(this.label3);
            this.panel3.Location = new System.Drawing.Point(0, 0);
            this.panel3.Name = "panel3";
            this.panel3.Size = new System.Drawing.Size(230, 84);
            this.panel3.TabIndex = 0;
            // 
            // change
            // 
            this.change.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.change.Cursor = System.Windows.Forms.Cursors.Hand;
            this.change.FlatAppearance.BorderSize = 0;
            this.change.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.change.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.change.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.change.Font = new System.Drawing.Font("Times New Roman", 9F, System.Drawing.FontStyle.Bold);
            this.change.ForeColor = System.Drawing.Color.White;
            this.change.Location = new System.Drawing.Point(0, 0);
            this.change.Name = "change";
            this.change.Padding = new System.Windows.Forms.Padding(6, 3, 6, 3);
            this.change.Size = new System.Drawing.Size(75, 30);
            this.change.TabIndex = 0;
            this.change.Text = "Modify Phoenix";
            this.change.UseVisualStyleBackColor = false;
            this.change.Click += new System.EventHandler(this.change_Click);
            // 
            // label3
            // 
            this.label3.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(68)))), ((int)(((byte)(84)))), ((int)(((byte)(111)))));
            this.label3.Location = new System.Drawing.Point(116, 10);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(100, 23);
            this.label3.TabIndex = 1;
            this.label3.Text = "Change installed components of Phoenix.";
            // 
            // panel4
            // 
            this.panel4.Controls.Add(this.repair);
            this.panel4.Controls.Add(this.label4);
            this.panel4.Location = new System.Drawing.Point(0, 0);
            this.panel4.Name = "panel4";
            this.panel4.Size = new System.Drawing.Size(200, 100);
            this.panel4.TabIndex = 1;
            // 
            // repair
            // 
            this.repair.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.repair.Cursor = System.Windows.Forms.Cursors.Hand;
            this.repair.FlatAppearance.BorderSize = 0;
            this.repair.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.repair.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.repair.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.repair.Font = new System.Drawing.Font("Times New Roman", 9F, System.Drawing.FontStyle.Bold);
            this.repair.ForeColor = System.Drawing.Color.White;
            this.repair.Location = new System.Drawing.Point(0, 0);
            this.repair.Name = "repair";
            this.repair.Padding = new System.Windows.Forms.Padding(6, 3, 6, 3);
            this.repair.Size = new System.Drawing.Size(75, 23);
            this.repair.TabIndex = 0;
            this.repair.Text = "Repair Phoenix";
            this.repair.UseVisualStyleBackColor = false;
            this.repair.Click += new System.EventHandler(this.repair_Click);
            // 
            // label4
            // 
            this.label4.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(68)))), ((int)(((byte)(84)))), ((int)(((byte)(111)))));
            this.label4.Location = new System.Drawing.Point(130, 10);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(100, 23);
            this.label4.TabIndex = 1;
            this.label4.Text = "Fix missing or corrupted files in Phoenix installation.";
            // 
            // panel5
            // 
            this.panel5.Controls.Add(this.remove);
            this.panel5.Controls.Add(this.label5);
            this.panel5.Location = new System.Drawing.Point(0, 0);
            this.panel5.Name = "panel5";
            this.panel5.Size = new System.Drawing.Size(200, 100);
            this.panel5.TabIndex = 2;
            // 
            // remove
            // 
            this.remove.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.remove.Cursor = System.Windows.Forms.Cursors.Hand;
            this.remove.FlatAppearance.BorderSize = 0;
            this.remove.FlatAppearance.MouseDownBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.remove.FlatAppearance.MouseOverBackColor = System.Drawing.Color.FromArgb(((int)(((byte)(110)))), ((int)(((byte)(93)))), ((int)(((byte)(198)))));
            this.remove.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.remove.Font = new System.Drawing.Font("Times New Roman", 9F, System.Drawing.FontStyle.Bold);
            this.remove.ForeColor = System.Drawing.Color.White;
            this.remove.Location = new System.Drawing.Point(0, 0);
            this.remove.Name = "remove";
            this.remove.Padding = new System.Windows.Forms.Padding(6, 3, 6, 3);
            this.remove.Size = new System.Drawing.Size(75, 23);
            this.remove.TabIndex = 0;
            this.remove.Text = "Remove Phoenix";
            this.remove.UseVisualStyleBackColor = false;
            this.remove.Click += new System.EventHandler(this.remove_Click);
            // 
            // label5
            // 
            this.label5.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(68)))), ((int)(((byte)(84)))), ((int)(((byte)(111)))));
            this.label5.Location = new System.Drawing.Point(130, 10);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(100, 23);
            this.label5.TabIndex = 1;
            this.label5.Text = "Completely remove Phoenix from your computer.";
            // 
            // MaintenanceTypeDialog
            // 
            this.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(247)))), ((int)(((byte)(248)))), ((int)(((byte)(249)))));
            this.ClientSize = new System.Drawing.Size(494, 361);
            this.Controls.Add(this.middlePanel);
            this.Controls.Add(this.topBorder);
            this.Controls.Add(this.topPanel);
            this.Controls.Add(this.bottomPanel);
            this.Name = "MaintenanceTypeDialog";
            this.Text = "Phoenix Maintenance";
            this.Load += new System.EventHandler(this.MaintenanceTypeDialog_Load);
            this.topPanel.ResumeLayout(false);
            this.topPanel.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.banner)).EndInit();
            this.bottomPanel.ResumeLayout(false);
            this.tableLayoutPanel1.ResumeLayout(false);
            this.middlePanel.ResumeLayout(false);
            this.panel3.ResumeLayout(false);
            this.panel4.ResumeLayout(false);
            this.panel5.ResumeLayout(false);
            this.ResumeLayout(false);

		}

		#endregion

		private Panel topBorder;
		private Panel topPanel;
		private PictureBox banner;
		private Label label1;
		private Label label2;
		private Panel bottomPanel;
		private TableLayoutPanel tableLayoutPanel1;
		private Button back;
		private Button next;
		private Button cancel;
		private Panel border1;
		private TableLayoutPanel middlePanel;
		private Panel panel3;
		private Button change;
		private Label label3;
		private Panel panel4;
		private Button repair;
		private Label label4;
		private Panel panel5;
		private Button remove;
		private Label label5;
	}
}
