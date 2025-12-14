using Phoenix.Dialogs;
using System;
using System.IO;
using WixSharp;
using WixSharp.CommonTasks;

namespace Phoenix
{
    public class Program
    {
        static void Main()
        {
            var project = new ManagedProject("Phoenix",
                new InstallDir(@"%ProgramFiles%\Osllm\Phoenix",
                    new WixSharp.File(@"E:\phoenix\installer\Phoenix.ico")
                )
            );

            project.GUID = new Guid("8060234b-eb32-4540-a6d3-4b433640383a");
            project.Version = new Version("0.1.33");
            project.ControlPanelInfo.ProductIcon = @"E:\phoenix\installer\Phoenix.ico";
            project.ManagedUI.Icon = @"E:\phoenix\installer\Phoenix.ico";

            project.ManagedUI = new ManagedUI();
            project.ManagedUI.InstallDialogs
                .Add<WelcomeDialog>()
                .Add<LicenceDialog>()
                .Add<InstallDirDialog>()
                .Add<ProgressDialog>()
                .Add<ExitDialog>();

            project.ManagedUI.ModifyDialogs
                .Add<MaintenanceTypeDialog>()
                .Add<ProgressDialog>()
                .Add<ExitDialog>();

            string licensePath = @"E:\phoenix\installer\license.rtf";
            if (System.IO.File.Exists(licensePath))
                project.AddBinary(new Binary(new Id("WixSharp_LicenceFile"), licensePath));

            ValidateAssemblyCompatibility();

            project.BuildMsi();
        }

        static void ValidateAssemblyCompatibility()
        {
            var assembly = System.Reflection.Assembly.GetExecutingAssembly();
            if (!assembly.ImageRuntimeVersion.StartsWith("v2."))
            {
                Console.WriteLine($"Warning: assembly '{assembly.GetName().Name}' is compiled for {assembly.ImageRuntimeVersion} runtime, which may not be compatible with the CLR version hosted by MSI.");
            }
        }
    }
}
