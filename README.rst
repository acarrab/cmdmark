Command Mark
============

Mark commands and locations with a single bash command so that you can
easily repeat a command without rewriting alias definitions in your


---

Just add this function to your .bashrc then it will run wherever.
You can specify where to save the commands when calling the `cmds()` funciton.

```
function j { $(python -c 'from cmdmark import cmds; cmds("~/.savedCommands.dat");' "$@";); }
```

Use -h

Then you can use it with

```
$ j -s a 'ssh whatever.server.edu'
```

Then, instead of typing the ssh command or adding an alias in your bashrc, you can simply just jump to that locations

```
$ j a
```


You can mark any commands that you want as long as you can pass them into command line argument

I like to define this function for marking the current directory

````
function m { j -m $1 "cd $PWD"; }
````
