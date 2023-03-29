# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# go
export GOROOT=/usr/local/go
PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go
PATH=$PATH:$GOPATH/bin


# fzf
if [[ ! "$PATH" == */home/huy/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/huy/.fzf/bin"
fi

export FZF_DEFAULT_CONFIG="fd --type f ---color=never --hidden --no-ignore"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_CONFIG"
export FZF_CTRL_T_OPTS="--preview 'head -n 15 {}'"

export FZF_ALT_C_COMMAND="fd --type d --color=never --hidden"
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"

if [ -e /home/huy/.nix-profile/etc/profile.d/nix.sh ]; then . /home/huy/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer