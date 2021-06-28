
# my pretty, pure-bash 'powerline' prompt x3

[[ $SHELL != "/bin/bash" ]] && echo "Must be bash" && exit 1

# powerline-like sectioning. first argument is ANSI color to use.
#  call without arguments to end powerline and return to normal formatting
__sect() {
    local sep=""
    # derive unique name for section file from tty device (replace / by -) 
    local tty=$(tty)
    local sectfile="/tmp/zalsect${tty//\//-}"
    if [[ ! -e $sectfile ]]; then
        [[ -z "$1" ]] && echo "Can't open without argument" >&2 && return 1
        printf '\\[\\033[1;3%s;49;7m\\]' "$1"
    else
        local sect_last=$(<$sectfile)
        if [[ -z "$1" ]]; then
            printf '\\[\\033[27;3%s;49m\\]' "$sect_last"
            printf '%s' "$sep"
            printf '\\[\\033[0m\\]'
        else
            printf '\\[\\033[27;3%s;4%sm\\]' "$sect_last" "$1"
            printf '%s' "$sep"
            printf '\\[\\033[3%s;49;7m\\]' "$1"
        fi
    fi
    if [[ -n "$1" ]]; then
        echo -n $1 > $sectfile
    else
        rm -f $sectfile
    fi
}

__prompt_git_info() {
    local branch=$(git branch --show-current 2>/dev/null)
    if [[ -n "${branch}" ]]; then
        printf "$(__sect 5)"
        printf ' \ue0a0'
        printf "$branch"
    fi
}

__prompt_exitcode() {
    [[ $1 != 0 ]] && printf "$(__sect 3)$1"
}

__prompt_update() {
    local code=$?
    PS1="$(__sect 2)\\u@\\h$(__prompt_git_info)$(__sect 4) \\w \\\$$(__prompt_exitcode $code)$(__sect) "
}

