#!/usr/bin/env python3
####################################################################
# dotware.threads.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import threading


_lock = threading.RLock()


def _acquireLock():
	"""Acquire the global lock."""
	global _lock
	if _lock:
		_lock.acquire()


def _releaseLock():
	"""Release the global lock."""
	global _lock
	if _lock:
		_lock.release()

