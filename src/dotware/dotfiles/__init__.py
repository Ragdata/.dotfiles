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

from .. config import *
from .. logger import *
from .. output import *
from .. registry import *


__mod_name__ = "dotfiles"


logger = getFileLogger(__mod_name__)

registry = Registry()
