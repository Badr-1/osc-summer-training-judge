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
    neutral)
        echo -e "${BOLD_WHITE}${message}${RESET}"
        ;;
    *)
        echo -e "${BOLD_WHITE}${message}${RESET}"
        ;;
    esac
}

get_repo() {
    github_link=$(echo "$entry" | cut -d "," -f2)
    reponame="$(echo $github_link | sed 's/\.git$//' | awk -F '/' '{print $NF}')"
    git clone $github_link &>/dev/null
    if [[ $? -ne 0 ]]; then # pull instead of clone
        print_message "pulled $github_link"
        cd $reponame
        git pull &>/dev/null
    else
        print_message "cloned $github_link"
        cd $reponame
    fi
}

create_sandbox() {

    print_message "Testing Solution..."
    $path/$task_name/validate.sh &>/dev/null
    if [[ $? -ne 0 ]]; then
        print_message "Task Failed" error
        echo "$github_link,Failed" >>$path/output.csv
    else
        print_message "Task Passed" success
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
    cd $path/repos
}
path=$(pwd)
# reading repos csv must be headless
source="repos.csv"
repositories=$(wc -l <"$source")
print_message "Number of Repositories: $repositories"
print_line
mkdir repos &>/dev/null
cd repos
for student in $(seq 1 $repositories); do
    entry=$(sed -n "$student"p $path/$source)
    task_name=$1
    validating_task
    print_line
done
