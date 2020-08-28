This script installs:

	- Node.js
	- .NET Core SDK
	- Azure CLI
	- Azure Functions Core Tools

The version of Azure CLI is the value of the `g_AzureCLI_Version` variable in `scripts.sh` file.
The version of Azure Azure Functions Core Tools is newest Version.


## How to try Azure Functions

1. Install the above "Azure Functions Core Tools"
2. Create new folder as new project
3. Open the new folder in Visual Studio Code and install the following extensions
    - Azure Functions (0.24.0)
    - C# (1.23.1)
4. For more information, see the link below
    - Quickstart: Create a function in Azure using Visual Studio Code
    https://docs.microsoft.com/en-us/azure/azure-functions/functions-create-first-function-vs-code?pivots=programming-language-csharp


## Open bash

To open bash for use with installed commands, after installation,
drag and drop the folder of the project you are developing into the `run_open.bat` file.
