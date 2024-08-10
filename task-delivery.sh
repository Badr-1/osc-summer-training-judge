#!/bin/env bash

get_repo() {
    github_link=$(echo "$entry" | cut -d "," -f2)
    reponame="$(echo $github_link | sed 's/\.git$//' | awk -F '/' '{print $NF}')"
    path=$(pwd)
    git clone $github_link &>/dev/null
    cd $reponame
}

create_task() {
    cp -r $path/$task_name .
    cd $task_name
    touch solution.sh
    chmod +x solution.sh
}

submit_task() {
    git add .
    git commit -m ${task_name} &>/dev/null
    git push &>/dev/null
}

clean_up() {
    cd $path
    rm -rf $reponame
}

push_task() {

    get_repo
    create_task
    submit_task
    clean_up
}

source="repos.csv"
repositories=$(wc -l <"$source")
for student in $(seq 1 $repositories); do

    entry=$(sed -n "$student"p $source)
    task_name=$1
    push_task

done
