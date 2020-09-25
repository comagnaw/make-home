#!/usr/bin/env bash

printf "# Installing homebrew formulas...\n"
while read formula; do    
    /usr/local/bin/brew install ${formula}
done < formulas.txt
printf "# Done installing homebrew formulas\n"