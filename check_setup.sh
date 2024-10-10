#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NORMAL='\033[0m'
COL=15

exit_status=0

# from: https://stackoverflow.com/a/4024263
function version_less() {
    [ "$1" = "$(echo -e "$1\n$2" | sort -V | head -n1)" ]
}

function check_tool() {
    min_version=$2 || "0"
    required=$3 || true
    if [ -x "$(command -v $1)" ]; then
        version=$($1 --version | grep -o -E "[0-9]+.[0-9]+(.[0-9]+)?" | head -1)

        if version_less $version $min_version; then
            printf "%-${COL}s found, ${RED}version: ${version}, need at least: ${min_version}${NORMAL}\n" $1
            exit_status=1
        else
            printf "%-${COL}s found, version: ${version}\n" $1
            return 0
        fi

    elif $required; then
        printf "${RED}%-${COL}s not found, but required${NORMAL}\n" $1
        exit_status=1
    else
        printf "${YELLOW}%-${COL}s not found, but optional${NORMAL}\n" $1
    fi
    return 1
}

# compiler
check_tool c++ 12.0.0 false ||
    check_tool g++ 12.0.0 false ||
    check_tool clang++ 15.0.0 false || {
    echo -e "${RED}No supported compiler found${NORMAL}"
    exit_status=1
} # clang does not work for header_units exercise

# tools
check_tool twiggy
check_tool make
check_tool ninja
check_tool cmake 3.22.0

printf "\n"
if [ $exit_status -eq 0 ]; then
    printf "${GREEN}%-${COL}s Setup found no issues! ${NORMAL}\n" $1
else
    printf "${RED}%-${COL}s Some of the checks failed! ${NORMAL}\n" $1
fi
