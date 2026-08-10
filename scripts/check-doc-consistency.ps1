[CmdletBinding()]
param(
    [string]$Root = ''
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
if ([string]::IsNullOrWhiteSpace($Root)) {
    $scriptPath = $MyInvocation.MyCommand.Path
    $Root = Split-Path -Parent (Split-Path -Parent $scriptPath)
}
$Root = (Resolve-Path $Root).Path
$failures = New-Object 'System.Collections.Generic.List[string]'

function Read-Utf8File {
    param([string]$Path)
    return [System.IO.File]::ReadAllText($Path, [System.Text.Encoding]::UTF8)
}

function Assert-FilePair {
    param([string]$Chinese, [string]$English)

    foreach ($relativePath in @($Chinese, $English)) {
        $path = Join-Path $Root $relativePath
        if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
            $failures.Add("Missing paired file: $relativePath")
        }
    }
}

function Assert-Contains {
    param([string]$RelativePath, [string[]]$Patterns)

    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        return
    }

    $content = Read-Utf8File -Path $path
    foreach ($pattern in $Patterns) {
        if (-not $content.Contains($pattern)) {
            $failures.Add("Missing '$pattern' in $RelativePath")
        }
    }
}

function Assert-NotContains {
    param([string]$RelativePath, [string[]]$Patterns)

    $path = Join-Path $Root $RelativePath
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) {
        return
    }

    $content = Read-Utf8File -Path $path
    foreach ($pattern in $Patterns) {
        if ($content.Contains($pattern)) {
            $failures.Add("Forbidden stale text '$pattern' in $RelativePath")
        }
    }
}

$pairedFiles = @(
    'SKILL.md',
    'README.md',
    'references/tech-stack-guide.md',
    'references/architecture-design.md',
    'references/dev-lifecycle.md',
    'templates/agent-architecture.md',
    'templates/agent-workflow.md',
    'templates/agent-context.md',
    'templates/agent-coding-rule.md',
    'templates/adr-template.md',
    'templates/domain-model-template.md',
    'templates/project-readme-template.md'
)

foreach ($relativePath in $pairedFiles) {
    Assert-FilePair -Chinese ("skills/project-architecture/$relativePath") -English ("skills/project-architecture-en/$relativePath")
}

$requiredRules = @(
    'skills/project-architecture/SKILL.md|docs/adr/|S/M/L',
    'skills/project-architecture-en/SKILL.md|docs/adr/|risk|Tier S',
    'skills/project-architecture/templates/agent-architecture.md|docs/adr/|RTO / RPO|CI/CD',
    'skills/project-architecture-en/templates/agent-architecture.md|Project Tier and Boundaries|Message queue|Security scanning|RTO / RPO',
    'skills/project-architecture/templates/agent-workflow.md|Definition of Ready|Definition of Done|docs/adr/',
    'skills/project-architecture-en/templates/agent-workflow.md|Definition of Ready|Definition of Done|CI Security Gates|Rollback Process|Post-Release Checks'
)

foreach ($rule in $requiredRules) {
    $parts = $rule.Split('|')
    Assert-Contains -RelativePath $parts[0] -Patterns $parts[1..($parts.Length - 1)]
}

$staleRules = @(
    'skills/project-architecture/README.md|Top 3',
    'skills/project-architecture-en/README.md|Top 3|skips redundant layers|two phases',
    'skills/project-architecture-en/references/dev-lifecycle.md|Every task must pass through all 6 phases',
    'skills/project-architecture-en/references/tech-stack-guide.md|Skip L9|Skip L4|Skip L8'
)

foreach ($rule in $staleRules) {
    $parts = $rule.Split('|')
    Assert-NotContains -RelativePath $parts[0] -Patterns $parts[1..($parts.Length - 1)]
}

$allMarkdown = Get-ChildItem -LiteralPath (Join-Path $Root 'skills') -Recurse -Filter '*.md' -File
foreach ($file in $allMarkdown) {
    $content = Read-Utf8File -Path $file.FullName
    if ($content -match '(?m)^<<<<<<<|^=======|^>>>>>>>') {
        $relative = $file.FullName.Substring($Root.Length) -replace '^[\\/]+', ''
        $failures.Add("Merge conflict marker in $relative")
    }
}

if ($failures.Count -gt 0) {
    foreach ($failure in $failures) {
        Write-Error $failure
    }
    exit 1
}

Write-Output "Documentation consistency check passed: $($pairedFiles.Count) file pairs verified."
