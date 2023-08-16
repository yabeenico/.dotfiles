mkdir ~/account/Documents/WindowsPowerShell
powershell.exe -Command 'Start-Process -Verb runas powershell.exe'
Set-ExecutionPolicy Unrestricted
iwr -useb get.scoop.sh | iex
scoop install sudo
