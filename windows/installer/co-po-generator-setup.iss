; Script generated by the Inno Setup Script Wizard.
; SEE THE DOCUMENTATION FOR DETAILS ON CREATING INNO SETUP SCRIPT FILES!

#define MyAppName "CO-PO Generator"
#define MyAppVersion "v0.4.3-alpha"
#define MyAppPublisher "Jery"
#define MyAppExeName "co_po_generator.exe"
#define RootDir "..\.."

; & "C:\Program Files (x86)\Inno Setup 6\ISCC.exe" windows\installer\co-po-generator-setup.iss

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={{3BAEC7C3-C191-418C-BF63-4AA1A47FB172}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\CO-PO_Generator
DefaultGroupName={#MyAppName}
AllowNoIcons=yes
LicenseFile={#RootDir}\LICENSE.txt
; Remove the following line to run in administrative install mode (install for all users.)
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
OutputDir=.
OutputBaseFilename=co-po-generator-setup
SetupIconFile=..\runner\resources\app_icon.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "{#RootDir}\build\windows\x64\runner\Debug\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#RootDir}\build\windows\x64\runner\Debug\flutter_windows.dll"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#RootDir}\build\windows\x64\runner\Debug\data\*"; DestDir: "{app}\data"; Flags: ignoreversion recursesubdirs createallsubdirs
; NOTE: Don't use "Flags: ignoreversion" on any shared system files

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

