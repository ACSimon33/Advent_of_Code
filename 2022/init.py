#!/usr/bin/env python3

description = '''
Initializes a new day from the template in 00/typescript_template.'''

help = '''\
----------------------------------------------------------------------
Example uses:

  init.py --name <name>
    Initializes the next uninitialized day.

  init.py --name <name> --day <day>
    Initializes the next uninitialized day.

'''

import os
import re
import sys
import argparse
from pathlib import Path

TEMPLATE_DAY = 0
TEMPLATE_PROJECT = "Typescript Template"

# ---------------------------------------------------------------------------- #
# Get day string
def _get_day(day: int) -> str:
  day_str = '0' if day <= 9 else ''
  day_str += str(day)
  return day_str

# Get lowercase name string
def _get_lower(name: str) -> str:
  return re.sub(' ', '_', name.lower())

# Get the folder name for a given day
def _get_day_folder(day: int, name: str = None) -> Path:
  day_folder = _get_day(day)
  if name:
    day_folder = os.path.join(day_folder, _get_lower(name))

  return Path(os.path.join(Path(__file__).parent, day_folder))

# Find next day
def _find_next_day() -> int:
  day = 1
  while _get_day_folder(day).exists():
    day += 1
  return day

# ---------------------------------------------------------------------------- #
# Command line options
parser = argparse.ArgumentParser(
  formatter_class=argparse.RawDescriptionHelpFormatter,
  description=description, epilog=help)

parser.add_argument(
  '-n', '--name', action='store', help='Name of the subproject',
  required=True)
parser.add_argument(
  '-d', '--day', action='store', help='The number of the day',
  type=int, default=_find_next_day())
opts = parser.parse_args()

# ---------------------------------------------------------------------------- #
# Search and Replace
def search_and_replace(day: int, name: str, contents: str) -> str:
  contents = re.sub(_get_day(TEMPLATE_DAY), _get_day(day), contents)
  contents = re.sub(TEMPLATE_PROJECT, name, contents)
  contents = re.sub(_get_lower(TEMPLATE_PROJECT), _get_lower(name), contents)
  return contents

# Initialize project from template
def init_project(day: int, name: str,) -> None:
  source = _get_day_folder(TEMPLATE_DAY, TEMPLATE_PROJECT)
  destination = _get_day_folder(day, name)

  for (dirpath, _, files) in os.walk(source):
    output_dir = re.sub(str(source), str(destination), str(dirpath))
    os.makedirs(output_dir)

    for filename in files:
      input = os.path.join(dirpath, filename)
      with open(input, 'r') as file:
        contents = file.read()

      output = os.path.join(output_dir, search_and_replace(day, name, filename))
      with open(output, 'w') as file:
        file.write(search_and_replace(day, name, contents))

# ---------------------------------------------------------------------------- #
def main():
  # Check day
  if opts.day < 1 or opts.day > 25:
    raise RuntimeError('Day needs to be between 1 and 25.')

  # Test if folder already exists
  folder = _get_day_folder(opts.day)
  if folder.exists():
    raise RuntimeError("Day '{0}' already exists.".format(folder))

  # Initilaize project
  init_project(opts.day, opts.name)

  # Initialize as workspace
  package_file = os.path.join(Path(__file__).parent, 'package.json')
  config = []
  with open(package_file, 'r') as file:
    last_line_matched = False
    add_workspace = False
    for line in file.readlines():
      if not add_workspace:
        add_workspace = last_line_matched
        m = re.match('    "([0-9]{2})\/([a-z_]*)"', line)
        if m and len(m.groups()) == 2:
          last_line_matched = True
          add_workspace = (int(m.group(1)) > opts.day)

        # Add workspace if the day of the next entry is larger or if this
        # is the last entry in the workspace list
        if add_workspace:
          workspace = 4 * ' ' + '"'
          workspace += _get_day(opts.day) + '/' + _get_lower(opts.name)
          workspace += '"'

          # Insert missing comma
          if m and len(m.groups()) == 2:
            workspace += ','
          else:
            config[-1] = re.sub('\n', ',\n', config[-1])

          workspace += '\n'
          config.append(workspace)

      config.append(line)

  with open(package_file, 'w') as file:
    file.writelines(config)

  sys.exit(0)

if __name__ == "__main__":
  main()
