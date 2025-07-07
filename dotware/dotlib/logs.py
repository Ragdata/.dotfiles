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
from files import makedir



def initLogger(name: str, level: int = LOG_LEVEL, **kwargs) -> logging.Logger:
	"""
	Initialize a logger with the specified name and level.

	Args:
		name (str): The name of the logger.
		level (int): The logging level (default is LOG_LEVEL).

	Returns:
		logging.Logger: Configured logger instance.
	"""
	logger = logging.getLogger(name)
	logger.setLevel(level)

	return logger


def initFileHandler(name: str, level: int = LOG_LEVEL_FILE, dir: Path = LOG_DIR, format: str = LOG_FORMAT) -> logging.Handler:
	"""
	Initialize a file handler for logging.

	Returns:
		logging.Handler: Configured file handler.
	"""
	logfile = dir / f"{name}.log"

	if not dir.exists():
		makedir(dir)

	handler = logging.FileHandler(logfile)
	handler.setLevel(level)

	# Create formatter and add it to the handler
	formatter = logging.Formatter(format)
	handler.setFormatter(formatter)

	return handler


def initStreamHandler(stream: TextIO | Any = sys.stdout, level: int = LOG_LEVEL_STREAM, format: str = CON_FORMAT) -> logging.Handler:
	"""
	Initialize a logging handler.

	Returns:
		logging.Handler: Configured logging handler.
	"""
	handler = logging.StreamHandler(stream)
	handler.setLevel(level)

	# Create formatter and add it to the handler
	formatter = logging.Formatter(format)
	handler.setFormatter(formatter)

	return handler
