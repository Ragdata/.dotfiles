#!/usr/bin/env python3
####################################################################
# tests.test_integration.py
####################################################################
# Author:       Ragdata
# Date:         06/07/2025
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2025 Redeyed Technologies
####################################################################

import pytest
import tempfile
import shutil
from pathlib import Path
from unittest.mock import patch

import sys
sys.path.insert(0, str(Path(__file__).parent.parent))

from install import DotfileInstaller


class TestDotfileInstallerIntegration:
    """Integration tests for the complete dotfiles installation process"""

    @pytest.fixture
    def integration_setup(self):
        """Set up a complete test environment"""
        temp_dir = Path(tempfile.mkdtemp())

        # Create source structure
        src_dir = temp_dir / "src"
        dots_dir = src_dir / "dots"
        dots_dir.mkdir(parents=True)

        # Create test dotfiles
        (dots_dir / ".bashrc").write_text("export TEST=integration")
        (dots_dir / ".vimrc").write_text("set number")
        (dots_dir / ".gitconfig").write_text("[user]\n    name = Test User")

        # Create nested structure
        bashrc_d = dots_dir / ".bashrc.d"
        bashrc_d.mkdir()
        (bashrc_d / "aliases").write_text("alias ll='ls -la'")

        # Create other directories
        base_dir = temp_dir / "base"
        custom_dir = temp_dir / "custom"
        log_dir = temp_dir / "log"
        home_dir = temp_dir / "home"

        base_dir.mkdir()
        custom_dir.mkdir()
        log_dir.mkdir()
        home_dir.mkdir()

        yield {
            'temp': temp_dir,
            'src': src_dir,
            'base': base_dir,
            'custom': custom_dir,
            'log': log_dir,
            'home': home_dir
        }

        shutil.rmtree(temp_dir)

    def test_full_installation_process(self, integration_setup):
        """Test the complete installation process"""
        dirs = integration_setup

        with patch.multiple(
            'install',
            SRC_DIR=dirs['src'],
            BASEDIR=dirs['base'],
            CUSTOM=dirs['custom'],
            DOT_LOG=dirs['log'],
            LOG_LEVEL=20  # INFO level
        ):
            with patch('install.Path.home', return_value=dirs['home']):
                with patch.object(DotfileInstaller, 'initLogger'):
                    installer = DotfileInstaller()
                    installer.logger = MockLogger() # type: ignore

                    # Run the complete process
                    installer._checkPython()
                    installer.scandir(installer.src)

                    # Verify files were processed
                    base_dots = dirs['base'] / 'dots'
                    assert base_dots.exists()

                    # Check that files were copied to base
                    assert (base_dots / '.bashrc').exists()
                    assert (base_dots / '.vimrc').exists()
                    assert (base_dots / '.gitconfig').exists()


class MockLogger:
    """Mock logger for integration tests"""
    def debug(self, msg): pass
    def info(self, msg): pass
    def warning(self, msg): pass
    def error(self, msg): pass
