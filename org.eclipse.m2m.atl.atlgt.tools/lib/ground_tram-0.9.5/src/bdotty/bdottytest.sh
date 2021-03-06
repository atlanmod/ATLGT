#!/bin/sh -x
# 	$Id: bdotty,v 1.3 2009/08/01 11:57:19 hidaka Exp $	

FILES=""
MLEVEL="0"
LMODE="async"
FLAGS=

LEFTYPATH=`dirname $0`; export LEFTYPATH

usage='echo "usage: bdotty [-V] [-lm (sync|async)] [-el (0|1)] <filename>"'

if [ "x$DOTTYOPTIONS" != "x" ]; then
    set -- $DOTTYOPTIONS $*
fi

while [ "x$1" != 'x' ]; do
    case $1 in
    -V)
        echo "BiG editor based on dotty version 96c (09-24-96)"
		FLAGS=$FLAGS" -V"
        shift
        ;;
    -f)
        shift
        loadfile=$1
        shift
        ;;
    -lm)
        shift
        LMODE=$1
        if [ "x$LMODE" != 'xsync' -a "x$LMODE" != 'xasync' ]; then
            $usage
            exit 1
        fi
        shift
        ;;
    -el)
        shift
        MLEVEL=$1
        if [ "x$MLEVEL" != 'x0' -a "x$MLEVEL" != 'x1' ]; then
            $usage
            exit 1
        fi
        shift
        ;;
    -)
        FILES=`echo $FILES \"$1\"`
        shift
        ;;
    -*)
        $usage
        exit 1
        ;;
    *)
        FILES=`echo $FILES \"$1\"`
        shift
        ;;
    esac
done

if [ "x$DOTTYPATH" != 'x' ]; then
    LEFTYPATH="$DOTTYPATH:$LEFTYPATH"
fi

CMDS=""

CMDS="dotty.protogt.layoutmode = '$LMODE';"

CMDS=`echo $CMDS dotty.mlevel = $MLEVEL";"`

if [ "x$loadfile" != 'x' ]; then
    CMDS=`echo $CMDS load \("'"$loadfile"'"\)";"`
fi

if [ "x$FILES" = 'x' ]; then
    FILES=null
fi
FUNC="dotty.createviewandgraph"
for i in $FILES; do
#    CMDS=`echo $CMDS $FUNC \($i, "'"file"'", null, null\)";"`
    CMDS=`echo $CMDS $FUNC \($i, "'"file"'", big.protogt, big.protovt\)";"`
done

leftypath=`which lefty`
if [ ! -f "$leftypath" ]; then
    echo "bdotty: cannot locate the lefty program"
    echo "       make sure that your path includes"
    echo "       the directory containing dotty and lefty"
    exit 1
fi

exec $leftypath $FLAGS -e "
#load ('dotty.lefty');
load ('big.lefty');
checkpath = function () {
    if (tablesize (dotty) > 0)
        remove ('checkpath');
    else {
        echo ('bdotty: cannot locate the dotty scripts');
        echo ('       make sure that the environment variable LEFTYPATH');
        echo ('       is set to the directory containing big.lefty');
        exit ();
    }
};
checkpath ();
dotty.init ();
monitorfile = dotty.monitorfile;
$CMDS
#txtview ('off');
"
