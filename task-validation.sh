#!/bin/env bash

print_message() {
    # Define colors with bold and semantic meaning
    BOLD_RED='\033[1;31m'     # Error
    BOLD_GREEN='\033[1;32m'   # Success
    BOLD_YELLOW='\033[1;33m'  # Warning
    BOLD_BLUE='\033[1;34m'    # Information
    BOLD_CYAN='\033[1;36m'    # Highlight
    BOLD_MAGENTA='\033[1;35m' # Important
    BOLD_WHITE='\033[1;37m'   # Neutral
    RESET='\033[0m'
    local type=$1
    local message=$2

    case $type in
    error)
        echo -e "${BOLD_RED}Error: ${message}${RESET}"
        ;;
    success)
        echo -e "${BOLD_GREEN}Success: ${message}${RESET}"
        ;;
    warning)
        echo -e "${BOLD_YELLOW}Warning: ${message}${RESET}"
        ;;
    info)
        echo -e "${BOLD_BLUE}Info: ${message}${RESET}"
        ;;
    highlight)
        echo -e "${BOLD_CYAN}Highlight: ${message}${RESET}"
        ;;
    important)
        echo -e "${BOLD_MAGENTA}Important: ${message}${RESET}"
        ;;
    neutral)
        echo -e "${BOLD_WHITE}Neutral: ${message}${RESET}"
        ;;
    *)
        echo -e "${BOLD_WHITE}Neutral: ${message}${RESET}"
        ;;
    esac
}

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
    if [[ ! -e "../solution.sh" ]]; then
        print_message error "No Solution Was Found"
        echo "$github_link,Failed" >>$path/output.csv
    else
        ../solution.sh &>/dev/null
        # to negate the need for check if the user has changed the validate script
        # we use the script we wrote
        # but should we apply punishment on students who changes the validate script ?
        $path/$task_name/validate.sh &>/dev/null
        if [[ $? -ne 0 ]]; then
            echo "$github_link,Failed" >>$path/output.csv
        else
            echo "$github_link,Passed" >>$path/output.csv
        fi
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
