#!/usr/bin/env python3
####################################################################
# dotfiles.cli.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import os
import sys
import typer
import logging

from pathlib import Path
from typing_extensions import Annotated

from dotware.config import *
from dotware import __pkg_name__, __version__, comp_types
from dotware.dotfiles.registry import *
#from dotware.dotfiles.lib import *



app = typer.Typer(
    help=f"{__pkg_name__} - A python package for managing dotfiles and server processes",
    invoke_without_command=True,
    no_args_is_help=True
)

# cfg = typer.Typer()
# disable = typer.Typer()
# enable = typer.Typer()
# install = typer.Typer()
# remove = typer.Typer()
# # search = typer.Typer()
# show = typer.Typer()
# update = typer.Typer()

# app.add_typer(cfg, name="config", help="Manage Dotfiles Configuration")
# app.add_typer(disable, name="disable", help="Disable Dotfiles Components")
# app.add_typer(enable, name="enable", help="Enable Dotfiles Components")
# app.add_typer(install, name="install", help="Install Software")
# app.add_typer(remove, name="remove", help="Uninstall Software")
# # app.add_typer(search, name="search", help="Search for Dotfiles Components")
# app.add_typer(show, name="show", help="Show Details of Dotfiles Components")
# app.add_typer(update, name="update", help="Update Software")

pkg = typer.Typer()
comp = typer.Typer()

app.add_typer(pkg, help="Manage Software Packages")
app.add_typer(comp, help="Manage Dotfiles Components")


reg = Registry('dotfiles')


#--------------------------------------------------------------
# Component Commands
#--------------------------------------------------------------
@comp.command('show', help="Show Dotfiles Components")
def showComponents(type: Annotated[str, typer.Argument(help="Show Dotfiles Components")]):
	try:

		match type:
			case 'aliases':
				compdir = ALIASES
			case 'completions':
				compdir = COMPLETIONS
			case 'functions':
				compdir = FUNCTIONS
			case 'plugins':
				compdir = PLUGINS
			case _:
				reg.logger.error(f"Unknown component type '{type}'. Valid types are: {', '.join(comp_types)}")
				raise typer.Exit(code=1)

		if not compdir.exists():
			reg.logger.error(f"Component directory '{compdir}' does not exist.")
			raise typer.Exit(code=1)

		# List all files in the component directory
		i = 1
		files = [f.name for f in compdir.iterdir() if f.is_file()]
		for file in files:
			pass

	except Exception as e:
		reg.logger.error(f"Failed to show components of type '{type}': {e}")
		raise


@comp.command('disable', help="Disable Dotfiles Components")
def disableComponent(name: Annotated[str, typer.Argument(help="Disable Dotfiles Component")]):
	""" Disable a Dotfiles Component """
	try:
		reg.disable(name)
	except Exception as e:
		reg.logger.error(f"Failed to disable component '{name}': {e}")
		raise


@comp.command('enable', help="Enable Dotfiles Components")
def enableComponent(name: Annotated[str, typer.Argument(help="Enable Dotfiles Component")]):
	""" Enable a Dotfiles Component """
	try:
		reg.enable(name)
	except Exception as e:
		reg.logger.error(f"Failed to enable component '{name}': {e}")
		raise


#--------------------------------------------------------------
# Package Commands
#--------------------------------------------------------------
@pkg.command('install', help="Install Software Packages")
def installPackage(name: Annotated[str, typer.Argument(help="Install a Software Package")]):
	""" Install a Software Package """
	try:
		pkgfile = PACKAGES / name
		if not pkgfile.exists():
			reg.logger.error(f"Package directory '{pkgfile}' does not exist.")
			raise typer.Exit(code=1)

	except Exception as e:
		reg.logger.error(f"Failed to install package '{name}': {e}")
		raise

@pkg.command('cfg', help="Configure Packages")
def cfgPackage():
	pass





# @install.command(help="Install Dependencies")
# def installDeps():
# 	pass

# @install.command(help="Install a Package")
# def installPackage():
# 	pass

# @install.command(help="Install Packages")
# def installRepos():
# 	pass


# def log():
# 	pass


# def migrate():
# 	pass


# def preview():
# 	pass


# def profile():
# 	pass


# def removePackage():
# 	pass


# def reboot():
# 	pass


# def restart():
# 	pass


# def reload():
# 	pass


# def search():
# 	pass


# def updateBin():
# 	pass


# def updateDots():
# 	pass


# def updateRepo():
# 	pass


# def updateSystem():
# 	pass





def run():
	""" Return a Dotfiles CLI App Instance """
	try:
		return app()
	except Exception as e:
		typer.style(f"An error occurred: {e}", fg="config.COLOR_ERROR", bold=True)
		raise



if __name__ == "__main__":
	run()
