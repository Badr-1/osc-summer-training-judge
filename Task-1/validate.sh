#!/bin/bash

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
                echo -e "${BOLD_GREEN}Success: ${message}${RESET}\r"
                ;;
        warning)
                echo -e "${BOLD_YELLOW}Warning: ${message}${RESET}\r"
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

mkdir sandbox
cd sandbox
../solution.sh

if [[ ! -e name ]]; then
        print_message "failed (0/6)\r" error
        exit 1
else
        print_message "passed (1/6)\r" success
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
                print_message "failed (1/6)\r" error
                exit 1
        else
                print_message "passed (2/6)\r" success
                sleep 0.1
        fi
fi
if [[ ! -e name/.hidden_file.txt ]]; then
        print_message "failed (2/6)\r" error
        exit 1
else
        print_message "passed (3/6)\r" success
        sleep 0.1
fi
if [[ ! -s name/documents/file1.txt ]]; then
        print_message "failed (3/6)\r" error
        exit 1
else
        print_message "passed (4/6)\r" success
        sleep 0.1
fi

if [[ ! -e name/documents/- || ! -d name/documents/- ]]; then
        print_message "failed (4/6)\r" error
        exit 1
else
        print_message "passed (5/6)\r" success
        sleep 0.1
fi
if ! diff -r name/documents name/my_documents; then
        print_message "failed (5/6)\r" error
        exit 1
else
        print_message "passed (6/6)\r" success
        sleep 0.1
fi

cd ..
rm -rf sandbox