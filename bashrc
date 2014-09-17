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
# tmux
alias jmux="tmux -S /tmp/john.tmux"
alias jmux2="tmux -S /tmp/john2.tmux"
# stand-alone tokumx
alias m="./mongo --nodb"
alias jm="./mongo --port 29000"
alias jmd="mkdir -p data && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath data --port 29000"
alias jms="./mongostat --port 29000"
# replicated tokumx
alias jm-repl1="./mongo --port 28000"
alias jm-repl2="./mongo --port 28001"
alias jmd-repl1="mkdir -p repldata1 && gdb -ex r --args ./mongod --nohttpinterface --replSet johnrs --expireOplogDays 0 --expireOplogHours 1 --gdb --dbpath repldata1 --port 28000"
alias jmd-repl2="mkdir -p repldata2 && gdb -ex r --args ./mongod --nohttpinterface --replSet johnrs --expireOplogDays 0 --expireOplogHours 1 --gdb --dbpath repldata2 --port 28001"
# sharded tokumx
alias jm-sh="./mongo --port 15001"
alias jm-shard1="./mongo --port 15002"
alias jm-shard2="./mongo --port 15003"
alias jmd-config="mkdir -p configsvrdata && gdb -ex r --args ./mongod --configsvr --nohttpinterface --gdb --dbpath configsvrdata --port 15000"
alias jmongos="gdb -ex r --args ./mongos --configdb localhost:15000 --port 15001"
alias jmd-shard1="mkdir -p sharddata1 && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath sharddata1 --port 15002"
alias jmd-shard2="mkdir -p sharddata2 && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath sharddata2 --port 15003"
alias jmd-shard3="mkdir -p sharddata3 && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath sharddata3 --port 15004"
alias jmd-shard4="mkdir -p sharddata4 && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath sharddata4 --port 15005"
alias jmd-shard5="mkdir -p sharddata5 && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath sharddata5 --port 15006"
alias jmd-shard6="mkdir -p sharddata6 && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath sharddata6 --port 15007"
alias jmd-shard7="mkdir -p sharddata7 && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath sharddata7 --port 15008"
alias jmd-shard8="mkdir -p sharddata8 && gdb -ex r --args ./mongod --nohttpinterface --gdb --dbpath sharddata8 --port 15009"
alias jms-sharded="./mongostat --discover --port 15001"
# vanilla mongo
alias jm-vanilla="./mongo --port 29001"
alias jmd-vanilla="mkdir -p data && gdb -ex r --args ./mongod --nohttpinterface --dbpath data --port 29001"
# mysql
alias jsql="mysql --sigint-ignore -u root --socket=/tmp/john.mysql"
alias jsqld="gdb -ex r --args bin/mysqld --gdb --socket=/tmp/john.mysql --port=53421"

# convenience
alias io="iostat -xk 1"

# interactive for safety
alias rm="rm -i"
alias mv="mv -i"
alias ln="ln -i"
alias cp="cp -i"

# tokutek new york + lexington
tokunyc="68.173.79.125"
alias nyc="ssh -C -p 22102 esmet@$tokunyc"
alias celery="ssh -C -p 22101 esmet@$tokunyc"
tokulex="tokulex.tokutek.com"
alias lex1="ssh -p 22114 esmet@$tokulex"
alias lex2="ssh -p 22115 esmet@$tokulex"
alias lex3="ssh -p 22120 esmet@$tokulex"
alias lex4="ssh -p 22121 esmet@$tokulex"
alias pointy="ssh -p 22148 esmet@$tokulex"
alias mac="ssh -p 22118 admin@$tokulex"
alias mork="ssh -p 22150 esmet@$tokulex"
alias mindy="ssh -p 22151 esmet@$tokulex"
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
if [ $(hostname) != "celery" ]; then
    # ccache breaks gcc-4.9 LTO for some reason
    pathmunge "/usr/lib/ccache"
fi
pathmunge "/opt/chef/embedded/bin"

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
    p1="$HOME/git/tokutek/ft-index/build/buildheader/db.h"
    p2="$HOME/git/tokutek/ft-index/dbg/buildheader/db.h"
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

function parse_git_branch {
    git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
}

function gbin { 
    echo branch \($1\) has these commits and \($(parse_git_branch)\) does not 
    git log ..$1 --no-merges --format='%h | Author:%an | Date:%ad | %s' --date=local
}
function vimconflicts { 
    vim $(git status | grep 'both modified:' | awk '{print $3}')
}
