MAKEFLAGS += --silent

.ONESHELL:

SHELL := /bin/bash

CUSTOM := "$(HOME)/.dotfiles/custom"
SYSDIR := "$(HOME)/.dotfiles/sys"

.PHONY: clean check checkVenv install uninstall

MODE := $(if $(DEV),dev,prod)

check:
	@echo "Running in $(MODE) mode."

uninstall:
	@echo
	@dot uninstall
	source "$(HOME)/.bashrc"

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
	source "$(HOME)/.bashrc"

checkVenv:
	@if [ -z "$(VIRTUAL_ENV)" ]; then
		if [ ! -d "$(HOME)/.venv/dotenv" ]; then
			python3 -m venv "$(HOME)/.venv/dotenv"
		fi
		source "$(HOME)/.venv/dotenv/bin/activate"
		export PATH="$(HOME)/.venv/dotenv/bin:$$(PATH)"
	fi

clean:
	@echo "Cleaning up..."
	@rm -rf build/ dist/ *.egg-info/
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -delete

# DEBUG target to check variables
debug:
	@echo "DEBUG: MODE=$(MODE)"
	@echo "DEBUG: CUSTOM=$(CUSTOM)"
	@echo "DEBUG: SYSDIR=$(SYSDIR)"
	@echo "DEBUG: VIRTUAL_ENV=$(VIRTUAL_ENV)"
	@echo "DEBUG: PATH=$(PATH)"
	@echo "DEBUG: SHELL=$(SHELL)"
	@echo "DEBUG: SHELLFLAGS=$(SHELLFLAGS)"
	@echo "DEBUG: MAKEFLAGS=$(MAKEFLAGS)"
