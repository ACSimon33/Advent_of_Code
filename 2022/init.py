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
import glob
from pathlib import Path
import warnings

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
  type=int, default=0)
opts = parser.parse_args()

# ---------------------------------------------------------------------------- #
# Copy file
def _copy_file(filename):
  output_file = filename
  if opts.outplace:
    _path = Path(filename)
    output_file = "{0}_formatted{1}".format(_path.stem, _path.suffix)

  # Preprocess ...
  with open(filename, "r") as source:
    lines = source.readlines()
  with open(output_file, "w") as source:
    for line in lines:
      # ... comment out OpenMP pragmas
      line = re.sub(r'#pragma omp', '//#pragma omp', line)
      # ... comment out multiple case statements
      line = re.sub(r'case (.*?):( +)(.*):', 'case \\1: /*\\3:*/', line)
      source.write(line)

  clang_format_call = 'clang-format -i --Wno-error=unknown '
  if not opts.silent:
    clang_format_call += '--verbose '
  if opts.dry_run:
    clang_format_call += '--dry-run '
  if opts.Werror:
    clang_format_call += '--Werror '

  # Call clang-format (ignore interupt signals)
  result = run(
    clang_format_call + output_file,
    shell=True, stdout=PIPE, stderr=PIPE)

  # Postprocess ...
  lines = []
  with open(output_file, "r") as source:
    line = source.read().strip('\n')
    # global rexex
    if not opts.dry_run:
      a = re.findall(r'^( *),\n( *)(.*)', line, flags=re.MULTILINE)
      if len(a):
        line = re.sub(r'^( *),\n( *)(.*)', '\\1, \\3', line, flags=re.MULTILINE)
    lines = [s + '\n' for s in line.split('\n')] # split and readd '\n'

  with open(output_file, "w") as source:
    # single line regEx
    for line in lines:
      # ... comment in OpenMP pragmas
      line = re.sub(r'\/\/ *#pragma omp', '#pragma omp', line)
      # ... comment in multiple case statements
      line = re.sub(
        r'case (.*?):( +)\/\*case (.*?):\*\/', 'case \\1: case \\3:', line)
      source.write(line)

  # Atomic write
  sys.stdout.write(result.stderr.decode("utf-8"))

  # Return the exit code of clang-format
  return result.returncode

# Disable interrupt signals for workers
def init_worker():
  signal.signal(signal.SIGINT, signal.SIG_IGN)

# Gracefully shut down (wait for current jobs to finish)
def sigint_handler(executer, signum, frame):
  executer.shutdown(wait=True, cancel_futures=True)
  sys.exit(signal.SIGINT)

# ---------------------------------------------------------------------------- #
def main():
  # Format entire codebase
  if opts.all:
    repository_root = Path(__file__).parent.parent.resolve()
    c_files = os.path.join(repository_root, '*', '*.c')
    h_files = os.path.join(repository_root, '*', '*.h')
    opts.args = [c_files, h_files]

  # Check amount of jobs
  if int(opts.jobs) > os.cpu_count():
    warnings.warn('The amount of jobs is higher than the cpu core count.')

  # Create process pool (with custom signal handling for python >= 3.7)
  if (sys.version_info[1] >= 7):
    executer = ProcessPoolExecutor(int(opts.jobs), initializer=init_worker)
  else:
    executer = ProcessPoolExecutor(int(opts.jobs))
    warnings.warn(
      "Python < 3.7 -> Workers won't ignore interrupt signals! If you use "
      "CTRL+C to cancel the formatting you might end up with scrambled files.")

  if (sys.version_info[1] >= 9):
    signal.signal(signal.SIGINT, lambda s, f: sigint_handler(executer, s, f))

  # Submit formatting jobs
  future_results = []
  for arg in opts.args:
    for file in glob.glob(arg):
      future_results.append(executer.submit(_format_file, file))

  # Wait for all processes to finish and return exit code
  exit_code = 0
  for future in as_completed(future_results):
    exit_code = future.result() if exit_code == 0 else exit_code

  sys.exit(exit_code)

if __name__ == "__main__":
  main()
