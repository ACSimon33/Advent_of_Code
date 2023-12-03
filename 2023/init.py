#! /usr/bin/env python3
"""init.py.

Initializer script for Advent of Code 2023. Initializes a new day from
the template in 00/kotlin_template and adds a new subproject to the
settings.gradle.kts file in the root project.
"""
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
TEMPLATE_NAME = "Kotlin Template"

# -------------------------------------------------------------------- #


def get_day(day: int) -> str:
    """Get a two-digit day string.

    Args:
        day (int): Given or the next day.

    Returns:
        str: The two-digit day string.
    """
    day_str = "0" if day <= 9 else ""
    day_str += str(day)
    return day_str


def snake_case(name: str) -> str:
    """Get snake case string.

    Args:
        name (str): A string.

    Returns:
        str: A snake case version of the given string.
    """
    name_parts = name.lower().split(" ")
    return "_".join(name_parts)


def pascal_case(name: str) -> str:
    """Get PascalCase string.

    Args:
        name (str): A string.

    Returns:
        str: A PascalCase version of the given string.
    """
    name_parts = name.lower().split(" ")
    for i in range(len(name_parts)):
        name_parts[i] = name_parts[i].capitalize()
    return "".join(name_parts)


def camel_case(name: str) -> str:
    """Get camelCase string.

    Args:
        name (str): A string.

    Returns:
        str: A camelCase version of the given string.
    """
    name_parts = name.lower().split(" ")
    for i in range(len(name_parts)):
        if i > 0:
            name_parts[i] = name_parts[i].capitalize()
    return "".join(name_parts)


def get_day_folder(day: int, name: str | None = None) -> Path:
    """Get the folder name for a given day.

    Args:
        day (int): The new day.
        name (str | None, optional): The project name. Defaults to None.

    Returns:
        Path: The path to the subproject.
    """
    day_folder = Path(get_day(day))
    if name:
        day_folder /= snake_case(name)

    return Path(__file__).parent / day_folder


def find_next_day() -> int:
    """Find the next day if no day was given.

    Returns:
        int: The next uninitialized day.
    """
    day = 1
    while get_day_folder(day).exists():
        day += 1
    return day


# -------------------------------------------------------------------- #

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
    default=find_next_day(),
)
opts = parser.parse_args()

# -------------------------------------------------------------------- #


def search_and_replace(day: int, name: str, contents: str) -> str:
    """Search and Replace day and project name.

    Searches for the template project name and the day in different
    naming styles and replaces them with the given / next day and given
    project name.

    Args:
        day (int): The new day (replacement for 00 in the template)
        name (str): The project name (replacement for the template name)
        contents (str): The template project file contents

    Returns:
        str: The file contents of the new subproject
    """
    contents = re.sub(get_day(TEMPLATE_DAY), get_day(day), contents)
    contents = re.sub(TEMPLATE_NAME, name, contents)
    contents = re.sub(snake_case(TEMPLATE_NAME), snake_case(name), contents)
    contents = re.sub(pascal_case(TEMPLATE_NAME), pascal_case(name), contents)
    contents = re.sub(camel_case(TEMPLATE_NAME), camel_case(name), contents)
    return contents


def init_project(
    day: int,
    name: str,
) -> None:
    """Initialize a new subproject from the template.

    Walk through each file in the template project and replace the day
    and project name.

    Args:
        day (int): The new day (replacement for 00 in the template)
        name (str): The project name (replacement for the template name)
    """
    source = get_day_folder(TEMPLATE_DAY, TEMPLATE_NAME).as_posix()
    destination = get_day_folder(day, name).as_posix()

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


def subproject_registration() -> str:
    """Generate a subproject string.

    Generate a subproject string which registers the subproject in the
    root project (settings.gradle.kts).

    Returns:
        str: The subproject registration string
    """
    subproject = 'include("'
    subproject += get_day(opts.day) + ":"
    subproject += snake_case(opts.name) + '")\n'
    return subproject


# -------------------------------------------------------------------- #


def main() -> int:
    """Execute subproject initialization.

    Raises:
        RuntimeError: If the day is not between 1 and 25.
        RuntimeError: If there is already a project for the given day.

    Returns:
        int: System exit code.
    """
    # Check day
    if opts.day < 1 or opts.day > 25:
        raise RuntimeError("Day needs to be between 1 and 25.")

    # Test if folder already exists
    folder = get_day_folder(opts.day)
    if folder.exists():
        raise RuntimeError("Day '{0}' already exists.".format(folder))

    # Initialize project
    init_project(opts.day, opts.name)

    # Initialize as a subproject
    package_file = Path(__file__).parent / "settings.gradle.kts"
    config: list[str] = []
    with open(package_file, "r") as file:
        last_line_matched = False
        subproject_added = False
        for line in file.readlines():
            if not subproject_added:
                subproject_added = last_line_matched
                m = re.match(r'include\("([0-9]{2}):([a-z_]*)"\)', line)
                if m and len(m.groups()) == 2:
                    last_line_matched = True
                    subproject_added = int(m.group(1)) > opts.day

                # Add subproject if the day of the next entry is larger
                # or if this is the last entry in the subproject list
                if subproject_added:
                    config.append(subproject_registration())

            config.append(line)

        # Add subproject entry at the end of the file
        if last_line_matched and not subproject_added:
            config.append(subproject_registration())

    with open(package_file, "w") as file:
        file.writelines(config)

    return 0


if __name__ == "__main__":
    sys.exit(main())
