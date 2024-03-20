# dotfiles

## Install Software

```shell
# oh-my-zash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

## Install Homebrew

```shell
# install homebrew from bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install chezmoi

```shell
brew install chezmoi
chezmoi init https://github.com/thundermiracle/dotfiles.git
chezmoi diff
chezmoi apply -v
```

## Trouble shooting

1. throws error `PATH contains ~/.local/bin and ~/.fig/bin: Path does not contain ~/.local/bin` when running fig doctor
   ```shell
   sudo vim /etc/paths

   # add followings
   /.local/bin
   ```
