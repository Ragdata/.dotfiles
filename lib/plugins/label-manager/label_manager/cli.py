####################################################################
# label_manager.cli.py
####################################################################
# GitHub Repository Label Manager
#
# File:         cli.py
# Package:      label_manager
# Author:       Ragdata
# Date:         14/10/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
import argparse

from pathlib import Path

def _parser() -> argparse.ArgumentParser:

    parser = argparse.ArgumentParser(
        prog="label_manager",
        description="Manage GitHub Repository Labels",
        add_help=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )

    flags = parser.add_argument_group('flags')
    flags_mex = flags.add_mutually_exclusive_group()
    options = parser.add_argument_group('options')

    parser.add_argument('action', type=str, nargs='?', help='Action to perform')

    flags_mex.add_argument('-h', '--help', action='help', help='Show this help message and exit')
    flags_mex.add_argument('-V', '--version', action='version', version='%(prog)s ver 0.1.0', help='Display module version and exit')

    options.add_argument('-t', '--token', help='GitHub Token or path to file containing token (required if no GITHUB_ACCESS_TOKEN environment variable)')
    options.add_argument('-f', '--file', type=Path, help='Path to file required by action (required for "dump", "update", and "validate" actions)')
    options.add_argument('-o', '--owner', type=str, help='Specify user / organisation')
    options.add_argument('-r', '--repo', type=str, help='Specify repository name')

    return parser

def _process_args() -> None:

    parser: argparse.ArgumentParser = _parser()
    args: argparse.Namespace = parser.parse_args()

    match args.action:
        case "clear":
            print('clear')
        case "config":
            print('config')
        case "dump":
            print('dump')
        case "get":
            print('get')
        case "update":
            print('update')
        case "validate":
            print('validate')

def run() -> None:
    _process_args()

if __name__ == '__main__':
    run()
