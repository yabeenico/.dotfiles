#!/bin/bash

set -xeuo pipefail

# apt-fast
sudo add-apt-repository -y ppa:apt-fast/stable
sudo apt-get update
sudo apt-get install -y apt-fast

# vim
sudo add-apt-repository -y ppa:jonathonf/vim
sudo apt-fast install -y vim
sudo apt-fast -y --only-upgrade install vim

