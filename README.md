# [Snek](https://www.reddit.com/r/Snek/)

## PowerShell wrapper around [Python for .NET ](https://github.com/pythonnet/pythonnet) to invoke Python from PowerShell

![](./snek.jpg)

## Install snek 

```
Install-Module snek
```

## Requirements

* Python v3.7, v3.8, v3.9, v3.10, or v3.11 (defaults to python 3.11)

## Functions 

* Use-Python
* Invoke-Python
* Import-PythonRuntime
* Import-PythonPackage
* Install-PythonPackage
* Uninstall-PythonPackage
* Use-PythonScope
* Set-PythonVariable

### Invoke Python Code (v3.11)

```
Use-Python { 
    Invoke-Python -Code "print('hi!')" 
}
    
hi!
```

### Invoke Python Code (v3.7)

```
PS > Use-Python { 
    Invoke-Python -Code "print('hi!')" 
} -Version v3.7
    
hi!
```

### Returning A Value from Python to PowerShell

Due to the use of `dynamic` the type must be cast to the expected type so you need to specify the `-ReturnType` parameter to do so.

```
Use-Python {
    Invoke-Python "'Hello'" -ReturnType ([String])
}
```

### Imports the `numpy` Python module and does some math

Access methods of modules directly! 

```
Use-Python {
    $np = Import-PythonPackage "numpy"
    [float]$np.cos($np.pi * 2)

    [float]$np.sin(5)
    [float]($np.cos(5) + $np.sin(5))
} -Version v3.7
```

Output

```
1
-0.9589243
-0.6752621
```

### Manage pip

Format is `Install-PythonPackage <package>`

```
Install-PythonPackage requests
```

Or similarly:

```
Uninstall-PythonPackage requests
```

### Using Scopes

You can use Python scopes to string together multiple `Invoke-Python` calls or to pass in variables from PowerShell. 

```
Use-Python {
    Use-PythonScope {
        Invoke-Python -Code "import sys" 
        Invoke-Python -Code "sys.version" -ReturnType ([string]) 
    }
}
```

### Passing a .NET Object to Python

```
class Person {
    [string]$FirstName
    [string]$LastName
}

Use-Python {
    Use-PythonScope {
        $Person = [Person]::new()
        $Person.FirstName = "Adam"
        $Person.LastName = "Driscoll"
        Set-PythonVariable -Name "person" -Value $Person

        Invoke-Python -Code "person.FirstName + ' ' + person.LastName" -ReturnType ([string])
    }
}
```
