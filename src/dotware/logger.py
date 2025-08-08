#!/usr/bin/env python3
"""
====================================================================
dotware.logger.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import logging, sys

from pathlib import Path
from typing import TextIO, Any
from logging.handlers import RotatingFileHandler

from hamcrest import instance_of

from . config import *
from . output import *
from . registry import *


#-------------------------------------------------------------------
# Logger Class
#-------------------------------------------------------------------
class Logger(logging.Logger):
	""" Custom dotware logger class """

	def __init__(self, name: str, level: int = logging.INFO, **kwargs):
		"""
		Initialize the logger with a name and level.

		Args:
			name (str): Name of the logger.
			level (int): Logging level (default is INFO).
			**kwargs: Additional keyword arguments for logging configuration.
		"""
		super().__init__(name, level, **kwargs)
		self.setLevel(level)


	def debug(self, msg: str, *args, **kwargs) -> None:
		"""
		Log a debug message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.DEBUG):
			self._log(logging.DEBUG, msg, args, **kwargs)


	def info(self, msg: str, *args, **kwargs) -> None:
		"""
		Log an informational message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.INFO):
			self._log(logging.INFO, msg, args, **kwargs)


	def warning(self, msg: str, *args, **kwargs) -> None:
		"""
		Log a warning message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.WARNING):
			self._log(logging.WARNING, msg, args, **kwargs)


	def error(self, msg: str, *args, **kwargs) -> None:
		"""
		Log an error message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.ERROR):
			self._log(logging.ERROR, msg, args, **kwargs)


	def exception(self, msg: str, *args, **kwargs) -> None:
		"""
		Log an exception message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.ERROR):
			self._log(logging.ERROR, msg, args, exc_info=True, **kwargs)


	def critical(self, msg: str, *args, **kwargs) -> None:
		"""
		Log a critical message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.CRITICAL):
			self._log(logging.CRITICAL, msg, args, **kwargs)


	def fatal(self, msg: str, *args, **kwargs) -> None:
		"""
		Log a fatal message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.FATAL):
			self._log(logging.FATAL, msg, args, **kwargs)


	def log(self, level: int, msg: str, *args, **kwargs) -> None:
		"""
		Log a message with a specific logging level.

		Args:
			level (int): The logging level.
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(level):
			self._log(level, msg, args, **kwargs)


#-------------------------------------------------------------------
# initRotatingFileHandler
#-------------------------------------------------------------------
def initRotatingFileHandler(name: str, level: int = LOG_LEVEL, dir: Path = LOGDIR, maxSize: int = LOG_SIZE, backups: int = LOG_COUNT) -> RotatingFileHandler:
	"""
	Initialize and return a RotatingFileHandler.

	Args:
		name (str): Name of the logger.
		level (int): Logging level for the file handler (default is LOG_LEVEL_FILE).
		dir (Path): Directory where the log file will be stored (default is DOT_LOG).
		maxSize (int): Maximum size of the log file before rotation (default is 5 MB).
		backups (int): Number of backup files to keep (default is 5).

	Returns:
		RotatingFileHandler: Configured file handler instance.
	"""
	if not dir.exists():
		dir.mkdir(parents=True, exist_ok=True, mode=0o755)

	logFile = dir / f"{name}.log"

	return RotatingFileHandler(logFile, maxBytes = maxSize, backupCount = backups, encoding='utf-8', delay=False)


#-------------------------------------------------------------------
# initStreamHandler
#-------------------------------------------------------------------
def initStreamHandler(stream: TextIO | Any = sys.stdout, level: int = LOG_LEVEL, format: str = CON_FORMAT) -> logging.StreamHandler:
	"""
	Initialize and return a StreamHandler.

	Args:
		stream (TextIO | Any): The stream to which the log messages will be sent (default is sys.stdout).
		level (int): Logging level for the stream handler (default is LOG_LEVEL_STREAM).
		format (str): Log format string (default is CON_FORMAT).

	Returns:
		logging.StreamHandler: Configured stream handler instance.
	"""
	handler = logging.StreamHandler(stream)
	handler.setLevel(level)

	return handler
