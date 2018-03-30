###############################################################################
#                              Command Management                             #
###############################################################################

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
    echo "$@" | sed 's/^\(([^)]*)\).*$/\1/'
}
function getCmd {
    echo "$@" | sed 's/^([^)]*) \(.*\)$/\1/'
}

function printCommands {
    commands="$(cat $savedCommands)"

    longest=$(printf "$commands\n" | while read line; do k=$(getKey $line); echo ${#k}; done | sort -n | tail -n 1)
    printf "$commands\n" | \
	while read cmdline; do
	    key="$(getKey "$cmdline")"
	    cmd="$(getCmd "$cmdline")"

	    echo ${#key} "$key" "$cmd"
	done | sort -n | sed 's/^[0-9]* *//g' |
	while read cmdline; do
	    key="$(getKey "$cmdline")"
	    cmd="$(getCmd "$cmdline")"
	    echo "$(fill ${#key} $(($longest + 1)) ' ')("$(colorText "${key:1:$((${#key} - 2))}")")" "-->" "$cmd" 1>&2
	done
}

function listCommands {
    printf "$(printCommands)" 1>&2
}

function deleteCommand {
    newCommands="$(cat $savedCommands | grep -v -e '^('$1')')"
    printf "$newCommands\n" | grep -v '^$' > $savedCommands
}
function renameCommand {
    newCommands="$(cat $savedCommands | sed 's/^('$1')/('$2')/' )"
    printf "$newCommands\n" | grep -v '^$' > $savedCommands
}

function areCommands {
    if (( $(cat $savedCommands | wc -l) != 0 )); then echo 1; fi
}



if [[ ! -f $savedCommands ]]; then touch $savedCommands; fi
# if it has a flag
if [[ $1 != '' && ${1::1} == '-' ]]; then
    case $1 in
	'-set') deleteCommand $2
	      echo "($2) ${@:3}" >> $savedCommands
	      ;;
	'-delete') deleteCommand ${@:2};;
	'-rename') renameCommand ${@:2};;
	'-list') if [[ $(areCommands) ]]; then printCommands; fi;;
	*) echo "commands: " 1>&2
	   echo "   set:    -set <name> <command>" 1>&2
	   echo "   delete: -delete <name>" 1>&2
	   echo "   rename: -rename <old name> <new name>" 1>&2
	   echo "   list:   -list" 1>&2
	   echo "   help:   -help" 1>&2;;
    esac
else
    getCmd "$(cat $savedCommands | grep -e "^($1)")"
fi
