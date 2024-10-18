import colorama

class msg:

    SUCCESS: str = colorama.Fore.GREEN
    WARN: str = colorama.Fore.YELLOW
    ERROR: str = colorama.Fore.RED
    INFO: str = colorama.Fore.BLUE
    BOLD: str = colorama.Style.BRIGHT
    RESET: str = colorama.Style.RESET_ALL

    @staticmethod
    def success(self, message: str) -> None:
        print(f'{self.BOLD}{self.SUCCESS}{message}{self.RESET}')

    @staticmethod
    def warn(self, message: str) -> None:
        print(f'{self.BOLD}{self.WARN}{message}{self.RESET}')

    @staticmethod
    def error(self, message: str) -> None:
        print(f'{self.BOLD}{self.ERROR}{message}{self.RESET}')

    @staticmethod
    def info(self, message: str) -> None:
        print(f'{self.BOLD}{self.INFO}{message}{self.RESET}')
