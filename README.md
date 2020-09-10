# Takakiri's Snippets

Snippets are versioned here.

[ English | [Japanese](README-jp.md) ]

## List

- for-bash
	- base
		- [bashlib](for-bash/base/bashlib/Example_without_inc.sh) - A basic part of the bash shell script file that also allows for efficient debugging
	- [git_clone_commit](for-bash/git_clone_commit/git_clone_commit.sh) - Git clone a specific commit
	- installer
		- Azure
			- [CLI](for-bash/installer/Azure/CLI/)
		- cypress - E2E automatic test tool
			- [base](for-bash/installer/cypress/base/)
			- [+ log in](for-bash/installer/cypress/login/)
		- [Node.js](for-bash/installer/Node_js/)
		- React
			- [created_React_project](for-bash/installer/React/created_React_project/)
			- [create-react-app](for-bash/installer/React/create-react-app/)
		- Visual Studio Code
			- [base](for-bash/installer/VisualStudioCode/base/)
			- [+ TypeScript](for-bash/installer/VisualStudioCode/TypeScript/)


## How to install (Windows)

1. Install Git bash.
	- https://git-scm.com/downloads
	- Example of downloading installer file name: `Git-2.27.0-64-bit.exe`
	- bash must be installed. Other settings are optional
2. Place Node.js package under `${USERPROFILE}\Downloads` folder.
	- https://nodejs.org/ja/download/
	- Example of downloading installer file name: `node-v12.18.3-x64.msi`
	- The version of Node.js is the value of the `g_Node_js_Version` variable
		in the shell script to be executed later
	- Some shell scripts need to be placed in the location indicated by the error message when they are run
	- You can also double-click `run_*.bat` file to run them
3. Open bash and run one of the shell scripts in the Takakiri&apos;s snippet.
	- Shell script file has .sh extension
	- To launch bash, right-click on a folder and select **Git Bash Here**
	- Type `./__FileName__.sh` (Enter) to run the shell script

This was synchronized with "README-jp.md" in 2020-07-26 commit next to 79d12be7.
