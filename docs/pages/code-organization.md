---
layout: page
title: Code organization
permalink: /documentation/code-organization
feature-img: "assets/img/documentation/computer.jpeg"
tags: [Documentation]
---

<!-- Breadcrumb navigation -->
<nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="{{ site.url }}{{ site.baseurl }}/">Home</a></li>
    <li class="breadcrumb-item"><a href="documentation">Documentation</a></li>
    <li class="breadcrumb-item active" aria-current="page">Code organization</li>
  </ol>
</nav>

<!-- To be placed at the beginning of the post, it is where the table of content will be generated -->
* TOC
{:toc}



# Organization

You should read this before continuing : [Getting started with AGS](documentation/getting-started).

In order to organize the code of an AutoIT application with a graphical interface, AGS propose to use conventions and a following model to develop and build AutoIt application with an graphic user interface (GUI). This article explains the organization of the code of a project respecting the AGS conventions. We describe below its main elements.

![Overview of AGS architecture]({{ "assets/img/documentation/autoit-gui-skeleton_overview.png" | absolute_url }}){:class="img-fancybox img-full"}


## Main entry program

The `myApplication.au3` program serves as a single point of entry for our application. This is the location where the application starts. In the latter we start by including all the other dependencies that it needs: libraries of AutoIt, third-party libraries, the declaration of global variables, the code of the application GUI and business. It calls a single method: _main_GUI (). It is the main GUI manager that is used to build the interface and manage user interactions.

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

## Centralize the declaration of global variables

This script is used to define all the constants and variables of the application in the overall scope of the program, with the exception of graphic elements, which are defined in a specific view file. Moreover by convention, all the variables declared in myApplication_GLOBALS.au3 must be written in capital letters and separated by underscores.

The Global statement is used to explicitly indicate which access to the scope is desired for a variable. If you declare a variable with the same name as a parameter, using Local in a user function, an error will occur. Global can be used to assign global variables within a function, but if a local variable (or parameter) has the same name as a global variable, the local variable will be the only one used. It is recommended that local and global variables have distinct names.

The statement Global Const is used to declare a constant. Once created a global constant, you can not change the value of a constant. In addition, you can not replace an existing variable with a constant.

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

<br/>

> **Relating reading**
>
>  Previous step with reading <a href="documentation/getting-started">Getting started with ags</a>. 
