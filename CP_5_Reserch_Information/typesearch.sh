#!/bin/bash -
#
#typesearch.sh
#
#
#
#
#
#
DEEPORNOT="-maxdepth 1"  # current directory only; default
#
#
while getopts 'c:irR' opt; do

    case "${opt}" in
        c) # copy fined files to dir
            COPY=YES
            DESTDIR="$OPTARG"
        i) # ignore case when searching
            CASEMATCH='-i'
            ;;
        [Rr])
            unset DEEPORNOT;;
        *)
            exist 2;;
    esac
done
shift $((OPTIND -1 ))

PATTERN=${1: -PDF document}
STARTDIR=${2:-.} #start here by default

find $STARTDIR $DEEPORNOT -type f | while read FN
do
    file $FN | egrep -q $CASEMATCH "$PATTERN"
    if (( $? == 0))
    then
        echo $FN
        if [[ $COPY ]]
        then
            cp -p $FN $DESTDIR
        fi
    fi
done
