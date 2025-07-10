#!/usr/bin/env python3
####################################################################
# dotlib.files.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import os
import sys
import shutil
import logging

from pathlib import Path
from typing import Optional

from dotware.config import *



def checkCustom(filepath: Path, logger: Optional[logging.Logger] = None) -> str:
	""" Check for overriding files in the custom directory """

	index = str(filepath).find('/.dotfiles')
	if index != -1:
		relativePath = str(filepath)[index + len('/.dotfiles') + 1:]
		# if logger:
		# 	logger.debug(f"Checking for custom override: {relativePath}")
	else:
		relativePath = ""

	customfile = CUSTOM / relativePath

	if customfile.exists():
		return str(customfile)
	else:
		return str(filepath)


def makedir(dir: Path, perms: int = 0o755) -> int:
	""" Helper function to make directories and set permissions """
	try:
		if dir.exists():
			return 0
		dir.mkdir(parents=True, exist_ok=True)
		dir.chmod(perms)
	except Exception as e:
		raise
	return True


def pathReplace(value: str, filepath: str):
	""" Replace a value in a BASH PATH with the given value """
	filepath = os.path.expanduser(filepath)

	if not os.path.exists(filepath):
		raise FileNotFoundError(f"Path '{filepath}' does not exist.")

	lines = []
	found = False
	with open(filepath, 'r') as f:
		for line in f:
			if line.strip().startswith("export PATH=") or line.strip().startswith("PATH="):
				lines.append(f"export PATH={value}\n")
				found = True
			else:
				lines.append(line)
	if not found:
		lines.append(f"\nexport PATH={value}\n")

	with open(filepath, 'w') as f:
		f.writelines(lines)

	return True
