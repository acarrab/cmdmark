###############################################################################
#                              Command Management                             #
###############################################################################

function printHelp {
  echo "commands: "
	echo "   set a cmd:        -set <name> <command>"
	echo "   delete:           -delete <name>"
	echo "   rename:           -rename <old name> <new name>"
	echo "   list saved cmds:  -ls"
	echo "   help:             -help"
}

function processFlag {
  py="$cmdmark_py $savedCommands"

  case $1 in
	  '-set') $py set "$2" "${@:3}";;
	  '-delete') $py delete "$2";;
	  '-rename') $py rename "$2" "$3";;
	  '-list') $py ls;;
	  *) printHelp
  esac
}

if [[ ! -f $savedCommands ]]; then
  $cmdmark_py $savedCommands init
fi
# if it has a flag
if [[ $1 != '' && ${1::1} == '-' ]]; then
  processFlag "$@"  1>&2
else
  $cmdmark_py $savedCommands get "$@"
fi

