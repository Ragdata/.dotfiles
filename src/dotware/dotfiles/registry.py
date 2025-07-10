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
import sys
import shutil
import logging

from pathlib import Path

from dotware import *
from dotware.config import *
from dotware.dotlib.output import *
from dotware.dotlib.logs import *


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

		self.logger = self.getLogger(name, level)
		self.logger.info(f"Registry Logger ('{name}') initialized with log level {logging._levelToName}.")

		# Ensure the registry directory exists
		if not REGISTRY.exists():
			makedir(REGISTRY)
			self.logger.info(f"Created registry directory: {REGISTRY}")


	def _checkName(self, name: str):
		""" Check if the component name is valid """

		parts = name.split('.')
		compfile = DOT_LIB / parts[1] / f"{name}.bash"

		if len(parts) != 2:
			raise ValueError("Component name must be in the format 'name.type'")
		if parts[1] not in comp_types:
			raise ValueError(f"Invalid component type. Must be one of: {', '.join(comp_types)}")
		if not compfile.exists():
			raise FileNotFoundError(f"Component file '{compfile}' does not exist.")


	def getLogger(self, name: str, level: int = LOG_LEVEL, **kwargs) -> logging.Logger:
		""" Get a logger for the registry"""
		if hasattr(self, 'logger'):
			return self.logger
		else:
			self.logger = initLogger(name, level) # type: ignore

		# Set FileHandler parameters
		fileLevel = kwargs.get('fileLevel', LOG_LEVEL_FILE)
		filedir = kwargs.get('filedir', DOT_LOG)
		fileFormat = kwargs.get('fileFormat', LOG_FORMAT)
		# Create FileHandler
		fileHandler = initFileHandler('registry', fileLevel, DOT_LOG, fileFormat)
		self.logger.addHandler(fileHandler)
		# Set ConsoleHandler parameters
		stream = kwargs.get('stream', sys.stdout)
		streamLevel = kwargs.get('streamLevel', LOG_LEVEL_STREAM)
		streamFormat = kwargs.get('streamFormat', CON_FORMAT)
		# Create ConsoleHandler
		streamHandler = initStreamHandler(stream, streamLevel, streamFormat)
		self.logger.addHandler(streamHandler)

		return self.logger


	def enable(self, name: str):
		""" Enable a component """

		parts = name.split('.')
		regfile = REGISTRY / f"{parts[1]}.enabled"

		self._checkName(name)

		if not regfile.exists():
			tmplfile = TEMPLATES / "registry.tmpl"
			shutil.copy(tmplfile, regfile)

		with open(regfile, 'a') as reg:
			if name not in reg.read():
				reg.write(f"{parts[0]}\n")
				self.logger.info(f"Component '{name}' enabled.")
				return 0
			else:
				self.logger.warning(f"Component '{name}' is already enabled.")
				return 2


	def disable(self, name: str):
		""" Disable a component """

		parts = name.split('.')
		regfile = REGISTRY / f"{parts[1]}.enabled"

		self._checkName(name)

		if not regfile.exists():
			self.logger.warning(f"Component '{name}' is not enabled.")
			return 0

		with open(regfile, 'r') as reg:
			if name in reg.read():
				lines = reg.readlines()
				with open(regfile, 'w') as reg:
					for line in lines:
						if line.strip() != parts[0]:
							reg.write(line)
				self.logger.info(f"Component '{name}' disabled.")
				return 0
			else:
				self.logger.warning(f"Component '{name}' is not enabled.")
				return 2


	def list(self):
		""" List all registered components """
		pass
