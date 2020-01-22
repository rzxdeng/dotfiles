if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi
# User specific environment and startup programs

PATH=$PATH:$HOME/bin
PATH=$PATH:/Users/rdeng/apache-maven-3.6.3/bin
export PATH

COLOR_RED="\001\033[0;31m\002"
COLOR_YELLOW="\001\033[0;33m\002"
COLOR_GREEN="\001\033[0;32m\002"
COLOR_OCHRE="\001\033[38;5;95m\002"
COLOR_BLUE="\001\033[0;34m\002"
COLOR_WHITE="\001\033[0;37m\002"
COLOR_RESET="\001\033[0m\002"

function git_prompt() {
    local OUT=""
    git rev-parse --is-inside-work-tree >> /dev/null 2>&1
    if [ $? -eq 0 ]; then
        OUT="$OUT"

        local git_status="$(git status 2> /dev/null)"
        local on_branch="On branch ([^${IFS}]*)"
        local on_commit="HEAD detached at ([^${IFS}]*)"

        if [[ ! $git_status =~ "working directory clean" ]]; then
            OUT="$OUT$COLOR_RED"
        elif [[ $git_status =~ "Your branch is ahead of" ]]; then
            OUT="$OUT$COLOR_YELLOW"
        elif [[ $git_status =~ "nothing to commit" ]]; then
            OUT="$OUT$COLOR_GREEN"
        else
            OUT="$OUT$COLOR_OCHRE"
        fi

        if [[ $git_status =~ $on_branch ]]; then
            local branch=${BASH_REMATCH[1]}
            OUT="$OUT$branch"
        elif [[ $git_status =~ $on_commit ]]; then
            local commit=${BASH_REMATCH[1]}
            OUT="$OUT$commit"
        fi

        OUT="$OUT$COLOR_BLUE "

    fi

    echo -ne "$OUT"
}

export PS1='\[\033[0;34m\][\h] \w $(git_prompt)$ \[\033[m\]'

# use go on the first instance in its list
function go_first() {
    HOST=$(go $@ | head -n1)
    ssh $HOST
}

# Finding things
function findin () {
    find . -exec grep -q "$1" '{}' \; -print
}

# Extracting files
extract () {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xvjf $1    ;;
            *.tar.gz)    tar xvzf $1    ;;
            *.tgz)       tar xvzf $1    ;;
            *.bz2)       bunzip2 $1     ;;
	    *.rar)       unrar x $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xvf $1     ;;
	    *.tbz2)      tar xvjf $1    ;;
            *.tgz)       tar xvzf $1    ;;
	    *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
	    *.7z)        7z x $1        ;;
	    *)           echo "'$1' cannot be extracted via >extract<" ;;
	esac
    else
	echo "'$1' is not a valid file"
    fi
}

# Make things lowercase
lowercase(){
    echo "$1" | sed "y/ABCDEFGHIJKLMNOPQRSTUVWXYZ/abcdefghijklmnopqrstuvwxyz/"
}


# Detect OS
OS=`lowercase \`uname\``
if [ "$OS" = "darwin" ]; then
    OS="linx"
else
    OS="mac"
fi

#### Aliases ####

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
# alias ls='ls --color=auto'
alias ll='ls -hal'
alias rm='rm -i'
alias vi="vim"
alias gof='go_first'
alias htmldiff='pygmentize -l diff -O full=true -f html'
alias tmux='tmux -2'                    # force tmux to support 256 colors
alias trimw="grep -rli '[[:blank:]]$'"  # show all files with trailing whitespace in a dir
alias ho="hop"
#### Exports ####

# Exposing editor for things
export EDITOR='vim'

# Large command history file
HISTFILESIZE=1000000
HISTSIZE=10000

# Setting for the new UTF-8 terminal support in Lion
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export GIT_EMPTY_TREE=$(git hash-object -t tree /dev/null)
