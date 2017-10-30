if [ -f /etc/bashrc ]; then
       . /etc/bashrc
fi

alias htmldiff='pygmentize -l diff -O full=true -f html'

function gcr() {
    local context=20
    local opts=""
    if [ "$1" == "-c" ]; then
        opts="--cached"
        shift
    fi
    if [ -n "$1" ]; then
        context=$1
    fi
    git diff $opts -w -U$1 | htmldiff | pastie | tee >(/usr/bin/pbcopy)
}

function utime() {
    if [[ -n "$1" ]]; then
        # Translate unix timestamp into human-readable date
        date -d @$1
    else
        # Print time in unix format
        date +%s
    fi
}

igo ()
{
    go "$@" | xargs echo | sed 's/ /\\\\\|/g' | xargs -I "{}" grep "{}" /etc/hosts
}

if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
fi
export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock

function jazz() {
    if [[ -n "$1" ]]; then
        PGUSER=$1;
        PGPASSWORD=$(sim resource get --name cloud.jazzhands-db.prod.user.$PGUSER --property password) psql -d jazzhands -h jazzhands-db.appnexus.net -U $PGUSER
    else
        psql -d jazzhands -h jazzhands-db.appnexus.net -U rdeng
    fi
}

alias trim='cut -b -$(tput cols)'

. /home/rdeng/bin/z
alias ho='z'

export PATH=$PATH:/usr/lib/go-1.7/bin
export GOPATH=/home/rdeng/.go=/home/rdeng/projects/realtime-platform/internal-pkg_libbatches/go_source

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
