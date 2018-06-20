#cs ----------------------------------------------------------------------------
GUI Footer handler

AutoIt Version : 3.3.14.5
Author         : v20100v <7567933+v20100v@users.noreply.github.com>
Package        : autoit-gui-skeleton
Version        : 1.0
#ce ----------------------------------------------------------------------------


#include-once


;==============================================================================================================
; Create footer element
;
; These elements are always display in each view, so we don't need to add '_GUI_ShowHide_Footer' method.
;
; @param void
; @return void
;==============================================================================================================
Func _GUI_Init_Footer()
   GUISetFont(8, 400, 0, "Segoe UI")
   Global $label_copyright = GUICtrlCreateLabel($APP_COPYRIGHT, 5, $APP_HEIGHT-38)
   Global $label_version_application = GUICtrlCreateLabel("v"&$APP_VERSION, $APP_WIDTH-StringLen("v"&$APP_VERSION)*5, $APP_HEIGHT-38)
   Global $img_trait = GuiCtrlCreatePic("./assets/images/line.jpg", 0, $APP_HEIGHT-45, 800, 2)
   GUISetFont(10, 400, 0, "Segoe UI")
EndFunc