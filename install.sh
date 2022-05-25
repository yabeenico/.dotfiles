#!/bin/bash

cd -P $(dirname $0)

ln -sf ~/.dotfiles/.bashrc              ~/
ln -sf ~/.dotfiles/.colorrc             ~/
ln -sf ~/.dotfiles/.gitconfig           ~/
ln -sf ~/.dotfiles/.inputrc             ~/
ln -sf ~/.dotfiles/.lesskey             ~/
ln -sf ~/.dotfiles/.screenrc            ~/
ln -sf ~/.dotfiles/.tmux.conf           ~/
ln -sf ~/.dotfiles/.vim                 ~/
ln -sf ~/.dotfiles/.vimrc               ~/

touch ~/.hushlogin

vim
