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

import typer

import dotware.output as output

from typing_extensions import Annotated

from dotware import AliasGroup

from .. config import *
from .. server import *

from .. __init__ import __version__
from . __init__ import __mod_name__, logger, registry




app = typer.Typer(cls=AliasGroup, rich_markup_mode="rich", invoke_without_command=True)


regfile = REGISTRY / "servers.json"


@app.callback()
def callback() -> None:
	"""
	DotSSH CLI for performing commands on remote servers.

	The keys for server configurations are:
	- `ip4`: IPv4 address of the server
	- `ip6`: IPv6 address of the server
	- `host`: Hostname of the server
	- `domain`: Domain name of the server
	- `port`: Port number for SSH connection
	- `user`: Username for SSH login
	- `pwd`: Password for SSH login (if applicable)
	- `key`: Path to the SSH private key file (if applicable)
	- `notes`: Additional notes about the server
	- `type`: Type of server (e.g., "web", "database", etc.)
	"""
	output.printInfo(f"{__mod_name__} CLI - Version {__version__}")
	output.printInfo("Use 'dotssh --help' for more information on available commands.")


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
def add_server(
	name: Annotated[str, typer.Argument(help="Name of the server")],
	ip4: Annotated[Optional[str], typer.Option(help="IPv4 address of the server")] = None,
	ip6: Annotated[Optional[str], typer.Option(help="IPv6 address of the server")] = None,
	hostname: Annotated[Optional[str], typer.Option(help="Hostname of the server")] = None,
	domain: Annotated[Optional[str], typer.Option(help="Domain name of the server")] = None,
	ssh_user: Annotated[Optional[str], typer.Option(help="SSH username")] = None,
	ssh_pwd: Annotated[Optional[str], typer.Option(help="SSH password (if applicable)")] = None,
	ssh_port: Annotated[int, typer.Option(help="SSH port number")] = 22,
	ssh_key: Annotated[Optional[str], typer.Option(help="Path to SSH private key file (if applicable)")] = None,
	notes: Annotated[Optional[str], typer.Option(help="Additional notes about the server")] = None,
	server_type: Annotated[str, typer.Option(help="Type of server (e.g., web, database)")] = "web"
) -> None:
	"""
	Add a new SSH server configuration.
	"""
	if not registry.isRegister('servers'):
		_createRegistry('servers')

	srvConfig = ServerConfig(
		ip4=ip4,
		ip6=ip6,
		hostname=hostname,
		domain=domain,
		ssh_user=ssh_user,
		ssh_pwd=ssh_pwd,
		ssh_port=ssh_port,
		ssh_key=ssh_key,
		notes=notes,
		server_type=server_type
	)

	registry.addRecord('servers', name, srvConfig.toDict())
	output.printSuccess(f"Server '{name}' added successfully.")


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
def update_server(
	name: Annotated[str, typer.Argument(help="Name of the server")],
	ip4: Annotated[Optional[str], typer.Option(help="IPv4 address of the server")] = None,
	ip6: Annotated[Optional[str], typer.Option(help="IPv6 address of the server")] = None,
	hostname: Annotated[Optional[str], typer.Option(help="Hostname of the server")] = None,
	domain: Annotated[Optional[str], typer.Option(help="Domain name of the server")] = None,
	ssh_user: Annotated[Optional[str], typer.Option(help="SSH username")] = None,
	ssh_pwd: Annotated[Optional[str], typer.Option(help="SSH password (if applicable)")] = None,
	ssh_port: Annotated[int, typer.Option(help="SSH port number")] = 22,
	ssh_key: Annotated[Optional[str], typer.Option(help="Path to SSH private key file (if applicable)")] = None,
	notes: Annotated[Optional[str], typer.Option(help="Additional notes about the server")] = None,
	server_type: Annotated[Optional[str], typer.Option(help="Type of server (e.g., web, database)")] = "web"
) -> None:
	"""
	Update an SSH server configuration.
	"""
	if registry.isRegister('servers'):

		if registry.hasRecord('servers', name):

			record = registry.getRecord('servers', name)

			srvConfig = ServerConfig(dict=record)

			if ip4 is not None:
				srvConfig.ip4 = ip4
			if ip6 is not None:
				srvConfig.ip6 = ip6
			if hostname is not None:
				srvConfig.hostname = hostname
			if domain is not None:
				srvConfig.domain = domain
			if ssh_user is not None:
				srvConfig.ssh_user = ssh_user
			if ssh_pwd is not None:
				srvConfig.ssh_pwd = ssh_pwd
			if ssh_port is not None:
				srvConfig.ssh_port = ssh_port
			if ssh_key is not None:
				srvConfig.ssh_key = ssh_key
			if notes is not None:
				srvConfig.notes = notes
			if server_type is not None:
				srvConfig.server_type = server_type

			registry.updateRecord('servers', name, srvConfig.toDict())
			output.printSuccess(f"Server '{name}' updated successfully.")
		else:
			output.printWarning(f"Server '{name}' does not exist.")
	else:
		output.printError("No 'servers' register found. Please create one first.")


@app.command("get", help="Get an SSH server configuration")
def get_server(name: str) -> None:
	"""
	Get an SSH server configuration.
	"""
	if registry.isRegister('servers'):
		if registry.hasRecord('servers', name):
			config = registry.getRecord('servers', name)
			output.printMessage(f"Server '{name}' configuration:")
			for key, value in config.items():
				output.printMessage(f"  {key}: {value}")
		else:
			output.printWarning(f"Server '{name}' does not exist.")
	else:
		output.printError("No 'servers' register found. Please create one first.")


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



if __name__ == "__main__":
	app()

