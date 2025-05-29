#!/usr/bin/env bash

temp=$(sensors | awk '/Package id 0:/ {gsub(/\+|°C/, "", $4); print int($4)}')
class="normal"

if [ "$temp" -ge 85 ]; then
    class="critical"
elif [ "$temp" -ge 70 ]; then
    class="warning"
fi

echo "{\"text\": \" ${temp}°C\", \"class\": \"$class\"}"
