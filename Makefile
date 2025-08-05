SHELL := ./make-venv
MAKEFLAGS += --silent

.ONESHELL:

SHELL := /bin/bash

CUSTOM := "$(HOME)/.dotfiles/custom"
SYSDIR := "$(HOME)/.dotfiles/sys"

.PHONY: clean check install uninstall

MODE := $(if $(DEV),dev,prod)

check:
	@echo "Running in $(MODE) mode."

uninstall:
	@echo
	@dot uninstall
	@$(HOME)/.venv/dotenv/bin/pip uninstall -y dotware
	source "$(HOME)/.bashrc"

install:
	@echo
	@if [ "$(MODE)" == "dev" ]; then
		$(HOME)/.venv/dotenv/bin/pip install -e .
	else
		$(HOME)/.venv/dotenv/bin/pip install .
	fi
	@[ ! -d "$(CUSTOM)" ] && mkdir -p "$(CUSTOM)"
	@[ ! -d "$(SYSDIR)" ] && mkdir -p "$(SYSDIR)"
	@if [ "$(MODE)" == "dev" ]; then
		@dot install --debug
	else
		@dot install
	fi
	source "$(HOME)/.bashrc"

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
