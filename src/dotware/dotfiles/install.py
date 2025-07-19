#!/usr/bin/env python3
####################################################################
# dotware.dotfiles.cli.py
####################################################################
# Author:       Ragdata
# Date:         19/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import shutil, sys, os

import dotware.output as output
import dotware.utils as utils

from pathlib import Path
from typing import Union

from dotware.config import *
from dotware.dotfiles import logger, registry


skipfiles = [".gitkeep"]


outlog = output.OutLog(logger)


#-------------------------------------------------------------------
# _install
#-------------------------------------------------------------------
def _install(file: Path, dest: Path) -> None:
	"""
	Copy a file to the destination directory.

	Args:
		file (Path): The source file to copy.
		dest (Path): The destination directory.
	"""
	try:
		if not file.exists():
			outlog.logWarning(f"Source file '{file}' does not exist, skipping.")
			return

		if not dest.exists():
			dest.mkdir(parents=True, exist_ok=True, mode=0o755)
			logger.debug(f"Created destination directory: {dest}")

		filedest = dest / file.name

		installed = shutil.copy(file, filedest)

		outlog.logPrint(f"Installed {file} -> {installed}", style="bold green")

	except Exception as e:
		logger.error(f"Failed to install file {file}: {e}")
		raise


#-------------------------------------------------------------------
# _scandir
#-------------------------------------------------------------------
def _scandir(currdir: Path) -> None:
	"""
	Recursively scan the current directory for files and directories.

	Args:
		currdir (Path): The current directory to scan.
	"""
	try:
		# Get all subdirectories in the current directory
		dirs = [d for d in currdir.iterdir() if d.is_dir()]
		dirs.sort()
		# Process each subdirectory
		for dir in dirs:
			outlog.logPrint(f"Processing directory: {dir}", style="bold cyan")
			# Determine the relative path for installation
			index = str(dir).find('/sys')
			if index != -1:
				relativePath = str(dir)[index + len('/sys') + 1:]
				logger.debug(f"Relative path: {relativePath}")
			else:
				relativePath = ""
			installPath = SYSDIR / relativePath
			logger.debug(f"Install path: {installPath}")
			# Get all files in the directory, excluding skipfiles
			files = [f for f in dir.iterdir() if f.is_file() and f.name not in skipfiles]
			files.sort()
			# Process each file in the directory
			for file in files:
				outlog.logPrint(f"Processing file: {file}")
				# Install the file to the destination directory
				_install(file, installPath)
			# Recursively scan subdirectories
			_scandir(dir)
	except Exception as e:
		logger.error(f"Error processing directory {currdir}: {e}")
		raise


#-------------------------------------------------------------------
# cmd
#-------------------------------------------------------------------
def cmd() -> None:


	output.line()

	if not utils.checkPython():
		output.printError("Python version 3.10 or higher is required")
		sys.exit(1)

	outlog.logPrint("Installing dotfiles...", style="bold yellow")


	_scandir(SYSDIR)


	outlog.logPrint("Dotfiles installed successfully", style="bold green")


