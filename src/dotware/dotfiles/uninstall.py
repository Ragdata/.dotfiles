#!/usr/bin/env python3
"""
====================================================================
dotware.dotfiles.uninstall.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

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

		bashrc = Path.home() / '.bashrc'
		profile = Path.home() / '.profile'

		if BASEDIR.exists():
			shutil.rmtree(BASEDIR)
		if BASHRCD.exists():
			shutil.rmtree(BASHRCD)
		if bashrc.exists():
			os.remove(bashrc)
			shutil.copy(REPODIR / 'sys' / 'bak' / '.bashrc', Path.home() / '.bashrc')
		if profile.exists():
			os.remove(profile)
			shutil.copy(REPODIR / 'sys' / 'bak' / '.profile', Path.home() / '.profile')

	except Exception as e:
		outlog.logError(f"An error occurred during uninstallation: {e}")


	outlog.logSuccess("Uninstallation completed successfully.")
