#!/usr/bin/env python3

import sys

from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))


__pkg_name__ = "dotware"
__version__ = "0.1.0"


def version(output: bool = True):
	""" Print the package version """
	if output:
		# Print version to console
		print(f"{__pkg_name__.capitalize()} version {__version__}")
	else:
		# Return version string
		return f"{__version__}"

