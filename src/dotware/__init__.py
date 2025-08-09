#!/usr/bin/env python3
"""
====================================================================
Package: dotware
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import sys, typer, typer.core, re

from pathlib import Path
from typing import Union

from . config import *
from . registry import Registry
from . logger import Logger, initRotatingFileHandler

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))


__pkg_name__ = "dotware"
__version__ = "0.1.0"


#-------------------------------------------------------------------
# version
#-------------------------------------------------------------------
def version(output: bool = True):
	""" Print the package version """
	if output:
		# Print version to console
		print(f"{__pkg_name__.capitalize()} version {__version__}")
	else:
		# Return version string
		return f"{__version__}"


#-------------------------------------------------------------------
# getFileLogger
#-------------------------------------------------------------------
def getFileLogger(name: str, level: int = LOG_LEVEL) -> Logger:
	"""
	Retrieve or create a file logger instance.

	Args:
		name (str): Name of the logger.
		level (int): Logging level for the file logger (default is LOG_LEVEL).

	Returns:
		Logger: Logger instance associated with the given name, or False if it does not exist.
	"""

	reg = Registry()

	if reg.hasLogger(name):
		logger = reg.getLogger(name)
	else:
		formatter = logging.Formatter(STD_FORMAT, datefmt='%Y-%m-%d %H:%M:%S')
		handler = initRotatingFileHandler(name, level=level, maxSize=LOG_SIZE, backups=LOG_COUNT)
		handler.setFormatter(formatter)
		logger = Logger(name, level=level)
		logger.addHandler(handler)
		reg.addLogger(name, logger)

	return logger


#-------------------------------------------------------------------
# AliasGroup Class
#-------------------------------------------------------------------
class AliasGroup(typer.core.TyperGroup):

	_CMD_SPLIT_P = re.compile(r", ?")

	def get_command(self, ctx: typer.Context, name: str):
		"""
		Get the command associated with the given name.

		Args:
			ctx (typer.Context): The context for the command.
			name (str): The name of the command.

		Returns:
			typer.core.Command: The command associated with the name.
		"""
		cmd_name = self._group_cmd_name(name)
		return super().get_command(ctx, cmd_name)


	def _group_cmd_name(self, default_name: str):
		"""
		Convert a command name to a group command name.

		Args:
			cmd_name (str): The command name to convert.

		Returns:
			str: The converted group command name.
		"""
		for cmd in self.commands.values():
			name = cmd.name
			if name and default_name in self._CMD_SPLIT_P.split(name):
				return name

		return default_name
