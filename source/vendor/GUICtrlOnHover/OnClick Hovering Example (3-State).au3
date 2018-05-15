#include <GUIConstantsEx.au3>
#include "GUICtrlOnHover.au3"

Global $PlayIsClicked 	= False
Global $sImages_Path 	= @ScriptDir & "\Example Images"

$Gui = GUICreate("OnClick Hovering Example", 280, 200)
GUISetBkColor(0xFFFFFF)

$Button = GUICtrlCreatePic($sImages_Path & "\Button.jpg", 82, 24, 82, 24)
_GUICtrl_OnHoverRegister(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$Round = GUICtrlCreatePic($sImages_Path & "\Round_Button.jpg", 82, 70, 150, 24)
_GUICtrl_OnHoverRegister(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$Pause = GUICtrlCreatePic($sImages_Path & "\Pause_Button.jpg", 110, 100, 40, 40)
_GUICtrl_OnHoverRegister(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

$Play = GUICtrlCreatePic($sImages_Path & "\Play_Button.jpg", 70, 100, 40, 40)
_GUICtrl_OnHoverRegister(-1, "_Hover_Proc", "_Leave_Hover_Proc", "PrimaryDown_Proc", "PrimaryUp_Proc")

GUISetState()

While 1
	$nMsg = GUIGetMsg()
	
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
	
	;We use Global variable and main loop to avoid the blocking of OnHover function (please read UDF docs)
	If $PlayIsClicked Then
		$PlayIsClicked = False
		
		MsgBox(64, "", "You Clicked 'Play' Button")
	EndIf
WEnd

Func _Hover_Proc($iCtrlID)
	Switch $iCtrlID
		Case $Button
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Button_Hover.jpg")
		Case $Round
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Round_Button_Hover.jpg")
		Case $Pause
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Pause_Button_Hover.jpg")
		Case $Play
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Play_Button_Hover.jpg")
	EndSwitch
EndFunc

Func _Leave_Hover_Proc($iCtrlID)
	Switch $iCtrlID
		Case $Button
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Button.jpg")
		Case $Round
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Round_Button.jpg")
		Case $Pause
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Pause_Button.jpg")
		Case $Play
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Play_Button.jpg")
	EndSwitch
EndFunc

Func PrimaryDown_Proc($iCtrlID)
	Switch $iCtrlID
		Case $Button
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Button_Click.jpg")
		Case $Round
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Round_Button_Click.jpg")
		Case $Pause
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Pause_Button_Click.jpg")
		Case $Play
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Play_Button_Click.jpg")
			
			;$PlayIsClicked = True
	EndSwitch
EndFunc

Func PrimaryUp_Proc($iCtrlID)
	Switch $iCtrlID
		Case $Button
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Button_Hover.jpg")
		Case $Round 
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Round_Button_Hover.jpg")
		Case $Pause
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Pause_Button_Hover.jpg")
		Case $Play
			GUICtrlSetImage($iCtrlID, $sImages_Path & "\Play_Button_Hover.jpg")
			
			$PlayIsClicked = True
	EndSwitch
EndFunc
