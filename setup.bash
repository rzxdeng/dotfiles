files=".vimrc .bashrc .tmux.conf"
for f in $files ; do
    fullpath="$HOME/$f"
    rm -f $fullpath
    nodot=$(echo $f | sed 's/^\.//')
    ln -s "$PWD/$nodot" $fullpath
done

