source /etc/profile
PS1="[\u@\h \W] \$ "

# vi bindings are great everywhere except the command line
set -o emacs

# this bundle of joy is for portable LS colors.
# I like yellow dictories because bold blue is
# impossible to see on an osx terminal
unamestr=$(uname | tr '[:upper:]' '[:lower:]')
if [ $unamestr == 'linux' ] ; then
    alias ls="ls --color=auto"
    export LS_COLORS='di=33'
elif [ $unamestr == 'darwin' ] ; then
    alias ls="ls -G"
    export CLICOLOR=1
    export LSCOLORS="DxGxcxdxCxegedabagacad"
else
    alias ls="ls"
    echo "Problem setting ls colors, uname = $unamestr"
fi

alias grep="grep --color=auto"

# use vimdiff for git diffs so they don't suck
alias gitdiff='git difftool --tool=vimdiff'

alias io="iostat -xk 1"
alias vi="vim"
alias emacs="emacs -nw"
alias jmux="tmux -S /tmp/john.tmux"
export EDITOR=vim

# interactive for safety
alias rm="rm -i"
alias mv="mv -i"
alias ln="ln -i"
alias cp="cp -i"

# i'm used to this now
unalias reset &>/dev/null
alias realreset="$(which reset)"
alias reset="source $HOME/.bashrc && clear"

# force gcc44 when using cmake
alias cmake="CC=gcc44 CXX=g++44 cmake"

# stolen from /etc/profile
function pathmunge {
    if ! echo $PATH | egrep -q "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

export PATH="/bin:/usr/bin"
pathmunge "/sbin"
pathmunge "/usr/sbin"
pathmunge "/usr/local/bin" 
pathmunge "/usr/local/sbin" 
pathmunge "$HOME/local/bin" 

export LD_LIBRARY_PATH="$HOME/local/lib:/usr/local/lib:$LD_LIRARY_PATH"
export C_INCLUDE_PATH="$HOME/local/include:/usr/local/include:$C_INCLUDE_PATH"

shopt -s histappend
export HISTIGNORE="ls:cd ~:cd ..:exit:h:history"
export HISTCONTROL="erasedups"
export PROMPT_COMMAND="history -a" # so history flushes after each command

function h {
    pattern=$1
    history | grep $pattern
}
