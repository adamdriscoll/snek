
function Import-PythonRuntime {
    param(
        [ValidateSet("v2.7", "v3.5", "v3.6", "v3.7")]
        $Version = "v3.7"
        )

    $Architecture = 'x64'
    if ([IntPtr]::Size -eq 4)
    {
        $Architecture = 'x86'
    }

    $Runtime = [System.IO.Path]::Combine($PSScriptRoot, "binaries", $Architecture, $Version, "Python.Runtime.dll")
    [System.Reflection.Assembly]::LoadFrom($Runtime) | Out-Null
}

function Use-Python {
    param(
        [ScriptBlock]$Script,
        [ValidateSet("v2.7", "v3.5", "v3.6", "v3.7")]
        $Version = "v3.7"
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
        [ValidateSet("v2.7", "v3.5", "v3.6", "v3.7")]
        $Version = "v3.7"
    )

    Invoke-Pip -Action "install" -Name $Name -Version $Version
}

function Uninstall-PythonModule {
    param(
        $Name,
        [ValidateSet("v2.7", "v3.5", "v3.6", "v3.7")]
        $Version = "v3.7"
    )

    Invoke-Pip -Action "uninstall" -Name $Name -Version $Version
}

function Invoke-Pip {
    param(
        $Action,
        $Name,
        [ValidateSet("v2.7", "v3.5", "v3.6", "v3.7")]
        $Version = "v3.7"
    )

    Use-Python -Version $Version -Script {
        Invoke-Python -Code "import pip._internal
pip._internal.main([`"$Action`", `"$Name`"])"
    }
}
