#!/usr/bin/env bash

printf "# Installing powerline fonts ...\n"
brew tap homebrew/cask-fonts
brew install cask font-hack-nerd-font
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts
printf "# Done installing powerline fonts \n"