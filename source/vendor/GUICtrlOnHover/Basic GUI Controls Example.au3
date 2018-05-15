#include <GUIConstantsEx.au3>
#include "GUICtrlOnHover.au3"

GUICreate("GUICtrlSetOnHover GUI DEMO", 280, 200)

$Button = GUICtrlCreateButton("Button", 20, 40, 100, 20)
_GUICtrl_OnHoverRegister(-1, "_Hover_Func", "_Hover_Func")

$Label = GUICtrlCreateLabel("Label", 200, 40, 28, 15)
GUICtrlSetFont($Label, 8.5)
GUICtrlSetCursor($Label, 0)
_GUICtrl_OnHoverRegister($Label, "_Hover_Func", "_Hover_Func")

$CheckBox = GUICtrlCreateCheckbox("CheckBox", 20, 120)
_GUICtrl_OnHoverRegister($CheckBox, "_Hover_Func", "_Hover_Func")

$Edit = GUICtrlCreateEdit("Edit", 150, 120, 100, 50)
_GUICtrl_OnHoverRegister($Edit, "_Hover_Func", "_Hover_Func")

GUISetState()

While 1
	$Msg = GUIGetMsg()
	Switch $Msg
		Case -3
			Exit
	EndSwitch
WEnd

Func _Hover_Func($iCtrlID, $iParam)
	Local $sConsole_Data = "Hovered"
	
	Local $sButton_Text = "Hover Button"
	Local $iLabel_Color = 0x00000FF
	Local $iLabel_FontAttrib = 4
	Local $iCheckBox_State = $GUI_CHECKED
	Local $sEdit_Data = "New Edit Data"
	
	If $iParam = 2 Then ;Indicates On *Leave* Hover process
		$sConsole_Data = "NOT Hovered"
		
		$sButton_Text = "Button"
		$iLabel_Color = 0x000000
		$iLabel_FontAttrib = 0
		$iCheckBox_State = $GUI_UNCHECKED
		$sEdit_Data = "Edit Data"
	EndIf
	
	Printf("Control " & $iCtrlID & " [Data: " & GUICtrlRead($iCtrlID, 1) & "] Is Now " & $sConsole_Data)
	
	Switch $iCtrlID
		Case $Button
			If GUICtrlRead($iCtrlID) <> $sButton_Text Then GUICtrlSetData($iCtrlID, $sButton_Text)
		Case $Label
			GUICtrlSetColor($iCtrlID, $iLabel_Color)
			GUICtrlSetFont($iCtrlID, Default, Default, $iLabel_FontAttrib)
		Case $CheckBox
			GUICtrlSetState($iCtrlID, $iCheckBox_State)
		Case $Edit
			If GUICtrlRead($iCtrlID) <> $sEdit_Data Then GUICtrlSetData($iCtrlID, $sEdit_Data)
	EndSwitch
EndFunc

Func Printf($Str, $Line=@ScriptLineNumber)
	ConsoleWrite("!===========================================================" & @LF & _
				"+======================================================" & @LF & _
				"--> Script Line (" & $Line & "):" & @LF & "!" & @TAB & $Str & @LF & _
				"+======================================================" & @LF)
EndFunc
