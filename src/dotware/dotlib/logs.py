#!/usr/bin/env python3
####################################################################
# dotlib.logs.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import os
import sys
import logging

from pathlib import Path
from typing import TextIO, Any

from dotware.config import *
from dotware.dotlib.files import makedir
from dotware.dotlib.output import *



class Logger(logging.Logger):
	""" A class to manage logging for the application. """


	def __init__(self, name: str, level: int = LOG_LEVEL, **kwargs):
		"""
		Initialize the Logger with a name and level.

		Args:
			name (str): The name of the logger.
			level (int): The logging level (default is LOG_LEVEL).
		"""
		super().__init__(name, level, **kwargs)


	@staticmethod
	def initFileHandler(name: str, level: int = LOG_LEVEL_FILE, dir: Path = DOT_LOG, format: str = LOG_FORMAT) -> logging.Handler:
		"""
		Initialize a file handler for logging.

		Args:
			name (str): The name of the log file.
			level (int): The logging level for the file handler (default is LOG_LEVEL_FILE).
			dir (Path): The directory where the log file will be stored (default is DOT_LOG).
			format (str): The format of the log messages (default is LOG_FORMAT).

		Returns:
			logging.Handler: Configured file handler.
		"""
		logfile = dir / f"{name}.log"

		if not dir.exists():
			makedir(dir)

		handler = logging.FileHandler(logfile)
		handler.setLevel(level)

		formatter = logging.Formatter(format)
		handler.setFormatter(formatter)

		return handler







		# self.addHandler(initFileHandler(name))
		# self.addHandler(initStreamHandler())


	@staticmethod
	def initStreamHandler(stream: TextIO | Any = sys.stdout, level: int = LOG_LEVEL_STREAM, format: str = CON_FORMAT) -> logging.Handler:
		"""
		Initialize a logging handler.

		Args:
			stream (TextIO | Any): The stream to which the log messages will be sent (default is sys.stdout).
			level (int): The logging level for the stream handler (default is LOG_LEVEL_STREAM).
			format (str): The format of the log messages (default is CON_FORMAT).

		Returns:
			logging.Handler: Configured logging handler.
		"""
		handler = logging.StreamHandler(stream)
		handler.setLevel(level)

		formatter = logging.Formatter(format)
		handler.setFormatter(formatter)

		return handler


	def debug(self, msg: str, *args, **kwargs) -> None:
		"""
		Log a debug message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.DEBUG):
			self._log(logging.DEBUG, formatDebug(msg), *args, **kwargs)


	def info(self, msg: str, *args, **kwargs) -> None:
		"""
		Log an informational message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.INFO):
			self._log(logging.INFO, formatInfo(msg), *args, **kwargs)


	def warning(self, msg: str, *args, **kwargs) -> None:
		"""
		Log a warning message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.WARNING):
			self._log(logging.WARNING, formatWarning(msg), *args, **kwargs)


	def error(self, msg: str, *args, **kwargs) -> None:
		"""
		Log an error message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.ERROR):
			self._log(logging.ERROR, formatError(msg), *args, **kwargs)


	def exception(self, msg: str, *args, **kwargs) -> None:
		"""
		Log an exception message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.ERROR):
			self._log(logging.ERROR, formatError(msg), *args, **kwargs)
			self.exception(msg, *args, **kwargs)


	def critical(self, msg: str, *args, **kwargs) -> None:
		"""
		Log a critical message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.CRITICAL):
			self._log(logging.CRITICAL, formatError(msg), *args, **kwargs)


	def fatal(self, msg: str, *args, **kwargs) -> None:
		"""
		Log a fatal message.

		Args:
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self.isEnabledFor(logging.FATAL):
			self._log(logging.FATAL, formatError(msg), *args, **kwargs)
			sys.exit(1)


	def log(self, level: int, msg: str, *args, **kwargs) -> None:
		"""
		Log a message with the specified logging level.

		Args:
			level (int): The logging level.
			msg (str): The message to log.
			*args: Variable length argument list.
			**kwargs: Arbitrary keyword arguments.
		"""
		if not isinstance(level, int):
			if raiseExceptions:
				raise TypeError("Logging level must be an integer.")
			else:
				return
		if self.isEnabledFor(level):
			self._log(level, msg, *args, **kwargs)



def initLogger(name: str, level: int = LOG_LEVEL, **kwargs) -> Logger:
	"""
	Initialize a logger with the specified name and level.

	Args:
		name (str): The name of the logger.
		level (int): The logging level (default is LOG_LEVEL).

	Returns:
		logging.Logger: Configured logger instance.
	"""
	logger = Logger(name)
	logger.setLevel(level)

	return logger


