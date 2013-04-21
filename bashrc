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

# cmake aliases
if [ $unamestr == 'linux' ] ; then
    cmake="CC=\"gcc47\" CXX=\"g++47\" cmake -D USE_BDB=OFF -D CMAKE_INSTALL_PREFIX=../release"
else
    cmake="CC=\"cc\" CXX=\"c++\" cmake -D USE_BDB=OFF -D CMAKE_INSTALL_PREFIX=../release"
fi
alias cmakedbg="$cmake -D CMAKE_BUILD_TYPE=Debug .."
alias cmakecov="$cmake -D CMAKE_BUILD_TYPE=Debug -D USE_GCOV=ON .."
alias cmakeopt="$cmake -D USE_VALGRIND=OFF -D CMAKE_BUILD_TYPE=Release .."

# use vimdiff for svn/git diffs so they don't suck
alias svndiff='svn diff --diff-cmd ~/local/bin/svnvimdiff'
alias gitdiff='git difftool --tool=vimdiff'

# common macros
export SVN="https://svn.tokutek.com/tokudb"

# convenience aliases
alias vi="vim"
alias emacs="emacs -nw"
alias jmux="tmux -S /tmp/john.tmux"
alias jmux2="tmux -S /tmp/john.tmux2"
alias jm="./mongo --port 29000"
alias jm-vanilla="./mongo --port 29001"
alias jmd="mkdir -p data && gdb -ex r --args ./mongod --gdb --dbpath data --port 29000"
alias jmd-vanilla="mkdir -p data && gdb -ex r --args ./mongod --gdb --dbpath data --port 29001"
alias jsql="mysql --sigint-ignore -u root --socket=/tmp/john.mysql"
alias jsqld="gdb ex r --args $HOME/mysql/bin/mysqld --gdb --socket=/tmp/john.mysql --port=53421"
alias io="iostat -xk 1"
alias gdb="gdb"

# interactive for safety
alias rm="rm -i"
alias mv="mv -i"
alias ln="ln -i"
alias cp="cp -i"

# tokutek new york + lexington
tokunyc="108.27.202.11"
alias nyc="ssh -C -p 22123 esmet@$tokunyc"
tokulex="tokulex.tokutek.com"
alias coyote="ssh -p 22111 esmet@$tokulex"
alias roadrunner="ssh -p 22112 esmet@$tokulex"
alias lex1="ssh -p 22114 esmet@$tokulex"
alias lex2="ssh -p 22115 esmet@$tokulex"
alias pointy="ssh -p 22148 esmet@$tokulex"
alias mork="ssh -p 22150 esmet@$tokulex"
alias mindy="ssh -p 22151 esmet@$tokulex"
alias phoenix="ssh -p 22153 esmet@$tokulex"
alias buk="ssh -p 2202 esmet@buk.fizzfaldt.org"
alias munchkin="ssh -p 22150 esmet@munchkin.leifwalsh.com"
alias mac="ssh esmet@192.168.0.113"

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
pathmunge "/usr/local/gcc-4.7/bin" 
pathmunge "/usr/local/gdb-7.5/bin"
pathmunge "/usr/local/binutils-2.22/bin"

export LD_LIBRARY_PATH="$HOME/local/lib:/usr/local/lib:$LD_LIRARY_PATH"
export C_INCLUDE_PATH="$HOME/local/include:/usr/local/include:$C_INCLUDE_PATH"
export HISTIGNORE="ls"

function h {
    pattern=$1
    history | grep $pattern
}

function g {
    d=$(basename $(pwd))
    if [[ $d =~ "mariadb" ]]; then
        grep -n "$@" storage/*/*.{cc,c,h} */*.{cc,c,h}
    elif [[ $d =~ "mysql" ]]; then
        grep -n "$@" */*.{cc,c,h}
    elif [[ $d =~ "tokudb" && ! -e ha_tokudb.cc ]]; then # don't do this for the handlerton
        grep -n "$@" ft/*.{cc,h} src/*.{cc,h} locktree/*.{cc,h} portability/*.{cc,h} toku_include/*.h
    elif [[ $d == "db" ]]; then
        grep -n "$@" *.{cpp,h} */*.{cpp,h}
    else # brute search everything in the first two levels, ignore the "no such file or dir errors"
        grep -n "$@" *.{cpp,cc,c,h} */*.{cpp,cc,c,h} 2>/dev/null
    fi
}

function maketags {
    for d in dbg build opt ; do
        if make -C "$d" build_cscope.out -j4 ; then
            return
        fi
    done
    echo "couldn't make tags. does build/opt/dbg exist? proplerly cmake'd?"
}

function perf_client_thread {
    gdb -p $(pgrep perf_) -ex "thr 3" -ex "thr" -batch | grep "Current thread is 3" | awk '{print $8}' | awk -F ')' '{print $1}'
}

function dbh {
    p="$HOME/svn/toku/tokudb/build/buildheader/db.h"
    test -e "$p" && vim $p
}

function smoke {
    smoke="buildscripts/smoke.py"
    if [ -e $smoke ] ; then
        d="smokedata"
        mkdir -p $d
        PYTHONPATH=/usr/lib64/python2.4/site-packages/ python2.6 $smoke --continue-on-failure --smoke-db-prefix $d --quiet $@
    fi
}
