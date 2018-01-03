
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

function Test-Python {
    Use-Python {
        $np = Import-PythonModule "numpy"
        [float]$np.cos($np.pi * 2)
    
        [float]$np.sin(5)
        [float]($np.cos(5) + $np.sin(5))
    }
}