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

herdr-app also gets the `main-dots` layout: Herdr's `main` layout with `mods/spaces-dots`, a copy of its `spaces` mod that shows herdr's state dot before each space's name instead of the initial's avatar.
`chezmoi apply` switches herdr-app to it once (`run_onchange_after_8_switch-herdr-app-layout.sh`): through the open window, or, when herdr-app isn't running, in `~/.config/herdr-app/shared.json` for its next start. The script runs again only when it changes, so going back to `main` with `ctrl-shift-l` sticks.
Check the mod after changing it:

```shell
herdr-app check ~/.config/herdr-app/mods/spaces-dots
```

The copies don't update with herdr-app; to pick up a newer `spaces` mod, copy it again and redo the change described at the top of `main.js`.

### Resuming agents after a restart

herdr-app's tabs survive a restart, a logout or `hc server stop`, but come back as fresh shells: the program that ran in them isn't started again. `~/.local/bin/agent-resume` brings back the Claude Code and Codex sessions that were running:

- Their `SessionStart` hooks (`~/.claude/settings.json`, `~/.codex/hooks.json`) put the session on the terminal as `resume.*` labels (`hc get <t> --json` shows them). Codex runs the hook at the session's first message; until then, a Codex started in herdr-app is recorded without a session. After `/new`, the previous session stays recorded until the new one's first message.
- `codex` typed at a prompt in herdr-app runs with `--no-daemon`, as herdr-app's menu starts it: on Codex's shared background server, the session and its hooks run outside the tab and can't be recorded. `command codex` uses the server.
- The first prompt of a shell that came back types `claude --resume <id>` or `codex resume --no-daemon <id>` in the session's folder (`~/.zshrc`). An agent that hadn't been sent anything yet starts fresh there instead.
- Claude comes back on the model and effort its status line showed last, even before its first answer: `~/.claude/effort-recorder.sh` (the status line) records them for each session, and the claude shim (`~/.claude-shim/bin/claude`) adds them, as it does when herdr restores a pane. `codex resume` brings back Codex's own; a Codex that hadn't been sent anything starts on Codex's default model.
- Quitting the agent yourself (`/exit`, `/quit`, Ctrl-C twice, Ctrl-D) removes the labels, so it doesn't come back after the next restart: `~/.zshrc` checks the exit status of agents typed at the prompt, and the `SessionEnd` hooks cover agents started from herdr-app's menu. An agent killed by a signal, as at shutdown, keeps them.

Each tab, and each pane of a split tab, is its own terminal with its own labels, so a space running several agents gets all of them back. A terminal follows one agent: one started while another is suspended with Ctrl-Z replaces its labels.

Codex asks before running hooks it hasn't seen. After `chezmoi apply` adds them, the next Codex start shows **Hooks need review**: choose **Trust all and continue**. If herdr rewrites `~/.codex/hooks.json`, the next `chezmoi apply` adds them back.

To stop resuming, remove the `agent-resume` line from `~/.zshrc`; the hooks only set labels.

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
