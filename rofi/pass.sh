#!/bin/bash

# a simple script that uses Rofi in dmenu mode to select passwords from the
#  password store. use pinentry-rofi.bash as pinentry to also use rofi to ask
#  for the GPG key's passphrase

list_passwords() {
    cd ~/.password-store
    find . -name '*.gpg' | sed -r 's/\.\/(.*)\.gpg$/\1/g'
}

check_dep() {
    if [[ ! -x "$(which $1 2>/dev/null)" ]]; then
        rofi -e "ERROR: $1 not found in PATH"
        exit 1
    fi
}

check_dep pass
check_dep xdotool

entry=$(list_passwords | rofi -dmenu -p "pass")
[[ -z "$entry" ]] && exit

# entries in the otp subdirectory are handled using the OTP extension.
#  Note: this sorta defeats the purpose of two-factor-OTPs. in my case it
#  if fine (probably) since all my passwords are encrypted using a key on a
#  hardware token. might call this "one-and-a-half-factor".
if [[ "${entry}" =~ ^otp/.* ]]; then
    password=$(pass otp ${entry} | head -n 1) || exit 1
else
    password=$(pass "${entry}" | head -n 1) || exit 1
fi

xdotool type "${password}"

unset password
