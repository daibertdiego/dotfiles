#Suppress last login message from terminal
touch ~/.hushlogin

# Enable vi-mode
fish_vi_key_bindings

# Paths
set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin $HOME/.local/bin $HOME/.local/share/nvim/mason/bin

# Editor
set -gx EDITOR nvim

alias ls="eza --group-directories-first --icons"
alias ll="eza -l --group-directories-first --icons"
alias la="eza -la --group-directories-first --icons"

alias zz="z"  # zoxide
alias zb="zoxide add (pwd)"

alias z="zoxide"
function z_with_fzf
    zoxide query -i | fzf --preview "eza --icons --tree {} | head -100" --preview-window=right:60% | read dir
    cd $dir
end
alias zz="z_with_fzf"

# Cache API Keys dynamically with LastPass
function load_api_keys
    set -lx OPENAI_API_CACHE "$HOME/.cache/openai_api_key"
    set -lx ANTHROPIC_API_CACHE "$HOME/.cache/anthropic_api_key"

    if not test -f $OPENAI_API_CACHE
        lpass show ChatGPT_API_KEY --field=API_KEY > $OPENAI_API_CACHE
    end

    if not test -f $ANTHROPIC_API_CACHE
        lpass show Cloude_API_KEY --field=API_KEY > $ANTHROPIC_API_CACHE
    end

    set -gx OPENAI_API_KEY (cat $OPENAI_API_CACHE)
    set -gx ANTHROPIC_API_KEY (cat $ANTHROPIC_API_CACHE)
end

function fish_greeting
    set now (date '+%A, %B %d %Y, %H:%M:%S')
    echo "📅 $now"
    echo "  "
    echo "Salve $(whoami)!"
    echo "🐔 🔺 🇧🇷"
end

set fzf_preview_dir_cmd eza --all --color=always

# Call the function to load keys
load_api_keys

# ~/.config/fish/config.fish
starship init fish | source
zoxide init fish | source
