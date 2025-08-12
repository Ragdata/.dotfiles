#!/usr/bin/env python3
"""
====================================================================
dotware.registry.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import json


from typing import Dict, Union, Optional


from . config import *
from . logger import Logger



#-------------------------------------------------------------------
# Registry Class
#-------------------------------------------------------------------
class Registry(object):


	_instance = None

	_loggers: Dict[str, Logger] = {}


	def __new__(cls):

		if cls._instance is None:
			cls._instance = super(Registry, cls).__new__(cls)
			if not REG_CACHE.exists():
				REG_CACHE.mkdir(parents=True, exist_ok=True, mode=0o755)
			if not REG_COMP.exists():
				REG_COMP.mkdir(parents=True, exist_ok=True, mode=0o755)
		return cls._instance


	# --------------------------------------------------------------
	# Component Management
	# --------------------------------------------------------------
	def _checkComponent(self, name: str) -> int:
		return 0


	def disable(self, name: str) -> int:
		return 0


	def enable(self, name: str) -> int:
		return 0


	def status(self, name: str) -> int:
		return 0

	# --------------------------------------------------------------
	# Data Management
	# --------------------------------------------------------------
	def addRegister(self, name: str) -> None:
		"""
		Add a new register to the registry.

		Args:
			name (str): Name of the register to add.
		"""
		registerPath = REGISTRY / f"{name}.json"
		if not registerPath.exists():
			registerPath.touch(mode=0o644)
		else:
			raise FileExistsError(f"Register '{name}' already exists in the registry.")


	def deleteRegister(self, name: str) -> None:
		"""
		Delete a register from the registry.

		Args:
			name (str): Name of the register to delete.
		"""
		registerPath = REGISTRY / f"{name}.json"

		if registerPath.exists():
			registerPath.unlink()
		else:
			raise FileNotFoundError(f"Register '{name}' does not exist in the registry.")


	def isRegister(self, name: str) -> bool:
		"""
		Check if a register exists in the registry.

		Args:
			name (str): Name of the register to check.

		Returns:
			bool: True if the register exists, False otherwise.
		"""
		registerPath = REGISTRY / f"{name}.json"

		return registerPath.exists()


	def addRecord(self, name: str, id: str, record: dict) -> None:
		"""
		Add a record to a register in the registry.

		Args:
			name (str): Name of the register to add the record to.
			record (dict): Record data to add.
		"""
		registerPath = REGISTRY / f"{name}.json"

		if registerPath.exists():
			try:
				with open(registerPath, 'r+', encoding='utf-8') as file:
					data = json.load(file)
					data[id] = record
					file.seek(0)
					json.dump(data, file, indent=4)
					file.truncate()
			except json.JSONDecodeError:
				with open(registerPath, 'w', encoding='utf-8') as file:
					json.dump({id: record}, file, indent=4)
		else:
			raise FileNotFoundError(f"Register '{name}' does not exist in the registry.")


	def deleteRecord(self, name: str, id: str) -> None:
		"""
		Delete a record from a register in the registry.

		Args:
			name (str): Name of the register to delete the record from.
			id (str): ID of the record to delete.
		"""
		registerPath = REGISTRY / f"{name}.json"

		if registerPath.exists():
			try:
				with open(registerPath, 'r+', encoding='utf-8') as file:
					data = json.load(file)
					if id in data:
						del data[id]
						file.seek(0)
						json.dump(data, file, indent=4)
						file.truncate()
					else:
						raise KeyError(f"Record with ID '{id}' does not exist in register '{name}'.")
			except json.JSONDecodeError:
				raise ValueError(f"Register '{name}' is empty or corrupted.")
		else:
			raise FileNotFoundError(f"Register '{name}' does not exist in the registry.")


	def updateRecord(self, name: str, id: str, record: dict) -> None:
		"""
		Update a record in a register in the registry.

		Args:
			name (str): Name of the register to update the record in.
			id (str): ID of the record to update.
			record (dict): New record data to update.
		"""
		registerPath = REGISTRY / f"{name}.json"

		if registerPath.exists():
			try:
				with open(registerPath, 'r+', encoding='utf-8') as file:
					data = json.load(file)
					if id in data:
						data[id] = record
						file.seek(0)
						json.dump(data, file, indent=4)
						file.truncate()
					else:
						raise KeyError(f"Record with ID '{id}' does not exist in register '{name}'.")
			except json.JSONDecodeError:
				raise ValueError(f"Register '{name}' is empty or corrupted.")
		else:
			raise FileNotFoundError(f"Register '{name}' does not exist in the registry.")


	def getRecord(self, name: str, id: str, default: Optional[dict] = None) -> dict:
		"""
		Get a record from a register in the registry.

		Args:
			name (str): Name of the register to get the record from.
			id (str): ID of the record to get.

		Returns:
			dict: Record data if found, None otherwise.
		"""
		registerPath = REGISTRY / f"{name}.json"

		if registerPath.exists():
			try:
				with open(registerPath, 'r', encoding='utf-8') as file:
					data = json.load(file)
					return data.get(id, None)
			except json.JSONDecodeError:
				raise ValueError(f"Register '{name}' is empty or corrupted.")
		else:
			raise FileNotFoundError(f"Register '{name}' does not exist in the registry.")


	def getRecords(self, name: str) -> Dict[str, dict]:
		"""
		Get all records from a register in the registry.

		Args:
			name (str): Name of the register to get records from.

		Returns:
			Dict[str, dict]: Dictionary of all records in the register.
		"""
		registerPath = REGISTRY / f"{name}.json"

		if registerPath.exists():
			try:
				with open(registerPath, 'r', encoding='utf-8') as file:
					data = json.load(file)
					return data
			except json.JSONDecodeError:
				raise ValueError(f"Register '{name}' is empty or corrupted.")
		else:
			raise FileNotFoundError(f"Register '{name}' does not exist in the registry.")


	def hasRecord(self, name: str, id: str) -> bool:
		"""
		Check if a record exists in a register in the registry.

		Args:
			name (str): Name of the register to check.
			id (str): ID of the record to check.

		Returns:
			bool: True if the record exists, False otherwise.
		"""
		registerPath = REGISTRY / f"{name}.json"

		if registerPath.exists():
			try:
				with open(registerPath, 'r', encoding='utf-8') as file:
					data = json.load(file)
					return id in data
			except json.JSONDecodeError:
				raise ValueError(f"Register '{name}' is empty or corrupted.")
		else:
			raise FileNotFoundError(f"Register '{name}' does not exist in the registry.")


	def clearRegister(self, name: str) -> None:
		"""
		Clear all records from a register in the registry.

		Args:
			name (str): Name of the register to clear.
		"""
		registerPath = REGISTRY / f"{name}.json"

		if registerPath.exists():
			with open(registerPath, 'w', encoding='utf-8') as file:
				json.dump({}, file, indent=4)
		else:
			raise FileNotFoundError(f"Register '{name}' does not exist in the registry.")


	def listRegisters(self) -> Dict[str, str]:
		"""
		List all registers in the registry.

		Returns:
			Dict[str, str]: Dictionary of register names and their paths.
		"""
		registers = {}

		for file in REGISTRY.glob("*.json"):
			registers[file.stem] = str(file.resolve())

		return registers


	# --------------------------------------------------------------
	# Logger Management
	# --------------------------------------------------------------
	def addLogger(self, name: str, logger: Logger) -> None:
		"""
		Store a logger instance in the registry.

		Args:
			name (str): Name of the logger.
			logger (Logger): Logger instance to store.
		"""
		self._loggers[name] = logger


	def getLogger(self, name: str) -> Logger:
		"""
		Retrieve a logger instance from the registry.

		Args:
			name (str): Name of the logger.

		Returns:
			Logger: Logger instance associated with the given name.
		"""
		if name in self._loggers:
			return self._loggers[name]
		else:
			raise ValueError(f"Logger '{name}' does not exist in the registry.")


	def getLoggers(self) -> Dict[str, Logger]:
		"""
		Retrieve all logger instances from the registry.

		Returns:
			Dict[str, Logger]: Dictionary of logger instances.
		"""
		return self._loggers


	def hasLogger(self, name: str) -> bool:
		"""
		Check if a logger instance exists in the registry.

		Args:
			name (str): Name of the logger.

		Returns:
			bool: True if the logger exists, False otherwise.
		"""
		return name in self._loggers


	def removeLogger(self, name: str) -> None:
		"""
		Remove a logger instance from the registry.

		Args:
			name (str): Name of the logger to remove.
		"""
		if name in self._loggers:
			del self._loggers[name]


