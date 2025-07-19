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

from typing import Union
from typing_extensions import Annotated

from dotware.config import *
from dotware import __pkg_name__, __version__


app = typer.Typer(rich_markup_mode="rich")


@app.callback()
def callback() -> None:
	"""
	[bold]Dotfiles CLI[/]

	[white]Manage your dotfiles and configurations with ease.[/]
	"""


@app.command()
def install() -> None:
	"""
	Install dotfiles and their dependencies.
	"""
	installer.cmd()


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



if __name__ == "__main__":
	app()
