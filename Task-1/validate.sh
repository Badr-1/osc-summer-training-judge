#!/bin/bash

if [[ ! -e name ]]; then
        exit 1
else
        echo -ne "passed (1/6)\r"
        sleep 0.1
fi
if [[ -e name/documents && -d name/documents ]]; then
        all_exist=true
        for i in {1..3}; do
                if [[ ! -e file${i}.txt ]]; then
                        all_exist=false
                fi
        done
        if [[ ! all_exist ]]; then
                exit 1
        else
                echo -ne "passed (2/6)\r"
                sleep 0.1
        fi
fi
if [[ ! -e name/.hidden_file.txt ]]; then
        exit 1
else
        echo -ne "passed (3/6)\r"
        sleep 0.1
fi
if [[ ! -s name/documents/file1.txt ]]; then
        exit 1
else
        echo -ne "passed (4/6)\r"
        sleep 0.1
fi

if [[ ! -e name/documents/- || ! -d name/documents/- ]]; then
        exit 1
else
        echo -ne "passed (5/6)\r"
        sleep 0.1
fi
if ! diff -r name/documents name/my_documents; then
        exit 1
else
        echo -ne "passed (6/6)\r"
        sleep 0.1
fi
