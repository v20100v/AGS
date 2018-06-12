---
layout: post
title: Création d'un setup Windows pour une application AutoIt
tags: [AGS, InnoSetup]
feature-img: "assets/img/pixabay/jigsaw-puzzle-712465_1920.jpg"
thumbnail: "assets/img/pixabay/jigsaw-puzzle-712465_1920.jpg"
excerpt_separator: <!--more-->
---

> AGS fournit un processus automatique et d'autres fonctionnalités pour faciliter la création d'un package et d'un installeur Windows (setup) d'une application AutoIt.

<!--more-->


# Fonctionnalités deploiement avec AGS

Voici quelques nouvelles fonctionnalités avec le couple AGS et InnoSetup:

- Générer un package (archive zip) et un installeur Windows.
- Soutenir l'internationalisation (i18n).
- Vérifier si l'application est déjà installée.
- Configurer des messages supplémentaires dans la configuration comme: contrat de licence, prérequis et projet d'historique.
- Ajouter des applciations d'icônes dans le menu Démarrer de Windows.
- Lancer une commande personnalisée après la fin de l'installation.
- Personnaliser et modifier les éléments graphiques du programme d'installation de Windows.


# AGS utilise un batch Windows pour automatiser la génération du setup

Dans AGS on utilise un batch Windows qui joue le rôle de chef d'orquestre, pour générer le setup.

![AGS GUI package and deployment process](assets/img/documentation/AGS-package-and-deployment-process.gif" | absolute_url }}){:class="img-full img-fancybox"}




<br/>

> **Read AGS documentation**
>
> [Creating installation packages for AutoIt application with AGS]({{ site.url }}{{ site.baseurl }}/documentation/creating-setup-package-autoit-application)
 