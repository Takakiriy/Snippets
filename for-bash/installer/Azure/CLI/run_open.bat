@echo off
PATH=C:\Program Files\Git\usr\bin;%PATH%
"C:\Program Files\Git\usr\bin\bash.exe"  scripts.sh  set-path
"C:\Program Files\Git\usr\bin\bash.exe" -c "source .s;  exec bash"
