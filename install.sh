#. /home/huy/.nix-profile/etc/profile.d/nix.sh install nix
sh <(curl --proto '=https' --tlsv1.2 -L https://nixos.org/nix/install) --daemon
# . /home/huy/.nix-profile/etc/profile.d/nix.sh
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
	. '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi

[ ! -d ~/.setup_backup ] && mkdir ~/.setup_backup && mv ~/.bashrc ~/.profile ~/.setup_backup

nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable

nix-env -iA nixpkgs.git
nix-env -iA nixpkgs.stow
nix-env -iA nixpkgs.ripgrep
nix-env -iA nixpkgs.fd
nix-env -iA nixpkgs.neovim
nix-env -iA nixpkgs.glow
nix-env -iA nixpkgs.fontconfig
nix-env -iA nixpkgs.unzip
nix-env -iA nixpkgs.curl
nix-env -iA nixpkgs.gnutar
nix-env -iA nixpkgs.gzip
nix-env -iA nixpkgs.wget
nix-env -iA nixpkgs.gcc
nix-env -iA nixpkgs.gnumake
nix-env -iA nixpkgs.direnv
nix-env -iA nixpkgs.tldr
nix-env -iA nixpkgs.jq
nix-env -iA nixpkgs.tree
nix-env -iA nixpkgs.mkcert
nix-env -iA nixpkgs.nss_latest
nix-env -iA nixpkgs.nodejs_24

stow -d ~/.dotfiles -t ~ git
stow -d ~/.dotfiles -t ~ nvim
stow -d ~/.dotfiles -t ~ bash
stow -d ~/.dotfiles -t ~ vim
stow -d ~/.dotfiles -t ~ psql
stow -d ~/.dotfiles -t ~ ripgrep
stow -d ~/.dotfiles -t ~ nix

if [ ! -d ~/.fzf ]; then
	git clone --filter=blob:none https://github.com/junegunn/fzf.git ~/.fzf
else
	cd ~/.fzf && git pull && ~/.fzf/install
	pwd
	cd -
fi
~/.fzf/install

mkdir -p ~/.local/share/fonts && sudo wget -q -O /tmp/Hack.zip https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip &&
	unzip -o -q /tmp/Hack.zip -d ~/.local/share/fonts/ && sudo rm -rf /tmp/Hack.zip /tmp/Hack

fc-cache -f -v

[ ! -d ~/.kubectl ] && mkdir ~/.kubectl
stow -d ~/.dotfiles -t ~/.kubectl kubectl

# sudo -s
# apt install stow
# stow -d ~/.dotfiles -t /var/lib/postgresql vim
# stow -d ~/.dotfiles -t /var/lib/postgresql psql
# exit

. ~/.profile

nvim --headless +"Lazy sync" +qall

if [[ "$SHELL" == *"zsh"* ]]; then
	if ! grep -qxF '. ~/.myyprofile.sh'; then
		echo '. ~/.myyprofile.sh' >>~/.zprofile
	fi
	if ! grep -qxF '. ~/.myzshrc.sh'; then
		echo '. ~/.myzshrc.sh' >>~/.zshrc
	fi
elif [[ "$SHELL" == *"bash"* ]]; then
	if ! grep -qxF '. ~/.myprofile' ~/.profile; then
		echo '. ~/.myprofile.sh' >>~/.profile
	fi
	if ! grep -qxF '. ~/.mybashrc.sh' ~/.bashrc; then
		echo '. ~/.mybashrc.sh' >>~/.bashrc
	fi
fi
