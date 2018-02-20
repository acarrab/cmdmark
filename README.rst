Command Mark
============

Mark commands and locations with a single bash command so that you can
easily repeat a command without rewriting alias definitions in your


---

You can alias this package and then call it from the shell as so

alias j="python -c \"import cmdmark; cmdmark('~/.savedCommands.dat');\""


Then you can use it with

$ j -s access 'ssh whatever.server.edu'

Then, instead of typing the ssh command or adding an alias in your bashrc, you can simply just jump to that locations

$ j access


You can mark any commands that you want as long as you can pass them into command line argument

I like to define this function for marking the current directory

function m { j -m $1 "cd $PWD"; }
