#!/bin/env bash

# 1
mkdir name
cd name
# 2
mkdir documents
cd documents
touch file{1..3}.txt
ls
# 3
cd ..
touch .hidden_file.txt
ls -a
# 4
echo "Hello" >documents/file1.txt
cat documents/file1.txt
# 5
cd documents
# 6
mkdir "-"
cd ./-
# 7
cp -r ../../documents ../../my_documents
cat ../../.hidden_file.txt
