#!/bin/bash

# SepCMDS - отделение команд от строки ввода 

function SepCmds()
{
    LCMD=${ALINE%%|*}
    REST=${ALINE#*|}
    WCMD=${REST%%|*}
    REST=${REST#*|}
    TAG=${REST%%|*}

    if [[ $OSTYPE == "MSWin" ]]
    then
        CMD="$WCMD"
    else
        CMD="$LCMD"
    fi
}

function DumpInfo()
    {
        printf '<systeminfo host="%s" type="%s"' "$HOSTNAME" "$OSTYPE"
        printf ' date="%s" time="%s">\n' "$(date '+%F')" "$(date '+%T')"
        readarray CMDS
        for ALINE in "${CMDS[@]}"
        do
            #игнорировать комменты 
            if [[ ${ALINE:0:1} == '#' ]]
            then 
                continue
            fi

            SepCmds

            if [[ ${CMD:0:3} == N/A ]]
            then
                continue
            else
                printf "<%s>\n" $TAG
                $CMD
                print "</%s>\n" $TAG
            fi
        done
        printf "</systeminfo>\n"

    }
    OSTYPE=$(./osdetect.sh)
    HOSTNM=$(hostname)
    TMPFILE="${HOSTNM}.info"

    # собираем в tmp file как информацию и ошибки 

    DumpInfo > $TMPFILE 2>&1
