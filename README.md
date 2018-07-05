# [Snek](https://www.reddit.com/r/Snek/)

## PowerShell wrapper around [Python for .NET ](https://github.com/pythonnet/pythonnet) to invoke Python from PowerShell

![](./snek.jpg)

## Install snek 

```
Install-Module snek
```

## Requirements

* Python v2.7 or v3.6 (defaults to python 3.6)
* for Python v2.7 just add -Version v2

## Functions 

* Use-Python
* Invoke-Python
* Import-PythonRuntime
* Import-PythonModule
* Set-PythonModule

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

Format is `Set-PythonModule <pip command> <package>`

```
PS> Set-PythonModule install requests
```

Or similarly:

```
PS> Set-PythonModule uninstall requests
```
