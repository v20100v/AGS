#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

#include "GUICtrlOnHover.au3"

Global $sBack_Normal_Image = @Systemdir & "\oobe\images\backup.jpg"
Global $sBack_Hover_Image = @Systemdir & "\oobe\images\backover.jpg"
Global $sNext_Normal_Image = @Systemdir & "\oobe\images\nextup.jpg"
Global $sNext_Hover_Image = @Systemdir & "\oobe\images\nextover.jpg"
Global $sSkip_Normal_Image = @Systemdir & "\oobe\images\skipup.jpg"
Global $sSkip_Hover_Image = @Systemdir & "\oobe\images\skipover.jpg"
Global $sQuestion_Normal_Image = @Systemdir & "\oobe\images\qmark.gif"
Global $sQuestion_Hover_Image = @Systemdir & "\oobe\images\redshd.gif"

$Gui = GUICreate("Arrows Example", 280, 200)

$Back_Pic = GUICtrlCreatePic($sBack_Normal_Image, 80, 10, 32, 32)
_GUICtrl_OnHoverRegister(-1, "_Hover_Image_Proc", "_Hover_Image_Proc")

$Skip_Pic = GUICtrlCreatePic($sSkip_Normal_Image, 125, 10, 32, 32)
_GUICtrl_OnHoverRegister(-1, "_Hover_Image_Proc", "_Hover_Image_Proc")

$Next_Pic = GUICtrlCreatePic($sNext_Normal_Image, 170, 10, 32, 32)
_GUICtrl_OnHoverRegister(-1, "_Hover_Image_Proc", "_Hover_Image_Proc")

$Question_Pic = GUICtrlCreatePic($sQuestion_Normal_Image, 115, 100, 52, 52, -1, $WS_EX_TRANSPARENT)
_GUICtrl_OnHoverRegister(-1, "_Hover_Image_Proc", "_Hover_Image_Proc")

GUISetState()

While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func _Hover_Image_Proc($iCtrlID, $iParam)
	Local $sPic_Back = $sBack_Hover_Image
	Local $sPic_Next = $sNext_Hover_Image
	Local $sPic_Skip = $sSkip_Hover_Image
	Local $sPic_Question = $sQuestion_Hover_Image
	
	If $iParam = 2 Then
		$sPic_Back = $sBack_Normal_Image
		$sPic_Next = $sNext_Normal_Image
		$sPic_Skip = $sSkip_Normal_Image
		$sPic_Question = $sQuestion_Normal_Image
	EndIf
	
	Switch $iCtrlID
		Case $Back_Pic
			GUICtrlSetImage($iCtrlID, $sPic_Back)
		Case $Next_Pic
			GUICtrlSetImage($iCtrlID, $sPic_Next)
		Case $Skip_Pic
			GUICtrlSetImage($iCtrlID, $sPic_Skip)
		Case $Question_Pic
			GUICtrlSetImage($iCtrlID, $sPic_Question)
	EndSwitch
EndFunc
