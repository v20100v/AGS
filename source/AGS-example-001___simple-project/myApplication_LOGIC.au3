#cs ----------------------------------------------------------------------------
Logic and business code

AutoIt Version : 3.3.14.5
Author         : v20100v <7567933+v20100v@users.noreply.github.com>
Package        : autoit-gui-skeleton
Version        : 1.0
#ce ----------------------------------------------------------------------------


#include-once


;===========================================================================================================
; Show a dialog box to user, in order that he chooses a file in the Windows Explorer
;
; @params : void
; @return : $array_result[0] = file path
;           $array_result[1] = file name
;===========================================================================================================
Func _dialogbox_open()
   Local $info_fichier = _WinAPI_GetOpenFileName("Open file", "*.*", @WorkingDir, "", _
						  "", 2, BitOR($OFN_ALLOWMULTISELECT, $OFN_EXPLORER), $OFN_EX_NOPLACESBAR)
   Local $array_result[2]

   If @error Then
	  $array_result[0] = -1
	  $array_result[1] = -1
   Else
	  ; Chemin relatif du nouveau fichier
	  $array_result[0] = $info_fichier[1]&"\"&$info_fichier[2] ; $PATHFILE_OF_OPEN_FILE_IN_APP
	  $array_result[1] = $info_fichier[2] ; $NAME_OF_OPEN_FILE_IN_APP
   EndIf

   Return $array_result
EndFunc