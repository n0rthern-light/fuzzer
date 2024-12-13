#!/bin/sh

if [ "$#" -ne 3 ]; then
    echo "Usage: fuzzer.sh <input-file> <output-file> <tested-app>"
    exit 1
fi

input_file=$(realpath "$1")
output_file="$(dirname "$input_file")/$2"
mutation_log_file="$output_file.log"
tested_app=$(realpath "$3")

resolve_symlink() {
    target_file="$1"
    while [ -L "$target_file" ]; do
        target_file=$(readlink "$target_file")
        case "$target_file" in
            /*) : ;;
            *) target_file=$(dirname "$1")/"$target_file" ;;
        esac
    done
    echo "$(cd "$(dirname "$target_file")" && pwd)"
}
script_dir=$(resolve_symlink "$0")

while true; do
    "$script_dir/mut.py" "$input_file" "$output_file" > "$mutation_log_file"
    "$tested_app" "$output_file"
    if [ "$?" -ne "0" ]; then
        echo CRASH CRASH CRASH
        echo Mutation that did the crash available in: "$mutation_log_file" 
        exit 0
    fi
done

