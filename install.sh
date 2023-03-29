# install nix
sh <(curl -L https://nixos.org/nix/install) --no-daemon

nix-env -iA \
    nixpkgs.git \
    nixpkgs.stow \
    nixpkgs.fzf \
    nixpkgs.ripgrep \
    nixpkgs.fd \
    nixpkgs.neovim \
    nixpkgs.glow \

stow git
stow nvim
stow bash
stow fzf

nvim --headless +"Lazy sync" +qall
