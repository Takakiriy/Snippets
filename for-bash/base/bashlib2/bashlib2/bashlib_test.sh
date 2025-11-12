#!/bin/bash
#// Character Encoding: "WHITE SQUARE" U+25A1 is □.

function  Main() {
    Test_Min
    Test_Pause
    Test_ErrorIfLastIs
    Test_TestErrorIfMatched
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

function  RunAfterPause() {
    echo  "$ $( GetArgumentsString  "$@" )"  >&2
    read  -p "To continue, press Enter: "  dummyVariable
    "$@"
}

function  Test_ErrorIfLastIs() {

    local  output="$( Test_Sub1_ErrorIfLastIs )"
    local  answer="$( echo -e 'OK\nstdout\n(ERROR)\n' )"
    if [ "${output}" != "${answer}" ]; then
        TestError  "ERROR in Test_ErrorIfLastIs 1"
    fi

    local  output="$( Test_Sub2_ErrorIfLastIs )"
    local  answer="$( echo -e '(error_symbol) OK\nPass\n' )"
    if [ "${output}" != "${answer}" ]; then
        TestError  "ERROR in Test_ErrorIfLastIs 2"
    fi
}

function  Test_Sub1_ErrorIfLastIs() {
    local  output=""

    output="$( echo "OK" || echo "(ERROR)" )"
    echo  "${output}"
    ErrorIfLastIs  "${output}"  "(ERROR)"

    output="$( TestReturn1 || echo "(ERROR)" )"
    echo  "${output}"
    ErrorIfLastIs  "${output}"  "(ERROR)"

    echo  "not reach here"
}

function  Test_Sub2_ErrorIfLastIs() {
    local  output=""

    output="$( echo "(error_symbol) OK" || echo "(error_symbol)" )"
    echo  "${output}"
    ErrorIfLastIs  "${output}"  "(error_symbol)"

    echo  "Pass"
}

function  TestReturn1()
{
    echo  "stdout"
	return  1
}

# LastIs
#     Check in $( )
# Example:
#     variable="$( command  || echo "(ERROR)" )"
#     if LastIs  "${variable}"  "(ERROR)"; then
function  LastIs() {
    local  output="$1"
    local  tag="$2"

    local  last="${output:${#output}-${#tag}:${#tag}}"

    [ "${last}" == "${tag}" ]
}

# ErrorIfLastIs
#     Check command exit code or function return code in $( )
# Example:
#     variable="$( command  ||  echo "(ERROR)" )"
#     ErrorIfLastIs  "${variable}"  "(ERROR)"
function  ErrorIfLastIs() {
    local  output="$1"
    local  tag="$2"

    local  last="${output:${#output}-${#tag}:${#tag}}"

    if [ "${last}" == "${tag}" ]; then
        exit  2
    fi
}

function  ExitIfMatched() {
    # ExitIfMatched
    #     Check function return code or function exit code in $( )
    # Example:
    #     local  out="$(x="$( command )" && echo "$x" || echo "(ERROR:$?)" )"
    #     ExitIfMatched  "${out}"  '^\(ERROR:([0-9]*)\)$'
    local  output="$1"
    local  regularExpression="$2"

    if [[ "${output}" =~ ${regularExpression} ]]; then
        local  exitCode="$( echo "${output}"  |  sed -E  's/'"${regularExpression}"'/\1/')"
        exit  "${exitCode}"
    fi
}

function  Test_TestErrorIfMatched() {
    test  "${ErrorCount}" == 0  ||  Error

    local  out="$(x="$( Test_Sub11_Exit )" && echo "$x" || echo "(ERROR:$?)" )"
    TestErrorIfMatched  "${out}"  '^\(ERROR:([0-9]*)\)$'
    test  "${ErrorCount}" == 1  ||  Error

    ErrorCount=0
}

function  Test_Sub11_Exit() {
    Error  "in Test_Sub11_Exit"
}

function  TestErrorIfMatched() {  #// Count up "ErrorCount" if function return code or function exit code in $( ) is not 0
    # Example:
    #     local  out="$(x="$(  command  )" && echo "$x" || echo "(ERROR:$?)" )"
    #     TestErrorIfMatched  "${out}"  '^\(ERROR:([0-9]*)\)$'
    local  output="$1"
    local  regularExpression="$2"
    local  errorMessage="$3"

    if [[ "${output}" =~ ${regularExpression} ]]; then
        local  exitCode="$( echo "${output}"  |  sed -E  's/'"${regularExpression}"'/\1/')"
        TestError  "${errorMessage}"
    fi
}

function  EchoSubTest() {
    local  message="$1"
    if [ "${TestCaseName}" == "" ]; then
        local  name=""
    else
        local  name="  (${TestCaseName})"
    fi

    echo  "${message}${name}"
}

function  EchoEndOfTest() {
    local  name="$1"
    if [ "${name}" != "" ]; then
        TestCaseName="${name}"
    fi

    EchoSubTest  "ErrorCount: ${ErrorCount}"
    if [ "${ErrorCount}" == 0 ]; then
        EchoSubTest  "Pass."
    fi
}

function  TestError() {
    local  errorMessage="${1-""}"  #// "${1-""}" means that "$1" default is "".
    local  dateTime="${2-""}"      #// "${1-""}" means that "$1" default is "".
    if [ "${errorMessage}" == "" ]; then
        errorMessage="ERROR: a test error"
    fi
    if [ "${ErrorCountBeforeStart}" == "${NotInErrorTest}" ]; then

        EchoWithBreadcrumb  "${errorMessage}"  "${dateTime}"
    fi
    LastErrorMessage="${errorMessage}"
    ErrorCount=$(( ${ErrorCount} + 1 ))
}
ErrorCount=0
LastErrorMessage=""
TestCaseName=""

function  IgnoreError() {
    return 0
}

function  PrintCallStack() {
    echo  "Call stack:"  >&2
    local  index=0
    while frame=($( caller "${index}" )); do
        local  functionName="${frame[1]}"
        local  fileName="${frame[2]}"
        local  lineNum="${frame[0]}"
        echo  "    ${functionName} (${fileName}:${lineNum})"  >&2
        (( index ++ ))
    done
}

#// simple version
function  Error() {
    echo  "$1"  >&2
    exit 2
}

#// full version
function  Error() {
    local  errorMessage="${1-""}"  #// "${1-""}" means that "$1" default is "".
    local  exitCode="${2-""}"      #// "${1-""}" means that "$1" default is "".
    if [ "${errorMessage}" == "" ]; then
        errorMessage="ERROR"
    fi
    if [ "${exitCode}" == "" ]; then  exitCode=2  ;fi
    if [ "${InChildProcess}" == "yes" ]; then
        local  seeChildProcessMessage="(See above error message. The following message is usually no effective.) "
    else
        local  seeChildProcessMessage=""
    fi

    PrintCallStack

    EchoWithBreadcrumb  "${seeChildProcessMessage}${Red}${errorMessage}${DefaultColor}"  >&2
    if [ "${MSYSTEM}" == "MINGW64" ]; then
        echo  "[Advice] Git bash is flaky on Windows. Install WSL2 and input the command: wsl __CommadAndParameters__"
    fi
    exit  "${exitCode}"
}
DefaultColor="\e[0m"
Red="\e[91m"

export  True=0  #// 0 is same as the specifiation of Linux bash "test" command
export  False=1  #// Not 0 is same as the specifiation of Linux bash "test" command

Main  "$@"
