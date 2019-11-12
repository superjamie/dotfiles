## Terminal

# Ubuntu Tab complete directory slash
bind 'set mark-symlinked-directories on'

if [ $TERM == "xterm" ]; then export TERM="xterm-256color"; fi

# http://askubuntu.com/questions/131099/set-terminal-title-to-taskbar
case "$TERM" in
xterm*|rxvt*)
    PROMPT_COMMAND='echo -ne "\033]0;${PWD/#$HOME/\~}\007"'
    ;;  
*)
    ;;  
esac

# flow ctrl off (ctrl+s and ctrl+q)
stty -ixon

## Variables

export EDITOR=vim

# https://jonathansblog.co.uk/colour-man-pages
# https://linuxtidbits.wordpress.com/2009/03/23/less-colors-for-man-pages/
export LESS_TERMCAP_mb=$'\E[01;31m' # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m' # begin bold
export LESS_TERMCAP_me=$'\E[0m' # end mode
export LESS_TERMCAP_se=$'\E[0m' # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m' # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m' # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

## Aliases

alias ccat='pygmentize -g'
alias dns-servers='sudo systemd-resolve --status'
alias dns-flush='sudo systemd-resolve --flush-caches'
alias ll='ls -AlF'
alias ips='watch -n 0.5 ip addr'
alias muteunmute='pactl set-sink-mute 0 toggle'
alias newtags='rm -f GPATH GRTAGS GSYMS GTAGS; gtags'
alias pkg='sudo apt'
alias vms='sudo virsh list --all'
alias webserve='python3 -m http.server' # formerly 'python -m SimpleHTTPServer'
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

# Nice oneline (no square bracket)
#PS1="\[\e[0;32m\]\u@\h \[\e[0;34m\]\W\[\e[0m\] \$ "

# Nice twoline
PS1="[\[\e[0;32m\]\u@\h \[\e[0;34m\]\W\[\e[0m\]]\\n \$ "

# vim: ft=sh
