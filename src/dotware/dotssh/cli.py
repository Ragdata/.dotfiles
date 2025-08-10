#!/usr/bin/env python3
"""
====================================================================
dotware.dotssh.cli.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

from ast import Dict
import typer

import dotware.output as output

from dotware import AliasGroup

from .. config import *

from . __init__ import __mod_name__, logger, registry



app = typer.Typer(cls=AliasGroup, rich_markup_mode="rich", invoke_without_command=True)


regfile = REGISTRY / "servers.json"


@app.callback()
def callback() -> None:
	"""
	DotSSH CLI for performing commands on remote servers.
	"""


#--------------------------------------------------------------
# FUNCTIONS
#--------------------------------------------------------------
def _createRegistry(name: str = "servers") -> None:
	"""
	Create a new registry for SSH server configurations.
	"""
	registry.addRegister(name)
	logger.info(f"Registry '{name}' created successfully.")


def _getServerConfig(**kwargs) -> dict:
	"""
	Get the server configuration from the inbound arguments.
	"""
	srvConfig = {}

	for key, val in kwargs.items():
		match str(key).lower():
			case "ip4":
				srvConfig["ip4"] = val
			case "ip6":
				srvConfig["ip6"] = val
			case "host":
				srvConfig["host"] = val
			case "domain":
				srvConfig["domain"] = val
			case "port":
				srvConfig["port"] = val
			case "user":
				srvConfig["user"] = val
			case "pwd":
				srvConfig["pwd"] = val
			case "key":
				srvConfig["key"] = val
			case "notes":
				srvConfig["notes"] = val
			case "type":
				srvConfig["type"] = val
			case _:
				output.printError(f"Unknown key: {key}")

	return srvConfig


def connect(**kwargs) -> None:
    pass



#--------------------------------------------------------------
# SSH Commands
#--------------------------------------------------------------
@app.command("add", help="Add a new SSH server configuration")
def add_server(**kwargs) -> None:
	"""
	Add a new SSH server configuration.
	"""
	if not registry.isRegister('servers'):
		_createRegistry('servers')

	srvConfig = _getServerConfig(**kwargs)

	if 'name' in kwargs:
		registry.addRecord('servers', kwargs['name'], srvConfig)
		output.printSuccess(f"Server '{kwargs['name']}' added successfully.")
	else:
		output.printError("Server name is required to add a new server configuration.")


@app.command("remove", help="Remove an SSH server configuration")
def remove_server(id: str) -> None:
	"""
	Remove an SSH server configuration.
	"""
	if registry.isRegister('servers'):
		if registry.hasRecord('servers', id):
			registry.deleteRecord('servers', id)
			output.printSuccess(f"Server '{id}' removed successfully.")
		else:
			output.printWarning(f"Server '{id}' does not exist.")
	else:
		output.printError("No 'servers' register found. Please create one first.")


@app.command("update", help="Update an SSH server configuration")
def update_server(**kwargs) -> None:
	"""
	Update an SSH server configuration.
	"""
	srvConfig = _getServerConfig(**kwargs)

	if 'name' in kwargs:
		registry.updateRecord('servers', kwargs['name'], srvConfig)
		output.printSuccess(f"Server '{kwargs['name']}' updated successfully.")
	else:
		output.printError("Server name is required to update a server configuration.")


@app.command("list", help="List all SSH server configurations")
def list_servers(**kwargs) -> None:
	"""
	List all SSH server configurations.
	"""
	if registry.isRegister('servers'):
		servers = registry.getRecords('servers')
		if servers:
			output.printInfo("Available SSH Servers:")
			for name, config in servers.items():
				output.printMessage(f"{name}: {config}")
	else:
		output.printError("No 'servers' register found. Please create one first.")


@app.command("cmd | command", help="Run a command on a remote server")
def cmd(**kwargs) -> None:
	"""
	Run a command on a remote server.
	"""
	pass


@app.command("cid | copyId", help="Send specified ID to remote server")
def copy_id(**kwargs) -> None:
	"""
	Copy SSH public key to a remote server.
	"""
	pass




