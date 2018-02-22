#!/bin/bash
savedCommands=/Users/acarrab/.savedCommands.dat
###############################################################################
#                              Command Management                             #
###############################################################################
# echo $savedCommands

function colorText { echo $(tput setaf 2)"$@"$(tput sgr0); }

function printCommand {
    cmd=$1
    while [ ${#cmd} -lt 15 ]; do cmd+="~"; done
    echo "$cmd""-->"
}

function fill {
    size=$1
    addition=''
    while [ $size -lt $2 ]; do addition+=$3; size=$(($size + 1)); done
    echo "$addition"
}

function getKey {
    echo "$@" | sed 's/^\((.*)\).*$/\1/'
}
function getCmd {
    echo "$@" | sed 's/^(.*)\(.*\)/\1/'
}

function printCommands {
    longest=$(cat $savedCommands | while read line; do k=$(getKey $line); echo ${#k}; done | sort -n | tail -n 1)
    cat $savedCommands | \
	while read cmdline; do
	    key=$(getKey "$cmdline")
	    cmd=$(getCmd "$cmdline")
	    echo ${#key} $key $cmd
	done | sort -n | awk '{$1=""; print $0}' |

	while read cmdline; do
	    key=$(getKey "$cmdline")
	    cmd=$(getCmd "$cmdline")
	    echo "$(fill ${#key} $(($longest + 1)) ' ')("$(colorText "${key:1:$((${#key} - 2))}")")" "-->" $cmd
	done
}

function listCommands {
    printf "$(printCommands)" 1>&2
}



function deleteCommand {
    newCommands="$(cat $savedCommands | grep -v -e '^('$1')')"
    printf "$newCommands\n" > $savedCommands
}

function markCommand {
    echo ${@:2}
    deleteCommand $1
    echo "($1) ${@:2}" >> $savedCommands
}

function runCommand {
    $(getCmd $(cat $savedCommands | grep -e "^($1)"))
}





# if it has a flag
if [[ $1 != '' && ${1::1} == '-' ]]; then
    case $1 in
	'-m') markCommand ${@:2};;
	'-d') deleteCommand ${@:2};;
	'-l') printCommands;;
    esac
else
    runCommand $@
fi
