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
	[[ -z "$(VIRTUAL_ENV)" ]] && echo "No virtual environment found. Skipping uninstall." && echo && exit 0
	@dot uninstall
	@$(HOME)/.venv/dotenv/bin/pip uninstall -y dotware

install:
	@echo
	[[ -z "$(VIRTUAL_ENV)" ]] && echo "No virtual environment found. Skipping install." && echo && exit 0
	@echo "Installing Dotware in $(MODE) mode..."
	@if [ "$(MODE)" == "dev" ]; then
		$(HOME)/.venv/dotenv/bin/pip install -e . -q
	else
		$(HOME)/.venv/dotenv/bin/pip install . -q
	fi
	@echo "Dotware installed successfully."
	@[ ! -d "$(CUSTOM)/scripts" ] && mkdir -p "$(CUSTOM)/scripts"
	@[ ! -d "$(SYSDIR)" ] && mkdir -p "$(SYSDIR)"
	@if [ "$(MODE)" == "dev" ]; then
		@dot install --debug
	else
		@dot install
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
