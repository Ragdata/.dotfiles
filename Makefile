MAKEFLAGS += --silent

.ONESHELL:

SHELL := /bin/bash

.PHONY: check checkVenv install uninstall

MODE := $(if $(DEV),dev,prod)

check:
	@echo "Running in $(MODE) mode."

uninstall:
	@echo
	@rm -rf $(HOME)/.dotfiles
	@rm -rf $(HOME)/.bashrc.d
	@rm -f $(HOME)/.bashrc
	@rm -f $(HOME)/.profile
	@cp sys/bak/.bashrc $(HOME)/.bashrc
	@cp sys/bak/.profile $(HOME)/.profile
	@echo ".dotfiles successfully uninstalled"
# 	@source $(HOME)/.bashrc

install: checkVenv
	@if [ "$(MODE)" == "dev" ]; then
		@pip install -e .
	else
		@pip install .
	fi
	@dot install

checkVenv:
	@if [ -z "$(VIRTUAL_ENV)" ]; then
		if [ ! -d "$(HOME)/.venv/dotenv" ]; then
			python3 -m venv "$(HOME)/.venv/dotenv"
		fi
		source "$(HOME)/.venv/dotenv/bin/activate"
	fi
