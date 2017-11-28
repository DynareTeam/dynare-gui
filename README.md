Dynare GUI
==========

Main functionalities:
---------------------

- New, open, save, close Dynare_GUI project files (.dproj)
- Load .mod file: an interface to load a mod file
- Model settings: an interface for defining various model and GUI options
- Dynare_GUI log file
- Export to .mod file
- Save/load model snapshots
- Define observed variables and datafile
- Specification of estimated parameters & shocks
- Estimation command
- Calibrated smoother command
- Stochastic simulation
- Deterministic simulation
- Shock decomposition
- Conditional forecast.

How to run it:
--------------

- Temporarily add the dynare/matlab folder to the matlab's path.

```matlab
   >> addpath c:\dynare\4.x.y\matlab
```

- Temporarily add the folder containing the function Dynare_GUI to the Matlab's path

```matlab
   >> addpath c:\dynare\dynare-gui\src
   >> addpath c:\dynare\dynare-gui\src\resources
```

- Launch the GUI

```matlab
  >> Dynare_GUI
```

- Important notes: 

The following folder is not on GitHub, but it is necessary for running the application: \src\resources
