#!/usr/bin/env python3
####################################################################
# dotware.dotfiles.cli.py
####################################################################
# Author:       Ragdata
# Date:         19/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import typer, sys, os

import dotware.output as output
import dotware.dotfiles.install as installer
import dotware.dotfiles.uninstall as uninstaller

from typing import Union
from typing_extensions import Annotated

from .. config import *
from . custom import app as custapp

from dotware import __pkg_name__, __version__


app = typer.Typer(rich_markup_mode="rich")
app.add_typer(custapp, name="custom", help="Manage custom dotfiles", rich_help_panel="Dotfiles Commands")


@app.callback()
def callback() -> None:
	"""
	[bold]Dotfiles CLI[/]

	[white]Manage your dotfiles and configurations with ease.[/]
	"""

#--------------------------------------------------------------
# Component Commands
#--------------------------------------------------------------
@app.command('disable', help="Disable a dotfiles component")
def disableComponent(name: Annotated[str, typer.Argument(help="Component Name (eg: git.aliases)")]) -> None:
	pass


@app.command('enable', help="Enable a dotfiles component")
def enableComponent(name: Annotated[str, typer.Argument(help="Component Name (eg: git.aliases)")]) -> None:
	pass


@app.command('show', help="Show dotfiles components")
def showComponents(type: Annotated[str, typer.Argument(help="Component Type (eg: aliases)")]) -> None:
	pass


#--------------------------------------------------------------
# Installer Commands
#--------------------------------------------------------------
@app.command()
def install() -> None:
	"""
	Install dotfiles and their dependencies.
	"""
	installer.cmd()


@app.command()
def uninstall() -> None:
	"""
	Uninstall dotfiles
	"""
	uninstaller.cmd()


#--------------------------------------------------------------
# Miscellaneous Commands
#--------------------------------------------------------------
@app.command()
def version(
	silent: Annotated[bool, typer.Option("--silent", "-s", help="Return only version number as variable", rich_help_panel="Output Level")] = False,
	version: Annotated[bool, typer.Option("--version", "-v", help="Print version", rich_help_panel="Output Level")] = True,
	verbose: Annotated[bool, typer.Option("--verbose", "-vv", help="Print package name and version", rich_help_panel="Output Level")] = False,
	ververbose: Annotated[bool, typer.Option("--vverbose", "-vvv", help="Print package name, version, and copyright information", rich_help_panel="Output Level")] = False
) -> Union[str, None]:
	"""
	Print version information for the dotware package.
	"""
	if silent:
		return __version__
	elif verbose:
		output.printMessage(f"{__pkg_name__.capitalize()} v{__version__}")
	elif ververbose:
		output.printMessage(f"{__pkg_name__.capitalize()} v{__version__} ~ Copyright © 2025 Redeyed Technologies", style="yellow")
	else:
		output.printMessage(f"v{__version__}")


@app.command()
def test():
	output.printInfo(f"{REPODIR}")



if __name__ == "__main__":
	app()
