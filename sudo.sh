#!/bin/bash

set -xeuo pipefail

sudo cp .vimrc_root /root/.vimrc

# apt-fast
if ! which apt-fast &>/dev/null; then
    sudo add-apt-repository -y ppa:apt-fast/stable &&
    sudo apt-get install -y apt-fast
fi

# vim
if ! grep -R jonathonf/vim /etc/apt/sources.list.d >/dev/null; then
    sudo add-apt-repository -y ppa:jonathonf/vim &&
    sudo apt-fast -y --only-upgrade install vim-nox
fi

