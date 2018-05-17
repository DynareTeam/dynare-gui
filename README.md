Dynare GUI
==========

Main functionalities:
---------------------

- New, open, save, close Dynare GUI project files (.dproj)
- Load .mod file: an interface to load a mod file
- Model settings: an interface for defining various model and GUI options
- Dynare GUI log file
- Export to .mod file
- Save/load model snapshots
- Define observed variables and datafile
- Specification of estimated parameters & shocks
- Estimation command
- Calibrated smoother command
- Stochastic simulation
- Deterministic simulation
- Shock decomposition
- Conditional forecast

How to run it:
--------------

- Open Matlab

- Add the Dynare `matlab` folder to the Matlab path:

```matlab
   >> addpath c:\dynare\4.x.y\matlab
```

- Add the folder containing the Dynare GUI source code to the Matlab path:

```matlab
   >> addpath c:\dynare\dynare-gui\src
```

- Launch the GUI

```matlab
  >> dynare_gui
```
