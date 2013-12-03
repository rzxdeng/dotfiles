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
if [ $(hostname) == 'celery' ] ; then
    cmake="cmake -D USE_BDB=OFF -D CMAKE_INSTALL_PREFIX=../release"
elif [ $unamestr == 'linux' ] ; then
    cmake="CC=\"gcc47\" CXX=\"g++47\" cmake -D USE_BDB=OFF -D CMAKE_INSTALL_PREFIX=../release"
else
    cmake="CC=\"cc\" CXX=\"c++\" cmake -D USE_BDB=OFF -D CMAKE_INSTALL_PREFIX=../release"
fi
alias cmakedbg="$cmake -D CMAKE_BUILD_TYPE=Debug .."
alias cmakecov="$cmake -D CMAKE_BUILD_TYPE=Debug -D USE_GCOV=ON .."
alias cmakeopt="$cmake -D TOKU_DEBUG_PARANOID=OFF -D USE_VALGRIND=OFF -D CMAKE_BUILD_TYPE=Release .."

# distcc
if [ $(hostname) == "celery" ] ; then
    export DISTCC_HOSTS="localhost/4 192.168.1.102/4"
fi

# use vimdiff for git diffs so they don't suck
alias gitdiff='git difftool --tool=vimdiff'

# convenience aliases
alias vi="vim"
alias emacs="emacs -nw"
alias jmux="tmux -S /tmp/john.tmux"
alias jmux2="tmux -S /tmp/john2.tmux"
alias m="./mongo --nodb"
alias jm="./mongo --port 29000"
alias jms="./mongostat --port 29000"
alias jm-repl1="./mongo --port 28000"
alias jm-repl2="./mongo --port 28001"
alias jm-vanilla="./mongo --port 29001"
alias jmd="mkdir -p data && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath data --port 29000"
alias jmd-repl1="mkdir -p repldata1 && gdb -ex r --args ./mongod --nohttpinterface --replSet johnrs --expireOplogDays 0 --expireOplogHours 1 --gdb --dbpath repldata1 --port 28000"
alias jmd-repl2="mkdir -p repldata2 && gdb -ex r --args ./mongod --nohttpinterface --replSet johnrs --expireOplogDays 0 --expireOplogHours 1 --gdb --dbpath repldata2 --port 28001"
alias jmd-vanilla="mkdir -p data && gdb -ex r --args ./mongod --nohttpinterface --dbpath data --port 29001"
alias jsql="mysql --sigint-ignore -u root --socket=/tmp/john.mysql"
alias jsqld="gdb -ex r --args bin/mysqld --gdb --socket=/tmp/john.mysql --port=53421"
alias io="iostat -xk 1"

# interactive for safety
alias rm="rm -i"
alias mv="mv -i"
alias ln="ln -i"
alias cp="cp -i"

# tokutek new york + lexington
tokunyc="tokunyc.tokutek.com"
alias nyc="ssh -C -p 22102 esmet@$tokunyc"
alias celery="ssh -C -p 22101 esmet@$tokunyc"
tokulex="tokulex.tokutek.com"
alias lex1="ssh -p 22114 esmet@$tokulex"
alias lex2="ssh -p 22115 esmet@$tokulex"
alias pointy="ssh -p 22148 esmet@$tokulex"
alias mork="ssh -p 22150 esmet@$tokulex"
alias mindy="ssh -p 22151 esmet@$tokulex"
alias buk="ssh -p 2202 esmet@buk.fizzfaldt.org"
alias munchkin="ssh -p 22150 esmet@munchkin.leifwalsh.com"

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
pathmunge "/usr/local/gdb-7.5.1/bin"
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
    gdb -p $(pgrep perf_) -ex "thr 3" -ex "thr" -batch 2>/dev/null | grep "Current thread is 3" | awk '{print $8}' | awk -F ')' '{print $1}'
}

function dbh {
    p1="$HOME/git/tokutek/ft-index/dbg/buildheader/db.h"
    p2="$HOME/git/tokutek/ft-index/build/buildheader/db.h"
    if [ -e $p1 ] ; then
        vim $p1
    elif [ -e $p2 ] ; then
        vim $p2
    fi
}

function smoke {
    smoke="buildscripts/smoke.py"
    if [ -e $smoke ] ; then
        d="smokedata"
        mkdir -p $d
        if command -v python2.7 &>/dev/null ; then
            python="python2.7"
        elif command -v python2 &>/dev/null ; then
            python="python2"
        elif command -v python2.6 &>/dev/null ; then
            python="python2.6"
        else
            python="python"
        fi
        PYTHONPATH=/usr/lib64/python2.4/site-packages/ $python $smoke --continue-on-failure --smoke-db-prefix $d --quiet $@
    fi
}

function lex1tunnel {
    while true; do
        cmd='ssh -N -L 8010:localhost:8010 -L 8020:localhost:8020 -L 8080:localhost:8080 -p22114 esmet@tokulex.tokutek.com'
        echo $cmd
        $cmd
    done
}

function tags {
    ctags */*.{cpp,h} *.{cpp,h}
}
