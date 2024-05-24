#!/bin/bash -
#
#typesearch.sh
#
#Description:
#Searchig any files with scecific type
#Print path_file if file is found
#
#
#
#Use:
#
DEEPORNOT="-maxdepth 1"  # current directory only; default
#
#
while getopts  'c:irR' opt; do                              #1

    case "${opt}" in                                        #2
        c) # copy fined files to dir
            COPY=YES
            DESTDIR="$OPTARG"                               #3
            ;;
        i) # ignore case when searching
            CASEMATCH='-i'
            ;;
        [Rr])                                               #4
            unset DEEPORNOT;;                               #5
        *)                                                  #6
            exist 2;;
    esac
done
shift $((OPTIND -1 ))                                       #7

PATTERN=${1:-PDF document}                                  #8
STARTDIR=${2:-.} #start here by default

find $STARTDIR $DEEPORNOT -type f | while read FN           #9
do
    file $FN | egrep -q $CASEMATCH "$PATTERN"               #10
    if (( $? == 0))                                         #11
    then
        echo $FN
        if [[ $COPY ]]                                      #12
        then
            cp -p $FN $DESTDIR                              #13
        fi
    fi
done
