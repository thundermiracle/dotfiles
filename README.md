# dotfiles

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

## Intel Macs

Homebrew no longer builds bottles for Intel Macs, so `brew bundle` skips upgrades there and some CLI tools come from elsewhere:

- `herdr`, `glow` and `bat` are downloaded from their GitHub releases to `~/bin` (`.chezmoiexternal.toml`).
- `git-delta` is built with `cargo install`. Install [rustup](https://rustup.rs) before `chezmoi apply`.

## Containers

- Intel Macs use Docker Desktop, which is installed manually and not managed by chezmoi.
- Apple Silicon Macs use Podman. `~/bin/docker` forwards `docker` commands to `podman`.

Run this once on an Apple Silicon Mac after `chezmoi apply`:

```shell
podman machine init
```

The VM does not start at login. Start it when you need containers:

```shell
podman machine start
```

## Trouble shooting

1. throws error `PATH contains ~/.local/bin and ~/.fig/bin: Path does not contain ~/.local/bin` when running fig doctor

   ```shell
   sudo vim /etc/paths

   # add followings
   /.local/bin
   ```

## Credits

- herdr request sound (`~/.config/herdr/sounds/request-voidoll.mp3`): VOICEVOX:Voidoll(CV:丹下桜)
