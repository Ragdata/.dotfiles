####################################################################
# label_manager.msg.py
####################################################################
# GitHub Repository Label Manager
#
# File:         msg.py
# Package:      label_manager
# Author:       Ragdata
# Date:         14/10/2024
# License:      MIT License
# Repository:	https://github.com/Ragdata/.dotfiles
# Copyright:    Copyright © 2024 Redeyed Technologies
####################################################################
# DEPENDENCIES
####################################################################
import colorama

class msg:

    SUCCESS: str = colorama.Fore.GREEN
    WARN: str = colorama.Fore.YELLOW
    ERROR: str = colorama.Fore.RED
    INFO: str = colorama.Fore.BLUE
    BOLD: str = colorama.Style.BRIGHT
    RESET: str = colorama.Style.RESET_ALL

    def success(self, message: str) -> None:
        print(f'{self.BOLD}{self.SUCCESS}{message}{self.RESET}')

    def warn(self, message: str) -> None:
        print(f'{self.BOLD}{self.WARN}{message}{self.RESET}')

    def error(self, message: str) -> None:
        print(f'{self.BOLD}{self.ERROR}{message}{self.RESET}')

    def info(self, message: str) -> None:
        print(f'{self.BOLD}{self.INFO}{message}{self.RESET}')
