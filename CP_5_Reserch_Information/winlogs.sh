#!/bin/bash

TGZ=0
if (( $# >0 ))
then
    if [[ ${1:0:2} == '-z' ]]
    then 
        TGZ=1 # tgz flags for create archiv logs 
    shift
    fi
fi
SYSNAM=$(hostname)
LOGDIR=${1:-/tmp/${SYSNAM}_logs}        #3


mkdir -p $LOGDIR
cd ${LOGDIR} || exit -2                 #4

wevtutil el | while read ALOG           #5
do
    ALOG="${ALOG%$'\r'}"                #6
    echo "${ALOG}:"                     #7
    SAFNAM="${ALOG// /_}"               #8
    SAFNAM="${SAFNAM//\//-}"
    wevtutil epl "$ALOG" "${SYSNAM}_${SAFNAM}.evtx"
done

if (( TGZ ==1))                         #9
then
    tar -czf ${SYSNAM}_logs.tgz *.evtx  #10
fi


