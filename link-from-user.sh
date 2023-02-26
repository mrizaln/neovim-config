#!/usr/bin/env bash

user="$1"

if [[ -z "$1" ]]; then
	echo "please specify user to target":
    echo "    $0 <username>"
	exit 0
fi

# link the main config files
./attach.sh

# link other files
mkdir -p ~/.local
if [[ -e ~/.local/share/nvim ]]; then
	mv ~/.local/share/nvim ~/.local/share/nvim.bak.$(date +%F_%H-%M-%S)
fi
ln -s /home/"$1"/.local/share/nvim ~/.local/share/
