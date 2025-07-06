#!/usr/bin/env python3
####################################################################
# install.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import os
import sys
import shutil
import logging

from pathlib import Path

from dotware.config import *



dotdirs = [
	('dots', Path.home()),
	('dots/.bashrc.d', Path.home() / '.bashrc.d'),
	('dots/.bashrc.d/prompts', Path.home() / '.bashrc.d/prompts')
]


skipfiles = [".gitkeep"]


####################################################################
# Dotfiles Installer Class
####################################################################
class DotfileInstaller:


	def __init__(self):
		""" Initialise the Installer """

		self.cwd = Path.cwd()
		self.src = SRC_DIR
		self.home = Path.home()
		self.user = self.home.name
		self.base = BASEDIR

		self.initLogger()


	def _checkCustom(self, filepath: Path):
		""" Check for overriding files """

		relativePath = filepath.relative_to(BASEDIR)
		customfile = CUSTOM_DIR / relativePath

		if customfile.exists():
			return customfile
		else:
			return filepath


	def _checkPython(self):
		""" Check python version is adequate (3.10+) """
		if sys.version_info < (3, 10):
			self.logger.error("Python 3.9 or higher is required")
			sys.exit(1)
		else:
			self.logger.debug(f"Python version {sys.version} is adequate")


	def initLogger(self):
		""" Initialise the Installer Logger """
		try:

			loggerID = 'install'
			logDir = LOG_DIR
			logFile = logDir / '{loggerID}.log'
			logLevel = LOG_LEVEL

			if not logDir.exists():
				self.makeDir(logDir)

			if logFile.exists():
				bkpLog = logFile.with_suffix('.bak')
				logFile.replace(bkpLog)

			logging.basicConfig(
				level = LOG_LEVEL,
				handlers = [
					logging.FileHandler(logFile),
					logging.StreamHandler(sys.stdout)
				]
			)

			self.logger = logging.getLogger(loggerID)
			self.logger.info("Logger Initialised")

		except Exception as e:
			raise RuntimeError(f"Failed to initialise installer logger: {e}")


	def install(self, file: Path, dest: Path):
		""" Install a dotfiles file """
		try:

			self.logger.info(f"Processing file: {file.name}")

			fileDest = dest / file.name

			if not file.exists():
				self.logger.error(f"Source file does not exist: {file}")
				return

			if not dest.exists():
				self.makeDir(dest)
				self.logger.info(f"Created destination directory: {dest}")

			if fileDest.exists():
				fileDest.unlink()
				self.logger.info(f"Removed existing file: {fileDest}")

			shutil.copy(file, fileDest)
			self.logger.info(f"Installed {file} to {dest}")

		except Exception as e:
			self.logger.error(f"Failed to install file {file}: {e}")
			raise


	def linkdots(self):
		""" Install dotfiles and custom overrides """
		try:

			self.logger.info("Installing dotfiles ...")

			for dotdir, dest in dotdirs:
				self.logger.debug(f"Processing dotdir: {dotdir} -> {dest}")
				srcDot = self.src / dotdir
				destDot = self.base / dotdir
				self.logger.debug(f"Source -> Dest: {srcDot} -> {destDot}")

				if not srcDot.exists():
					self.logger.error(f"Source directory does not exist: {srcDot}")
					continue

				if not dest.exists():
					self.makeDir(dest)
				if not destDot.exists():
					self.makeDir(destDot)

				files = [f for f in srcDot.iterdir() if f.is_file() and not f.name in skipfiles]
				for file in files:
					self.logger.debug(f"Processing file: {file.name}")
					destfile = dest / file.name
					dotfile = destDot / file.name

					if dotfile.exists():
						destfile.unlink()
						self.logger.info(f"Removed existing dotfile: {dotfile}")

					shutil.copy(file, dotfile)

					if destfile.exists():
						destfile.unlink()
						self.logger.info(f"Removed existing file: {destfile}")

					srcfile = self._checkCustom(file)

					if 'custom' in str(srcfile):
						self.logger.info(f"Custom file exists: {srcfile}")
						self.linkfile(srcfile, destfile)
					else:
						self.logger.info(f"Installing {dotfile} to {destfile}")
						shutil.copy(dotfile, destfile)

		except Exception as e:
			self.logger.error(f"Failed to install dotfiles from {srcDot}: {e}")
			raise


	def linkfile(self, src: Path | str, dest: Path | str):
		""" Create a symbolic link from src to dest """
		try:

			srcPath = Path(src)
			destPath = Path(dest)

			if not srcPath.exists():
				self.logger.error(f"Source file does not exist: {srcPath}")
				return

			destPath.symlink_to(srcPath)
			self.logger.info(f"Linked {srcPath} to {destPath}")

		except Exception as e:
			self.logger.error(F"Failed to link file: {e}")
			raise


	def makeDir(self, dir: Path | str, perms: int = 0o755):
		""" Create directory if it does not exist """
		try:

			path = Path(dir)
			if not path.exists():
				path.mkdir(parents=True, exist_ok=True)
				path.chmod(perms)
				self.logger.info(f"Created directory: {dir}")
			else:
				self.logger.info(f"Directory already exists: {path}")

		except Exception as e:
			self.logger.error(f"Failed to create directory {dir}: {e}")
			raise


	def scandir(self, currDir: Path):
		""" Recursively scan directories and install files """
		try:

			dirs = [d for d in currDir.iterdir() if d.is_dir()]
			for dir in dirs:
				self.logger.info(f"Processing directory: {dir}")
				relativePath = dir.relative_to(self.src)
				installPath = self.base / relativePath
				files = [f for f in dir.iterdir() if f.is_file() and not f.name in skipfiles]
				for file in files:
					self.install(file, installPath)
				self.scandir(dir)

		except Exception as e:
			self.logger.error(f"Failed to scan directory tree at {currDir}: {e}")
			raise





def main():
	""" Main Entry Point """
	installer = DotfileInstaller()
	installer.initLogger()
	installer._checkPython()
	installer.scandir(installer.src)
	installer.linkdots()
	installer.logger.info("Dotfiles installation complete.")



if __name__ == "__main__":
	main()



