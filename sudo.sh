#!/bin/bash

set -xeuo pipefail

sudo mkdir -p /root/.vim/anydir
sudo cp .vimrc_root /root/.vimrc


sudo tee /etc/apt/mirrors.txt >/dev/null <<EOF
https://ftp.udx.icscoe.jp/Linux/ubuntu/ priority:2
https://linux.yz.yamagata-u.ac.jp/ubuntu/   priority:3
http://archive.ubuntu.com/ubuntu/
EOF

sudo sed -i.bak \
    's@http://archive.ubuntu.com/ubuntu/@mirror+file:/etc/apt/mirrors.txt@' \
    /etc/apt/sources.list

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

