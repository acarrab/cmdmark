#!/bin/bash


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
mkdir dist
dist=$(realpath ./dist/cmdmark.sh)

if [ ! -f $filename ]; then touch $filename; fi

echo "#!/bin/bash" > $dist
echo "savedCommands=$filename" >> $dist
cat $src >> $dist

chmod +x $dist


echo "add these lines to your .bashrc file to use"
echo "-------------------------------------------"
echo 'function j { eval "$('$dist' "$1" "$2" ${@:3})"; }'
echo 'function m { j -s "$1" cd $PWD; }'
