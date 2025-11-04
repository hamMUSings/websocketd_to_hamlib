#!/bin/bash
#This script is a simple manager for all the other bash scripts.
#This way you only need one running websocketd process.
while read C
do
    cdir=`pwd`
    script=''
    first=''
    args=''

    # does $C have arguments?
    spcs=`echo $C | grep \  | wc -l`
    if [ $spcs -eq 0 ]; then
        first=$C
    else
        # read the first arg to determine what script to run
        IFS=' ' read -a part <<< "$C"

        first=${part[0]}
        #remove the first part of the string, leave all the rest as args to pass to script
        args=${C#${part[0]} }
    fi

    # which script to run?
    if [ "$first" == "hamlib" ]; then
	script='ws-rigctl-actions.sh'
    fi
    if [ ! -z $script ]; then
        #echo $cdir/$script $args
        eval $cdir/$script $args
    else
        echo "I don't understand: $C"
    fi

done
exit
