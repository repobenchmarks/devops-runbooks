# PowerShell Quickstart Runbook: WSL Containers (wslc.exe) GA
# Ref: https://www.repobenchmarks.com/2026/10/wsl-containers-at-ga-what-wslc-can-do.html
 = 'Stop'

Write-Host '==> Checking WSL and wslc CLI version...'
wsl.exe --version
wslc.exe version

Write-Host '==> Running hello-world container test...'
wslc.exe run --rm hello-world

Write-Host '==> Starting Nginx background test on port 8080...'
wslc.exe run -d --rm -p 8080:80 --name wslc-web nginx
Start-Sleep -Seconds 2

Write-Host '==> Testing port reachability from Windows...'
curl.exe http://localhost:8080/

Write-Host '==> Container list & cleanup...'
wslc.exe container list
wslc.exe container stop wslc-web
Write-Host '==> WSL Containers smoke test passed.'
