#. /home/huy/.nix-profile/etc/profile.d/nix.sh install nix
if [ ! -e /nix/var/nix/profiles/default/bin/nix ]; then
	sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
fi
# . /home/huy/.nix-profile/etc/profile.d/nix.sh
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
	. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi

if ! command -v nix-env >/dev/null; then
	echo "Nix is not available (install failed?). Fix it and rerun install.sh." >&2
	return 1 2>/dev/null || exit 1
fi

OS=$(uname -s)

[ ! -d ~/.setup_backup ] && mkdir ~/.setup_backup && mv ~/.bashrc ~/.profile ~/.setup_backup

nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable

nix-env -iA nixpkgs.git
nix-env -iA nixpkgs.stow
nix-env -iA nixpkgs.ripgrep
nix-env -iA nixpkgs.fd
nix-env -iA nixpkgs.neovim
nix-env -iA nixpkgs.tree-sitter
nix-env -iA nixpkgs.glow
nix-env -iA nixpkgs.fontconfig
nix-env -iA nixpkgs.unzip
nix-env -iA nixpkgs.curl
nix-env -iA nixpkgs.gnutar
nix-env -iA nixpkgs.gzip
nix-env -iA nixpkgs.wget
if [ "$OS" != "Darwin" ] && ! command -v cc >/dev/null; then
	nix-env -iA nixpkgs.gcc
fi
nix-env -iA nixpkgs.gnumake
nix-env -iA nixpkgs.direnv
nix-env -iA nixpkgs.tldr
nix-env -iA nixpkgs.jq
nix-env -iA nixpkgs.tree
nix-env -iA nixpkgs.mkcert
nix-env -iA nixpkgs.nss_latest
nix-env -iA nixpkgs.fzf
nix-env -iA nixpkgs.go
# Separate profile so it doesn't shadow the system java; only jdtls uses it
nix-env -p ~/.local/state/nix/profiles/jdk21 -iA nixpkgs.jdk21

stow -d ~/.dotfiles -t ~ git
stow -d ~/.dotfiles -t ~ nvim
stow -d ~/.dotfiles -t ~ bash
stow -d ~/.dotfiles -t ~ vim
stow -d ~/.dotfiles -t ~ psql
stow -d ~/.dotfiles -t ~ ripgrep
stow -d ~/.dotfiles -t ~ nix
stow --no-folding -d ~/.dotfiles -t ~ opencode

wget -q -O /tmp/Hack.zip https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip
if [ "$OS" = "Darwin" ]; then
	unzip -o -q /tmp/Hack.zip -d ~/Library/Fonts/
else
	mkdir -p ~/.local/share/fonts
	unzip -o -q /tmp/Hack.zip -d ~/.local/share/fonts/
	fc-cache -f -v
fi
rm -rf /tmp/Hack.zip

[ ! -d ~/.kubectl ] && mkdir ~/.kubectl
stow -d ~/.dotfiles -t ~/.kubectl kubectl

# sudo -s
# apt install stow
# stow -d ~/.dotfiles -t /var/lib/postgresql vim
# stow -d ~/.dotfiles -t /var/lib/postgresql psql
# exit

if [[ "$SHELL" == *"zsh"* ]]; then
	if ! grep -qxF '. ~/.myprofile.sh' ~/.zprofile; then
		echo '. ~/.myprofile.sh' >>~/.zprofile
	fi
	if ! grep -qxF '. ~/.myzshrc.sh' ~/.zshrc; then
		echo '. ~/.myzshrc.sh' >>~/.zshrc
	fi
	. ~/.myzshrc.sh
	. ~/.zprofile
elif [[ "$SHELL" == *"bash"* ]]; then
	if ! grep -qxF '. ~/.myprofile.sh' ~/.profile; then
		echo '. ~/.myprofile.sh' >>~/.profile
	fi
	if ! grep -qxF '. ~/.mybashrc.sh' ~/.bashrc; then
		echo '. ~/.mybashrc.sh' >>~/.bashrc
	fi
	. ~/.profile
fi

nvim --headless +"Lazy sync" +qall
