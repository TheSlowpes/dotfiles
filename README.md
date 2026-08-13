# Dotfiles

Cross-platform development environment managed with Bash, GNU Stow, and the `dot` command. Linux package managers and Homebrew are supported.

## Fresh Machine

Clone the repository, inspect the planned operations, and bootstrap the machine:

```sh
git clone https://github.com/TheSlowpes/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./dot bootstrap dev --email you@example.com --dry-run
./dot bootstrap dev --email you@example.com
```

The bootstrap installs:

- GNU Stow, ripgrep, and Neovim build prerequisites
- Zsh and login-shell setup
- tmux and TPM
- GitHub CLI, a dedicated SSH key, and GitHub authentication
- OpenCode through its official installer
- Neovim stable built from source into `~/.local`
- mise with Go 1.26 and Node.js 24
- pnpm 11 through Corepack
- Task, lazygit, Wails v2, gograph, Crit, Hunk, and Sideshow
- CLI dotfiles and the global OpenCode configuration

The command is safe to rerun. Existing keys, authenticated sessions, TPM installations, and dirty Neovim source checkouts are not overwritten. Use `--dry-run` to inspect privileged commands and external installers.

## Development Profiles

Install only part of the environment when a full bootstrap is unnecessary:

```sh
./dot dev list
./dot dev install runtimes
./dot dev install wails
./dot dev install cli
./dot dev install opencode
./dot dev install --all --dry-run
```

| Profile | Contents |
| --- | --- |
| `runtimes` | mise, Node.js 24, Go 1.26, pnpm 11 |
| `wails` | Wails v2.14 and platform desktop build dependencies |
| `cli` | Task, lazygit, gograph, Crit, Hunk, Sideshow |
| `opencode` | Crit integration managed by the OpenCode dotfiles |

Runtime and application versions are pinned in `dot`. Project repositories should still pin their own Node, Go, and pnpm versions.

## Project Integrations

Enable gograph for the current Git repository:

```sh
cd /path/to/go-project
dot project enable gograph --dry-run
dot project enable gograph
```

This builds the project graph and creates a project-local `opencode.json` with the gograph MCP server. It refuses to replace an existing OpenCode project config. Restart OpenCode after enabling an integration.

## OpenCode

The `opencode` Stow component manages:

- Global configuration under `~/.config/opencode/`
- Sideshow MCP integration
- Reusable skills under `~/.config/opencode/skills/`
- The `/crit` review command and Crit CLI skill

Sideshow is global because it is useful across projects. gograph remains project-local because it only applies to Go repositories and exposes a large MCP toolset.

## Dotfile Components

```sh
./dot list
./dot list --all
./dot install zsh nvim tmux opencode
./dot install --profile cli
./dot uninstall tmux
```

| Component | Operating systems | Description |
| --- | --- | --- |
| `zsh` | Linux, macOS | Zsh configuration |
| `nvim` | Linux, macOS | Neovim configuration |
| `tmux` | Linux, macOS | Tmux configuration |
| `ghostty` | Linux, macOS | Ghostty terminal configuration |
| `hyprland` | Linux | Hyprland desktop configuration |
| `opencode` | Linux, macOS | OpenCode configuration, commands, and skills |

Stow runs a simulation before each change. Existing conflicting files are reported and left untouched.

## Lower-Level Commands

```sh
./dot requirements list
./dot requirements install --dry-run
./dot tools list
./dot tools install zsh tmux github opencode nvim --email you@example.com
```

On macOS, install the Xcode Command Line Tools with `xcode-select --install` before bootstrapping. The bootstrap installs Homebrew when it is missing. Wails desktop dependencies vary by platform; run `wails doctor` after installation to identify any host-specific requirement that remains.
