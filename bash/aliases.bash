
has() {
    [[ -x "$(which $1 2> /dev/null)" ]]
}

alias lsl="ls -lh"
alias free="free -h"
alias df="df -h"
alias cp="cp --reflink=auto"

alias trim="sed 's/^[ \t]*//'"

if has git; then
    alias gits="git status"
fi

# the logind power management works with polkit. shame
if has loginctl && has pkexec; then
    alias llock="loginctl lock-session"
    alias lpoweroff="loginctl poweroff"
    alias lsuspend="loginctl suspend"
    alias lreboot="loginctl reboot"
else
    alias lpoweroff="doas /sbin/shutdown -hP now"
    alias lreboot="doas /sbin/shutdown -r now"
    alias lsuspend="doas ${ZAL_DOTFILES}/bash/suspend"
fi

if has maim && has xclip; then
    alias ss2cb="maim -s | xclip -t image/png -selection clipboard"
fi

if has nvim; then
    alias vim="nvim"
    alias vi="nvim"
fi

alias zt="${ZAL_DOTFILES}/bash/zaltime/zt"
alias windoof="${ZAL_DOTFILES}/bash/boot-windows"

alias lw=librewolf

# every damn time!
alias flatpack=flatpak

if has equery; then
    isusing() {
        for PKG in $(equery -q hasuse $1); do echo $PKG: $(equery -q uses $PKG | grep $1); done
    }
fi

unset -f has
