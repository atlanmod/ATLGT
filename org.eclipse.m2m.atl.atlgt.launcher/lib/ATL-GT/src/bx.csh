#!/bin/csh -f
# Forward transformation from XMI to XMI via GRoundTram
# Usage
# bx.csh -fwd -atl trans.atl -sxmi src.xmi -txmi tgt.xmi -skm3 smm.km3 -spkg smm -tkm3 tmm.km3 -tpkg tmm
# bx.csh -bwd -atl trans.atl -sxmi src.xmi -txmi tgt.xmi -skm3 smm.km3 -spkg smm -tkm3 tmm.km3 -tpkg tmm

set CMDNAME=`basename $0`
set COMMANDNAME=${CMDNAME}

unset BWD

onintr int

while ($#argv > 0)
    switch ($1:q)
	case --help:
	case -help:
	    goto printusage
	breaksw
	case -fwd:
	    unset BWD
	    shift
        breaksw
	case -bwd:
	    set BWD
	    shift
        breaksw
	case -sxmi:
	    shift
	    set XMISRC = ${1:q}
	    shift
	breaksw
	case -txmi:
	    shift
	    set XMITGT = ${1:q}
	    shift
	breaksw
	case -skm3:
	    shift
	    set KM3SRC = ${1:q}
	    shift
	breaksw
	case -tkm3:
	    shift
	    set KM3TGT = ${1:q}
	    shift
	breaksw
	case -spkg:
	    shift
	    set PKGSRC = ${1:q}
	    shift
	breaksw
	case -tpkg:
	    shift
	    set PKGTGT = ${1:q}
	    shift
	breaksw
	case -atl:
	    shift
	    set ATL = ${1:q}
	    # currently ATL file is ignored
	    shift
	breaksw
	case -*:
	    echo "Error: unknown option: ${1:q}"
	    goto printusage
	breaksw
	default:
	    # anonymouns argument are invalid
	    echo "Error: unknown argument ${1:q}"
	    goto printusage
        breaksw
    endsw
end

if (! ${?XMISRC}) then
    echo "Error: Source XMI file unspecified"
    goto printusage
endif

if (! ${?XMITGT}) then
    echo "Error: Target XMI file unspecified"
    goto printusage
endif

if (! ${?KM3SRC}) then
    echo "Error: Source KM3 metamodel unspecified"
    goto printusage
endif

if (! ${?PKGSRC}) then
    echo "Error: Source KM3 package name unspecified"
    goto printusage
endif

if (! ${?KM3TGT}) then
    echo "Error: Target KM3 metamodel unspecified"
    goto printusage
endif

if (! ${?PKGTGT}) then
    echo "Error: Target KM3 package name unspecified"
    goto printusage
endif

if (! ${?ATL}) then
    echo "Error: Transformation ATL file unspecified"
    goto printusage
endif

set EXPID=$$

set BIGROOT     = ../../ground_tram-0.9.5
set BIGSRC      = ${BIGROOT}/src
set FWD_UNCAL   = "${BIGSRC}/fwd_uncal -ge -sb -cl -zn -fi -np -sa -t -rw -as"
set BX_CONTRACT = "${BIGSRC}/bx_contract -batch"
set BWD_UNCAL   = "${BIGSRC}/bwd_uncal -t"

# ATL to UnQL translation 
set TGTUNQL = ${ATL:t}.unql
# ../examples/ICMT11class2table3.unql
./atl2unql -atl ${ATL} -uq ${TGTUNQL} -ikm3 ${KM3SRC} -ipkg ${PKGSRC} -okm3 ${KM3TGT} -opkg ${PKGTGT}

# set XMISRC = ../examples/Sample-Class.xmi
# set XMITGT = x.xmi
# set KM3SRC = ../examples/Sample-Class.km3 
# set PKGSRC = Class
# set KM3TGT = ../examples/Table.km3
# set PKGTGT = Table

set DOTSRC = ${XMISRC}.dot
set DOTTGT = ${XMITGT}.dot
# name of the trace file is automatically generated using source and transformation name
set XG = ${DOTSRC:t}_${TGTUNQL:t}.xg
set EI = ${XG:r}.ei

set DOTTGT_NORMAL = ${DOTTGT:r}_NORMAL.dot

if (${?BWD}) then
    goto bwd
endif

# xmi2dot
./xmi2dot.csh -xmi ${XMISRC} -dot ${DOTSRC} -km3 ${KM3SRC} -pkg ${PKGSRC}

fwd:

${FWD_UNCAL} -db ${DOTSRC} -uq ${TGTUNQL} -dot ${DOTTGT} -xg ${XG} -ei ${EI}

# bisimulation contraction
${BX_CONTRACT} -src ${DOTTGT} -dst ${DOTTGT_NORMAL}

# dot2xmi
./dot2xmi.csh -dot ${DOTTGT_NORMAL} -xmi ${XMITGT} -km3 ${KM3TGT} -pkg ${PKGTGT}

exit 0

bwd:
#
# Backward transformation
#

set DOTTGT_NORMAL_UPD = ${DOTTGT_NORMAL:r}_UPD.dot
set DOTTGT_UPD = ${DOTTGT:r}_UPD.dot
set DOTSRC_UPD = ${DOTSRC:r}_UPD.dot

# update xmi file
emacs -q ${XMITGT}
# Backward transformation of contraction
# This fails because XMI2DOT will create different node IDs.
# XMI2DOT should have taken the old DOT file, just like the
# usual PUT functions in BX.
./xmi2dot.csh -xmi ${XMITGT} -dot ${DOTTGT_NORMAL_UPD} -odot ${DOTTGT_NORMAL} -km3 ${KM3TGT} -pkg ${PKGTGT}

# #
# # Tentative emulation to circumvent the above issue. Contracted dot is
# # directly edited manually
# cp -p ${DOTTGT_NORMAL} ${DOTTGT_NORMAL_UPD}
# bdotty ${DOTTGT_NORMAL_UPD}

${BX_CONTRACT} -src ${DOTTGT} -dst ${DOTTGT_NORMAL_UPD} -usrc ${DOTTGT_UPD} -batch

${BWD_UNCAL} -db ${DOTSRC}  -udot ${DOTSRC_UPD} -dot ${DOTTGT_UPD} -xg ${XG} -ei ${EI}

# dot2xmi
./dot2xmi.csh -dot ${DOTSRC_UPD} -xmi ${XMISRC:r}_upd.xmi -km3 ${KM3SRC} -pkg ${PKGSRC}

exit 0

printusage: 
set usage="syntax: ${COMMANDNAME:t} (-fwd|-bwd) -atl trans.atl -sxmi src.xmi -txmi tgt.xmi -skm3 smm.km3 -spkg smm -tkm3 tmm.km3 -tpkg tmm"
echo "Usage:"
echo  "${usage}"
echo "Example: "
echo "        ${COMMANDNAME:t} (-fwd|-bwd) -sxmi ../examples/Sample-Class.xmi -skm3 ../examples/Sample-Class.km3 -spkg Class -txmi x.xmi -tkm3 ../examples/Table.km3 -tpkg Table"
echo "-fwd|bwd      transformation direction"
echo "-atl  <atl>   transformation ATL file"
echo "-sxmi <xmi>   source XMI file"
echo "-txmi <xmi>   target XMI file"
echo "-skm3 <km3>   source KM3 metamodel file"
echo "-spkg <pkg>   Package name in source KM3"
echo "-tkm3 <km3>   target KM3 metamodel file"
echo "-tpkg <pkg>   Package name in target KM3"
echo "-help        print this help"
exit 1
