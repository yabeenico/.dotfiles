#!/bin/bash

set -xeuo pipefail

sudo mkdir -p /root/.vim/anydir
sudo cp .vimrc_root /root/.vimrc

# apt-fast
if ! which apt-fast &>/dev/null; then
    sudo -E add-apt-repository -y ppa:apt-fast/stable &&
    echo '
        debconf apt-fast/maxdownloads string 20
        debconf apt-fast/dlflag boolean true
        debconf apt-fast/aptmanager string apt-get
    ' | sudo debconf-set-selections
    sudo apt-get install -y apt-fast
fi

# vim
if ! grep -R jonathonf/vim /etc/apt/sources.list.d >/dev/null; then
    sudo -E add-apt-repository -y ppa:jonathonf/vim &&
    sudo apt-fast -y --only-upgrade install vim-nox
fi

if ! which icdiff &>/dev/null; then
    sudo apt-fast install -y icdiff
fi
