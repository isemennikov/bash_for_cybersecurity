#!/bin/bash
#
#
#
#
# Change argcnt.sh so that it only prints even arguments


COUNT_ARG=$#
echo "there are $COUNT_ARG agruments"
i=1
for arg in "$@"; do
    if ((i % 2 == 0)); then
        echo "arg$i: $arg"
    fi
    ((i++))
done

