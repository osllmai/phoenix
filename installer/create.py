import os
import shutil
import glob
import subprocess

BIN_PATH = "/doc/dev/work/phoenix/phoenix_qt/build/Desktop_Qt_6_8_system-Debug/bin/"
QMAKE_PATH = "/usr/bin/qmake6"
QTIF_PATH = "/doc/Qt/Tools/QtInstallerFramework/4.1/bin/"
PACKAGE_DATA_FOLDER = "packages/io.phoenix.phoenix/data/"
APP_NAME = "appPhoenix"
CQTDEPLOYER_PATH = "/usr/bin/cqtdeployer"
TEMP_FOLDER_NAME="tmp"

def copyFilesFromBin():
    # Create output folder if it doesn't exist, otherwise remove all its contents
    if os.path.exists(TEMP_FOLDER_NAME):
        shutil.rmtree(TEMP_FOLDER_NAME)
    os.makedirs(TEMP_FOLDER_NAME)
    
    # Copy required files from BIN_PATH to TEMP_FOLDER_NAME
    required_files = [APP_NAME, "models.json"] + glob.glob(f"{BIN_PATH}/*.so")
    for file in required_files:
        src = os.path.join(BIN_PATH, file)
        dest = os.path.join(TEMP_FOLDER_NAME, os.path.basename(file))
        if os.path.exists(src):
            shutil.copy(src, dest)
            print(f"Copied: {src} -> {dest}")
        else:
            print(f"File not found: {src}")

def runDeployer():
    # Run cqtdeployer command on the file TEMP_FOLDER_NAME/appPhoenix
    app_path = os.path.join(TEMP_FOLDER_NAME, APP_NAME)
    if not os.path.exists(app_path):
        raise FileNotFoundError(f"{app_path} not found. Ensure the application is built and copied.")
    
    deploy_command = [CQTDEPLOYER_PATH, "-qmake", QMAKE_PATH,  "-bin", f"{TEMP_FOLDER_NAME}/{APP_NAME}", "-binDir", TEMP_FOLDER_NAME, "-qmlDir", "../phoenix_qt/"]
    print(f"Running command: {' '.join(deploy_command)}")
    subprocess.run(deploy_command, check=True)

    # Move all output to PACKAGE_DATA_FOLDER
    if os.path.exists(PACKAGE_DATA_FOLDER):
        shutil.rmtree(PACKAGE_DATA_FOLDER)
    os.makedirs(PACKAGE_DATA_FOLDER)
    
    for file in os.listdir(TEMP_FOLDER_NAME):
        src = os.path.join(TEMP_FOLDER_NAME, file)
        dest = os.path.join(PACKAGE_DATA_FOLDER, file)
        shutil.move(src, dest)
        print(f"Moved: {src} -> {dest}")

def createPackage():
    # Call QtIF binarycreator to generate the installer
    config_file = "config/config.xml"  # Adjust as needed
    package_folder = "packages/"
    binary_creator_path = os.path.join(QTIF_PATH, "binarycreator")
    
    if not os.path.exists(binary_creator_path):
        raise FileNotFoundError(f"Binarycreator not found at {binary_creator_path}")
    
    if not os.path.exists(config_file):
        raise FileNotFoundError(f"Configuration file not found: {config_file}")
    
    package_command = [
        binary_creator_path,
        "-c", config_file,
        "-p", package_folder,
        "installer.exe"  # Output installer file name
    ]
    print(f"Running command: {' '.join(package_command)}")
    subprocess.run(package_command, check=True)
    print("Installer created successfully: installer.exe")

# Call above methods one by one
if __name__ == "__main__":
    try:
        print("Copying files from BIN_PATH...")
        copyFilesFromBin()
        
        print("Running cqtdeployer...")
        runDeployer()
        
        print("Creating installer package...")
        createPackage()
        
        print("All steps completed successfully.")
    except Exception as e:
        print(f"Error: {e}")
