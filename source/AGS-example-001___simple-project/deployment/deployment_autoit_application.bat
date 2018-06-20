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