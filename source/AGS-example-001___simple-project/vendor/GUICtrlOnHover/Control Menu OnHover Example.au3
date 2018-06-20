#include <GuiConstants.au3>
#include "GUICtrlOnHover.au3"

Global $iShowMenu = False
Global $hHover_CtrlID = 0

$hGUI = GUICreate("Control Menu OnHover Example",500,400)

$Button = GUICtrlCreateButton("Button", 100, 100, 50, 50)
_GUICtrl_OnHoverRegister(-1, "_ShowMenu_Proc", "_ShowMenu_Proc")

$Label = GUICtrlCreateLabel("Label", 300, 100, -1, 15)
_GUICtrl_OnHoverRegister(-1, "_ShowMenu_Proc", "_ShowMenu_Proc")

GUISetState(@SW_SHOW, $hGUI)

$Dummy_Ctrl = GUICtrlCreateDummy()
$Dummy_Label = GUICtrlCreateLabel("", -100, -100)

$Context_Menu = GUICtrlCreateContextMenu($Dummy_Ctrl)

$Some_CMItem = GUICtrlCreateMenuItem("Some Item", $Context_Menu)
$Exit_CMItem = GUICtrlCreateMenuItem("Exit", $Context_Menu)

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
		Case $GUI_EVENT_CLOSE, $Exit_CMItem
			ExitLoop
	EndSwitch
	
	If $iShowMenu Then
		$iShowMenu = False
		_GUICtrlShowMenu($hGUI, $Context_Menu, $hHover_CtrlID)
	EndIf
WEnd

Func _ShowMenu_Proc($iCtrlID, $iHoverMode, $hWnd_Hovered)
	$hHover_CtrlID = $iCtrlID
	
	Switch $iHoverMode
		Case 1 ;Hover proc
			$iShowMenu = True
		Case 2 ;Leave hover proc
			If $hWnd_Hovered = $hGUI Then ControlClick($hGUI, "", $Dummy_Label)
	EndSwitch
EndFunc

; Show a menu in a given GUI window which belongs to a given GUI ctrl
Func _GUICtrlShowMenu($hWnd, $nContextID, $nContextControlID, $iMouse=0)
	Local $hMenu = GUICtrlGetHandle($nContextID)
    Local $iCtrlPos = ControlGetPos($hWnd, "", $nContextControlID)
	
	Local $iX = $iCtrlPos[0]
	Local $iY = $iCtrlPos[1] + $iCtrlPos[3]
	
	; Convert the client (GUI) coordinates to screen (desktop) coordinates
	;ClientToScreen
	Local $stPoint = DllStructCreate("int;int")
    
    DllStructSetData($stPoint, 1, $iX)
    DllStructSetData($stPoint, 2, $iY)

    DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))
    
    $iX = DllStructGetData($stPoint, 1)
    $iY = DllStructGetData($stPoint, 2)
	;ClientToScreen
	
	If $iMouse Then
		$iX = MouseGetPos(0)
		$iY = MouseGetPos(1)
	EndIf
	
	DllCall("user32.dll", "int", "TrackPopupMenuEx", "hwnd", $hMenu, "int", 0, "int", $iX, "int", $iY, "hwnd", $hWnd, "ptr", 0)
EndFunc
