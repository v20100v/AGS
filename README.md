autoit-gui-skeleton (AGS)
=========================

> AGS proposes to provide an architecture and an organization to efficiently build an AutoIt application with a graphical interface.

<br/>

## AGS's architecture overview

In order to organize the code of an AutoIT application with a graphical interface we use the following model.

```
root project
|
|   myApplication.au3          # Main entry program
|   myApplication_GLOBAL.au3   # All global variables declaration
|   myApplication_GUI.au3      # Main program to handle GUI
|   myApplication_LOGIC.au3    # Business code only
|   package.json               # Divert initial usage to describe the project with npm
|   README.md                  # Cause We always need it
|   
+---assets                     # All applications assets (images, files...)
|   +---css
|   +---html
|   +---images
|   \---javascript
|
+---vendor                     # All third-party code use in this project
|   \--- FolderVendor
|               
\---views                      # Views declaration
    View_About.au3
    View_Footer.au3
    View_Welcome.au3
```


### Directory `assets`

This folder contains all elements use in application like image, html, css, javascript, pdf, text file. Indeed we can also add html files in an ambedded browser in the GUI with `_IECreateEmbedded()` method provide by 'IE.au3' library.


### Directory `vendor`

The vendor directory is the conventional location for all third-party code in a project. In this exemple, we put in the library GUICtrlOnHover v2.0 created by G.Sandler a.k.a MrCreatoR.


### Directory `views`

This folder contains all handler view. All views code are defined in specifically dedicated files store in this folder.


<br/>

## Code organization  

> Explanation of code organization of a project respecting the AGS conventions. We descrive the main elements.

### Main entry program `myApplication.au3`

The main program is the entry point of a application. When the application is started, `_main_GUI()` is the first method called. We include all another script file in this main program. It acts as a single point of entry.

```AutoIt
;; `myApplication.au3` ;;

Opt('MustDeclareVars', 1)

; Include all built-in AutoIt library requires
#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIDlg.au3>

; Include all third-party code in a project store in vendor directory
#include 'vendor/GUICtrlOnHover/GUICtrlOnHover.au3'

; Include myApplication scripts
#include 'myApplication_CONSTANTS.au3'
#include 'myApplication_GUI.au3'
#include 'myApplication_LOGIC.au3'

; Start main graphic user interface defined in myApplication_GUI.au3
_main_GUI()
```


### Centralize the declaration of global variables

This script is used to define all application's constants and variables in global scope, except for graphic elements, which are defined in a specific view file. By convention all variables declared in `myApplication_GLOBALS.au3` must be declared in all uppercase with underscore separators.

You use `Global` to explicitly state which scope access is desired for a variable. If you declare a variable with the same name as a parameter, using Local inside a user function, an error will occur. Global can be used to assign to global variables inside a function, but if a local variable (or parameter) has the same name as a global variable, the local variable will be the only one used. It is recommended that local and global variables have distinct names.

You use `Global Const` to declare a constant. Once created a constant global, you cannot change the value of a constant. Also, you cannot change an existing variable into a constant.

```AutoIt
;; `myApplication_GLOBAL.au3` ;;
; Application main constants
Global Const $APP_NAME = "myApplication"
Global Const $APP_VERSION = "1.0.0"
Global Const $APP_WEBSITE = "https://myApplication-website.org"
Global Const $APP_EMAIL_CONTACT = "myApplication@website.org"
Global Const $APP_ID = "acme.myApplication"
Global Const $APP_LIFE_PERIOD = "2016-"&@YEAR
Global Const $APP_COPYRIGHT = "© "&$APP_LIFE_PERIOD&", A.C.M.E."

; Application GUI constants
Global Const $APP_WIDTH = 800
Global Const $APP_HEIGHT = 600
Global Const $APP_GUI_TITLE_COLOR = 0x85C4ED
Global Const $APP_GUI_LINK_COLOR = 0x5487FB

; Application global variable
; Example in order to persist an opened file on action "File > Open"
Global $OPEN_FILE = False
Global $OPEN_FILE_PATH = -1
Global $OPEN_FILE_NAME = -1
```


### Declare all business code in specifically dedicated files

In this template, we add a script `myApplication_LOGIC.au3` that contains all methods for business code. These logic methods are subsequently called by other methods triggered by user interactions defined in the GUI. Simple principle of separation between logic and view.

For example, we manage a dialog box in the following way :

```AutoIt
;; `myApplication_LOGIC.au3` ;;
;===========================================================================================================
; Show a dialog box to user, in order that he chooses a file in the Windows Explorer
;
; @params : void
; @return : $array_result[0] = file path
;           $array_result[1] = file name
;===========================================================================================================
Func _dialogbox_open()
   Local $info_fichier = _WinAPI_GetOpenFileName("Open file", "*.*", @WorkingDir, "", _
						  "", 2, BitOR($OFN_ALLOWMULTISELECT, $OFN_EXPLORER), _
              $OFN_EX_NOPLACESBAR)
   Local $array_result[2]

   If @error Then
	  $array_result[0] = -1
	  $array_result[1] = -1
   Else
	  ; Chemin relatif du nouveau fichier
	  $array_result[0] = $info_fichier[1]&"\"&$info_fichier[2] ; $PATHFILE_OF_OPEN_FILE_IN_APP
	  $array_result[1] = $info_fichier[2] ; $NAME_OF_OPEN_FILE_IN_APP
   EndIf

   Return $array_result
EndFunc
```


### Main program to handle GUI `myApplication_GUI.au3`

This script contains the `_main_GUI()` method call by the main entry program. This method is designed for create the Graphic User Interface definition (GUI) and handle all user interactions and events occured.

```AutoIt
;; myApplication_GUI.au3 ;;
#include-once

; Includes all views definition
#include './views/View_Footer.au3'
#include './views/View_Welcome.au3'
#include './views/View_About.au3'

;==============================================================================================================
; Main graphic user interface
;
; @param void
; @return void
;==============================================================================================================
Func _main_GUI()
   Global $main_GUI = GUICreate($APP_NAME, $APP_WIDTH, $APP_HEIGHT, -1, -1)

   _GUI_Init_Menu()

   _GUI_Init_Footer()       ; By default all elements of this view are visible
   _GUI_Init_View_Welcome() ; By default all elements of this view are hidden
   _GUI_Init_View_About()   ; By default all elements of this view are hidden

   ; Set configuration application : icon, background color
   _GUI_Configuration()

   ; Show Welcome view on startup
   _GUI_ShowHide_View_Welcome($GUI_SHOW)
   GUISetState(@SW_SHOW)

   ; Handle all user interactions and events
   _GUI_HandleEvents()

   GUIDelete()
   Exit
EndFunc

(...)
```

A few comments :

 - All uppercase variable (`$APP_NAME`, `$APP_WIDTH`, `$APP_HEIGHT`) are delcared in global scope in *myApplication_GLOBAL.au3* file ;
 - `_GUI_Init_Menu()`. It's used to create a menu control in main GUI ;
 - `_GUI_Init_Footer()`. It's used to create footer elements in main GUI. Its definition is done in a separate special file. All footer elements are visible in all views by default, so we don't need to handle its visibility ;
 - `_GUI_Init_View_Welcome()`. It's used to create GUI elements for a view name "Welcome". All elements declared in this method are hidden by default. To make visible "Welcome" view, i.e. to make them visible, simply call the method with this param `_GUI_ShowHide_View_Welcome($GUI_SHOW)`. And to make them hidden, simply call `_GUI_ShowHide_View_Welcome($GUI_HIDE)` ;
 - `_GUI_HandleEvents()`. It handles all user interactions and events by parsing return message with `GUIGetMsg()` method. The event return with GUIGetMsg method is the control ID of the control sending the message. This method call another specific handler events by view, like `_GUI_HandleEvents_View_Welcome($msg)` ;


### Declare all views code in specifically dedicated files

Create GUI elements for the 'Welcome' view with `_GUI_Init_View_Welcome()` method.

```AutoIt
;; ./view/View_Welcome.au3 ;;
Func _GUI_Init_View_Welcome()
   ; Create GUI elements here for "Welcome view" in global scope
   Global $label_title_View_Welcome = GUICtrlCreateLabel("Welcome", 20, 30, 400)
EndFunc
```

Handler for display element on 'Welcome' view in `_GUI_ShowHide_View_Welcome($action)` method.

```AutoIt
;; ./view/View_Welcome.au3 ;;
Func _GUI_ShowHide_View_Welcome($action)
   Switch $action
	  Case $GUI_SHOW
		 ; Define here all elements to show when user come into this view
		 _GUI_Hide_all_view() ; Hide all elements defined in all method _GUI_ShowHide_View_xxx
		 GUICtrlSetState($label_title_View_Welcome, $GUI_SHOW)
		 GUICtrlSetState($label_welcome, $GUI_SHOW)

	  Case $GUI_HIDE
		 ; Define here all elements to hide when user leave this view
		 GUICtrlSetState($label_title_View_Welcome, $GUI_HIDE)
		 GUICtrlSetState($label_welcome, $GUI_HIDE)
	EndSwitch
 EndFunc
```

Handler for events in 'Welcome' view in `_GUI_HandleEvents_View_Welcome($msg)` method. This method is called in main handler method ` _GUI_HandleEvents()`.

```AutoIt
;; ./view/View_Welcome.au3 ;;
Func _GUI_HandleEvents_View_Welcome($msg)
   Switch $msg

	  ; Trigger for click on $image_banner
	  Case $label_welcome
		 ConsoleWrite('Click on "$label_welcome"' & @CRLF)

	  ; Add another trigger in view 'Welcome' here
   EndSwitch
EndFunc
```


### Main handler events

The main handler `_GUI_HandleEvents()` called the handler events of each view. They are named by convention `_GUI_HandleEvents_View_Xxx($msg)`.

```AutoIt
;; myApplication_GUI.au3 ;;
;=========================;

Func _GUI_HandleEvents()
   Local $msg
   While 1
    ; event return with GUIGetMsg method, i.e. the control ID of the control sending the message
    $msg = GUIGetMsg()
	  Switch $msg
		 ; Trigger on close dialog box
		 Case $GUI_EVENT_CLOSE
			ExitLoop

		 ; Trigger on click on item menu 'File > Exit'
		 Case $menuitem_Exit
			ExitLoop
	  EndSwitch

	  _GUI_HandleEvents_View_Welcome($msg)
	  _GUI_HandleEvents_View_About($msg)
	  _GUI_HandleEvents_Menu_File($msg)
	  _GUI_HandleEvents_Menu_About($msg)
   WEnd
EndFunc
```

### Change view

In order to move from a starting view to another view of arrival, it is sufficient at first to hide all the graphic elements, then in a second time to display only those of the arrival view. So how to hide all the graphics elments ? Just with one method `_GUI_Hide_all_view()` wich will call the visibility manager of each view. They are named by convention `_GUI_ShowHide_View_Xxx`.

```AutoIt
;; myApplication_GUI.au3 ;;
;;-----------------------;;

Func _GUI_Hide_all_view()
   _GUI_ShowHide_View_Welcome($GUI_HIDE)
   _GUI_ShowHide_View_About($GUI_HIDE)
EndFunc
```

<br/>

## About

## Release History

 - AGS v1.0.0 - 2018.05.15

### Contributing
Pull requests and stars are always welcome ! For comments, bugs and feature requests, please create an issue.

### License

<pre>
   .-""-.       
  /[] _ _\
 _|_<span style="color:red;font-size:35px">&#8226;</span>LII|_     
/ | ====<span style="width:11px;height:10px;display: inline-block;">&nbsp;</span>| \
--------------------------------
</pre>
Copyright (c) 2018 by [v20100v](https://github.com/v20100v). Released under the [Apache license](https://github.com/v20100v/autoit-gui-skeleton/blob/master/LICENSE.md).
