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


from typing import Dict


from .. server import Server


app = typer.Typer(rich_markup_mode="rich", invoke_without_command=True)


#-------------------------------------------------------------------
# FUNCTIONS
#-------------------------------------------------------------------


#--------------------------------------------------------------
# SERVER COMMANDS
#--------------------------------------------------------------
@app.command(name="con")
@app.command(name="connect", help="Connect to a remote SSH server")
def connect(config: Dict[str, str]) -> None:
    pass
