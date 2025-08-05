<a name="top" href="https://github.com/ragdata" target="_blank"><img height="100" align="right" src="https://raw.githubusercontent.com/Ragdata/media/master/logo/Ragdata-64.svg" alt="Dotfiles" /></a>

<!-- [![Codacy grade][codacy-grade]][codacy-repo] -->
![Pre-Release][pre-release]
<!-- [![Version][version-badge]][release] -->

<h1>

[Dotfiles][release]

</h1>

<div align="center">

### _My Personal Dotfiles<br>(and the means to manage them)_

</div>

> These are my .dotfiles. There are many like them, but these ones are mine. My .dotfiles are my best friends. They are my life. I must master them as I must master my life. My .dotfiles, without me, are useless. Without my .dotfiles, I am useless. I must execute my .dotfiles true. I must use them straighter than my enemy who is trying to hack me. I must hack him before he hacks me ... and I will ...

<div align="center">

[![GitHub issues][issues-badge]][issues]
![Last Commit][last-commit]
[![AGPL][license-badge]][mit-license]
<br />
[![wakatime][wakatime-badge]][wakatime-repo]

</div>

<div align="center">

<a href="https://bsky.app/profile/aever.au" target="_blank"><img alt="Bluesky" src="https://img.shields.io/badge/Bluesky-0085ff?style=flat-square&logo=bluesky&logoColor=white" /></a>
<a href="mailto:github.discharge208@passfwd.com" target="_blank"><img alt="Bluesky" src="https://img.shields.io/badge/Email-00B4F0?style=flat-square&logo=maildotru&logoColor=white" /></a>
<a href="https://discord.com/users/146165361333633024" target="_blank"><img alt="Discord" src="https://img.shields.io/badge/Discord-5865f2?style=flat-square&logo=discord&logoColor=white" /></a>

</div>

## [Overview](#top) 📑

<!-- markdownlint-disable-next-line MD026 --->
### Welcome to yet another fucking dotfile repository!

These are the very first files I drop onto any machine I set up — bare metal or virtual, it doesn’t matter. Why? Because they guarantee my environment feels just right, no matter where I am. Inside you’ll find slick aliases, custom functions, completions, and plenty more.

Keeping everything running smooth is a lightweight command-line utility written in Python. It takes inspiration from the big-name environment managers, but skips the bloat (and yes, you even get to pick your own prompt style!).

## [Installation](#top) 📂

### Step 1 - Clone this Repository

Clone this repo to a directory anywhere under your user's home directory.

```shell
git clone https://github.com/ragdata/.dotfiles.git
```

### Step 2 - Create Virtual Environment

(This only needs to be done once - once complete you can skip this step and go straight to step 3.  And yes, I'm sorry - you need to create the virtual environment exactly as shown because it is referenced in the makefile)

```shell
cd ~
python3 -m venv ~/.venv/dotenv
```

### Step 3 - Activate Virtual Environment

```shell
source ~/.venv/dotenv/bin/activate
```

Once `.dotfiles` is installed, an alias will automatically load allowing you to activate the virtual environment using the following command:

```shell
dotenv
```

To deactivate the virtual environment, use the `deactivate` command as usual.

### Step 4 - Run the Installer

```shell
cd .dotfiles
make install
source ~/.bashrc
```

And that's it, you're ready to go!

[`^ Top`](#top)

<!-- ## [Tests](#top) 🏏

There are a bunch of tests available for the package.  You don't NEED to run them manually as a GitHub Actions Workflow makes sure everything is tested as it's committed - but just in case you WANT to, it's all configured via the `Makefile` in the project root.

The following commands are used to initiate tests manually:

```shell
# Install test dependencies
make install-test-deps

# Run all tests
make test

# Run specific test categories
make test-unit
make test-integration
make test-edge-cases

# Run with coverage report
make test-coverage

# Lint and format code
make lint
make format

# Clean up test artifacts
make clean

# Run tests in parallel
pytest tests/ -n auto

# Run specific test file
pytest tests/test_install.py -v

# Run tests matching pattern
pytest tests/ -k "test_install" -v

# Run slow tests only
pytest tests/ -m "slow" -v
```

[`^ Top`](#top)

## [Resources](#top) 📖

[`^ Top`](#top) -->

## [Security](#top) 🔐

> [!warning]
>If you discover any issue regarding the security of this project, please disclose that information responsibly by sending a [security advisory][advisory].  **PLEASE DO NOT CREATE AN ISSUE OR DISCUSSION TOPIC.**  You can read more about this project's security policies [HERE][security]

While I always good security practices, 100% security can never be guaranteed in any software package.  `Dotfiles` is provided AS IS, and without warranty.  You can find more details in the [LICENSE](LICENSE) file included with this repository.

[`^ Top`](#top)

## [License](#top) ⚖️

<div align="center">

[![MIT][license-badge]][mit-license]

Copyright © 2025 Redeyed Technologies

[_**CLICK HERE FOR THE FULL TEXT OF THIS LICENSE**_][mit-license]

<!-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. -->

****
&nbsp;

<a href="https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fragdata%2F.dotfiles" target="_blank"><img alt="Visitors" src="https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fgithub.com%2Fragdata%2F.dotfiles&countColor=%23d20000" /></a>
<a href="https://github.com/Ragdata" target="_blank"><img alt="Ragdata" src="https://img.shields.io/badge/-Made_With_☕_By_Ragdata-D20000?style=for-the-badge" /></a>

<h4>

If you like this repository, please give it a ⭐ (it really does help)

<img alt="GitHub repository stars" src="https://img.shields.io/github/stars/ragdata/.dotfiles?style=social">

</h4>

Copyright &copy; 2025 Redeyed Technologies
</div>

[//]: # (############################################################)

[release]: https://github.com/ragdata/.dotfiles/releases/tag/0.1.0
<!-- [gh-pages]: https://ragdata.github.io/.dotfiles/
[repo]: https://github.com/ragdata/.dotfiles -->

[pre-release]: https://img.shields.io/badge/Status-Pre--Release-d20000?labelColor=31383f
[issues-badge]: https://img.shields.io/github/issues-raw/ragdata/.dotfiles?style=for-the-badge&logo=github
[license-badge]: https://img.shields.io/badge/License-MIT-gold?style=for-the-badge
[last-commit]: https://img.shields.io/github/last-commit/ragdata/.dotfiles/master?style=for-the-badge
<!-- [version-badge]: https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fragdata%2F.dotfiles%2Fmaster%2F.releaserc&query=%24.version&prefix=v&label=Version&labelColor=31383f&color=cd4800 -->

[issues]: https://github.com/ragdata/.dotfiles/issues
[mit-license]: https://choosealicense.com/licenses/mit/

[wakatime-badge]: https://wakatime.com/badge/user/7e04d9d4-3a44-495e-b622-69fdbafd036c/project/c9c26aac-fe71-4e32-a25b-1dac175853f6.svg?style=for-the-badge
[wakatime-repo]: https://wakatime.com/badge/user/7e04d9d4-3a44-495e-b622-69fdbafd036c/project/c9c26aac-fe71-4e32-a25b-1dac175853f6

[advisory]: https://github.com/ragdata/.dotfiles/security/advisories/new
[security]: https://github.com/ragdata/.dotfiles/security/policy

<!-- [all-contributors]: https://allcontributors.org
[contributing]: https://github.com/ragdata/.github/blob/master/.github/CONTRIBUTING.md -->

<!-- [ragdata-repo]: https://github.com/Ragdata -->
