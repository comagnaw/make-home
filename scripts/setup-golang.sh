#!/usr/bin/env bash

printf "# Installing go tools..."
/usr/local/bin/go get -u golang.org/x/tools/...
printf "Done\n"