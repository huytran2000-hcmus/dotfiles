# Setup fzf
# ---------
if [[ ! "$PATH" == */home/huy/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/huy/.fzf/bin"
fi

# Auto-completion
# ---------------
source "/home/huy/.fzf/shell/completion.bash"

# Key bindings
# ------------
source "/home/huy/.fzf/shell/key-bindings.bash"
