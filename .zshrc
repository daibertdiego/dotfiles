# zmodload zsh/zprof
# Enable Powerlevel10k instant prompt for fast startup
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell" # Consider a lightweight theme if robbyrussell is slow

# Plugins: Lazy-load where possible
zstyle ':omz:plugins:nvm' lazy yes
plugins=(git zsh-vi-mode fzf) # Minimal plugins for better performance
source $ZSH/oh-my-zsh.sh

# Use lazy-loading for zsh-autosuggestions and zsh-syntax-highlighting
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#8a8a8a"
if [[ $- == *i* ]]; then
  source ~/.oh-my-zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  source ~/.oh-my-zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Paths
export GOPATH="$HOME/go"
export PATH=$PATH:$GOPATH/bin:$HOME/.local/bin:$HOME/.local/share/nvim/mason/bin

# Powerlevel10k
source /usr/local/opt/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

autoload -Uz compinit
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
compinit -C

# NVM: Use lazy-loading
export NVM_DIR="$HOME/.nvm"

load_nvm() {
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

nvm() {
  load_nvm
  command nvm "$@"
}


# Cache API Keys
OPENAI_API_CACHE="$HOME/.cache/openai_api_key"
ANTHROPIC_API_CACHE="$HOME/.cache/anthropic_api_key"

if [[ ! -f $OPENAI_API_CACHE ]]; then
  lpass show ChatGPT_API_KEY --field=API_KEY > $OPENAI_API_CACHE
fi
if [[ ! -f $ANTHROPIC_API_CACHE ]]; then
  lpass show Cloude_API_KEY --field=API_KEY > $ANTHROPIC_API_CACHE
fi

export OPENAI_API_KEY=$(cat $OPENAI_API_CACHE)
export ANTHROPIC_API_KEY=$(cat $ANTHROPIC_API_CACHE)

# FZF configurations
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_COMMAND="fd --type f . $HOME"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d . $HOME"
bindkey '^r' fzf-history-widget

# SDKMAN
lazy_sdkman() {
  export SDKMAN_DIR="$HOME/.sdkman"
  [[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"
}
alias sdk="lazy_sdkman"

# zprof
