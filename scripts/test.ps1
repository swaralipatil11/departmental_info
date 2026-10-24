<#
  test.ps1
  Member 3 test sequence. Runs build/run/stop/restart/log checks and prints PASS/FAIL for each.
  Leaves the "portal" container running at the end.
  Run from the project root: .\scripts\test.ps1
#>

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

$results = @()

function Add-Result($name, $pass, $detail) {
    $script:results += [PSCustomObject]@{ Test = $name; Pass = $pass; Detail = $detail }
    $status = if ($pass) { "PASS" } else { "FAIL" }
    $color = if ($pass) { "Green" } else { "Red" }
    Write-Host "[$status] $name - $detail" -ForegroundColor $color
}

# 0. Docker daemon check
docker info > $null 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "Docker Desktop is not running. Start it and re-run this script." -ForegroundColor Red
    exit 1
}

# 1. Build image
try {
    docker build -t department-portal . 2>&1 | Out-Null
    Add-Result "Build image" $true "docker build completed successfully"
} catch {
    Add-Result "Build image" $false "docker build failed: $_"
}

# Remove any existing container named portal before starting fresh
$existing = docker ps -a --filter "name=^portal$" --format "{{.Names}}"
if ($existing -eq "portal") {
    docker rm -f portal | Out-Null
}

# 2. Start container
try {
    docker run -d -p 8080:80 --name portal department-portal | Out-Null
    Start-Sleep -Seconds 2
    $psOut = docker ps --filter "name=^portal$" --format "{{.Names}}"
    Add-Result "Start container" ($psOut -eq "portal") "docker ps shows: $psOut"
} catch {
    Add-Result "Start container" $false "docker run failed: $_"
}

# 3. Open website, check 200 and all 5 sections present
try {
    $resp = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing
    $body = $resp.Content
    $sections = @("Home", "About the Department", "Faculty Information", "Courses Offered", "Contact Information")
    $missing = @()
    foreach ($s in $sections) {
        if ($body -notmatch [regex]::Escape($s)) { $missing += $s }
    }
    $pass = ($resp.StatusCode -eq 200) -and ($missing.Count -eq 0)
    Add-Result "Open website" $pass "status=$($resp.StatusCode); missing sections: $($missing -join ', ')"
} catch {
    Add-Result "Open website" $false "request failed: $_"
}

# 4. Stop container, expect request to fail
try {
    docker stop portal | Out-Null
    Start-Sleep -Seconds 1
    $failed = $false
    try {
        Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing -TimeoutSec 3 | Out-Null
    } catch {
        $failed = $true
    }
    Add-Result "Stop container" $failed "request to localhost:8080 failed as expected: $failed"
} catch {
    Add-Result "Stop container" $false "docker stop failed: $_"
}

# 5. Restart container, expect 200 again
try {
    docker start portal | Out-Null
    Start-Sleep -Seconds 2
    $resp2 = Invoke-WebRequest -Uri "http://localhost:8080" -UseBasicParsing
    Add-Result "Restart container" ($resp2.StatusCode -eq 200) "status=$($resp2.StatusCode)"
} catch {
    Add-Result "Restart container" $false "request after restart failed: $_"
}

# 6. Check logs for error/emerg/crit
try {
    $logs = docker logs portal 2>&1
    $badLines = $logs | Select-String -Pattern "error|emerg|crit" -CaseSensitive:$false
    $pass = ($badLines.Count -eq 0)
    Add-Result "View logs" $pass "matching lines found: $($badLines.Count)"
} catch {
    Add-Result "View logs" $false "docker logs failed: $_"
}

Write-Host ""
Write-Host "===== Summary =====" -ForegroundColor Cyan
$results | Format-Table -AutoSize

$failCount = ($results | Where-Object { -not $_.Pass }).Count
if ($failCount -eq 0) {
    Write-Host "All tests passed. Container 'portal' is left running." -ForegroundColor Green
} else {
    Write-Host "$failCount test(s) failed. Container 'portal' is left running for inspection." -ForegroundColor Yellow
}
