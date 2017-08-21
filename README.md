# HLiteral
Takes a file and converts into a compilable string literal.

## Install
```
git clone https://github.com/thisiswhereitype/HLiteral.git
stack install
```
## Usage
Takes a file path `-i` and writes to argument in `-o`. If `-o` is not provided
the file is written to the inputPath with `.HLiteral` extension.
Mandatory options:  
`-l` Specifies total length of each line is to be. Includes indent.
`-s` Specifies a literal to prepend each line with while not making it part of the string. Allows the file to include automatic indenting.
```
$ ls
someFile.txt
$ HLiteral -i foo.txt -s "    " -l 40 -o bar.baz
$ ls
foo.txt bar.baz
```
Or
```
$ ls
someFile.txt
$ HLiteral -i foo.txt -s "    " -l 40
$ ls
foo.txt foo.txt.HLiteral
```
