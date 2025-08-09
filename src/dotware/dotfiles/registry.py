#!/usr/bin/env python3
"""
====================================================================
dotware.dotfiles.registry.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import typer

import dotware.output as output

from pathlib import Path

from .. config import *
from .. logger import *
from .. registry import *

from .. import getFileLogger

from . import __mod_name__


logger = getFileLogger(__mod_name__)

outlog = output.OutLog(logger)

app = typer.Typer(name="registry", rich_markup_mode="rich", no_args_is_help=True, add_completion=DOTWARE_COMPLETION)

#-------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------



#-------------------------------------------------------------------
# REGISTRY COMMANDS
#-------------------------------------------------------------------
