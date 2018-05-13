
function Import-PythonRuntime {
    param(
        [ValidateSet("v2", "v3")]
        $Version = "v3"
        )

    $FolderPath = "v27";
    if ($Version -eq "v3") {
        $FolderPath = "v36";
    }

    $arch = "x86"
    if ([IntPtr]::Size -eq 8) {
        $arch = "x64"
    }

    $Runtime = [System.IO.Path]::Combine($PSScriptRoot, "binaries", $arch, $FolderPath, "Python.Runtime.dll")
    [System.Reflection.Assembly]::LoadFrom($Runtime) | Out-Null
}

function Use-Python {
    param(
        [ScriptBlock]$Script,
        [ValidateSet("v2", "v3")]
        $Version = "v3"
    )

    Import-PythonRuntime -Version $Version

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

function Invoke-Python {
    param(
        $Code
    )

    [Python.Runtime.PythonEngine]::Exec($Code)
}

function Install-PythonModule {
    param(
        $Name,
        [ValidateSet("v2", "v3")]
        $Version = "v3"
    )

    Use-Python -Version $Version -Script {
        Invoke-Python -Code "import pip._internal
pip._internal.main([`"install`", `"$Name`"])"
    }
}
