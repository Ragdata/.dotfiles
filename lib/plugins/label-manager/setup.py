from setuptools import setup

setup(
    name="label_manager",
    version="0.1.0",
    description="Command-line tool for managing GitHub labels",
    packages=["label_manager"],
    author="Ragdata",
    author_email="ragdata@users.noreply.github.com",
    url="https://github.com/ragdata/.dotfiles",
    install_requires=["PyGithub==2.4.0"],
    entry_points={
        "console_scripts": ['label_manager=label_manager.src.cli:run']
    },
    classifiers=["Programming Language :: Python :: 3.10"]
)
