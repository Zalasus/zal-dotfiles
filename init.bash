
# init script for setting up my dotfiles.
#
#  source this from your bashrc or what you have

# use this variable to refer to dotfiles
export ZAL_DOTFILES=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# use gpg-agent for SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent
gpg-connect-agent updatestartuptty /bye > /dev/null

# the following stuff is only relevant for interactive shells
if [[ $- == *i* ]] ; then
    . ${ZAL_DOTFILES}/bash/aliases.bash
    . ${ZAL_DOTFILES}/bash/completions.bash

    HISTCONTROL=ignoredups:erasedups
    shopt -s histappend

    # use my custom prompt if using a graphical terminal
    if [[ $TERM == "alacritty" ]]; then
        . ${ZAL_DOTFILES}/bash/prompt.bash
        PROMPT_COMMAND="update_prompt"
    fi

    # since i can't fix the dead key issues with xdotool, the'll just have to vanish from my passwords
    export PASSWORD_STORE_CHARACTER_SET="[:alnum:]+*/?!$%&(){}=_#~';:.,<>|@"
fi

# you know what? fuck it, i wanna use cargo install. i'm lazy.
export PATH="${PATH}:${HOME}/.cargo/bin"
