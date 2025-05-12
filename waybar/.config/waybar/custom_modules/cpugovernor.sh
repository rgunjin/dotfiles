#!/bin/bash

gov=$(cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor)

if [[ "$gov" == "performance" ]]; then
	echo '{"text": "perf", "alt": "perf", "class": "performance", "tooltip": "<b>Governor</b> Performance"}'
elif [[ "$gov" == "schedutil" ]]; then
	echo '{"text": "sched", "class": "schedutil", "tooltip": "<b>Governor</b> Schedutil"}'
fi
