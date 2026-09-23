. /etc/zshrc
. ~/.sh_aliases.sh
eval "$(direnv hook zsh)"
. ~/.myshrc.sh
whence -p fzf >/dev/null && source <(fzf --zsh)
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
