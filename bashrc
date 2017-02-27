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

# Initialize the 'hop' script                                                                                                                                                                                                             
source /usr/hop/hop.bash                                                       
# Define an entry point for the lua script version of hop                       
alias hop-lua-script="LUA_PATH=/usr/hop/json.lua /usr/hop/hop.lua"
