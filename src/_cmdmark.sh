# parameter completion for cmdmark.sh
function getCommands {
    commands=$(cat $savedCommands | grep -e '^\('$cur | sed 's/^\(([^\)]*)\)).*$/1/')
    echo "$commands"

}
function _cmdmark {
    local cur

    COMPREPLY=() # possible completions
    cur=${COMP_WORDS[COMP_CWORD]}

    COMPREPLY=( $(compgen -W "$(getCommands)") )
    return 0
}
