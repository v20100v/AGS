---
layout: page
title: Getting started with AGS
permalink: /documentation/getting-started
feature-img: "assets/img/documentation/hand-3285912_1920.jpg"
tags: [Documentation, AGS]
---


<!-- Breadcrumb navigation -->
<nav aria-label="breadcrumb">
  <ol class="breadcrumb">
    <li class="breadcrumb-item"><a href="{{ site.url }}{{ site.baseurl }}/">Home</a></li>
    <li class="breadcrumb-item"><a href="documentation">Documentation</a></li>
    <li class="breadcrumb-item active" aria-current="page">Getting started</li>
  </ol>
</nav>


<!-- To be placed at the beginning of the post, it is where the table of content will be generated -->
* TOC
{:toc}


# What is AGS ?

AutoIt Gui Skeleton (AGS) give an environment for developers, that makes it easy to build AutoIt applications. 

In order to organize the code of an AutoIT application with a graphical interface, AGS propose to use conventions and a following model to develop and build AutoIt application with an graphic user interface (GUI).


# Architecture of an AGS project

An AGS project respects the following organization for its files and directories.

```
project root folder
|
|   myApplication.au3          # Main entry program
|   myApplication_GLOBAL.au3   # Centralized global variables declaration
|   myApplication_GUI.au3      # Main GUI handler
|   myApplication_LOGIC.au3    # Logic/Business code only
|   README.md                  # Cause We always need it
|  
+---assets                     # All applications assets
|   +---html
|   +---images
|   \---pdf
|
+---deployment                
|   \---releases               # Contains releases setup (zip and Windows setup files)
|   deployment.bat             # The orquestrator to pilot Windows setup creation
|   deploymeny.iss             # InnoSetup script use to generate Windows setup
|
+---vendor                     # All third-party code use in this project
|   \--- FolderVendor
|              
\---views                      # Views declaration
    View_About.au3
    View_Footer.au3
    View_Welcome.au3
```

## Directories and files of AutoIt project 

We organize the files of an AutoIt project in specific directories.

### Directory `assets`

This directory contains the elements used in the application like images, text files, pdf, html, css, javascript. Indeed, note that it is possible to integrate in a AutoIt application, a static html file, into a web browser embedded in the HMI with the `_IECreateEmbedded ()` method provided by the `IE.au3` library.


### Directory `deployment`

This directory contains a Windows batch that controls the creation of a Windows installer with the [InnoSetup](http://www.jrsoftware.org/isinfo.php) solution. To run the batch, it is necessary that the InnoSetup compiler and 7zip be installed on the pc. If this is not the case, I advise you to use the Windows package manager [Chocolatey](https://chocolatey.org/) to install them simply:

```
C: \> choco install 7zip
C: \> choco install innosetup
```


### Directory `vendor`

This directory is the place where to conventionally store the code developed by third parties in a project. In this project (https://github.com/v20100v/autoit-gui-skeleton), we have for example put the GUICtrlOnHover v2.0 library created by G.Sandler a.k.a MrCreatoR in this directory.


### Directory `views`

This directory contains view managers. All the code of all the views are defined each time in a specific file and stored in that directory.



## Overview of AGS architecture

![Overview of AGS architecture]({{ "assets/img/documentation/autoit-gui-skeleton_overview.png" | absolute_url }}){:class="img-fancybox img-full"}


### Main entry program

The main entry program serves as a single point of entre for AutoIt application. This is the location where the application starts. In the latter we start by including all the other dependencies that it needs: libraries of AutoIt, third-party libraries, the declaration of global variables, the code of the application GUI and business. 

It starts application with the main handler GUI `_main_GUI()`.


### Main handler GUI

The main handler GUI contains the `_main_GUI()` method which is only called by the main entry program. This method is designed to create the graphical user interface (GUI) and manage all user interactions and events. 


### Centralize declaration of variables in global scope

All constants and global variables are set in one place, in `myProject_GLOBALS.au3`. With the exception of all global variables of graphic elements which are set in each specific view file. It is recalled that constants can no longer change their value over time, unlike global variables.

By convention, all the global variables must be written in capital letter and separated by underscore. For example : `Global Const $APP_EMAIL_CONTACT`


### Package and setup deployment

In order to facilitate the deployment of a Windows desktop application develop with AutoIt. We propose to provide an automated process to build a Windows installer with the [InnoSetup](http://www.jrsoftware.org/isinfo.php) solution.

For generate a Windows application installer, we need a preparation whose main steps are:

- Assign a version number to the application;
- Compile the application, i.e. compile the main entry point `myProject.au3` with `aut2exe` compiler;
- Copy the assets (images, files ...) necessary for the proper functioning of the application in the output directory;
- Create a zip archive to recover the application;
- And finally build the installer by compiling the associated InnoSetup script.

All these steps are driven by the Windows batch `deployment_autoit_application.bat` store in directory `deployment`.

![Result of process to package AutoIt application and generate Windows installer in AGS]({{ "assets/img/documentation/AGS-package-and-deployment-result.png" | absolute_url }}){:class="img-full"}

<br/>

> **Relating reading**
> 
> Next step and continue reading with <a href="/autoit-gui-skeleton/documentation/code-organization">Code organization</a>.