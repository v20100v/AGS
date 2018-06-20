#include <GUIConstantsEx.au3>
#include "GUICtrlOnHover.au3"

Global $Pic1 = @Systemdir & "\oobe\images\hand1.gif"
Global $Pic2 = @Systemdir & "\oobe\images\hand2.gif"

$Gui = GUICreate("Hand Click Example", 280, 200)

$Hand_Pic = GUICtrlCreatePic($Pic1, 55, 35, 180, 120)
_GUICtrl_OnHoverRegister(-1, "_Hover_Proc", "_Leave_Hover_Proc")

GUISetState()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func _Hover_Proc($iCtrlID)
	Switch $iCtrlID
		Case $Hand_Pic
			GUICtrlSetImage($iCtrlID, $Pic2)
	EndSwitch
EndFunc

Func _Leave_Hover_Proc($iCtrlID)
	Switch $iCtrlID
		Case $Hand_Pic
			GUICtrlSetImage($iCtrlID, $Pic1)
	EndSwitch
EndFunc
