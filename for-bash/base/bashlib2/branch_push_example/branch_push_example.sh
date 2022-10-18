#!/bin/bash
#// Character Encoding: "WHITE SQUARE" U+25A1 is □.
set -eE  #// -eE option breaks execution, when an error was occurred.

function  Main()
{
    CreateNewBranch
}

function  CreateNewBranch()
{
    local  tokenPath="${HOME}/.secret/gitlab-pat"
    local  accountAt="oauth2:$(cat ${tokenPath})@"  #search: git clone PAT
    local  baseBranchName="main"
    local  newBranchName="staging"
    local  projectName="${aURL##*/}"
    AssertExist  "branch_push_example.sh"  #// Check current folder
    AssertExist  "${tokenPath}"
    rm -rf  "${projectName}"

    #// git clone
	git clone  -b "${baseBranchName}"  "https://${accountAt}gitlab.com/takakiriy1/first"
    cd  "${projectName}"

    #// Delete old branch
    local  branchExists="${False}"
    git branch --all | grep "remotes/origin/${newBranchName}"  &&  branchExists="${True}"
    if [ "${branchExists}" == "${True}" ]; then
        git push  --delete origin  "${newBranchName}"
    fi

    #// Edit new branch and git push
    git checkout -b "${newBranchName}"
    echo "a" >> "a.txt"
    git add "."
    git commit -m "Added a charactor."
    git push --set-upstream origin "${newBranchName}"

    #// Clean up
    cd  ".."
    rm -rf  "${projectName}"
    echo "Done"
}

function  AssertExist() {
    local  path="$1"

    if [ ! -e "${path}" ]; then
        Error  "ERROR: Not found \"${path}\""
    fi
}

function  Error() {
    local  errorMessage="$1"
    echo  "${errorMessage}"
    exit  2
}

True=0  #// 0 is same as the specifiation of Linux bash "test" command
False=1  #// Not 0 is same as the specifiation of Linux bash "test" command

Main  "$@"
