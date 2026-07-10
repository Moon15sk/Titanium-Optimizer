Clear-Host
$Host.UI.RawUI.ForegroundColor = "Cyan"

# Modré ASCII záhlavie podľa obrázka
Write-Host "████████╗██╗████████╗ █████╗ ███╗   ██╗██╗██╗   ██╗███╗   ███╗"
Write-Host "╚══██╔══╝██║╚══██╔══╝██╔══██╗████╗  ██║██║██║   ██║████╗ ████║"
Write-Host "   ██║   ██║   ██║   ███████║██╔██╗ ██║██║██║   ██║██╔████╔██║"
Write-Host "   ██║   ██║   ██║   ██╔══██║██║╚██╗██║██║██║   ██║██║╚██╔╝██║"
Write-Host "   ██║   ██║   ██║   ██║  ██║██║ ╚████║██║╚██████╔╝██║ ╚═╝ ██║"
Write-Host "   ╚═╝   ╚═╝   ╚═╝   ╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝ ╚═════╝ ╚═╝     ╚═╝"
Write-Host "================= TITÁNOVÝ OPTIMALIZÁTOR ================="
Write-Host ""

# Simulácia / Príprava prostredia so sťahovaním
$progressText = "Downloading "
Write-Host -NoNewline $progressText

for ($i = 1; $i -le 20; $i++) {
    Start-Sleep -Milliseconds 100
    Write-Host -NoNewline "-"
}
Write-Host -NoNewline " 100%"
Write-Host ""
Write-Host "Downloaded!" -ForegroundColor Green
Start-Sleep -Seconds 1

# Vytvorenie skrytého priečinka pre optimizer a spustenie jadra
$optDir = "$env:USERPROFILE\.titan_optimizer"
if (!(Test-Path $optDir)) { New-Item -ItemType Directory -Path $optDir -Force | Out-Null }

# Vytvorenie samotného Python kódu aplikácie
$pythonCodePath = "$optDir\app.py"
