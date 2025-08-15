#!/usr/bin/env python3
"""
====================================================================
dotware.dotfiles.cli.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import rich
import typer, sys, os

import dotware.output as output
import dotware.dotfiles.install as installer
import dotware.dotfiles.uninstall as uninstaller

from typing import Union
from typing_extensions import Annotated

from .. config import *
from . custom import app as custapp
from . package import app as pkgApp, repoApp
from . registry import app as regApp

from dotware import __pkg_name__, __version__


app = typer.Typer(rich_markup_mode="rich", invoke_without_command=True)

app.add_typer(pkgApp, name="pkg", help="Package Manager", rich_help_panel="Dotware Subcommands")
app.add_typer(regApp, name="reg", help="Registry Manager", rich_help_panel="Dotware Subcommands")
app.add_typer(repoApp, name="repo", help="Package Repository Manager", rich_help_panel="Dotware Subcommands")
app.add_typer(custapp, name="custom", help="Custom Dotfiles Manager", rich_help_panel="Dotware Subcommands")


@app.callback()
def callback() -> None:
	"""
	Dotfiles CLI for managing dotfiles and their components.
	"""


#--------------------------------------------------------------
# Component Commands
#--------------------------------------------------------------
@app.command('disable', help="Disable a dotfiles component", rich_help_panel="Component Management")
def disableComponent(name: Annotated[str, typer.Argument(help="Component Name (eg: git.aliases)")]) -> None:
	pass


@app.command('enable', help="Enable a dotfiles component", rich_help_panel="Component Management")
def enableComponent(name: Annotated[str, typer.Argument(help="Component Name (eg: git.aliases)")]) -> None:
	pass


@app.command('show', help="Show dotfiles components", rich_help_panel="Component Management")
def showComponents(type: Annotated[str, typer.Argument(help="Component Type (eg: aliases)")]) -> None:
	pass


#--------------------------------------------------------------
# Installer Commands
#--------------------------------------------------------------
@app.command()
def env() -> None:
	"""
	Print the current environment variables.
	"""
	output.printInfo("Current Environment Variables:")
	for key, value in os.environ.items():
		output.printMessage(f"{key}: {value}")


@app.command()
def install(
	debug: Annotated[bool, typer.Option("--debug", "-d", help="Enable debug mode", rich_help_panel="Output Level")] = False
) -> None:
	"""
	Install dotfiles and their dependencies.
	"""
	installer.cmd(debug=debug)


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




if __name__ == "__main__":
	app()
