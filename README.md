# dotfiles

## Install Software

```shell
# fnm
curl -fsSL https://fnm.vercel.app/install | bash

# node
fnm install 18.16.0
fnm default 18.16.0

# oh-my-zash
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Fig
brew install fig
# if necessary
fig doctor
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
3. 
