#!/usr/bin/env python3
"""
====================================================================
Module: dotware.dotfiles
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import logging

from colorama import init

from .. config import *
from .. logger import *
from .. output import *
from .. registry import *


__mod_name__ = "dotfiles"


registry = Registry()


if registry.hasLogger(__mod_name__):
	logger = registry.getLogger(__mod_name__)
else:
	formatter = logging.Formatter(STD_FORMAT, datefmt='%Y-%m-%d %H:%M:%S')
	handler = initRotatingFileHandler(__mod_name__, level=LOG_LEVEL, maxSize=LOG_SIZE, backups=LOG_COUNT)
	handler.setFormatter(formatter)
	logger = Logger(__mod_name__, level=LOG_LEVEL)
	logger.addHandler(handler)
	registry.addLogger(__mod_name__, logger)

