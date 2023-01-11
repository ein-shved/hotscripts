#!/bin/bash

function prErr() {
    echo "${FUNCNAME[1]}:" "$@" >&2
    return 1
}

function setOutVar() {
    local l_name="$1"
    local l_val="$2"

    [ -n "$l_name" ] && {
        eval $l_name="$l_val" || return 1
    } || return 0
}
