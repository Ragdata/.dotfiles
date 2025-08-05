#!/usr/bin/env python3
"""
====================================================================
dotware.dotfiles.custom.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

from itertools import count
import subprocess, typer, shutil, os

import dotware.output as output

from pathlib import Path
from typing import Dict, List, Union, Optional
from typing_extensions import Annotated

from .. config import *
from . import logger, registry
from . install import skipfiles


outlog = output.OutLog(logger)


app = typer.Typer(rich_markup_mode="rich")


#-------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------
# scandir
#-------------------------------------------------------------------
def scandir(currdir: Path, currdict: Optional[Dict[str, List[Path]]] = None) -> Dict[str, List[Path]]:
	"""
	Scan the CUSTOM directory for custom dotfiles.

	Returns:
		list[Path]: A list of custom dotfiles found in the CUSTOM directory.
	"""
	# return [f for f in CUSTOM.glob('**/*') if f.is_file() and not f.name.startswith('.')]
	try:

		if currdict is None:
			currdict = {}

		dirs = [d for d in currdir.iterdir() if d.is_dir()]
		dirs.sort()
		# Process each subdirectory
		for dir in dirs:
			outlog.logPrint(f"Processing directory: {dir}", style="bold cyan")
			# Get all files in the directory
			files = [f for f in dir.iterdir() if f.is_file() and f.name not in skipfiles]
			files.sort()
			# Process each file
			pathFiles = []
			for file in files:
				# Store files
				pathFiles.append(file)
			# Recursively scan subdirectories
			currdict[str(dir)] = pathFiles
			scandir(dir, currdict)

	except Exception as e:
		outlog.logError(f"An error occurred while scanning the CUSTOM directory: {e}")
		raise e

	return currdict
#-------------------------------------------------------------------
# COMMANDS
#-------------------------------------------------------------------
@app.command()
def add(file: Annotated[Path, typer.Argument(help="Path to file being overridden")]) -> None:
	"""
	Add a custom dotfile.

	Args:
		file (Path): 	Path to the file being overridden
	"""
	try:

		if not file.exists():
			outlog.logError(f"Source file '{file}' does not exist.")
			return
		if not file.is_file():
			outlog.logError(f"Source path '{file}' is not a file.")
			return

		# Determine the custom path
		bashindex = str(file).find('/.bashrc.d')
		sysindex = str(file).find('/sys')

		if bashindex != -1:
			destfile = CUSTOM / 'dots' / str(file)[bashindex + len('/.bashrc.d') + 1:]
		elif sysindex != -1:
			destfile = CUSTOM / str(file)[sysindex + len('/sys') + 1:]

		# Ensure destination directory exists
		if not destfile.parent.exists():
			destfile.parent.mkdir(parents=True, exist_ok=True, mode=0o755)
			logger.debug(f"Created destination directory: {destfile.parent}")

		# If the destination file does not exist, copy the source file and open for editing
		if not destfile.exists():
			shutil.copy(file, destfile)
			outlog.logPrint(f"Added custom file: {destfile}", style="bold green")

		# Open the file in the default editor
		editor = os.environ.get('EDITOR', 'nano')
		subprocess.run([editor, destfile])

	except Exception as e:
		outlog.logError(f"An error occurred while adding the source file: {e}")
		return


@app.command()
def create(file: Annotated[Path, typer.Argument(help="Path to counterpart of new custom file")]) -> None:
	"""
	Create a new custom dotfile, links to its counterpart path, opens custom file for editing

	Args:
		file (Path): 	Path to the counterpart of the new custom file.
	"""
	try:

		# Determine the custom and backup paths
		bashindex = str(file).find('/.bashrc.d')
		sysindex = str(file).find('/sys')

		if bashindex != -1:
			destfile = CUSTOM / 'dots' / str(file)[bashindex + len('/.bashrc.d') + 1:]
			bakfile = SYSDIR / 'bak' / str(file)[bashindex + len('/.bashrc.d') + 1:]
		elif sysindex != -1:
			destfile = CUSTOM / str(file)[sysindex + len('/sys') + 1:]
			bakfile = SYSDIR / 'bak' / str(file)[sysindex + len('/sys') + 1:]

		if file.exists():
			# Ensure the backup directory exists
			if not bakfile.parent.exists():
				bakfile.parent.mkdir(parents=True, exist_ok=True, mode=0o755)
				logger.debug(f"Created backup directory: {bakfile.parent}")
			# Move the existing file to the backup directory
			shutil.move(file, bakfile)
			outlog.logPrint(f"Moved existing file to backup: {bakfile}", style="bold yellow")
		else:
			# Ensure the custom directory exists
			if not destfile.parent.exists():
				destfile.parent.mkdir(parents=True, exist_ok=True, mode=0o755)
				logger.debug(f"Created custom directory: {destfile.parent}")
			# Create an empty custom file
			destfile.touch()
			# Link the custom file to the counterpart path
			os.symlink(destfile, file)

			outlog.logPrint(f"Created and linked custom file: {destfile}", style="bold green")

		# Open the file in the default editor
		editor = os.environ.get('EDITOR', 'nano')
		subprocess.run([editor, destfile])

	except Exception as e:
		outlog.logError(f"An error occurred while creating the custom file: {e}")
		return


@app.command()
def edit(file: Annotated[Path, typer.Argument(help="Path to custom file")]) -> None:
	"""
	Edit a custom dotfile at the specified destination

	Args:
		file (Path): 	The path to the custom dotfile.
	"""
	try:

		if not file.exists():
			outlog.logError(f"Source file '{file}' does not exist.")
			return

		editor = os.environ.get('EDITOR', 'nano')

		subprocess.run([editor, file])

	except Exception as e:
		outlog.logError(f"An error occurred while editing the custom file: {e}")
		raise e


@app.command()
def remove(file: Annotated[Path, typer.Argument(help="Path to custom file")]) -> None:
	"""
	Remove a custom dotfile.

	Args:
		file (Path): The path of the custom dotfile to remove.
	"""
	try:

		if not file.exists():
			outlog.logError(f"Custom file '{file}' does not exist.")
			return

		# Determine the counterpart path
		index = str(file).find('/dots')

		if index != -1:
			dotindex = str(file).find('/.dotfiles')
			counterpart = SYSDIR / str(file)[dotindex + len('/.dotfiles') + 1:]
		else:
			dotindex = str(file).find('/sys')
			counterpart = Path(str(file).replace(str(CUSTOM), str(SYSDIR)))

		if counterpart.exists():
			if counterpart.is_file():
				os.remove(counterpart)
				outlog.logPrint(f"Removed counterpart file: {counterpart}", style="bold green")
			elif counterpart.is_symlink():
				counterpart.unlink()
				outlog.logPrint(f"Removed symlink: {counterpart}", style="bold green")
			else:
				outlog.logError(f"Counterpart '{counterpart}' is not a file or symlink.")
				return

		# Remove the custom file
		if file.exists():
			os.remove(file)
			outlog.logPrint(f"Removed custom file: {file}", style="bold green")

	except Exception as e:
		outlog.logError(f"An error occurred while removing the custom file: {e}")
		raise e


@app.command()
def suspend(file: Annotated[Path, typer.Argument(help="Path to custom file")]) -> None:
	"""
	Suspend a custom dotfile.

	Args:
		name (str): The name of the custom dotfile to suspend.
	"""
	try:

		if not file.exists():
			outlog.logError(f"Custom file '{file}' does not exist.")
			return

		# Determine the counterpart path
		index = str(file).find('/dots')

		if index != -1:
			dotindex = str(file).find('/.dotfiles')
			counterpart = SYSDIR / str(file)[dotindex + len('/.dotfiles') + 1:]
		else:
			dotindex = str(file).find('/sys')
			counterpart = Path(str(file).replace(str(CUSTOM), str(SYSDIR)))

		if counterpart.exists():
			os.rename(counterpart, counterpart.with_suffix('.suspended'))
			outlog.logPrint(f"Suspended counterpart file: {counterpart}", style="bold yellow")

		# Suspend the custom file
		if file.exists():
			file.rename(file.with_suffix('.suspended'))
			outlog.logPrint(f"Suspended custom file: {file}", style="bold yellow")

	except Exception as e:
		outlog.logError(f"An error occurred while suspending the custom file: {e}")
		raise e


@app.command()
def restore(file: Annotated[Path, typer.Argument(help="Path to custom file once restored")]) -> None:
	"""
	Restore a suspended custom dotfile.

	Args:
		name (str): The name of the custom dotfile to restore.
	"""
	try:

		if not file.suffix == '.suspended':
			file = file.with_suffix('.suspended')

		if not file.exists():
			outlog.logError(f"Suspended custom file '{file}' does not exist.")
			return

		# Determine the counterpart path
		index = str(file).find('/dots')

		if index != -1:
			dotindex = str(file).find('/.dotfiles')
			counterpart = SYSDIR / str(file)[dotindex + len('/.dotfiles') + 1:]
		else:
			dotindex = str(file).find('/sys')
			counterpart = Path(str(file).replace(str(CUSTOM), str(SYSDIR)))

		if not counterpart.suffix == '.suspended':
			counterpart = counterpart.with_suffix('.suspended')

		if counterpart.exists():
			os.rename(counterpart, counterpart.with_suffix(''))
			outlog.logPrint(f"Restored counterpart file: {counterpart}", style="bold green")

		# Restore the custom file
		if file.exists():
			file.rename(file.with_suffix(''))
			outlog.logPrint(f"Restored custom file: {file}", style="bold green")

	except Exception as e:
		outlog.logError(f"An error occurred while restoring the custom file: {e}")
		raise e


@app.command()
def show(
	directory: Annotated[Path, typer.Argument(help="Directory to scan for files")] = CUSTOM,
	active: Annotated[bool, typer.Option("--active", "-a", help="Show active custom files", rich_help_panel="Filters")] = True,
	suspended: Annotated[bool, typer.Option("--suspended", "-s", help="Show suspended custom files", rich_help_panel="Filters")] = False,
	recurse: Annotated[bool, typer.Option("--recurse", "-r", help="Recurse into all directories", rich_help_panel="Filters")] = True
) -> None:
	"""
	List all custom dotfiles.
	"""
	try:

		customfiles = {}

		customfiles[str(CUSTOM), scandir(CUSTOM)]

	except Exception as e:
		outlog.logError(f"An error occurred while showing custom files: {e}")
		raise e


if __name__ == "__main__":
	app()
