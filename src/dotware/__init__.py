import os
import sys
import logging
import subprocess

from pathlib import Path
from dotenv import load_dotenv

from dotware.config import *
from dotware.dotlib.output import *



__pkg_name__ = "dotware"
__version__ = "v0.1.0"



__all__ = ["Message", "formatBlack", "formatRed", "formatGreen", "formatYellow", "formatBlue", "formatMagenta", "formatCyan", "formatLtGrey", "formatGrey",
           "formatPink", "formatLtGreen", "formatYellow", "formatLtBlue", "formatPurple", "formatLtCyan", "formatWhite", "formatDivider", "formatLine", "formatDebug",
		   "formatError", "formatWarning", "formatInfo", "formatSuccess", "formatTip", "formatImportant", "console", "errconsole", "__pkg_name__", "__version__",
		   "initLogger", "version", "comp_types"]


comp_types = ["aliases", "completions", "functions", "plugins"]


def initLogger(name: str):
	""" Initialise the logger for the package """

	try:
		logDir = Path(DOT_LOG)
		logFile = logDir / '{name}.log'
		logLevel = LOG_LEVEL

		if not logDir.exists():
			logDir.mkdir(parents=True, exist_ok=True)

		if not logFile.exists():
			bkpLog = logFile.with_suffix('.bak')
			logFile.replace(bkpLog)

		logging.basicConfig(
			level = logLevel,
			handlers = [ logging.FileHandler(logFile) ]
		)

		logger = logging.getLogger(name)
		logger.info("Logger Initialised")

	except Exception as e:
		raise RuntimeError(f"Failed to initialise logger: {e}")


def version(output: bool = True):
	""" Print the package version """
	if output:
		# Print version to console
		print(f"{__pkg_name__.capitalize()} version {__version__}")
	else:
		# Return version string
		return f"{__version__}"


def captureOutput(command: str, shell: bool = True):
	""" Capture the output of a shell command """
	try:
		if shell:
			result = subprocess.check_output(command, shell=True, text=True)
			return result.strip()
		else:
			subprocess.run(command, shell=False, check=True)
			return None
	except subprocess.CalledProcessError as e:
		raise RuntimeError(f"Command '{command}' failed with error: {e}")
