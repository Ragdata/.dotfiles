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
import subprocess

from requests import post
from pathlib import Path
from inspect import isfunction
from typing_extensions import Annotated

from dotware import config
from dotware.config import *
from dotware import __pkg_name__, __version__
from dotware.registry import *
from dotware.dotfiles import *
from dotware.logger import logger



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
show = typer.Typer()

app.add_typer(pkg, help="Manage Software Packages")
app.add_typer(comp, help="Manage Dotfiles Components")
comp.add_typer(show, )


reg = Registry('registry')


#--------------------------------------------------------------
# Component Commands
#--------------------------------------------------------------
@show.command('show', help="Show Dotfiles Components")
def showComponents(type: Annotated[str, typer.Argument(help="Component Type")]):
	try:

		match type:
			case 'aliases':
				compdir = ALIASES
			case 'completions':
				compdir = COMPLETIONS
			case 'functions':
				compdir = FUNCTIONS
			case 'packages':
				compdir = PACKAGES
			case 'plugins':
				compdir = PLUGINS
			case 'scripts':
				compdir = SCRIPTS
			case 'stacks':
				compdir = STACKS
			case _:
				logger.error(f"Unknown component type '{type}'. Valid types are: {', '.join([t[0] for t in COMPONENT_TYPES])}")
				raise typer.Exit(code=1)

		if not compdir.exists():
			logger.error(f"Component directory '{compdir}' does not exist.")
			raise typer.Exit(code=1)

		# List all files in the component directory
		i = 1
		files = [f.name for f in compdir.iterdir() if f.is_file()]
		for file in files:
			try:
				compfile = compdir / file
				if not compfile.exists():
					logger.error(f"Component file '{compfile}' does not exist.")
					continue
				if type in SELECTABLE_TYPES:
					status = Registry._status(compfile)
					if status == 0:
						status_symbol = SYMBOL_SUCCESS
					elif status == 1:
						status_symbol = " "
					else:
						status_symbol = SYMBOL_ERROR
				else:
					status_symbol = " "
				logger.info(f"{i}. {status_symbol} {file}")
				i += 1
			except Exception as e:
				logger.error(f"Error processing file '{file}': {e}")
				raise

	except Exception as e:
		logger.error(f"Failed to show components of type '{type}': {e}")
		raise


@comp.command('disable', help="Disable Dotfiles Components")
def disableComponent(name: Annotated[str, typer.Argument(help="Component Name")]):
	""" Disable a Dotfiles Component """
	try:
		reg.disable(name)
	except Exception as e:
		logger.error(f"Failed to disable component '{name}': {e}")
		raise


@comp.command('enable', help="Enable Dotfiles Components")
def enableComponent(name: Annotated[str, typer.Argument(help="Component Name")]):
	""" Enable a Dotfiles Component """
	try:
		reg.enable(name)
	except Exception as e:
		logger.error(f"Failed to enable component '{name}': {e}")
		raise


#--------------------------------------------------------------
# Package Commands
#--------------------------------------------------------------
@pkg.command('install', help="Install Software Packages")
def installPackage(name: Annotated[str, typer.Argument(help="Package Name")]):
	""" Install a Software Package """
	try:
		pkgfile = PACKAGES / name
		pkgcheck = f"{name}::check"
		preinstall = f"{name}::pre_install"
		installfnc = f"{name}::install"
		postinstall = f"{name}::post_install"
		configfnc = f"{name}::config"
		if not pkgfile.exists():
			logger.error(f"Package directory '{pkgfile}' does not exist.")
			raise typer.Exit(code=1)
		else:

			if grepFile(pkgfile, pkgcheck):
				ck = subprocess.run(pkgcheck, shell=True, capture_output=True, text=True)
				if ck.returncode == 0:
					logger.info(f"Package '{name}' is already installed.")
					return

			if grepFile(pkgfile, preinstall):
				pre = subprocess.run(preinstall, shell=True, capture_output=True, text=True)
				if pre.returncode != 0:
					logger.error(f"Pre-installation hook failed for package '{name}': {pre.stderr}")
					raise typer.Exit(code=1)
				else:
					logger.info(f"Pre-installation hook executed successfully for package '{name}'.")

			if grepFile(pkgfile, installfnc):
				ins = subprocess.run(installfnc, capture_output=True, text=True)
				if ins.returncode != 0:
					logger.error(f"Installation failed for package '{name}': {ins.stderr}")
					raise typer.Exit(code=1)
				else:
					logger.info(f"Package '{name}' installed successfully.")

			if grepFile(pkgfile, postinstall):
				post = subprocess.run(postinstall, capture_output=True, text=True)
				if post.returncode != 0:
					logger.error(f"Post-installation hook failed for package '{name}': {post.stderr}")
					raise typer.Exit(code=1)
				else:
					logger.info(f"Post-installation hook executed successfully for package '{name}'.")

			if grepFile(pkgfile, configfnc):
				logger.info(typer.style(f"Package also includes configuration hook", fg=config.COLOR_WARNING, bold=True))

	except Exception as e:
		logger.error(f"Failed to install package '{name}': {e}")
		raise


@pkg.command('cfg', help="Configure Packages")
def cfgPackage(name: Annotated[str, typer.Argument(help="Package Name")]):
	""" Configure a Software Package """
	try:
		pkgfile = PACKAGES / name
		cfgfnc = f"{name}::config"
		postcfg = f"{name}::post_config"
		if not pkgfile.exists():
			logger.error(f"Package directory '{pkgfile}' does not exist.")
			raise typer.Exit(code=1)
		else:
			if grepFile(pkgfile, cfgfnc):
				cfg = subprocess.run(cfgfnc, capture_output=True, text=True)
				if cfg.returncode != 0:
					logger.error(f"Configuration failed for package '{name}': {cfg.stderr}")
					raise typer.Exit(code=1)
				else:
					logger.info(f"Package '{name}' configured successfully.")

			if grepFile(pkgfile, postcfg):
				post = subprocess.run(postcfg, capture_output=True, text=True)
				if post.returncode != 0:
					logger.error(f"Post-configuration hook failed for package '{name}': {post.stderr}")
					raise typer.Exit(code=1)
				else:
					logger.info(f"Post-configuration hook executed successfully for package '{name}'.")

	except Exception as e:
		logger.error(f"Failed to install package '{name}': {e}")
		raise


@pkg.command('remove', help="Remove Software Packages")
def removePackage(name: Annotated[str, typer.Argument(help="Package Name")]):
	""" Remove a Software Package """
	try:
		pkgfile = PACKAGES / name
		pkgcheck = f"{name}::check"
		preuninstall = f"{name}::pre_uninstall"
		uninstallfnc = f"{name}::uninstall"
		postuninstall = f"{name}::post_uninstall"
		if not pkgfile.exists():
			logger.error(f"Package directory '{pkgfile}' does not exist.")
			raise typer.Exit(code=1)
		else:

			if grepFile(pkgfile, pkgcheck):
				ck = subprocess.run(pkgcheck, shell=True, capture_output=True, text=True)
				if ck.returncode != 0:
					logger.error(f"Package '{name}' is not installed.")
					return

			if grepFile(pkgfile, preuninstall):
				pre = subprocess.run(preuninstall, shell=True, capture_output=True, text=True)
				if pre.returncode != 0:
					logger.error(f"Pre-uninstallation hook failed for package '{name}': {pre.stderr}")
					raise typer.Exit(code=1)
				else:
					logger.info(f"Pre-uninstallation hook executed successfully for package '{name}'.")

			if grepFile(pkgfile, uninstallfnc):
				unins = subprocess.run(uninstallfnc, capture_output=True, text=True)
				if unins.returncode != 0:
					logger.error(f"Uninstallation failed for package '{name}': {unins.stderr}")
					raise typer.Exit(code=1)
				else:
					logger.info(f"Package '{name}' uninstalled successfully.")

			if grepFile(pkgfile, postuninstall):
				post = subprocess.run(postuninstall, capture_output=True, text=True)
				if post.returncode != 0:
					logger.error(f"Post-uninstallation hook failed for package '{name}': {post.stderr}")
					raise typer.Exit(code=1)
				else:
					logger.info(f"Post-uninstallation hook executed successfully for package '{name}'.")

	except Exception as e:
		logger.error(f"Failed to remove package '{name}': {e}")
		raise





def run():
	""" Return a Dotfiles CLI App Instance """
	try:
		return app()
	except Exception as e:
		typer.style(f"An error occurred: {e}", fg="config.COLOR_ERROR", bold=True)
		raise



if __name__ == "__main__":
	run()
