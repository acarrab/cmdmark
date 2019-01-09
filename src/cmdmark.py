#!/usr/bin/python3
"""
The command is described as
commands = {
  cmd_name: (
    cmd: string,
    last_used: number, # time in ms
  )
}
"""
from sys import argv, exit, stderr
from time import time
import pickle

def eprint(*args, **kwargs):
    print(*args, file=stderr, **kwargs)

if len(argv) < 3:
  eprint('usage: ./cmdmark.py <data_file: string> <action: delete|get|set|ls|ls_cmd_names|rename> <key: string|?> <command: string|?>')
  eprint('')
  eprint('  ./cmdmark.py <data_file: string> get <cmd_name: string>')
  eprint('  ./cmdmark.py <data_file: string> set <cmd_name: string> <cmd: string>')
  eprint('  ./cmdmark.py <data_file: string> delete <cmd_name: string>')
  eprint('  ./cmdmark.py <data_file: string> rename <old_name: string> <new_name: string>')
  exit()



none = '\033[0m'
green = '\033[0;32m'
violet = '\033[0;35m'
teal = '\033[0;36m'
blue =  '\033[0;34m'
yellow = '\033[0;33m'
red = '\033[0;31m'

class CmdMark:
  def __init__(self, file_name, action):
    self.file_name = file_name
    self.cmds = {}
    self.load()

    {'delete': self.delete,
     'get': self.get,
     'set': self.set,
     'ls': self.ls,
     'ls_cmd_names': self.ls_cmd_names,
     'init': self.init,
     'rename': self.rename,
    }[action]()

  def init(self):
    self.save()

  def save(self):
    with open(self.file_name, 'wb') as fout:
      pickle.dump(self.cmds, fout)

  def load(self):
    try:
      with open(self.file_name, 'rb') as fin:
        self.cmds = pickle.load(fin)
    except:
      self.cmds = {}


  @staticmethod
  def cmd_name():
    return argv[3] if len(argv) > 3 else ''

  @staticmethod
  def cmd():
    return ' '.join(argv[4:]) if len(argv) > 3 else ''

  @staticmethod
  def cmd_rename():
    return '' if len(argv) < 5 else argv[4]


  def delete(self):
    try:
      del self.cmds[self.cmd_name()]
      self.save()
    except KeyError:
      eprint('The key "{}" does not exist'.format(self.cmd_name()))

  def get(self):
    try:
      cmd = self.cmds[self.cmd_name()][0]
      self.cmds[self.cmd_name()] = (cmd, time())
      print(cmd)
      self.save()
    except KeyError:
      eprint('The key "{}" does not exist'.format(self.cmd_name()))

  def set(self):
    self.cmds[self.cmd_name()] = (self.cmd(), time())
    self.save()

  def rename(self):
    try:
      self.cmds[self.cmd_rename()] = self.cmds[self.cmd_name()]
      del self.cmds[self.cmd_name()]
      self.save()
    except KeyError:
      eprint('The key "{}" does not exist'.format(self.cmd_name()))

  def ls(self):
    cmds = []
    for (cmd_name, (cmd, last_used)) in self.cmds.items():
      cmds.append((-last_used, cmd_name, cmd))

    cmds.sort()

    mx = max([0] + [len(cmd_name) for _, cmd_name, _ in cmds]) + 1

    last_label = ''
    t = time()
    for last_used, cmd_name, cmd in cmds:
      days_ago = (t + last_used) / (60 * 60 * 24) # last_used was negative for sorting
      pretext = ''
      color = None
      if days_ago < 15/60/24:
        if last_label != 'recent':
          last_label = pretext = 'recent'
        color = yellow
      elif days_ago < 1/24:
        if last_label != 'last hour':
          last_label = pretext = 'last hour'
        color = green
      elif days_ago < 1:
        if last_label != 'last day':
          last_label = pretext = 'last day'
        color = blue
      elif days_ago < 14:
        if last_label != 'last two weeks':
          last_label = pretext = 'last two weeks'
        color = violet
      else:
        if last_label != 'old':
          last_label = pretext = 'old'
        color = red

      if pretext:
        print("{}{}{}".format(color, (' '+pretext).rjust(mx + 6, '~'), none))
      print("{0}({1}{2}{3}) {1}-->{3} {4}".format(" " * (mx - len(cmd_name)), color, cmd_name, none, cmd))

  def ls_cmd_names(self):
    cmds = []
    for cmd_name, (cmd, last_used) in self.cmds.items():
      cmds.append((-last_used, cmd_name, cmd))

    cmds.sort()
    for last_used, cmd_name, cmd in cmds:
      print(cmd_name)


CmdMark(argv[1], argv[2])
