#!/usr/bin/env python3
"""
====================================================================
dotware.dotfiles.package.py
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

app = typer.Typer(name="package", rich_markup_mode="rich", no_args_is_help=True, add_completion=DOTWARE_COMPLETION)

repoApp = typer.Typer(rich_markup_mode="rich", no_args_is_help=True, add_completion=DOTWARE_COMPLETION)

app.add_typer(repoApp, name="repo", help="Repository management commands", rich_help_panel="Dotware Subcommands")

#-------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------
def _check(name: str) -> bool:
	return False


def _pre_install(name: str) -> bool:
	return False


def _post_install(name: str) -> bool:
	return False


def _post_config(name: str) -> bool:
	return False


def _pre_remove(name: str) -> bool:
	return False


def _post_remove(name: str) -> bool:
	return False


def _post_update(name: str) -> bool:
	return False


#-------------------------------------------------------------------
# PACKAGE COMMANDS
#-------------------------------------------------------------------
@app.command(name="config", help="Configure package")
def config() -> None:
	pass


@app.command(name="install", help="Install package")
def install() -> None:
	pass


@app.command(name="remove", help="Uninstall package")
def remove() -> None:
	pass


@app.command(name="update", help="Update package")
def update() -> None:
	pass


@app.command(name="list", help="List packages")
def list() -> None:
	pass


@app.command(name="search", help="Search for a package")
def search(name: str) -> None:
	pass


#-------------------------------------------------------------------
# REPOSITORY COMMANDS
#-------------------------------------------------------------------
@repoApp.command(name="add", help="Add a repository")
def add_repo(name: str, url: str) -> None:
	pass


@repoApp.command(name="remove", help="Remove a repository")
def remove_repo(name: str) -> None:
	pass


@repoApp.command(name="list", help="List repositories")
def list_repos() -> None:
	pass

