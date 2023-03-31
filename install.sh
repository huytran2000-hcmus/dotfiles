# install nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

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

[ ! -d ~/.setup_backup ] && mkdir ~/.setup_backup && mv ~/.bashrc ~/.profile ~/.setup_backup

[ ! -d ~/.fzf ] && git clone --filter=blob:none https://github.com/junegunn/fzf.git ~/.fzf && . ~/.fzf/install

[ ! -d ~/.local/share/fonts ] && mkdir -p ~/.local/share/fonts && wget -q -O /tmp/Hack.zip https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.zip && \
    unzip -o -q /tmp/Hack.zip -d ~/.local/share/fonts/ && rm -rf /tmp/Hack.zip /tmp/Hack

fc-cache -f -v

. ~/.nix-profile/etc/profile.d/nix.sh
stow -d ~/.dotfiles -t ~ git
stow -d ~/.dotfiles -t ~ nvim
stow -d ~/.dotfiles -t ~ bash
stow -d ~/.dotfiles -t ~ fzf

. ~/.profile

nvim --headless +"Lazy sync" +qall

