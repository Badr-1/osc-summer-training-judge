#!/bin/env bash

get_repo() {
    github_link=$(echo "$entry" | cut -d "," -f2)
    reponame="$(echo $github_link | sed 's/\.git$//' | awk -F '/' '{print $NF}')"
    path=$(pwd)
    git clone $github_link &>/dev/null
    cd $reponame
}

create_sandbox() {
    mkdir sandbox
    cd sandbox
    ../solution.sh &>/dev/null
    ../validate.sh &>/dev/null
    if [[ $? -ne 0 ]]; then
        echo "$github_link,Failed" >>$path/output.csv
    else
        echo "$github_link,Passed" >>$path/output.csv
    fi
}

clean_up() {
    cd $path
    rm -rf $reponame
}

validating_task() {
    get_repo
    cd $task_name
    create_sandbox
    clean_up
}

# reading repos csv must be headless
source="repos.csv"
repositories=$(wc -l <"$source")
for student in $(seq 1 $repositories); do

    entry=$(sed -n "$student"p $source)
    task_name=$1
    validating_task

done
