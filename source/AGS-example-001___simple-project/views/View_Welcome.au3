#cs ----------------------------------------------------------------------------
GUI View Welcome handler

AutoIt Version : 3.3.14.5
Author         : v20100v <7567933+v20100v@users.noreply.github.com>
Package        : autoit-gui-skeleton
Version        : 1.0
#ce ----------------------------------------------------------------------------


#include-once


;==============================================================================================================
; Create element for the 'Welcome' view
;
; @param void
; @return void
;==============================================================================================================
Func _GUI_Init_View_Welcome()
   ; GUI elements have to register in global scope
   GUISetFont(20, 800, 0, "Arial Narrow")
   Global $label_title_View_Welcome = GUICtrlCreateLabel("Welcome", 20, 30, 400)
   GUICtrlSetColor($label_title_View_Welcome, $APP_GUI_TITLE_COLOR)
   GUICtrlSetBkColor($label_title_View_Welcome, $GUI_BKCOLOR_TRANSPARENT)

   GUISetFont(10, 400, 0, "Segoe UI")
   Global $label_welcome = GUICtrlCreateLabel( _
	  "On startup " & $APP_NAME & ", we show this Welcome view. " & _
	  "We add an event click on this label in order to show how to define " & @CRLF & _
	  "a trigger on a view." _
	  , 20, 80)
   GUICtrlSetCursor($label_welcome, 0)
EndFunc


;==============================================================================================================
; Handler for display element on 'Welcome' view
;
; @param {int} $action, use GUIConstantsEx $GUI_SHOW or $GUI_HIDE
; @return void
;==============================================================================================================
Func _GUI_ShowHide_View_Welcome($action)
   Switch $action
	  Case $GUI_SHOW
		 ; Define here all elements to show when user come into this view
		 _GUI_Hide_all_view()
		 GUICtrlSetState($label_title_View_Welcome, $GUI_SHOW)
		 GUICtrlSetState($label_welcome, $GUI_SHOW)

	  Case $GUI_HIDE
		 ; Define here all elements to hide when user leave this view
		 GUICtrlSetState($label_title_View_Welcome, $GUI_HIDE)
		 GUICtrlSetState($label_welcome, $GUI_HIDE)
	EndSwitch
 EndFunc


;==============================================================================================================
; Handler for events in 'Welcome' view
;
; @param $msg, event return with GUIGetMsg method, i.e. the control ID of the control sending the message
; @return @void
;==============================================================================================================
Func _GUI_HandleEvents_View_Welcome($msg)
   Switch $msg

	  ; Trigger for click on $image_banner
	  Case $label_welcome
		 ConsoleWrite('Click on "$label_welcome"' & @CRLF)

	  ; Add another trigger in view 'Welcome' here
   EndSwitch
EndFunc