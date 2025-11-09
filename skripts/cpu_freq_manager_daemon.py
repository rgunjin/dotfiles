#!/usr/bin/env python3
import os
import time
import psutil

CPU_PATH = "/sys/devices/system/cpu"

# Настройки
MIN_FREQ = 800_000
MAX_FREQ = 2_700_000
TURBO = 1
LOAD_THRESHOLD_UP = 40
LOAD_THRESHOLD_DOWN = 20
STEP_FREQS = [2200000, 2400000, MAX_FREQ]
SLEEP_INTERVAL = 1  # основной цикл

def write_file(path, value):
    try:
        with open(path, "w") as f:
            f.write(str(value))
    except PermissionError:
        pass  # демон тихо игнорирует ошибки прав

def set_min_max_freq(min_freq, max_freq):
    for cpu in os.listdir(CPU_PATH):
        if cpu.startswith("cpu") and cpu[3:].isdigit():
            base = os.path.join(CPU_PATH, cpu, "cpufreq")
            for name, val in [("scaling_min_freq", min_freq), ("scaling_max_freq", max_freq)]:
                path = os.path.join(base, name)
                if os.path.exists(path):
                    write_file(path, val)

def enable_turbo_boost():
    for cpu in os.listdir(CPU_PATH):
        if cpu.startswith("cpu") and cpu[3:].isdigit():
            path = os.path.join(CPU_PATH, cpu, "cpufreq", "boost")
            if os.path.exists(path):
                write_file(path, TURBO)

def set_governor(governor):
    for cpu in os.listdir(CPU_PATH):
        if cpu.startswith("cpu") and cpu[3:].isdigit():
            path = os.path.join(CPU_PATH, cpu, "cpufreq", "scaling_governor")
            if os.path.exists(path):
                write_file(path, governor)

def gradual_max_freq(current_max, target_max):
    for step in STEP_FREQS:
        if step > current_max and step <= target_max:
            set_min_max_freq(MIN_FREQ, step)
            time.sleep(0.5)
            current_max = step
    return current_max

def main():
    set_min_max_freq(MIN_FREQ, MIN_FREQ)
    enable_turbo_boost()
    set_governor("powersave")

    current_max = MIN_FREQ
    while True:
        load = psutil.cpu_percent(interval=1)
        if load > LOAD_THRESHOLD_UP:
            set_governor("ondemand")
            current_max = gradual_max_freq(current_max, MAX_FREQ)
        elif load < LOAD_THRESHOLD_DOWN:
            set_min_max_freq(MIN_FREQ, MIN_FREQ)
            set_governor("powersave")
            current_max = MIN_FREQ
        time.sleep(SLEEP_INTERVAL)

if __name__ == "__main__":
    main()

