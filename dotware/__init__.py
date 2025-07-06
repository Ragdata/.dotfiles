import os
import sys
import logging

from pathlib import Path
from dotenv import load_dotenv

from config import *
from output import *



__pkg_name__ = "dotware"
__version__ = "v0.1.0"


__all__ = ["Message", "echoBlack", "echoRed", "echoGreen", "echoYellow", "echoBlue", "echoMagenta", "echoCyan", "echoLtGrey", "echoGrey",
           "echoPink", "echoLtGreen", "echoYellow", "echoLtBlue", "echoPurple", "echoLtCyan", "echoWhite", "echoDivider", "echoLine", "echoDebug",
		   "echoError", "echoWarning", "echoInfo", "echoSuccess", "echoTip", "echoImportant", "console", "errconsole"]


def initLogger(name: str):
	""" Initialise the logger for the package """

	try:
		logDir = Path(LOG_DIR)
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
