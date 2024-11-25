#!/bin/bash

function  Main()
{
    local  subCommand="$1"
    if [ "${subCommand}" == ""  -o  "${subCommand}" == "setup" ]; then
        SetUp  "$@"
    elif [ "${subCommand}" == "clean" ]; then
        Clean  "$@"
    else
        Error  "ERROR: Unknown sub command \"${subCommand}\""
    fi
}

function  SetUp()
{
	echo  "Hello, world!"
}

function  Clean()
{
if false; then #// "Skipped"
echo "Skipped"  ;fi

	echo  ""
	echo  "List up files ..."

	ls
}

function  Error() {
    local  errorMessage="$1"
    echo  "${errorMessage}"
    exit  2
}

Main  "$@"
