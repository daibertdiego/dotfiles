# Setup fzf
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git 2> /dev/null'
# ---------
if [[ ! "$PATH" == */usr/local/opt/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/usr/local/opt/fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/usr/local/opt/fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/usr/local/opt/fzf/shell/key-bindings.zsh"

export FZF_DEFAULT_COMMAND="fd --type file --hidden --exclude .git --exclude go/pkg --exclude 'cargo' --exclude .cargo --exclude 'node_modules' --exclude 'target' --exclude 'Library' --exclude .rustup --exclude .cache --exclude .m2 --exclude aws-sam-cli-app-templates"

export FZF_DEFAULT_OPTS="-m --height 50% --layout=reverse --border --inline-info 
  --preview-window=:hidden
  --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
  --bind '?:toggle-preview' 
"

export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d --follow --exclude .git --exclude go/pkg --exclude node_modules --exclude Users/diegodaibert/Library . \$HOME"





