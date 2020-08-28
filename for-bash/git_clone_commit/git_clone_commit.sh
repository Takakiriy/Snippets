#!/bin/bash
#// Character Encoding: "WHITE SQUARE" U+25A1 is □.
set -eE
#// -eE option breaks execution, when an error was occurred.

#********************************************************************
#* File: check-out-commit.sh
#    Type "./check-out-commit.sh" in Windows git bash.
#    Type "chmod +x check-out-commit.sh" and "./check-out-commit.sh" in Linux bash.
#********************************************************************

#// Setting
#//==================================================================

g_DefaultRepositoryURL="https://github.com/Takakiriy/Snippets.git"

g_DefaultCommitListURL="https://github.com/Takakiriy/Snippets/commits/master"
#//==================================================================
PATH="${PATH}:/c/Program Files/Git/bin"


#********************************************************************
# Function: Main_func
#********************************************************************
function  Main_func()
{
	if [ "$1" == ""  -o  "$1" == "setup" ]; then
		SetUp_func
	elif [ "$1" == "clean"  -o  "$1" == "cleanup" ]; then
		CleanUp_func
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


	#// Input
	echo  ""
	ColorEcho_func  "Git check out a commit ...\n"  "Green"
	
	InputGitRepositoryURL_func  "Git repository URL"
	local  repository_URL="${g_ReturnValue}"

	GetLocalFolderName_func  "${repository_URL}"
	local  local_folder_name="${g_ReturnValue}"
	if [ "${repository_URL}" == "${g_DefaultRepositoryURL}" ]; then
		echo  ""

		echo  "Commit List: ${g_DefaultCommitListURL}"
	fi
	echo  "Enter only: newest master commit"

	read -p "Commit ID >"  commit_ID


	#// Git clone
	EchoNextCommand_func

	rm -rf  "${local_folder_name}"
	EchoNextCommand_func

	git clone  "${repository_URL}"
	if [ "${commit_ID}" != "" ]; then
		EchoNextCommand_func

		pushd  "${local_folder_name}"  > /dev/null
		EchoNextCommand_func

		git checkout  -b "temporary"  "${commit_ID}"
	fi
}


#********************************************************************
# Function: CleanUp_func
#********************************************************************
function  CleanUp_func()
{
	#// Skip
if false; then #// "Skipped"
echo "Skipped"  ;fi

	#// Input
	echo  ""
	ColorEcho_func  "Remove local folder ...\n"  "Green"
	
	InputGitRepositoryURL_func  "A folder name or git repository URL"
	local  repository_URL="${g_ReturnValue}"

	GetLocalFolderName_func  "${repository_URL}"
	local  local_folder_name="${g_ReturnValue}"


	#// Remove the folder
	EchoNextCommand_func

	rm -rf  "${local_folder_name}"
}


#********************************************************************
# Function: InputGitRepositoryURL_func
#********************************************************************
function  InputGitRepositoryURL_func()
{
	local  guide="$1"
	local  repository_URL
	local  default_input
	if [ "${guide}" == "A folder name or git repository URL" ]; then
		GetLocalFolderName_func  "${g_DefaultRepositoryURL}"
		local  local_folder_name="${g_ReturnValue}"
		default_input="${local_folder_name}"
	else
		default_input="${g_DefaultRepositoryURL}"
	fi
	echo  "Enter only: ${default_input}"

	read -p "${guide} >"  repository_URL
	if [ "${repository_URL}" == "" ]; then
		repository_URL="${g_DefaultRepositoryURL}"
	fi

	g_ReturnValue="${repository_URL}"
}


#********************************************************************
# Function: GetLocalFolderName_func
#********************************************************************
function  GetLocalFolderName_func()
{
	local  repository_URL="$1"

	local  local_folder_name="${repository_URL##*/}"
	local  extension="${local_folder_name##*.}"

	if [ "${extension}" == "git" ]; then
		local_folder_name="${local_folder_name%.*}"  #// Cut extension
	fi

	g_ReturnValue="${local_folder_name}"
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
# Function: IsWindows_func
#
# Example:
#    if IsWindows_func; then
#        echo  "in Windows"
#    else
#        echo  "in Linux or others"
#    fi
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
#    > ColorEcho_func  "Pass."  "Green"
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
			a1="${a1}下記コールツリーの最も下の関数が、\` \` を使って echo 出力を取得しているときは、取得しないようにすると、更にコール先の関数が表示されます。${LF}"
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
			ColorText_func  "$g_Err_Desc"  "Red" "Bold"
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


#********************************************************************
# Function: SafeFileUpdate_func
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
			full_path=`echo "$full_path" | sed -e "s%[^/]*/\.\./%%"`
		done ; done_func $?

		while true; do   #//  "/*/.." -> ""
			echo  "$full_path" | grep  "[^/]*/[^/]*/\.\." > /dev/null  || break
			full_path=`echo "$full_path" | sed -e "s%/[^/]*/\.\.$%%"`
		done ; done_func $?

		while true; do  #//  "/./" -> "/"
			echo  "$full_path" | grep  "/\./" > /dev/null  || break
			StringClass.replace_method  "$full_path"  "/./"  "/" ; full_path="$g_ReturnValue"
		done ; done_func $?

		while true; do  #//  "/." -> ""
			StringClass.right_method  "$full_path"  2
			if [ "$g_ReturnValue" != "/." ];then  break  ;fi
			StringClass.replace_method  "$full_path"  "/./"  "/" ; full_path="$g_ReturnValue"
			full_path=`echo "$full_path" | sed -e "s%/\.$%%"`
		done ; done_func $?

		g_ReturnValue="$full_path"
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
export  LF=`echo_e_func "\nx"`; LF="${LF:0:1}"


#********************************************************************
# Variable: Tab
#********************************************************************
export  Tab=`echo_e_func "\t"`


#********************************************************************
# Calling "CallMain_func"
#********************************************************************
CallMain_func  $*
