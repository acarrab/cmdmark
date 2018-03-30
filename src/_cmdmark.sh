###############################################################################
#                       bash completion for commands!!!                       #
###############################################################################
function _cmdmark {
    local cur=${COMP_WORDS[COMP_CWORD]}
    COMPREPLY=( )


    if (( $COMP_CWORD < 2 )); then
	local commands=$(cat $savedCommands | sed 's/^(\([^)]*\)).*$/\1/' | grep -ve '^$')
	COMPREPLY=( $(compgen -W "$commands -set -delete -list -help") )
	return 0
    fi

    case "${COMP_WORDS[1]}" in
	'-set')
	    case $COMP_CWORD in
		2) COMPREPLY=( );;
		3) COMPREPLY=( $(compgen  -A "function" -abck) );;
		*) COMPREPLY=( $(compgen -o "filenames" -A "file") );;
	    esac
	    ;;
	'-delete')
	    case $COMP_CWORD in
		2) COMPREPLY=( $(compgen -W "$(cat $savedCommands | sed 's/^(\([^)]*\)).*$/\1/' | grep -ve '^$')") );;
		*) COMPREPLY=( );;
	    esac
	    ;;
	'-help') COMPREPLY=( );;
	'-list') COMPREPLY=( );;
	*)
	    COMPREPLY=( $(compgen -o "filenames" -A "file") );;
    esac
    return 0
}


# for zsh shell
if [ -n "$ZSH_VERSION" ]; then
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit
fi
complete -o filenames -F _cmdmark j
