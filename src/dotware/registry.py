#!/usr/bin/env python3
####################################################################
# dotfiles.cli.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import os
import stat
import sys
import shutil
import logging

from pathlib import Path, PurePath

from . import *
from . config import *
from . output import *
from . logger import *


####################################################################
# Registry Class
####################################################################
class Registry:
	"""
    Registry class for managing dotfiles components.
	This class provides methods to register, unregister, and list components.
	"""

	def __init__(self, name: str, level: int = LOG_LEVEL):
		""" Initialise the Registry """

		# Ensure the registry directory exists
		if not REGISTRY.exists():
			REGISTRY.mkdir(parents=True, exist_ok=True, mode=0o755)
			logger.info(f"Created registry directory: {REGISTRY}")


	@staticmethod
	def _checkName(name: str):
		""" Check if the component name is valid """

		parts = name.split('.')
		compfile = DOT_LIB / parts[1] / f"{name}.bash"

		if len(parts) != 2:
			raise ValueError("Component name must be in the format 'name.type'")
		if parts[1] not in SELECTABLE_TYPES:
			raise ValueError(f"Invalid component type. Must be one of: {', '.join(SELECTABLE_TYPES)}")
		if not compfile.exists():
			raise FileNotFoundError(f"Component file '{compfile}' does not exist.")


	@staticmethod
	def _checkFile(file: Path):
		""" Check if the file is a valid selectable component file """
		if not file.exists():
			logger.error(f"File '{file}' does not exist.")
			return 1
		if not file.is_file():
			logger.error(f"Path '{file}' is not a file.")
			return 1
		parts = PurePath(os.path.dirname(file)).parts
		if parts[-1] not in SELECTABLE_TYPES:
			logger.error(f"Invalid component type in file path '{file}'. Must be one of: {', '.join(SELECTABLE_TYPES)}")
			return 1
		return 0


	@staticmethod
	def _status(id: Path | str) -> int:
		""" Check the status of a component """

		if isinstance(id, Path):
			if not id.is_file():
				logger.error(f"Path '{id}' is not a file.")
				return 20
			if Registry._checkFile(id) != 0:
				logger.error(f"File '{id}' is not a valid component file.")
				return 20
			name = id.name
		elif isinstance(id, str):
			name = id
		else:
			logger.error(f"Invalid component ID type: {type(id)}. Must be a Path or str.")
			return 10

		parts = name.split('.')
		regfile = REGISTRY / f"{parts[1]}.enabled"

		if not regfile.exists():
			logger.info(f"Component '{id}' is not enabled.")
			return 1

		with open(regfile, 'r') as reg:
			if parts[0] in reg.read():
				logger.info(f"Component '{id}' is enabled.")
				return 0
			else:
				logger.info(f"Component '{id}' is not enabled.")
				return 1


	def enable(self, name: str):
		""" Enable a component """

		parts = name.split('.')
		regfile = REGISTRY / f"{parts[1]}.enabled"

		self._checkName(name)

		if not regfile.exists():
			tmplfile = TEMPLATES / "registry.tmpl"
			shutil.copy(tmplfile, regfile)
			logger.debug(f"Created registry file: {regfile}")

		with open(regfile, 'a') as reg:
			if name not in reg.read():
				reg.write(f"{parts[0]}\n")
				logger.info(f"Component '{name}' enabled.")
				return 0
			else:
				logger.warning(f"Component '{name}' is already enabled.")
				return 2

		return 1


	def disable(self, name: str) -> int:
		""" Disable a component """

		parts = name.split('.')
		regfile = REGISTRY / f"{parts[1]}.enabled"

		self._checkName(name)

		if not regfile.exists():
			logger.warning(f"Component '{name}' is not enabled.")
			return 1

		with open(regfile, 'r') as reg:
			if name in reg.read():
				lines = reg.readlines()
				with open(regfile, 'w') as reg:
					for line in lines:
						if line.strip() != parts[0]:
							reg.write(line)
				logger.info(f"Component '{name}' disabled.")
				return 0
			else:
				logger.warning(f"Component '{name}' is not enabled.")
				return 2

		return 1



	# def list(self):
	# 	""" List all registered components """
	# 	pass
