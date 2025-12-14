using System.Diagnostics;
using System.IO;
using System.Windows.Forms;
using WixSharp;
using WixSharp.UI.Forms;

namespace Phoenix.Dialogs
{
    /// <summary>
    /// The standard Exit dialog (customized, no image)
    /// </summary>
    public partial class ExitDialog : ManagedForm, IManagedDialog
    {
        public ExitDialog()
        {
            InitializeComponent();
        }

        void ExitDialog_Load(object sender, System.EventArgs e)
        {
            if (Shell.UserInterrupted || Shell.Log.Contains("User cancelled installation."))
            {
                title.Text = "[UserExitTitle]";
                description.Text = "[UserExitDescription1]";
                this.Localize();
            }
            else if (Shell.ErrorDetected)
            {
                title.Text = "[FatalErrorTitle]";
                description.Text = Shell.CustomErrorDescription ?? "[FatalErrorDescription1]";
                this.Localize();
            }
        }

        void finish_Click(object sender, System.EventArgs e)
        {
            Shell.Exit();
        }

        void viewLog_LinkClicked(object sender, LinkLabelLinkClickedEventArgs e)
        {
            try
            {
                string logFile = Runtime.Session.LogFile;

                if (logFile.IsEmpty())
                {
                    string wixSharpDir = Path.GetTempPath().PathCombine("WixSharp");

                    if (!Directory.Exists(wixSharpDir))
                        Directory.CreateDirectory(wixSharpDir);

                    logFile = wixSharpDir.PathCombine(Runtime.ProductName + ".log");
                    System.IO.File.WriteAllText(logFile, Shell.Log);
                }

                Process.Start("notepad.exe", logFile);
            }
            catch
            {
            }
        }
    }
}
