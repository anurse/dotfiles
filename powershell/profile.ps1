Write-Host "Loading profile from .dotfiles"
$Global:DotFilesRoot = Convert-Path (Split-Path -Parent $PSScriptRoot)

# Locate code root
$DefaultCodeRoot = Join-Path $env:USERPROFILE "Code"
if(!$CodeRoot -and (Test-Path $DefaultCodeRoot)) {
    $CodeRoot = $DefaultCodeRoot
}

$DnvmPath = Join-Path (Join-Path (Join-Path $CodeRoot "aspnet") "dnvm") "src"
$env:PATH="$DnvmPath;$env:PATH"

# Put dotfiles bin on the path
$env:PATH="$DotFilesRoot\bin;$env:PATH"

# Add the modules from dotfiles to the module path
$env:PSModulePath="$DotFilesRoot\powershell\modules;$env:PSModulePath"

# Load all modules, unless they are disabled
dir "$DotFilesRoot\powershell\modules" | Where-Object { $_.PSIsContainer } | ForEach-Object {
    if(!(Test-Path "$DotFilesRoot\powershell\modules\$($_.Name).disabled")) {
        Import-Module ($_.Name)
    }
}

function TwoLevelRecursiveDir($filter) {
    dir $DotFilesRoot | ForEach-Object {
        if($_.Name -like $filter) {
            $_
        }
        if($_.PSIsContainer) {
            dir $_.FullName -filter $filter
        }
    }
}

function Profile! {
    . "$PSScriptRoot\profile.ps1"
}

TwoLevelRecursiveDir "*.profile.ps1" | foreach {
    . $_.FullName
}
