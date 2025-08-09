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


from dotware import AliasGroup
from . server import app as srvApp


app = typer.Typer(cls=AliasGroup, rich_markup_mode="rich", invoke_without_command=True)

app.add_typer(srvApp, name="server", help="Manage servers")



@app.callback()
def callback() -> None:
	"""
	DotSSH CLI for performing commands on remote servers.
	"""


#--------------------------------------------------------------
# FUNCTIONS
#--------------------------------------------------------------
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
	pass


@app.command("remove", help="Remove an SSH server configuration")
def remove_server(**kwargs) -> None:
	"""
	Remove an SSH server configuration.
	"""
	pass


@app.command("list", help="List all SSH server configurations")
def list_servers(**kwargs) -> None:
	"""
	List all SSH server configurations.
	"""
	pass


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




