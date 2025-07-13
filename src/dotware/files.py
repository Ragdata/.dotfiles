#!/usr/bin/env python3
####################################################################
# dotware.files.py
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

from datetime import datetime
from pathlib import Path
from typing import Optional

from dotware.config import *
from dotware.logger import logger


def backupFile(filepath: Path, backupdir: Path = BACKUP) -> bool:
	""" Backup a file to the backup directory """
	if not filepath.exists():
		raise FileNotFoundError(f"File '{filepath}' does not exist.")

	if not backupdir.exists():
		makedir(backupdir)

	now = datetime.now()

	bakfile = f"{filepath.name}.bak.{now.timestamp()}"

	backupfile = backupdir / bakfile

	try:
		shutil.copy2(filepath, backupfile)
	except Exception as e:
		raise RuntimeError(f"Failed to backup file '{filepath}': {e}")

	return True


def checkCustom(filepath: Path) -> str:
	""" Check for overriding files in the custom directory """

	index = str(filepath).find('/.dotfiles')
	if index != -1:
		relativePath = str(filepath)[index + len('/.dotfiles') + 1:]
		logger.debug(f"Checking for custom override: {relativePath}")
	else:
		relativePath = ""

	customfile = CUSTOM / relativePath

	if customfile.exists():
		logger.debug(f"Custom override found: {customfile}")
		return str(customfile)
	else:
		return str(filepath)


def grepFile(filepath: Path, pattern: str) -> bool:
	""" Search for a pattern in a file and return True if found """
	if not filepath.exists():
		raise FileNotFoundError(f"File '{filepath}' does not exist.")

	try:
		with open(filepath, 'r') as f:
			for line in f:
				if pattern in line:
					logger.debug(f"Pattern '{pattern}' found in file '{filepath}'.")
					return True
	except Exception as e:
		raise RuntimeError(f"Failed to read file '{filepath}': {e}")

	logger.debug(f"Pattern '{pattern}' not found in file '{filepath}'.")
	return False


def makedir(dir: Path, perms: int = 0o755) -> int:
	""" Helper function to make directories and set permissions """
	try:
		if dir.exists():
			return True
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
