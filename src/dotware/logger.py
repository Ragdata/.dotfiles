#!/usr/bin/env python3
####################################################################
# dotware.logger.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import logging, sys

from typing import TextIO, Any
from pathlib import Path
from logging.handlers import RotatingFileHandler

from dotware import *
from dotware.config import *
from dotware.output import *



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



def initLogger(name: str, level: int = logging.INFO) -> Logger:
	"""
	Initialize and return a logger instance.

	Args:
		name (str): Name of the logger.
		level (int): Logging level (default is INFO).

	Returns:
		Logger: Configured logger instance.
	"""
	logger = Logger(name, level)

	# # Setup FileHandler
	# fileLevel = kwargs.get('fileLevel', LOG_LEVEL_FILE)
	# filedir = kwargs.get('filedir', DOT_LOG)
	# fileFormat = kwargs.get('fileFormat', LOG_FORMAT)
	# fileHandler = Logger.initFileHandler(name, fileLevel, filedir, fileFormat)
	# logger.addHandler(fileHandler)

	# # Setup ConsoleHandler
	# stream = kwargs.get('stream', sys.stdout)
	# streamLevel = kwargs.get('streamLevel', LOG_LEVEL_STREAM)
	# streamFormat = kwargs.get('streamFormat', CON_FORMAT)
	# streamHandler = Logger.initStreamHandler(stream, streamLevel, streamFormat)
	# logger.addHandler(streamHandler)

	return logger


def initRotatingFileHandler(name: str, level: int = LOG_LEVEL_FILE, dir: Path = DOT_LOG, format: str = STD_FORMAT, maxSize: int = 5 * 1024 * 1024, backups: int = 5) -> RotatingFileHandler:
	"""
	Initialize and return a RotatingFileHandler.

	Args:
		name (str): Name of the logger.
		level (int): Logging level for the file handler (default is LOG_LEVEL_FILE).
		dir (Path): Directory where the log file will be stored (default is DOT_LOG).
		format (str): Log format string (default is STD_FORMAT).
		maxSize (int): Maximum size of the log file before rotation (default is 5 MB).
		backups (int): Number of backup files to keep (default is 5).

	Returns:
		RotatingFileHandler: Configured file handler instance.
	"""
	if not dir.exists():
		dir.mkdir(parents=True, exist_ok=True, mode=0o755)

	logFile = dir / f"{name}.log"

	return RotatingFileHandler(logFile, maxBytes = maxSize, backupCount = backups, encoding='utf-8', delay=False)


def initStreamHandler(stream: TextIO | Any = sys.stdout, level: int = LOG_LEVEL_STREAM, format: str = CON_FORMAT) -> logging.StreamHandler:
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


# Formatters
STANDARD = logging.Formatter(STD_FORMAT)
SHORT = logging.Formatter(SHORT_FORMAT)
LONG = logging.Formatter(LONG_FORMAT)
CONSOLE = logging.Formatter(CON_FORMAT)
# Handlers
fileHandler = initRotatingFileHandler('dotfiles', logging.DEBUG, DOT_LOG, STD_FORMAT, 1000000, 3)
fileHandler.setFormatter(STANDARD)
errorFileHandler = initRotatingFileHandler('error', logging.WARNING, DOT_LOG, LONG_FORMAT, 1000000, 3)
errorFileHandler.setFormatter(LONG)
consoleHandler = initStreamHandler(sys.stdout, logging.INFO, CON_FORMAT)
consoleHandler.setFormatter(CONSOLE)
# Primary Logger
logger = initLogger('dotfiles', logging.DEBUG)
logger.addHandler(fileHandler)
logger.addHandler(consoleHandler)
# Error Logger
errorLog = initLogger('error', logging.WARNING)
errorLog.addHandler(errorFileHandler)
