## Variables

# Ubuntu Tab complete directory slash
bind 'set mark-symlinked-directories on'

export EDITOR=vim
if [ $TERM == "xterm" ]; then export TERM="xterm-256color"; fi

## Aliases

alias ccat='pygmentize -g'
alias dns-servers='sudo systemd-resolve --status'
alias dns-flush='sudo systemd-resolve --flush-caches'
alias vms='sudo virsh list --all'
alias ytup='sudo -H pip3 install --upgrade youtube-dl'

## Functions

# finds a file in the pwd downards
fn() { find . -iname "*$1*" -print; }

# uses kpcli to find something in keepassx database
kpass() { kpcli --kdb=path/to/my-keepass-database.kdbx --readonly --command "find $1"; }

## Prompt

# Red for root
# PS1="\[\e[0;31m\][\u@\h \W]\\$\[\e[0m\] "

# Raspberry Pi Default
# PS1="\[\033]0;\u@\h: \w\007\]\[\e[1;32m\]\h\[\e[1;32m\]:\[\e[1;34m\]\w \[\e[0m\]\\$ "

# Nice oneline
# PS1="[\[\e[0;32m\]\u@\h \[\e[0;34m\]\W\[\e[0m\]] \$ "

# Nice twoline
PS1="[\[\e[0;32m\]\u@\h \[\e[0;34m\]\W\[\e[0m\]]\\n \$ "

# vim: ft=sh
