#!/usr/bin/env bash

printf "# Setting up gpg/gnupg..."
mkdir ~/.gnupg
echo "pinentry-program /usr/local/bin/pinentry-mac" >> ~/.gnupg/gpg-agent.conf
printf "Done\n"