#!/bin/bash

echo '{"version":1}'
echo '['

first=true
while true; do
    # temp
    temp=$(vcgencmd measure_temp | grep -o '[0-9.]*')

    # date
    datetime=$(date '+%Y-%m-%d %H:%M:%S')

    # mem
    mem_used_mb=$(free -m | awk '/^Mem:/ {print $3}')
    mem_total_mb=$(free -m | awk '/^Mem:/ {print $2}')
    mem_used_g=$(awk "BEGIN {printf \"%.1f\", $mem_used_mb/1024}")
    mem_total_g=$(awk "BEGIN {printf \"%.1f\", $mem_total_mb/1024}")

    [[ $first == true ]] && first=false || echo ","
    echo "[{\"full_text\":\"${temp}°C  |  ${mem_used_g}G / ${mem_total_g}G  |  ${datetime}  \"}]"

    sleep 1
done
