#!/bin/bash

# MemTotal:        8052076 kB
# MemFree:         2372916 kB
# MemAvailable:    5687644 kB
# Buffers:            4400 kB
# Cached:          3026332 kB

spark_percent_00='▁'
spark_percent_12='▂'
spark_percent_25='▃'
spark_percent_37='▄'
spark_percent_50='▅'
spark_percent_62='▆'
spark_percent_75='▇'
spark_percent_87='█'

mem_total_kb=$(awk '/^MemTotal:/ {print $2}' /proc/meminfo)
mem_free_kb=$(awk '/^MemFree:/ {print $2}' /proc/meminfo)
mem_avail_kb=$(awk '/^MemAvailable:/ {print $2}' /proc/meminfo)
buff_kb=$(awk '/^Buffers:/ {print $2}' /proc/meminfo)
cached_kb=$(awk '/^Cached:/ {print $2}' /proc/meminfo)

used_kb=$(bc -l <<< "$mem_total_kb - $mem_free_kb - $buff_kb - $cached_kb")

used_percent=$(bc -l <<< "($used_kb/$mem_total_kb)*100" )

if [[ $used_percent > 00 ]]; then spark=${spark_percent_00}; fi
if [[ $used_percent > 12 ]]; then spark=${spark_percent_12}; fi
if [[ $used_percent > 25 ]]; then spark=${spark_percent_25}; fi
if [[ $used_percent > 37 ]]; then spark=${spark_percent_37}; fi
if [[ $used_percent > 50 ]]; then spark=${spark_percent_50}; fi
if [[ $used_percent > 62 ]]; then spark=${spark_percent_62}; fi
if [[ $used_percent > 75 ]]; then spark=${spark_percent_75}; fi
if [[ $used_percent > 87 ]]; then spark=${spark_percent_87}; fi

printf "[%s] %.0f%%\n" $spark $used_percent
