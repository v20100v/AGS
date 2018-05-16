#include <GuiConstants.au3>
#include <StaticConstants.au3>

#include "GUICtrlOnHover.au3"

Global $aSquere = 0

$hGUI = GUICreate("Control Squere OnHover Example", 300, 200)

$Label1 = GUICtrlCreateLabel(" Label 1", 20, 40, -1, 13)
_GUICtrl_OnHoverRegister(-1, "_Hover_Proc", "_Hover_Proc")

$Label2 = GUICtrlCreateLabel(" Label 2", 20, 70, -1, 13)
_GUICtrl_OnHoverRegister(-1, "_Hover_Proc", "_Hover_Proc")

$List = GUICtrlCreateList("List", 120, 40, 120, 100)
_GUICtrl_OnHoverRegister(-1, "_Hover_Proc", "_Hover_Proc")

GUISetState(@SW_SHOW, $hGUI)

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func _Hover_Proc($iCtrlID, $iParam)
	Switch $iParam
		Case 1
			Local $aCtrlPos = ControlGetPos($hGUI, "", $iCtrlID)
			
			Switch $iCtrlID
				Case $Label1
					$aSquere = _GUICtrlCreateSquere($aCtrlPos[0], $aCtrlPos[1], $aCtrlPos[2], $aCtrlPos[3], 3, 0x0000FF)
				Case $Label2
					$aSquere = _GUICtrlCreateSquere($aCtrlPos[0], $aCtrlPos[1], $aCtrlPos[2], $aCtrlPos[3], 3, 0x00FF00)
				Case $List
					$aSquere = _GUICtrlCreateSquere($aCtrlPos[0], $aCtrlPos[1], $aCtrlPos[2], $aCtrlPos[3], 5, 0xFF0000)
			EndSwitch
		Case 2
			If Not IsArray($aSquere) Then Return
			
			For $i = $aSquere[1] To $aSquere[$aSquere[0]]
				GUICtrlDelete($i)
			Next
			
			$aSquere = 0
	EndSwitch
EndFunc

Func _GUICtrlCreateSquere($iLeft, $iTop, $iWidth, $iHeight, $iLineWidth=3, $sColor=0)
	Local $aControlIDArray[5]
	
	$aControlIDArray[0] = 4
	
	$aControlIDArray[1] = GUICtrlCreateLabel("", $iLeft, $iTop, $iWidth, $iLineWidth, $SS_SUNKEN)
	GUICtrlSetBkColor(-1, $sColor)
	
	$aControlIDArray[2] = GUICtrlCreateLabel("", $iLeft, $iTop, $iLineWidth, $iHeight, $SS_SUNKEN)
	GUICtrlSetBkColor(-1, $sColor)
	
	$aControlIDArray[3] = GUICtrlCreateLabel("", ($iLeft+$iWidth)-1, $iTop, $iLineWidth, $iHeight+2, $SS_SUNKEN)
	GUICtrlSetBkColor(-1, $sColor)
	
	$aControlIDArray[4] = GUICtrlCreateLabel("", $iLeft, ($iTop+$iHeight)-1, $iWidth+1, $iLineWidth, $SS_SUNKEN)
	GUICtrlSetBkColor(-1, $sColor)
	
	Return $aControlIDArray
EndFunc
