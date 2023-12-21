#. /home/huy/.nix-profile/etc/profile.d/nix.sh install nix
curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
. /home/huy/.nix-profile/etc/profile.d/nix.sh

nix-env -iA \
    nixpkgs.git \
    nixpkgs.stow \
    nixpkgs.go \
    nixpkgs.ripgrep \
    nixpkgs.fd \
    nixpkgs.neovim \
    nixpkgs.glow \
    nixpkgs.fontconfig \
    nixpkgs.unzip \
    nixpkgs.curl \
    nixpkgs.gnutar \
    nixpkgs.gzip \
    nixpkgs.wget \
    nixpkgs.gcc \
    nixpkgs.gnumake \
    nixpkgs.direnv \
    nixpkgs.tldr \
    nixpkgs.jq \
    nixpkgs.tree \
    nixpkgs.adoptopenjdk-openj9-bin-11 \
    nixpkgs.maven \
    nixpkgs.mkcert \
    nixpkgs.nss_latest

[ ! -d ~/.setup_backup ] && mkdir ~/.setup_backup && mv ~/.bashrc ~/.profile ~/.setup_backup

if [ ! -d ~/.fzf ] 
then
    git clone --filter=blob:none https://github.com/junegunn/fzf.git ~/.fzf && . ~/.fzf/install
else
    cd ~/.fzf
    git pull
    cd -
fi
~/.fzf/install

mkdir -p ~/.local/share/fonts && sudo wget -q -O /tmp/Hack.zip https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip \
    && unzip -o -q /tmp/Hack.zip -d ~/.local/share/fonts/ && sudo rm -rf /tmp/Hack.zip /tmp/Hack

fc-cache -f -v

. ~/.nix-profile/etc/profile.d/nix.sh
stow -d ~/.dotfiles -t ~ git
stow -d ~/.dotfiles -t ~ nvim
stow -d ~/.dotfiles -t ~ bash
stow -d ~/.dotfiles -t ~ vim
stow -d ~/.dotfiles -t ~ psql

[ ! -d ~/.kubectl ] && mkdir ~/.kubectl
stow -d ~/.dotfiles -t ~/.kubectl kubectl

# sudo -s
# apt install stow
# stow -d ~/.dotfiles -t /var/lib/postgresql vim
# stow -d ~/.dotfiles -t /var/lib/postgresql psql
# exit

. ~/.profile

nvim --headless +"Lazy sync" +qall

