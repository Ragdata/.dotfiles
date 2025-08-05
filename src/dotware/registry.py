#!/usr/bin/env python3
"""
====================================================================
dotware.registry.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

from typing import Dict, Union


from . config import *
from . logger import Logger



#-------------------------------------------------------------------
# Registry Class
#-------------------------------------------------------------------
class Registry(object):


	_instance = None

	_loggers: Dict[str, Logger] = {}


	def __new__(cls):

		if cls._instance is None:
			cls._instance = super(Registry, cls).__new__(cls)
			if not REG_CACHE.exists():
				REG_CACHE.mkdir(parents=True, exist_ok=True, mode=0o755)
			if not REG_COMP.exists():
				REG_COMP.mkdir(parents=True, exist_ok=True, mode=0o755)
		return cls._instance


	# --------------------------------------------------------------
	# Component Management
	# --------------------------------------------------------------
	def _checkComponent(self, name: str) -> int:
		return 0


	def disable(self, name: str) -> int:
		return 0


	def enable(self, name: str) -> int:
		return 0


	def status(self, name: str) -> int:
		return 0

	# --------------------------------------------------------------
	# Logger Management
	# --------------------------------------------------------------
	def addLogger(self, name: str, logger: Logger) -> None:
		"""
		Store a logger instance in the registry.

		Args:
			name (str): Name of the logger.
			logger (Logger): Logger instance to store.
		"""
		self._loggers[name] = logger


	def getLogger(self, name: str) -> Union[Logger, bool]:
		"""
		Retrieve a logger instance from the registry.

		Args:
			name (str): Name of the logger.

		Returns:
			Logger: Logger instance associated with the given name.
		"""
		if name in self._loggers:
			return self._loggers[name]
		else:
			return False


	def getLoggers(self) -> Dict[str, Logger]:
		"""
		Retrieve all logger instances from the registry.

		Returns:
			Dict[str, Logger]: Dictionary of logger instances.
		"""
		return self._loggers


	def hasLogger(self, name: str) -> bool:
		"""
		Check if a logger instance exists in the registry.

		Args:
			name (str): Name of the logger.

		Returns:
			bool: True if the logger exists, False otherwise.
		"""
		return name in self._loggers


	def removeLogger(self, name: str) -> None:
		"""
		Remove a logger instance from the registry.

		Args:
			name (str): Name of the logger to remove.
		"""
		if name in self._loggers:
			del self._loggers[name]


