#!/bin/bash

# kill-port.sh - Kill process running on specified port
# Usage: ./kill-port.sh <port_number>

if [ $# -eq 0 ]; then
    echo "Usage: $0 <port_number>"
    echo "Example: $0 3000"
    exit 1
fi

PORT=$1

# Check if port is a valid number
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: Port must be a number"
    exit 1
fi

echo "Looking for process on port $PORT..."

# Find the PID of the process using the port
PID=$(lsof -ti:$PORT)

if [ -z "$PID" ]; then
    echo "No process found running on port $PORT"
    exit 0
fi

echo "Found process with PID: $PID"
echo "Killing process..."

# Try graceful kill first
kill $PID 2>/dev/null

# Wait up to 3 seconds for the process to die
for i in {1..6}; do
    sleep 0.5
    if ! lsof -ti:$PORT >/dev/null 2>&1; then
        echo "Successfully killed process $PID on port $PORT"
        exit 0
    fi
done

# If still running, force kill
echo "Process still running, forcing kill..."
kill -9 $PID 2>/dev/null

# Wait up to 2 more seconds
for i in {1..4}; do
    sleep 0.5
    if ! lsof -ti:$PORT >/dev/null 2>&1; then
        echo "Successfully force-killed process on port $PORT"
        exit 0
    fi
done

# Check if there are any remaining processes (could be multiple)
REMAINING=$(lsof -ti:$PORT 2>/dev/null)
if [ -n "$REMAINING" ]; then
    echo "Multiple processes detected, killing all..."
    lsof -ti:$PORT | xargs kill -9 2>/dev/null
    sleep 1
    if ! lsof -ti:$PORT >/dev/null 2>&1; then
        echo "Successfully killed all processes on port $PORT"
        exit 0
    else
        echo "Warning: Some processes on port $PORT may still be running"
        exit 1
    fi
else
    echo "Successfully freed port $PORT"
fi
