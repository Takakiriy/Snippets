#!/bin/bash
#// Character Encoding: "WHITE SQUARE" U+25A1 is □.
set -eE  #// -eE option breaks execution, when an error was occurred.

function  AllTest() {
    Test_Min
    Test_Pause
    Test_ErrorIfLastIs
    EndOfTest
}

function  EndOfTest() {
    echo  ""
    echo  "ErrorCount: ${ErrorCount}"
    if [ "${ErrorCount}" == "0" ]; then
        echo  "Pass."
    fi
}

function  Test_Min() {
    ./bashlib_min.sh
    ./bashlib_min.sh  clean
    ./bashlib_min.sh  unknown  ||  IgnoreError
}

function  Test_Pause() {
    echo  "Press Enter key..."
    Pause 11
}

function  Pause() {
    local  key
    if [ "${key}" == "" ]; then
        key="Pause"
    fi
    read  -p "$1>"  key
}

function  Test_ErrorIfLastIs() {
    local  output="$( Test_Sub_ErrorIfLastIs )"
    local  answer="$( echo -e 'OK\nstdout\n(ERROR)\n' )"
    if [ "${output}" != "${answer}" ]; then
        TestError  "ERROR in Test_ErrorIfLastIs"
    fi
}

function  Test_Sub_ErrorIfLastIs() {
    local  output=""

    output="$( echo "OK" || echo "(ERROR)" )"
    echo  "${output}"
    ErrorIfLastIs  "(ERROR)"  "${output}"

    output="$( TestReturn1 || echo "(ERROR)" )"
    echo  "${output}"
    ErrorIfLastIs  "(ERROR)"  "${output}"

    echo  "not reach here"
}

function  ErrorIfLastIs() {
    local  tag="$1"
    local  output="$2"

    local  last="${output:${#output}-${#tag}:${#tag}}"

    if [ "${last}" == "${tag}" ]; then
        exit  2
    fi
}

function  TestReturn1()
{
    echo  "stdout"
	return  1
}

function  TestError() {
    local  errorMessage="$1"
    if [ "${ErrorCountBeforeStart}" == "${NotInErrorTest}" ]; then

        echo  "${errorMessage}"
    fi
    LastErrorMessage="${errorMessage}"
    ErrorCount=$(( ${ErrorCount} + 1 ))
}
ErrorCount=0
LastErrorMessage=""

function  IgnoreError() {
    return 0
}

export  True=0  #// 0 is same as the specifiation of Linux bash "test" command
export  False=1  #// Not 0 is same as the specifiation of Linux bash "test" command

AllTest  "$@"
