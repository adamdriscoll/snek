# Snek

## PowerShell wrapper around [Python for .NET ](https://github.com/pythonnet/pythonnet) to invoke Python from PowerShell

![](./snek.jpg)

## Requirements

* Python v2.7

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