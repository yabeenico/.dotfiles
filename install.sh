#!/bin/bash

ln -sf ~/.dotfiles/.bashrc         ~/
ln -sf ~/.dotfiles/.colorrc        ~/
ln -sf ~/.dotfiles/.gitconfig      ~/
ln -sf ~/.dotfiles/.inputrc        ~/
ln -sf ~/.dotfiles/.screenrc       ~/
ln -sf ~/.dotfiles/.tmux.conf      ~/
ln -sf ~/.dotfiles/.vim            ~/
ln -sf ~/.dotfiles/.vimrc          ~/

touch ~/.hushlogin

#sudo mkdir -p /root/.vim/anydir
#sudo cp ~/.dotfiles/.vimrc_root /root/.vimrc

mkdir -p ~/.vim/anydir
vim
