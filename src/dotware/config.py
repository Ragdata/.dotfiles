#!/usr/bin/env python3
####################################################################
# dotware.config.py
####################################################################
# Author:       Ragdata
# Date:         19/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import logging

from pathlib import Path

SYMBOL_ERROR = "✘"
SYMBOL_WARNING = "🛆"
SYMBOL_INFO = "✚"
SYMBOL_SUCCESS = "🗸"
SYMBOL_TIP = "★"
SYMBOL_IMPORTANT = "⚑"
SYMBOL_DEBUG = "⚙"
SYMBOL_HEAD="➤"
SYMBOL_DOT="⦁"

STYLE_ERROR = "bold red"
STYLE_WARNING = "bold yellow"
STYLE_INFO = "bright_blue"
STYLE_SUCCESS = "bright_green"
STYLE_TIP = "cyan"
STYLE_IMPORTANT = "magenta"
STYLE_DEBUG = "dim white"
STYLE_HEAD = "bold yellow"
STYLE_DOT = "green"

REPODIR = Path(__file__).resolve().parent.parent.parent
REPOSRV = REPODIR / 'srv'

BACKUP = Path.home() / '.backup'
BASHRCD = Path.home() / '.bashrc.d'
BASEDIR = Path.home() / '.dotfiles'

CUSTOM = BASEDIR / 'custom'
SRVDIR = BASEDIR / 'srv'

CFGDIR = SRVDIR / 'cfg'
DOTSDIR = SRVDIR / 'dots'
ETCDIR = SRVDIR / 'etc'
LIBDIR = SRVDIR / 'lib'
LOGDIR = SRVDIR / 'log'

REGISTRY = SRVDIR / 'reg'

REG_CACHE = REGISTRY / 'cache'
REG_COMP = REGISTRY / 'comp'

ALIASES = LIBDIR / 'aliases'
ASSETS = LIBDIR / 'assets'
COMPLETIONS = LIBDIR / 'completions'
FUNCTIONS = LIBDIR / 'functions'
HELPDIR = LIBDIR / 'help'
PACKAGES = LIBDIR / 'pkgs'
PLUGINS = LIBDIR / 'plugins'
SCRIPTS = LIBDIR / 'scripts'
STACKS = LIBDIR / 'stacks'
TEMPLATES = LIBDIR / 'templates'

LOG_LEVEL = logging.INFO
LOG_SIZE = 1 * 1024 * 1024  # 1 MB
LOG_COUNT = 3

STD_FORMAT = "%(asctime)s :: %(levelname)s :: %(message)s"
SHORT_FORMAT = "%(levelname)s :: %(message)s"
LONG_FORMAT = "%(asctime)s :: %(levelname)s :: %(message)s in %(filename)s\n%(pathname)s [ %(funcName)s line %(lineno)s ]"
CON_FORMAT = "%(message)s"

SELECTABLE_TYPES = ["aliases", "completions", "functions", "plugins"]
COMPONENT_TYPES = [("aliases", ALIASES),
				   ("completions", COMPLETIONS),
				   ("functions", FUNCTIONS),
				   ("packages", PACKAGES),
				   ("plugins", PLUGINS),
				   ("scripts", SCRIPTS),
				   ("stacks", STACKS)]
