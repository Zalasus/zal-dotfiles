
has() {
    [[ -x "$(which $1 2> /dev/null)" ]]
}

alias lsl="ls -lh"
alias free="free -h"
alias df="df -h"
alias cp="cp --reflink=auto"

alias trim="sed 's/^[ \t]*//'"

alias windoof="~/src/scripts/boot-windows.sh"

if has git; then
    alias gits="git status"
fi

if has loginctl; then
    alias lpoweroff="loginctl poweroff"
    alias lsuspend="loginctl suspend"
    alias lreboot="loginctl reboot"
    alias llock="loginctl lock-session"
fi

if has maim && has xclip; then
    alias ss2cb="maim -s | xclip -t image/png -selection clipboard"
fi

if has nvim; then
    alias vim="nvim"
    alias vi="nvim"
fi

unset -f has
