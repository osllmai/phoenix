using System.Drawing;
using System.Drawing.Drawing2D;
using System.Windows.Forms;
using WixSharp;
using WixSharp.UI.Forms;

namespace Phoenix.Dialogs
{
    partial class WelcomeDialog
    {
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.Panel mainPanel;
        private System.Windows.Forms.Label labelTitle;
        private System.Windows.Forms.Label labelDescription;
        private System.Windows.Forms.Panel bottomPanel;
        private System.Windows.Forms.Button back;
        private System.Windows.Forms.Button next;
        private System.Windows.Forms.Button cancel;
        private System.Windows.Forms.TableLayoutPanel tableLayoutPanel;
        private System.Windows.Forms.FlowLayoutPanel iconPanel;
        private System.Windows.Forms.PictureBox githubIcon;
        private System.Windows.Forms.PictureBox twitterIcon;
        private System.Windows.Forms.PictureBox discordIcon;
        private System.Windows.Forms.PictureBox linkedinIcon;

        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
                components.Dispose();
            base.Dispose(disposing);
        }


        private void InitializeComponent()
        {
            this.mainPanel = new System.Windows.Forms.Panel();
            this.labelTitle = new System.Windows.Forms.Label();
            this.labelDescription = new System.Windows.Forms.Label();
            this.iconPanel = new System.Windows.Forms.FlowLayoutPanel();
            this.githubIcon = new System.Windows.Forms.PictureBox();
            this.twitterIcon = new System.Windows.Forms.PictureBox();
            this.discordIcon = new System.Windows.Forms.PictureBox();
            this.linkedinIcon = new System.Windows.Forms.PictureBox();
            this.bottomPanel = new System.Windows.Forms.Panel();
            this.tableLayoutPanel = new System.Windows.Forms.TableLayoutPanel();
            this.back = new System.Windows.Forms.Button();
            this.cancel = new System.Windows.Forms.Button();
            this.next = new System.Windows.Forms.Button();
            this.mainPanel.SuspendLayout();
            this.iconPanel.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.githubIcon)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.twitterIcon)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.discordIcon)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.linkedinIcon)).BeginInit();
            this.bottomPanel.SuspendLayout();
            this.tableLayoutPanel.SuspendLayout();
            this.SuspendLayout();

            // 
            // mainPanel
            // 
            this.mainPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(247)))), ((int)(((byte)(248)))), ((int)(((byte)(249)))));
            this.mainPanel.Controls.Add(this.labelTitle);
            this.mainPanel.Controls.Add(this.labelDescription);
            this.mainPanel.Controls.Add(this.iconPanel);
            this.mainPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mainPanel.Location = new System.Drawing.Point(0, 0);
            this.mainPanel.Name = "mainPanel";
            this.mainPanel.Size = new System.Drawing.Size(500, 310);
            this.mainPanel.TabIndex = 0;
            // 
            // labelTitle
            // 
            this.labelTitle.Font = new System.Drawing.Font("Times New Roman", 14F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelTitle.ForeColor = System.Drawing.Color.Black;
            this.labelTitle.Location = new System.Drawing.Point(12, 20);
            this.labelTitle.Name = "labelTitle";
            this.labelTitle.Size = new System.Drawing.Size(450, 28);
            this.labelTitle.TabIndex = 0;
            this.labelTitle.Text = "Welcome to Phoenix Installer";
            // 
            // labelDescription
            // 
            this.labelDescription.Font = new System.Drawing.Font("Times New Roman", 9F);
            this.labelDescription.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(68)))), ((int)(((byte)(84)))), ((int)(((byte)(111)))));
            this.labelDescription.Location = new System.Drawing.Point(12, 58);
            this.labelDescription.Name = "labelDescription";
            this.labelDescription.Size = new System.Drawing.Size(469, 194);
            this.labelDescription.TabIndex = 1;
            this.labelDescription.Text = "[Description goes here]";
            // 
            // iconPanel
            // 
            this.iconPanel.Controls.Add(this.githubIcon);
            this.iconPanel.Controls.Add(this.twitterIcon);
            this.iconPanel.Controls.Add(this.discordIcon);
            this.iconPanel.Controls.Add(this.linkedinIcon);
            this.iconPanel.Location = new System.Drawing.Point(353, 266);
            this.iconPanel.Name = "iconPanel";
            this.iconPanel.Size = new System.Drawing.Size(135, 38);
            this.iconPanel.TabIndex = 2;
            // 
            // githubIcon
            // 
            this.githubIcon.Cursor = System.Windows.Forms.Cursors.Hand;
            this.githubIcon.Location = new System.Drawing.Point(3, 3);
            this.githubIcon.Name = "githubIcon";
            this.githubIcon.Size = new System.Drawing.Size(28, 28);
            this.githubIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.githubIcon.TabIndex = 0;
            this.githubIcon.TabStop = false;
            this.githubIcon.Click += new System.EventHandler(this.githubIcon_Click);
            // 
            // twitterIcon
            // 
            this.twitterIcon.Cursor = System.Windows.Forms.Cursors.Hand;
            this.twitterIcon.Location = new System.Drawing.Point(37, 3);
            this.twitterIcon.Name = "twitterIcon";
            this.twitterIcon.Size = new System.Drawing.Size(28, 28);
            this.twitterIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.twitterIcon.TabIndex = 1;
            this.twitterIcon.TabStop = false;
            this.twitterIcon.Click += new System.EventHandler(this.twitterIcon_Click);
            // 
            // discordIcon
            // 
            this.discordIcon.Cursor = System.Windows.Forms.Cursors.Hand;
            this.discordIcon.Location = new System.Drawing.Point(71, 3);
            this.discordIcon.Name = "discordIcon";
            this.discordIcon.Size = new System.Drawing.Size(26, 26);
            this.discordIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.discordIcon.TabIndex = 2;
            this.discordIcon.TabStop = false;
            this.discordIcon.Click += new System.EventHandler(this.discordIcon_Click);
            // 
            // linkedinIcon
            // 
            this.linkedinIcon.Cursor = System.Windows.Forms.Cursors.Hand;
            this.linkedinIcon.Location = new System.Drawing.Point(103, 3);
            this.linkedinIcon.Name = "linkedinIcon";
            this.linkedinIcon.Size = new System.Drawing.Size(25, 25);
            this.linkedinIcon.SizeMode = System.Windows.Forms.PictureBoxSizeMode.Zoom;
            this.linkedinIcon.TabIndex = 3;
            this.linkedinIcon.TabStop = false;
            this.linkedinIcon.Click += new System.EventHandler(this.linkedinIcon_Click);
            // 
            // bottomPanel
            // 
            this.bottomPanel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(241)))), ((int)(((byte)(242)))), ((int)(((byte)(244)))));
            this.bottomPanel.Controls.Add(this.tableLayoutPanel);
            this.bottomPanel.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.bottomPanel.Location = new System.Drawing.Point(0, 310);
            this.bottomPanel.Name = "bottomPanel";
            this.bottomPanel.Size = new System.Drawing.Size(500, 50);
            this.bottomPanel.TabIndex = 1;
            // 
            // tableLayoutPanel
            // 
            this.tableLayoutPanel.ColumnCount = 5;
            this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Percent, 100F));
            this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle(System.Windows.Forms.SizeType.Absolute, 8F));
            this.tableLayoutPanel.ColumnStyles.Add(new System.Windows.Forms.ColumnStyle());
            this.tableLayoutPanel.Controls.Add(this.back, 1, 0);
            this.tableLayoutPanel.Controls.Add(this.cancel, 4, 0);
            this.tableLayoutPanel.Controls.Add(this.next, 2, 0);
            this.tableLayoutPanel.Dock = System.Windows.Forms.DockStyle.Fill;
            this.tableLayoutPanel.Location = new System.Drawing.Point(0, 0);
            this.tableLayoutPanel.Name = "tableLayoutPanel";
            this.tableLayoutPanel.RowStyles.Add(new System.Windows.Forms.RowStyle(System.Windows.Forms.SizeType.Absolute, 20F));
            this.tableLayoutPanel.Size = new System.Drawing.Size(500, 50);
            this.tableLayoutPanel.TabIndex = 0;
            // 
            // back
            // 
            this.back.AutoSize = true;
            this.back.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.back.Enabled = false;
            this.back.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.back.Font = new System.Drawing.Font("Times New Roman", 8F);
            this.back.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            this.back.Location = new System.Drawing.Point(252, 3);
            this.back.Name = "back";
            this.back.Size = new System.Drawing.Size(75, 28);
            this.back.TabIndex = 0;
            this.back.Text = "Back";
            this.back.UseVisualStyleBackColor = false;
            this.back.Click += new System.EventHandler(this.back_Click);
            // 
            // cancel
            // 
            this.cancel.AutoSize = true;
            this.cancel.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.cancel.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.cancel.Font = new System.Drawing.Font("Times New Roman", 8F);
            this.cancel.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            this.cancel.Location = new System.Drawing.Point(422, 3);
            this.cancel.Name = "cancel";
            this.cancel.Size = new System.Drawing.Size(75, 28);
            this.cancel.TabIndex = 2;
            this.cancel.Text = "Cancel";
            this.cancel.UseVisualStyleBackColor = false;
            this.cancel.Click += new System.EventHandler(this.cancel_Click);
            // 
            // next
            // 
            this.next.AutoSize = true;
            this.next.BackColor = System.Drawing.Color.FromArgb(((int)(((byte)(159)))), ((int)(((byte)(143)))), ((int)(((byte)(239)))));
            this.next.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.next.Font = new System.Drawing.Font("Times New Roman", 8F);
            this.next.ForeColor = System.Drawing.Color.FromArgb(((int)(((byte)(255)))), ((int)(((byte)(255)))), ((int)(((byte)(255)))));
            this.next.Location = new System.Drawing.Point(333, 3);
            this.next.Name = "next";
            this.next.Size = new System.Drawing.Size(75, 28);
            this.next.TabIndex = 1;
            this.next.Text = "Next";
            this.next.UseVisualStyleBackColor = false;
            this.next.Click += new System.EventHandler(this.next_Click);
            // 
            // WelcomeDialog
            // 
            this.ClientSize = new System.Drawing.Size(500, 360);
            this.Controls.Add(this.mainPanel);
            this.Controls.Add(this.bottomPanel);
            this.Font = new System.Drawing.Font("Times New Roman", 12F);
            this.Name = "WelcomeDialog";
            this.Text = "Welcome - Phoenix Installer";
            this.Load += new System.EventHandler(this.WelcomeDialog_Load);
            this.mainPanel.ResumeLayout(false);
            this.iconPanel.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.githubIcon)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.twitterIcon)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.discordIcon)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.linkedinIcon)).EndInit();
            this.bottomPanel.ResumeLayout(false);
            this.tableLayoutPanel.ResumeLayout(false);
            this.tableLayoutPanel.PerformLayout();
            this.ResumeLayout(false);

        }
    }
}
