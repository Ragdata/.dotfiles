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
from . import logger, registry


outlog = output.OutLog(logger)

app = typer.Typer(rich_markup_mode="rich", no_args_is_help=True, add_completion=DOTWARE_COMPLETION)

repoApp = typer.Typer(rich_markup_mode="rich", no_args_is_help=True, add_completion=DOTWARE_COMPLETION)

app.add_typer(repoApp, name="repo", help="Repository management commands")

#-------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------


#-------------------------------------------------------------------
# PACKAGE COMMANDS
#-------------------------------------------------------------------
@app.command(name="install", help="Install package")
def install() -> None:
	pass


@app.command(name="uninstall", help="Uninstall package")
def uninstall() -> None:
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

