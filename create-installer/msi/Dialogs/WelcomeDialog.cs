using System;
using System.Diagnostics;
using System.Windows.Forms;
using WixSharp;
using WixSharp.UI.Forms;
using System.Reflection;

namespace Phoenix.Dialogs
{
    public partial class WelcomeDialog : ManagedForm, IManagedDialog
    {
        public WelcomeDialog()
        {
            InitializeComponent();
        }

        void WelcomeDialog_Load(object sender, EventArgs e)
        {
            // Set custom welcome text
            labelTitle.Text = "Welcome to Phoenix Installer";
            labelDescription.Text =
                "Phoenix is an open-source application built with Qt/QML that enables seamless interaction " +
                "with Large Language Models (LLMs) locally, without requiring an internet connection.\n\n" +
                "The program is designed to automatically detect whether your system has a GPU and load models accordingly, " +
                "allowing you to use them as powerful AI assistants directly on your machine.\n\n" +
                "Version: 1.0.0";

            // Set icons (make sure the paths exist)
            githubIcon.ImageLocation = @"E:\phoenix\media\icon\github.png";
            twitterIcon.ImageLocation = @"E:\phoenix\media\icon\twitter.png";
            discordIcon.ImageLocation = @"E:\phoenix\media\icon\discord.png";
            linkedinIcon.ImageLocation = @"E:\phoenix\media\icon\linkedin.png";
        }

        void cancel_Click(object sender, EventArgs e) => Shell.Cancel();

        void next_Click(object sender, EventArgs e) => Shell.GoNext();

        void back_Click(object sender, EventArgs e) => Shell.GoPrev();

        void githubIcon_Click(object sender, EventArgs e)
        {
            Process.Start("explorer.exe", "https://github.com/osllmai");
        }

        void twitterIcon_Click(object sender, EventArgs e)
        {
            Process.Start("explorer.exe", "https://x.com/osllmai");
        }

        void discordIcon_Click(object sender, EventArgs e)
        {
            Process.Start("explorer.exe", "https://discord.gg/pufX5Aua2g");
        }

        void linkedinIcon_Click(object sender, EventArgs e)
        {
            Process.Start("explorer.exe", "https://www.linkedin.com/company/osllmai/");
        }
    }
}
