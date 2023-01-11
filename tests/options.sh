#!/bin/bash

source ../include/options.sh

assertRet() {
    local l_op="$1"; shift
    local l_val="$1"; shift
    local l_ret

    "$@"
    l_ret=$?

    assert"$l_op" "$l_val" "$l_ret"
    return $?
}

assertSuccess () {
    assertRet Equals 0 "$@"
    return $?
}

assertFailed () {
    assertRet NotEquals 0 "$@"
    return $?
}

testOpts_Parse_Single() {
    assertSuccess parseOpt ASingleOp op_name op_val has_val is_neg
    assertEquals ASINGLEOP "$op_name"
    assertEquals "" "$op_val"
    assertEquals 0 "$has_val"
    assertEquals 0 "$is_neg"

    assertSuccess parseOpt asingleop op_name op_val has_val is_neg
    assertEquals ASINGLEOP "$op_name"
    assertEquals "" "$op_val"
    assertEquals 0 "$has_val"
    assertEquals 0 "$is_neg"

    assertSuccess parseOpt no-asingleop op_name op_val has_val is_neg
    assertEquals ASINGLEOP "$op_name"
    assertEquals "" "$op_val"
    assertEquals 0 "$has_val"
    assertEquals 1 "$is_neg"

    assertSuccess parseOpt NO-ASingleOp op_name op_val has_val is_neg
    assertEquals ASINGLEOP "$op_name"
    assertEquals "" "$op_val"
    assertEquals 0 "$has_val"
    assertEquals 1 "$is_neg"

}

testOpts_Parse_Val() {
    assertSuccess parseOpt AValOp=SomeVal op_name op_val

    assertEquals AVALOP "$op_name"
    assertEquals SomeVal "$op_val"
}

testOpts_Parse_Wrong() {
    assertFailed parseOpt
    assertFailed parseOpt 'OP =VAL'
    assertFailed parseOpt 'O P'
    assertFailed parseOpt ' OP'
    assertFailed parseOpt '=OP'
    assertFailed parseOpt 'O-P'


    assertFailed parseOpt 'OP' wrong-name
    assertFailed parseOpt 'OP' _ wrong-name
    assertFailed parseOpt 'OP' _ _ wrong-name
    assertFailed parseOpt 'OP' _ _ _ wrong-name
}

. shunit2
