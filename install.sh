mkdir -p ~/.vim/backupdir
mkdir -p ~/.vim/directory
mkdir -p ~/.vim/undodir

ln -sf ~/.dotfiles/.bashrc ~/.bashrc
ln -sf ~/.dotfiles/.vimrc ~/.vimrc
ln -sf ~/.dotfiles/dein.toml ~/.vim/dein/rc/dein.toml
ln -sf ~/.dotfiles/dein_lazy.toml ~/.vim/dein/rc/dein_lazy.toml
