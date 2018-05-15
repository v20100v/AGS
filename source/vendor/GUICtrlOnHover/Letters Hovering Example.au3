#include "GUICtrlOnHover.au3"

Opt("GUIOnEventMode", 1)

Global $aButtons[26]

$Btn_Color = 0x7A9DD8
$Hover_Color = 0xFF0000 ;0x7AC5D8

Global $GUIMain = GUICreate("Letters Hovering Example", 570, 200)
GUISetOnEvent(-3, "Quit")

_CreateLetters_Proc(10, 60, 18, 20)

GUICtrlCreateButton("Close", 30, 120, 100, 30)
GUICtrlSetOnEvent(-1, "Quit")

GUICtrlSetFont(GUICtrlCreateLabel("Letter: ", 35, 170, 200, 20), 9, 800)
$Status_Label = GUICtrlCreateLabel("", 80, 171, 200, 20)
GUICtrlSetColor(-1, 0xFF0000)
GUICtrlSetFont(-1, 8.5, 800)

GUISetState()

While 1
    Sleep(100)
WEnd

Func _CreateLetters_Proc($iLeft, $Top, $Width=15, $Height=15)
	Local $iLeft_Begin = $iLeft
	Local $iAsc_Char = 64
	
	For $i = 0 To 25
		$iLeft_Begin += 20
		$iAsc_Char += 1
		
		$aButtons[$i] = GUICtrlCreateButton(Chr($iAsc_Char), $iLeft_Begin, $Top, $Width, $Height)
		_GUICtrl_OnHoverRegister($aButtons[$i], "_Hover_Func", "_Leave_Hover_Func")
		GUICtrlSetOnEvent($aButtons[$i], "_Letter_Events")
		GUICtrlSetBkColor($aButtons[$i], $Btn_Color)
		GUICtrlSetFont($aButtons[$i], 6)
	Next
EndFunc

Func _Letter_Events()
	MsgBox(64, "Pressed", "Letter = " & GUICtrlRead(@GUI_CtrlId))
EndFunc

Func _Hover_Func($iCtrlID)
	GUICtrlSetBkColor($iCtrlID, $Hover_Color)
	GUICtrlSetData($Status_Label, GUICtrlRead($iCtrlID))
	Beep(1000, 20)
EndFunc

Func _Leave_Hover_Func($iCtrlID)
	GUICtrlSetBkColor($iCtrlID, $Btn_Color)
	GUICtrlSetData($Status_Label, "")
EndFunc

Func Quit()
    Exit
EndFunc
