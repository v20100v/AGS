<!-- Breadcrumb navigation -->
<nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="{{ site.url }}{{ site.baseurl }}/">Home</a></li>
    <li class="breadcrumb-item"><a href="{{ site.url }}{{ site.baseurl }}/documentation">Documentation</a></li>
    <li class="breadcrumb-item active" aria-current="page">Creating installation packages for AutoIt application</li>
  </ol>
</nav>

<!-- To be placed at the beginning of the post, it is where the table of content will be generated -->
* TOC
{:toc}



# Objectifs et motivations

Lorsqu'on termine une application, et que nous avons un code executable, il faut trouver un moyen pour faciliter le déploiement et l'installation sur un poste client. L'approche naturelle est de créer une simple archive zip du projet. Mais ce n'est pas suffisant, si on souhaite bénéficier de toutes les fonctionnalités d'un installeur Windows.

Ainsi afin de faciliter le déploiement d'une application de bureau Windows, AGS propose de constuire un installeur Windows avec la solution [InnoSetup](http://www.jrsoftware.org/isinfo.php).


# Packager une application AutoIt et créer un programme d'installation Windows

Pour préparer un package et générer un programme d'installation, les principales étapes à suivre sont les suivantes :

  - Affecter un numéro de version à l'application et configurez les scripts qui créent le paquet et génèrent le programme d'installation de Windows.
  - Compiler l'application via le point d'entrée principal myApplication.au3 avec le compilateur theaut2exe;
  - Copier les assets (images, fichiers ...) nécessaires au bon fonctionnement de l'application dans le répertoire de sortie;
  - Créer une archive zip pour récupérer l'application;
  - Et finalement construire le programme d'installation en compilant le script InnoSetup associé.

Toutes les étapes, pour packager l'application et générer le programme d'installation, sont pilotées à partir d'un batch Windows, pour des raisons évidentes de rejouabilité et de facilité d'utilsiation.


## Utiliser un batch Windwos comme chef d'orquestre

Avec AGS nous utilisons un fichier batch Windows, appelé `deployment_autoit_application.bat`, qui joue en effet le rôle de ched d'orquestre. Il créer le répertoire de sortie `\releases\vx.y.z\`, dans lequel l'archive zip de l'application et le programme d'installation de Windows seront construits.

![AGS GUI package and deployment process]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/AGS-package-and-deployment-process.gif){:class="img-full img-fancybox"}

<br/>

Pour ce faire, il suivra les 7 étapes suivantes:



### Étape 1/7 : créer un répertoire de sortie

Avant l'exécution du batch Windows, il est nécessaire de définir différentes variables utilisées dans ce processus de création d'installeur:

Variable | Description
-------- | -----------------
`%VERSION%` | Version assigned to the application.
`%NAME_PROJECT%` | Used to name the executable of the application. Note that the version number also appears in the executable name.
`%AUT2EXE_AU3%` | The name of the main AutoIt file (`myApplication.au3`)
`%AUT2EXE_ICON%` | The application icon (`%FOLDER_SRC%\assets\images\myApplication.ico`)
`%ZIP_CLI%` | Path of the 7zip binary to create an archive (`"C:\Program Files\7-Zip\7z.exe"`). I advise you to install it via the manager Chocolatey.
`%ISCC_CLI%` | InnoSetup compiler binary path (`"C:\Program Files (x86)\Inno Setup 5\ISCC.exe "`). I advise you to install it via the manager Chocolatey.

À partir de ces variables, le batch Windows construira le répertoire de sortie `.\ Releases\v1.0.0\ myApplication_v1.0.0\`, dans lequel le programme d'entrée principal sera compiler,


### Étape 2/7: Compilation AutoIt du programme principal

Le programme AutoIt principal est compilé en ligne de commande avec le binaire `aut2exe`. Attention, il faut que ce dernier soit correctement renseigné dans la variable d'environnement `%PATH%` du système d'exploitation.

```Batch
:: deployment_autoit_application.bat ::

(...)

set AUT2EXE_ARGS=/in "%FOLDER_SRC%\%AUT2EXE_AU3%" /out "%FOLDER_OUT%\%NAME_EXE%" /icon
aut2exe %AUT2EXE_ARGS%
echo Compilation AutoIt is finished.
```


### Étape 3/7: Copier les ressources

Lorsque le processus est lancé, il copiera dans le répertoire de sortie tous les éléments (images, fichiers ...) nécessaires au bon fonctionnement de l'application et à la génération du programme d'installation dans le répertoire de sortie.


### Étape 4/7: Create a file with metadatas of generation

In order to keep the build date, we create a file named `".v%VERSION%"` in the output directory. It's possible to store in this text file any metadats need to describe this generated application.


### Étape 5/7: Créer l'archive zip

La création de l'archive zip nécessite que 7zip soit installé sur l'ordinateur et que la variable `%ZIP_CLI%` soit correctement renseignée avec le chemin complet de ce binaire. La commande qui génère alors l'archive est la suivante:

```Batch
set ZIP_CLI="C:\Program Files\7-Zip\7z.exe"

%ZIP_CLI% a -tzip %NAME_PROJECT%_v%VERSION%.zip "%NAME_PROJECT%_v%VERSION%
echo * The zip has been created.
```


### Étape 6/7: Créer l'installeur Windows avec le script InnoSetup

Le script InnoSetup `.\Deployment\deployment_autoit_application.iss` contient toutes les instructions pour générer le programme d'installation Windows associé.

On passe les arguments définis dans le batch Windows au script ISS via l'instruction `/dNameVariable=ValueVariable` en ligne de commande. Ainsi avec cette démarche, il suffit de configurer une seule fois les variables du projet (nom, version ...) dans le fichier batch Windows. Il n'est pas nécessaire de reconfigurer les variables dans le script ISS.

> **!!! Attention !!!**
>
> Dans le fichier de script ISS, il existe d'autres variables à configurer: `ApplicationPublisher`,` ApplicationURL`, `ApplicationGUID`, ...

```Batch
set ISCC_CLI="C:\Program Files (x86)\Inno Setup 5\ISCC.exe"
set ISCC_SCRIPT=deployment_autoit_application.iss

echo * Launch compilation with iscc
%ISCC_CLI% %ISCC_SCRIPT% /dApplicationVersion=%VERSION% /dApplicationName=%NAME_PROJECT%
echo * Compilation has been finished.
```


### Étape 7/7: Nettoyer en supprimant le répertoire temporaire

Il suffit de conserver uniquement l'archive Zip et le programme d'installation Windows à la fin du processus. Donc le batch Windows supprime le répertoire temporaire à la fin du processus.

![AGS GUI package and deployment result]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/AGS-package-and-deployment-result.png){:class="img-full"}



# Fonctionnalité d'un installeur Windows avec AGS et InnoSetup

## Support de l'internationalisation (i18n)

Pour ajouter une nouvelle langue, il suffit d'ajouter dans la section `[languages]` la langue fournie dans le compilateur dans le fichier de script InnoSetup (ISS). Cela va traduire tous les messages natifs à InnoSetup.
Attention, méfiez-vous des boutons «YES/NO» des MsgBox. Ils n'utilisent que la langue du système d'exploitation.

```Batch
[Languages]
Name: "en"; MessagesFile: compiler:Default.isl;
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
```

Pour traduire les autres messages, il suffit de les déclarer dans la section `[CustomMessages]`, en préfixant les variables avec la langue (`en`,` french`, `nl`, ...). [http://www.jrsoftware.org/ishelp/index.php?topic=languagessection](http://www.jrsoftware.org/ishelp/index.php?topic=languagessection)

```Batch
[CustomMessages]
french.CheckInstall=est déjà installé sur ce PC.
french.CheckInstallAction=Souhaitez-vous désinstaller cette version existante avant de poursuivre?
en.CheckInstall=is already install on this PC.
en.CheckInstallAction=Do you want to uninstall this existing version before continuing?
```

Ainsi, au démarrage de l'installation, il demande à l'utilisateur de choisir la langue qu'il doit utiliser.

![AGS InnoSetup choix langue]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/innosetup_choose_language.png)


## Vérifier si l'application est déjà installé sur le PC

Pour éviter d'installer plusieurs fois l'application sur l'ordinateur client, le programme d'installation vérifie à l'avance qu'il n'est pas déjà présent.

![AGS InnoSetup check already install]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/innosetup_check_already_install.png)

Pour ce faire, il est basé sur le GUID (*global unique identifier*) défini dans le script InnoSetup. Il est important de ne pas modifier ce code entre différentes versions d'application et qu'il soit unique par application. L'IDE fourni par InnoSetup fournit un outil pour en générer un nouveau GUID, accessible via le menu: *Outils > Générer GUID dans l'IDE*.

```Batch
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
#define ApplicationGUID "6886E28B-AAB5-4866-BCD5-E1B4C171A87A"
#define ApplicationID ApplicationName + "_" + ApplicationGUID
```

Le programme d'installation ajoute la clé `SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\{# ApplicationID}_is1` dans la base de registre Windows. Et lorsque l'application est désinstallée, cette clé est supprimée. Il suffit donc de vérifier la présence de cette clé dans le registre pour savoir si l'application a déjà été installée.

![AGS InnoSetup check already install in Windows registry]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/innosetup_check_already_install2.png){:class="img-fancybox img-full"}


## Configurer des messages supplémentaires dans l'installeur : licence, prérequis & historique

Pour configurer différents messages pour le programme d'installation, y compris les accords de licence, il suffit de remplir les fichiers texte stockés dans le répertoire `/Assets`.

- `AFTER_INSTALL.txt`: généralement pour afficher la feuille de route et l'historique du projet;
- `BEFORE_INSTALL.txt`: généralement pour afficher les prérequis de l'application;
- `LICENSE.txt`: pour la licence d'utilisation.

![AGS InnoSetup licence aggrement]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/innosetup_choose_license_agreement.png)


## Ajouter des icônes dans le menu Démarrer de Windows

Pour ajouter des éléments au menu Démarrer de Windows, entrez la section `[Icons]` dans le script InnoSetup comme suit:

```batch
[Icons]
Name: "{group}\{#ApplicationName}"; Filename: "{app}\{#ApplicationExeName}"; IconFilename: {app}\assets\images\myApplication.ico;
Name: "{group}\{cm:ProgramOnTheWeb,{#ApplicationName}}"; Filename: "{#ApplicationURL}";
Name: "{group}\{cm:UninstallProgram,{#ApplicationName}}"; Filename: "{uninstallexe}"; IconFilename: {app}\assets\images\setup.ico;
Name: "{commondesktop}\{#ApplicationName}"; Filename: "{app}\{#ApplicationExeName}"; IconFilename: {app}\assets\images\myApplication.ico; IconIndex: 0
```

Ainsi on obtient :

![AGS InnoSetup licence Windows icons start menu]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/innosetup_finish2.png)


## Executer une commande après l'installation

Il est possible de configurer l'installeur pour qu'il execute une commande à la fin de l'installation, comme par exemple pour démarrer l'application, ouvrir une page web, ouvrir un pdf...

![AGS InnoSetup licence Windows icons start menu]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/innosetup_finish.png)


## Personnaliser et modifiez les éléments graphiques du programme d'installation Windows

Nous avons choisi une taille (largeur x hauter) statique pour l'installateur. Ce n'est pas le plus facile de changer ces dimensions.

Il y a 2 images et 2 icônes utilisées dans l'installateur. Ils sont stockés dans le répertoire `.\Assets\images`. Les images sont nécessairement au format bmp et doivent respecter les tailles standards.

Images use in setup       | File  | Comments
--------------------------|-------|---------
UninstallDisplayIcon      | .\assets\images\myApplication.ico | Must be an ico
SetupIconFile             | .\assets\images\setup.ico  | Must be an ico
WizardImageFile           | .\assets\images\innosetup_background.bmp  |  Must be a 500x313 bmp image
WizardSmallImageFile      | .\assets\images\innosetup_image.bmp  | Must be a 50x50 bmp image

Dans le script InnoSetup, ils sont utilisés comme suit:

```Batch
UninstallDisplayIcon={app}\assets\images\myApplication.ico
WizardImageFile={#PathAssets}\images\innosetup_background.bmp
WizardSmallImageFile={#PathAssets}\images\innosetup_image.bmp
SetupIconFile={#PathAssets}\images\setup.ico
```


# Code source

## Windows batch, le chef d'orquestre

```Batch
::---------------------------------------------------------------------------------
::
::    Copyright © 2018-05, v20100v
::
::    @author    v20100v
::    @contact   7567933+v20100v@users.noreply.github.com
::    @version   1.0.0
::
::---------------------------------------------------------------------------------

cls
@echo off

:: Change value for this variables
set VERSION=1.0.0
set NAME_PROJECT=myApplication

:: Deployment variables
set FOLDER_CURRENT=%cd%
set NAME_EXE=%NAME_PROJECT%_v%VERSION%.exe
set FOLDER_SRC=%FOLDER_CURRENT%\..\
cd %FOLDER_SRC%
set FOLDER_SRC=%cd%
set FOLDER_OUT=%FOLDER_CURRENT%\releases\v%VERSION%\%NAME_PROJECT%_v%VERSION%

:: AutoIt compiler
Set AUT2EXE_AU3=myApplication.au3
set AUT2EXE_ICON=%FOLDER_SRC%\assets\images\myApplication.ico
set AUT2EXE_ARGS=/in "%FOLDER_SRC%\%AUT2EXE_AU3%" /out "%FOLDER_OUT%\%NAME_EXE%" /icon "%AUT2EXE_ICON%"

:: Path binaries
set ZIP_CLI="C:\Program Files\7-Zip\7z.exe"
set ISCC_CLI="C:\Program Files (x86)\Inno Setup 5\ISCC.exe"
set ISCC_SCRIPT=deployment_autoit_application.iss


echo.
echo.
echo     º  Run script deployment for : %NAME_PROJECT%  º
echo.
echo.


echo ÄÄÄÄ[ Variables for generation ]ÄÄÄÄ
echo * VERSION        = %VERSION%
echo * NAME_PROJECT   = %NAME_PROJECT%
echo * FOLDER_CURRENT = %FOLDER_CURRENT%
echo * NAME_EXE       = %NAME_EXE%
echo * FOLDER_SRC     = %FOLDER_SRC%
echo * FOLDER_OUT     = %FOLDER_OUT%
echo * AUT2EXE_ICON   = %AUT2EXE_ICON%
echo * AUT2EXE_AU3    = %AUT2EXE_AU3%
echo * AUT2EXE_ARGS   = %AUT2EXE_ARGS%
echo * ZIP_CLI        = %ZIP_CLI%
echo * ISCC_CLI       = %ISCC_CLI%
echo * ISCC_SCRIPT    = %ISCC_SCRIPT%
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

echo.
echo.

echo ÄÄÄÄ[ Step 1/7 - Creating directories ]ÄÄÄÄ
cd %FOLDER_CURRENT%
echo * Attempt to create : "%cd%\releases\"
mkdir releases
cd releases
echo.
echo * Attempt to create : "%cd%\v%VERSION%\"
mkdir v%VERSION%
cd v%VERSION%
echo.
echo * Attempt to create : %cd%\%NAME_PROJECT%_v%VERSION%\
mkdir %NAME_PROJECT%_v%VERSION%
cd %FOLDER_CURRENT%
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

echo.
echo.


echo ÄÄÄÄ[ Step 2/7 - Launch AutoIt compilation ]ÄÄÄÄ
echo * Run compilation with aut2exe and AUT2EXE_ARGS.
aut2exe %AUT2EXE_ARGS%
echo * Compilation AutoIt is finished.
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

echo.
echo.


echo ÄÄÄÄ[ Step 3/7 - Copy assets files ]ÄÄÄÄ
echo * Create the file xcopy_EXCLUDE.txt in order to ignore some file and directory.
echo .au3 > xcopy_Exclude.txt
echo .pspimage >> xcopy_Exclude.txt
echo *   - ignore all .au3 files
echo *   - ignore all .pspimage files
echo * The file xcopy_EXCLUDE.txt is created.
echo.
echo * Copy additional files store in assets directory with xcopy
echo * Launch command : xcopy "%FOLDER_SRC%\assets" "%FOLDER_OUT%\assets\" /E /H /Y /EXCLUDE:xcopy_Exclude.txt
xcopy "%FOLDER_SRC%\assets" "%FOLDER_OUT%\assets\" /E /H /Y /EXCLUDE:xcopy_Exclude.txt
echo * Files and directory are copied.
echo.
echo * Delete xcopy_Exclude.txt.
del xcopy_Exclude.txt
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

echo.
echo.


echo ÄÄÄÄ[ Step 4/7 - Create additional files ]ÄÄÄÄ
echo * Create file ".v%VERSION%" in FOLDER_OUT.
cd %FOLDER_OUT%
echo Last compilation of application %NAME_PROJECT% version %VERSION% the %date% at %time% > .v%VERSION%
echo * This file has been created.
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

echo.
echo.


echo ÄÄÄÄ[ Step 5/7 - Create zip archive ]ÄÄÄÄ
echo * Move in the folder %FOLDER_CURRENT%\releases\v%VERSION%
cd %FOLDER_CURRENT%\releases\v%VERSION%
echo * Zip the folder %NAME_PROJECT%_v%VERSION%
%ZIP_CLI% a -tzip %NAME_PROJECT%_v%VERSION%.zip "%NAME_PROJECT%_v%VERSION%
echo * The zip has been created.
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

echo.
echo.

echo ÄÄÄÄ[ Step 6/7 - Make setup with InnoSetup command line compilation ]ÄÄÄÄ
cd %FOLDER_CURRENT%
echo * Launch compilation with iscc
%ISCC_CLI% %ISCC_SCRIPT% /dApplicationVersion=%VERSION% /dApplicationName=%NAME_PROJECT%
echo.
echo * Compilation has been finished.
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

echo.
echo.

echo ÄÄÄÄ[ Step 7/7 - Delete temp folder use for ISS compilation ]ÄÄÄÄ
cd %FOLDER_CURRENT%
echo * Delete the folder %FOLDER_CURRENT%\releases\v%VERSION%\%NAME_PROJECT%_v%VERSION%\
rmdir %FOLDER_CURRENT%\releases\v%VERSION%\%NAME_PROJECT%_v%VERSION% /S /Q
echo ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ

echo.
echo.

cd %FOLDER_CURRENT%
echo ÄÄÄÄ[ End process ]ÄÄÄÄ
echo.
```


## InnoSetup Script (ISS) associé

```batch
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
Source: "{#PathRelease}\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs
                                                                          
[Icons]
Name: "{group}\{#ApplicationName}"; Filename: "{app}\{#ApplicationExeName}"; IconFilename: {app}\assets\images\myApplication.ico;
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
```



<br/>

> **Lectures associés**
>
> <a href="{{ site.url }}{{ site.baseurl }}/documentation/getting-started">Démarrer avec AGS</a><br/>
> <a href="{{ site.url }}{{ site.baseurl }}/documentation/code-organization">Organisation du code d'un projet AGS</a>.