MAKEFLAGS += --silent

.ONESHELL:

SHELL := /bin/bash

.PHONY: check checkVenv install uninstall

MODE := $(if $(DEV),dev,prod)

check:
	@echo "Running in $(MODE) mode."

uninstall:
	@echo
	@dot uninstall
 	source $(HOME)/.bashrc

install: checkVenv
	@echo
	@if [ "$(MODE)" == "dev" ]; then
		pip install -e .
	else
		pip install .
	fi
	@[ ! -d "$(CUSTOM)" ] && mkdir -p "$(CUSTOM)"
	@[ ! -d "$(SYSDIR)" ] && mkdir -p "$(SYSDIR)"
	@dot install
 	source $(HOME)/.bashrc

checkVenv:
	@if [ -z "$(VIRTUAL_ENV)" ]; then
		if [ ! -d "$(HOME)/.venv/dotenv" ]; then
			python3 -m venv "$(HOME)/.venv/dotenv"
		fi
		source "$(HOME)/.venv/dotenv/bin/activate"
	fi
