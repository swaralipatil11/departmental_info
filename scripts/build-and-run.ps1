<#
  build-and-run.ps1
  Windows helper: builds the department-portal image and runs it as container "portal" on port 8080.
  Run from the project root: .\scripts\build-and-run.ps1
#>

$ErrorActionPreference = "Stop"

Write-Host "Checking Docker Desktop is running..." -ForegroundColor Cyan
docker info > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker Desktop is not running. Please start it and try again." -ForegroundColor Red
    exit 1
}

# Move to project root (parent of this script's folder)
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

Write-Host "Building image 'department-portal'..." -ForegroundColor Cyan
docker build -t department-portal .

$existing = docker ps -a --filter "name=^portal$" --format "{{.Names}}"
if ($existing -eq "portal") {
    Write-Host "Removing existing container 'portal'..." -ForegroundColor Yellow
    docker rm -f portal | Out-Null
}

Write-Host "Starting container 'portal' on http://localhost:8080 ..." -ForegroundColor Cyan
docker run -d -p 8080:80 --name portal department-portal

Write-Host "Done. Open http://localhost:8080 in your browser." -ForegroundColor Green
