
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

function Import-PythonPackage {
    param(
        $Name
    )

    # Wrap in an ArrayList so PowerShell doesn't try to unwind the dynamic because it will throw
    # an exception
    $ar = [System.Collections.ArrayList]::new()
    $ar.add([Python.Runtime.Py]::Import($Name)) | Out-Null
    $ar
}

function Invoke-Python {
    param(
        [Parameter(Mandatory)]
        $Code,
        [Parameter()]
        [type]$ReturnType
    )

    if ($ReturnType)
    {
        if ($null -eq $Scope)
        {
            [Python.Runtime.PythonEngine]::Eval($Code) -as $ReturnType
        }
        else 
        {
            $Scope.Eval($Code) -as $ReturnType
        }
        
    }
    else 
    {
        if ($null -eq $Scope)
        {
            [Python.Runtime.PythonEngine]::Exec($Code)
        }
        else 
        {
            $Scope.Exec($Code)
        }
    }
}

function Use-PythonScope {
    param(
        [Parameter(Mandatory)]
        [scriptblock]$ScriptBlock
    )

    $Scope = $null
    try 
    {
        $Scope = [Python.Runtime.Py]::CreateScope()
        $ScriptBlock.Invoke()
    }
    finally 
    {
        $Scope.Dispose()
    }
}

function Set-PythonVariable {
    param(
        [Parameter(Mandatory)]
        $Name,
        [Parameter(Mandatory)]
        $Value
    )

    if ($null -eq $Scope)
    {
        throw "Set-PythonVariable must be called within a Use-PythonScope" 
    }

    $PyObject = [Python.Runtime.ConverterExtension]::ToPython($Value)
    $Scope.Set($Name, $PyObject)
}

function Install-PythonPackage {
    param(
        $Name,
        [ValidateSet("v2.7", "v3.5", "v3.6", "v3.7")]
        $Version = "v3.7"
    )

    Invoke-Pip -Action "install" -Name $Name -Version $Version
}

function Uninstall-PythonPackage {
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
        Invoke-Python -Code "import subprocess
subprocess.check_call(['python', '-m', 'pip', '$Action', '$Name'])"
    }
}
