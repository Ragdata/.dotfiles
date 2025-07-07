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

from dotware import __pkg_name__, __version__
from dotware.config import *



app = typer.Typer(
    help=f"{__pkg_name__} - A python package for managing dotfiles and server processes",
    invoke_without_command=True,
    no_args_is_help=True
)

cfg = typer.Typer()
disable = typer.Typer()
enable = typer.Typer()
install = typer.Typer()
remove = typer.Typer()
# search = typer.Typer()
show = typer.Typer()
update = typer.Typer()

app.add_typer(cfg, name="config", help="Manage Dotfiles Configuration")
app.add_typer(disable, name="disable", help="Disable Dotfiles Components")
app.add_typer(enable, name="enable", help="Enable Dotfiles Components")
app.add_typer(install, name="install", help="Install Software")
app.add_typer(remove, name="remove", help="Uninstall Software")
# app.add_typer(search, name="search", help="Search for Dotfiles Components")
app.add_typer(show, name="show", help="Show Details of Dotfiles Components")
app.add_typer(update, name="update", help="Update Software")



#--------------------------------------------------------------
# Configuration Commands
#--------------------------------------------------------------
@cfg.command(help="Configure Packages")
def cfgPackage():
	pass
#--------------------------------------------------------------
# Configuration Commands
#--------------------------------------------------------------
@show.command(help="Show Components")
def showComponents():
	pass

@disable.command(help="Disable Components")
def disableComponents():
	pass

@enable.command(help="Enable Components")
def enableComponents():
	pass

@install.command(help="Install Dependencies")
def installDeps():
	pass

@install.command(help="Install a Package")
def installPackage():
	pass

@install.command(help="Install Packages")
def installRepos():
	pass


def log():
	pass


def migrate():
	pass


def preview():
	pass


def profile():
	pass


def removePackage():
	pass


def reboot():
	pass


def restart():
	pass


def reload():
	pass


def search():
	pass


def updateBin():
	pass


def updateDots():
	pass


def updateRepo():
	pass


def updateSystem():
	pass





def run():
	""" Return a Dotfiles CLI App Instance """
	try:
		return app()
	except Exception as e:
		typer.style(f"An error occurred: {e}", fg="config.COLOR_ERROR", bold=True)
		raise



if __name__ == "__main__":
	run()
