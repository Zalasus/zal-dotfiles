#!/bin/bash

# pinentry-tofi.bash
#  This is a pure bash implementation of a GnuPG pinentry program that uses
#  tofi as a graphical frontend. I do not vouch for security or anything.

tofi=~/bin/tofi

# debug logging facility for debugging the interaction with the agent.
#  be aware that this will log your passphrase in plain text!
DEBUG=0
debug() {
    if [[ "${DEBUG}" ]]; then
        echo "[$(date --rfc-3339=seconds)] $@" >> ~/pinentry-tofi.log
    fi
}

debug "=== pinentry-tofi starting up ==="
debug "  cmdline: $@"
debug "  tofi: ${tofi}"
debug "  WAYLAND_DISPLAY: ${WAYLAND_DISPLAY}"

# parse arguments
while :; do
    case ${1} in
        --display)
            if [[ -n "${2}" ]]; then
                DISPLAY=${2}
                shift
            else
                DISPLAY=
            fi;;
        --display=?*)
            DISPLAY=${1#*=}
            ;;
        --display=)
            DISPLAY=
            ;;
        *)
            break
    esac
    shift
done

# if we have no display at this point, fall back to curses
if [[ -z "${WAYLAND_DISPLAY}" ]]; then
    debug "WAYLAND_DISPLAY not set. falling back to pinentry-curses"
    exec pinentry-curses "$@"
fi

if [[ -z "${XDG_RUNTIME_DIR}" ]]; then
    debug "XDG_RUNTIME_DIR not set. Making something up"
    export XDG_RUNTIME_DIR=$(mktemp -d)
fi

makemessage() {
    [[ "${description}" ]] && echo "${description}"
    [[ "${errormsg}" ]] && echo "ERROR: ${errormsg}"
}

getprompt() {
    if [[ -z "${prompt}" ]]; then
        echo ${options[default-prompt]}
    else
        echo ${prompt}
    fi
}

getpin() {
    debug "Prompting for pin"
    export WAYLAND_DISPLAY
    ${tofi} --prompt-text "$(getprompt) " --placeholder-text "$(makemessage)" --text-cursor true --hide-input true --require-match false < /dev/null 2> /tmp/tofi-err
}

confirm() {
    debug "Asking for confirmation"
    echo -e "yes\nno" | ${tofi} --prompt-text "$(getprompt)" --placeholder-text "$(makemessage)"
}

percentescape() {
    # replace all % with %25 and all \n with %0A
    echo -n $@ | sed 's/%/%25/g; :a;N;$!ba;s/\n/%0A/g'
}

percentunescape() {
    printf '%b' "$(echo ${1} | sed -r 's/%([0-9a-fA-F]{2})/\\x\1/g')"
}

ipc_send() {
    debug "ipc (tx) $@"
    echo $@
}

description=""
prompt=""
errormsg=""

declare -A options
options[default-prompt]="PIN:"

debug "Opening assuan IPC"
ipc_send "OK Pleased to meet you"

while read line
do
    debug "ipc (rx) ${line}"
    cmd=$(echo ${line} | cut -d ' ' -f 1)
    arg=$(percentunescape "${line#${cmd}}")
    case ${cmd} in
        SETDESC)
            description="${arg}"
            ipc_send OK;;
        SETPROMPT)
            prompt="${arg}"
            ipc_send OK;;
        SETERROR)
            errormsg="${arg}"
            ipc_send OK;;
        SETOK | SETCANCEL | SETNOTOK)
            ipc_send OK;; # we can't implement these
        SETQUALITYBAR)
            ipc_send OK;;
        SETKEYINFO)
            ipc_send OK;;
        GETINFO)
            case "${arg}" in
                flavor)
                    ipc_send "D tofi";;
                version)
                    ipc_send "D 0.0.0";;
                ttyinfo)
                    ipc_send "D - - -";;
                pid)
                    ipc_send "D $$";;
            esac
            ipc_send OK;;
        GETPIN)
            pin=$(getpin)
            if [[ $? -eq 0 ]]; then
                ipc_send "D $(percentescape ${pin})"
                ipc_send OK
            else
                ipc_send "ERR 83886179 Operation cancelled <Pinentry>"
            fi
            [[ "${options[touch-file]}" ]] && touch ${options[touch-file]}
            ;;
        CONFIRM)
            result=$(confirm)
            if [[ "${result}" == "yes" ]]; then
                ipc_send OK
            else
                ipc_send "ERR 83886179 Operation cancelled <Pinentry>"
            fi;;
        OPTION)
            key=$(echo "${arg}" | cut -d '=' -f 1 | xargs)
            value=$(echo "${arg}" | cut -d '=' -f 2 | xargs)
            options["${key}"]="${value}"
            ipc_send OK;;
        BYE)
            ipc_send OK
            exit 0;;
        NOP)
            ipc_send OK;;
        "#");; # comment. ignore completely
        *)
            ipc_send "ERR 536871187 Unknown IPC command <Pinentry>"
    esac
done
