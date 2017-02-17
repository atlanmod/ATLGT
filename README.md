# ATLGT
Bidirectional version of ATL on top of the GRoundTram transformation engine

**Paper**: Sochiro Hidaka and Massimo Tisi, "ATLGT: bidirectional ATL on top of GRoundTram" ([link](http://www.prg.nii.ac.jp/members/hidaka/papers/esop2016_long.pdf))
_(This is the long version of the conference submission "Partial Bidirectionalization of Model Transformation Languages" by the same authors)_

### Installation

The simplest way to install _ATG-GT_ is to use the update-site, that is available [here](https://atlanmod.github.io/ATLGT/releases/). It provides an all-in-one component: **ATL-GT**.

A JDK8 is required, and, in order to import the _ATL-GT_ repository in Eclipse, you will need the following plugins in your installation (installable from the software repository of your Eclipse release):

- **EMF**: v2.12.0, or later
- **ATL** (with the EMFTVM launcher): v3.7.0, or later

### Sample

The project is provided with a sample project: `org.eclipse.m2m.atl.atlgt.example.simpleclass2relational`.

To use it, you need to import this project under an Eclipse workspace, and run the 2 preconfigured `*.launch` files, which can be found under the `test` directory:

1. `myClassDiagram2myRelational-forward`
2. `myClassDiagram2myRelational-backward`