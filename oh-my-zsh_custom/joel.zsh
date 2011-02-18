# Prevent <ctrl-s> from freezing 
stty -ixon

setopt COMPLETE_IN_WORD
setopt RM_STAR_SILENT

export PAGER=more
export TERM=xterm-256color

###### ALIASES #####
alias gemstall='sudo gem install --no-ri --no-rdoc'
alias install='sudo apt-get install'
alias update='sudo apt-get update'
alias upgrade='sudo aptitude safe-upgrade'

alias findfile='find . -name '
alias findgrep='find . -name "*.php" | xargs grep'
alias lt='ls -lrth'
alias ack='ack -ai'

alias commitWarn='egrep -i "^\+\+\+|XXX|TODO|debug|wtf|dumpObject" | egrep -v "^-"'

alias zrc='vi ~/.zshrc && source ~/.zshrc'

alias gnl='g nl -5'
alias gco='g co'
alias gba='git br && git br -a | grep --color=none "remotes/public"'
alias st='gst .'
alias gdiff='g diff'

alias resource='source ~/.zshrc'
alias zrc='vi $ZSH/custom/joel.zsh && resource'
