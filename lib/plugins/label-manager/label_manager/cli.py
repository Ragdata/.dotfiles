import argparse
import pathlib
import logging
import random
import json
import sys
import os
import re

from label_manager import manager, msg

def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="label_manager",
        description="Manage labels for a GitHub Repository",
        add_help=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )

    flags = parser.add_argument_group('flags')
    flags_mex = flags.add_mutually_exclusive_group()
    optional = parser.add_argument_group('optional')
    required = parser.add_argument_group('required')

    # cli flags
    flags_mex.add_argument('-h', '--help', action='help', help='Show this help message and exit')
    flags_mex.add_argument('-V', '--version', action='version', version="%(prog)s v0.1.0", help='Display module version and exit')
    flags_mex.add_argument('-v', '--validate', action='store_true', help='Validate local label definitions')

    # optional arguments
    optional.add_argument('-t', '--token', type=str, help='GitHub Token (required if not specified as GITHUB_ACCESS_TOKEN environment variable or as a file')
    optional.add_argument('-T', '--token-file', type=str, help='Path to file containing GitHub Token')
    optional.add_argument('-f', '--file', type=pathlib.Path, help='Path to file required for action (required when using "dump" or "update" action commands)')

    # required arguments
    required.add_argument('-o', '--owner', type=str, help='Specify user / organisation who owns the repository')
    required.add_argument('-r', '--repo', type=str, help='Specify name of the repository')

    parser.add_argument('action', type=str, choices=['clear', 'config', 'dump', 'get', 'update'], help='Action to perform')

    return parser

def _process_args() -> None:
    parser: argparse.ArgumentParser = _parser()
    args: argparse.Namespace = parser.parse_args()

def run() -> None:
    _process_args()

if __name__ == "__main__":
    run()
