param(
  [string]$Version = "latest",
  [string]$InstallDir = "$HOME\\.local\\bin"
)

Write-Error "Yuto Code currently publishes macOS arm64 and Linux x64 binaries only. Please use install.sh on macOS or Linux."
Write-Host "Requested version: $Version"
Write-Host "Requested install directory: $InstallDir"
exit 1
