Dynare GUI
==========

Main functionalities:
---------------------

- New, open, save, close Dynare_GUI project files (.dproj)
- Load .mod file: an interface to load a mod file
- Model settings: an interface for defining various model and GUI options
- Dynare_GUI log file
- Select observed variables
- Specification of estimated parameters & shocks
- Estimation command (basic functionalities)
- Stochastic simulation (basic functionalities).

How to run it:
--------------

- Temporarly add the dynare/matlab folder to the matlab's path.

```matlab
   >> addpath c:\dynare\4.x.y\matlab
```

- Temporarly add folder containing the fonction Dynare_GUI to the matlab's path

```matlab
   >> addpath c:\dynare\dynare-gui\src
   >> addpath c:\dynare\dynare-gui\src\resources
```

- Launch the GUI

```matlab
  >> Dynare_GUI
```

- Important note: 

<<<<<<< HEAD
Following folder is not on GitHub, but it is necessary for running the application:
- \src\resources 

=======
Following folders are not on GitHub, but there are necessary for running the application:
- \src\resources
- \src\GUILayout-v1p14\+uiextras\Resources
>>>>>>> origin/master
