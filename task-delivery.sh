#!/bin/env bash

print_line() {
    local terminal_width=$(tput cols)
    printf '%*s\n' "$terminal_width" '' | tr ' ' '='
}
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
    local type=$2
    local message=$1

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
    overlay)
        echo -en "${BOLD_WHITE}${message}${RESET}\r"
        sleep 0.1
        ;;
    *)
        echo -e "${BOLD_WHITE}${message}${RESET}"
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
print_message "Number of Repositories: $repositories"
for student in $(seq 1 $repositories); do
    entry=$(sed -n "$student"p $source)
    task_name=$1
    push_task
    print_message "($student/$repositories) Tasks Pushed" overlay
done
print_message "($repositories/$repositories) Tasks Pushed"
