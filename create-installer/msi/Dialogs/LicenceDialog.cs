using System;
using System.Diagnostics;
using System.IO;
using System.Windows.Forms;
using WixSharp;
using WixSharp.UI.Forms;
using io = System.IO;

namespace Phoenix.Dialogs
{
    public partial class LicenceDialog : ManagedForm, IManagedDialog
    {
        public LicenceDialog()
        {
            InitializeComponent();
        }

        void LicenceDialog_Load(object sender, EventArgs e)
        {
            try
            {
                logoPictureBox.Image = new System.Drawing.Bitmap(@"E:\phoenix\media\image_company\phoenix.png");
            }
            catch
            {}

            try
            {
                string licenseText = Runtime.Session.GetResourceString("WixSharp_LicenceFile");
                if (!string.IsNullOrEmpty(licenseText))
                    agreement.Rtf = licenseText;
                else
                    agreement.Text = "License file could not be loaded. Please contact support.";
            }
            catch (Exception ex)
            {
                agreement.Text = "Error loading license: " + ex.Message;
            }

            accepted.Checked = Runtime.Session["LastLicenceAcceptedChecked"] == "True";

            titleLbl.Text = "License Agreement";
            label2.Text = "Please read and accept the following license before continuing:";
            accepted.Text = "I accept the terms in the License Agreement";
        }

        void back_Click(object sender, EventArgs e) => Shell.GoPrev();
        void next_Click(object sender, EventArgs e) => Shell.GoNext();
        void cancel_Click(object sender, EventArgs e) => Shell.Cancel();

        void accepted_CheckedChanged(object sender, EventArgs e)
        {
            next.Enabled = accepted.Checked;
            Runtime.Session["LastLicenceAcceptedChecked"] = accepted.Checked.ToString();
        }

        void print_Click(object sender, EventArgs e)
        {
            try
            {
                var file = Path.Combine(Path.GetTempPath(), Runtime.Session.Property("ProductName") + ".licence.rtf");
                io.File.WriteAllText(file, agreement.Rtf);
                Process.Start(file);
            }
            catch { }
        }

        void copyToolStripMenuItem_Click(object sender, EventArgs e)
        {
            try
            {
                var data = new DataObject();
                if (agreement.SelectedText.Length > 0)
                {
                    data.SetData(DataFormats.UnicodeText, agreement.SelectedText);
                    data.SetData(DataFormats.Rtf, agreement.SelectedRtf);
                }
                else
                {
                    data.SetData(DataFormats.Rtf, agreement.Rtf);
                    data.SetData(DataFormats.Text, agreement.Text);
                }
                Clipboard.SetDataObject(data);
            }
            catch { }
        }
    }
}
