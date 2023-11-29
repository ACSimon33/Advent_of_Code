#!/usr/bin/env python3
from __future__ import annotations

import os
import re
import sys
import argparse
from pathlib import Path

description = """
Initializes a new day from the template in 00/kotlin_template."""

help = """\
----------------------------------------------------------------------
Example uses:

  init.py --name <name>
    Initializes the next uninitialized day.

  init.py --name <name> --day <day>
    Initializes a given day.

"""

TEMPLATE_DAY = 0
TEMPLATE_PROJECT = "Kotlin Template"

# --------------------------------------------------------------------------- #


# Get day string
def _get_day(day: int) -> str:
    day_str = "0" if day <= 9 else ""
    day_str += str(day)
    return day_str


# Get snake case name string
def _snake_case(name: str) -> str:
    name_parts = name.lower().split(" ")
    return "_".join(name_parts)


# Get PascalCase name string
def _pascal_case(name: str) -> str:
    name_parts = name.lower().split(" ")
    for i in range(len(name_parts)):
        name_parts[i] = name_parts[i].capitalize()
    return "".join(name_parts)


# Get camelCase name string
def _camel_case(name: str) -> str:
    name_parts = name.lower().split(" ")
    for i in range(len(name_parts)):
        if i > 0:
            name_parts[i] = name_parts[i].capitalize()
    return "".join(name_parts)


# Get the folder name for a given day
def _get_day_folder(day: int, name: str | None = None) -> Path:
    day_folder = Path(_get_day(day))
    if name:
        day_folder /= _snake_case(name)

    return Path(__file__).parent / day_folder


# Find next day
def _find_next_day() -> int:
    day = 1
    while _get_day_folder(day).exists():
        day += 1
    return day


# --------------------------------------------------------------------------- #

# Command line options
parser = argparse.ArgumentParser(
    formatter_class=argparse.RawDescriptionHelpFormatter,
    description=description,
    epilog=help,
)

parser.add_argument(
    "-n",
    "--name",
    action="store",
    help="Name of the subproject",
    required=True,
)
parser.add_argument(
    "-d",
    "--day",
    action="store",
    help="The number of the day",
    type=int,
    default=_find_next_day(),
)
opts = parser.parse_args()

# --------------------------------------------------------------------------- #


# Search and Replace
def search_and_replace(day: int, name: str, contents: str) -> str:
    contents = re.sub(_get_day(TEMPLATE_DAY), _get_day(day), contents)
    contents = re.sub(TEMPLATE_PROJECT, name, contents)
    contents = re.sub(
        _snake_case(TEMPLATE_PROJECT), _snake_case(name), contents
    )
    contents = re.sub(
        _pascal_case(TEMPLATE_PROJECT), _pascal_case(name), contents
    )
    contents = re.sub(
        _camel_case(TEMPLATE_PROJECT), _camel_case(name), contents
    )
    return contents


# Initialize project from template
def init_project(
    day: int,
    name: str,
) -> None:
    source = _get_day_folder(TEMPLATE_DAY, TEMPLATE_PROJECT).as_posix()
    destination = _get_day_folder(day, name).as_posix()

    for dirpath, _, files in os.walk(source):
        output_dir = re.sub(source, destination, Path(dirpath).as_posix())
        output_dir = search_and_replace(day, name, output_dir)
        os.makedirs(output_dir)

        for filename in files:
            input = Path(dirpath) / filename
            with open(input, "r") as file:
                contents = file.read()

            output = Path(output_dir) / search_and_replace(day, name, filename)
            with open(output, "w") as file:
                file.write(search_and_replace(day, name, contents))


# --------------------------------------------------------------------------- #
def main() -> None:
    # Check day
    if opts.day < 1 or opts.day > 25:
        raise RuntimeError("Day needs to be between 1 and 25.")

    # Test if folder already exists
    folder = _get_day_folder(opts.day)
    if folder.exists():
        raise RuntimeError("Day '{0}' already exists.".format(folder))

    # Initilaize project
    init_project(opts.day, opts.name)

    # Initialize as subproject
    package_file = Path(__file__).parent / "settings.gradle.kts"
    config: list[str] = []
    with open(package_file, "r") as file:
        last_line_matched = False
        add_workspace = False
        for line in file.readlines():
            print(line)
            if not add_workspace:
                add_workspace = last_line_matched
                m = re.match(r'include\("([0-9]{2}):([a-z_]*)"\)', line)
                if m and len(m.groups()) == 2:
                    print("lol")
                    last_line_matched = True
                    add_workspace = int(m.group(1)) > opts.day

                # Add workspace if the day of the next entry is larger
                # or if this is the last entry in the workspace list
                if add_workspace:
                    workspace = 'include("'
                    workspace += _get_day(opts.day) + ':'
                    workspace += _snake_case(opts.name) + '")\n'
                    config.append(workspace)

            config.append(line)

    with open(package_file, "w") as file:
        file.writelines(config)

    sys.exit(0)


if __name__ == "__main__":
    main()
