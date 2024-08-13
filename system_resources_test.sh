#!/bin/bash

# Set thresholds
CPU_THRESHOLD=80    # in percentage
MEM_THRESHOLD=1024  # in MB
DISK_THRESHOLD=10   # in GB

# Check CPU usage
# Get CPU usage percentage using `top` without batch mode
cpu_usage=$(top -n 1 | grep "Cpu(s)" | awk '{print $2 + $4}')
cpu_usage=${cpu_usage%.*} # Convert to integer

if [ "$cpu_usage" -gt "$CPU_THRESHOLD" ]; then
    echo "CPU usage is above threshold: ${cpu_usage}%"
    exit 1
fi

# Check Memory usage
# Use `free` to get memory statistics
mem_total=$(free -m | grep Mem: | awk '{print $2}')
mem_free=$(free -m | grep Mem: | awk '{print $4}')
mem_used=$((mem_total - mem_free))

if [ "$mem_used" -gt "$MEM_THRESHOLD" ]; then
    echo "Memory usage is above threshold: ${mem_used}MB"
    exit 1
fi

# Check Disk usage
# Use `df` to get disk usage in GB
disk_usage=$(df -BG / | grep / | awk '{print $3}' | sed 's/G//')

if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
    echo "Disk usage is above threshold: ${disk_usage}GB"
    exit 1
fi

# If all checks passed
echo "System resources are within acceptable limits."
exit 0
