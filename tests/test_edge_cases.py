#!/usr/bin/env python3
####################################################################
# tests.test_edge_cases.py
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
import os
from pathlib import Path
from unittest.mock import Mock, patch

import sys
sys.path.insert(0, str(Path(__file__).parent.parent))

from install import DotfileInstaller


class TestEdgeCases:
    """Test edge cases and error conditions"""

    @pytest.fixture
    def installer_with_mock_logger(self):
        """Create installer with mocked logger"""
        with patch.object(DotfileInstaller, 'initLogger'):
            installer = DotfileInstaller()
            installer.logger = Mock()
            return installer

    def test_scandir_with_permission_denied(self, installer_with_mock_logger):
        """Test scandir handles permission errors gracefully"""
        temp_dir = Path(tempfile.mkdtemp())

        try:
            # Create a directory and make it unreadable
            restricted_dir = temp_dir / "restricted"
            restricted_dir.mkdir()
            restricted_dir.chmod(0o000)  # No permissions

            with pytest.raises(PermissionError):
                installer_with_mock_logger.scandir(restricted_dir)

        finally:
            # Cleanup - restore permissions before deletion
            if restricted_dir.exists():
                restricted_dir.chmod(0o755)
            shutil.rmtree(temp_dir)

    def test_install_with_readonly_destination(self, installer_with_mock_logger):
        """Test install with read-only destination directory"""
        temp_dir = Path(tempfile.mkdtemp())

        try:
            src_file = temp_dir / "source.txt"
            dest_dir = temp_dir / "readonly"

            src_file.write_text("content")
            dest_dir.mkdir()
            dest_dir.chmod(0o444)  # Read-only

            with pytest.raises(PermissionError):
                installer_with_mock_logger.install(src_file, dest_dir)

        finally:
            # Cleanup
            if dest_dir.exists():
                dest_dir.chmod(0o755)
            shutil.rmtree(temp_dir)

    def test_linkfile_with_existing_link(self, installer_with_mock_logger):
        """Test linkfile when destination already exists as symlink"""
        temp_dir = Path(tempfile.mkdtemp())

        try:
            src_file = temp_dir / "source.txt"
            dest_file = temp_dir / "dest.txt"
            old_target = temp_dir / "old_target.txt"

            src_file.write_text("new content")
            old_target.write_text("old content")
            dest_file.symlink_to(old_target)

            # This should raise an exception due to existing symlink
            with pytest.raises(FileExistsError):
                installer_with_mock_logger.linkfile(src_file, dest_file)

        finally:
            shutil.rmtree(temp_dir)

    def test_check_custom_with_invalid_path(self, installer_with_mock_logger):
        """Test _checkCustom with path that can't be made relative"""
        temp_dir = Path(tempfile.mkdtemp())

        try:
            # Create a file outside the base directory
            external_file = Path("/tmp") / "external.txt"

            with pytest.raises(ValueError):
                installer_with_mock_logger._checkCustom(external_file)

        finally:
            shutil.rmtree(temp_dir)
