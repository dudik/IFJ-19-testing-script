#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

compilerPath=./../bin/main

run_test() {
    echo \# \# \# "$filename" \# \# \#
    cat ifj19.py "$filename" > source.out
    $compilerPath < "$filename" > assembly.out

    code=$?

    expCode=0
    if [ "$(head -n 1 "$filename" | cut -c 1-2)" == "##" ]; then
        expCode=$(head -n 1 "$filename" | cut -c 3-)
    fi

    if [ "$code" == "0" ]; then

        inFile="${filename%.*}.in"
        if [ -f "$inFile" ]; then
            ./ic19int assembly.out < "$inFile" > test.out
            code=$?
        else
            ./ic19int assembly.out > test.out
            code=$?
        fi

        if [ "$expCode" == "$code" ]; then
            printf "${GREEN}RETURN CODE OK${NC}\n"
        else
            printf "${RED}RETURN CODE BAD${NC}\n"
            echo "EXPECTED $expCode WAS $code"
            exit 1
        fi

        if [ "$code" == "0" ]; then
            if [ -f "$inFile" ]; then
                python3 source.out < "$inFile" > vzor.out
                code=$?
            else
                python3 source.out > vzor.out
                code=$?
            fi

            diff=$(diff -s vzor.out test.out)

            if [ "$diff" == "Files vzor.out and test.out are identical" ]; then
                printf "${GREEN}DIFF OK${NC}\n"
            else
                printf "${RED}DIFF BAD${NC}\n"
                diff --old-line-format="%5dn. < %L" --new-line-format="%5dn. > %L" --unchanged-line-format="" vzor.out test.out
                exit 1
            fi
        fi

    else
        if [ "$expCode" == "$code" ]; then
            printf "${GREEN}RETURN CODE OK${NC}\n"
        else
            printf "${RED}RETURN CODE BAD${NC}\n"
            echo "EXPECTED $expCode WAS $code"
            exit 1
        fi
    fi

    echo
}

make main -C ../

if [ "$1" != "" ]; then
    if [ "${1: -1}" == "/" ]; then
        for filename in "$1"*.src; do
            run_test
        done
    else
        filename=$1
        run_test
    fi
else
    for filename in tests/*.src; do
        run_test
    done
fi