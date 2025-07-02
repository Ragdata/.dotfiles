#!/usr/bin/env python3
####################################################################
# install.py
####################################################################
# Author:       Ragdata
# Date:         28/06/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################

import os
import sys
import shutil
import logging

from pathlib import Path


env = [
	('BACKUP_DIR', Path.home() / '.backup'),
	('INSTALL_DIR', Path.home() / '.dotfiles'),
	('LOG_LEVEL', 'INFO')
]

dotdirs = [
	('dots', Path.home()),
	('dots/.bashrc.d', Path.home() / '.bashrc.d'),
	('dots/.bashrc.d/prompts', Path.home() / '.bashrc.d/prompts')
]

skipfiles = ['.gitkeep']


class DotfileInstaller:


	def __init__(self):
		""" Initialize the Class """

		self.cwd = Path.cwd()
		self.src = self.cwd / 'src'
		self.home = Path.home()
		self.user = self.home.name
		self.base = Path(os.environ.get('INSTALL_DIR', self.home / '.dotfiles'))


	def load_env(self):
		""" Load environment variables from .env file """
		try:
			envfile = self.cwd / '.env'

			if envfile.exists():
				with open(envfile, 'r') as f:
					for line in f:
						if line.strip() and not line.startswith('#'):
							if '=' in line:
								key, value = line.split('=', 1)
								os.environ[key.strip()] = value.strip()
			else:
				for key, value in env:
					os.environ[key] = str(value)
		except Exception as e:
			raise RuntimeError(f"Failed to load environment variables: {e}")


	def init_logger(self):
		""" Initialize the logger """
		try:
			log_dir = self.home / '.dotfiles' / 'log'
			log_file = log_dir / 'install.log'
			log_level = os.environ.get('LOG_LEVEL', 'INFO').upper()

			if not log_dir.exists():
				log_dir.mkdir(parents=True, exist_ok=True)

			if log_file.exists():
				bkp_log = log_file.with_suffix('.bak')
				log_file.replace(bkp_log)

			logging.basicConfig(
				level = getattr(logging, log_level, logging.INFO),
				format='%(asctime)s - %(levelname)s - %(message)s',
				handlers = [
					logging.FileHandler(log_file),
					logging.StreamHandler(sys.stdout)
				]
			)
			self.logger = logging.getLogger(__name__)
			self.logger.info("Logger initialized.")
		except Exception as e:
			raise RuntimeError(f"Failed to initialize logger: {e}")


	def check_python(self):
		""" Check Python version is adequate (3.9+) """
		if sys.version_info < (3, 9):
			self.logger.error("Python 3.9 or higher is required.")
			sys.exit(1)
		else:
			self.logger.info(f"Python version {sys.version} is adequate.")


	def make_dir(self, dir: str):
		""" Create a directory if it does not exist """
		try:
			path = Path(dir)
			if not path.exists():
				path.mkdir(parents=True, exist_ok=True)
				path.chmod(0o755)  # Set permissions to rwxr-xr-x
				self.logger.info(f"Created directory: {path}")
			else:
				self.logger.info(f"Directory already exists: {path}")
		except Exception as e:
			self.logger.error(f"Failed to create directory {dir}: {e}")
			raise


	def link_dots(self):
		""" Link dotfiles to home directory """
		try:
			self.logger.info("Linking dotfiles ...")

			custom = self.base / 'custom'

			for dotdir, dest in dotdirs:
				self.logger.debug(f"Processing dotdir: {dotdir} -> {dest}")
				src_dot = self.src / dotdir
				dest_dot = self.base / dotdir
				self.logger.debug(f"Source dot directory: {src_dot}")
				self.logger.debug(f"Destination dot directory: {dest_dot}")

				if not src_dot.exists():
					self.logger.error(f"Source directory does not exist: {src_dot}")
					continue

				if not dest.exists():
					self.make_dir(dest)

				files = [f for f in src_dot.iterdir() if f.is_file()]
				for file in files:
					self.logger.debug(f"Processing file: {file.name}")
					destfile = dest / file.name
					custfile = custom / dotdir / file.name
					dotfile  = dest_dot / file.name

					if dotfile.exists():
						destfile.unlink()  # Remove existing file if it exists
						self.logger.info(f"Removed existing dotfile: {dotfile}")

					shutil.copy(file, dotfile)

					if destfile.exists():
						destfile.unlink()
						self.logger.info(f"Removed existing file: {destfile}")

					if custfile.exists():
						self.logger.info(f"Custom file exists: {custfile}")
						self.linkfile(custfile, destfile)
					else:
						self.logger.info(f"Installing {dotfile} to {destfile}")
						shutil.copy(dotfile, destfile)
		except Exception as e:
			self.logger.error(f"Failed to link dotfiles from {src_dot}: {e}")
			raise


	def linkfile(self, src: str, dest: str):
		""" Create a symbolic link from src to dest """
		try:
			src_path = Path(src)
			dest_path = Path(dest)

			if not src_path.exists():
				self.logger.error(f"Source file does not exist: {src_path}")
				return

			dest_path.symlink_to(src_path)
			self.logger.info(f"Linked {src_path} to {dest_path}")
		except Exception as e:
			self.logger.error(f"Failed to link file: {e}")
			raise


	def install(self, file: Path, dest: Path):
		""" Install a dotfiles file """
		try:
			self.logger.info(f"Processing file: {file.name}")

			file_dest = dest / file.name

			if not file.exists():
				self.logger.error(f"Source file does not exist: {file}")
				return

			if not dest.exists():
				dest.mkdir(parents=True, exist_ok=True)
				self.logger.info(f"Created destination directory: {dest}")

			if file_dest.exists():
				file_dest.unlink()  # Remove existing file if it exists
				self.logger.info(f"Removed existing file: {file_dest}")

			shutil.copy(file, file_dest)
			self.logger.info(f"Installed {file} to {dest}")
		except Exception as e:
			self.logger.error(f"Failed to install file {file}: {e}")
			raise


	def scandir(self, curr_dir: Path):
		""" Recursively scan directories and install files """
		try:
			dirs = [d for d in curr_dir.iterdir() if d.is_dir()]
			for dir in dirs:
				if dir.is_dir():
					self.logger.info(f"Processing directory: {dir}")
					relative_path = dir.relative_to(self.src)
					install_path = self.base / relative_path
					files = [f for f in dir.iterdir() if f.is_file() and not f.name in skipfiles]
					for file in files:
						self.install(file, install_path)
					self.scandir(dir)
		except Exception as e:
			self.logger.error(f"Failed to scan directory tree at {curr_dir}: {e}")
			raise



def main():
	""" Main Entry Point """
	installer = DotfileInstaller()
	installer.load_env()
	installer.init_logger()
	installer.check_python()
	installer.scandir(installer.src)
	installer.link_dots()
	installer.logger.info("Installation completed successfully.")



if __name__ == "__main__":
	main()
