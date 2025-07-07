#!/usr/bin/env python3
####################################################################
# dotlib.output.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import typer

from typing import Optional
from dotware.config import *
from rich.console import Console



console = Console()
errconsole = Console(stderr=True)



####################################################################
# Message Class
####################################################################
class Message:
	"""
	A class representing formatted messages with optional colour, prefix, suffix, and stream options
	"""

	def __init__(self, message: str, color: Optional[str] = None, prefix: Optional[str] = None, suffix: Optional[str] = None, err: bool = False, errcode: int = 1, noline: bool = False):
		"""
		Initialize a message object.

		:param message: 	The message to display.
		:param color: 		The color of the message (optional).
		:param prefix: 		A prefix to add to the message (optional).
		:param suffix: 		A suffix to add to the message (optional).
		:param err: 		Whether the message is an error (default: False).
		:param errcode: 	The error code to return if the message is an error (default: 1).
		:param noline: 		Whether to suppress the newline at the end of the message (default: False).
		"""
		self.message = message
		self.color = color
		self.prefix = prefix
		self.suffix = suffix
		self.err = err
		self.errcode = errcode
		self.noline = noline


	def __str__(self) -> str:
		return f"{self.format()}"


	def _getMsg(self) -> None:
		"""
		Applies formatting to the message
		"""
		if self.message == "":
			raise ValueError("Message cannot be empty")

		if self.message == "divider":
			self.message = "=" * 80
			return

		if self.message == "line":
			self.message = "-" * 80
			return

		if self.prefix:
			self.message = f"{self.prefix}{self.message}"

		if self.suffix:
			self.message = f"{self.message}{self.suffix}"

		return


	def format(self) -> str:
		"""
		Format the message with color and prefix/suffix.

		:return: The formatted message string.
		"""
		self._getMsg()

		if self.err:
			self.message = typer.style(self.message, fg=COLOR_ERROR, bold=True)
		elif self.color:
			self.message = typer.style(self.message, fg=self.color)

		return self.message


	def output(self) -> None:
		"""
		Outputs the message to the console
		"""
		if self.noline:
			le = ""
		else:
			le = "\n"

		if self.err:
			errconsole.print(self.message, end="{le}")
		else:
			console.print(self.message, end="{le}")


	def print(self) -> None:
		"""
		Prints the formatted message to the console
		"""
		self.format()
		self.output()



#-------------------------------------------------------------------
# Color Aliases
#-------------------------------------------------------------------
def echoBlack(): lambda msg: Message(msg, color="black").print()
def echoRed(): lambda msg: Message(msg, color="red").print()
def echoGreen(): lambda msg: Message(msg, color="green").print()
def echoGold(): lambda msg: Message(msg, color="yellow").print()
def echoBlue(): lambda msg: Message(msg, color="blue").print()
def echoMagenta(): lambda msg: Message(msg, color="magenta").print()
def echoCyan(): lambda msg: Message(msg, color="cyan").print()
def echoLtGrey(): lambda msg: Message(msg, color="white").print()
def echoGrey(): lambda msg: Message(msg, color="bright_black").print()
def echoPink(): lambda msg: Message(msg, color="bright_red").print()
def echoLtGreen(): lambda msg: Message(msg, color="bright_green").print()
def echoYellow(): lambda msg: Message(msg, color="bright_yellow").print()
def echoLtBlue(): lambda msg: Message(msg, color="bright_blue").print()
def echoPurple(): lambda msg: Message(msg, color="bright_magenta").print()
def echoLtCyan(): lambda msg: Message(msg, color="bright_cyan").print()
def echoWhite(): lambda msg: Message(msg, color="bright_white").print()


#-------------------------------------------------------------------
# Special Styles
#-------------------------------------------------------------------
def echoDivider(): lambda col: Message("divider", color=col).print()
def echoLine(): lambda col: Message("line", color=col).print()
def echoDebug(): lambda msg: Message(msg, color="white", prefix="DEBUG: ").print()

#-------------------------------------------------------------------
# Terminal Message Aliases
#-------------------------------------------------------------------
def echoError(): lambda msg: Message(msg, color=COLOR_ERROR, prefix=SYMBOL_ERROR + " ERROR: ", err=True).print()
def echoWarning(): lambda msg: Message(msg, color=COLOR_WARNING, prefix=SYMBOL_WARNING + " WARNING: ").print()
def echoInfo(): lambda msg: Message(msg, color=COLOR_INFO, prefix=SYMBOL_INFO + " INFO: ").print()
def echoSuccess(): lambda msg: Message(msg, color=COLOR_SUCCESS, prefix=SYMBOL_SUCCESS + " SUCCESS: ").print()
def echoTip(): lambda msg: Message(msg, color=COLOR_TIP, prefix=SYMBOL_TIP + " TIP: ").print()
def echoImportant(): lambda msg: Message(msg, color=COLOR_IMPORTANT, prefix=SYMBOL_IMPORTANT + " IMPORTANT: ").print()
