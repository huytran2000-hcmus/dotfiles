# Setup fzf
# ---------
if [[ ! "$PATH" == */home/huy/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/huy/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/huy/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# ------------
source "/home/huy/.fzf/shell/key-bindings.bash"
