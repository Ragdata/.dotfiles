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

# from flake8 import LOG_FORMAT

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

REPODIR = filepath.parent.parent.parent
SRC_DIR = REPODIR / 'src'
SYS_DIR = REPODIR / 'sys'
LIB_DIR = SYS_DIR / 'lib'

BACKUP = Path.home() / '.backup'
BASHRCD = Path.home() / '.bashrc.d'
BASEDIR = Path.home() / '.dotfiles'
CUSTOM = BASEDIR / 'custom'
DOTSDIR = BASEDIR / 'dots'
DOT_ETC = BASEDIR / 'etc'
DOT_LOG = BASEDIR / 'logs'
REGISTRY = BASEDIR / 'reg'
DOT_SYS = BASEDIR / 'sys'
DOT_CFG = DOT_SYS / 'cfg'
DOT_LIB = DOT_SYS / 'lib'

ALIASES = DOT_LIB / 'aliases'
COMPLETIONS = DOT_LIB / 'completions'
FUNCTIONS = DOT_LIB / 'functions'
PACKAGES = DOT_LIB / 'pkgs'
PLUGINS = DOT_LIB / 'plugins'
SCRIPTS = DOT_LIB / 'scripts'
STACKS = DOT_LIB / 'stacks'
TEMPLATES = DOT_LIB / 'templates'

LOG_LEVEL = logging.INFO

LOG_LEVEL_FILE = logging.DEBUG
LOG_LEVEL_STREAM = logging.INFO
LOG_LEVEL_ERROR = logging.ERROR

STD_FORMAT = "%(asctime)s :: %(name)s -- %(levelname)s :: %(message)s"
SHORT_FORMAT = "%(levelname)s :: %(message)s"
LONG_FORMAT = "%(asctime)s :: %(name)s -- %(levelname)s :: %(message)s in %(filename)s\n%(pathname)s [ %(funcName)s line %(lineno)s ]"
CON_FORMAT = "%(message)s"

SELECTABLE_TYPES = ["aliases", "completions", "functions", "plugins"]
COMPONENT_TYPES = [("aliases", ALIASES),
				   ("completions", COMPLETIONS),
				   ("functions", FUNCTIONS),
				   ("packages", PACKAGES),
				   ("plugins", PLUGINS),
				   ("scripts", SCRIPTS),
				   ("stacks", STACKS)]
