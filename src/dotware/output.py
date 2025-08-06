#!/usr/bin/env python3
"""
====================================================================
dotware.output.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import typer, logging

from rich.text import Text
from rich.theme import Theme
from rich.measure import Measurement
from rich.console import Console, ConsoleOptions, RenderableType

from typing import Optional, Union

from . config import *
from . logger import Logger


_theme = Theme({
	"info": STYLE_INFO,
	"success": STYLE_SUCCESS,
	"warning": STYLE_WARNING,
	"error": STYLE_ERROR,
	"tip": STYLE_TIP,
	"important": STYLE_IMPORTANT,
	"debug": STYLE_DEBUG,
	"head": STYLE_HEAD,
	"dot": STYLE_DOT,
})


console = Console(theme=_theme)


def clear(home=True) -> None:
	"""
	Clear the console.

	Args:
		home (bool): If True, clear the console and move the cursor to the home position.
	"""
	console.clear(home)


def input(prompt: Union[str, Text], **kwargs) -> str:
	"""
	Get user input from the console.

	Args:
		prompt (Union[str, Text]): The prompt to display to the user.
		**kwargs: Arbitrary keyword arguments.

	Returns:
		str: The user input.
	"""
	return console.input(prompt, **kwargs)


def line(count=1) -> None:
	"""
	Add a newline in the console.

	Args:
		count (int): The number of newlines to add (default: 1).
	"""
	console.line(count)


def measure(renderable: RenderableType, options: Optional[ConsoleOptions] = None) -> Measurement:
	"""
	Measure the size of a renderable object.

	Args:
		renderable (RenderableType): The object to measure.
		options (Optional[ConsoleOptions]): Console options for measurement.

	Returns:
		Measurement: The measured size of the renderable.
	"""
	return console.measure(renderable, options=options)


def pager(renderable: RenderableType, **kwargs) -> None:
	"""
	Display a renderable object in a pager.

	Args:
		renderable (RenderableType): The object to display.
		**kwargs: Arbitrary keyword arguments.
	"""
	with console.pager(**kwargs):
		console.print(renderable)


def printHeader(style: Optional[str] = None, **kwargs) -> None:
	"""
	Print the dotfiles banner and copyright information.
	"""
	msg = ""

	banner = ASSETS / "ascii" / "banner.txt"

	if not banner.exists():
		banner = REPODIR / "sys" / "ascii" / "banner.txt"

	if banner.exists():
		with open(banner, 'r') as f:
			for line in f:
				msg += line

	if msg:
		console.print(msg, style=style, highlight=False, **kwargs)


def printInfo(msg: str, **kwargs) -> None:
	"""
	Print an informational message.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	msg = f"{SYMBOL_INFO} " + msg
	console.print(msg, style="info", highlight=False, **kwargs)


def printSuccess(msg: str, **kwargs) -> None:
	"""
	Print a success message.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	msg = f"{SYMBOL_SUCCESS} " + msg
	console.print(msg, style="success", highlight=False, **kwargs)


def printWarning(msg: str, **kwargs) -> None:
	"""
	Print a warning message.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	msg = f"{SYMBOL_WARNING} WARNING: " + msg
	console.print(msg, style="warning", highlight=False, **kwargs)


def printError(msg: str, **kwargs) -> None:
	"""
	Print an error message.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	msg = f"{SYMBOL_ERROR} ERROR: " + msg
	console.print(msg, style="error", highlight=False, **kwargs)


def printTip(msg: str, **kwargs) -> None:
	"""
	Print a tip message.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	msg = f"{SYMBOL_TIP} " + msg
	console.print(msg, style="tip", highlight=False, **kwargs)


def printImportant(msg: str, **kwargs) -> None:
	"""
	Print an important message.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	msg = f"{SYMBOL_IMPORTANT} " + msg
	console.print(msg, style="important", highlight=False, **kwargs)


def printDebug(msg: str, **kwargs) -> None:
	"""
	Print a debug message.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	msg = f"{SYMBOL_DEBUG} " + msg
	console.print(msg, style="debug", highlight=False, **kwargs)


def printHead(msg: str, **kwargs) -> None:
	"""
	Print a head message.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	msg = f"{SYMBOL_HEAD} " + msg
	console.print(msg, style="head", highlight=False, **kwargs)


def printDot(msg: str, **kwargs) -> None:
	"""
	Print a dot message.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	msg = f"{SYMBOL_DOT} " + msg
	console.print(msg, style="dot", highlight=False, **kwargs)


def printMessage(msg: str, style: Optional[str] = None, **kwargs) -> None:
	"""
	Print a message with an optional style.

	Args:
		msg (str): 	The message to print.
		style (Optional[str]): The style to apply to the message.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	if style:
		console.print(msg, style=style, highlight=False, **kwargs)
	else:
		console.print(msg, highlight=False, **kwargs)


def printRed(msg: str, **kwargs) -> None:
	"""
	Print a message in red.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	if kwargs.get("lt") == True:
		console.print(msg, style="bright_red", highlight=False, **kwargs)
	else:
		console.print(msg, style="red", highlight=False, **kwargs)


def printGreen(msg: str, **kwargs) -> None:
	"""
	Print a message in green.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	if kwargs.get("lt") == True:
		console.print(msg, style="bright_green", highlight=False, **kwargs)
	else:
		console.print(msg, style="green", highlight=False, **kwargs)


def printBlue(msg: str, **kwargs) -> None:
	"""
	Print a message in blue.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	if kwargs.get("lt") == True:
		console.print(msg, style="bright_blue", highlight=False, **kwargs)
	else:
		console.print(msg, style="blue", highlight=False, **kwargs)


def printYellow(msg: str, **kwargs) -> None:
	"""
	Print a message in yellow.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	if kwargs.get("lt") == True:
		console.print(msg, style="bright_yellow", highlight=False, **kwargs)
	else:
		console.print(msg, style="yellow", highlight=False, **kwargs)


def printPurple(msg: str, **kwargs) -> None:
	"""
	Print a message in purple.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	if kwargs.get("lt") == True:
		console.print(msg, style="bright_magenta", highlight=False, **kwargs)
	else:
		console.print(msg, style="magenta", highlight=False, **kwargs)


def printCyan(msg: str, **kwargs) -> None:
	"""
	Print a message in cyan.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	if kwargs.get("lt") == True:
		console.print(msg, style="bright_cyan", highlight=False, **kwargs)
	else:
		console.print(msg, style="cyan", highlight=False, **kwargs)


def printWhite(msg: str, **kwargs) -> None:
	"""
	Print a message in white.

	Args:
		msg (str): 	The message to print.
		**kwargs: 	Arbitrary keyword arguments.
	"""
	if kwargs.get("lt") == True:
		console.print(msg, style="bright_white", highlight=False, **kwargs)
	else:
		console.print(msg, style="white", highlight=False, **kwargs)


def rule(*args) -> None:
	"""
	Draw a line with optional title
	"""
	console.rule(*args)


def status(status: Union[str, Text], **kwargs) -> None:
	"""
	Display a status and spinner
	"""
	console.status(status, **kwargs)



#-------------------------------------------------------------------
# OutLog Class
#-------------------------------------------------------------------
class OutLog(object):
	"""
	A class to handle output messages with concurrent logging capabilities.
	"""


	_logger: Logger


	def __init__(self, logger: Logger):
		"""
		Initialize the OutLog instance.

		Args:
			logger: An optional logger instance for logging messages.
		"""
		self._logger = logger


	def logDebug(self, msg: str, **kwargs) -> None:
		"""
		Log a debug message.

		Args:
			msg (str): The message to log.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self._logger.isEnabledFor(logging.DEBUG):
			self._logger.debug(msg)
		printDebug(msg, **kwargs)


	def logInfo(self, msg: str, **kwargs) -> None:
		"""
		Log an informational message.

		Args:
			msg (str): The message to log.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self._logger.isEnabledFor(logging.INFO):
			self._logger.info(msg)
		printInfo(msg, **kwargs)


	def logWarning(self, msg: str, **kwargs) -> None:
		"""
		Log a warning message.

		Args:
			msg (str): The message to log.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self._logger.isEnabledFor(logging.WARNING):
			self._logger.warning(msg)
		printWarning(msg, **kwargs)


	def logError(self, msg: str, **kwargs) -> None:
		"""
		Log an error message.

		Args:
			msg (str): The message to log.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self._logger.isEnabledFor(logging.ERROR):
			self._logger.error(msg)
		printError(msg, **kwargs)


	def logSuccess(self, msg: str, **kwargs) -> None:
		"""
		Log a success message.

		Args:
			msg (str): The message to log.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self._logger.isEnabledFor(logging.INFO):
			self._logger.info(msg)
		printSuccess(msg, **kwargs)


	def logPrint(self, msg: str, level: int = logging.INFO, style: Optional[str] = None, **kwargs) -> None:
		"""
		Log and print a message with an optional style.

		Args:
			msg (str): The message to log and print.
			style (Optional[str]): The style to apply to the message.
			**kwargs: Arbitrary keyword arguments.
		"""
		if self._logger.isEnabledFor(level):
			self._logger.log(level, msg)
		printMessage(msg, style=style, **kwargs)

