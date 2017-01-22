#!/bin/csh -f
# Usage 
# dot2xmi.csh -dot xxx.dot -xmi xxx.xmi -km3 xxx.km3 -pkg xxx.pkg

set CMDNAME=`basename $0`
set COMMANDNAME=${CMDNAME}

onintr int

set EXPID=$$
set DOT2XMI = ./dot2xmi_command

# initialize option for xmi2dot_generic_command
set OPT = 

# sample command line:

# set KM3SRC = ../examples/Class.km3
# set KM3PKG = Class
# set XMI = /tmp/${EXPID}.xmi
# set DOT = yyyyyyyy.dot

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

if (! ${?DOT}) then
    echo "Error: Input DOT file unspecified"
    goto printusage
endif

if (! ${?XMI}) then
    echo "Error: Output XMI file unspecified"
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




${DOT2XMI} -km3 ${KM3SRC} -pkg ${KM3PKG} -xmi ${XMI}  -dot ${DOT} ${OPT}
# ./dot2xmi.csh -dot yyyyyyyy.dot -km3 ../examples/Class.km3 -pkg Class -xmi zzz.xmi

int: 
exit 0

printusage: 
set usage="syntax: ${COMMANDNAME:t} -dot dotfile -xmi xmifile -km3 km3file -pkg pkgname"
echo "Usage:"
echo  "${usage}"
echo "Example: "
echo "        ${COMMANDNAME:t} -dot yyy.dot -km3 ../examples/Class.km3 -pkg Class -xmi zzz.xmi "
echo "-dot <dot>   input DOT file"
echo "-pkg <pkg>   Package name in KM3"
echo "-km3 <km3>   KM3 metamodel file"
echo "-xmi <xmi>   output XMI file"
echo "-help        print this help"
exit 1

