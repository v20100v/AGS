#cs ----------------------------------------------------------------------------
GUI View About handler

AutoIt Version : 3.3.14.5
Author         : v20100v <7567933+v20100v@users.noreply.github.com>
Package        : autoit-gui-skeleton
Version        : 1.0
#ce ----------------------------------------------------------------------------


#include-once


;==============================================================================================================
; Create element for the 'About' view
;
; @param void
; @return void
;==============================================================================================================
Func _GUI_Init_View_About()
   Local $h = 20
   GUISetFont(10, 400, 0, "Segoe UI")
   Global $label_about_team = GUICtrlCreateLabel("Team", 20, $h)
   Global $label_about_requirements = GUICtrlCreateLabel("Requirements", 20, $h+30)
   Global $label_about_license = GUICtrlCreateLabel("License", 20, $h+60)
   Global $label_about_releases = GUICtrlCreateLabel("Releases", 20, $h+90)
   Global $label_about_contact = GUICtrlCreateLabel("Contact", 20, $h+130)
   Global $label_about_website = GUICtrlCreateLabel("Website", 20, $h+160)
   Global $about_horizontal_line = GuiCtrlCreatePic("./assets/images/line.jpg", 15, $h+120, 110, 1)
   Global $about_vertical_line = GuiCtrlCreatePic("./assets/images/line.jpg", 130, 20, 1, $APP_HEIGHT - 50)

   GUICtrlSetColor($label_about_team, $APP_GUI_LINK_COLOR)
   GUICtrlSetColor($label_about_requirements, $APP_GUI_LINK_COLOR)
   GUICtrlSetColor($label_about_license, $APP_GUI_LINK_COLOR)
   GUICtrlSetColor($label_about_releases, $APP_GUI_LINK_COLOR)
   GUICtrlSetColor($label_about_contact, $APP_GUI_LINK_COLOR)
   GUICtrlSetColor($label_about_website, $APP_GUI_LINK_COLOR)

   GUICtrlSetCursor($label_about_team, 0)
   GUICtrlSetCursor($label_about_requirements, 0)
   GUICtrlSetCursor($label_about_license, 0)
   GUICtrlSetCursor($label_about_releases, 0)
   GUICtrlSetCursor($label_about_contact, 0)
   GUICtrlSetCursor($label_about_website, 0)

   _IEErrorHandlerRegister()
   Global $IE_Embedded_About = _IECreateEmbedded()
   Global $control_IE_Embedded_About = GUICtrlCreateObj($IE_Embedded_About, 140, 0, $APP_WIDTH-140, $APP_HEIGHT-50)

   ; Hide all elements by default
   _GUI_ShowHide_View_About($GUI_HIDE)
EndFunc


;==============================================================================================================
; Handler for display element on 'About' view
;
; @param {int} $action, use GUIConstantsEx $GUI_SHOW or $GUI_HIDE
; @return void
;==============================================================================================================
Func _GUI_ShowHide_View_About($action)
   Switch $action
	  Case $GUI_SHOW
		 _GUI_Hide_all_view()
		 ; Define here all elements to show when user come into this view
		 GUICtrlSetState($label_about_team, $GUI_SHOW)
		 GUICtrlSetState($label_about_requirements, $GUI_SHOW)
		 GUICtrlSetState($label_about_license, $GUI_SHOW)
		 GUICtrlSetState($label_about_releases, $GUI_SHOW)
		 GUICtrlSetState($label_about_contact, $GUI_SHOW)
		 GUICtrlSetState($label_about_website, $GUI_SHOW)
		 GUICtrlSetState($control_IE_Embedded_About, $GUI_SHOW)
		 GUICtrlSetState($about_horizontal_line, $GUI_SHOW)
		 GUICtrlSetState($about_vertical_line, $GUI_SHOW)

	  Case $GUI_HIDE
		 ; Define here all elements to hide when user leave this view
		 GUICtrlSetState($label_about_team, $GUI_HIDE)
		 GUICtrlSetState($label_about_requirements, $GUI_HIDE)
		 GUICtrlSetState($label_about_license, $GUI_HIDE)
		 GUICtrlSetState($label_about_releases, $GUI_HIDE)
		 GUICtrlSetState($label_about_contact, $GUI_HIDE)
		 GUICtrlSetState($label_about_website, $GUI_HIDE)
		 GUICtrlSetState($control_IE_Embedded_About, $GUI_HIDE)
		 GUICtrlSetState($about_horizontal_line, $GUI_HIDE)
		 GUICtrlSetState($about_vertical_line, $GUI_HIDE)
	EndSwitch
 EndFunc


;==============================================================================================================
; Navigate to given page in IE embedded
;
; @param {string}, name page to show in IE embedded
; @return void
;==============================================================================================================
Func _GUI_IENavigate_Embedded_About($page)
   Switch $page
   Case "TEAM"
	  _IENavigate ($IE_Embedded_About, @ScriptDir&"\assets\html\team.html")
   Case "REQUIREMENTS"
	  _IENavigate ($IE_Embedded_About, @ScriptDir&"\assets\html\requirements.html")
   Case "LICENSE"
	  _IENavigate ($IE_Embedded_About, @ScriptDir&"\assets\html\license.html")
   Case "RELEASES"
	  _IENavigate ($IE_Embedded_About, @ScriptDir&"\assets\html\releases.html")
   EndSwitch
EndFunc


;==============================================================================================================
; Handler for events in 'Welcome' view
;
; @param $msg, event return with GUIGetMsg method, i.e. the control ID of the control sending the message
; @return @void
;==============================================================================================================
Func _GUI_HandleEvents_View_About($msg)
   Switch $msg
	  Case $label_about_team
		 ConsoleWrite('Click on "$label_about_team"' & @CRLF)
		 _GUI_IENavigate_Embedded_About('TEAM')
	  Case $label_about_requirements
		 ConsoleWrite('Click on "$label_about_requirements"' & @CRLF)
		 _GUI_IENavigate_Embedded_About('REQUIREMENTS')
	  Case $label_about_license
		 ConsoleWrite('Click on "$label_about_license"' & @CRLF)
		 _GUI_IENavigate_Embedded_About('LICENSE')
	  Case $label_about_releases
		 ConsoleWrite('Click on "$label_about_releases"' & @CRLF)
		 _GUI_IENavigate_Embedded_About('RELEASES')
	  Case $label_about_contact
		 ConsoleWrite('Click on "$label_about_contact"' & @CRLF)
		 ShellExecute("mailto:"&$APP_EMAIL_CONTACT&"?subject=["&$APP_NAME&" - v"&$APP_VERSION&"] I need informations...&cc=20100@acme.org")
	  Case $label_about_website
		 ConsoleWrite('Click on "$label_about_website"' & @CRLF)
		 ShellExecute($APP_WEBSITE)
   EndSwitch
EndFunc