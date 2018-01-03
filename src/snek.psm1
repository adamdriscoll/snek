
function Import-PythonRuntime {
    param(
        [ValidateSet("v2", "v3")]
        $Version = "v2"
        )

    $FolderPath = "v27";
    if ($Version -eq "v3") {
        $FolderPath = "v36";
    }

    $arch = "x86"
    if ([IntPtr]::Size -eq 8) {
        $arch = "x64"
    }

    $Runtime = Join-Path (Join-Path (Join-Path (Join-Path $PSScriptRoot "binaries") $arch) $FolderPath) "Python.Runtime.dll"

    [System.Reflection.Assembly]::LoadFrom($Runtime) | Out-Null
    
}

function Use-Python {
    param(
        [ScriptBlock]$Script
    )

    Import-PythonRuntime

    $runtime = $null
    try 
    {
        $runtime = [Python.Runtime.Py]::Gil()

        $Script.Invoke()
    } 
    Finally 
    {
        $runtime.Dispose()
    }
}

function Import-PythonModule {
    param(
        $Name
    )

    [Python.Runtime.Py]::Import($Name)
}

function Install-PythonModule {
    param(
        $Name
    )

    $item = Get-Item "hklm:\SOFTWARE\Python\PythonCore\2.7\InstallPath"
    $pythonPath = $item.GetValue("")

    Invoke-Expression "$($pythonPath)Scripts\pip.exe install $name"
}