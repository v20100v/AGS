#include "GUICtrlOnHover.au3"

$hParent_GUI = GUICreate("Parent & Child Example", 280, 200)

$Parent_Button = GUICtrlCreateButton("Button", 20, 160, 100, 20)
_GUICtrl_OnHoverRegister(-1, "_Hover_Func", "_Leave_Hover_Func")

GUISetState()

$hChild_GUI = GUICreate("Child", 150, 100, -1, -1, -1, -1, $hParent_GUI)

$Child_Button = GUICtrlCreateButton("Button", 20, 20, 100, 20)
_GUICtrl_OnHoverRegister(-1, "_Hover_Func", "_Leave_Hover_Func")

While 1
	Switch GUIGetMsg()
		Case -3
			Exit
		Case $Parent_Button, $Child_Button
			If BitAND(WinGetState($hChild_GUI), 2) Then
				GUISetState(@SW_HIDE, $hChild_GUI)
			Else
				GUISetState(@SW_SHOW, $hChild_GUI)
			EndIf
	EndSwitch
WEnd

Func _Hover_Func($CtrlID)
	Switch $CtrlID
		Case $Parent_Button, $Child_Button
			If GUICtrlRead($CtrlID) <> "Show/Hide Child" Then GUICtrlSetData($CtrlID, "Show/Hide Child")
	EndSwitch
EndFunc

Func _Leave_Hover_Func($CtrlID)
	Switch $CtrlID
		Case $Parent_Button, $Child_Button
			If GUICtrlRead($CtrlID) <> "Button" Then GUICtrlSetData($CtrlID, "Button")
	EndSwitch
EndFunc
