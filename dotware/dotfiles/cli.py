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
search = typer.Typer()
show = typer.Typer()
update = typer.Typer()

app.add_typer(cfg, name="config", help="Manage Dotfiles Configuration")
app.add_typer(disable, name="disable", help="Disable Dotfiles Components")
app.add_typer(enable, name="enable", help="Enable Dotfiles Components")
app.add_typer(install, name="install", help="Install Software")
app.add_typer(remove, name="remove", help="Uninstall Software")
app.add_typer(search, name="search", help="Search for Dotfiles Components")
app.add_typer(show, name="show", help="Show Details of Dotfiles Components")
app.add_typer(update, name="update", help="Update Software")



####################################################################
# Dotfiles CLI Class
####################################################################
class dotfiles:

	#---------------------------------------------------------------
    # Utility Methods
	#---------------------------------------------------------------

	def __init__(self):
		"""
		Initialise the DotFiles CLI Application
		"""

		pass


	#--------------------------------------------------------------
	# Configuration Commands
	#--------------------------------------------------------------
	@cfg.command(help="Configure Packages")
	@staticmethod
	def cfgPackage():
		pass
	#--------------------------------------------------------------
	# Configuration Commands
	#--------------------------------------------------------------
	@show.command(help="Show Components")
	@staticmethod
	def showComponents():
		pass

	@disable.command(help="Disable Components")
	@staticmethod
	def disableComponents():
		pass

	@enable.command(help="Enable Components")
	@staticmethod
	def enableComponents():
		pass

	@install.command(help="Install Dependencies")
	@staticmethod
	def installDeps():
		pass

	@install.command(help="Install a Package")
	@staticmethod
	def installPackage():
		pass

	@install.command(help="Install Packages")
	@staticmethod
	def installRepos():
		pass


	@staticmethod
	def log():
		pass


	@staticmethod
	def migrate():
		pass


	@staticmethod
	def preview():
		pass


	@staticmethod
	def profile():
		pass


	@staticmethod
	def removePackage():
		pass


	@staticmethod
	def reboot():
		pass


	@staticmethod
	def restart():
		pass


	@staticmethod
	def reload():
		pass


	@staticmethod
	def search():
		pass


	@staticmethod
	def updateBin():
		pass


	@staticmethod
	def updateDots():
		pass


	@staticmethod
	def updateRepo():
		pass


	@staticmethod
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
