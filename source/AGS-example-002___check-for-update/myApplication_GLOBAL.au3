#cs ----------------------------------------------------------------------------
Defines application constants and variable in global scope

AutoIt Version : 3.3.14.5
Author         : v20100v <7567933+v20100v@users.noreply.github.com>
Package        : autoit-gui-skeleton
Version        : 1.0
#ce ----------------------------------------------------------------------------


#include-once


; Application main constants
Global Const $APP_NAME = "myApplication"
Global Const $APP_VERSION = "1.2.1"
Global Const $APP_WEBSITE = "https://myApplication-website.org"
Global Const $APP_EMAIL_CONTACT = "myApplication@website.org"
Global Const $APP_ID = "acme.myApplication"
Global Const $APP_LIFE_PERIOD = "2016-" & @YEAR
Global Const $APP_COPYRIGHT = "© " & $APP_LIFE_PERIOD & ", A.C.M.E."

; Application GUI constants
Global Const $APP_WIDTH = 800
Global Const $APP_HEIGHT = 600
Global Const $APP_GUI_TITLE_COLOR = 0x85C4ED
Global Const $APP_GUI_LINK_COLOR = 0x5487FB

; Application alias
Global Const $APP_FOLDER_ROOT = @ScriptDir
Global Const $APP_FOLDER_ASSETS = @ScriptDir & "/assets"
Global Const $APP_CONFIGURATION_INI = @ScriptDir & "/config/myApplication.ini"

; Check updates. This json file must persist in a remote server available with internet, and without restriction.
Global Const $APP_REMOTE_RELEASES_JSON = "https://github.com/v20100v/autoit-gui-skeleton/tree/master/source/AGS-example-002___check-updater/RELEASES.json"

; Application global variable
; Persist opened file on action "File > Open"
Global $OPEN_FILE = False
Global $OPEN_FILE_PATH = -1
Global $OPEN_FILE_NAME = -1
