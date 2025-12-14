function Component()
{
    if (!installer.isCommandLineInstance())
        gui.pageWidgetByObjectName("LicenseAgreementPage").entered.connect(changeLicenseLabels);
}

changeLicenseLabels = function()
{
    page = gui.pageWidgetByObjectName("LicenseAgreementPage");
    page.AcceptLicenseLabel.setText("Yes I do!");
}

Component.prototype.createOperations = function()
{
    component.createOperations();

    var targetExe = "@TargetDir@/appphoenix.exe";

    if (systemInfo.productType === "windows") {
        component.addOperation("CreateShortcut",
                targetExe,
                "@DesktopDir@/Phoenix.lnk",
                "workingDirectory=@TargetDir@",
                "iconPath=@TargetDir@/Phoenix.ico",
                "description=Phoenix");
        // component.addOperation(
        //               "Copy",
        //               "@SourceDir@/pin_to_taskbar.ps1",
        //               "@TargetDir@/pin_to_taskbar.ps1");
        // component.addOperation("Execute",
        //                        "powershell.exe",
        //                        "-ExecutionPolicy",
        //                        "Bypass",
        //                        "-File",
        //                        "@TargetDir@/pin_to_taskbar.ps1");
    }
}
