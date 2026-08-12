# Only configure interactive shells
[[ -o interactive ]] || return

# Use vim key bindings in the shell
bindkey -v

# Meta/UTF-8 settings
setopt COMBINING_CHARS

# History configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=32768
SAVEHIST=32768
setopt APPEND_HISTORY         # Append to the history file
setopt SHARE_HISTORY          # Share history across sessions
setopt HIST_IGNORE_DUPS       # Ignore consecutive duplicate commands
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicate commands
setopt HIST_IGNORE_SPACE      # Ignore commands starting with a space
setopt HIST_REDUCE_BLANKS     # Remove unnecessary blanks
setopt HIST_VERIFY            # Edit expanded history before executing it

# Completion configuration
autoload -Uz compinit
compinit
zmodload zsh/complist

setopt COMPLETE_IN_WORD       # Complete at the cursor
setopt ALWAYS_TO_END          # Move the cursor to the end after completion
unsetopt MENU_COMPLETE        # Do not select a match on the first Tab
setopt AUTO_LIST              # List ambiguous matches
setopt LIST_AMBIGUOUS         # Insert a shared prefix before listing matches
setopt AUTO_MENU              # Select matches after another Tab

zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=* l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' list-prompt ''
zstyle ':completion:*' select-prompt ''
zstyle ':completion:*' match-hidden-files off

bindkey '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

# Interactive shell behavior
setopt AUTO_CD
setopt EXTENDED_GLOB
setopt INTERACTIVE_COMMENTS
unsetopt BEEP

export EDITOR="nvim"
export PATH="$HOME/.local/bin:$PATH"
export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi
export MANROFFOPT="-c"
