# getting the directory of the current script is a bit more complicated if
#  the script is supposed to be sourced instead of run
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# use gpg-agent for SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# the following stuff is only relevant for interactive shells
if [[ $- == *i* ]] ; then
    . ${SCRIPT_DIR}/aliases.bash
    . ${SCRIPT_DIR}/completions.bash

    HISTCONTROL=ignoredups:erasedups
    shopt -s histappend

    # use my custom prompt if using a graphical terminal
    if [[ $TERM == "alacritty" ]]; then
        . ${SCRIPT_DIR}/prompt.bash
        PROMPT_COMMAND="update_prompt"
    fi

    # since i can't fix the dead key issues with xdotool, the'll just have to vanish from my passwords
    export PASSWORD_STORE_CHARACTER_SET="[:alnum:]+*/?!$%&(){}=_#~';:.,<>|@"
fi

unset SCRIPT_DIR
