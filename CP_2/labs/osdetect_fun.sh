#! /bin/bash
#
#
# Bash for cybersecurity
#
#
#Description:
#Detection OS use unamme -s comand

OS_NAME=$(uname -s)

function os_detect()
{
    if [[ "$OS_NAME" = "Linux" ]]
    then
        OS_NAME=Linux
    elif [[ "$OS_NAME" = "Darwin" ]]
    then
        OS_NAME=macOS
    elif [[ "$OS_NAME" = "FreeBDS" ]]
    then
        OS_NAME=FreeBDS
    else
        OS_NAME=MSWindows
    fi 

echo $OS_NAME
}

os_detect