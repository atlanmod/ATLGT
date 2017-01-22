#!/bin/csh -f
# Usage 
# xmidot.csh -xmi xxx.xmi -dot xxx.dot -km3 xxx.km3 -pkg xxx

set CMDNAME=`basename $0`
set COMMANDNAME=${CMDNAME}

onintr int

set EXPID=$$
set XMI2DOT = ./xmi2dot_generic_command

# initialize option for xmi2dot_generic_command
set OPT = 

# optional argument initialization
unset ODOT

# sample command line:

# set KM3SRC = ../examples/Class.km3
# set KM3PKG = Class
# set XMI = ../examples/class6.xmi
# #set XMI = ../../doc/examples/massimoExample/AdaptedATL/Sample-RelationalIDs-original.xmi
# set DOT = /tmp/${EXPID}.dot

while ($#argv > 0)
    switch ($1:q)
	case --help:
	case -help:
	    goto printusage
	breaksw
	case -xmi:
	    shift
	    set XMI = ${1:q}
	    shift
	breaksw
	case -dot:
	    shift
	    set DOT = ${1:q}
	    shift
	breaksw
	case -odot:
	    shift
	    set ODOT = ${1:q}
	    shift
	breaksw
	case -km3:
	    shift
	    set KM3SRC = ${1:q}
	    shift
	breaksw
	case -pkg:
	    shift
	    set KM3PKG = ${1:q}
	    shift
	breaksw
	case -*:
	    # unknown options are passed to the underlying command
	    set OPT = "${OPT} ${1:q}"
	    shift
	breaksw
	default:
	    # anonymouns argument are invalid
	    echo "Error: unknown argument ${1:q}"
	    goto printusage
        breaksw
    endsw
end

if (! ${?XMI}) then
    echo "Error: Input XMI file unspecified"
    goto printusage
endif

if (! ${?DOT}) then
    echo "Error: Output DOT file unspecified"
    goto printusage
endif


if (! ${?KM3SRC}) then
    echo "Error: KM3 metamodel unspecified"
    goto printusage
endif

if (! ${?KM3PKG}) then
    echo "Error: KM3 package name unspecified"
    goto printusage
endif

if (${?ODOT}) then
    set OPT = "${OPT} -odot ${ODOT}"
endif



${XMI2DOT} -km3 ${KM3SRC} -pkg ${KM3PKG} -xmi ${XMI}  -dot ${DOT} ${OPT}
# ./xmi2dot.csh -xmi ../examples/class.xmi -km3 ../examples/Class.km3 -pkg Class  -dot xxxxxx.dot

int: 
exit 0

printusage: 
set usage="syntax: ${COMMANDNAME:t} -xmi xmifile -km3 km3file -pkg pkgname -dot dotfile"
echo "Usage:"
echo  "${usage}"
echo "Example: "
echo "        ${COMMANDNAME:t} ../examples/class6.xmi -dot xxxxxx.dot -km3 ../examples/Class.km3 -pkg Class -xmi "
echo "-xmi <xmi>   input XMI file"
echo "-pkg <pkg>   Package name in KM3"
echo "-km3 <km3>   KM3 metamodel file"
echo "-dot <dot>   output DOT file"
echo "-odot <dot>  original DOT file"
echo "-help        print this help"
exit 1

