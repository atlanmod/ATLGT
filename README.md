# ATLGT
Bidirectional version of ATL on top of the GRoundTram transformation engine

**Technical Report**: Sochiro Hidaka and Massimo Tisi, "Partial Bidirectionalization of Model Transformation Languages" ([link](http://cis.k.hosei.ac.jp/~hidaka/research/papers/scp2016.pdf))


### Installation

The simplest way to install _ATL-GT_ is to use the update-site, that is available [here](https://atlanmod.github.io/ATLGT/releases/). It provides an all-in-one component: **ATL-GT**.

A JDK8 is required, and, in order to import the _ATL-GT_ repository in Eclipse, you will need the following plugins in your installation (installable from the software repository of your Eclipse release):

- **EMF**: v2.12.0, or later
- **ATL** (with the EMFTVM launcher): v3.7.0, or later

### Sample

The project is provided with an example project, named "Class to Relational". In order to import it in your workspace, you can retrieve it in the `File > New > Example...` window, under the "ATL-GT" section.


You can run it by using the 2 preconfigured `*.launch` files, which can be found under the `test` directory:

1. `myClassDiagram2myRelational-forward`
2. `myClassDiagram2myRelational-backward`

See `README.md` in the project for details on its usage.
