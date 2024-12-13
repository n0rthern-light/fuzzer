#!/bin/sh

if [ "$#" -ne 3 ]; then
    echo "Usage: fuzzer.sh <input-file> <output-file> <tested-app>"
    exit 1
fi

while true; do
    ./mut.py "$1" "$2" > "$2.log"
    "$3" "$2"
    if [ "$?" -ne "0" ]; then
        echo CRASH CRASH CRASH
        echo Mutation that did the crash:
        cat "$2.log" 
    fi
done

