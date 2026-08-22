[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
$themeRoots = @('web', 'cart', 'clientarea') | ForEach-Object { Join-Path $repoRoot $_ }
$sourceFiles = Get-ChildItem -Path $themeRoots -Recurse -File | Where-Object {
  $_.Extension -in @('.css', '.html', '.js', '.tpl')
}
$failed = $false

function Report-Failure([string]$Message) {
  Write-Error $Message
  $script:failed = $true
}

& git -C $repoRoot diff --check
if ($LASTEXITCODE -ne 0) {
  Report-Failure 'git diff --check failed.'
}

$forbiddenPatterns = @(
  ':has\(',
  'console\.log',
  'var_dump',
  'print_r',
  'TODO',
  'FIXME',
  'Premium surface',
  'cloud-hero',
  'cloud-service-strip',
  'cloud-capabilities',
  'cloud-cta'
)

$forbiddenMatches = Select-String -Path $sourceFiles.FullName -Pattern $forbiddenPatterns
if ($forbiddenMatches) {
  $forbiddenMatches | ForEach-Object { Write-Host $_.ToString() }
  Report-Failure 'Forbidden legacy, debug, or stacked-override patterns found.'
}

foreach ($cssFile in ($sourceFiles | Where-Object Extension -eq '.css')) {
  $css = Get-Content -Raw $cssFile.FullName
  $openBraces = ([regex]::Matches($css, '\{')).Count
  $closeBraces = ([regex]::Matches($css, '\}')).Count
  if ($openBraces -ne $closeBraces) {
    Report-Failure "$($cssFile.FullName): CSS brace count is $openBraces/$closeBraces."
  }
}

$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
  foreach ($jsFile in ($sourceFiles | Where-Object Extension -eq '.js')) {
    & $node.Source --check $jsFile.FullName
    if ($LASTEXITCODE -ne 0) {
      Report-Failure "$($jsFile.FullName): JavaScript syntax check failed."
    }
  }
} else {
  Write-Warning 'Node.js was not found; JavaScript syntax checks were skipped.'
}

$webVersion = (Get-Content (Join-Path $repoRoot 'web/VERSION') -Raw).Trim()
$cartVersion = (Get-Content (Join-Path $repoRoot 'cart/VERSION') -Raw).Trim()
$clientVersion = (Get-Content (Join-Path $repoRoot 'clientarea/VERSION') -Raw).Trim()

$cacheChecks = @(
  @{ Path = 'web/index.html'; Token = "framework.css?v=$webVersion" },
  @{ Path = 'web/index.html'; Token = "framework.js?v=$webVersion" },
  @{ Path = 'web/static/cart/header.html'; Token = "framework.css?v=$webVersion" },
  @{ Path = 'web/static/cart/header.html'; Token = "framework.js?v=$webVersion" },
  @{ Path = 'cart/product.tpl'; Token = "cart.css?v=$cartVersion" },
  @{ Path = 'cart/product.tpl'; Token = "cart.js?v=$cartVersion" },
  @{ Path = 'cart/configureproduct.tpl'; Token = "configure.css?v=$cartVersion" },
  @{ Path = 'cart/configureproduct.tpl'; Token = "configure.js?v=$cartVersion" },
  @{ Path = 'clientarea/clientarea.tpl'; Token = "dashboard.js?v={`$Ver}-$clientVersion" },
  @{ Path = 'clientarea/header.tpl'; Token = "custom.css?v={`$Ver}-$clientVersion" },
  @{ Path = 'clientarea/footer.tpl'; Token = "clientarea.js?v={`$Ver}-$clientVersion" },
  @{ Path = 'clientarea/login.tpl'; Token = "login.css?v={`$Ver}-$clientVersion" },
  @{ Path = 'clientarea/register.tpl'; Token = "login.css?v={`$Ver}-$clientVersion" },
  @{ Path = 'clientarea/pwreset.tpl'; Token = "login.css?v={`$Ver}-$clientVersion" },
  @{ Path = 'clientarea/service.tpl'; Token = "service.css?v={`$Ver}-$clientVersion" },
  @{ Path = 'clientarea/servicedetail.tpl'; Token = "servicedetail.css?v={`$Ver}-$clientVersion" }
)

foreach ($check in $cacheChecks) {
  $path = Join-Path $repoRoot $check.Path
  if (-not (Get-Content -Raw $path).Contains($check.Token)) {
    Report-Failure "$($check.Path): missing cache token '$($check.Token)'."
  }
}

if ($failed) {
  exit 1
}

Write-Host 'Theme validation passed.'
