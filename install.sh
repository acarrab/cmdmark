#!/bin/bash

init=${1:-"$HOME/.bashrc"} # user can specify their bashrc location

if [[ $(command -v realpath) ]]; then  expandPath="realpath"; else expandPath="readlink -m"; fi

# get our directory name
if [[ $1 = '' ]]; then
  if [[ "$(uname -s)" = 'Linux' ]]; then
	  basedir=$(dirname "$(readlink -f "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")
  else
	  basedir=$(dirname "$(readlink "$0" || echo "$(echo "$0" | sed -e 's,\\,/,g')")")
  fi
  basedir=$(dirname $($expandPath $0))

  filename=~/.cmdsave.dat
else
  filename=$($expandPath $1)
fi


if [ ! -f $filename ]; then touch $filename; fi

function src { if [[ ! $1 ]]; then echo $($expandPath ./src); else echo $($expandPath ./src)/$1; fi }
function dst { if [[ ! $1 ]]; then echo $($expandPath ./dst); else echo $($expandPath ./dst)/$1; fi }
mkdir -p $(dst)

cmdmark_py="cmdmark.py"
cmdmark="cmdmark.sh"
_cmdmark="_cmdmark.sh"
include="include.sh"

declarations="savedCommands=${filename}"'\n'
declarations+="cmdmark=$(dst $cmdmark)"'\n'
declarations+="_cmdmark=$(dst $_cmdmark)"'\n'
declarations+="cmdmark_py=$(dst $cmdmark_py)"'\n'

function create_cmdmark_py {
  echo 'creating cmdmark.py...'

  s=$(src $cmdmark_py)
  d=$(dst $cmdmark_py)
  cp $s $d

  chmod +rx $d
}

function create_cmdmark {
  echo 'creating cmdmark...'

  s=$(src $cmdmark)
  d=$(dst $cmdmark)

  echo "#!/bin/bash" > $d
  printf "$declarations\n" | while read line; do
	  echo $line >> $d
  done
  cat $s >> $d

  chmod +rx $d
}

function create_completions {
  s=$(src $_cmdmark)
  d=$(dst $_cmdmark)
  echo 'creating completions...'
  echo '#!/bin/bash' > $d
  echo 'function j { eval "$('$(dst $cmdmark)' "$1" "$2" ${@:3})"; }' >> $d
  echo 'function m { j -set "$1" cd $PWD; }' >> $d
  printf "$declarations\n" | while read line; do
	  echo $line >> $d
  done
  cat $s >> $d

  chmod +rx $d
}

function include_cmdmark {
  initText="source '$(dst $_cmdmark)'"
  if (( $(grep "$initText" <$init | wc -l) == 0 )); then
	  echo 'including the include'
	  echo $initText >> $init;
  fi
}

create_cmdmark_py && create_cmdmark && create_completions && include_cmdmark
