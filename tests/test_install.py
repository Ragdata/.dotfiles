#!/usr/bin/env python3
####################################################################
# tests.test_install.py
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
import logging
from pathlib import Path
from unittest.mock import Mock, patch, MagicMock

# Assuming your install.py is in the parent directory
import sys
sys.path.insert(0, str(Path(__file__).parent.parent))

from install import DotfileInstaller


class TestDotfileInstaller:
    """Test cases for DotfileInstaller class"""

    @pytest.fixture
    def temp_dirs(self):
        """Create temporary directories for testing"""
        temp_dir = Path(tempfile.mkdtemp())
        src_dir = temp_dir / "src"
        base_dir = temp_dir / "base"
        custom_dir = temp_dir / "custom"
        log_dir = temp_dir / "log"

        # Create directory structure
        src_dir.mkdir(parents=True)
        base_dir.mkdir(parents=True)
        custom_dir.mkdir(parents=True)
        log_dir.mkdir(parents=True)

        yield {
            'temp': temp_dir,
            'src': src_dir,
            'base': base_dir,
            'custom': custom_dir,
            'log': log_dir
        }

        # Cleanup
        shutil.rmtree(temp_dir)

    @pytest.fixture
    def mock_config(self, temp_dirs):
        """Mock the config module constants"""
        with patch.multiple(
            'install',
            SRC_DIR=temp_dirs['src'],
            BASEDIR=temp_dirs['base'],
            CUSTOM_DIR=temp_dirs['custom'],
            LOG_DIR=temp_dirs['log'],
            LOG_LEVEL=logging.INFO
        ):
            yield

    @pytest.fixture
    def installer(self, mock_config, temp_dirs):
        """Create a DotfileInstaller instance for testing"""
        with patch.object(DotfileInstaller, 'initLogger'):
            installer = DotfileInstaller()
            installer.logger = Mock()
            installer.cwd = temp_dirs['temp']
            return installer

    def test_init(self, mock_config, temp_dirs):
        """Test DotfileInstaller initialization"""
        with patch.object(DotfileInstaller, 'initLogger') as mock_init_logger:
            installer = DotfileInstaller()

            assert installer.src == temp_dirs['src']
            assert installer.base == temp_dirs['base']
            assert installer.home == Path.home()
            assert installer.user == Path.home().name
            mock_init_logger.assert_called_once()

    def test_check_custom_file_exists(self, installer, temp_dirs):
        """Test _checkCustom when custom file exists"""
        # Create test file structure
        test_file = temp_dirs['base'] / 'test.txt'
        custom_file = temp_dirs['custom'] / 'test.txt'

        test_file.touch()
        custom_file.touch()

        result = installer._checkCustom(test_file)
        assert result == custom_file

    def test_check_custom_file_not_exists(self, installer, temp_dirs):
        """Test _checkCustom when custom file doesn't exist"""
        test_file = temp_dirs['base'] / 'test.txt'
        test_file.touch()

        result = installer._checkCustom(test_file)
        assert result == test_file

    def test_check_python_version_adequate(self, installer):
        """Test _checkPython with adequate Python version"""
        with patch('sys.version_info', (3, 11, 0)):
            installer._checkPython()
            installer.logger.debug.assert_called_with(f"Python version {sys.version} is adequate")

    def test_check_python_version_inadequate(self, installer):
        """Test _checkPython with inadequate Python version"""
        with patch('sys.version_info', (3, 9, 0)):
            with pytest.raises(SystemExit):
                installer._checkPython()
            installer.logger.error.assert_called_with("Python 3.9 or higher is required")

    def test_make_dir_new_directory(self, installer, temp_dirs):
        """Test makeDir creates new directory"""
        new_dir = temp_dirs['temp'] / 'new_directory'

        installer.makeDir(new_dir)

        assert new_dir.exists()
        assert new_dir.is_dir()
        installer.logger.info.assert_called_with(f"Created directory: {new_dir}")

    def test_make_dir_existing_directory(self, installer, temp_dirs):
        """Test makeDir with existing directory"""
        existing_dir = temp_dirs['temp'] / 'existing'
        existing_dir.mkdir()

        installer.makeDir(existing_dir)

        installer.logger.info.assert_called_with(f"Directory already exists: {existing_dir}")

    def test_make_dir_permission_error(self, installer, temp_dirs):
        """Test makeDir handles permission errors"""
        with patch.object(Path, 'mkdir', side_effect=PermissionError("Permission denied")):
            with pytest.raises(PermissionError):
                installer.makeDir(temp_dirs['temp'] / 'failed_dir')

    def test_install_file_success(self, installer, temp_dirs):
        """Test successful file installation"""
        src_file = temp_dirs['src'] / 'test.txt'
        dest_dir = temp_dirs['temp'] / 'dest'

        src_file.write_text("test content")
        dest_dir.mkdir()

        installer.install(src_file, dest_dir)

        dest_file = dest_dir / 'test.txt'
        assert dest_file.exists()
        assert dest_file.read_text() == "test content"

    def test_install_file_source_not_exists(self, installer, temp_dirs):
        """Test install when source file doesn't exist"""
        src_file = temp_dirs['src'] / 'nonexistent.txt'
        dest_dir = temp_dirs['temp'] / 'dest'
        dest_dir.mkdir()

        installer.install(src_file, dest_dir)

        installer.logger.error.assert_called_with(f"Source file does not exist: {src_file}")

    def test_install_creates_dest_directory(self, installer, temp_dirs):
        """Test install creates destination directory if it doesn't exist"""
        src_file = temp_dirs['src'] / 'test.txt'
        dest_dir = temp_dirs['temp'] / 'new_dest'

        src_file.write_text("test content")

        with patch.object(installer, 'makeDir') as mock_make_dir:
            installer.install(src_file, dest_dir)
            mock_make_dir.assert_called_with(dest_dir)

    def test_linkfile_success(self, installer, temp_dirs):
        """Test successful symbolic link creation"""
        src_file = temp_dirs['src'] / 'test.txt'
        dest_file = temp_dirs['temp'] / 'link.txt'

        src_file.write_text("test content")

        installer.linkfile(src_file, dest_file)

        assert dest_file.is_symlink()
        assert dest_file.resolve() == src_file.resolve()

    def test_linkfile_source_not_exists(self, installer, temp_dirs):
        """Test linkfile when source doesn't exist"""
        src_file = temp_dirs['src'] / 'nonexistent.txt'
        dest_file = temp_dirs['temp'] / 'link.txt'

        installer.linkfile(src_file, dest_file)

        installer.logger.error.assert_called_with(f"Source file does not exist: {src_file}")
        assert not dest_file.exists()

    def test_scandir_processes_files(self, installer, temp_dirs):
        """Test scandir processes files correctly"""
        # Create test structure
        test_dir = temp_dirs['src'] / 'subdir'
        test_dir.mkdir()
        test_file = test_dir / 'test.txt'
        test_file.write_text("content")

        with patch.object(installer, 'install') as mock_install:
            installer.scandir(temp_dirs['src'])

            # Should call install for the test file
            mock_install.assert_called()

    def test_scandir_recursive(self, installer, temp_dirs):
        """Test scandir processes directories recursively"""
        # Create nested structure
        level1 = temp_dirs['src'] / 'level1'
        level2 = level1 / 'level2'
        level2.mkdir(parents=True)

        test_file = level2 / 'deep.txt'
        test_file.write_text("deep content")

        with patch.object(installer, 'install') as mock_install:
            installer.scandir(temp_dirs['src'])

            # Should process files at all levels
            mock_install.assert_called()

    def test_scandir_skips_skipfiles(self, installer, temp_dirs):
        """Test scandir skips files in skipfiles list"""
        test_dir = temp_dirs['src'] / 'subdir'
        test_dir.mkdir()

        # Create files, one should be skipped
        regular_file = test_dir / 'regular.txt'
        skip_file = test_dir / '.gitkeep'

        regular_file.write_text("content")
        skip_file.write_text("skip me")

        with patch.object(installer, 'install') as mock_install:
            installer.scandir(temp_dirs['src'])

            # Should only install regular file, not .gitkeep
            calls = mock_install.call_args_list
            installed_files = [call[0][0].name for call in calls]
            assert 'regular.txt' in installed_files
            assert '.gitkeep' not in installed_files


class TestMain:
    """Test the main function"""

    @patch('install.DotfileInstaller')
    def test_main_execution_order(self, mock_installer_class):
        """Test main function executes methods in correct order"""
        mock_installer = Mock()
        mock_installer_class.return_value = mock_installer

        from install import main
        main()

        # Verify method call order
        mock_installer.initLogger.assert_called_once()
        mock_installer._checkPython.assert_called_once()
        mock_installer.scandir.assert_called_once_with(mock_installer.src)
        mock_installer.linkdots.assert_called_once()


if __name__ == "__main__":
    pytest.main([__file__])
