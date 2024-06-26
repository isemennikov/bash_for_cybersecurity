#!/bin/bash
#
#
#
#
# Write a script called argcnt.sh that reports the number of transmitted arguments added to it:
# 
#
# -  Modify your script to also output each argument one at a time n line.
# 
#
# -  Modify the script so that each argument is marked with the following t once:
#
#$ bash argcnt.sh this is a "real live" test
#there are 5 arguments
#arg1: this
#arg2: is
#arg3:a
#arg4: real live
#arg5: test
#$



#!/bin/bash -
# Cybersecurity Ops with bash
# argcnt.sh

echo "there are $# arguments"

i=1
for MYARGS
do
	echo "arg$i: $MYARGS"
	let i++
done

# "$#"" is a special variable that holds the number of positional parameters passed to a script or a function
# "$@"" is a special variable that represents all the positional parameters passed to a script 