
# sources a completion if it exists, or ignores it silently if not
completion() {
    local f="/usr/share/bash-completion/completions/$1"
    [[ -e "$f" ]] && . "$f"
}

completion git
completion pass
completion pass-otp
completion emerge

unset -f completion
