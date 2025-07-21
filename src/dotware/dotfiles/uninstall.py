#!/usr/bin/env python3
####################################################################
# dotware.dotfiles.uninstall.py
####################################################################
# Author:       Ragdata
# Date:         19/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import shutil, os

import dotware.output as output

from pathlib import Path

from .. config import *
from . import logger, registry


outlog = output.OutLog(logger)


#-------------------------------------------------------------------
# cmd
#-------------------------------------------------------------------
def cmd() -> None:
	"""
	Uninstall dotfiles
	"""
	try:

		shutil.rmtree(BASEDIR)
		shutil.rmtree(BASHRCD)
		os.remove(Path.home() / '.bashrc')
		os.remove(Path.home() / '.profile')

		shutil.copy(REPODIR / 'sys' / 'bak' / '.bashrc', Path.home() / '.bashrc')
		shutil.copy(REPODIR / 'sys' / 'bak' / '.profile', Path.home() / '.profile')

	except Exception as e:
		outlog.logError(f"An error occurred during uninstallation: {e}")
		raise e

	outlog.logSuccess("Uninstallation completed successfully.")
