#!/usr/bin/env python3
"""
====================================================================
dotware.dotssh.server.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import typer


from .. server import Server


app = typer.Typer(rich_markup_mode="rich", invoke_without_command=True)


#-------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------


#--------------------------------------------------------------
# SERVER COMMANDS
#--------------------------------------------------------------
@app.command(name="add", help="Add a new SSH server configuration")
def add_server(**kwargs) -> None:
    pass


@app.command(name="remove", help="Remove an SSH server configuration")
def remove_server(**kwargs) -> None:
    pass


