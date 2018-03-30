#!/bin/bash

init=${1:-"$HOME/.bashrc"} # user can specify their bashrc location

# get our directory name
if [[ $1 = '' ]]; then
    if [[ "$(uname -s)" = 'Linux' ]]; then
	basedir=$(dirname "$(readlink -f "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")
    else
	basedir=$(dirname "$(readlink "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")
    fi
    basedir=$(dirname $(realpath $0))

    filename=~/.savedCommands.dat
else

    filename=$(realpath $1)
fi



if [ ! -f $filename ]; then touch $filename; fi


# fileList



function src { echo $(realpath ./src)/$1; }
function dst { echo $(realpath ./dst)/$1; }
mkdir -p $(dst)

cmdmark="cmdmark.sh"
_cmdmark="_cmdmark.sh"
include="include.sh"

declarations="savedCommands=${filename}"'\n'"cmdmark=$(dst $cmdmark)"'\n'"_cmdmark=$(dst $_cmdmark)"'\n'



function create_cmdmark {
    echo 'creating cmdmark...'

    s=$(src $cmdmark)
    d=$(dst $cmdmark)

    echo "#!/bin/bash" > $d

    printf "$declarations\n" | while read line; do
	echo $line >> $d
    done

    cat $s >> $d

    chmod +x $(dst $cmdmark)
}

function create_completions {
    echo 'creating completions...'
    echo '#!/bin/bash' > $(dst $_cmdmark)
    echo 'function j { eval "$('$(dst $cmdmark)' "$1" "$2" ${@:3})"; }' >> $(dst $_cmdmark)
    echo 'function m { j -set "$1" cd $PWD; }' >> $(dst $_cmdmark)
    echo "savedCommands=${filename}" >> $(dst $_cmdmark)

    echo "_cmdmark='$(dst $_cmdmark)'" >> $(dst $_cmdmark)
    cat $(src $_cmdmark) >> $(dst $_cmdmark)
}


function include_cmdmark {
    initText="source '$(dst $_cmdmark)'"
    if (( $(grep "$initText" <$init | wc -l) == 0 )); then
	echo 'including the include'
	echo $initText >> $init;
    fi
}


create_cmdmark && create_completions && include_cmdmark
