
function Import-PythonRuntime {
    param(
        [ValidateSet("v3.7", 'v3.8', 'v3.9', 'v3.10', 'v3.11')]
        $Version = "v3.11",
        [Parameter()]
        $PythonDLL
    )

    if (-not $PythonDLL) {
        if ($IsCoreCLR) {
            if ($IsWindows) {
                $pythonDll = "python$($Version.Replace('v', '').Replace('.', '')).dll"
            }
            elseif ($IsLinux) {
                $pythonDll = "libpython$($Version.Replace('v', '')).so"
            }
            else {
                $pythonDll = "libpython$($Version.Replace('v', '')).dylib"
            }
        }
        else {
            $pythonDll = "python$($Version.Replace('v', '').Replace('.', '')).dll"
        }
    }

    $Runtime = [System.IO.Path]::Combine($PSScriptRoot, "binaries", "Python.Runtime.dll")
    [System.Reflection.Assembly]::LoadFrom($Runtime) | Out-Null

    [Python.Runtime.Runtime]::PythonDLL = $pythonDll
    [Python.Runtime.PythonEngine]::Initialize()  | Out-Null
    [Python.Runtime.PythonEngine]::BeginAllowThreads() | Out-Null
}

function Use-Python {
    param(
        [ScriptBlock]$Script,
        [ValidateSet("v3.7", 'v3.8', 'v3.9', 'v3.10', 'v3.11')]
        $Version = "v3.11",
        [Parameter()]
        $PythonDLL
    )

    Import-PythonRuntime -Version $Version

    $runtime = $null
    try {
        $runtime = [Python.Runtime.Py]::Gil()

        $Script.Invoke()
    } 
    Finally {
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

    if ($ReturnType) {
        if ($null -eq $Scope) {
            [Python.Runtime.PythonEngine]::Eval($Code) -as $ReturnType
        }
        else {
            $Scope.Eval($Code) -as $ReturnType
        }
        
    }
    else {
        if ($null -eq $Scope) {
            [Python.Runtime.PythonEngine]::Exec($Code)
        }
        else {
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
    try {
        $Scope = [Python.Runtime.Py]::CreateScope()
        $ScriptBlock.Invoke()
    }
    finally {
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

    if ($null -eq $Scope) {
        throw "Set-PythonVariable must be called within a Use-PythonScope" 
    }

    $PyObject = [Python.Runtime.ConverterExtension]::ToPython($Value)
    $Scope.Set($Name, $PyObject)
}

function Install-PythonPackage {
    param(
        $Name,
        [ValidateSet("v3.7", 'v3.8', 'v3.9', 'v3.10', 'v3.11')]
        $Version = "v3.11",
        [Parameter()]
        $PythonDLL
    )

    Invoke-Pip -Action "install" -Name $Name -Version $Version
}

function Uninstall-PythonPackage {
    param(
        $Name,
        [ValidateSet("v3.7", 'v3.8', 'v3.9', 'v3.10', 'v3.11')]
        $Version = "v3.11",
        [Parameter()]
        $PythonDLL
    )

    Invoke-Pip -Action "uninstall" -Name $Name -Version $Version
}

function Invoke-Pip {
    param(
        $Action,
        $Name,
        [ValidateSet("v3.7", 'v3.8', 'v3.9', 'v3.10', 'v3.11')]
        $Version = "v3.11",
        [Parameter()]
        $PythonDLL
    )

    Use-Python -Version $Version -Script {
        Invoke-Python -Code "import subprocess
subprocess.check_call(['python', '-m', 'pip', '$Action', '$Name'])"
    }
}
