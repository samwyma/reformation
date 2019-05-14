# Reformation

A cloned, refactored and heavily influenced version of [Formation](https://github.com/minamarkham/formation) by [Mina Markham](https://github.com/minamarkham)

Reform is a shell script to set up and keep your Mac 'in form'.

It can be run multiple times on the same machine safely. It installs, upgrades, or skips packages based on the current system state.

## Install

```sh
git clone git@github.com:landtechnologies/reformation.git && cd reformation
```

Reform!

```sh
./reform
```

## Specs

`reform` loops over and executes all 'specs' defined in the `./specs` folder. 'Specs' are used for installing packages, frameworks, libraries etc...

## Mods

`reform` loops over and executes all 'mods' defined in the `./mods` folder. 'Mods' are used for modifying your system. Think... aliases, kernel tweaks, users etc...

## Known Issues

`brew cask` does not recognise applications installed outside of it – in the case that the script fails, you can either remove the application from the install list or uninstall the application causing the failure and try again.
