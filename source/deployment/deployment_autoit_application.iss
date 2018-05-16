;---------------------------------------------------------------------------------
;
;    Copyright © 2018-05, v20100v
;
;    @author    v20100v
;    @contact   7567933+v20100v@users.noreply.github.com
;    @version   1.0.0
;
;---------------------------------------------------------------------------------

; ApplicationVersion : the version number is defined by InnoSetupCommandLineCompiler (iscc) with /d<name>[=<value>]	(/dApplicationVersion=0.3.6.5)
; ApplicationName : the name of applciation is defined by InnoSetupCommandLineCompiler (iscc) with /d<name>[=<value>]	(/dApplicationName=MyApplication)

#define ApplicationPublisher "v20100v"
#define ApplicationURL "https://github.com/v20100v/autoit-gui-skeleton"
#define ApplicationExeName ApplicationName+"_v" + ApplicationVersion + ".exe"
#define ApplicationCopyright "Copyright (C) 2018, A.C.M.E v20100v"

; Get the path where the script iss is placed
#define PathRelease SourcePath + "releases\v" + ApplicationVersion + "\"+ApplicationName+"_v" + ApplicationVersion
#define PathOutput SourcePath + "releases\v" + ApplicationVersion + "\"
#define PathAssets SourcePath + "..\assets"

; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
#define ApplicationGUID "6886E28B-AAB5-4866-BCD5-E1B4C171A87A"
#define ApplicationID ApplicationName + "_" + ApplicationGUID

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
AppId={#ApplicationID}
AppName={#ApplicationName}
AppVersion={#ApplicationVersion}
AppPublisher={#ApplicationPublisher}
AppPublisherURL={#ApplicationURL}
AppSupportURL={#ApplicationURL}
AppUpdatesURL={#ApplicationURL}
AppCopyright={#ApplicationCopyright}
DefaultDirName={sd}\ACME\{#ApplicationName}
DefaultGroupName=ACME\{#ApplicationName}
LicenseFile={#PathAssets}\LICENSE.txt
InfoBeforeFile={#PathAssets}\BEFORE_INSTALL.txt
InfoAfterFile={#PathAssets}\AFTER_INSTALL.txt
OutputDir={#PathOutput}\
OutputBaseFilename=Setup_{#ApplicationName}_v{#ApplicationVersion}
Compression=lzma2/fast
SolidCompression=yes
AppContact=7567933+v20100v@users.noreply.github.com
UninstallDisplayIcon={app}\assets\images\myApplication.ico
WizardImageFile={#PathAssets}\images\innosetup_background.bmp
WizardImageStretch=no
WizardSmallImageFile={#PathAssets}\images\innosetup_image.bmp
SetupIconFile={#PathAssets}\images\setup.ico
BackColor=$FFFF00
VersionInfoVersion={#ApplicationVersion}

; Make this setup program work with 32-bit and 64-bit Windows
ArchitecturesAllowed=x86 x64
ArchitecturesInstallIn64BitMode=x64


[Languages]
Name: "en"; MessagesFile: compiler:Default.isl;
Name: "french"; MessagesFile: "compiler:Languages\French.isl"

[CustomMessages]
french.CheckInstall=est déjà installé sur ce PC.
french.CheckInstallAction=Souhaitez-vous désinstaller cette version existante avant de poursuivre?
en.CheckInstall=is already install on this PC.
en.CheckInstallAction=Do you want to uninstall this existing version before continuing?

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}";

[Files]
Source: "{#PathRelease}\{#ApplicationExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#PathRelease}*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
                                                                          
[Icons]
Name: "{group}\{#ApplicationName}"; Filename: "{app}\{#ApplicationExeName}"; IconFilename: {app}\assets\images\myApplication.ico.ico;
Name: "{group}\{cm:ProgramOnTheWeb,{#ApplicationName}}"; Filename: "{#ApplicationURL}";
Name: "{group}\{cm:UninstallProgram,{#ApplicationName}}"; Filename: "{uninstallexe}"; IconFilename: {app}\assets\images\setup.ico;
Name: "{commondesktop}\{#ApplicationName}"; Filename: "{app}\{#ApplicationExeName}"; IconFilename: {app}\assets\images\myApplication.ico; IconIndex: 0 

[Run]
Filename: "{app}\{#ApplicationExeName}"; Description: "{cm:LaunchProgram,{#StringChange(ApplicationName, '&', '&&')}}"; Flags: shellexec postinstall skipifsilent

[Registry]
Root: HKCR; Subkey: {#ApplicationName}Application; ValueType: string; ValueName: ; ValueData: Program {#ApplicationName}; Flags: uninsdeletekey
Root: HKCR; Subkey: {#ApplicationName}Application\DefaultIcon; ValueType: string; ValueName: ; ValueData: {app}\{#ApplicationExeName},0; Flags: uninsdeletevalue
Root: HKCR; Subkey: {#ApplicationName}Application\shell\open\command; ValueType: string; ValueName: ; ValueData: """{app}\{#ApplicationExeName}"" ""%1"""; Flags: uninsdeletevalue

[Code]
function InitializeSetup(): Boolean;
var
  ResultCode: Integer;
  ResultStr:string;
begin
  // Check if the application is already install
  // MsgBox('ApplicationID = ' + '{#ApplicationID}', mbInformation, mb_Ok);
  begin
    If RegQueryStringValue(HKLM, 'SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{#ApplicationID}_is1', 'UninstallString', ResultStr) then begin
      If ResultStr<>'' then begin
        ResultStr:=RemoveQuotes(ResultStr);
          if MsgBox('{#ApplicationName} ' + ExpandConstant('{cm:CheckInstall}') + #13#13 + ExpandConstant('{cm:CheckInstallAction}'), mbConfirmation, MB_YESNO) = idYes then
          if not Exec(ResultStr, '/silent', '', SW_SHOW, ewWaitUntilTerminated, ResultCode) then
            MsgBox('Erreur !!! ' #13#13 '' + SysErrorMessage(ResultCode) + '.', mbError, MB_OK);
      end;
    end;
  end ;
  Result := True;
end;

procedure InitializeWizard();
var
  WLabel1, WLabel2 : TLabel;
begin
  WizardForm.WelcomeLabel1.Hide;
  WizardForm.WelcomeLabel2.Hide;
  WizardForm.FinishedHeadingLabel.Hide;

  WizardForm.WizardBitmapImage.Width := 500;
  WizardForm.WizardBitmapImage.Height := 315;

  WLabel1 := TLabel.Create(WizardForm);
  WLabel1.Left := ScaleX(176); 
  WLabel1.Top := ScaleY(16);
  WLabel1.Width := ScaleX(301); 
  WLabel1.Height := ScaleY(54); 
  WLabel1.AutoSize := False;
  WLabel1.WordWrap := True;
  WLabel1.Font.Name := 'tahoma'; 
  WLabel1.Font.Size := 12; 
  WLabel1.Font.Style := [fsBold];
  WLabel1.Font.Color:= clBlack; 
  WLabel1.ShowAccelChar := False;
  WLabel1.Caption := WizardForm.WelcomeLabel1.Caption;
  WLabel1.Transparent := True;
  WLabel1.Parent := WizardForm.WelcomePage;
  WLabel1.Hide;

  WLabel2 :=TLabel.Create(WizardForm);
  WLabel2.Left := ScaleX(176); 
  WLabel2.Top := ScaleY(136);
  WLabel2.Width := ScaleX(301); 
  WLabel2.Height := ScaleY(234); 
  WLabel2.AutoSize := False;
  WLabel2.WordWrap := True;
  WLabel2.Font.Name := 'tahoma'; 
  WLabel2.Font.Color:= clBlack; 
  WLabel2.ShowAccelChar := False;
  WLabel2.Caption := WizardForm.WelcomeLabel2.Caption;
  WLabel2.Transparent := True;
  WLabel2.Parent := WizardForm.WelcomePage;

  WizardForm.WizardBitmapImage2.Width := 500; 
  WizardForm.WizardBitmapImage2.Height := 315; 

  WizardForm.FinishedLabel.Left := ScaleX(176);
  WizardForm.FinishedLabel.Top := ScaleY(116);
end;

procedure CurPageChanged(CurPageID: Integer);
begin
  // you must do this as late as possible, because the RunList is being modified
  // after installation; so this will check if there's at least one item in the
  // RunList and then set to the first item (indexing starts at 0) Enabled state
  // to False
  if (CurPageID = wpFinished) then    
    //WizardForm.RunList.Visible := False;
    WizardForm.RunList.Left := ScaleX(176);
    WizardForm.RunList.Top := ScaleY(214);
end;