#!/bin/bash

# a simple script that uses Rofi in dmenu mode to select passwords from the
#  password store. use pinentry-rofi.bash as pinentry to also use rofi to ask
#  for the GPG key's passphrase

list_passwords() {
    cd ~/.password-store
    find . -name '*.gpg' | sed -r 's/\.\/(.*)\.gpg$/\1/g'
}

entry=$(list_passwords | rofi -dmenu -p "pass")
[[ -z "$entry" ]] && exit

password=$(pass "${entry}" | head -n 1) || exit 1

xdotool type "${password}"

unset password

# to prevent my yubikey from caching the PIN. really sucks that this is necessary
gpgconf --reload scdaemon
