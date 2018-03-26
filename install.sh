#!/bin/bash

init=${1:-"$HOME/.bashrc"}

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



src=$(realpath ./src/cmdmark.sh)
mkdir -p dist
dist=$(realpath ./dist/cmdmark.sh)

if [ ! -f $filename ]; then touch $filename; fi

echo "#!/bin/bash" > $dist
echo "savedCommands=$filename" >> $dist
cat $src >> $dist

chmod +x $dist




l1='function j { eval "$('$dist' "$1" "$2" ${@:3})"; }'
l2='function m { j -s "$1" cd $PWD; }'



tmp="./tmprc"
sed 's/^.*function [jm] {[^}]*}.*$//g'<$init > $tmp
cat $tmp > $init
rm $tmp

echo "$l1" >> $init
echo "$l2" >> $init
