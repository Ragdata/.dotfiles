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
from typing import Dict, List, Union, Optional

from .. config import *
from . import logger, registry


skipfiles = [".gitkeep"]


outlog = output.OutLog(logger)

dotdirs = [
	('dots', Path.home()),
	('dots/.bashrc.d', Path.home() / '.bashrc.d'),
	('dots/.bashrc.d/prompts', Path.home() / '.bashrc.d/prompts')
]


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
# _linkdots
#-------------------------------------------------------------------
def linkdots() -> None:
	"""
	Link dotfiles and custom overrides to the system directories
	"""
	try:

		outlog.logPrint(f"Linking dotfiles...", style="bold yellow")

		for dotdir, dest in dotdirs:
			logger.debug(f"Processing dotdir: {dotdir} -> {dest}")
			dotsrc = REPOSRT / dotdir
			dotdest = SRTDIR / dotdir
			logger.debug(f"Source -> Dest: {dotsrc} -> {dotdest}")

			if not dotsrc.exists():
				outlog.logError(f"Source directory does not exist: {dotsrc}")
				raise FileNotFoundError(f"Source directory does not exist: {dotsrc}")
			if not dotdest.exists():
				logger.debug(f"Creating destination directory: {dotdest}")
				dotdest.mkdir(parents=True, exist_ok=True, mode=0o755)
			if not dest.exists():
				logger.debug(f"Creating destination directory: {dest}")
				dest.mkdir(parents=True, exist_ok=True, mode=0o755)

			files = [f for f in dotsrc.iterdir() if f.is_file() and f.name not in skipfiles]
			files.sort()
			for file in files:
				logger.debug(f"Processing file: {file.name}")
				destfile = dest / file.name
				srcfile = utils.checkCustom(file)

				if 'custom' in str(srcfile):
					outlog.logPrint(f"Linking custom file: {srcfile}", style="bold white")
					_linkfile(srcfile, destfile)
				else:
					outlog.logPrint(f"Installing file: {file.name} to {destfile}")
					shutil.copy(file, destfile)

	except Exception as e:
		logger.error(f"Failed to link dotfiles: {e}")
		raise


#-------------------------------------------------------------------
# _linkfile
#-------------------------------------------------------------------
def _linkfile(src: Path, dest: Path) -> None:
	"""
	Create a symbolic link from the source file to the destination.

	Args:
		src (Path): The source file to link.
		dest (Path): The destination where the link will be created.
	"""
	try:
		if not src.exists():
			outlog.logWarning(f"Source file '{src}' does not exist, skipping.")
			return

		if dest.exists():
			dest.unlink()
			logger.debug(f"Removed existing file: {dest}")

		dest.symlink_to(src)
		outlog.logPrint(f"Linked {src} -> {dest}", style="bold green")
	except Exception as e:
		outlog.logError(f"Failed to link file {src} to {dest}: {e}")
		raise


#-------------------------------------------------------------------
# _scandir
#-------------------------------------------------------------------
def _scandir(currdir: Path, currDict: Optional[Dict[str, List[Path]]] = None) -> None:
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
			relativePath = str(dir).replace(str(SRTDIR), "")
			installPath = SRTDIR / relativePath
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
	"""
	Command-line interface for installing dotfiles.
	"""
	try:

		output.line()

		if not utils.checkPython():
			output.printError("Python version 3.10 or higher is required")
			sys.exit(1)

		filepath = Path(__file__).resolve()

		if str(REPODIR).find(str(BASEDIR)) != -1:
			outlog.logError("Install script must be run from the repository directory")
			sys.exit(1)

		outlog.logPrint("Installing dotfiles...", style="bold yellow")

		_scandir(REPOSRT)

		linkdots()

		outlog.logPrint("Dotfiles installed successfully", style="bold green")

	except Exception as e:
		outlog.logError(f"Failed to install dotfiles: {e}")
		raise
