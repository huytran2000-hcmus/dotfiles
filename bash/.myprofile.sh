export FZF_DEFAULT_COMMAND="fd --type f --color auto --hidden --no-ignore"

# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_CONFIG"
export FZF_CTRL_T_OPTS="--preview 'head -n 15 {}'"

# export FZF_ALT_C_COMMAND="fd --type d --color auto --hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

export RIPGREP_CONFIG_PATH=~/.ripgreprc

export PATH=$PATH:~/.local/share/nvim/mason

export GOPATH=$HOME/go
PATH=$GOPATH/bin:$PATH
