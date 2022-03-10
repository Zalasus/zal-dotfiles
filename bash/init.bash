
if [[ $- != *i* ]] ; then
	# non-interactive shell
	return
fi

. ./aliases.bash
. ./completions.bash

HISTCONTROL=ignoredups:erasedups
shopt -s histappend

# use my custom prompt if using a graphical terminal
if [[ $TERM == "alacritty" ]]; then
    . ./prompt.bash
    PROMPT_COMMAND="update_prompt"
fi

# use gpg-agent for SSH
export GPG_TTY="$(tty)"
export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
gpgconf --launch gpg-agent

# since i can't fix the dead key issues with xdotool, the'll just have to vanish from my passwords
export PASSWORD_STORE_CHARACTER_SET="[:alnum:]+*/?!$%&(){}=_#~';:.,<>|@"
