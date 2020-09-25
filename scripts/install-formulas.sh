#!/usr/bin/env bash

printf "# Installing homebrew formulas...\n"
while read formula; do    
    /usr/local/bin/brew install ${formula}
done < scripts/formulas.txt
printf "# Done installing homebrew formulas\n"
