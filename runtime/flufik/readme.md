<img src="https://github.com/gatblau/artisan/raw/master/artisan.png" width="150" align="right"/>

# Flufik Runtime for Artisan

This runtime uses flufik written in GO which has required functions implemented to build rpm and deb packages, push to
SonarType Nexus3 and JFrog repositories.
Packages build by flufik are valid for any system that is using dnf/yum, apt package managers

At this moment flufik has below functionality:
```shell
host ~ % flufik  

++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
|                                                        |
|                /,,,,\_____________/,,,,\               |
|               |,(  )/,,,,,,,,,,,,,\(  ),|              |
|                \__,,,,___,,,,,___,,,,__/               |
|                  /,,,/(')\,,,/(')\,,,\                 |
|                 |,,,,___ _____ ___,,,,|                |
|                 |,,,/   \\o_o//   \,,,|                |
|                 |,,|       |       |,,|                |
|                 |,,|   \__/|\__/   |,,|                |
|                  \,,\     \_/     /,,/                 |
|                   \__\___________/__/                  |
|     ________________/,,,,,,,,,,,,,\________________    |
|    / \,,,,,,,,,,,,,,,,___________,,,,,,,,,,,,,,,,/ \   |
|   (   ),,,,,,,,,,,,,,/           \,,,,,,,,,,,,,,(   )  |
|    \_/____________,,/             \,,____________\_/   |
|                  /,/               \,\                 |
|                 |,|   I am Flufik   |,|                |
|                 |,|  ready to pack  |,|                |
|                 |,|  apps for Linux |,|                |
|                 |,|                 |,|                |
|                  \,\       O       /,/                 |
|                  /,,\_____________/,,\                 |
|                 /,,,,,,,,,,,,,,,,,,,,,\                |
|                /,,,,,,,,_______,,,,,,,,\               |
|               /,,,,,,,,/       \,,,,,,,,\              |
|              /,,,,,,, /         \,,,,,,,,\             |
|             /_____,,,/           \,,,_____\            |
|            //     \,/             \,/     \\           |
|            \\_____//               \\_____//           |
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Usage:
  flufik [command]

Available Commands:
  build       builds deployment rpm or deb or both packages
  completion  generate the autocompletion script for the specified shell
  help        Help about any command
  pgp         generates pgp key with passphrase
  push        any rpm or deb packages to repositories like nexus3 and jfrog

Flags:
  -h, --help      help for flufik
  -v, --version   version for flufik

Use "flufik [command] --help" for more information about a command.

host ~ % flufik build -h
builds deployment rpm or deb or both packages

Usage:
  flufik build [flags]

Flags:
  -c, --configuration-file string      configuration file used during build, default is current location config.yaml (default "config.yaml")
  -d, --destination-directory string   output directory default is current user ~/.flufik/output (default "/Users/eduardgevorkyan/.flufik/output")
  -h, --help                           help for build
  -p, --package string                 used to identify what type of package to build: values rpm|deb
  
host ~ % flufik push -h
any rpm or deb packages to repositories like nexus3 and jfrog

Usage:
  flufik push [flags]

Flags:
  -a, --arch string          architecture example: for deb amd64, for rpm x86_64
  -c, --component string     only requires for deb packages to push (default "main")
  -d, --dist string          only required for deb packages to push
  -h, --help                 help for push
  -n, --nxcomponent string   Nexus components - apt or yum
  -b, --package string       package name for push
  -p, --password string      repository password
  -m, --path string          path from where take package (default "/Users/eduardgevorkyan/.flufik/output")
  -w, --provider string      jfrog|nexus|generic
  -r, --repository string    repository name for apt or yum
  -l, --url string           repository url
  -u, --user string          repository user (must have permission to upload packages) (default ".")
```
><b>Information:</b> Please refer to full detailed documentation to use flufik, repository is active and all changes are
> visible immediately. Also available version for MacOS: https://github.com/egevorkyan/flufik
> Current active version is: 0.1-3

# Usage

See `version` function in [build](build.yaml) file.

To see which version of the tools are installed run the following command:

```sh
art runc version
```
