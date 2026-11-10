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

## Linux (VPS)

Ubuntu, CentOS and other distributions. Install `git`, `curl` and `tar` first, then chezmoi into `~/.local/bin`:

```shell
cd ~
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init https://github.com/thundermiracle/dotfiles.git
~/.local/bin/chezmoi diff
~/.local/bin/chezmoi apply -v
```

Log in again after the first `chezmoi apply`: Ubuntu adds `~/bin` and `~/.local/bin` to `PATH` at login only when they exist. CentOS and RHEL add them in `~/.bashrc`.

On ARM64 servers, herdr-file-viewer has no prebuilt Linux binary and is built with `cargo`. Install [rustup](https://rustup.rs) before `chezmoi apply`.
herdr-file-viewer shows plain text until `glow`, `bat` and `delta` are installed. Its `scripts/install-renderers.sh` installs them (`herdr plugin list` shows the plugin folder).

## Intel Macs

Homebrew no longer builds bottles for Intel Macs, so `brew bundle` skips upgrades there and some CLI tools come from elsewhere:

- `herdr`, `glow` and `bat` are downloaded from their GitHub releases to `~/bin` (`.chezmoiexternal.toml`).
- `git-delta` is built with `cargo install`. Install [rustup](https://rustup.rs) before `chezmoi apply`.

## herdr

| Machine | Installs |
| --- | --- |
| Apple Silicon Mac | [herdr-app](https://github.com/herdrdev/herdr-app) (Homebrew cask) and [herdr-core](https://github.com/herdrdev/herdr-core) |
| Intel Mac | the herdr TUI and its plugins. herdr-app has no Intel build |
| Linux (VPS) | the herdr TUI and its plugins, and herdr-core |

herdr-app runs on herdr-core, not on herdr. The VPS gets herdr-core so herdr-app can add it as a machine. herdr-core goes to `~/.local/bin/herdr-core` once; herdr-app and `hc update` keep it current.

The request sound (`~/.config/herdr/sounds/request-voidoll.mp3`) is set in `~/.config/herdr/config.toml` for herdr and in `~/.config/herdr-app/settings.json` (`sounds.blocked`) for herdr-app.
The sound plays where the window is, not where the agent runs, so a VPS plays nothing itself. To hear the VPS's agents, open the VPS from a Mac: in herdr-app, add it as a machine; in herdr, run `herdr --remote <host>`.

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

- herdr and herdr-app request sound (`~/.config/herdr/sounds/request-voidoll.mp3`): VOICEVOX:Voidoll(CV:丹下桜)
