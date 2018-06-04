---
layout: post
title: Creation of a Windows setup for an AutoIt application
tags: [AGS]
feature-img: "assets/img/pixabay/jigsaw-puzzle-712465_1920.jpg"
thumbnail: "assets/img/pixabay/jigsaw-puzzle-712465_1920.jpg"
excerpt_separator: <!--more-->
---

> AGS provides a process industrialized and some features to facilitate the creation of a package and a Windows setup to an AutoIt application.

<!--more-->


# AGS provides a process and features pleasant to create a Windows Setup

## AGS features deployment
Here are some new features with the combination of AGS, InnoSetup

- Generate package (archive zip) and Windows setup.
- Support internationalization (i18n).
- Check if application is already install.
- Configure additional messages in the setup like: license agreement, prerequisites and history project.
- Add icons applciation into Windows start menu.
- Launch custom command after the end of the installation.
- Customize and change the graphic elements of the Windows installer (setup).

## AGS use a Windows batch to automate Windows installer creation

In AGS we use a Windows batch file which plays the role of orquestrian leader. 

![AGS GUI package and deployment process]({{ "assets/img/documentation/AGS-package-and-deployment-process.gif" | absolute_url }}){:class="img-full img-fancybox"}




<br/>

> **Read AGS documentation**
>
> [Creating installation packages for AutoIt application with AGS]({{ site.url }}{{ site.baseurl }}/documentation/creating-setup-package-autoit-application)
 