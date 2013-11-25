# Prevent <ctrl-s> from freezing 
stty -ixon

bindkey -v
bindkey \\C-R history-incremental-search-backward

unsetopt share_history
setopt COMPLETE_IN_WORD
setopt RM_STAR_SILENT

export PAGER=more
export TERM=xterm-256color
export EDITOR=vim

###### ALIASES #####
alias gemstall='gem install --no-ri --no-rdoc'
alias install='sudo apt-get install'
alias update='sudo apt-get update'
alias upgrade='sudo aptitude safe-upgrade'

alias findfile='find . -name '
alias findgrep='find . -name "*.php" | xargs grep'
alias lt='ls -lrth'
alias ack='ack -ai'
alias ag='ag -i'
alias vi='vim'

alias commitWarn='egrep -i "^\+\+\+|print|XXX|TODO|debug|wtf|dumpObject|console\.log|console\.time|console\.timeEnd|console\.debug|console\.dir" | egrep -v "^-"'

alias zrc='vi ~/.zshrc && source ~/.zshrc'

alias gnl='g nl -5'
alias gco='g co'
alias gba='git br && git br -a | grep --color=none "remotes/public"'
alias st='gst .'
alias gdiff='g diff'

alias resource='source ~/.zshrc'
alias zrc='vi $ZSH/custom/joel.zsh && resource'

#history
setopt APPEND_HISTORY
setopt hist_ignore_all_dups
export HISTFILE=~/.zhistory
export SAVEHIST=1000
export PAGER=more

tmatt() {
    SESSION_NAME="${1}-${2}"
    if tmux has -t $SESSION_NAME; then
        if [ -z "$TMUX" ]; then
            tmux attach-session -d -t $SESSION_NAME
        else
            tmux switch-client -t $SESSION_NAME
        fi
    else
        tmux new-session -s $SESSION_NAME "teamocil ${2}"
    fi
}

[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator
