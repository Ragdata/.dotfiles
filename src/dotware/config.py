#!/usr/bin/env python3
####################################################################
# dotware.config.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import os
import logging

from pathlib import Path

from flake8 import LOG_FORMAT

filepath = Path(__file__).resolve()

SYMBOL_ERROR = "✘"
SYMBOL_WARNING = "🛆"
SYMBOL_INFO = "✚"
SYMBOL_SUCCESS = "✔"
SYMBOL_TIP = "★"
SYMBOL_IMPORTANT = "⚑"

COLOR_ERROR = "red"
COLOR_WARNING = "yellow"
COLOR_INFO = "blue"
COLOR_SUCCESS = "green"
COLOR_TIP = "cyan"
COLOR_IMPORTANT = "magenta"

BASEDIR = Path.home() / '.dotfiles'
BACKUP_DIR = BASEDIR / '.backup'
CUSTOM_DIR = BASEDIR / 'custom'
CFG_DIR = BASEDIR / 'cfg'
LIB_DIR = BASEDIR / 'lib'
LOG_DIR = BASEDIR / 'logs'
REGISTRY = BASEDIR / 'reg'

TEMPLATES = LIB_DIR / 'templates'

REPODIR = filepath.parent.parent
DOT_DIR = REPODIR / 'dot'
SRC_DIR = REPODIR / 'src'

LOG_LEVEL = logging.INFO

LOG_LEVEL_FILE = logging.DEBUG
LOG_LEVEL_STREAM = logging.INFO
LOG_LEVEL_ERROR = logging.ERROR

LOG_FORMAT = "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
CON_FORMAT = "%(levelname)s: %(message)s"
