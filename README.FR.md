Autoit-Gui-Skeleton (AGS)
=========================

*Lire ce fichier dans une autre langue : [English](README.md), [French](README.FR.md)*

<br/>

> Fournir une architecture et une organisation pour construire efficacement une application bureautique Windows via la solution AutoIt.
>
> Pou se **documenter**  : [https://v20100v.github.io/autoit-gui-skeleton/](https://v20100v.github.io/autoit-gui-skeleton/)

<br/>



<br/>



## AGS ?

AutoIt Gui Skeleton (AGS) donne aux développeurs des éléments, pour faciliter la construction d'application AutoIt.

Pour organiser le code d'une application AutoIT, AGS propose d'utiliser des conventions et le modèle suivant pour développer et construire une application AutoIt avec une interface graphqiue (IHM).

<br/>


## Architecture et vue d'ensemble d'un projet AGS

Un projet AGS respecte l'organisation suivante pour ses fichiers et répertoires.


```
project root folder
|
|   myApplication.au3          # Main entry program
|   myApplication_GLOBAL.au3   # All global variables declaration
|   myApplication_GUI.au3      # Main program to handle GUI
|   myApplication_LOGIC.au3    # Business code only
|   README.md                  # Cause We always need it
|  
+---assets                     # All applications assets (images, files...)
|   +---css
|   +---html
|   +---images
|   \---javascript
|
+---deployment                
|   \---releases               # Contains releases setup (zip and Windows setup files)
|   deployment.bat             # Windows batch bandmaster to pilot the creation of the Windows setup
|   deploymeny.iss             # ISS to generate Windows setup
|
+---vendor                     # All third-party code use in this project
|   \--- FolderVendor
|              
\---views                      # Views declaration
    View_About.au3
    View_Footer.au3
    View_Welcome.au3
```


### Repertoires et fichiers d'un projet AGS

On organise les fichiers dans des répertyoires spécifiques.


### Répertoire `assets`

Ce répertoire contient les éléments utilisés dans l'application comme des images, des fichiers textes, pdf, html, css, javascript. Ce répertoire contient tous les fichiers locaux nécessaire à l'application.


### Répertoire `deployment`

Ce répertoire contient un batch Windows qui pilote la création d'un installeur Windows avec la solution [InnoSetup](http://www.jrsoftware.org/isinfo.php). Pour faire fonctionner le batch, il est nécessaire que le compilateur d'InnoSetup et que 7zip soit installer sur le poste client. Si ce n'est pas le cas, je vous conseille d'utiliser le gestionnaire de package Windows [Chocolatey](https://chocolatey.org/) pour les installer simplement :

```
C:\> choco install 7zip
C:\> choco install innosetup
```


### Répertoire `vendor`

Ce répertoire est l'endroit par convention où stocker le code développé par des tiers dans un projet. Dans ce projet (https://github.com/v20100v/autoit-gui-skeleton), nous avons par exemple mis la bibliothèque GUICtrlOnHover v2.0 créée par G.Sandler a.k.a MrCreatoR dans ce répertoire.


### Répertoire `views`

Ce répertoire contient les gestionnaires des vues. Tout le code de toutes les vues sont définis à chaque fois dans un fichier spécifique et stockés dans ce répertoire.


<br/>


### Vue d'ensemble de l'architecture d'AGS

![](docs/assets/img/documentation/autoit-gui-skeleton_overview.png)


#### Programme d'entrée principale

Le programme d'entrée principale sert de point d'entrée unique pour l'application AutoIt. C'est l'endroit où l'application démarre. Dans ce dernier, il est nécessaire d'inclure les autres libraires, de définir toutes les variables globales, l'interface graphique et le code métier de l'application.

L'application démarre avec le gestionnaire principal de l'IHM `_main_GUI()`.


#### Gestionnaire principal de l'IHM

Ce gestionnaire contiens la méthode `_main_GUI()`, qui est uniquement appellé par le programme d'entrée principal. Cette méthode a pour rôle de créer l'interface graphique (IHM) et de gérer toutes les interactions et évenements de l'utilisateur.


#### Centraliser la décalaration des variables dans la portée globale

Toutes les constantes et les variables globales sont définis en un seul endroit, dans le fichier `myProject_GLOBALS.au3`. À l'exception de toutes les variables globales des éléments graphiques qui elles, sont définies dans chaque fichier de vue spécifique. On rappelle que les constantes ne peuvent plus changer de valeur dans le temps, contrairement aux variables globales.

Par convetion, toutes les variables glboales doivent être écrites en majuscule avec un underscore pour séparée les motes. Par exemple : `Global Const $APP_EMAIL_CONTACT`


#### Package et déploiement

Dans le but de faciliter le déploiement d'application Windows développer avec AutoIt, on propose d'utiliser un processus automatisée pour construire un installeur Windows avec la solution [InnoSetup](http://www.jrsoftware.org/isinfo.php). Dans AGS, on utilise en plus un fichier batch Windows, appellé `.deployment_autoit_application.bat` qui joue le rôle de chef d'orquestre dans la génération de l'installeur. Dans le répertoire `\Deployment`, il sera créer le répertoire `\releases\vx.y.z\` où l'archive zip de l'application, ainsi que le programme d'installation Windows seront construits.  

![AGS GUI package and deployment process](docs/assets/img/documentation/AGS-package-and-deployment-process.gif) 

Pour génerer un installeur, il faut une préparation dont les principales étapes sont :

- Assigner un numéro de version à l'application;
- Compiler l'application, c'est à dire compiler le programme d'entrée principale myProject.au3 avec le compilateur aut2exe;
- Copier les assets (images, files...) nécessaires au fonctionnement de l'application dans le répertoire de génération;
- Créer l'archive zip;
- Et dinalement construire l'installeur Windows par la compilation du script InnoSetup associé.

Toutes ces étapes sont pilotées par le fichier batch Windows `deployment_autoit_application.bat`. 

![Result of process to package AutoIt application and generate Windows installer in AGS](docs/assets/img/documentation/AGS-package-and-deployment-result.png)


### Exemple d'un projet AGS

Dans ce dépôt Git, on a ajouté dans le répertoire [./source](https://github.com/v20100v/autoit-gui-skeleton/tree/master/source) d'un projet AutoIt construit avec les conventions AGS. Pour créer un nouveau projet, on vous conseille de copier ce dernier, et de changer les mentions de 'myApplication' avec le nom réel de votre application.

![Result of process to package AutoIt application and generate Windows installer in AGS](docs/assets/img/documentation/AGS-gui-example.gif)  



<br/>

## A propos


### Historique

 - AGS v1.0.0 - 2018.05.16


### Contribution

Vos commentaires, pull-request et stars sont toujours les bienvenues !


### Licence

Copyright (c) 2018 by [v20100v](https://github.com/v20100v). Released under the [Apache license](https://github.com/v20100v/autoit-gui-skeleton/blob/master/LICENSE.md).
