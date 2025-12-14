using System;
using System.Drawing;
using System.IO;
using System.Net;
using System.Security.Principal;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Xml.Linq;
using System.Diagnostics;
using WixSharp;
using WixSharp.CommonTasks;
using WixSharp.UI.Forms;
using WixToolset.Dtf.WindowsInstaller;

namespace Phoenix.Dialogs
{
    public partial class ProgressDialog : ManagedForm, IManagedDialog, IProgressDialog
    {
        private System.Windows.Forms.Timer showWaitPromptTimer;
        private string baseUrl = "https://osllm-phoenix.s3.us-east-2.amazonaws.com/phoenix_windows/windows_64x/update/";
        private string localTempDir = Path.Combine(Path.GetTempPath(), "PhoenixInstaller");

        public ProgressDialog()
        {
            InitializeComponent();

            showWaitPromptTimer = new System.Windows.Forms.Timer() { Interval = 4000 };
            showWaitPromptTimer.Tick += (s, e) =>
            {
                this.waitPrompt.Visible = true;
                showWaitPromptTimer.Stop();
            };
        }

        async void ProgressDialog_Load(object sender, EventArgs e)
        {
            try
            {
                logoPictureBox.Image = new Bitmap(@"E:\phoenix\media\image_company\phoenix.png");
            }
            catch
            {
                logoPictureBox.BackColor = Color.LightGray;
            }

            if (!WindowsIdentity.GetCurrent().IsAdmin() && Uac.IsEnabled())
            {
                this.waitPrompt.Text = "Please confirm the UAC prompt to continue installing Phoenix.";
                showWaitPromptTimer.Start();
            }

            dialogText.Text = "Preparing online installation...";
            description.Text = "Downloading latest Phoenix files...";
            currentAction.Text = "Checking update repository...";
            progress.Value = 5;

            await DownloadAndExtractAsync();

            Shell.StartExecute();
        }

        private async Task DownloadAndExtractAsync()
        {
            try
            {
                Directory.CreateDirectory(localTempDir);

                string updatesXmlUrl = baseUrl + "Updates.xml";
                string xmlPath = Path.Combine(localTempDir, "Updates.xml");

                using (var client = new WebClient())
                {
                    await client.DownloadFileTaskAsync(new Uri(updatesXmlUrl), xmlPath);
                }

                var xml = XDocument.Load(xmlPath);
                var packageNode = xml.Root.Element("PackageUpdate");
                var archives = packageNode.Element("DownloadableArchives")?.Value.Split(',');

                if (archives == null || archives.Length == 0)
                {
                    MessageBox.Show("No downloadable archives found in Updates.xml", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
                    return;
                }

                int total = archives.Length;
                int count = 0;

                foreach (var archive in archives)
                {
                    string trimmed = archive.Trim();
                    string fileUrl = baseUrl + trimmed;
                    string destPath = Path.Combine(localTempDir, trimmed);

                    currentAction.Text = $"Downloading {trimmed}...";
                    progress.Value = (int)((count / (float)total) * 80);

                    using (var client = new WebClient())
                    {
                        client.DownloadProgressChanged += (s, e) =>
                        {
                            progress.Value = (int)((count / (float)total) * 80 + e.ProgressPercentage * 0.8 / total);
                        };
                        await client.DownloadFileTaskAsync(new Uri(fileUrl), destPath);
                    }

                    count++;
                }

                // Extract files
                currentAction.Text = "Extracting archives...";
                progress.Value = 90;

                foreach (var archive in archives)
                {
                    string trimmed = archive.Trim();
                    string filePath = Path.Combine(localTempDir, trimmed);

                    if (System.IO.File.Exists(filePath))
                    {
                        await Task.Run(() =>
                        {
                            Process.Start(new ProcessStartInfo
                            {
                                FileName = "7z.exe",
                                Arguments = $"x \"{filePath}\" -o\"{localTempDir}\\extracted\" -y",
                                CreateNoWindow = true,
                                UseShellExecute = false
                            })?.WaitForExit();
                        });
                    }
                }

                progress.Value = 100;
                currentAction.Text = "Download and extraction complete.";
            }
            catch (Exception ex)
            {
                MessageBox.Show("Error during online installation:\n" + ex.Message, "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        protected override void OnShellChanged()
        {
            if (Runtime.Session.IsUninstalling())
            {
                dialogText.Text = "Removing Phoenix";
                description.Text = "Please wait while Phoenix is being removed...";
            }
            else if (Runtime.Session.IsRepairing())
            {
                dialogText.Text = "Repairing Phoenix";
                description.Text = "Repairing your Phoenix installation...";
            }
            else if (Runtime.Session.IsInstalling())
            {
                dialogText.Text = "Installing Phoenix";
                description.Text = "Phoenix is being installed on your computer...";
            }

            this.Localize();
        }

        public override MessageResult ProcessMessage(InstallMessage messageType, Record messageRecord,
            MessageButtons buttons, MessageIcon icon, MessageDefaultButton defaultButton)
        {
            switch (messageType)
            {
                case InstallMessage.InstallStart:
                case InstallMessage.InstallEnd:
                    showWaitPromptTimer.Stop();
                    waitPrompt.Visible = false;
                    break;

                case InstallMessage.ActionStart:
                    try
                    {
                        string message = null;
                        if (messageRecord.FieldCount >= 3)
                            message = messageRecord[2].ToString();

                        if (!string.IsNullOrEmpty(message))
                            currentAction.Text = $"{currentActionLabel.Text} {message}";
                    }
                    catch { }
                    break;
            }
            return MessageResult.OK;
        }

        public override void OnProgress(int progressPercentage)
        {
            progress.Value = progressPercentage;
            if (progressPercentage > 0)
                waitPrompt.Visible = false;
        }

        public override void OnExecuteComplete()
        {
            currentAction.Text = null;
            Shell.GoNext();
        }

        void cancel_Click(object sender, EventArgs e)
        {
            if (Shell.IsDemoMode)
                Shell.GoNext();
            else
                Shell.Cancel();
        }
    }
}
