files=".vimrc .bashrc .tmux.conf"
for f in $files ; do
    fullpath="$HOME/$f"
    rm -f $fullpath
    nodot=$(echo $f | sed 's/^\.//')
    ln -s "$PWD/$nodot" $fullpath
done

mkdir -p ~/.vim/bundle
mkdir -p ~/.vim/autoload

# first get pathogen, then each of the plugins we want
echo 'Ensuring pathogen is up to date ...'
curl -Sso ~/.vim/autoload/pathogen.vim 'https://raw.github.com/tpope/vim-pathogen/master/autoload/pathogen.vim'
pushd ~/.vim/bundle &>/dev/null
if [ ! -d ag ] ; then
    echo 'Installing ag ...'
    git clone https://github.com/rking/ag.vim ag
    echo ''
fi
if [ ! -d fugitive ] ; then
    echo 'Installing fugitive ...'
    git clone https://github.com/tpope/vim-fugitive.git fugitive
    echo ''
fi
if [ ! -d ctrlp ] ; then
    echo 'Installing ctrlp ...'
    git clone https://github.com/kien/ctrlp.vim.git ctrlp
    echo ''
fi
if [ ! -d vim-rspec ] ; then
    echo 'Installing vim-rspec ...'
    git clone https://github.com/thoughtbot/vim-rspec.git vim-rspec
    echo ''
fi
if [ ! -d ruby-matchit ] ; then
    echo 'Installing ruby-matchit ...'
    git clone https://github.com/vim-scripts/ruby-matchit.git ruby-matchit
    echo ''
fi
popd &>/dev/null
