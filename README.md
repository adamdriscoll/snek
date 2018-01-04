# Snek

## PowerShell wrapper around [Python for .NET ](https://github.com/pythonnet/pythonnet) to invoke Python from PowerShell

![](./snek.jpg)

## Requirements

* Python v2.7

## Functions 

* Use-Python
* Import-PythonRuntime
* Import-PythonModule
* Install-PythonModule

### Imports the `numpy` Python module and does some math

```
Use-Python {
    $np = Import-PythonModule "numpy"
    [float]$np.cos($np.pi * 2)

    [float]$np.sin(5)
    [float]($np.cos(5) + $np.sin(5))
}
```

Output

```
1
-0.9589243
-0.6752621
```

### Install a new pip

```
PS> Install-PythonModule virtualenv-15.1.0-py2.py3-none-any.whl

Requirement 'virtualenv-15.1.0-py2.py3-none-any.whl' looks like a filename, but the file does not exist
Requirement already satisfied: virtualenv==15.1.0 from file:///C:/Users/Adam/virtualenv-15.1.0-py2.py3-none-any
:\python27\lib\site-packages
```
