. ~/.sh_aliases.sh
eval "$(direnv hook bash)"
. ~/.myshrc.sh
type -P fzf >/dev/null && eval "$(fzf --bash)"
