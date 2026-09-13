<h1 align="center">myuwi/dots</h1>

## Info

- **OS:** NixOS
- **Desktop:** [Mango](https://github.com/mangowm/mango) + [Quickshell](https://quickshell.org/) + [Fuzzel](https://codeberg.org/dnkl/fuzzel)
- **Term:** [Ghostty](https://ghostty.org/) + Zsh + tmux
- **Editor:** Neovim
- **Fonts:** Inter (UI), JetBrains Mono (Terminal)

## Layout

- `home/` - configuration files, symlinked into `$HOME`
- `nix/` - NixOS configuration for my machines
- `bin/` - scripts on `$PATH`
- `dots.toml` - link manifest for `home/`

## Setup

> [!NOTE]
> I don't advise you to straight up just install these configs on your machine, as they are very much adapted to my specific workflow, but feel free to take inspiration.

```sh
$ git clone https://github.com/myuwi/dots.git .dots
$ cd .dots

$ ./bin/dots apply
```
