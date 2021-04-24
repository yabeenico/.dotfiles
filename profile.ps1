# posh

Import-Module PSReadLine
Set-PSReadlineOption -EditMode Emacs
#Set-PSReadLineKeyHandler -Key ctrl+n -Function HistorySearchForward
#Set-PSReadLineKeyHandler -Key ctrl+p -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key ctrl+i -Function Complete

Set-PSReadlineOption -Colors @{
    "Operator"  = "$([char]0x1b)[95m"
    "Parameter" = "$([char]0x1b)[95m"
}


function prompt(){
    $uh = $env:USERNAME + "@" + $env:COMPUTERNAME
    $ph = (Get-Location).Path

    $Host.ui.RawUI.WindowTitle = $uh + ":" + $ph.Split('\')[-1]

    Write-Host -NoNewLine -ForegroundColor White "`r`n"
    Write-Host -NoNewLine -ForegroundColor Cyan  $uh
    Write-Host -NoNewLine -ForegroundColor White "/"
    Write-Host -NoNewLine -ForegroundColor Green $ph
    Write-Host -NoNewLine -ForegroundColor White "`r`n"
    return '> '
}

$ENV:Path="C:\Users\yabeenico\scoop\shims;"+$ENV:Path

Set-Alias s ls
Set-Alias l ls

