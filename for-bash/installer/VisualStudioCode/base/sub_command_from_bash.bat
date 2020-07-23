@echo off
if "%~2" == "slash" (
	"%~1" /"%~3"
) else (
	"%~1" "%~2"
)
