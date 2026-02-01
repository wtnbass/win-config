$pkg = Get-AppxPackage -Name Microsoft.WindowsTerminal
$settingsPath = "$env:LOCALAPPDATA\Packages\$($pkg.PackageFamilyName)\LocalState\settings.json"
$settingsJson = Get-Content $settingsPath | ConvertFrom-Json

$settingsJson.schemes = @(
  @{
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
)

$settingsJson.profiles.defaults.colorScheme = "Kanagawa"
$settingsJson.profiles.defaults.opacity = 80
$settingsJson.profiles.defaults.useAcrylic = $false

Add-Type -AssemblyName System.Drawing
$fontFace = "Bizin Gothic NF"
$installedFonts = New-Object System.Drawing.Text.InstalledFontCollection
if ($installedFonts.Families.Name -contains $fontFace) {
  $settingsJson.profiles.defaults.font.face = $fontFace
} else {
  Write-Host "$fontFace がインストールされてないためスキップ"
}

$settingsJson | ConvertTo-Json -Depth 10 | Set-Content $settingsPath -Encoding utf8
