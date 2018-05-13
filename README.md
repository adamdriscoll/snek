# [Snek](https://www.reddit.com/r/Snek/)

## PowerShell wrapper around [Python for .NET ](https://github.com/pythonnet/pythonnet) to invoke Python from PowerShell

![](./snek.jpg)

## Install snek 

```
Install-Module snek
```
- this forked repo defaults to python 3
- function `Install-PythonModule` has been changed to `Manage-PythonModule` to enable all the pip commands
- to use this repo, after doing an `Install-Module snek` need to replace snek.psd1 and snek.psm1 in `C:\Program Files\WindowsPowerShell\Modules\snek\<version>` with the snek.psd1 and snek.psm1 in this repo.

## Requirements

* Python v2.7 or v3.6 (defaults to python 3.6)
* for Python v2.7 just add -Version v2

## Functions 

* Use-Python
* Invoke-Python
* Import-PythonRuntime
* Import-PythonModule
* Manage-PythonModule

### Invoke Python Code (v3.6)

```
PS > Use-Python { 
    Invoke-Python -Code "print('hi!')" 
}
    
hi!
```

### Invoke Python Code (v2.7)

```
PS > Use-Python { 
    Invoke-Python -Code "print('hi!')" 
} -Version v2
    
hi!
```

### Imports the `numpy` Python module and does some math

Access methods of modules directly! 

```
Use-Python {
    $np = Import-PythonModule "numpy"
    [float]$np.cos($np.pi * 2)

    [float]$np.sin(5)
    [float]($np.cos(5) + $np.sin(5))
} -Version v3
```

Output

```
1
-0.9589243
-0.6752621
```

### Manage pip

Format is `Manage-PythonModule <pip command> <package>`

```
PS> Manage-PythonModule install requests
```

Or similarly:

```
PS> Manage-PythonModule uninstall requests
```
