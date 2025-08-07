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


from typing import Dict, List, Annotated



serverTypes = ["LXC", "VM", "Docker", "BareMetal", "Cloud", "VPS", "Other"]


	# ip4: str
	# ip6: str
	# hostname: str
	# domain: str
	# ssh_user: str
	# ssh_pwd: str
	# ssh_port: int
	# ssh_key: str
	# ssh_config: str
	# notes: str
	# type: str

class Server(object):


	_config: Dict[str, str] = {}


	def __init__(self, config: Dict[str, str]) -> None:
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


	def get(self, name: str, default: str = "") -> str:
		"""
		Get the value of a server config element
		"""

		return self._config[name]


	def set(self, name: str, value: str) -> None:
		"""
		Set the value of a server config element
		"""

		self._config[name] = value

