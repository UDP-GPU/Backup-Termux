#!/data/data/com.termux/files/usr/bin/bash

if [[ "$PREFIX" != "/data/data/com.termux/files/usr" ]]; then
    echo "This script is only for Termux."
    exit 1
fi

if [[ $# -lt 1 ]]; then
    echo "Use: $0 backup | restore [--backup <file>]"
    exit 1
fi

backup() {
    DATETIME=$(date +"%Y-%m-%d_%H-%M-%S")
    FILENAME="backup-${DATETIME}.tar.gz"
    echo "Making backup $FILENAME..."
    tar -czf "$FILENAME" "$PREFIX" "$HOME"
    echo "Backup completed: $FILENAME"
}

restore() {
    BACKUP_FILE=""

    if [[ "$2" == "--backup" && -n "$3" ]]; then
        BACKUP_FILE="$3"
    else
        BACKUP_FILE=$(ls backup*.tar.gz 2>/dev/null | head -n 1)
    fi

    if [[ -z "$BACKUP_FILE" ]]; then
        echo "Backup file wasn't found. Use --backup <file>."
        exit 1
    fi

    echo "Restoring backup from $BACKUP_FILE..."
    tar -xzf "$BACKUP_FILE" -C /
    echo "Restore completed."
}

case "$1" in
    backup)
        backup
        ;;
    restore)
        restore "$@"
        ;;
    *)
        echo "Unknown command: $1. Use 'backup' or 'restore'."
        exit 1
        ;;
esac
