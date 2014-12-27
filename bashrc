# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# ... or force ignoredups and ignorespace
HISTCONTROL=ignoredups:ignorespace

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
#if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
#    . /etc/bash_completion
#fi

# setup a colored prompt, if the terminal has the capability
if [ -x /usr/bin/tput ] && tput setaf 1 &>/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
    NORMAL="$(tput sgr0)"
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 4)"
    MAGENTA="$(tput setaf 5)"
    CYAN="$(tput setaf 6)"
    WHITE="$(tput setaf 7)"
fi

PS1="${RED}\u@\h${NORMAL} ${CYAN}\w${NORMAL} \n$ "
unset NORMAL RED GREEN YELLOW BLUE MAGENTA CYAN WHITE    

# things to do before prompt
function prompt_command
{
    # write history
    history -a

    case "$TERM" in
    xterm*|rxvt*)
        # set window title
        echo -ne "\e]0;${HOSTNAME%%.*}\a"
        ;;
    screen*)
        # escape sequence for "shelltitle" command
        echo -ne "\ek\e\\"
        ;;
    esac
    
    echo
}
PROMPT_COMMAND=prompt_command

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias l='ls'
alias ll='ls -AFlh'
alias la='ls -AF'

[ -d "$HOME/bin" ] && PATH="$HOME/bin:$PATH"
[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"

if hash trash &>/dev/null; then
    alias rm='echo "You should use trash. If you really want, use \rm."; false'
fi

# screen helper
function scr
{
    if [ -z "$1" ]; then
        screen -list | head -n -2
    else
        screen -dRR $1
    fi
}
if hash screen &>/dev/null && [ -z $LOGON_SCREEN_LIST ]; then
    export LOGON_SCREEN_LIST="off"
    scr
fi

# beets (music library organizer) completion
[ -f ~/.beetcomp.sh ] && source ~/.beetcomp.sh
