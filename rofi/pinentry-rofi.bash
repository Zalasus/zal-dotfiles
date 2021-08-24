#!/bin/bash

# pinentry-rofi.bash
#  This is a pure bash implementation of a GnuPG pinentry program that uses
#  Rofi as a graphical frontend. I do not vouch for security or anything.

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
if [[ -z "${DISPLAY}" ]]; then
    echo "# DISPLAY not set. falling back to pinentry-curses"
    exec pinentry-curses "$@"
fi

makemessage() {
    [[ "${description}" ]] && echo "${description}"
    [[ "${errormsg}" ]] && echo "<span foreground=\"red\">${errormsg}</span>"
}

getprompt() {
    if [[ -z "${prompt}" ]]; then
        echo ${options[default-prompt]}
    else
        echo ${prompt}
    fi
}

getpin() {
    export DISPLAY
    rofi -dmenu -p "$(getprompt)" -mesg "$(makemessage)" -input /dev/null -password
}

confirm() {
    echo -e "yes\nno" | rofi -dmenu -p "$(getprompt)" -mesg "$(makemessage)"
}

percentescape() {
    # replace all % with %25 and all \n with %0A
    echo -n $@ | sed 's/%/%25/g; :a;N;$!ba;s/\n/%0A/g'
}

percentunescape() {
    printf '%b' "$(echo ${1} | sed -r 's/%([0-9a-fA-F]{2})/\\x\1/g')"
}

description=""
prompt=""
errormsg=""

declare -A options
options[default-prompt]="PIN:"

echo "OK Pleased to meet you"

while read line
do
    cmd=$(echo ${line} | cut -d ' ' -f 1)
    arg=$(percentunescape "${line#${cmd}}")
    case ${cmd} in
        SETDESC)
            description="${arg}"
            echo OK;;
        SETPROMPT)
            prompt="${arg}"
            echo OK;;
        SETERROR)
            errormsg="${arg}"
            echo OK;;
        SETOK | SETCANCEL | SETNOTOK)
            echo OK;; # we can't implement these
        SETQUALITYBAR)
            echo "OK";;
        SETKEYINFO)
            echo "OK";;
        GETINFO)
            case "${arg}" in
                flavor)
                    echo "D rofi";;
                version)
                    echo "D 0.0.0";;
                ttyinfo)
                    echo "D - - -";;
                pid)
                    echo "D $$";;
            esac
            echo OK;;
        GETPIN)
            pin=$(getpin) 
            if [[ $? -eq 0 ]]; then
                echo "D $(percentescape ${pin})"
                echo OK
            else
                echo "ERR 83886179 Operation cancelled <Pinentry>"
            fi
            [[ "${options[touch-file]}" ]] && touch ${options[touch-file]}
            ;;
        CONFIRM)
            result=$(confirm)
            if [[ "${result}" == "yes" ]]; then
                echo OK
            else
                echo "ERR 83886179 Operation cancelled <Pinentry>"
            fi;;
        OPTION)
            key=$(echo "${arg}" | cut -d '=' -f 1 | xargs)
            value=$(echo "${arg}" | cut -d '=' -f 2 | xargs)
            options["${key}"]="${value}"
            echo OK;;
        BYE)
            echo OK
            exit 0;;
        NOP)
            echo OK;;
        "#");; # comment. ignore completely
        *)
            echo "ERR 536871187 Unknown IPC command <Pinentry>"
    esac
done
