#cs ----------------------------------------------------------------------------
Main entry program

The main method is the entry point of a application. When the application is
started, the main method is the first method called.

AutoIt Version : 3.3.14.5
Author         : v20100v <7567933+v20100v@users.noreply.github.com>
Package        : autoit-gui-skeleton
Version        : 1.0
#ce ----------------------------------------------------------------------------


Opt('MustDeclareVars', 1)


; Include all built-in AutoIt library requires
#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIDlg.au3>

; Include all third-party code in a project store in vendor directory
#include 'vendor/GUICtrlOnHover/GUICtrlOnHover.au3'

; Include myApplication scripts
#include 'myApplication_GLOBAL.au3'
#include 'myApplication_LOGIC.au3'
#include 'myApplication_GUI.au3'



; Start main graphic user interface
_main_GUI()
