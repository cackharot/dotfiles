#!/usr/bin/env bash

wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
mkdir -p ~/.local/share/fonts
unzip FiraCode.zip -d ~/.local/share/fonts
rm FiraCode.zip
cd ~/.local/share/fonts
rm *Windows*
cd ~
fc-cache -fv
fc-list | grep -i "fira"|awk -F: '{print $2}' |sort|uniq
