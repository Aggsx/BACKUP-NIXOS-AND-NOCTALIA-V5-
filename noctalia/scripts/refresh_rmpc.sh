#!/usr/bin/env bash

RMPC_PID=$(pgrep -x "rmpc" | head -n 1)

if [ -n "$RMPC_PID" ]; then
    PARENT_PID=$(ps -o ppid= -p "$RMPC_PID" | tr -d ' ')

    if [ -n "$PARENT_PID" ]; then
        kill -9 "$PARENT_PID" 2>/dev/null
    fi

    kill -9 "$RMPC_PID" 2>/dev/null

    sleep 0.1

    ghostty -e rmpc >/dev/null 2>&1 & disown
else
    exit 0
fi
