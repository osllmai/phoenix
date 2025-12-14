using System;
using System.Linq;
using System.Windows.Forms;
using System.Drawing;
using WixSharp;
using WixSharp.UI.Forms;

namespace Phoenix.Dialogs
{
    /// <summary>
    /// Custom Maintenance Type dialog for Phoenix Installer
    /// </summary>
    public partial class MaintenanceTypeDialog : ManagedForm, IManagedDialog
    {
        private bool isDarkTheme;

        public MaintenanceTypeDialog()
        {
            InitializeComponent();
        }

        Type ProgressDialog
        {
            get
            {
                return Shell.Dialogs.FirstOrDefault(d => d.GetInterfaces().Contains(typeof(IProgressDialog)));
            }
        }

        void change_Click(object sender, EventArgs e)
        {
            Runtime.Session["MODIFY_ACTION"] = "Change";
            Shell.GoNext();
        }

        void repair_Click(object sender, EventArgs e)
        {
            Runtime.Session["MODIFY_ACTION"] = "Repair";
            int index = Shell.Dialogs.IndexOf(ProgressDialog);
            if (index != -1)
                Shell.GoTo(index);
            else
                Shell.GoNext();
        }

        void remove_Click(object sender, EventArgs e)
        {
            Runtime.Session["REMOVE"] = "ALL";
            Runtime.Session["MODIFY_ACTION"] = "Remove";

            int index = Shell.Dialogs.IndexOf(ProgressDialog);
            if (index != -1)
                Shell.GoTo(index);
            else
                Shell.GoNext();
        }

        void back_Click(object sender, EventArgs e) => Shell.GoPrev();
        void next_Click(object sender, EventArgs e) => Shell.GoNext();
        void cancel_Click(object sender, EventArgs e) => Shell.Cancel();

        void MaintenanceTypeDialog_Load(object sender, EventArgs e)
        {
            // Detect system dark theme (basic heuristic)
            isDarkTheme = SystemInformation.HighContrast ||
                          (SystemColors.Window.R < 128 && SystemColors.Window.G < 128 && SystemColors.Window.B < 128);

            banner.Visible = false;

            label1.Text = "Phoenix Maintenance Options";
            label2.Text = "Modify, repair, or remove your Phoenix installation.";

            // ----- Logo -----
            PictureBox logoPictureBox = new PictureBox();
            logoPictureBox.Image = new Bitmap(@"E:\phoenix\media\image_company\phoenix.png");
            logoPictureBox.SizeMode = PictureBoxSizeMode.Zoom;
            logoPictureBox.Size = new Size(60, 60);
            logoPictureBox.Anchor = AnchorStyles.Top | AnchorStyles.Right;
            logoPictureBox.Location = new Point(topPanel.Width - logoPictureBox.Width - 10, 5);
            logoPictureBox.BackColor = Color.Transparent;
            topPanel.Controls.Add(logoPictureBox);

            ApplyTheme();
            ResetLayout();
        }

        void ApplyTheme()
        {
            if (isDarkTheme)
            {
                // Dark theme colors
                this.BackColor = ColorTranslator.FromHtml("#1D2125");
                topPanel.BackColor = ColorTranslator.FromHtml("#161A1D");
                bottomPanel.BackColor = ColorTranslator.FromHtml("#161A1D");
                label1.ForeColor = Color.White;
                label2.ForeColor = ColorTranslator.FromHtml("#B6C2CF");

                foreach (var lbl in this.Controls.OfType<Label>().Concat(middlePanel.Controls.OfType<Label>()))
                    lbl.ForeColor = ColorTranslator.FromHtml("#B6C2CF");

                foreach (var btn in this.Controls.OfType<Button>().Concat(middlePanel.Controls.OfType<Button>()))
                {
                    btn.BackColor = ColorTranslator.FromHtml("#2B273F");
                    btn.ForeColor = ColorTranslator.FromHtml("#F3F0FF");
                    btn.FlatStyle = FlatStyle.Flat;
                    btn.FlatAppearance.BorderColor = ColorTranslator.FromHtml("#6E5DC6");
                }
            }
            else
            {
                // Light theme colors
                this.BackColor = ColorTranslator.FromHtml("#FFFFFF");
                topPanel.BackColor = ColorTranslator.FromHtml("#F7F8F9");
                bottomPanel.BackColor = ColorTranslator.FromHtml("#F7F8F9");
                label1.ForeColor = ColorTranslator.FromHtml("#172B4D");
                label2.ForeColor = ColorTranslator.FromHtml("#44546F");

                foreach (var lbl in this.Controls.OfType<Label>().Concat(middlePanel.Controls.OfType<Label>()))
                    lbl.ForeColor = ColorTranslator.FromHtml("#44546F");

                foreach (var btn in this.Controls.OfType<Button>().Concat(middlePanel.Controls.OfType<Button>()))
                {
                    btn.BackColor = ColorTranslator.FromHtml("#F3F0FF");
                    btn.ForeColor = ColorTranslator.FromHtml("#352C63");
                    btn.FlatStyle = FlatStyle.Flat;
                    btn.FlatAppearance.BorderColor = ColorTranslator.FromHtml("#9F8FEF");
                }
            }

            // Borders
            topBorder.BackColor = ColorTranslator.FromHtml(isDarkTheme ? "#2C333A" : "#DCDFE4");
            border1.BackColor = topBorder.BackColor;
        }

        void ResetLayout()
        {
            topPanel.Height = 70;
            topBorder.Top = topPanel.Height + 1;

            var upShift = (int)(next.Height * 2.3) - bottomPanel.Height;
            bottomPanel.Top -= upShift;
            bottomPanel.Height += upShift;

            middlePanel.Top = topBorder.Bottom + 10;
            middlePanel.Height = (bottomPanel.Top - 10) - middlePanel.Top;
        }
    }
}
