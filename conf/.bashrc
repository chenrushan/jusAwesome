# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

# Some applications read the EDITOR variable to determine your favourite text
# editor. So uncomment the line below and enter the editor of your choice :-)
export EDITOR=/usr/bin/vim

export LANG=en_US.UTF-8

# For some news readers it makes sense to specify the NEWSSERVER variable here
# export NEWSSERVER=your.news.server

# turn on bash smart context-sensitive completion
if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
fi

# for urxvt encoding
alias gb-encoding='export LC_CTYPE="zh_CN.gb2312"; printf "\33]701;$LC_CTYPE\007"'
alias utf8-encoding='export LC_CTYPE="zh_CN.utf8"; printf "\33]701;$LC_CTYPE\007"'
# misc
alias grep='grep --color=auto'
alias ..='cd ..'
alias s='screen -r'
alias f='fg'
alias vi='vim'
alias sort='LC_ALL=C sort'
alias ls='ls --color=auto'
alias mp='applauncher.sh mplayer 1 /usr/share/pixmaps/mplayer.png mplayer'
alias zathura='applauncher.sh zathura 1 /usr/share/pixmaps/zathura.png none'
alias l='ls -l'
alias jekyll=/home/juscodit/.gem/ruby/2.0.0/bin/jekyll

# ========================================
# Comment for the following set-title command:
#
# ----------------------------------------
# FROM http://ubuntuforums.org/showthread.php?t=448614
# 
# PROMPT_COMMAND='echo -ne "\033]0;"myWindowTitle"\007"'
# 
# where (in octal) \033 => <ESC>
# 0 => Ps = 0 (use string as a new icon name and title)
# ; => non-digit character
# string => "myWindowTitle"
# \007 => <BEL> (non-printing character)
# 
# The escape sequence I've employed is :-
# 
# ESC ] Ps ND string NP OSC Mode
# ND can be any non-digit Character (it's discarded)
# NP can be any non-printing Character (it's discarded)
# string can be any ASCII printable string (max 511 characters)
# Ps = 0 -> use string as a new icon name and title
# Ps = 1 -> use string is a new icon name only
# Ps = 2 -> use string is a new title only
# Ps = 46 -> use string as a new log file name
# ----------------------------------------
#
# MY OPINION:
#
# I think the ND is just used to terminate the Ps id, and the NP
# is used to terminate the title string
# ----------------------------------------
#
# About using single quote on shell cmd line: (==> means "result in")
#
# 'hello world\'' ==> hello world\'
# which actually leaves an open signle-quote at the end.
# If you want to escape a single quote, you should put it outside
# single quotes like:
# \'hello\' ==> 'hello'
# In the following commands, the unescaped single quote is for
# alias command, while the escaped one is for PROMPT_COMMAND
# ========================================

alias set-title-lo=PROMPT_COMMAND=\''echo -ne "\033]0;"local"\007"'\'
alias set-title-gw=PROMPT_COMMAND=\''echo -ne "\033]0;"gateway"\007"'\'
alias set-title-de=PROMPT_COMMAND=\''echo -ne "\033]0;"dev"\007"'\'

# the following "bind" command is for bash vi-editing mode
bind -m vi-insert "\C-l":clear-screen
bind -m vi-insert "\C-e":vi-append-eol
bind -m vi-insert "\C-a":vi-insert-beg
bind -m vi-insert "\C-p":history-search-backward
bind -m vi-insert "\C-n":history-search-forward
bind -m vi-insert "\C-b":backward-char
bind -m vi-insert "\C-f":forward-char
bind -m vi-insert "\C-u":unix-line-discard
bind -m vi-insert "\C-k":kill-line
bind -m vi-insert "\C-t":menu-complete

# \e[xx;xx] is the color code
# note that a newline before promot is important especially when you
# stare at terminal for a long time
export PS1="\n\[\e[30;1m\][\[\e[37;1m\]\u\[\e[30;1m\]]-[\[\e[37;1m\]jobs:\j\[\e[30;1m\]]-[\[\e[37;1m\]\w\[\e[30;1m\]]\n[\[\[\e[37;1m\]! \!\[\e[30;1m\]]-> \[\e[0m\]"

HISTCONTROL=ignoreboth

export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'                           
export LESS_TERMCAP_so=$'\E[01;44;33m'                                 
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

set show-all-if-ambiguous on

. /usr/lib/python3.4/site-packages/Powerline-beta-py3.4.egg/powerline/bindings/bash/powerline.sh

# RunTmux tries to attach to existing deattached tmux session or start a new session
function RunTmux()
{
    if [[ -z "$TMUX" ]] ;then
        ID="`tmux ls | grep -vm1 attached | cut -d: -f1`" # get the id of a deattached session
        if [[ -z "$ID" ]] ;then # if not available create a new one
            tmux new-session
        else
            tmux attach-session -t "$ID" # if available attach to it
        fi
    fi
}

alias t=RunTmux

