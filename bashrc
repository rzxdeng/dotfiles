if [ -f /etc/bashrc ]; then
       . /etc/bashrc
fi

if [[ -S "$SSH_AUTH_SOCK" && ! -h "$SSH_AUTH_SOCK" ]]; then
    ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock;
fi

export SSH_AUTH_SOCK=$HOME/.ssh/ssh_auth_sock
