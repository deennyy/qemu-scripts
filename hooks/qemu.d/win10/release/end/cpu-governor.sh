#!/bin/bash

for file in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do echo "schedutil" > $file; done
