import argparse
import logging
import json
import sys
import os

from label_manager import msg

def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="label_manager",
        description="Manage labels for a GitHub Repository",
        add_help=False,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter
    )

    flags = parser.add_mutually_exclusive_group()

    # cli flags
    flags.add_argument('-h', '--help', action='help', help='Show this help message and exit')
    flags.add_argument('-V', '--version', action='version', version="%(prog)s v0.1.0", help='Display module version and exit')
    flags.add_argument('-v', '--validate', action='store_true', help='Validate local label definitions')

    return parser

def _process_args() -> None:
    parser: argparse.ArgumentParser = _parser()
    args: argparse.Namespace = parser.parse_args()

def run():
    _process_args()

if __name__ == "__main__":
    run()
