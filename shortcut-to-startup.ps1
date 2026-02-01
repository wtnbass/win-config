$filename = "keybinds.ahk"
$sourceFile = Join-Path $pwd.Path $filename

$startupFolder = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup")
$shortcutPath = Join-Path $startupFolder "$filename.lnk"

# ショートカット作成の実行
$shell = New-Object -ComObject WScript.Shell
$shortcut = $shell.CreateShortcut($shortcutPath)
$shortcut.TargetPath = $sourceFile
$shortcut.Save()

Write-Host "スタートアップにショートカットを作成しました: $shortcutPath" -ForegroundColor Green
