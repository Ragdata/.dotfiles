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

from dotware.config import *
from dotware.dotlib.output import *


types = ["aliases", "completions", "functions", "plugins"]


class Registry:
	"""
    Registry class for managing dotfiles components.
	This class provides methods to register, unregister, and list components.
	"""

	def _checkName(self, name: str):
		""" Check if the component name is valid """

		parts = name.split('.')
		compfile = LIB_DIR / parts[1] / f"{name}.bash"

		if len(parts) != 2:
			raise ValueError("Component name must be in the format 'name.type'")
		if parts[1] not in types:
			raise ValueError(f"Invalid component type. Must be one of: {', '.join(types)}")
		if not compfile.exists():
			raise FileNotFoundError(f"Component file '{compfile}' does not exist.")


	# def initLogger(self):
	# 	""" Initialize the logger for the registry """

	# 	try:

	# 		loggerID = "registry"
	# 		logDir = LOG_DIR
	# 		logFile = logDir / f"{loggerID}.log"
	# 		logLevel = LOG_LEVEL

	# 		if not logDir.exists():



	# 	except Exception as e:

		# logging.basicConfig(
		# 	filename=LOG_DIR / 'registry.log',
		# 	level=LOG_LEVEL,
		# 	format='%(asctime)s - %(levelname)s - %(message)s',
		# 	datefmt='%Y-%m-%d %H:%M:%S'
		# )
		# self.logger = logging.getLogger(__name__)
		# self.logger.info("Registry initialized.")


	def enable(self, name: str):
		""" Enable a component """

		parts = name.split('.')
		compfile = LIB_DIR / parts[1] / f"{name}.bash"
		regfile = REGISTRY / f"{parts[1]}.enabled"

		self._checkName(name)

		if not regfile.exists():
			tmplfile = TEMPLATES / "registry.tmpl"
			shutil.copy(tmplfile, regfile)

		with open(regfile, 'a') as reg:
			if name not in reg.read():
				reg.write(f"{name}\n")
				pass
				# console(f"Enabled component: {name}", color=COLOR_SUCCESS)
			else:
				# console(f"Component '{name}' is already enabled.", color=COLOR_WARNING)
				pass




	def disable(self, name: str):
		""" Disable a component """
		pass


	def list(self):
		""" List all registered components """
		pass
