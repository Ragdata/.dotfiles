#!/usr/bin/env python3
####################################################################
# tests.conftest.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

"""
Shared pytest fixtures and configuration for all tests.
"""

import pytest
import tempfile
import shutil
import logging
from pathlib import Path
from unittest.mock import Mock


@pytest.fixture(scope="session")
def test_data_dir():
    """Create a temporary directory with test data for the entire test session."""
    temp_dir = Path(tempfile.mkdtemp(prefix="dotfiles_test_"))

    # Create comprehensive test file structure
    setup_test_structure(temp_dir)

    yield temp_dir

    # Cleanup after all tests
    shutil.rmtree(temp_dir, ignore_errors=True)


@pytest.fixture
def temp_workspace():
    """Create a fresh temporary workspace for each test."""
    temp_dir = Path(tempfile.mkdtemp(prefix="dotfiles_workspace_"))

    yield temp_dir

    # Cleanup after each test
    shutil.rmtree(temp_dir, ignore_errors=True)


@pytest.fixture
def mock_logger():
    """Provide a mock logger for testing."""
    logger = Mock(spec=logging.Logger)
    logger.debug = Mock()
    logger.info = Mock()
    logger.warning = Mock()
    logger.error = Mock()
    logger.critical = Mock()
    return logger


@pytest.fixture
def sample_dotfiles():
    """Sample dotfiles content for testing."""
    return {
        '.bashrc': '''
# Sample bashrc
export PATH="$PATH:$HOME/.local/bin"
alias ll='ls -la'
alias grep='grep --color=auto'
        '''.strip(),

        '.vimrc': '''
" Sample vimrc
set number
set autoindent
set tabstop=4
syntax on
        '''.strip(),

        '.gitconfig': '''
[user]
    name = Test User
    email = test@example.com
[core]
    editor = vim
[alias]
    st = status
    co = checkout
        '''.strip(),

        '.tmux.conf': '''
# Sample tmux config
set -g prefix C-a
unbind C-b
bind C-a send-prefix
        '''.strip()
    }


def setup_test_structure(base_dir: Path):
    """Set up a comprehensive test directory structure."""
    # Source directories
    src_dir = base_dir / "src"
    dots_dir = src_dir / "dots"
    bashrc_d = dots_dir / ".bashrc.d"
    prompts_dir = bashrc_d / "prompts"

    # Create directory structure
    prompts_dir.mkdir(parents=True)

    # Create sample dotfiles
    dotfiles_content = {
        '.bashrc': 'export TEST_VAR="test_value"\n',
        '.vimrc': 'set number\nset autoindent\n',
        '.gitconfig': '[user]\n    name = Test User\n',
        '.tmux.conf': 'set -g prefix C-a\n'
    }

    for filename, content in dotfiles_content.items():
        (dots_dir / filename).write_text(content)

    # Create .bashrc.d files
    (bashrc_d / "aliases").write_text("alias ll='ls -la'\n")
    (bashrc_d / "functions").write_text("function mkcd() { mkdir -p \"$1\" && cd \"$1\"; }\n")

    # Create prompt files
    (prompts_dir / "simple.sh").write_text("PS1='\\u@\\h:\\w\\$ '\n")
    (prompts_dir / "fancy.sh").write_text("PS1='\\[\\e[1;32m\\]\\u@\\h\\[\\e[0m\\]:\\[\\e[1;34m\\]\\w\\[\\e[0m\\]\\$ '\n")

    # Create .gitkeep files (should be skipped)
    (dots_dir / ".gitkeep").write_text("")
    (bashrc_d / ".gitkeep").write_text("")

    # Create other required directories
    (base_dir / "base").mkdir()
    (base_dir / "custom").mkdir()
    (base_dir / "log").mkdir()
    (base_dir / "home").mkdir()

    # Create custom override examples
    custom_dir = base_dir / "custom" / "dots"
    custom_dir.mkdir(parents=True)
    (custom_dir / ".bashrc").write_text("# Custom bashrc override\nexport CUSTOM=true\n")

