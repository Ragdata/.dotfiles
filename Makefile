.ONESHELL:

SHELL := /bin/bash

.PHONY: check install uninstall

MODE := $(if $(DEV),dev,prod)

check:
	@echo "Running in $(MODE) mode."

checkVenv:
	@if [ -z "$(VIRTUAL_ENV)" ]; then
		if [ ! -d "$(HOME)/.venv/dotenv" ]; then
			python3 -m venv "$(HOME)/.venv/dotenv"
		fi
		source "$(HOME)/.venv/dotenv/bin/activate"
	fi

uninstall:
	@echo "Uninstalling .dotfiles ..."
	@rm -rf $(HOME)/.dotfiles
	@rm -rf $(HOME)/.bashrc.d
	@rm -f $(HOME)/.bashrc
	@rm -f $(HOME)/.profile
	@cp sys/bak/.bashrc $(HOME)/.bashrc
	@cp sys/bak/.profile $(HOME)/.profile
	@echo "Uninstallation complete."
# 	@source $(HOME)/.bashrc

install:
	checkVenv
	ifeq ($(MODE),dev)
		@pip install -e .
	else
		@pip install .
	endif
	dot install
