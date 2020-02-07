# Reformation

A cloned, refactored and heavily influenced version of [Formation](https://github.com/minamarkham/formation) by [Mina Markham](https://github.com/minamarkham) (the main difference is that `specs` and `mods` are self contained scripts that are executed by the dummed-down `./reform` parent script)

`reform` is a shell script to set up and keep your Mac 'in form'.

It can be run multiple times on the same machine safely. It installs, upgrades, or skips packages based on the current system state.

## Install / First Run

```sh
git clone git@github.com:landtechnologies/reformation.git && cd reformation
```

Reform!

```sh
./reform 2>&1 | tee ~/reform.log
./reform --specs    # Only run the specs
./reform --mods     # Only run the mods
./reform --force    # Force a re-install of any specs and mods
./reform --help     # Show the help text

# want to run one thing?
./specs/brews
./mods/aws
```

## First Run

Running `./reform` for the first time will add a `~/.reformrc` to your `$HOME` directory. Adding `source ~\.reformrc` to your shell profile will allow you to run `reform` from anywhere for added convenience!

## Specs

`reform` loops over and executes all 'specs' defined in the `./specs` folder.

'Specs' concepts **without** dependencies, such as installing packages, frameworks, libraries etc...

## Mods

`reform` loops over and executes all 'mods' defined in the `./mods` folder.

'Mods' are concepts (that may require dependencies, for example `gopass` and `awscli`) used for modifying your system. Ie aliases, configs, users etc...

## Known Issues

`brew cask` does not recognise applications installed outside of it – in the case that the script fails, you can either remove the application from the install list or uninstall the application causing the failure and try again.

## Tests

```bash
make test
```
