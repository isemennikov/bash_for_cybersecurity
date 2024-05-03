#! /bin/bash
#
#
# Bash for cybersecurity
#
#
#Description:
#Detection OS use unamme -s comand

OS_NAME=$(uname -s)

if [[ "$OS_NAME" = "Linux" ]]
then
    echo "You are use Linux OS"
elif [[ "$OS_NAME" = "Darwin" ]]
then
    echo "You are use macOS system"
elif [[ "$OS_NAME" = "FreeBDS" ]]
then
    echo "You are use FreeBDS system"
else
    echo "You are use Windows system"
fi 

