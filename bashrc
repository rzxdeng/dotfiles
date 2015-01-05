source /etc/profile
PS1="[\u@\h \W] \$ "

# vi bindings are great everywhere except the command line
set -o emacs

# disable screen saving on blue
[ $(hostname) == "blue" ] && xset s off &>/dev/null

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

# cmake aliases
cmake="cmake -D CMAKE_INSTALL_PREFIX=../release"
alias cmakedbg="$cmake -D CMAKE_BUILD_TYPE=Debug .."
alias cmakecov="$cmake -D CMAKE_BUILD_TYPE=Debug -D USE_GCOV=ON .."
alias cmakeopt="$cmake -D TOKU_DEBUG_PARANOID=OFF -D USE_VALGRIND=OFF -D CMAKE_BUILD_TYPE=Release .."

# distcc
if [ $(hostname) == 'celery' ] ; then
    export DISTCC_HOSTS="localhost/4 192.168.1.102/4 192.168.1.110/4"
    export CCACHE_PREFIX="distcc"
fi

# use vimdiff for git diffs so they don't suck
alias gitdiff='git difftool --tool=vimdiff'

alias vi="vim"
alias emacs="emacs -nw"
alias jmux="tmux -S /tmp/john.tmux"

# convenience
alias io="iostat -xk 1"

# interactive for safety
alias rm="rm -i"
alias mv="mv -i"
alias ln="ln -i"
alias cp="cp -i"

# i'm used to this now
unalias reset &>/dev/null
alias realreset="$(which reset)"
alias reset="source $HOME/.bashrc && clear"

PREFERRED_EDITORS="vim vi nano pico"
for editor in $PREFERRED_EDITORS ; do
    if command -v "$editor" &> /dev/null ; then
        export EDITOR="$editor"
        break
    fi
done

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

function tags {
    ctags */*.{cpp,h} *.{cpp,h}
}

function vimconflicts { 
    vim $(git status | grep 'both modified:' | awk '{print $3}')
}
