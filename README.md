# Dotfiles

I use [oh-my-zsh](https://ohmyz.sh/#install) so make sure that's installed.

## Usage

Subdirectories are constructed to be used with stow, with the format:
```bash
stow <package> -d <path>/<to>/.dotfiles -t <path>/<to>/<package>/<config>
```

For a package with a directory of files (i.e. wezterm) the target directory must be created before stowing.

For executable scripts, they should either be moved to your path (i.e. /usr/local/bin) or added to your path.

