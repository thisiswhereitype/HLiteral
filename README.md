# HLiteral
Takes a file and converts into a compilable string literal.

## Install
```
git clone
stack install
```
## Usage
Takes a file path `a` as argument and writes the literal to `a.HLiteral`
```
$ ls
someFile.txt
$ HLiteral someFile.txt
$ ls
someFile.txt someFile.txt.HLiteral
```
