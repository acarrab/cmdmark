#!/bin/bash
function j { eval "$(/Users/acarrab/bashtools/cmdmark/dst/cmdmark.sh "$1" "$2" ${@:3})"; }
function m { j -set "$1" cd $PWD; }
savedCommands=/Users/acarrab/.savedCommands.dat
_cmdmark='/Users/acarrab/bashtools/cmdmark/dst/_cmdmark.sh'
###############################################################################
#                       bash completion for commands!!!                       #
###############################################################################
function _cmdmark {
    local cur=${COMP_WORDS[COMP_CWORD]}

    if (( $COMP_CWORD < 2 )); then
	local commands=$(cat $savedCommands | sed 's/^(\([^)]*\)).*$/\1/' | grep -ve '^$')
	COMPREPLY=( $(compgen -W "$commands -set -delete -list -help") )
    elif [[ $COMP_CWORD  == "2" && "${COMP_WORDS[1]}" == "-delete" ]]; then
	local commands=$(cat $savedCommands | sed 's/^(\([^)]*\)).*$/\1/' | grep -ve '^$')
	COMPREPLY=( $(compgen -W "$commands") )
    elif [[ "${COMP_WORDS[1]}" == "-list" || "${COMP_WORDS[1]}" == "-help" ]]; then
	COMPREPLY=( )
    elif [[ "${COMP_WORDS[1]}" == "-set" ]]; then
	if (( $COMP_CWORD ==  2 )); then
	    COMPREPLY=( $(compgen  -A "function" -abck) )
	else
	    COMPREPLY=( $(compgen -o "filenames" -A "file") )
	fi

    else
	COMPREPLY=( $(compgen -o filenames -A file) )
    fi
    return 0
}


# for zsh shell
if [ -n "$ZSH_VERSION" ]; then
    autoload -U +X compinit && compinit
    autoload -U +X bashcompinit && bashcompinit
fi
complete -o filenames -F _cmdmark j
