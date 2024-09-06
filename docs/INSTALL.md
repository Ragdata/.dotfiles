<a name="top"><img height="100" align="right" src="https://raw.githubusercontent.com/Ragdata/media/master/logo/Ragdata-64.svg" alt="Ragdata's Dotfiles" /></a>

![Pre-Release][pre-release]
![Version][version]
![MIT][mit-gold]

# [Ragdata's Dotfiles][repo]

<div align="center">

  <h2>Getting Started</h2>

  _Ideally, this project is intended to be executed on a freshly-installed version of **Ubuntu 22.04.**_

</div>

## [Installation](#top)

### Step 1 - Clone the Repo

```shell
$ git clone https://github.com/Ragdata/.dotfiles ~/.dotfiles
$ cd ~/.dotfiles
```

As soon as you have it, run the setup script.  This will minimally bootstrap `.dotfiles` and allow you to start using it while we talk about configuration options.

```shell
./setup.sh
```

Refresh your terminal session and you're on your way:

```shell
bash -i
```

## [Configuration](#top)

The major configuration files are (yes, there are a few):

```shell
~/.dotfiles/dots/bash_env.bash
```

There is actually very little in this file that you might want to customise for the moment.  The important thing to remember is **YOU SHOULD NEVER EDIT ANY FILE IN THE REPOSITORY DIRECTLY!!**

The correct way to customise the system is to make a copy of the file and save it in the `~/.dotfiles/lib/custom` folder using a path which mirrors the original location of the file.

> **EXAMPLE:** To customise the `bash_env.bash` file mentioned above it would need to be copied to `~/.dotfiles/lib/custom/dots/bash_env.bash`.  From that point forward, your custom version of the file will be used by the system.  This also keeps your changes safe whenever you update the rest of `.dotfiles`.






[pre-release]: https://img.shields.io/badge/Status-Pre--Release-d20000?labelColor=31383f
[version]: https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fragdata%2F.dotfiles%2Fmaster%2F.github%2F.releaserc&query=%24.version&label=Version&color=548af7&labelColor=31383f
[mit-gold]: https://img.shields.io/badge/License-MIT-gold

[release]: https://github.com/ragdata/.dotfiles/releases/tag/v0.1.0
[repo]: https://github.com/ragdata/.dotfiles
