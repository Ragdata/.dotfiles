#!/usr/bin/env python3
"""
====================================================================
Module: dotware.dotssh
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import logging

from .. config import *

from dotware import getFileLogger

from .. registry import Registry

__mod_name__ = "dotssh"


logger = getFileLogger(__mod_name__)

registry = Registry()
