<a name="top"><img height="100" align="right" src="https://raw.githubusercontent.com/Ragdata/media/master/logo/Ragdata-64.svg" alt="Ragdata's Dotfiles" /></a>

[![Codacy grade][codacy-grade]][codacy-repo]
![Pre-Release][pre-release]
![Version][version]

<h1>

[Ragdata's Dotfiles][release]

</h1>

<h3 align="center">My personal dotfiles - and the means to manage them.</h3>

> **These are my `.dotfiles`.  There are many like them, but these ones are mine.  My `.dotfiles` are my best friends.  They are my life.  I must master them as I must master my life.  My `.dotfiles`, without me, are useless.  Without my `.dotfiles`, I am useless.  I must execute my `.dotfiles` true.  I must use them straighter than my enemy who is trying to hack me.  I must hack him before he hacks me ... and I will ...**   

Welcome to Yet Another F'king Dotfiles Repo ...

If you're new to `.dotfiles`, you're not going to have a good time here.  The first thing you might notice about them is that, like me, they are _highly_ opinionated, prone to unexpected mood swings, and don't play well with others - but they'll get the job done.  The next thing you might notice is a distinct lack of documentation (working on it).  If you still want to play, read on ...   

<div align="center">

[![GitHub issues][issues-badge]][issues]
![Last Commit][commit-badge]
![MIT][license-badge]
<br />
[![wakatime][wakatime-badge]][wakatime-repo]

</div>

<hr />

## [Requirements](#top) ❓

- Bash 4+

#### Tested On:

- Ubuntu 22.04 (WSL2)

## [Installation](#top) 📂

#### Step 1 - Clone the repo

```bash
git clone https://github.com/Ragdata/.dotfiles ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

#### Step 2 - Customise your config

Edit the following files according to your needs and save them in your `~/.dotfiles/lib/custom` folder using a path which mirrors the original (ie. `~/.dotfiles/cfg/git/.gitconfig` goes to `~/.dotfiles/lib/custom/cfg/git/.gitconfig`)

```bash
~/.dotfiles/cfg/git/.gitconfig
~/.dotfiles/cfg/git/.gitignore_global

~/.dotfiles/cfg/gnupg/gpg.conf
~/.dotfiles/cfg/gnupg/gpg-agent.conf

~/.dotfiles/cfg/.wslconfig

~/.dotfiles/etc/fstab
~/.dotfiles/etc/resolv.conf
~/.dotfiles/etc/wsl.conf
```

It might also pay for you to have a look at the following files to see if you want to add or remove anything:

```bash
~/.dotfiles/cfg/data/dependencies.list
~/.dotfiles/cfg/data/repositories.list
```

[`^ Top`](#top)

## [Features](#top) ✨

* **Lightweight**
  * `.dotfiles` won't weigh down your system or slow your prompt
* **Customisable**
  * `.dotfiles` won't overwrite your hard work the next time you update
  * _(to be fair, whether they will be read in <em>every</em> instance is a dice roll right now ... working on it ...)_
* **Easy to Use**
  * Includes a number of bin scripts which help you access `.dotfiles` admin functionality
* **Reusable Code**
  * Vast library of functions you can use in your own projects
* **"Themable"**
  * `.dotfiles` includes a selection of prompts to choose from - none of which will soak up your available resources
* **GUI Admin**
  * Thanks to the `dialog` project, menu-driven admin functionality is easily accessible from the command-line.
* **... and more ...**

<div align="center">

![Main Menu][main-menu]

</div>

[`^ Top`](#top)

## [Included 3rd-Party Packages](#top) 📦

* [**Composure**](https://github.com/erichs/composure)<br />
  Copyright © 2012, 2016 Erich Smith<br />MIT Licensed

[`^ Top`](#top)

## [Project Supporters](#top) ❤️

<div align="center">

<h3><a href="https://github.com/sponsors/Ragdata" target="_blank">Click here to find out about available sponsorship opportunities!</a></h3>

<h4>If sponsorship isn't right for you, but you have found my work to be useful in some way,<br />would you please consider buying me a coffee to help keep me going?</h4>

<a href="https://www.buymeacoffee.com/ragdata" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>

</div>

[`^ Top`](#top)

## [Author / Maintainer](#top) 🚧

<div align="center">

[![Ragdata][personal-badge]][github-profile]

</div>

[`^ Top`](#top)

## [Security](#top) 🔐

While I always good security practices, 100% security can never be guaranteed in any software package.  My `Dotfiles` are provided AS IS, and without warranty.  You can find more details in the [LICENSE](LICENSE) file included with this repository.

If you discover any issue regarding the security of this project, please disclose that information responsibly by sending a [security advisory][advisory].  **PLEASE DO NOT CREATE AN ISSUE OR DISCUSSION TOPIC.**  You can read more about this project's security policies [HERE][security]

[`^ Top`](#top)

## [Resources](#top) 📖

[`^ Top`](#top)

## [Copyright & Attributions](#top) ©️

This project incorporates ideas and / or code crafted by the following talented individuals:

- **[Bash-it](https://github.com/Bash-it/bash-it)** (Community Bash Framework)<br />
	Copyright © 2020-2021 Bash-It<br />[MIT Licensed][mit-license] 

- **[Hardening Ubuntu](https://github.com/konstruktoid/hardening)** (Systemd Edition)<br />
  Copyright 2018 Thomas Sjögren (@konstruktoid)<br />[Apache-2.0 Licensed][apache-license]

> "We see much further, and reach much higher,<br>only because we stand upon the shoulders of giants"

[`^ Top`](#top)

## [License](#top) ⚖️

[![MIT][mit-gold]][mit-license]

**Copyright © 2024 Redeyed Technologies**

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[`^ Top`](#top)

<h3 align="center">

If you like this repository, please give it a ⭐ (it really does help)

![GitHub Stars][github-stars]

</h3>

<div align="center">

[![Visitors][visitors-badge]][visitors]
[![By Ragdata][ragdata-badge]][github-profile]

</div>

[main-menu]: https://raw.githubusercontent.com/Ragdata/media/da97bcc61c2697dfcf367a85ef5926f0f063b083/project/.dotfiles/img/menu-screen-800.png

[codacy-grade]: https://img.shields.io/codacy/grade/bd98a6793c0445dca1b4f956411af511?logo=codacy&labelColor=31383f
[commit-badge]: https://img.shields.io/github/last-commit/ragdata/.dotfiles/master?logo=github&style=for-the-badge
[github-stars]: https://img.shields.io/github/stars/ragdata/.dotfiles?style=social
[issues-badge]: https://img.shields.io/github/issues-raw/ragdata/.dotfiles?style=for-the-badge&logo=github
[license-badge]: https://img.shields.io/badge/License-MIT-gold?style=for-the-badge
[mit-gold]: https://img.shields.io/badge/License-MIT-gold
[pre-release]: https://img.shields.io/badge/Status-Pre--Release-d20000?labelColor=31383f
[version]: https://img.shields.io/badge/dynamic/yaml?url=https%3A%2F%2Fraw.githubusercontent.com%2Fragdata%2F.dotfiles%2Fmaster%2F.github%2F.releaserc&query=%24.version&label=Version&color=548af7&labelColor=31383f
[visitors-badge]: https://api.visitorbadge.io/api/combined?path=https%3A%2F%2Fgithub.com%2Fragdata%2F.dotfiles&countColor=%23d20000
[wakatime-badge]: https://wakatime.com/badge/github/Ragdata/.dotfiles.svg?style=for-the-badge

[codacy-repo]: https://app.codacy.com/gh/Ragdata/.dotfiles/dashboard?utm_source=gh&utm_medium=referral&utm_content=&utm_campaign=Badge_grade
[wakatime-repo]: https://wakatime.com/badge/github/Ragdata/.dotfiles

[github-profile]: https://github.com/Ragdata

[release]: https://github.com/ragdata/.dotfiles/releases/tag/v0.1.0
[repo]: https://github.com/ragdata/.dotfiles

[advisory]: https://github.com/ragdata/.dotfiles/security/advisories/new
[all-contributors]: https://allcontributors.org
[apache-license]: https://choosealicense.com/licenses/apache-2.0/
[contributing]: https://github.com/ragdata/.github/blob/master/.github/CONTRIBUTING.md
[issues]: https://github.com/ragdata/.dotfiles/issues
[mit-license]: http://choosealicense.com/licenses/mit/
[security]: https://github.com/ragdata/.dotfiles/security/policy
[sponsors]: https://github.com/sponsors/Ragdata
[visitors]: https://visitorbadge.io/status?path=https%3A%2F%2Fgithub.com%2Fragdata%2F.dotfiles

[ragdata-badge]: https://img.shields.io/badge/-Made_With_☕_By_Ragdata-D20000?style=for-the-badge
[personal-badge]: https://img.shields.io/badge/-Darren_"Ragdata"_Poulton-d20000?style=for-the-badge&labelColor=555555&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABsAAAAgEAYAAACz+d94AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAAAZAAAAGQBeJH1SwAAABl0RVh0U29mdHdhcmUAd3d3Lmlua3NjYXBlLm9yZ5vuPBoAAAnKSURBVFiFtVlrbFTVE/+du7t3a7t3u7vdPhb6pyjFankUiSYWm1gTCsHEWBOpEhEViG9RawXCB1GpNUKaKAFqNFowFkVQxMgj4W2hjRRMlwYQpAil72633W633e7ee8//w3BY+oK2sfPl9JwzZ2Z+M3PmzN6Cc845B8ZrrKkBgOzss2cBoLq6uhoA5s8fb70SxonOnmWMseXLOQeAw4dpNSNDkgBg3z6xP176xw1YIAAAZWUEbNMmsU7zsjKjEQB+/HG89DMRutGS280YYxMnMgYAn35KY1SUpgHAyy/PmsU5552dgv/8ecYYS09PT+ec8/PnxfrFi4wxpiihEABs2UK22Gy6DgBvvUVyrl4dN2CVlYwxdtddFgsAvP8+ra5aRWN0dH/uc+dkGQAyMx96SFEmTnS5GJNlVX3jDc5DIaNx8+aqKr+/oaGpiQBVVtK5adP6y+npofGzz7q7AWDDhsxMzjnv7R0zMPKwLFMEXnqJVtesoXHSpKHF/fbbmTMmk8m0du2KFRaLw7FwIcAY8MordK0bGgCAsUmTaL209KOP/H6/f/v2nJxwuKfngw/IlieeGFp+XR2NRUUGAwCUllIGkHuGBEZALBZVBYAlS2h75UpKsZSUoRWdPUu+W7ly7lyHw+VKSWFM13W9oIBzxoCpU2/l5pxqI2MzZ940gHHO2KVLnEsSY8XFhw97vU1NdXVRUQCwfj1xzZgxUDM54No1mq1fT3f2u+8IaHc3o3L8+efE+OKLxBgbOzQQt5uAr1v36KM2W3y8onDOmCTl55MDBhsgKDMzHA4Gr1yprDSZoqLuuWc4PqILFwh0aen+/R0dzc11dVYrEMmYiGP6k89HOLZtY+TDri7aUBQadZ0Y9u07dUqWZXn79oICRbHb775b13UdeO454ktPv72BgM3Gua4DO3f6fB6Ppj37rNXqdBoM7e2SJI24Jp8/T9xlZevX+/1dXVevPvxwKNTbu2gROfTxx4lPSPT7bwATufu//xFjQcEjj8TFJSefOEEZfOAAwDljNttITRG0dGlvb3c3sGxZMBgIAN9+SwXom2+iomJiRisNoOTt7GQMMJkWLDhxwuttaJgzh/aKi2m8fv0GwkhZpkiZTJzruqbJ8lgB0UkgNzcUurWGPfVUMNjTA5jNY3tmhD2ccx4OGwwUCLO5P09Hxw1g9fWRYwBgtRqNgKb5fGNRDQDz5vX1BYNAXBwlryC7nVIzJycUCgbHKh0wmRiTpM5Oki2ukKD6eomAUAcHiCyNj1dVVTUaGxtplUrGSGjiRF3XNGDJEkq94eiFF2hf8I+OVFVVVbWnp6mJ5gkJYociWF1tJCBud/+0uO++rq6uroYGjyc21uFISmpoWLQoGAwEUlKmTtU0VQUSEigSTicZFh9PkYikGGOMAYqyYMGCBUAodPny5ctAVFRGRkYGAOzatWsX8NNPPp/HA/T1EX9bG2OSBHg8kmQwAK2tVDb++cdgMBqBH34wm2Ni6ut9Pp/P5/N6a2oYY+z++4XlIlA3IlZV1X8j0gGQmbW1R4/KclQUkJ6uquEwMGuWqoZCQHIyARt4ZxITCwsLC4FJk3bs2LEDsNuXLVu2DEhOLi0tLQVkecqUKVMi/OK8kCfkz5hB+srLTSZ62wCgtrZ/BAcCO31amjGDc86vXKHlc+dotNsvXGCMsZQUqkK1tU1N5MHXXlMUhwO4dMlgMJmGTxa/f8+ePXsAVW1vb28HmptXr169GgiH6+vr6wGrNTc3N3f481euUISEvuvXDQaDgUoH57W11dWMMTZ5srCXxpqamTM55/zffwe8JLt3i7/CYQDIyaEEO3NGrHu9lBqvv64odjtw6pTJRH1hfzIaXS6XC5Aks9lsBhIS1q5duxaQJIvFYgG6uw8ePHhw8Lm//jIaZRl49VUC1NY28L3TdcaqqqilmjdPrFKkfvlFzG8eIcaffxZzuoTz5xsMZjNw6NCtcAGgt5fuxKpVFovNBly7Rh6OKNI0TQM4D4fDYcDjKS4uLgZ0PRAIBABZnjx58mSAMYpEXR2df+89RbHZgECA5PcnVWVMlnX92DECMn/+TSDSMMCox6qupgMnT9JqTs7hw62tra1NTYxxzjk1YLdSKEROaGkhz5rNaWlpaYDNlpeXlwdIUkxMTAwgy6mpqalAR8e2bdu2ARMmbNy4cSNgMDgcDkfkvJA3kBjjHHC7jxxpa2tra2wknrlzabe8fPp0zkUvCgDGwQIAYMMGmv36K92jp58mr+zdS9GYPbs/P5CWpqqqCkhSdHR0NNDaWlRUVAQ0N69Zs2ZN5G4Fg2632w309FRUVFQAqtrW1tYGpKVRNRTyBj7eui5JjP3+O6X9M8/QqtVKfMLeW3AM/tnCGGOSRLE5d44UeTxz5jidEyYsXw5omqa53cRrNot3SJTtgSQeZyo+fX0ul65rmtk8XJ+Ylxcb63QCDQ1UrIhCIc4ZY+yBByoqvN7m5q+/pnW7ndru6dOpfkdagSHE38qQn0+gs7JOnPB4GhttNsYAzo8dE9yi/A8kUQSWLrVa4+LI4Li4ixcXL6b5n38OXXQGyiN9R46cPOn1NjdTjw/MmUN25ecPBHQbYET0DOzfL6oNRa6wUJI4B778Ujhh2jQypLWVPLxuXUxMbCywYgVVTfGwChJFJj/fYrHbgZUrqfg0NtJ5Ie+mgRLnjJWUkP5PPqHVnTuprB84MJz9g+7YIOQSALzzDgGsqTl+vLOztdXvz8qy2RITjx+vqjKZZDk7u6SEunbRQYyUTp40mcxm4PRpq1WWgQcfpIeZ6OjR8vLOzpaWYJD0z55NsZk+/Y5234mBqs316yT4+efJ6E2bqJktKSHDdH20gAaSOE/yNC02VtfD4c2bSe/GjSR78eKMjMgnhtvRqL9SUW/28cc0i4nJyrLbExNdLpKxaNHtzg71aWBo+v77ioqOjpaW9naS6/XS1RB670yj/q5IVejDD2mWlFRYGAj4fHv30jVvbh6tvAjRa7huXXe3z3fwIAGKiyN9hYWjlTaGD6ZUhf7+GwCWLMnODoWCwczM9HRV7evbsoV4Blep25Om3XuvpoVCX3zx2GPhcDCYmdneDtDXsaGr3p1ozF+CFy7knHNNI4Bvv/3VV11dnZ2aFh3Nua5v3TpSOcRfWrp1q8/X0QFcvAgAb76Znc055yP/HTiI/ut/Bhw6BBiNc+c6HHZ7QkJ5uaLY7YmJnCuK3Z6Q4HaLOe0fP/7HHwDw5JP/tR3j9t+Od981m63W1FSr1WZLSiKACQlut9VqtycmVlYuXaooipKWNl76xw2YGJ1Op9PpdLkUJS7O5dq9Oz4+Pj4+PilpvPX+H9FzAjWyi5ldAAAAAElFTkSuQmCC