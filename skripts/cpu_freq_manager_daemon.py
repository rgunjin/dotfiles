#!/usr/bin/env python
"""
CPU Frequency Manager Daemon
Динимически управляет частотой процесора
для баланса между производительностью и
тишиной (coil whine)
"""

import os
import time
import psutil

# Пути
CPU_PATH = "/sys/devices/system/cpu"
CPUFREQ_PATH = "/sys/devices/system/cpu/cpufreq"
GLOBAL_BOOST = "/sys/devices/system/cpu/cpufreq/boost"

# Настройка частот (в kHz)
MIN_FREQ = 800_000              # Минимальная частота в простое
MAX_FREQ = 2_700_000            # Максимальная рабочая частота

# Ступени плавного разгона - снижает резкие скачки тока (coil whine)
STEP_FREQS = [1_600_000, 2_000_000, 2_400_000, MAX_FREQ]
STEP_DELAY = 0.4                # Пауза между ступенями разгона в сек

# Пороги нагрузки
LOAD_THRESHOLD_UP = 40          # Выше этого значение начинанем разгон
LOAD_THRESHOLD_DOWN = 20        # Ниже этого начинаем режим экономии

# Гиперстезис
# Сколько секунд нагрузка должна быть ниже порога чтобы понизить частоту
# Защита от дерьганья при нагрузке ~на пороге
COOLDOWN_SECONDS = 5

# Интервал остновного цикла
SAMPLE_INTERVAL = 1


def write_file(path: str, value) -> bool:
    # Записывает значение в sysfs файл. Возвращает True при успехе
    try:
        with open(path, "w") as f:
            f.write(str(value))
        return True
    except (PermissionError, OSError):
        return False


def iter_policies():
    # Итератор по всем policy* директориям cpufreq
    if not os.path.isdir(CPUFREQ_PATH):
        return
    for entry in sorted(os.listdir(CPUFREQ_PATH)):
        if entry.startswith("policy"):
            yield os.path.join(CPUFREQ_PATH, entry)


def set_governor(governor: str):
    # Устанавливает governor для всех policy
    # Использует schedutil при нагрузке - он быстрее реагирует
    # чем ondemand, т.к. привязан к планировщику ядра
    for policy_path in iter_policies():
        path = os.path.join(policy_path, "scaling_governor")
        if os.path.exists(path):
            write_file(path, governor)


def set_freq(min_freq: int, max_freq: int):
    # Устанавливает min/max частоту для все policy
    for policy_path in iter_policies():
        for name, val in [("scaling_min_freq", min_freq),
                          ("scaling_max_freq", max_freq)]:
            path = os.path.join(policy_path, name)
            if os.path.exists(path):
                write_file(path, val)


def set_boost(enable: bool):
    # Включает/выключает режим boost
    # Сначал пишем в глобальный файл, потом дублируем по policy
    # на случай если ядро не синхранизируется автоматически
    val = 1 if enable else 0

    # Глобальный boost
    if os.path.exists(GLOBAL_BOOST):
        write_file(GLOBAL_BOOST, val)

    # Per-policy boost
    for police_path in iter_policies():
        path = os.path.join(police_path, "boost")
        if os.path.exists(path):
            write_file(path, val)


def get_cpu_load() -> float:
    # Возвращает среднюю нагрузку CPU за последнюю секунду
    # interval=None - неблокирующий вызов, используется кэш psutil
    # Реальный замер происходит через time.sleep() в основном цикле
    return psutil.cpu_percent(interval=None)


def gradual_ramp_up(current_max: int, target_max: int) -> int:
    # Плавно поднимает частоту через STEP_FREQS
    # Возвращает итоговое значение current_max
    for step in STEP_FREQS:
        if current_max < step <= target_max:
            set_freq(MIN_FREQ, step)
            time.sleep(STEP_DELAY)
            current_max = step
    return current_max


# Основная логика

def apply_perfomance_mode(current_max: int) -> int:
    set_governor("schedutil")
    set_boost(True)
    current_max = gradual_ramp_up(current_max, MAX_FREQ)
    return current_max


def apply_powersave_mode() -> int:
    set_freq(MIN_FREQ, MIN_FREQ)
    set_governor("powersave")
    set_boost(False)
    return MIN_FREQ


def main():
    print("CPU Frequency Manager starting...")

    # Инициализация - стартуем в тихом режиме
    current_max = apply_powersave_mode()

    # Прогрев psutil - первый вызов cpu_percent всегда возвращает 0.0
    psutil.cpu_percent(interval=None)

    cooldown_counter = 0        # Счетчик секунд с низкой нагрузкой

    while True:
        time.sleep(SAMPLE_INTERVAL)
        load = get_cpu_load()

        if load > LOAD_THRESHOLD_UP:
            # Нагрузка выросла - сбрасываем cooldown
            cooldown_counter = 0
            if current_max < MAX_FREQ:
                print(f"Load {load:.0f}% - ramping up")
                current_max = apply_perfomance_mode(current_max)

        elif load < LOAD_THRESHOLD_DOWN:
            # Нагрузка низкая - инкрементируем cooldown
            cooldown_counter += 1
            if cooldown_counter >= COOLDOWN_SECONDS and current_max > MIN_FREQ:
                print(f"Load {load:.0f}% for {cooldown_counter}s - powersave")
                current_max = apply_powersave_mode()
                cooldown_counter = 0

        else:
            # Нагрузка между порогами - ничего не меняем, сбрасываем cooldown
            cooldown_counter = 0


if __name__ == "__main__":
    main()
