###############################################################################
#                       bash completion for commands!!!                       #
###############################################################################

function _cmdmark {
  local cur=${COMP_WORDS[COMP_CWORD]}

  if [[ $(command -v compopt) ]]; then
	  compopt +o default;
	  COMPREPLY=( )
  else
	  COMPREPLY=(" ")
  fi

  local commands=''
  if [[ -f $savedCommands && -s $savedCommands ]]; then
    commands="$($cmdmark_py $savedCommands ls_cmd_names | sed 's/\n/ /g')"
  fi

  if (( $COMP_CWORD < 2 )); then
	  COMPREPLY=( $(compgen -W "$commands -set -delete -list -help -rename" -- "$cur") )
	  return 0
  fi

  case "${COMP_WORDS[1]}" in
	  '-set')
	    case $COMP_CWORD in
		    2) ;;
		    3) COMPREPLY=( $(compgen  -A "function" -abck -- "$cur") );;
		    *) if [[ $(command -v compopt) ]]; then compopt -o default; fi;;
	    esac
	    ;;
	  '-delete'| '-rename')
	    if (( $COMP_CWORD == 2 )); then
		    COMPREPLY=( $(compgen -W "$commands " -- "$cur" ) )
	    fi;;
	  '-help') ;;
	  '-list') ;;
	  *) if [[ $(command -v compopt) ]]; then compopt -o default; fi;;
  esac
  return 0
}


# for zsh shell
if [ -n "$ZSH_VERSION" ]; then
  autoload -U +X compinit && compinit
  autoload -U +X bashcompinit && bashcompinit
fi
complete -o default -F _cmdmark j
