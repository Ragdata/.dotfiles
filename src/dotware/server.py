#!/usr/bin/env python3
"""
====================================================================
dotware.server.py
====================================================================
Author:			Ragdata
Date:			19/07/2025
License:		MIT License
Repository:		https://github.com/Ragdata/.dotfiles
Copyright:		Copyright © 2025 Redeyed Technologies
====================================================================
"""

import json

from typing import Dict, List, Annotated, Optional

from pyparsing import Opt



serverTypes = ["LXC", "VM", "Docker", "BareMetal", "Cloud", "VPS", "Other"]


class ServerConfig():


	ip4: Optional[str] = None
	ip6: Optional[str] = None
	hostname: Optional[str] = None
	domain: Optional[str] = None
	ssh_user: Optional[str] = None
	ssh_pwd: Optional[str] = None
	ssh_port: int = 22
	ssh_key: Optional[str] = None
	notes: Optional[str] = None
	server_type: str = "Other"


	def __init__(self, ip4: str | None = None, ip6: str | None = None, hostname: str | None = None, domain: str | None = None,
			  ssh_user: str | None = None, ssh_pwd: str | None = None, ssh_port: int = 22, ssh_key: str | None = None,
			  notes: str | None = None, server_type: str = "Other", dict: Optional[Dict[str, str | int]] = None) -> None:
		"""
		Initialise ServerConfig Class
		"""
		if not dict:
			self.ip4 = ip4
			self.ip6 = ip6
			self.hostname = hostname
			self.domain = domain
			self.ssh_user = ssh_user
			self.ssh_pwd = ssh_pwd
			self.ssh_port = ssh_port
			self.ssh_key = ssh_key
			self.notes = notes
			self.server_type = server_type
		else:
			self._fromDict(dict)


	def toJSON(self) -> str:
		"""
		Convert the ServerConfig to a JSON string.
		"""
		return json.dumps(self, default=lambda o: o.__dict__, sort_keys=True, indent=4)


	def toDict(self) -> Dict[str, str | int | None]:
		"""
		Convert the ServerConfig to a dictionary.
		"""
		return {
			"ip4": self.ip4,
			"ip6": self.ip6,
			"hostname": self.hostname,
			"domain": self.domain,
			"ssh_user": self.ssh_user,
			"ssh_pwd": self.ssh_pwd,
			"ssh_port": self.ssh_port,
			"ssh_key": self.ssh_key,
			"notes": self.notes,
			"type": self.server_type
		}


	def _fromDict(self, data: Dict[str, str | int]) -> None:
		"""
		Load the ServerConfig from a dictionary.

		Args:
			data (Dict[str, str | int]): Dictionary containing server configuration data.
		"""
		for key, val in data.items():
			match key:
				case "ip4":
					self.ip4 = str(val)
				case "ip6":
					self.ip6 = str(val)
				case "hostname":
					self.hostname = str(val)
				case "domain":
					self.domain = str(val)
				case "ssh_user":
					self.ssh_user = str(val)
				case "ssh_pwd":
					self.ssh_pwd = str(val)
				case "ssh_port":
					self.ssh_port = int(val)
				case "ssh_key":
					self.ssh_key = str(val)
				case "notes":
					self.notes = str(val)
				case "type":
					self.server_type = str(val)
				case _:
					raise ValueError(f"Unknown key: {key}")


	def update(self, data: Dict[str, str | int]) -> 'ServerConfig':
		"""
		Update the server configuration with new values.
		"""
		for key, value in data.items():
			match key:
				case "ip4":
					self.ip4 = str(value)
				case "ip6":
					self.ip6 = str(value)
				case "hostname":
					self.hostname = str(value)
				case "domain":
					self.domain = str(value)
				case "ssh_user":
					self.ssh_user = str(value)
				case "ssh_pwd":
					self.ssh_pwd = str(value)
				case "ssh_port":
					self.ssh_port = int(value)
				case "ssh_key":
					self.ssh_key = str(value)
				case "notes":
					self.notes = str(value)
				case "type":
					self.server_type = str(value)
				case _:
					raise ValueError(f"Unknown key: {key}")
		return self




class Server(object):


	_config: Dict[str, str | int] = {}


	def __init__(self, config: Dict[str, str | int]) -> None:
		"""
		Initialise Server Class
		"""
		self._config = config


	def getCredentials(self) -> List[str] | bool:

		creds = []

		if self._config['ssh_user'] and (self._config['ssh_pwd'] or self._config['ssh_key']) and self._config['ssh_port'] and (self._config['ip4'] or self._config['ip6'] or (self._config['hostname'] and self._config['domain'])):
			creds.append(self._config['ssh_user'])
			if self._config['ssh_key']:
				creds.append(self._config['ssh_key'])
			elif self._config['ssh_pwd']:
				creds.append(self._config['ssh_pwd'])
			if self._config['ip6']:
				creds.append(self._config['ip6'])
			elif self._config['ip4']:
				creds.append(self._config['ip4'])
			elif self._config['hostname'] and self._config['domain']:
				creds.append(f"{self._config['hostname']}.{self._config['domain']}")
			creds.append(str(self._config['ssh_port']))
			return creds
		else:
			return False


	def fqdn(self) -> str | bool:
		"""
		Get the fully qualified domain name (FQDN) of the server.

		Returns:
			str: The FQDN in the format "hostname.domain".
		"""
		if self._config['hostname'] and self._config['domain']:
			return f"{self._config['hostname']}.{self._config['domain']}"
		else:
			return False


	def get(self, name: str, default: str = "") -> str | int:
		"""
		Get the value of a server config element
		"""

		return self._config[name]


	def set(self, name: str, value: str) -> None:
		"""
		Set the value of a server config element
		"""

		self._config[name] = value

