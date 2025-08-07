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


from . server import app as srvApp


app = typer.Typer(rich_markup_mode="rich", invoke_without_command=True)

app.add_typer(srvApp, name="server", help="Manage servers")



@app.callback()
def callback() -> None:
	"""
	DotSSH CLI for managing SSH configurations and components.
	"""


#--------------------------------------------------------------
# SSH Commands
#--------------------------------------------------------------
