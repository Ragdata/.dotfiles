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

from dotware.config import *


class LogManager(logging.Manager):
	""" Custom logging manager for dotware """


	def __init__(self, *args, **kwargs):
		super().__init__(*args, **kwargs)
		self._loggers = {}


	def getLogger(self, name):
		if name not in self._loggers:
			logger = logging.getLogger(name)
			logger.setLevel(logging.DEBUG)
			self._loggers[name] = logger
		return self._loggers[name]
