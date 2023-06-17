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
