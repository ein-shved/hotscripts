#!/bin/bash

INCDIR="${BASH_SOURCE%/*}"
[ -d "$INCDIR" ] || INCDIR="$PWD"

source $INCDIR/util.sh

# Parses option expression in form [NO-]<OP_NAME>[=<OP_VALUE>] returns its name
# and value in separate variables
#
# $1 - opt expression
# $2 - name of out variable for option name
# $3 - name of out variable for option value
# $4 - name of out variable which will be set to 1 in case if the expiration
#      specified OP_VALUE and to 0 in case if not
# $5 - name of out variable which will be set to 1 in case if the expiration
#      have option with negation suffix and to 0 in case if not

function parseOpt() {
    local l_exp="$1"
    local l_out_name="$2"
    local l_out_val="$3"
    local l_out_eq="$4"
    local l_out_neg="$5"

    local l_op_name l_op_val l_op_eq l_op_neg

    [ -z "$l_exp" ] && {
        prErr "Argument required";
        return 1;
    }

    # Parse expression with optional equalaty symbol. If parsing failed - make
    # sed to exit with error code otherwize output the string in view
    # l_op_name='..';l_op_val='..';l_op_eq='..';l_op_neg='..' and eval this
    # string to apply to local variables

    local l_re='^\([Nn][Oo]-\)\?\(\w\+\)\(\(=\)\(.*\)\)\?$'
    local l_rep="l_op_name='\\2';l_op_val='\\5';l_op_eq='\\4';l_op_neg='\\1'"
    local l_parse_exp

    l_parse_exp="$(echo "$l_exp" |\
        sed "s/$l_re/$l_rep/;t;q 1")" || {
            prErr "'$l_exp' is invalid option expression";
            return 1;
        }

    eval $l_parse_exp || return 1;

    setOutVar "$l_out_name" "${l_op_name^^}" || return 1
    setOutVar "$l_out_val" "$l_op_val" || return 1
    setOutVar "$l_out_eq" "$([ -n "$l_op_eq" ] && echo 1 || echo 0)" || return 1
    setOutVar "$l_out_neg" "$([ -n "$l_op_neg" ] && echo 1 || echo 0)" || return 1

    return 0
}
