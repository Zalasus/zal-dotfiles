#!/bin/bash

# a simple script that uses tofi in dmenu mode to select passwords from the
#  password store. use pinentry-tofi.bash as pinentry to also use tofi to ask
#  for the GPG key's passphrase
#
# this is a 1:1 adaptation of the rofi version to the wayland-compatible tofi menu

TOFI=~/bin/tofi

list_passwords() {
    cd ~/.password-store
    find . -name '*.gpg' | sed -r 's/\.\/(.*)\.gpg$/\1/g'
}

entry=$(list_passwords | ${TOFI} --prompt-text "pass: ")
[[ -z "$entry" ]] && exit

# WHY WOULD YOU USE XDG_RUNTIME_DIR FOR A SOCKET THAT IS CREATED BY A ROOT-OWNED DAEMON?
export YDOTOOL_SOCKET="/tmp/.ydotool_socket"

ydt_args="--key-delay 5 --file -"

if [[ "${entry}" =~ ^otp/.* ]]; then
    pass otp ${entry} | head -n 1 | tr -d '\n' | ydotool type ${ydt_args}
else
    pass "${entry}" | head -n 1 | tr -d '\n' | ydotool type ${ydt_args}
fi
