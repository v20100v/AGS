<!-- Breadcrumb navigation -->
<nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="{{ site.url }}{{ site.baseurl }}/">Entrée</a></li>
    <li class="breadcrumb-item"><a href="{{ site.url }}{{ site.baseurl }}/documentation">Documentation</a></li>
    <li class="breadcrumb-item active" aria-current="page">Organisation du code</li>
  </ol>
</nav>

<!-- To be placed at the beginning of the post, it is where the table of content will be generated -->
* TOC
{:toc}

Vous devriez lire ceci au préalable : [Démarrer avec AGS](documentation/getting-started).


# Organisation du code

Pour organiser le code d'une application AuotIt avec une interface graphique, AGS propose d'utiliser des conventions et le modèle suivant. Cet article explique plus en détails l'organisation du code d'un projet respectant les conventiosn AGS. Nous décrivons ci-dessous ses principaux éléments.

![Overview of AGS architecture]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/autoit-gui-skeleton_overview.png){:class="img-fancybox img-full"}


## Programme d'entrée principal

Le programme `myApplication.au3` nous sert de point d'entrée unique de notre application. C'est lui qui démarre l'application. Dans ce dernier on commence par inclure toutes les autres dependances qu'il a besoin : librairies d'AutoIt, librairies tierces, la déclaration des variables globales, le code de l'application GUI et métier.

Il appelle la méthode _main_GUI()`, le gestionnaire principale de l'interface graphique qui va construire l'interface graphique et gérer les interactions des utilisateurs et les évenements de l'application.

```autoit
;; myApplication.au3 ;;

Opt('MustDeclareVars', 1)

; Include all built-in AutoIt library requires
#include <IE.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIDlg.au3>

; Include all third-party code in a project store in vendor directory
#include 'vendor/GUICtrlOnHover/GUICtrlOnHover.au3'

; Include myApplication scripts
#include 'myApplication_GLOBAL.au3'
#include 'myApplication_GUI.au3'
#include 'myApplication_LOGIC.au3'

; Start main graphic user interface defined in myApplication_GUI.au3
_main_GUI()
```


## Centraliser la déclaration des variables globales

Ce script est utilisé pour définir toutes les constantes et variables de l'application dans la portée globale du programme, à l'exception des éléments graphiques, qui eux sont définis dans un fichier de vue spécifique. De plus par convention, toutes les variables déclarées dans `myApplication_GLOBALS.au3` doivent être écrites en majuscules et séparés par des underscores.

On utilise la déclaration `Global` pour indiquer explicitement quel accès à la portée est souhaité pour une variable. Si vous déclarez une variable avec le même nom qu'un paramètre, en utilisant Local dans une fonction utilisateur, une erreur se produira. Global peut être utilisé pour affecter des variables globales à l'intérieur d'une fonction, mais si une variable locale (ou un paramètre) a le même nom qu'une variable globale, la variable locale sera la seule utilisée. Il est recommandé que les variables locales et globales aient des noms distincts.

On utilise la déclaration `Global Const` pour déclarer une constante. Une fois créée une constante globale, vous ne pouvez pas changer la valeur d'une constante. En outre, vous ne pouvez pas remplacer une variable existante par une constante.

```autoit
;; myApplication_GLOBAL.au3 ;;

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


## Ecrire le code métier dans des fichiers spécifiquement dédiés

Dans cet organisation, le code métier est décrit dans des fichiers spécifiquement dédiés.

Par exemple nous ajoutons un fichier `myApplication_LOGIC.au3` qui contient toutes les méthodes du code métier. Ces méthodes logiques sont ensuite appelées par d'autres généralement déclenchées par des interactions utilisateur, dont les liens sont définies dans l'interface graphique. Principe simple de séparation entre logique et vue. Nous gérons une boîte de dialogue de la façon suivante:

```autoit
;; myApplication_LOGIC.au3 ;;

;====================================================================================
; Show a dialog box to user, in order that he chooses a file in the Windows Explorer
;
; @params : void
; @return : $array_result[0] = file path
;           $array_result[1] = file name
;====================================================================================
Func _dialogbox_open()
   Local $info_fichier = _WinAPI_GetOpenFileName("Open file", "*.*", _ 
                         @WorkingDir, "", "", 2, _ 
                         BitOR($OFN_ALLOWMULTISELECT, $OFN_EXPLORER), _
                         $OFN_EX_NOPLACESBAR)
                         
   Local $array_result[2]

   If @error Then
      $array_result[0] = -1
      $array_result[1] = -1
   Else
      
      ; $PATHFILE_OF_OPEN_FILE_IN_APP
      $array_result[0] = $info_fichier[1]&"\"&$info_fichier[2] 
      
      ; $NAME_OF_OPEN_FILE_IN_APP
      $array_result[1] = $info_fichier[2] 
   EndIf

   Return $array_result
EndFunc
```


## Création d'une interface graphique

### Programme principal pour gérer l'interface graphique

Le fichier `myApplication_GUI.au3` contient la méthode `_main_GUI()` qui est appelé par le programme d'entrée principal. Cette méthode est conçue pour créer l'interface utilisateur graphique (GUI) et gérer toutes les interactions et tous les événements de l'utilisateur. Ainsi elle appelle toutes les autres méthodes qui initialise les éléments de l'interface graphique.

```autoit
;; myApplication_GUI.au3 ;;

#include-once

; Includes all views definition
#include './views/View_Footer.au3'
#include './views/View_Welcome.au3'
#include './views/View_About.au3'

;====================================================================================
; Main graphic user interface
;
; @param void
; @return void
;====================================================================================
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

<br/>

Quelques commentaires:

- Toutes les variables majuscules (`$ APP_NAME`,` $ APP_WIDTH`, `$ APP_HEIGHT`) sont déclarées dans la portée globale de l'application. Leur définition se fait dans le fichier `myApplication_GLOBAL.au3`;
- `_GUI_Init_Menu()` est utilisé pour créer un contrôle de menu dans l'interface graphique principale;
- `_GUI_Init_Footer()` est utilisé pour créer des éléments de pied de page dans l'interface graphique principale. Sa définition est faite dans un fichier spécial séparé. Tous les éléments de pied de page sont visibles dans toutes les vues par défaut, nous n'avons donc pas besoin de gérer sa visibilité.
- `_GUI_Init_View_Welcome()` est utilisé pour créer des éléments GUI pour un nom de vue "Welcome". Tous les éléments déclarés dans cette méthode sont masqués par défaut. Pour afficher la vue "Welcome", c'est-à-dire pour la rendre visible, appelez simplement la méthode avec ce paramètre `_GUI_ShowHide_View_Welcome($ GUI_SHOW)`. Et pour les cacher, appelez simplement `_GUI_ShowHide_View_Welcome($ GUI_HIDE)`;
- `_GUI_HandleEvents()` gère toutes les interactions et les événements utilisateur en analysant le message de retour avec la méthode `GUIGetMsg()`. Le retour d'événement avec la méthode GUIGetMsg est l'ID de contrôle du contrôle qui envoie le message. Cette méthode appelle un autre événement de gestionnaire spécifique par vue, par exemple `_GUI_HandleEvents_View_Welcome($msg)`;


### Déclarez le code de toutes les vues dans des fichiers spécifiquement dédiés

Chaque vue est gérée dans un fichier spécifique.

Par exemple pour la gestion de la création des éléments graphique de la vue "Welcome", on utilise la méthode `_GUI_Init_View_Welcome()`.

```autoit
;; ./view/View_Welcome.au3 ;;

Func _GUI_Init_View_Welcome()
   ; Create GUI elements here for "Welcome view" in global scope
   Global $label_title_View_Welcome = GUICtrlCreateLabel("Welcome", 20, 30, 400)
EndFunc
```

Pour la gestion de l'affichage des éléments de la vue "Welcome", on utilise la méthode `_GUI_ShowHide_View_Welcome($action)`

```autoit
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

Et pour la gestion des événements dans la vue "Welcome", on utilise la méthode `_GUI_HandleEvents_View_Welcome($msg)`. Cette méthode est appelée dans la méthode du gestionnaire principal `_GUI_HandleEvents()`.

```autoit
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


### Gestionnaire principal des événements

Le gestionnaire principal des événements utilisateurs et dans l'application se nomme `_GUI_HandleEvents()`. C'est ce dernier qui va appelé tous les autres gestionnaires d'événement spécifique à chaque vue. Ils sont nommés par convention `_GUI_HandleEvents_View_Xxx($msg)`.

```autoit
;; myApplication_GUI.au3 ;;

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


### Changer de vue

Pour passer d'une vue de départ à une autre vue d'arrivée, il suffit d'abord de masquer tous les éléments graphiques, puis dans un second temps d'afficher uniquement ceux de la vue d'arrivée. Alors, comment cacher tous les éléments graphiques? Juste avec une méthode `_GUI_Hide_all_view()` qui va appelle le gestionnaire de visibilité de chaque vue. Ces derniers sont nommés par convention `_GUI_ShowHide_View_Xxx`.

```autoit
;; myApplication_GUI.au3 ;;

Func _GUI_Hide_all_view()
   _GUI_ShowHide_View_Welcome($GUI_HIDE)
   _GUI_ShowHide_View_About($GUI_HIDE)
EndFunc
```

### Exemple d'une IHM

![AGS GUI example]({{ site.url }}{{ site.baseurl_root }}/assets/img/documentation/AGS-gui-example.gif){:class="img-full img-fancybox"}



<br/>

> **Lecture associée**
>
> <a href="{{ site.url }}{{ site.baseurl }}/documentation/getting-started">Démarrer avec AGS</a><br/>
> <a href="{{ site.url }}{{ site.baseurl }}/documentation/creating-setup-package-autoit-application">Création d'installeur - setup Windows - pour des applications AuotIt</a>
