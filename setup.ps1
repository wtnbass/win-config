$kanagawaScheme = @{
    name = "Kanagawa"
    cursorColor = "#dcd7ba"
    selectionBackground = "#727169"
    background = "#1f1f28"
    foreground = "#dcd7ba"
    black = "#16161d"
    red = "#c34043"
    green = "#76946a"
    yellow = "#c0a36e"
    blue = "#7e9cd8"
    purple = "#957fb8"
    cyan = "#6a9589"
    white = "#bac2de"
    brightBlack = "#727169"
    brightRed = "#e82424"
    brightGreen = "#98bb6c"
    brightYellow = "#e6c384"
    brightBlue = "#7fb4ca"
    brightPurple = "#938aa9"
    brightCyan = "#7aa89f"
    brightWhite = "#dcd7ba"
}
$fontFace = "Bizin Gothic NF"

$ahk = @"
SendMode "Input"  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

F13 & b::Left
F13 & n::Down
F13 & p::Up
F13 & f::Right
F13 & d::Del
F13 & h::BS
F13 & e::End
F13 & a::Home
F13 & Space::
{
    Send "{vkF3sc029}"
}

~Escape::
{
    IME_SET(0)
}

*LAlt:: {
    Send "{Blind}{LAlt down}"
}

*LAlt up:: {
    Send "{Blind}{LAlt up}"
    if (A_PriorKey = "LAlt") {
        Send "{Blind}{vkE8}"
        IME_SET(0)
    }
}

*RAlt:: {
    Send "{Blind}{RAlt down}"
}

*RAlt up:: {
    Send "{Blind}{RAlt up}"
    if (A_PriorKey = "RAlt") {
        Send "{Blind}{vkE8}"
        IME_SET(1)
    }
}

; set IME (0 off/ 1 on) 
; IME_SET(mode) {
;     hwnd := WinGetID("A")
;     ime := DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr")
;     DllCall("SendMessage", "Ptr", ime, "UInt", 0x283, "Ptr", 0x006, "Ptr", mode)
; }
IME_SET(mode) {
    hwnd := WinGetID("A")
    SendMessage(0x283, 0x006, mode, DllCall("imm32\ImmGetDefaultIMEWnd", "Ptr", hwnd, "Ptr"))
}
"@

function Confirm ($message) {
  $answer = Read-Host "$message (Y/n)"
  return ($answer -eq "") -or ($answer -match '^[Yy]$')
}

function Change-Windows-Terminal-Setting {
    $pkg = Get-AppxPackage -Name Microsoft.WindowsTerminal
    $settingsPath = "$env:LOCALAPPDATA\Packages\$($pkg.PackageFamilyName)\LocalState\settings.json"
    $settingsJson = Get-Content $settingsPath | ConvertFrom-Json
    $settingsJson.schemes = @($kanagawaScheme)
    $settingsJson.profiles.defaults.colorScheme = "Kanagawa"
    $settingsJson.profiles.defaults.opacity = 80
    $settingsJson.profiles.defaults.useAcrylic = $false
    if (Test-Font-Installed) {
        $settingsJson.profiles.defaults.font.face = $fontFace
    }
    $settingsJson | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding utf8
}

function Test-Font-Installed {
    Add-Type -AssemblyName System.Drawing
    $installedFonts = New-Object System.Drawing.Text.InstalledFontCollection

    return $installedFonts.Families.Name -contains $fontFace
}

function Write-AHK-To-Startup {
    $startupFolder = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup")
    $ahkFile = Join-Path $startupFolder "keybinds.ahk"
    echo $ahk | Out-File $ahkFile -Encoding utf8
    if (Confirm "配置した AHK を実行しますか") {
        start $ahkFile
    }
}

function Install-BizinGothicNF {
    $release = irm https://api.github.com/repos/yuru7/bizin-gothic/releases/latest
    $bizinGothicNF = $release.assets |? { $_.name.contains("NF")  }
    $downloadUrl =  $bizinGothicNF.browser_download_url

    $zipFile = "font.zip"
    Invoke-WebRequest $downloadUrl -OutFile $zipFile
    Expand-Archive $zipFile

    ll font/**/*.ttf |% { start $_.fullname }
    pause

    rm $zipFile
    rm ./font -Recurse
}


if (-not (Test-Font-Installed) ){
    if (Confirm "フォント: Bizin Gothic NF をインストールしますか") {
        Instal-BizinGothicNF
    }
}
if (Confirm "ahk を shell:startup に配置しますか？") {
    Write-AHK-To-Startup
}

if (Confirm "Windows Terminal のテーマを変更しますか？") {
    Change-Windows-Terminal-Setting
}
