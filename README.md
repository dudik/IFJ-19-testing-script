# IFJ-19-testing-script
Testing script and tests for IFJ 2019 project
## Setup
In main.sh:

compilerPath - path to binary

makefileFolder - path to folder which contains Makefile

## Usage
### Input
If test.src requires some input create file test.in with input

## Tests
By default only the tests in the tests folder will be run. To specify a folder or a file use the first argument of the script.
```
./main.sh tests/koule/koule.src
./main.sh tests/oficialne/
```

### Return codes
The default expected return code is 0.
To change the expected return code, add this line at the top of test.src:
```
##code
```
For example:
```
##4
```

For more information read the reference tests.

## FAQ
The script is bad.
I know.

Why english?
I don't know.
