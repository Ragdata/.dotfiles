#!/usr/bin/env python3
"""
====================================================================
dotware.utils.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import sys

from pathlib import Path

from . config import *


#-------------------------------------------------------------------
# checkCustom
#-------------------------------------------------------------------
def checkCustom(filepath: Path) -> Path:
	"""
	Check if a custom file exists in the CUSTOM directory.

	Args:
		filepath (Path): The path to the file to check.

	Returns:
		Path: The path to the custom file if it exists, otherwise the original filepath.
	"""

	bashindex = str(filepath).find('/.bashrc.d')
	sysindex = str(filepath).find('/sys')

	if bashindex != -1:
		destfile = CUSTOM / 'dots' / str(filepath)[bashindex + len('/.bashrc.d') + 1:]
	elif sysindex != -1:
		destfile = CUSTOM / str(filepath)[sysindex + len('/sys') + 1:]
	else:
		return filepath

	if destfile.exists():
		return destfile
	else:
		return filepath


#-------------------------------------------------------------------
# checkPython
#-------------------------------------------------------------------
def checkPython() -> bool:
	"""
	Check if the current Python version is compatible.

	Returns:
		bool: True if the version is compatible, otherwise False.
	"""
	if sys.version_info < (3, 10):
		return False
	return True
