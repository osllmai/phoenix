using System;
using System.Drawing;
using System.Windows.Forms;
using WixSharp;
using WixSharp.UI.Forms;

namespace Phoenix.Dialogs
{
    /// <summary>
    /// The customized InstallDir dialog for Phoenix setup
    /// </summary>
    public partial class InstallDirDialog : ManagedForm, IManagedDialog
    {
        string installDirProperty;

        public InstallDirDialog()
        {
            InitializeComponent();

            label1.Text = "Phoenix Setup";
            label2.Text = "Choose the folder where Phoenix will be installed.";

            try
            {
                logoPictureBox.Image = new Bitmap(@"E:\phoenix\media\image_company\phoenix.png");
                logoPictureBox.SizeMode = PictureBoxSizeMode.Zoom;
            }
            catch (Exception)
            {
            }
        }

        void InstallDirDialog_Load(object sender, EventArgs e)
        {
            installDirProperty = Runtime.Session.Property("WixSharp_UI_INSTALLDIR");
            string installDirPropertyValue = Runtime.Session.Property(installDirProperty);

            if (installDirPropertyValue.IsEmpty())
            {
                installDir.Text = Runtime.Session.GetDirectoryPath(installDirProperty);

                if (installDir.Text == "ABSOLUTEPATH")
                    installDir.Text = Runtime.Session.Property("INSTALLDIR_ABSOLUTEPATH");
            }
            else
            {
                installDir.Text = installDirPropertyValue;
            }
        }

        void back_Click(object sender, EventArgs e)
        {
            Shell.GoPrev();
        }

        void next_Click(object sender, EventArgs e)
        {
            if (!installDirProperty.IsEmpty())
                Runtime.Session[installDirProperty] = installDir.Text;
            Shell.GoNext();
        }

        void cancel_Click(object sender, EventArgs e)
        {
            Shell.Cancel();
        }

        void change_Click(object sender, EventArgs e)
        {
            if (this.Session().UseModernFolderBrowserDialog())
            {
                try
                {
                    var newFolderPath = WixSharp.FolderBrowserDialog.ShowDialog(this.Handle, "Select Folder", installDir.Text);
                    if (!string.IsNullOrEmpty(newFolderPath))
                        installDir.Text = newFolderPath;
                    return;
                }
                catch
                {
                }
            }

            using (var dialog = new System.Windows.Forms.FolderBrowserDialog())
            {
                if (!string.IsNullOrWhiteSpace(installDir.Text))
                    dialog.SelectedPath = installDir.Text;

                var result = dialog.ShowDialog(this);
                if (result == DialogResult.OK || result == DialogResult.Yes)
                {
                    installDir.Text = dialog.SelectedPath;
                }
            }
        }

    }
}
