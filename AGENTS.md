# AGENTS.md

Personal dotfiles, deployed with GNU Stow. There is no build, test, or CI; changes take effect via the symlinks.

## Layout and deployment

- Each top-level dir (`bash`, `git`, `nvim`, `vim`, `psql`, `ripgrep`, `nix`, `opencode`) is a stow package that mirrors `$HOME`. For example, `nvim/.config/nvim` is symlinked to `~/.config/nvim`, so edits here are live immediately.
- `kubectl` is the exception: `install.sh` stows it into `~/.kubectl`, not `~`.
- The repo must live at `~/.dotfiles` because `install.sh` hardcodes `stow -d ~/.dotfiles`.
- A new top-level package needs its own `stow -d ~/.dotfiles -t ~ <pkg>` line in `install.sh`. A new file inside an existing package needs a re-stow (`stow -R -d ~/.dotfiles -t ~ <pkg>`) unless its parent dir is already a symlink.
- `install.sh` is meant to be **sourced** (`. ~/.dotfiles/install.sh`), not executed. It installs tools with `nix-env -iA nixpkgs.*` (no flakes or home-manager), backs up `~/.bashrc`/`~/.profile`, and appends `. ~/.my*.sh` lines to the user's rc files. Do not run it as a "check"; it uses sudo and changes the machine.
- `install.sh` targets both macOS (Darwin) and Linux; keep OS-specific branches working for both.

## Shell (`bash/`)

- Shell files are hooked into the system rc files, not used in place of them: `.myprofile.sh` (env/PATH, both shells), `.myzshrc.sh` / `.mybashrc.sh` (per shell), both of which source `.sh_aliases.sh` and `.myshrc.sh`.
- `.myshrc.sh` contains `bindkey -e`, which is zsh-only even though bash also sources the file.
- JDKs 8/11/17/21 are nix profiles at `~/.local/state/nix/profiles/jdk<v>` (installed by `install.sh`). `.myprofile.sh` defaults `JAVA_HOME` to jdk17; projects override it in a direnv `.envrc`. `lspconfig/servers/jdtls.lua` hardcodes the same paths for jdtls (jdk21) and its runtimes.

## Neovim (`nvim/.config/nvim`)

- Targets Neovim 0.12 and uses native `vim.lsp.config` / `vim.lsp.enable`, the `nvim-treesitter` `main` branch (parsers compiled with the `tree-sitter` CLI), and `mason-org/*`. Don't reintroduce `require('lspconfig').X.setup`, `nvim-treesitter.configs`, or neodev.
- Entry point: `init.vim` → `lua require("mine")`. The global `PREFIX = "mine."` must prefix every internal require, e.g. `require(PREFIX .. "lspconfig.core")`.
- `lua/mine/utils/init.lua` defines globals that are used everywhere: `NNOREMAP`, `INOREMAP`, `VNOREMAP`, `TNOREMAP`, `AUGROUP`, `AUTOCMD`, `CLEAR_AUTOCMD`, `CMD`.
- Use [LazyVim](https://www.lazyvim.org) ([source](https://github.com/LazyVim/LazyVim)) as the reference when choosing plugins or configuring a language, LSP, DAP, test runner, or formatter. Check its core plugins and `extras/` (e.g. `extras/lang/java.lua`) first and adapt them to this config's structure and keymaps. This config does not depend on LazyVim, so don't `require("lazyvim...")` or import its specs.
- Plugins are lazy.nvim specs. `plugins/init.lua` imports only the subdirs `ui`, `editor`, `coding`, `colorscheme`, `lsp`, `dap`, `util`, and `lang`, so a new plugin file must go in one of them. `lua/mine/archive/` is dead code and is never loaded.
- Per-language setup lives in one file under `plugins/lang/` (e.g. `go.lua`, `java.lua`), like LazyVim's `extras/lang/`. These files only add to the core specs' `opts`: treesitter `ensure_installed`, lspconfig `servers`/`setup`, none-ls `sources` (through an `opts` function), mason `ensure_installed`, neotest `adapters`, and nvim-dap `dependencies`. Keep the core specs language-agnostic. `lang` is imported last because lazy.nvim only applies `opts_extend` to fragments that load after the spec that declares it.
- `config/option.lua` loads before lazy. `func`, `autocmd`, `keymap`, `cmd`, and `diagnostic` load on `User VeryLazy`.
- LSP servers are registered in the nvim-lspconfig `opts.servers` table: general ones in `plugins/lsp/core.lua` (with per-server files in `lspconfig/servers/`), language ones in `plugins/lang/*.lua`. `lspconfig/init.lua` installs the shared LspAttach hooks, and on-attach behavior is in `lspconfig/{core,autoformat,inlay_hint,codelens}.lua`. Shared mason/none-ls tools are in `plugins/lsp/core.lua` and `plugins/lsp/null-ls.lua`; language-specific tools are in `plugins/lang/*.lua`.
- Commit `lazy-lock.json` along with any plugin add/remove/update.
- `lua/.luarc.json` holds stale Linux paths (`/home/huy/...`). Ignore it.
- `nvim` comes from `~/.nix-profile/bin` and may be missing from a non-interactive agent shell. For a quick load check, run `~/.nix-profile/bin/nvim --headless +qa` and look for errors. Ask before running `Lazy sync`/`Lazy update`, because they change the lockfile.

## OpenCode (`opencode/.config/opencode`)

- Stowed with `--no-folding`, so `~/.config/opencode` stays a real directory and only the tracked files are symlinked into it. Re-stow with `stow -R --no-folding -d ~/.dotfiles -t ~ opencode` after adding a file.
- Tracked: `opencode.json`, `cli.json`, `dcp.jsonc`, `oh-my-opencode-slim.json`, and `AGENTS.md`. The global `AGENTS.md` is the only source for general agent rules (style, testing, questions); don't duplicate them into `rules/`.
- Work-specific or secret files stay as untracked files in `~/.config/opencode` and must not be added here: `agent/*` (symlinks into a work repo), `commands/`, `rules/mcporter-discovery.md`, `service.json` (contains a password), `skills/`, `logs/`, and `*.bak`. `opencode.json` loads `rules/mcporter-discovery.md` from its local path via `instructions`.
- OpenChamber config (`~/.config/openchamber`) is not managed here; its `settings.json` holds keys.

## No credentials in the repo

The repo is pushed to GitHub (`git@github.com:huytran2000-hcmus/dotfiles.git`), so every tracked file is upstream content.

- Never commit tokens, API keys, passwords, private keys, kubeconfigs, DB connection strings with passwords, internal hostnames/IPs, or company-specific URLs. This includes adding them to `.sh_aliases.sh`, `.myprofile.sh`, `.psqlrc`, `.gitconfig`, or nvim plugin config (e.g. vim-dadbod connections, Copilot/AI provider keys).
- Machine-specific or secret values belong in untracked files outside the repo, sourced only if they exist, e.g. `[ -f ~/.secrets.sh ] && . ~/.secrets.sh`. They can also go in direnv `.envrc` files inside the projects that need them.
- Stow symlinks mean a file written into a stowed directory, such as `~/.config/nvim/`, is actually created inside this repo. Before committing, check `git status` for files that tools generated there (e.g. caches, session files, `spell/`, credentials written by plugins).
- Before committing, scan the staged diff, e.g. `git diff --cached | grep -iE 'token|secret|passw|api[_-]?key|BEGIN .*PRIVATE'`. If a secret has ever been pushed, rotate it; deleting it in a later commit is not enough.

## Git

- Gitignore for this repo: everything under `nvim/.config/` except `nvim/.config/nvim/` is ignored, and `nvim/.config/nvim/spell/` is ignored.
- Commit messages are short and imperative (e.g. `Add lazygit to neovim`, `feat: upgrade neovim config to 0.12`).
