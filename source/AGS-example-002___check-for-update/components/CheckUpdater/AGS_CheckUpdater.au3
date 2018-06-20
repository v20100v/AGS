#cs --------------------------------------------------------------------------------------------------------
CheckUpdater

Handler releases by compare a local version to a remote version store in a JSON file (RELEASES.json). This
JSON file is saved on remote server, so to work it needs an internet connection to recover this JSON file,
as well as a JSON parser in AutoIt. We use the implementation proposed by ward store in vendor folder to deal
with JSON file.

Component title   : HttpRequest
Component version : 1.0.0
AutoIt version    : 3.3.14.5
Author            : v20100v <7567933+v20100v@users.noreply.github.com>
Package           : AGS version 1.0.0
#ce --------------------------------------------------------------------------------------------------------

#include-once

#include <Array.au3>
#include '../../components/HttpRequest/AGS_HttpRequest.au3'
#include '../../vendor/JSON/JSON.au3'


Opt('MustDeclareVars', 1)


;===========================================================================================================
; Decode JSON from a given local file
;
; @param $jsonfilePath (string)
; @return $object (object), instance return by json_decode
;
; @example
; <code>
;   Local $file = @ScriptDir & "\RELEASES.json"
;   Local $jsonObject = json_decode_from_file($file)
; </code>
;==============================================================================================================
Func json_decode_from_file($filePath)
	Local $fileOpen, $fileContent, $object

	$fileOpen = FileOpen($filePath, $FO_READ)
	If $fileOpen = -1 Then
		Return SetError(1, 0, "An error occurred when reading the file " & $filePath)
	EndIf
	$fileContent = FileRead($fileOpen)
	FileClose($fileOpen)
	$object = Json_Decode($fileContent)

	Return $object
EndFunc


;===========================================================================================================
; Decode JSON from a given URL
;
; @param $jsonfileUrl (string)
; @param $proxy (string), specify a proxy. By default we load proxy settings form configuration file
; @return $object (object), instance return by json_decode
;===========================================================================================================
Func json_decode_from_url($jsonfileUrl, $proxy = "")
	Local $response = HttpGET($jsonfileUrl, Default, $proxy)
	If (@error) Then
		Return SetError(@error, $response, "Unable to get json file on remote server " & $jsonfileUrl & ".")
	EndIf
	Local $data = $response.ResponseText
	Local $object = json_decode($data)

	Return $object
EndFunc


;===========================================================================================================
; Get all defined version(s) persisted in RELEASES.json
;
; @param $jsonObject (object), instance return by json_decode
; @return $RELEASES_all_versions (array[$i][6]) with $i equals to number of rows in this collection
;            -> $RELEASES_all_versions[$i][1] : Version
;            -> $RELEASES_all_versions[$i][2] : state
;            -> $RELEASES_all_versions[$i][3] : downloadSetup
;            -> $RELEASES_all_versions[$i][4] : published
;            -> $RELEASES_all_versions[$i][5] : releaseNotes
;
; Example of a `RELEASES.json` file:
; {
;   "name": "myApplication",
;   "description": "Description of myApplication into a small paragraph",
;   "license": "",
;   "homepage": "https://myApplication.com",
;   "releases": [
;     {
;       "version": "1.1.0",
;       "state": "stable",
;       "downloadSetup": "https://myApplication.com/download/setup_myApplication_v1.1.0.exe",
;       "published": "2018-04-25",
;       "releaseNotes": "https://myApplication.com/releases/myApplication_v1.1.0.html"
;     },
;     {
;       "version": "1.0.0",
;       "state": "prototype",
;       "downloadSetup": "undefined",
;       "published": "2017-02-14",
;       "releaseNotes": "undefined"
;     }
;   ]
; }
;===========================================================================================================
Func RELEASES_JSON_get_all_versions($jsonObject)
	Local $releases = Json_Get($jsonObject, '.releases')

	; Check if a version is defined into RELEASE.json
	Local $releases_count = UBound($releases)
	If $releases_count = 0 Then
		Return SetError(3, 0, "In this RELEASES.json, the array attribute 'releases' is empty.")
	EndIf

	Local $RELEASES_all_versions[$releases_count][5]
	For $i = 0 To UBound($releases) - 1 Step 1
		$RELEASES_all_versions[$i][0] = Json_Get($jsonObject, '.releases' & '[' & $i & '].version')
		$RELEASES_all_versions[$i][1] = Json_Get($jsonObject, '.releases' & '[' & $i & '].state')
		$RELEASES_all_versions[$i][2] = Json_Get($jsonObject, '.releases' & '[' & $i & '].downloadSetup')
		$RELEASES_all_versions[$i][3] = Json_Get($jsonObject, '.releases' & '[' & $i & '].published')
		$RELEASES_all_versions[$i][4] = Json_Get($jsonObject, '.releases' & '[' & $i & '].releaseNotes')
	Next

	; Sort in order to have last version on first array position
	_ArraySort($RELEASES_all_versions, 1)

	Return $RELEASES_all_versions
EndFunc


;===========================================================================================================
; Get last version persisted in RELEASES.json
;
; @param $jsonObject (object), instance return by json_decode
; @return $array (array[1][6]), this collection have one row
;            -> $array[0][1] : Version
;            -> $array[0][2] : state
;            -> $array[0][3] : downloadSetup
;            -> $array[0][4] : published
;            -> $array[0][5] : releaseNotes
;===========================================================================================================
Func RELEASES_JSON_get_last_version($jsonObject)
	Local $RELEASES_all_versions = RELEASES_JSON_get_all_versions($jsonObject)
	If (@error) Then
		Return SetError(3, 0, "In this RELEASES.json, the array attribute 'releases' is empty.")
	EndIf

	; Because we sort array, we assume that the first array position is the last version
	Return _ArrayExtract($RELEASES_all_versions, 0, 0)
EndFunc


;===========================================================================================================
; Compare the current version with the last version persisted in the remote RELEASES.json file, in order
; to check if an update is available.
;
; @param $currentApplicationVersion (string), respect semantic versioning
; @param $remoteUrlReleasesJson (string), URL use to get and parse remote RELEASES.json
; @param $proxy (string), specify a proxy. By default we load proxy settings form configuration file
; @return $result (array[7])
;            -> result[0] : "NO_UPDATE_AVAILABLE" | "UPDATE_AVAILABLE" | "CURRENT_VERSION_GREATER_UPDATE_AVAILABLE"
;            -> result[1] : $currentApplicationVersion
;            -> result[2] : $remoteApplicationVersion
;            -> result[3] : $remoteApplicationState
;            -> result[4] : $remoteApplicationDownloadSetup
;            -> result[5] : $remoteApplicationPublished
;            -> result[6] : $remoteApplicationReleaseNotes
;
; @example
; <code>
;   Local $currentApplicationVersion = "1.1.10"
;   Local $remoteUrlReleasesJson = "http://myApplication.com/RELEASES.json"
;   Local $result = CheckForUpdates($currentApplicationVersion, $remoteUrlReleasesJson)
;   If (@error) Then
;     ConsoleWrite("Value of @error is: " & @error & @CRLF)
;     ConsoleWrite("Value of message error is: " & $result & @CRLF)
;   EndIf
;   _ArrayDisplay($result)
; </code>
;==============================================================================================================
Func CheckForUpdates($currentApplicationVersion, $remoteUrlReleasesJson, $proxy = "")
	Local $jsonObject = json_decode_from_url($remoteUrlReleasesJson, $proxy)
	If (@error) Then
		Return SetError(@error, @extended, _
				"Unable to get JSON on remote server " & $remoteUrlReleasesJson & " (status HTTP " & @extended & ")" _
				)
	EndIf

	Local $RELEASES_JSON_last_version_object = RELEASES_JSON_get_last_version($jsonObject)
	Local $remoteApplicationVersion = $RELEASES_JSON_last_version_object[0][0]
	Local $remoteApplicationState = $RELEASES_JSON_last_version_object[0][1]
	Local $remoteApplicationDownloadSetup = $RELEASES_JSON_last_version_object[0][2]
	Local $remoteApplicationPublished = $RELEASES_JSON_last_version_object[0][3]
	Local $remoteApplicationReleaseNotes = $RELEASES_JSON_last_version_object[0][4]

	Local $result[7]
	$result[0] = "UNCHECKED"
	$result[1] = $currentApplicationVersion
	$result[2] = $remoteApplicationVersion
	$result[3] = $remoteApplicationState
	$result[4] = $remoteApplicationDownloadSetup
	$result[5] = $remoteApplicationPublished
	$result[6] = $remoteApplicationReleaseNotes

	If $currentApplicationVersion == $remoteApplicationVersion Then
		$result[0] = "NO_UPDATE_AVAILABLE"
	ElseIf $currentApplicationVersion < $remoteApplicationVersion Then
		$result[0] = "UPDATE_AVAILABLE"
	ElseIf $currentApplicationVersion > $remoteApplicationVersion Then
		$result[0] = "CURRENT_VERSION_GREATER_UPDATE_AVAILABLE"
	EndIf

	Return $result
EndFunc


;==============================================================================================================
; @param $main_GUI (string), id of the the main GUI
; @param $context (string), use to specify if it's launch on startup application or from user interaction
;                           availables values are : ON_STARTUP or ON_MENU
;==============================================================================================================
Func _GUI_launch_CheckForUpdates($main_GUI, $context)
	GUISetCursor(15, $GUI_CURSOR_OVERRIDE)
	_GUI_Handler_Menu($GUI_DISABLE)

	Local $currentApplicationVersion = $APP_VERSION
	Local $remoteUrlReleasesJson = $APP_REMOTE_RELEASES_JSON
	Local $LAUNCH_CHECK_FOR_UPDATE_ON_STARTUP = Int(IniRead($APP_CONFIGURATION_INI, "AGS_CHECK_UPDATER", "LAUNCH_CHECK_FOR_UPDATE_ON_STARTUP", "NotFound"))
	Local $proxy = IniRead($APP_CONFIGURATION_INI, "AGS_HTTP_REQUEST", "PROXY", "NotFound")

	If ($context = "ON_STARTUP" And $LAUNCH_CHECK_FOR_UPDATE_ON_STARTUP = 1) Or ($context <> "ON_STARTUP") Then
		Local $resultCheckUpdates = CheckForUpdates($currentApplicationVersion, $remoteUrlReleasesJson)
		If (@error) Then
			Local $msgError = "Unable to connect with the remote server use to check if a new version is available." & _
					@CRLF & @CRLF & _
					"Code error = AGS_CHECK_UPDATER_" & @error & @CRLF & $resultCheckUpdates
			If ($proxy <> "NotFound") Then
				$msgError = $msgError & @CRLF & @CRLF & "We found a proxy settings into configuration file of application, equals to : " & $proxy
			Else
				$msgError = $msgError & @CRLF & @CRLF & "We doesn't found proxy settings into configuration file of application. Maybe you have to add one."
			EndIf
			MsgBox(16, "Error in check for updates", $msgError)
			GUISetCursor(2, $GUI_CURSOR_OVERRIDE)
			_GUI_Handler_Menu($GUI_ENABLE)
			Return Null
		EndIf

		; Build a child GUI to show results of check for update
		GUISetCursor(2, $GUI_CURSOR_OVERRIDE)
		_GUI_build_view_to_CheckForUpdates($main_GUI, $resultCheckUpdates, $context)
	EndIf
EndFunc


;==============================================================================================================
; Create a child GUI use to check if an update of current application is available. The child GUI is related
; to a given main GUI of application. If this method is execute on startup, we built this child GUI only if
; an update is available. And when this method is called by a user interaction, we built this child GUI in
; any case : no update available, new update or experimental.
;
; @param $main_GUI (string), id of the the main GUI
; @param $resultCheckForUpdate (array[7]), the result of CheckForUpdate() method
; @param $context (string), use to specify if it's launch on startup application or from user interaction
;                           availables values are : ON_STARTUP or ON_MENU
;
; @example
; <code>
;   Global $main_GUI = GUICreate($APP_NAME, 640, 640, -1, -1)
;   Local $currentApplicationVersion = "1.1.10"
;   Local $remoteUrlReleasesJson = "http://myApplication.com/RELEASES.json"
;   Local $resultCheckForUpdate = CheckForUpdate($currentApplicationVersion, $remoteUrlReleasesJson)
;   GUI_build_view_to_CheckForUpdates($main_GUI, resultCheckForUpdate, "ON_STARTUP")
; </code>
;==============================================================================================================
Func _GUI_build_view_to_CheckForUpdates($main_GUI, $resultCheckForUpdate, $context = "")

	Local $title_child_GUI, $text_label_update_informations, $text_label_release_notes

	If $resultCheckForUpdate[0] = "UPDATE_AVAILABLE" Then
		$title_child_GUI = "A new update is available"
		$text_label_update_informations = "This application " & $APP_NAME & " v" & $resultCheckForUpdate[1] & " is not up to date. The version " & $resultCheckForUpdate[2] & @CRLF & _
				"is the last (" & $resultCheckForUpdate[3] & "), and it was published on " & $resultCheckForUpdate[5] & "."
		$text_label_release_notes = "See the releases notes of last version " & $resultCheckForUpdate[2] & "."
	ElseIf $resultCheckForUpdate[0] = "NO_UPDATE_AVAILABLE" Then
		$title_child_GUI = "No update available"
		$text_label_update_informations = "This version of " & $APP_NAME & " v" & $resultCheckForUpdate[1] & " is the current version (" & $resultCheckForUpdate[3] & ")." & @CRLF & _
				"It was published on " & $resultCheckForUpdate[5] & "."
		$text_label_release_notes = "See the releases notes of this version " & $resultCheckForUpdate[1] & "."
	ElseIf $resultCheckForUpdate[0] = "CURRENT_VERSION_GREATER_UPDATE_AVAILABLE" Then
		$title_child_GUI = "Current version use is higher than the last published version"
		$text_label_update_informations = "This application  " & $APP_NAME & " v" & $resultCheckForUpdate[1] & " is an experimental version." & @CRLF & _
				"The version " & $resultCheckForUpdate[2] & " (" & $resultCheckForUpdate[3] & ") is the last one published on " & $resultCheckForUpdate[5] & "."
		$text_label_release_notes = "See the releases notes of the last one version published on " & $resultCheckForUpdate[2] & "."
	EndIf

	If ($context = "ON_STARTUP" And $resultCheckForUpdate[0] = "UPDATE_AVAILABLE") Or ($context <> "ON_STARTUP") Then

		; Create child GUI, related to a given $main_GUI
		GUISetState(@SW_DISABLE, $main_GUI)
		Local $update_GUI = GUICreate("Check for updates to " & $APP_NAME & " v" & $APP_VERSION, 600, 240, -1, -1)
		Local $logo_CHECK_UPDATE = GUICtrlCreatePic($APP_FOLDER_ASSETS & "/images/myApplication.bmp", 40, 60, 128, 128)

		; Title child GUI
		GUISetFont(16, 900, 0, "Arial Narrow")
		Local $label_title_child_GUI = GUICtrlCreateLabel($title_child_GUI, 20, 20)
		GUICtrlSetColor($label_title_child_GUI, 0x77b0d5)
		GUICtrlSetBkColor($label_title_child_GUI, $GUI_BKCOLOR_TRANSPARENT)

		; Label update informations
		GUISetFont(10, 400, 0, "Segoe UI")
		GUISetIcon($APP_FOLDER_ASSETS & "/images/myApplication.ico")
		GUISetBkColor(0xFFFFFF)
		Local $label_update_informations = GUICtrlCreateLabel($text_label_update_informations, 188, 80)

		; Label download
		Local $label_update_download = GUICtrlCreateLabel("Download the last version.", 198, 130)
		GUICtrlSetColor($label_update_download, 0x5487FB)
		_GUICtrl_OnHoverRegister($label_update_download, "_MouseOver_Label", "_MouseLeave_Func")
		GUICtrlSetCursor($label_update_download, 0)

		; Label release notes
		Local $label_update_release_notes = GUICtrlCreateLabel($text_label_release_notes, 198, 150)
		GUICtrlSetColor($label_update_release_notes, 0x5487FB)
		_GUICtrl_OnHoverRegister($label_update_release_notes, "_MouseOver_Label", "_MouseLeave_Func")
		GUICtrlSetCursor($label_update_release_notes, 0)

		; Handle visibility and position of elements
		GUICtrlSetState($label_update_download, $GUI_HIDE)
		If $resultCheckForUpdate[0] = "UPDATE_AVAILABLE" Then
			GUICtrlSetState($label_update_download, $GUI_SHOW)
		Else
			GUICtrlSetPos($label_update_release_notes, 198, 130)
		EndIf

		; Button OK
		Local $button_update_OK = GUICtrlCreateButton("OK", 490, 200, 90)
		GUICtrlSetCursor($button_update_OK, 0)

		; Handle user interaction and events in this child GUI
		GUISetState()
		While 1
			Switch GUIGetMsg()
				Case $GUI_EVENT_CLOSE
					GUISetState(@SW_ENABLE, $main_GUI)
					GUIDelete($update_GUI)
					ExitLoop
				Case $button_update_OK
					GUISetState(@SW_ENABLE, $main_GUI)
					GUIDelete($update_GUI)
					ExitLoop
				Case $label_update_download
					ShellExecute($resultCheckForUpdate[4])
				Case $label_update_release_notes
					ShellExecute($resultCheckForUpdate[6])
			EndSwitch
		WEnd

		_GUI_Handler_Menu($GUI_ENABLE)
	EndIf
EndFunc
