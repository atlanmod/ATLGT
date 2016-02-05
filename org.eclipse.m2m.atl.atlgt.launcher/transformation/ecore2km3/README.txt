The KM3 plugin implements several transformations, including the generation of a KM3 model from an
Ecore metamodel: EMF2KM3. This distribution provides source code for the EMF2KM3 transformation
available in the KM3 plugin as of December 12th, 2005.

EMF2KM3 is usually used through the KM3 plugin, as the "Extract Ecore metamodel to KM3" action available
on *.ecore files. Some users may however want to customize this transformation.
Here is the procedure to replace the standard transformation with a custom one:
	* modify EMF2KM3.atl to support desired features,
	* compile it into EMF2KM3.asm (this is normally automatically performed by the ATL builder),
	* copy EMF2KM3.asm into org.atl.eclipse.km3 / src / org / atl / eclipse / km3 / resources,
	* restart Eclipse.

Files:
	* README.txt: this small note.
	* EMF2KM3.atl: an ATL transformation that transforms Ecore metamodels into KM3 models.
	* Sample.ecore: a sample Ecore model that may be used as input for EMF2KM3.atl.
	* Sample-KM3.ecore: a sample KM3 model that was obtained by applying EMF2KM3.atl to Sample.ecore.
	* LaunchConfiguration.png: a screenshot showing how to configure a launch for EMF2KM3.atl. Note
	that the KM3 metamodel is not loaded from an XMI file but referenced to by its xml namespace URI.
	This mechanism ensures that the latest version of KM3 is always used. It however requires a version of
	ADT more recent than December 12th, 2005.
