#Suppress last login message from terminal
touch ~/.hushlogin

# Enable vi-mode
fish_vi_key_bindings

# Paths
set -gx GOPATH $HOME/go
set -gx PATH $PATH $GOPATH/bin $HOME/.local/bin $HOME/.local/share/nvim/mason/bin

# For nvim LSP
set -x JAVA_OPTS "-Xmx2G -Xms512M"

# Editor
set -gx EDITOR nvim

alias ls="eza --group-directories-first --icons"
alias ll="eza -l --group-directories-first --icons"
alias la="eza -la --group-directories-first --icons"

# =============================================================================
#
# Utility functions for zoxide.
#

# pwd based on the value of _ZO_RESOLVE_SYMLINKS.
function __zoxide_pwd
    builtin pwd -L
end

# A copy of fish's internal cd function. This makes it possible to use
# `alias cd=z` without causing an infinite loop.
if ! builtin functions --query __zoxide_cd_internal
    if builtin functions --query cd
        builtin functions --copy cd __zoxide_cd_internal
    else
        alias __zoxide_cd_internal='builtin cd'
    end
end

# cd + custom logic based on the value of _ZO_ECHO.
function __zoxide_cd
    __zoxide_cd_internal $argv
end

# =============================================================================
#
# Hook configuration for zoxide.
#

# Initialize hook to add new entries to the database.
function __zoxide_hook --on-variable PWD
    test -z "$fish_private_mode"
    and command zoxide add -- (__zoxide_pwd)
end

# =============================================================================
#
# When using zoxide with --no-cmd, alias these internal functions as desired.
#

if test -z $__zoxide_z_prefix
    set __zoxide_z_prefix 'z!'
end
set __zoxide_z_prefix_regex ^(string escape --style=regex $__zoxide_z_prefix)

# Jump to a directory using only keywords.
function __zoxide_z
    set -l argc (count $argv)
    if test $argc -eq 0
        __zoxide_cd $HOME
    else if test "$argv" = -
        __zoxide_cd -
    else if test $argc -eq 1 -a -d $argv[1]
        __zoxide_cd $argv[1]
    else if set -l result (string replace --regex $__zoxide_z_prefix_regex '' $argv[-1]); and test -n $result
        __zoxide_cd $result
    else
        set -l result (command zoxide query --exclude (__zoxide_pwd) -- $argv)
        and __zoxide_cd $result
    end
end

# Completions.
function __zoxide_z_complete
    set -l tokens (commandline --current-process --tokenize)
    set -l curr_tokens (commandline --cut-at-cursor --current-process --tokenize)

    if test (count $tokens) -le 2 -a (count $curr_tokens) -eq 1
        # If there are < 2 arguments, use `cd` completions.
        complete --do-complete "'' "(commandline --cut-at-cursor --current-token) | string match --regex '.*/$'
    else if test (count $tokens) -eq (count $curr_tokens); and ! string match --quiet --regex $__zoxide_z_prefix_regex. $tokens[-1]
        # If the last argument is empty and the one before doesn't start with
        # $__zoxide_z_prefix, use interactive selection.
        set -l query $tokens[2..-1]
        set -l result (zoxide query --exclude (__zoxide_pwd) --interactive -- $query)
        and echo $__zoxide_z_prefix$result
        commandline --function repaint
    end
end
complete --command __zoxide_z --no-files --arguments '(__zoxide_z_complete)'

# Jump to a directory using interactive search.
function __zoxide_zi
    set -l result (command zoxide query --interactive -- $argv)
    and __zoxide_cd $result
end

# =============================================================================
#
# Commands for zoxide. Disable these using --no-cmd.
#

abbr --erase z &>/dev/null
alias z=__zoxide_z

abbr --erase zi &>/dev/null
alias zi=__zoxide_zi

alias za="zoxide add (pwd)"

# =============================================================================


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

function aws_profile
    set -gx AWS_PROFILE (aws configure list-profiles | fzf)
    echo "Switched to AWS Profile: $AWS_PROFILE"
end

# List windows being used from Aerospace
function ff
    aerospace list-windows --all | fzf --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
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



# Bind new key combinations for FZF 

# Search Directory   |  Ctrl+Alt+F (F for file)      |  --directory
# Search Git Log     |  Ctrl+Alt+L (L for log)       |  --git_log CTRL + L is already being used by tmux
# Search Git Status  |  Ctrl+Alt+S (S for status)    |  --git_status
# Search History     |  Ctrl+R     (R for reverse)   |  --history
# Search Processes   |  Ctrl+Alt+P (P for process)   |  --processes
# Search Variables   |  Ctrl+V     (V for variable)  |  --variables
fzf_configure_bindings --directory=\cf --git_status=\cs --processes=\cp

# ~/.config/fish/config.fish
starship init fish | source
zoxide init fish | source

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
