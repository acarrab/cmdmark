def main():
    """Entry point for the application script"""
    print("Passed in args: " + str(argv))



def printCommand(key, val):
    return key.ljust(19, '-') + '> "' + val + '"'

def cmds(filename = '~/.savedCommands.dat'):
    from sys import argv, exit
    from regex import match
    from os.path import abspath, expanduser

    filename=expanduser(filename)

    commands = {}
    try:
        with open(filename) as commandsFromFile:
            for cmdline in commandsFromFile:
                if len(cmdline) > 1:
                    key = match(r"^(\S+)\s", cmdline).group(1)
                    cmd = match(r"^\S+\s(.+)$", cmdline).group(1)
                    commands[key] = cmd

    except: pass # no old command file was found

    # empty command
    if len(argv) < 2:
        if '()' in commands:
            print(commands['()'])
        return

    flag=""

    cmdIndex = 1
    # is a flag command
    if match(r"^-", argv[1]):
        flag=argv[1]
        cmdIndex += 1


    key='()'
    if len(argv) > cmdIndex:
        key='('+argv[cmdIndex]+')'
        cmdIndex += 1

    cmd=['']
    if len(argv) > cmdIndex:
        cmd=argv[cmdIndex:]

    cmd = ' '.join(cmd)

    if flag == '-h':
        exit('\n'.join([
            " Possible arguments ".center(70, '~'),
            "",
            "  set a command: ",
            "    j -s <name> <command>",
            "",
            "  mark a path:",
            "    j -m <name>",
            "",
            "  delete a mark:",
            "    j -d <name>",
            "",
            "  list current marks:",
            "    j -l",
            "",
            "  to run a command, just type:",
            "    j <name>",
            "",
            "For any name, you can also pass in quotes to set name to be blank ",
            "",
        ])
        )
    elif flag == '-s':
        commands[key] = cmd
    elif flag == '-m':
        commands[key] = 'cd ' + abspath('.')
    elif flag == '-d' and key in commands:
        del commands[key]
    elif flag == '-l':
        exit("\n".join([ printCommand(key, val) for key, val in commands.items() ]))
    elif flag == '' and key in commands:
        print(commands[key])

    with open(filename, 'w') as fout:
        fout.write("\n".join([ "{} {}".format(key, val) for key, val in commands.items() ]))
