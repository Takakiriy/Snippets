[ English | [Japanese](README-jp.md) ]

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
3. Edit setting in `cypress.env.json` file
	- `LogInToken` is where the log-in token is located. The value is `"InCookie"` or `"InLocalStorage"`
		- In aws Amplify environment, match the presence or absence of `Auth/cookieStorage` in the argument to pass to `Amplify.configure`
	- `LogInAccount` and `LogInPassword` are the account and the password you signed up
4. Open bash and run one of the shell scripts.
	- Shell script file has .sh extension
	- To launch bash, right-click on a folder and select **Git Bash Here**
	- Type `./install_Cypress.sh` (Enter) to run the shell script
	- Type `./install_Cypress.sh  clean` (Enter) to run the shell script to uninstall
	- You can also double-click `install_Cypress.bat` file or `clean.bat` file to run it
5. There is a test script in the `cypress/integration`.
	- `0_visit.js`: Open a specific URL
	- `1_make_log-in_token.js`: Save the token in the log-in state to a file
	- `2_log-in_test.js`: Run a simple automated test using log-in token file
