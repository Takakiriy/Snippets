#!/bin/bash
#// Character Encoding: "WHITE SQUARE" U+25A1 is □.
set -eE
#// -eE option breaks execution, when an error was occurred.

#********************************************************************
#* File: ________.sh
#    Type "./________.sh" in Windows git bash.
#    Type "chmod +x ________.sh" and "./________.sh" in Linux bash.
#********************************************************************

#// Setting
#//==================================================================

export  g_DependenciesTitle="test_application"
export  g_Dependencies=( "Node.js" "npm-check-updates" )
#//==================================================================


#********************************************************************
# Function: Main_func
#********************************************************************
function  Main_func()
{
	if [ "$1" == ""  -o  "$1" == "setup" ]; then
		SetUp_func
	elif [ "$1" == "clean"  -o  "$1" == "cleanup" ]; then
		CleanUp_func
	elif [ "$1" == "test" ]; then
		Test_func
	elif [ "$1" == "manual-test" ]; then
		ManualTest_func
	else
		Error_func  "Unknown command name: $1"
	fi
	return  0
}


#********************************************************************
# Function: SetUp_func
#********************************************************************
function  SetUp_func()
{
	#// Skip
if false; then #// "Skipped"
echo "Skipped"  ;fi

	#// ...
	echo  ""
	ColorEcho_func  "List up files ...\n"  "Green"
	EchoNextCommand_func

	ls
	EchoNextCommand_func

	error_
#//echo "Skipped"  ;fi  #// Rolback
	echo  "After the error"
}


#********************************************************************
# Section: bashlib
#********************************************************************

#********************************************************************
# Function: Error_func
#    Occurrs an error
#
# Arguments:
#    Error messages
#
# Return Value:
#    None
#********************************************************************
function  Error_func()
{
	ErrClass.getErrStr_method  "$@" ; g_Err_Desc="$g_ReturnValue"
	return_func  1
}


#*********************************************************************
# Function: return_func
#*********************************************************************
function  return_func()
{
	if [ "$g_Err_LineNo" == "???" ];then  g_Err_LineNo=${BASH_LINENO[0]}  ;fi
	return  "$1"
}


#*********************************************************************
# Function: Test_func
#*********************************************************************
function  Test_func()
{
	TestOfStringsHasTheString_func
	TestOfCutAPartOfStringsAtTheString_func
	echo  "Pass."
}


#*********************************************************************
# Function: ManualTest_func
#*********************************************************************
function  ManualTest_func()
{

TestOfAddSystemPathVariable_func

	#// TestOfAddSystemPathVariable_func
	echo  "Pass."
}


#*********************************************************************
# Function: IsWindows_func
#
# Example:
#    if IsWindows_func; then
#        echo  "in Windows"
#    else
#        echo  "in Linux or others"
#    fi
#    if ! IsWindows_func; then  #// If not Windows
#*********************************************************************
function  IsWindows_func()
{
	if [ -e "/c/Windows/" ]; then
		return  ${True}
	else
		return  ${False}
	fi
}


#********************************************************************
# Function: EchoNextCommand_func
#    Enables to show the next executing command
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  EchoNextCommand_func()
{
	g_DebugTrapFunc="EchoNextTrap_func"
	echo  ""

	trap 'DebugTrap_func  "$LINENO"  "$BASH_COMMAND"  "${PIPESTATUS[@]}"
		#// resume ${PIPESTATUS[@]}
		case "${#g_PipeStatus[@]}" in
			"2")
				return ${g_PipeStatus[0]} | true;;
			"3")
				return ${g_PipeStatus[0]} | return ${g_PipeStatus[1]} | true;;
		esac' DEBUG
}

function  EchoNextTrap_func()
{
	local  line_num="$1"
	local  command="$2"
	shift  2
	g_PipeStatus=( "$@" )
	local  escaped_command="$( echo "$command" | sed -e "s/>/\\\\>/" )"

	echo "${line_num}: \$ ${command}" >&2
	case "${command}" in *\$*)
		echo  "$(eval echo ${line_num}: \$ ${escaped_command})" >&2;;
	esac

	g_DebugTrapFunc=""
}


#********************************************************************
# Function: EchoOn_func
#    Enables to show the executing commands
#
# Arguments:
#    None
#
# Return Value:
#    None
#
# Description:
#    Commands in calling functions are not shown.
#********************************************************************
function  EchoOn_func()
{
	g_DebugTrapFunc="EchoOnTrap_func"

	trap 'DebugTrap_func  "$LINENO"  "$BASH_COMMAND"  "${PIPESTATUS[@]}"
		#// resume ${PIPESTATUS[@]}
		case "${#g_PipeStatus[@]}" in
			"2")
				return ${g_PipeStatus[0]} | true;;
			"3")
				return ${g_PipeStatus[0]} | return ${g_PipeStatus[1]} | true;;
		esac' DEBUG
}

function  EchoOnTrap_func()
{
	local  LineNo="$1"
	local  Command="$2"
	shift  2
	g_PipeStatus=( "$@" )

	echo "$LineNo: $Command" >&2
}


 
#********************************************************************
# Function: EchoOff_func
#    Disables to show the executing commands
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  EchoOff_func()
{
	g_DebugTrapFunc=""
}


 
#********************************************************************
# Function: ColorEcho_func
#    Echos colored text
#
# Arguments:
#    in_Text      - .
#    in_ColorName - .
#
# Return Value:
#    None
#
# Example:
#    > ColorEcho_func  "Pass.\n"  "Green"
#********************************************************************
function  ColorEcho_func()
{
	local  in_Text="$1"
	local  in_ColorName="$2"

	ColorText_func  "${in_Text}"  "${in_ColorName}"
	echo -e -n  "$g_ReturnValue"
}


#********************************************************************
# Function: echo_line_func
#    Echos a line
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  echo_line_func()
{
	echo "-------------------------------------------------------------------------------"
}


#********************************************************************
# Function: Pause_func
#    Waits until user confirmation
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  Pause_func()
{
	local  key

	if [ "${LANG}" == "ja_JP.UTF-8" ]; then
		read -p "続行するには Enter キーを押してください . . . "  key
	else
		read -p "Press Enter key to continue ..."  key
	fi
}


#********************************************************************
# Function: ColorText_func
#    Adds the color to the specified text
#
# Arguments:
#    in_Text      - A text
#    in_ColorName - Color name or background color name or bold (1)
#    in_ColorName - Color name or background color name or bold (2)
#         :
#
# Return Value:
#    g_ReturnValue - The color attached text that will be used with echo command
#
# Example:
#    > ColorText_func  "Pass."  "Green"  "Bold"
#    > echo_e_func  "$g_ReturnValue"
#********************************************************************
function  ColorText_func()
{
	local  in_Text="$1"
	shift  1
	local  in_ColorNames=("$@")
	local  i
	local  n
	local  str

	#//=== initialize  g_ColorText_Codes
	if [ "${g_ColorText_Codes["Black"]}" == "" ];then

		#//=== set escape sequence
		g_ColorText_Codes["Black"]=30
		g_ColorText_Codes["Red"]=31
		g_ColorText_Codes["Green"]=32
		g_ColorText_Codes["Yellow"]=33
		g_ColorText_Codes["Blue"]=34
		g_ColorText_Codes["Magenta"]=35
		g_ColorText_Codes["Cyan"]=36
		g_ColorText_Codes["White"]=37

		g_ColorText_Codes["BlackBack"]=40
		g_ColorText_Codes["RedBack"]=41
		g_ColorText_Codes["GreenBack"]=42
		g_ColorText_Codes["YellowBack"]=43
		g_ColorText_Codes["BlueBack"]=44
		g_ColorText_Codes["MagentaBack"]=45
		g_ColorText_Codes["CyanBack"]=46
		g_ColorText_Codes["WhiteBack"]=47

		g_ColorText_Codes["Bold"]=1
	fi

	sequence="\e["
	n=$(( ${#in_ColorNames[@]} - 1 ))
	for (( i = 0;  i <= n;  i++ )) ;do
		local  color_code="${g_ColorText_Codes[${in_ColorNames[$i]}]}"
		if [ "$i" == "$n" ];then
			sequence="${sequence}${color_code}m"
		else
			sequence="${sequence}${color_code};"
		fi
	done ; done_func $?

	g_ReturnValue="${sequence}${in_Text}\e[m"
}

declare -A  g_ColorText_Codes


#********************************************************************
# Function: echo_e_func
#    Echos texts including escape. This is as same as "echo -e"
#
# Arguments:
#    in_Text - Echo texts
#
# Return Value:
#    None
#********************************************************************
function  echo_e_func()
{
	local  in_Text="$@"
	eval echo '$'"'$in_Text'"
}


#********************************************************************
# Function: ErrTrap_func
#    The function called from the error trap
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************

g_ExitStatus=0
g_ReturnValue=""
g_Ret2=""
g_Ret3=""
g_Err_IsDone=0
g_Err_IsOverwrite=0
g_Err_NestLevel=0
g_Err_ErrID=0
g_Err_Desc=""
g_Err_Desc1st=""
g_Err_LineNo="???"
g_PipeStatus=""
g_DebugTrapFunc=""

function  ErrTrap_func()
{
	local  a1

	if [ "$g_Err_IsDone" == "1" ];then
		g_Err_IsDone=0
	elif [ "$g_Err_IsOverwrite" == "1" ];then
		g_Err_IsOverwrite=0
	else

		g_Err_ErrID=$(( $g_Err_ErrID + 1 ))

		if [ "$g_ExitStatus" == "0" ];then
			if [ "$g_Err_LineNo" == "???" ];then  g_Err_LineNo=$1  ;fi
			if [ "$g_Err_LineNo" == "???" ]; then
				a1="${a1}（ヒント）現在の行番号は、${FUNCNAME[1]} 関数の最初で \"EchoOn_func\" を呼ぶと表示されます。${LF}"
			fi
			a1="${a1}（開発者向けヒント）ステップ実行したいときは、開始するところから \"debugger\" 関数を呼び出してください。 "
			a1="${a1}下記コールツリーの最も下の関数が、"'$( )'" を使って echo 出力を取得しているときは、取得しないようにすると、更にコール先の関数が表示されます。${LF}"
			ErrClass.getCallTree_method  "$g_Err_LineNo"  2  1
			#// g_Err_ErrCallStack="$a1$g_ReturnValue$LF"
			g_Err_ErrCallStack="$g_ReturnValue$LF"
			g_ExitStatus=1
		else
			echo  "<ERROR msg=\"エラー処理中に別のエラーが発生しました。\"/>" >&2

			ErrClass.getErrStr_method  "$g_Err_Desc"
			if [ "$g_ReturnValue" == "" ];then  g_ReturnValue="<ERROR/>"  ;fi
			ColorText_func  "$g_ReturnValue"  "Red" "Bold"
			echo_e_func  "$g_ReturnValue"

			ErrClass.getCallTree_method  "${BASH_LINENO[0]}"  2  1
			echo  "$g_ReturnValue"  >&2
			g_Err_Desc="$g_Err_Desc1st"
		fi


		if [ "$g_Err_Desc" == "" ];then
			ColorText_func  "<ERROR/>"  "Red" "Bold"
		else
			local  error_description="$( echo "$g_Err_Desc" | sed -e "s/\\\\/\\\\\\\\/g" )"  #// Disable escape
			ColorText_func  "$error_description"  "Red" "Bold"
		fi
		echo_e_func  "$g_ReturnValue" >&2
		echo "Exit Status = $g_ExitStatus"  >&2
		echo_line_func
		echo -n "$g_Err_ErrCallStack"  >&2
		if [ "$g_Err_Desc" == "" ];then
			echo  "<ERROR/>"  >&2
		else
			echo  "$g_Err_Desc"  >&2
		fi
		if [ "$is_not_err_handled" == "1" ];then
			echo  "エラー処理がされていません。ErrClass.clear_method または ErrClass.raiseOverwrite_method を呼び出してください"
		fi
		trap ':' EXIT
		if [ "${g_IsSourceCommand}" == "${False}" ]; then

			exit  "$g_ExitStatus"
		else
			cd  "${g_StartInPath}"
			while true; do
				read -p "This script was terminated. Please press Ctrl+C"  dummy_variable
			done
			#// "set -eE; return 1" is same as exit command.
		fi
	fi
}


#********************************************************************
# Function: done_func
#    Raises a raising exception at the end of loop
#
# Arguments:
#    None
#
# Return Value:
#    None
#
# Example:
#    > while true; do
#    >     :
#    > done ; done_func $?
#********************************************************************
function  done_func()
{
	CheckArgCount_func  1 "$@"
	if [ "$1" != "0" ];then  g_Err_IsDone=1  ;fi
	return  "$1"  #// if not 0, throw again
}


 
#********************************************************************
# Function: CheckArgCount_func
#    Checks the count of arguments at the called function
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  CheckArgCount_func()
{
	local  RequestArgumentCount="$1"
	shift  1
	local  Arguments=( "$@" )
	local  str

	if [ "${#Arguments[@]}" -ne "$RequestArgumentCount" ];then
		str="パラメーターの数が合っていません。 指定=${#Arguments[@]}, 要求=$RequestArgumentCount,"
		str="$str コマンドライン: ${FUNCNAME[1]} ${Arguments[@]}"
		Error_func  "$str"
	fi
}


#*********************************************************************
# Function: AddDependencies_func
#
# Arguments:
#    in_Title        - The name of the owner module
#    in_Dependencies - An array of target module names without spaces
#
# Return Value:
#    None
#
# Example:
#    > AddDependencies_func  "${g_DependenciesTitle}"  "${g_Dependencies[@]}"
#*********************************************************************
function  AddDependencies_func()
{
	local  in_Title="$1"
	shift
	local  in_Dependencies=( $* )
	if [ ! -e "${HOME}/.dependencies" ]; then
		mkdir  "${HOME}/.dependencies"
	fi
	rm -f  "${HOME}/.dependencies/${in_Title}.txt"

	for  module  in  "${in_Dependencies[@]}" ;do
		echo  "${module}" >> "${HOME}/.dependencies/${in_Title}.txt"
	done
}


#*********************************************************************
# Function: GetSharedDependencies_func
#
# Arguments:
#    in_Title        - The name of the owner module
#    in_Dependencies - An array of target module names
#
# Return Value:
#    g_SharedDependencies - An associative array of target module names shared with others
#
# Example:
#    > GetSharedDependencies_func  "${g_DependenciesTitle}"  "${g_Dependencies[@]}"  #// g_SharedDependencies = .
#    > if [ -v g_SharedDependencies["Node.js"] ]; then
#    > if [ ! -v ... ]; then  #// if not shared
#*********************************************************************
function  GetSharedDependencies_func()
{
	local  in_Title="$1"
	shift
	local  in_Dependencies=( $* )
	local -A  dependencies
	for  module  in  "${in_Dependencies[@]}"; do
		dependencies[${module}]="dummy"
	done
	g_SharedDependencies=()

	#// Set the key of "g_SharedDependencies" associative array to the name of the module in the file
	#// "${HOME}/.dependencies" folder of the elements of "in_Dependencies" array.
	#jp:// in_Dependencies 配列の要素のうち、${HOME}/.dependencies フォルダーにあるファイルの中に書かれている
	#jp:// モジュール名を g_SharedDependencies 連想配列のキーに設定します。
	if [ -e "${HOME}/.dependencies" ]; then
		local  file_paths=( $(find  "${HOME}/.dependencies") )

		for  file_path  in  "${file_paths[@]}"; do
			local  is_other_file=${False}
			if [ -f "${file_path}" ]; then  #// Because file_paths has a folder path
				if [ "${file_path}" != "${HOME}/.dependencies/${in_Title}.txt" ]; then
					is_other_file=${True}
				fi
			fi
			if [ ${is_other_file} == ${True} ]; then
				local  line
				local  modules_in_other_files=()
				while read  line; do
					modules_in_other_files=("${modules_in_other_files[@]}" "${line}")
				done < <( cat "${file_path}" )

				for  module  in  "${modules_in_other_files[@]}" ;do
					local  dependencies_has_the_module=${False}
					if [ -v dependencies[${module}] ];then
						dependencies_has_the_module=${True}
					fi
					local  is_shared=${dependencies_has_the_module}

					if [ ${is_shared} == ${True} ]; then
						g_SharedDependencies[${module}]="dummy"
					fi
				done
			fi
		done
	fi
}
declare -A  g_SharedDependencies


#*********************************************************************
# Function: RemoveDependencies_func
#
# Arguments:
#    in_Title - The name of the owner module
#
# Return Value:
#    None
#
# Example:
#    > RemoveDependencies_func  "${g_DependenciesTitle}"
#*********************************************************************
function  RemoveDependencies_func()
{
	local  in_Title="$1"

	rm -f  "${HOME}/.dependencies/${in_Title}.txt"
}


#********************************************************************
function  SafeFileUpdate_func()
{
	local  in_SourceFilePath="$1"
	local  in_DestinationFilePath="$2"

	local  is_same="${False}"
	diff -s  "${in_SourceFilePath}"  "${in_DestinationFilePath}" > /dev/null && is_same="${True}"
	if [ "${is_same}" == "${False}" ]; then
		mv  "${in_SourceFilePath}"  "${in_DestinationFilePath}"
	else
		rm  "${in_SourceFilePath}"
	fi
}


#********************************************************************
# Function: Get_POSIX_Path_func
#    Changes Windows path to POSIX path
#
# Arguments:
#    in_InputPath - POSIX path or Windows path
#
# Return Value:
#    g_ReturnValue - POSIX path
#********************************************************************
function  Get_POSIX_Path_func()
{
	local  in_InputPath="$1"
	local  path_="${in_InputPath}"


	#// is_full_path = ...
	local  is_full_path="${False}"
	if [ "${path_:1:2}" == ":\\" ]; then
		is_full_path="${True}"
	fi


	#// path_ = ...
	if [ "${is_full_path}" == "${True}" ]; then
		local  drive_name="${path_:0:1}"
		local  lower_drive_name="${drive_name,,}"

		path_="/${lower_drive_name}/${path_:3}"
	fi
	path_="$( echo "$path_" | sed -e "s,\\\\,/,g" )"  #// Replace "\" to "/"

	g_ReturnValue=${path_}
}


#********************************************************************
# Function: GetWindowsPath_func
#    Changes POSIX path to Windows path
#
# Arguments:
#    in_InputPath - POSIX path or Windows path
#
# Return Value:
#    g_ReturnValue - Windows path
#********************************************************************
function  GetWindowsPath_func()
{
	local  in_InputPath="$1"
	local  path_="${in_InputPath}"


	#// is_full_path = ...
	local  is_full_path="${False}"
	if [ "${path_:0:1}" == "/" ]; then
		if [ "${path_:2:1}" == "/" ]; then
			is_full_path="${True}"
		fi
	fi


	#// path_ = ...
	if [ "${is_full_path}" == "${True}" ]; then
		path_="${path_:1:1}:${path_:2}"
	fi
	path_="$( echo "$path_" | sed -e "s,/,\\\\,g" )"  #// Replace "/" to "\"

	g_ReturnValue=${path_}
}


#*********************************************************************
# Function: GetFullPath_func
#
# Arguments:
#    in_RelativePath - in_RelativePath
#    in_BasePath - in_BasePath
#
# Return Value:
#    g_ReturnValue - Full path
#*********************************************************************
function  GetFullPath_func()
{
	local  in_RelativePath="$1"
	local  in_BasePath="$2"

	local  full_path
	local  str

	LeftOfStr_func "$in_RelativePath" "/" ; str="$g_ReturnValue"  #// if full path, str=""
	if [ "$str" == "" ]; then
		g_ReturnValue="$in_RelativePath"
	elif [ "$str" == "~" ]; then
		StringClass.substring_method  "$in_RelativePath"  1
		g_ReturnValue="$HOME$g_ReturnValue"
	else
		if [ "$in_BasePath" == "" ];then  in_BasePath="$PWD"  ;fi

		full_path="$in_BasePath/$in_RelativePath"

		while true; do   #//  "*/../" -> ""
			echo  "$full_path" | grep  "[^/]*/\.\./" > /dev/null  || break
			full_path=$( echo "$full_path" | sed -e "s%[^/]*/\.\./%%" )
		done ; done_func $?

		while true; do   #//  "/*/.." -> ""
			echo  "$full_path" | grep  "[^/]*/[^/]*/\.\." > /dev/null  || break
			full_path=$( echo "$full_path" | sed -e "s%/[^/]*/\.\.$%%" )
		done ; done_func $?

		while true; do  #//  "/./" -> "/"
			echo  "$full_path" | grep  "/\./" > /dev/null  || break
			StringClass.replace_method  "$full_path"  "/./"  "/" ; full_path="$g_ReturnValue"
		done ; done_func $?

		while true; do  #//  "/." -> ""
			StringClass.right_method  "$full_path"  2
			if [ "$g_ReturnValue" != "/." ];then  break  ;fi
			StringClass.replace_method  "$full_path"  "/./"  "/" ; full_path="$g_ReturnValue"
			full_path=$( echo "$full_path" | sed -e "s%/\.$%%" )
		done ; done_func $?

		g_ReturnValue="$full_path"
	fi
}


#*********************************************************************
# Function: GetParentFullPath_func
#*********************************************************************
function  GetParentFullPath_func()
{
	local  in_Path="$1"
	CheckArgCount_func  1 "$@"

	local  str

	LeftOfStr_func "$in_Path" "/" ; str="$g_ReturnValue"  #// if abs path, str=""
	if [ "$str" != "" ]; then
		GetFullPath_func "$in_Path" ; in_Path="$g_ReturnValue"
	fi

	if [ x"$in_Path" == x"/"  -o  x"$in_Path" == x"" ]; then
		g_ReturnValue="$in_Path"
	else
		RightOfLastStr_func "$in_Path" "/"  #// if last char is "/", str=""
		if [ "$g_ReturnValue" == "" ]; then
			LeftOfLastStr_func "$in_Path" "/" ; in_Path="$g_ReturnValue"
		fi
		LeftOfLastStr_func  "$in_Path"  "/" ; in_Path="$g_ReturnValue"  #// parent folder
		if [ "$in_Path" == "" ];then  in_Path="/"  ;fi
		g_ReturnValue="$in_Path"
	fi
}


#*********************************************************************
# Function: TestOfAddSystemPathVariable_func
#*********************************************************************
function  TestOfAddSystemPathVariable_func()
{
	echo  "AddSystemPathVariable_func"
	AddSystemPathVariable_func  "/c/test"
	if ! HasInSystemPathVariable_func  "/c/test"; then  Error_func  ;fi

	echo  "RemoveSystemPathVariable_func"
	RemoveSystemPathVariable_func  "/c/test"
	if HasInSystemPathVariable_func  "/c/test"; then  Error_func  ;fi

#//	AddSystemPathVariable_func  "%windir%/test"  #// Not supported
}


#*********************************************************************
# Function: AddSystemPathVariable_func
#*********************************************************************
function  AddSystemPathVariable_func()
{
	local  new_folder_path="$1"
	local  new_folder_path_for_Windows=$( cygpath --windows "${new_folder_path}" )
	local  new_folder_path_for_Linux=$( cygpath --unix "${new_folder_path}" )

	if ! HasInSystemPathVariable_func  "${new_folder_path}"; then

		export  PATH="${new_folder_path_for_Linux}:${PATH}"
		if IsWindows_func; then
			local  exit_code=$( powershell -NoProfile -ExecutionPolicy unrestricted -Command "
				Set-Variable -Name process -Value ( Start-Process PowerShell.exe -Verb runas \"

					Write-Host  'Overwrite ' -NoNewLine
					Write-Host  'Path' -ForegroundColor Red -NoNewLine
					Write-Host  ' system environment variable'
					Write-Host  'Press Enter key to continue ...' -NoNewLine
					Read-Host

					[Microsoft.Win32.Registry]::SetValue(
						'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
						'Path',
						'${new_folder_path_for_Windows};' +
							(Get-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
							).GetValue('Path', '', 'DoNotExpandEnvironmentNames'),
						[Microsoft.Win32.RegistryValueKind]::ExpandString)
					Write-Host  'Done.'
					Start-Sleep -s 1
				\" -PassThru)
				if (Test-Path variable:process) {
					do {
						Start-Sleep -Milliseconds 500
					} until ((Get-Variable -Name process -ValueOnly).HasExited)
					((Get-Variable -Name process -ValueOnly).ExitCode)
				} else {
					1  #// return an error
				}" )
			if [ "${exit_code}" != "0" ]; then
				return  ${exit_code}
			fi
		fi
	fi
}


#*********************************************************************
# Function: AddUserPathVariable_func
#*********************************************************************
function  AddUserPathVariable_func()
{
Error_func  "not tested"
	local  new_folder_path="$1"
	new_folder_path_for_Windows=$( cygpath --windows "${new_folder_path}" )
	new_folder_path_for_Linux=$( cygpath --unix "${new_folder_path}" )

	if ! StringsHasTheString_func  "${PATH}"  "${new_folder_path_for_Linux}"  ":"; then

		export  PATH="${new_folder_path_for_Linux}:${PATH}"
		if IsWindows_func; then
			local  command="[Environment]::SetEnvironmentVariable('Path','C:\New;'+\$env:Path,"  #// +\\\$env:Path
			command="${command}[System.EnvironmentVariableTarget]::Machine)"

			powershell -Command "[Microsoft.Win32.Registry]::SetValue( 'HKEY_CURRENT_USER\Environment',
				'Path2',
				'C:\Test1;' + (Get-Item -Path 'HKCU:\Environment').GetValue('Path','','DoNotExpandEnvironmentNames'),
				[Microsoft.Win32.RegistryValueKind]::ExpandString)"

		fi
	fi
}


#*********************************************************************
# Function: RemoveSystemPathVariable_func
#*********************************************************************
function  RemoveSystemPathVariable_func()
{
	local  removing_folder_path="$1"
	local  removing_folder_path_for_Windows=$( cygpath --windows "${removing_folder_path}" )
	local  removing_folder_path_for_Linux=$( cygpath --unix "${removing_folder_path}" )

	if HasInSystemPathVariable_func  "${removing_folder_path}"; then

		CutAPartOfStringsAtTheString_func  "${PATH}"  "${removing_folder_path_for_Linux}"  ":"
		export  PATH="${g_ReturnValue}"

		if IsWindows_func; then
			local  current_path=$( powershell -Command "
				(Get-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
				).GetValue('Path', '', 'DoNotExpandEnvironmentNames')" )

			CutAPartOfStringsAtTheString_func  "${current_path}"  "${removing_folder_path_for_Windows}"  ";"
			local  new_path="${g_ReturnValue}"

			local  exit_code=$( powershell -NoProfile -ExecutionPolicy unrestricted -Command "
				Set-Variable -Name process -Value ( Start-Process PowerShell.exe -Verb runas \"

					Write-Host  'Overwrite ' -NoNewLine
					Write-Host  'Path' -ForegroundColor Red -NoNewLine
					Write-Host  ' system environment variable'
					Write-Host  'Press Enter key to continue ...' -NoNewLine
					Read-Host

					[Microsoft.Win32.Registry]::SetValue(
						'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
						'Path',
						'${new_path}',
						[Microsoft.Win32.RegistryValueKind]::ExpandString)
					Write-Host  'Done.'
					Start-Sleep -s 1
				\" -PassThru)
				if (Test-Path variable:process) {
					do {
						Start-Sleep -Milliseconds 500
					} until ((Get-Variable -Name process -ValueOnly).HasExited)
					((Get-Variable -Name process -ValueOnly).ExitCode)
				} else {
					1  #// return an error
				}" )
			if [ "${exit_code}" != "0" ]; then
				return  ${exit_code}
			fi
		fi
	fi
}


#*********************************************************************
# Function: HasInSystemPathVariable_func
#*********************************************************************
function  HasInSystemPathVariable_func()
{
	local  folder_path="$1"
	local  folder_path_for_Windows=$( cygpath --windows "${folder_path}" )
	local  is_registered="true"
	if IsWindows_func; then

		local  current_path=$( powershell -Command "
			(Get-Item -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
			).GetValue('Path', '', 'DoNotExpandEnvironmentNames')" )

		if ! StringsHasTheString_func  "${current_path}"  "${folder_path_for_Windows}"  ";"; then
			is_registered="false"
		fi
	else
		Error_func  "not supported"
	fi
	if [ "${is_registered}" == "true" ]; then
		return ${True}
	else
		return ${False}
	fi
}


#*********************************************************************
# Function: TestOfStringsHasTheString_func
#*********************************************************************
function  TestOfStringsHasTheString_func()
{
	if ! StringsHasTheString_func  "Aa;B b;Cc"  "Aa"  ";"  ;then  Error_func;  fi
	if ! StringsHasTheString_func  "Aa;B b;Cc"  "B b" ";"  ;then  Error_func;  fi
	if ! StringsHasTheString_func  "Aa;B b;Cc"  "Cc"  ";"  ;then  Error_func;  fi
	if   StringsHasTheString_func  "Aa;B b;Cc"  "xx"  ";"  ;then  Error_func;  fi
	if   StringsHasTheString_func  "Aa;B b;Cc"  "AA"  ";"  ;then  Error_func;  fi
	if ! StringsHasTheString_func  "Aa;B b;Cc"  ""    ";"  ;then  Error_func;  fi

	if ! StringsHasTheString_func  "Aa:B b:Cc"  "Aa"  ":"  ;then  Error_func;  fi
	if ! StringsHasTheString_func  "Aa:B b:Cc"  "B b" ":"  ;then  Error_func;  fi
	if ! StringsHasTheString_func  "Aa:B b:Cc"  "Cc"  ":"  ;then  Error_func;  fi
	if   StringsHasTheString_func  "Aa:B b:Cc"  "Ax"  ":"  ;then  Error_func;  fi

	if ! StringsHasTheString_func  "Aa"  "Aa"  ";"  ;then  Error_func;  fi
	if   StringsHasTheString_func  "Aa"  "xx"  ";"  ;then  Error_func;  fi
}


#*********************************************************************
# Function: StringsHasTheString_func
#
# Arguments:
#    in_WholeString - $1
#    in_TheString   - $2
#    in_Separator   - $3
#
# Return Value:
#    $? - 0: exists, 1: not exists
#*********************************************************************
function  StringsHasTheString_func()
{
	local  in_WholeString="$1"
	local  in_TheString="$2"
	local  in_Separator="$3"

	if [ "${in_TheString}" == "" ]; then
		return  0  #// exists
	else
		local  is_matched="false"
		local  oldIFS="$IFS"
		IFS="${in_Separator}"

		for  item  in ${in_WholeString[@]}; do  #// Splited by IFS
			if [ "${item}" == "${in_TheString}" ]; then
				is_matched="true"
			fi
		done
		IFS="$oldIFS"
		local  return_value=1  #// not exists
		if [ "$is_matched" == "true" ];then
			return_value=0  #// exists
		fi
		return  ${return_value}
	fi
}


#*********************************************************************
# Function: TestOfCutAPartOfStringsAtTheString_func
#*********************************************************************
function  TestOfCutAPartOfStringsAtTheString_func()
{
	CutAPartOfStringsAtTheString_func  "Aa;B b;Cc"  "Aa"  ";"
	if [ "${g_ReturnValue}" != "B b;Cc" ]; then  Error_func;  fi

	CutAPartOfStringsAtTheString_func  "Aa;B b;Cc"  "B b"  ";"
	if [ "${g_ReturnValue}" != "Aa;Cc" ]; then  Error_func;  fi

	CutAPartOfStringsAtTheString_func  "Aa;B b;Cc"  "Cc"  ";"
	if [ "${g_ReturnValue}" != "Aa;B b" ]; then  Error_func;  fi

	CutAPartOfStringsAtTheString_func  "Aa;B b;Cc"  "xx"  ";"
	if [ "${g_ReturnValue}" != "Aa;B b;Cc" ]; then  Error_func;  fi

	CutAPartOfStringsAtTheString_func  "Aa;B b;Cc"  "B"  ";"
	if [ "${g_ReturnValue}" != "Aa;B b;Cc" ]; then  Error_func;  fi

	CutAPartOfStringsAtTheString_func  "Aa"  "Aa"  ";"
	if [ "${g_ReturnValue}" != "" ]; then  Error_func;  fi

	CutAPartOfStringsAtTheString_func  "Aa:B b:Cc"  "Aa"  ":"
	if [ "${g_ReturnValue}" != "B b:Cc" ]; then  Error_func;  fi
}


#*********************************************************************
# Function: CutAPartOfStringsAtTheString_func
#*********************************************************************
function  CutAPartOfStringsAtTheString_func()
{
	local  in_WholeString="$1"
	local  in_TheString="$2"
	local  in_Separator="$3"

	if [ "${in_TheString}" == "" ]; then
		g_ReturnValue="${in_WholeString}"
	else
		g_ReturnValue=""
		local  oldIFS="$IFS"
		IFS="${in_Separator}"

		for  item  in ${in_WholeString[@]}; do  #// Splited by IFS
			if [ "${item}" != "${in_TheString}" ]; then
				if [ "${g_ReturnValue}" == "" ]; then
					g_ReturnValue="${item}"
				else
					g_ReturnValue="${g_ReturnValue}${in_Separator}${item}"
				fi
			fi
		done
		IFS="$oldIFS"
	fi
}


#*********************************************************************
# Function: LeftOfStr_func
#    Returns the substring to the left of the specified keyword
#
# Arguments:
#    in_String - in_String
#    in_Key    - in_BasePath
#
# Return Value:
#    g_ReturnValue - Full path
#*********************************************************************
function  LeftOfStr_func()
{
	local  in_String="$1"
	local  in_Key="$2"

	StringClass.replace_method  "$in_Key"         '\'  '\\'
	StringClass.replace_method  "$g_ReturnValue"  '*'  '\*'

	g_ReturnValue="${in_String%%$g_ReturnValue*}"
}


#*********************************************************************
# Function: LeftOfLastStr_func
#*********************************************************************
function  LeftOfLastStr_func()
{
	local  in_String="$1"
	local  in_Key="$2"
	CheckArgCount_func  2 "$@"

	StringClass.replace_method  "$in_Key"         '\'  '\\'
	StringClass.replace_method  "$g_ReturnValue"  '*'  '\*'

	g_ReturnValue="${in_String%$g_ReturnValue*}"
}


#*********************************************************************
# Function: RightOfStr_func
#*********************************************************************
function  RightOfStr_func()
{
	local  in_String="$1"
	local  in_Key="$2"
	CheckArgCount_func  2 "$@"

	StringClass.replace_method  "$in_Key"         '\'  '\\'
	StringClass.replace_method  "$g_ReturnValue"  '*'  '\*'

	g_ReturnValue="${in_String#*$g_ReturnValue*}"
}


#*********************************************************************
# Function: RightOfLastStr_func
#*********************************************************************
function  RightOfLastStr_func()
{
	local  in_String="$1"
	local  in_Key="$2"
	CheckArgCount_func  2 "$@"

	StringClass.replace_method  "$in_Key"         '\'  '\\'
	StringClass.replace_method  "$g_ReturnValue"  '*'  '\*'

	g_ReturnValue="${in_String##*$g_ReturnValue}"
}


#*********************************************************************
# Class: ErrClass
#*********************************************************************

#********************************************************************
# Method: ErrClass.raiseOverwrite_method
#    Overwrite the raising error object
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  ErrClass.raiseOverwrite_method()
{
	local  message ; ErrClass.getErrStr_method  "$@" ; message="$g_ReturnValue"
	local  exit_status="$g_ExitStatus"

	if [ "$message" != "" ];then
		g_Err_Desc="$message"
	fi

	if [ "$exit_status" == "0" ];then
		exit_status=1
	fi

	g_Err_IsOverwrite=1
	return  $exit_status
}


 
#********************************************************************
# Method: ErrClass.clear_method
#    Clears error status
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  ErrClass.clear_method()
{
	g_ExitStatus=0
	g_Err_Desc=""
	g_Err_Desc1st=""
	g_Err_LineNo="???"
	g_PipeStatus=""
}


 
#********************************************************************
# Method: ErrClass.getErrStr_method
#    Returns the error message
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  ErrClass.getErrStr_method()
{
	local  Message="$@"

	if [ "$Message" != "" ]; then
		if [ "${Message%%<ERROR *}" == "" ]; then
			g_ReturnValue="$Message"
		else
			StringClass.replace_method  "$Message"  "&"  "&amp;"
			StringClass.replace_method  "$g_ReturnValue"  "<"  "&lt;"
			StringClass.replace_method  "$g_ReturnValue"  "\""  "&quot;"
			g_ReturnValue="<ERROR msg=\"$g_ReturnValue\"/>"
		fi
	else
		g_ReturnValue=""
	fi
}


 
#********************************************************************
# Method: ErrClass.getCallTree_method
#    Returns the call tree text
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  ErrClass.getCallTree_method()
{
	local  LineNo="$1"
	local  TopIndex="$2"
	local  IsAbleLastCut="$3"
	local  indent=" "
	local  s

	if [ "${LANG}" == "ja_JP.UTF-8" ]; then
		s="コールツリー："
	else
		s="Call tree:"
	fi
	i=$(( ${#FUNCNAME[@]} - 1 ))
	s="$s${LF}""(global) ${BASH_SOURCE[$i]}:${BASH_LINENO[$i-1]}"
	for(( i=${#FUNCNAME[@]} - 2; i > $TopIndex; i-- ));do
		s="$s${LF}${indent}${FUNCNAME[$i]}() ${BASH_SOURCE[$i]}:${BASH_LINENO[$i-1]}"
		indent="${indent} "
	done ; done_func $?

	case  "${FUNCNAME[$TopIndex]}"  in
		"Error_func" | "DebugTrap_func" ) ;;
		*)  IsAbleLastCut=0 ;;
	esac
	if [ "$IsAbleLastCut" != "1" ];then
		if [ "$g_DebugTrapFunc" == "EchoOnTrap_func" ];then
			s="$s${LF}${indent}${FUNCNAME[$TopIndex]}() ${BASH_SOURCE[$TopIndex]}:$LineNo ?(->EchoOn_func)"
		elif [ "$g_DebugTrapFunc" == "EchoNextTrap_func" ];then
			s="$s${LF}${indent}${FUNCNAME[$TopIndex]}() ${BASH_SOURCE[$TopIndex]}:$LineNo ?(->EchoNext_func)"
		else
			s="$s${LF}${indent}${FUNCNAME[$TopIndex]}() ${BASH_SOURCE[$TopIndex]}:$LineNo"
		fi
	fi
	g_ReturnValue="$s"
}


#*********************************************************************
# Class: StringClass
#*********************************************************************

#*********************************************************************
# Method: StringClass.replace_method
#*********************************************************************
function  StringClass.replace_method()
{
	local  string="$1"
	local  from="$2"

	StringEscapeUtilsClass.escapeBashReplace_method  "$from"
	g_ReturnValue="${string//$g_ReturnValue/$3}"
}


#*********************************************************************
# Method: StringClass.right_method
#*********************************************************************
function  StringClass.right_method()
{
  local  in_String="$1"
  local  in_Length="$2"

  g_ReturnValue="${in_String:$(( ${#in_String} - $in_Length ))}"
}


#*********************************************************************
# Method: StringClass.indexOf_method
#*********************************************************************
function  StringClass.indexOf_method()
{
	local  self="$1"
	local  in_Keyword="$2"
	local  in_StartIndex="$3"

	if [ "$in_StartIndex" == "" ];then  in_StartIndex=0  ;fi
	if [ "$in_StartIndex" -le "0" ];then  #// -le:"<="
		part="${self%%$in_Keyword*}"
		if [ "$part" == "$self" ];then
			g_ReturnValue=-1
		else
			g_ReturnValue=$(( ${#part} ))
		fi
	else
		self="${self:$in_StartIndex}"
		part="${self%%$in_Keyword*}"
		if [ "$part" == "$self" ];then
			g_ReturnValue=-1
		else
			g_ReturnValue=$(( ${#part} + $in_StartIndex ))
		fi
	fi
}


#*********************************************************************
# Class: StringEscapeUtilsClass
#*********************************************************************

#*********************************************************************
# Method: StringEscapeUtilsClass.escapeGrep_method
#*********************************************************************
function  StringEscapeUtilsClass.escapeGrep_method()
{
	local  string="$1"
		string="${string//\\/\\\\}"
		string="${string//-/\-}"
		string="${string//./\.}"
		string="${string//$/\\$}"
		string="${string//^/\^}"
		string="${string//{/\{}"
		string="${string//\}/\}}"
		string="${string//[/\[}"
		string="${string//]/\]}"
		string="${string//\*/\*}"
		string="${string//+/\+}"
	g_ReturnValue="${string//\?/\?}"
}


#*********************************************************************
# Method: StringEscapeUtilsClass.escapeBashReplace_method
#*********************************************************************
function  StringEscapeUtilsClass.escapeBashReplace_method()
{
	local  string="$1"
		string="${string//\\/\\\\}"
		string="${string//\}/\}}"
		string="${string//\(/\\(}"
		string="${string//\)/\\)}"
		string="${string//\*/\\*}"
		string="${string//\?/\\?}"
	g_ReturnValue="${string//\//\\/}"
}


#********************************************************************
# Function: Exit_func
#    Exit the running shell script
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  Exit_func()
{
	g_DebugTrapFunc=""
	trap ':' EXIT
	exit $ret
}


 
#********************************************************************
# Function: DebugTrap_func
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  DebugTrap_func()
{
	if [ "$g_DebugTrapFunc" == "" ];then
		shift  2
		g_PipeStatus=( "$@" )
	else
		$g_DebugTrapFunc  "$@"
	fi
}


#********************************************************************
# Function: debugger
#    Starts step running
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  de()
{
	debugger
}

function  debugger()
{
	g_DebugTrapFunc="StepRunning_func"

	trap 'DebugTrap_func  "$LINENO"  "$BASH_COMMAND"  "${PIPESTATUS[@]}"
		#// resume ${PIPESTATUS[@]}
		case "${#g_PipeStatus[@]}" in
			"2")
				return ${g_PipeStatus[0]} | true;;
			"3")
				return ${g_PipeStatus[0]} | return ${g_PipeStatus[1]} | true;;
		esac' DEBUG
}

function  StepRunning_func()
{
	local  LineNo__="$1"
	local  Command__="$2"
	shift  2
	g_PipeStatus=( "$@" )

	local  key__
	local  a1__

	if [ "$step_running_guided" == "" ]; then
		ErrClass.getCallTree_method  "$LINENO"  2  1
		echo  "$g_ReturnValue"  >&2
		echo  "--- デバッガ情報 -------------------------"  >&2
		echo  "ステップ実行 … Enter キーを押してください"  >&2
		echo  "変数の値を表示 … 変数名を入力"              >&2
		echo  "------------------------------------------"  >&2
	fi

	echo  "${FUNCNAME[2]}() ${BASH_SOURCE[2]}:${BASH_LINENO[1]}"  >&2
	key__="goto_in_while"
	while [ "$key__" != "" ]; do
		read -p "$LineNo__: $Command__ " key__  #// break at the line

		#// inspect variable's value
		if [ "$key__" != "" ]; then

			case "$key__" in
			 "LineNo__" | "Command__" | "key__" | "a1__" )
				echo  "変数 $key__ の値の表示はサポートしていません。";;

			 *)
				CheckOutParamIsConflictToLocal_func  key__  

				key__=${key__/$/}  #// cut first $, if exists
				es  $key__  #// call es function
				;;
			esac
		fi
	done ; done_func $?

	step_running_guided=1
}


#********************************************************************
# Function: Escape_JSON_File_func
#********************************************************************
function  Escape_JSON_File_func()
{
	local  input_file_path="$1"
	local  output_file_path="$2"
	if [ "${output_file_path}" == "" ]; then
		output_file_path="/dev/stdout"
	fi
	GetFullPath_func  "${input_file_path}"  "${g_StartInPath}"
		input_file_path="${g_ReturnValue}"
	GetFullPath_func  "${output_file_path}"  "${g_StartInPath}"
		output_file_path="${g_ReturnValue}"

	EscapeJSON_func  "$( cat "${input_file_path}" )"  >  "${output_file_path}"
}


#********************************************************************
# Function: EscapeJSON_func
#********************************************************************
function  EscapeJSON_func()
{
	local  a_JSON_string="$1"
	local  string="${a_JSON_string}"

	string="$( echo "${string}"  |  sed -r "s/^[[:blank:]]+//" )"  #// Remove indents
	string="$( echo "${string}"  |  tr -d "\n" )"  #// To single line. CR+LF is not supported
	string="$( echo "${string}"  |  sed -e "s/\\\\/\\\\\\\\/g" )"  #// Escape back slashes
	string="$( echo "${string}"  |  sed -e "s/\"/\\\\\\\"/g" )"  #// Escape double quotations
	string="$( echo "${string}"  |  sed -e "s/\\t/\\\\t/g" )"  #// Escape tabs
	echo "${string}"
}


#********************************************************************
# Function: Unescape_JSON_File_func
#********************************************************************
function  Unescape_JSON_File_func()
{
	local  input_file_path="$1"
	local  output_file_path="$2"
	if [ "${output_file_path}" == "" ]; then
		output_file_path="/dev/stdout"
	fi
	GetFullPath_func  "${input_file_path}"  "${g_StartInPath}"
		input_file_path="${g_ReturnValue}"
	GetFullPath_func  "${output_file_path}"  "${g_StartInPath}"
		output_file_path="${g_ReturnValue}"

	UnescapeJSON_func  "$( cat "${input_file_path}" )"  >  "${output_file_path}"
}


#********************************************************************
# Function: UnescapeJSON_func
#********************************************************************
function  UnescapeJSON_func()
{
	local  escaped_JSON_string="$1"
	local  string="${escaped_JSON_string}"

	string=$( echo "${string}"  |  sed -e "s/\\\\t/\\t/g" )  #// Unescape tabs
	string=$( echo "${string}"  |  sed -e "s/\\\\\\\"/\"/g" )  #// Unescape double quotations
	string=$( echo "${string}"  |  sed -e "s/\\\\\\\\/\\\\/g" )  #// Unescape back slashes
	string=$( echo "${string}"  |  python -c "import json as j;print j.dumps(j.loads(raw_input()),indent=4,separators=(',',': '))" )
	echo "${string}"
}


#********************************************************************
# Function: ToLF_func
#    convert from CR+LF(stdin) to LF(stdout)
#
# Example:
#    ToLF_func  < "${input_path}"  > "${output_path}"
#********************************************************************
function  ToLF_func()
{
	tr -d \\r
}


#********************************************************************
# Function: parseJSON_func
#    Parse JSON
#
# Arguments:
#    None
#
# Return Value:
#    None
#********************************************************************
function  parseJSON_func()
{
	ToLF_func  |  PARSRJ_SH_func  $*
}


######################################################################
#
# PARSRJ.SH
#   A JSON Parser Which Convert Into "JSONPath-value"
#
# === What is "JSONPath-value" Formatted Text? ===
# 1. Format
#    <JSONPath_string#1> + <0x20> + <value_at_that_path#1>
#    <JSONPath_string#2> + <0x20> + <value_at_that_path#2>
#    <JSONPath_string#3> + <0x20> + <value_at_that_path#3>
#             :              :              :
#
# === This Command will Do Like the Following Conversion ===
# 1. Input Text (JSON)
#    {"hoge":111,
#     "foo" :["2\n2",
#             {"bar" :"3 3",
#              "fizz":{"bazz":444}
#             },
#             "\u5555"
#            ]
#    }
# 2. Output Text This Command Converts Into
#    $.hoge 111
#    $.foo[0] 2\n2
#    $.foo[1].bar 3 3
#    $.foo[1].fizz.bazz 444
#    $.foo[2] \u5555
#
# === Usage ===
# Usage   : parsrj.sh [options] [JSON_file]
# Options : -t      Quotes a value at converting when the value is a string
#         : -e      Escapes the following characters in impolite JSON key fields
#                   (" ",<0x09>,".","[","]")
#         : --xpath Use XPath instead of JSONPath when converting
#                   It is equivalent to using the following options
#                   (-rt -kd/ -lp'[' -ls']' -fn1 -li)
#          <<The following options are to arrange the JSONPath format>>
#           -sk<s>  Replaces <0x20> chrs in key string with <s>
#           -rt<s>  Replaces the root symbol "$" of JSONPath with <s>
#           -kd<s>  Replaces the delimiter "." of JSONPath hierarchy with <s>
#           -lp<s>  Replaces the prefix of array character "[" with <s>
#           -ls<s>  Replaces the suffix of array character "]" with <s>
#           -fn<n>  Redefines the start number of arrays with <n>
#           -li     Inserts another JSONPath line which has no value
#
#
# Written by Shell-Shoccar Japan (@shellshoccarjpn) on 2017-07-18
#
# This is a public-domain software (CC0). It means that all of the
# people can use this for any purposes with no restrictions at all.
# By the way, We are fed up with the side effects which are brought
# about by the major licenses.
#
######################################################################


######################################################################
# Initial configuration
######################################################################


# === Initialize shell environment ===================================
export LC_ALL=C
type command >/dev/null 2>&1 && type getconf >/dev/null 2>&1 &&
export PATH="$(command -p getconf PATH)${PATH+:}${PATH-}"
export UNIX_STD=2003  # to make HP-UX conform to POSIX

# === Usage printing function ========================================
print_usage_and_exit () {
  cat <<USAGE 1>&2
Usage   : ${0##*/} [options] [JSON_file]
Options : -t      Quotes a value at converting when the value is a string
          -e      Escapes the following characters in impolite JSON key fields
                  (" ",".","[","]")
          --xpath Use XPath instead of JSONPath when converting
                  It is equivalent to using the following options
                  (-rt -kd/ -lp'[' -ls']' -fn1 -li)
         <<The following options are to arrange the JSONPath format>>
          -sk<s>  Replaces <0x20> chrs in key string with <s>
          -rt<s>  Replaces the root symbol "$" of JSONPath with <s>
          -kd<s>  Replaces the delimiter "." of JSONPath hierarchy with <s>
          -lp<s>  Replaces the prefix of array character "[" with <s>
          -ls<s>  Replaces the suffix of array character "]" with <s>
          -fn<n>  Redefines the start number of arrays with <n>
          -li     Inserts another JSONPath line which has no value
Version : 2017-07-18 02:39:39 JST
          (POSIX Bourne Shell/POSIX commands)
USAGE
  exit 1
}


######################################################################
# Parse Arguments
######################################################################

function  PARSRJ_SH_func()
{

# === Print the usage when "--help" is put ===========================
case "$# ${1:-}" in
  '1 -h'|'1 --help'|'1 --version') print_usage_and_exit;;
esac

# === Get the options and the filepath ===============================
# --- initialize option parameters -----------------------------------
file=''
sk='_'
rt='$'
kd='.'
lp='['
ls=']'
fn=0
unoptli='#'
unopte='#'
optt=''
unoptt='#'
#
# --- get them -------------------------------------------------------
for arg in ${1+"$@"}; do
  if   [ "_${arg#-sk}" != "_$arg"    ] && [ -z "$file" ] ; then
    sk=${arg#-sk}
  elif [ "_${arg#-rt}" != "_$arg"    ] && [ -z "$file" ] ; then
    rt=${arg#-rt}
  elif [ "_${arg#-kd}" != "_$arg"    ] && [ -z "$file" ] ; then
    kd=${arg#-kd}
  elif [ "_${arg#-lp}" != "_$arg"    ] && [ -z "$file" ] ; then
    lp=${arg#-lp}
  elif [ "_${arg#-ls}" != "_$arg"    ] && [ -z "$file" ] ; then
    ls=${arg#-ls}
  elif [ "_${arg#-fn}" != "_$arg"    ] && [ -z "$file" ] &&
    printf '%s\n' "$arg" | grep -Eq '^-fn[0-9]+$'        ; then
    fn=${arg#-fn}
    fn=$((fn+0))
  elif [ "_$arg"        = '_-li'     ] && [ -z "$file" ] ; then
    unoptli=''
  elif [ "_$arg"        = '_--xpath' ] && [ -z "$file" ] ; then
    unoptli=''; rt=''; kd='/'; lp='['; ls=']'; fn=1
  elif [ "_$arg" = '_-t'             ] && [ -z "$file" ] ; then
    unoptt=''; optt='#'
  elif [ "_$arg" = '_-e'             ] && [ -z "$file" ] ; then
    unopte=''
  elif ([ -f "$arg" ] || [ -c "$arg" ]) && [ -z "$file" ]; then
    file=$arg
  elif [ "_$arg"        = "_-"       ] && [ -z "$file" ] ; then
    file='-'
  else
    print_usage_and_exit
  fi
done

# === Validate the arguments =========================================
if   [ "_$file" = '_'                ] ||
     [ "_$file" = '_-'               ] ||
     [ "_$file" = '_/dev/stdin'      ] ||
     [ "_$file" = '_/dev/fd/0'       ] ||
     [ "_$file" = '_/proc/self/fd/0' ]  ; then
  file=''
elif [ -f "$file"                    ] ||
     [ -c "$file"                    ] ||
     [ -p "$file"                    ]  ; then
  [ -r "$file" ] || error_exit 1 'Cannot open the file: '"$file"
else
  print_usage_and_exit
fi
case "$file" in ''|-|/*|./*|../*) :;; *) file="./$file";; esac


######################################################################
# Prepare for the Main Routine
######################################################################

# === Define some chrs. to escape some special chrs. temporarily =====
HT=$( printf '\t'   )              # Means TAB
DQ=$( printf '\026' )              # Use to escape doublequotation temporarily
LFs=$(printf '\\\n_');LFs=${LFs%_} # Use as a "\n" in s-command of sed

# === Export the variables to use in the following last AWK script ===
export sk
export rt
export kd
export lp
export ls


######################################################################
# Main Routine (Convert and Generate)
######################################################################

# === Open the JSON data source ======================================== #
cat ${file:+"$file"}                                                     |
#                                                                        #
# === Escape DQs and put each string between DQs into a sigle line ===== #
tr -d '\n'  | # 1)convert each DQ to new "\n" instead of original "\n"s  |
tr '"' '\n' | #                                                          |
awk '         # 2)discriminate DQ as just a letter from DQ as a segment  #
BEGIN {                                                                  #
  OFS=""; ORS="";                                                        #
  while (getline line) {                                                 #
    len = length(line);                                                  #
    if        (substr(line,len)!="\\"               ) {                  #
      print line,"\n";                                                   #
    } else if (match(line,/^(\\\\)+$|[^\\](\\\\)+$/)) {                  #
      print line,"\n";                                                   #
    } else                                            {                  #
      print substr(line,1,len-1),"'$DQ'";                                #
    }                                                                    #
  }                                                                      #
}'                                                                       |
awk '         # 3)restore DQ to the head and tail of lines               #
BEGIN {       #   which have DQs at head and tail originally             #
  OFS=""; even=0;                                                        #
  while (getline line)                   {                               #
    if (even==0) {print      line     ;}                                 #
    else         {print "\"",line,"\"";}                                 #
    even=1-even;                                                         #
  }                                                                      #
}'                                                                       |
#                                                                        #
# === Insert "\n" into the head and the tail of the lines which are ==== #
#     not as just a value string                                         #
sed "/^[^\"]/s/\([][{}:,]\)/$LFs\1$LFs/g"                                |
#                                                                        #
# === Cut the unnecessary spaces and tabs and "\n"s ==================== #
sed 's/^[ '"$HT"']\{1,\}//'                                              |
sed 's/[ '"$HT"']\{1,\}$//'                                              |
grep -v '^[ '"$HT"']*$'                                                  |
#                                                                        #
# === Generate the JSONPath-value with referring the head of the ======= #
#     strings and thier order                                            #
awk '                                                                    #
BEGIN {                                                                  #
  # Load shell values which have option parameters                       #
  alt_spc_in_key=ENVIRON["sk"];                                          #
  root_symbol   =ENVIRON["rt"];                                          #
  key_delimit   =ENVIRON["kd"];                                          #
  list_prefix   =ENVIRON["lp"];                                          #
  list_suffix   =ENVIRON["ls"];                                          #
  # Initialize the data category stack                                   #
  datacat_stack[0]="";                                                   #
  delete datacat_stack[0]                                                #
  # Initialize the key name stack                                        #
  keyname_stack[0]="";                                                   #
  delete keyname_stack[0]                                                #
  # Set 0 as stack depth                                                 #
  stack_depth=0;                                                         #
  # Initialize the error assertion variable                              #
  _assert_exit=0;                                                        #
  # Define the character for escaping double-quotation (DQ) character    #
  DQ="'$DQ'";                                                            #
  # Set null as field,record sparator for the print function             #
  OFS="";                                                                #
  ORS="";                                                                #
  #                                                                      #
  # MAIN LOOP                                                            #
  while (getline line) {                                                 #
    # In "{"-line case                                                   #
    if        (line=="{") {                                              #
      if ((stack_depth==0)                   ||                          #
          (datacat_stack[stack_depth]=="l0") ||                          #
          (datacat_stack[stack_depth]=="l1") ||                          #
          (datacat_stack[stack_depth]=="h3")  ) {                        #
        stack_depth++;                                                   #
        datacat_stack[stack_depth]="h0";                                 #
        continue;                                                        #
      } else {                                                           #
        _assert_exit=1;                                                  #
        exit _assert_exit;                                               #
      }                                                                  #
    # In "}"-line case                                                   #
    } else if (line=="}") {                                              #
      if (stack_depth>0)                                       {         #
        s=datacat_stack[stack_depth];                                    #
        if (s=="h0" || s=="h4")                              {           #
          if (s=="h0") {print_path();}                                   #
          delete datacat_stack[stack_depth];                             #
          delete keyname_stack[stack_depth];                             #
          stack_depth--;                                                 #
          if (stack_depth>0)                               {             #
            if ((datacat_stack[stack_depth]=="l0") ||                    #
                (datacat_stack[stack_depth]=="l1")  )    {               #
              datacat_stack[stack_depth]="l2"                            #
            } else if (datacat_stack[stack_depth]=="h3") {               #
              datacat_stack[stack_depth]="h4"                            #
            }                                                            #
          }                                                              #
          continue;                                                      #
        } else                                               {           #
          _assert_exit=1;                                                #
          exit _assert_exit;                                             #
        }                                                                #
      } else                                                   {         #
        _assert_exit=1;                                                  #
        exit _assert_exit;                                               #
      }                                                                  #
    # In "["-line case                                                   #
    } else if (line=="[") {                                              #
      if ((stack_depth==0)                   ||                          #
          (datacat_stack[stack_depth]=="l0") ||                          #
          (datacat_stack[stack_depth]=="l1") ||                          #
          (datacat_stack[stack_depth]=="h3")   ) {                       #
        stack_depth++;                                                   #
        datacat_stack[stack_depth]="l0";                                 #
        keyname_stack[stack_depth]='"$fn"';                              #
        continue;                                                        #
      } else {                                                           #
        _assert_exit=1;                                                  #
        exit _assert_exit;                                               #
      }                                                                  #
    # In "]"-line case                                                   #
    } else if (line=="]") {                                              #
      if (stack_depth>0)                                         {       #
        s=datacat_stack[stack_depth];                                    #
        if (s=="l0" || s=="l2")                                {         #
          if (s=="l0") {print_path();}                                   #
          '"$unoptli"'if (s=="l2") {print_path();}                       #
          delete datacat_stack[stack_depth];                             #
          delete keyname_stack[stack_depth];                             #
          stack_depth--;                                                 #
          if (stack_depth>0)                               {             #
            if ((datacat_stack[stack_depth]=="l0") ||                    #
                (datacat_stack[stack_depth]=="l1")  )    {               #
              datacat_stack[stack_depth]="l2"                            #
            } else if (datacat_stack[stack_depth]=="h3") {               #
              datacat_stack[stack_depth]="h4"                            #
            }                                                            #
          }                                                              #
          continue;                                                      #
        } else                                                 {         #
          _assert_exit=1;                                                #
          exit _assert_exit;                                             #
        }                                                                #
      } else                                                     {       #
        _assert_exit=1;                                                  #
        exit _assert_exit;                                               #
      }                                                                  #
    # In ":"-line case                                                   #
    } else if (line==":") {                                              #
      if ((stack_depth>0)                   &&                           #
          (datacat_stack[stack_depth]=="h2") ) {                         #
        datacat_stack[stack_depth]="h3";                                 #
        continue;                                                        #
      } else {                                                           #
        _assert_exit=1;                                                  #
        exit _assert_exit;                                               #
      }                                                                  #
    # In ","-line case                                                   #
    } else if (line==",") {                                              #
      # 1)Confirm the datacat stack is not empty                         #
      if (stack_depth==0) {                                              #
        _assert_exit=1;                                                  #
        exit _assert_exit;                                               #
      }                                                                  #
      '"$unoptli"'# 1.5)Action in case which li option is enabled        #
      '"$unoptli"'if (substr(datacat_stack[stack_depth],1,1)=="l") {     #
      '"$unoptli"'  print_path();                                        #
      '"$unoptli"'}                                                      #
      # 2)Do someting according to the top of datacat stack              #
      # 2a)When "l2" (list-step2 : just after getting a value in list)   #
      if (datacat_stack[stack_depth]=="l2") {                            #
        datacat_stack[stack_depth]="l1";                                 #
        keyname_stack[stack_depth]++;                                    #
        continue;                                                        #
      # 2b)When "lh" (hash-step4 : just after getting a value in hash)   #
      } else if (datacat_stack[stack_depth]=="h4") {                     #
        datacat_stack[stack_depth]="h1";                                 #
        continue;                                                        #
      # 2c)Other cases (error)                                           #
      } else {                                                           #
        _assert_exit=1;                                                  #
        exit _assert_exit;                                               #
      }                                                                  #
    # In another line case                                               #
    } else                {                                              #
      # 1)Confirm the datacat stack is not empty                         #
      if (stack_depth==0) {                                              #
        _assert_exit=1;                                                  #
        exit _assert_exit;                                               #
      }                                                                  #
      # 2)Remove the head/tail DQs quoting a string when they exists     #
      # 3)Unescape the escaped DQs                                       #
      if (match(line,/^".*"$/)) {                                        #
        gsub(DQ,"\\\"",line);                                            #
        key=substr(line,2,length(line)-2);                               #
        '"$optt"'value=key;                                              #
        '"$unoptt"'value=line;                                           #
      } else                    {                                        #
        gsub(DQ,"\\\"",line);                                            #
        key=line;                                                        #
        value=line;                                                      #
      }                                                                  #
      '"$unopte"'gsub(/ / ,"\\u0020",key);                               #
      '"$unopte"'gsub(/\t/,"\\u0009",key);                               #
      '"$unopte"'gsub(/\./,"\\u002e",key);                               #
      '"$unopte"'gsub(/\[/,"\\u005b",key);                               #
      '"$unopte"'gsub(/\]/,"\\u005d",key);                               #
      # 4)Do someting according to the top of datacat stack              #
      # 4a)When "l0" (list-step0 : waiting for the 1st value)            #
      s=datacat_stack[stack_depth];                                      #
      if ((s=="l0") || (s=="l1")) {                                      #
        print_path_and_value(value);                                     #
        datacat_stack[stack_depth]="l2";                                 #
      # 4b)When "h0,1" (hash-step0,1 : waiting for the 1st or next key)  #
      } else if (s=="h0" || (s=="h1")) {                                 #
        gsub(/ /,alt_spc_in_key,key);                                    #
        keyname_stack[stack_depth]=key;                                  #
        datacat_stack[stack_depth]="h2";                                 #
      # 4c)When "h3" (hash-step3 : waiting for a value of hash)          #
      } else if (s=="h3") {                                              #
        print_path_and_value(value);                                     #
        datacat_stack[stack_depth]="h4";                                 #
      # 4d)Other cases (error)                                           #
      } else {                                                           #
        _assert_exit=1;                                                  #
        exit _assert_exit;                                               #
      }                                                                  #
    }                                                                    #
  }                                                                      #
}                                                                        #
END {                                                                    #
  # FINAL ROUTINE                                                        #
  if (_assert_exit) {                                                    #
    print "Invalid JSON format\n" | "cat 1>&2";                          #
    line1="keyname-stack:";                                              #
    line2="datacat-stack:";                                              #
    for (i=1;i<=stack_depth;i++) {                                       #
      line1=line1 sprintf("{%s}",keyname_stack[i]);                      #
      line2=line2 sprintf("{%s}",datacat_stack[i]);                      #
    }                                                                    #
    print line1, "\n", line2, "\n" | "cat 1>&2";                         #
  }                                                                      #
  exit _assert_exit;                                                     #
}                                                                        #
# The Functions printing JSONPath-value                                  #
function print_path( i) {                                                #
  print root_symbol;                                                     #
  for (i=1;i<=stack_depth;i++) {                                         #
    if (substr(datacat_stack[i],1,1)=="l") {                             #
      print list_prefix, keyname_stack[i], list_suffix;                  #
    } else {                                                             #
      print key_delimit, keyname_stack[i];                               #
    }                                                                    #
  }                                                                      #
  print "\n";                                                            #
}                                                                        #
function print_path_and_value(str ,i) {                                  #
  print root_symbol;                                                     #
  for (i=1;i<=stack_depth;i++) {                                         #
    if (substr(datacat_stack[i],1,1)=="l") {                             #
      print list_prefix, keyname_stack[i], list_suffix;                  #
    } else {                                                             #
      print key_delimit, keyname_stack[i];                               #
    }                                                                    #
  }                                                                      #
  print " ", str, "\n";                                                  #
}                                                                        #
'

}


#********************************************************************
# Function: CallMain_func
#    Calls "Main_func"
#
# Arguments:
#    $* at starting
#
# Return Value:
#    None
#********************************************************************
function  CallMain_func()
{
	cd  "${g_ThisScriptPath%/*}"  #// parent of "${g_ThisScriptPath}"

	trap 'set +x ; ErrTrap_func' EXIT  #// Enable the exit trap
	trap 'set +x ; ErrTrap_func $LINENO ;  break' ERR  #// In function, it is necessary to bash -E option
	trap 'DebugTrap_func  "$LINENO"  "$BASH_COMMAND"  "${PIPESTATUS[@]}"
		#// resume ${PIPESTATUS[@]}
		case "${#g_PipeStatus[@]}" in
			"2")
				return ${g_PipeStatus[0]} | true;;
			"3")
				return ${g_PipeStatus[0]} | return ${g_PipeStatus[1]} | true;;
		esac' DEBUG
	set +e


	Main_func  $*


	trap EXIT  #// Disable the exit trap
	if [ "${g_IsSourceCommand}" == "${True}" ]; then
		cd  "${g_StartInPath}"
	fi
}


#********************************************************************
# Variable: True
#********************************************************************
export  True=0  #// 0 is same as the specifiation of Linux bash "test" command


#********************************************************************
# Variable: False
#********************************************************************
export  False=1  #// Not 0 is same as the specifiation of Linux bash "test" command


#********************************************************************
# Variable: g_ThisScriptPath
#********************************************************************
export  g_StartInPath="$( pwd )"
export  g_ThisScriptRelativePath="${BASH_SOURCE}"
GetFullPath_func  "${g_ThisScriptRelativePath}"
g_ThisScriptPath="${g_ReturnValue}"
if [ "$0" == "${BASH_SOURCE}" ]; then
	export  g_IsSourceCommand="${False}"
else
	export  g_IsSourceCommand="${True}"
fi


#********************************************************************
# Variable: LF
#    Line feed
#********************************************************************
export  LF=$( echo_e_func "\nx" ); LF="${LF:0:1}"


#********************************************************************
# Variable: Tab
#********************************************************************
export  Tab=$( echo_e_func "\t" )


#********************************************************************
# Calling "CallMain_func"
#********************************************************************
CallMain_func  $*
