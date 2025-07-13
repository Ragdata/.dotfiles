#!/usr/bin/env python3
####################################################################
# dotfiles.meta.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

from dataclasses import dataclass
from pathlib import Path
from typing import Optional

from . import *
from . config import *
from . files import *
from . registry import Registry



@dataclass
class Component:
	""" Represents a component in the dotfiles system. """
	name: str
	desc: str
	tags: list[str]

	_filepath: Path
	_status: int = 1



class Components:
	""" Represents a collection of components in the dotfiles system. """

	_components: list[Component] = []


	def __init__(self, path: Path):
		""" Initialise the Components collection. """
		self.searchPath(path)

	@property
	def components(self) -> list[Component]:
		""" Return the list of components. """
		return self._components

	@property
	def count(self) -> int:
		""" Return the number of components. """
		return len(self._components)


	def searchPath(self, path: Path, clear: bool = False, recursive: bool = True):
		""" Search for components in the specified path. """
		if not path.exists() or not path.is_dir():
			raise NotADirectoryError(f"Path {path} is not a directory.")
		if clear:
			self._components.clear()
		files = [f for f in path.iterdir() if f.is_file()]
		for file in files:
			if file.name == '__init__.py':
				continue
			with open(file, 'r') as f:
				for l in f:
					found = False
					if l.startswith('# METADATA'):
						found = True
						name = ""
						desc = ""
						tags = []
						for line in f:
							if line.startswith('# Name:'):
								name = line.split(':', 1)[1].strip()
							elif line.startswith('# Desc:'):
								desc = line.split(':', 1)[1].strip()
							elif line.startswith('# Tags:'):
								tags = [tag.strip() for tag in line.split(':', 1)[1].split(',')]
							elif line.startswith('# FUNCTIONS'):
								break
						component = Component(name=name, desc=desc, tags=tags, _filepath=file, _status=Registry._status(file))
						self._components.append(component)
					if found:
						break
		if recursive:
			for subdir in path.iterdir():
				if subdir.is_dir():
					self.searchPath(subdir, clear=False, recursive=True)


