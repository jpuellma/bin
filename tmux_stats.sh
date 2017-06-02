#!/bin/bash

SHOW_PERCENTS=false
SHOW_SPARKS=true

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

mem_used_percent=$(bc -l <<< "($used_kb/$mem_total_kb)*100" )
mem_used_percent=${mem_used_percent/.*/}

cpu_idle=$(top -bn 1| awk -F "," '/^%Cpu/ {print $4}' | awk '{print $1}')
cpu_used_percent=$(bc -l <<< "100 - $cpu_idle" )
cpu_used_percent=${cpu_used_percent/.*/}

swap_total_kb=$(awk '/^SwapTotal:/ {print $2}' /proc/meminfo)
swap_free_kb=$(awk '/^SwapFree:/ {print $2}' /proc/meminfo)
swap_used_kb=$(bc -l <<< "${swap_total_kb} - ${swap_free_kb}")
swap_used_percent=$(bc -l <<< "(${swap_used_kb}/${swap_total_kb})*100")
swap_used_percent=${swap_used_percent/.*/}

load=$(awk '{print $1}' /proc/loadavg)
load=${load/.*/}

mem_spark="#[fg=green]${spark_percent_00}#[fg=default]"
if [[ $mem_used_percent -ge 12 ]]; then mem_spark="#[fg=green]${spark_percent_12}#[fg=default]"; fi
if [[ $mem_used_percent -ge 25 ]]; then mem_spark="#[fg=green]${spark_percent_25}#[fg=default]"; fi
if [[ $mem_used_percent -ge 37 ]]; then mem_spark="#[fg=green]${spark_percent_37}#[fg=default]"; fi
if [[ $mem_used_percent -ge 50 ]]; then mem_spark="#[fg=yellow]${spark_percent_50}#[fg=default]"; fi
if [[ $mem_used_percent -ge 62 ]]; then mem_spark="#[fg=yellow]${spark_percent_62}#[fg=default]"; fi
if [[ $mem_used_percent -ge 75 ]]; then mem_spark="#[fg=yellow]${spark_percent_75}#[fg=default]"; fi
if [[ $mem_used_percent -ge 87 ]]; then mem_spark="#[fg=red]${spark_percent_87}#[fg=default]"; fi

cpu_spark="#[fg=green]${spark_percent_00}#[fg=default]"
if [[ $cpu_used_percent -ge 12 ]]; then cpu_spark="#[fg=green]${spark_percent_12}#[fg=default]"; fi
if [[ $cpu_used_percent -ge 25 ]]; then cpu_spark="#[fg=green]${spark_percent_25}#[fg=default]"; fi
if [[ $cpu_used_percent -ge 37 ]]; then cpu_spark="#[fg=green]${spark_percent_37}#[fg=default]"; fi
if [[ $cpu_used_percent -ge 50 ]]; then cpu_spark="#[fg=yellow]${spark_percent_50}#[fg=default]"; fi
if [[ $cpu_used_percent -ge 62 ]]; then cpu_spark="#[fg=yellow]${spark_percent_62}#[fg=default]"; fi
if [[ $cpu_used_percent -ge 75 ]]; then cpu_spark="#[fg=yellow]${spark_percent_75}#[fg=default]"; fi
if [[ $cpu_used_percent -ge 87 ]]; then cpu_spark="#[fg=red]${spark_percent_87}#[fg=default]"; fi

swap_spark="#[fg=green]${spark_percent_00}#[fg=default]"
if [[ $swap_used_percent -ge 12 ]]; then swap_spark="#[fg=green]${spark_percent_12}#[fg=default]"; fi
if [[ $swap_used_percent -ge 25 ]]; then swap_spark="#[fg=green]${spark_percent_25}#[fg=default]"; fi
if [[ $swap_used_percent -ge 37 ]]; then swap_spark="#[fg=green]${spark_percent_37}#[fg=default]"; fi
if [[ $swap_used_percent -ge 50 ]]; then swap_spark="#[fg=yellow]${spark_percent_50}#[fg=default]"; fi
if [[ $swap_used_percent -ge 62 ]]; then swap_spark="#[fg=yellow]${spark_percent_62}#[fg=default]"; fi
if [[ $swap_used_percent -ge 75 ]]; then swap_spark="#[fg=yellow]${spark_percent_75}#[fg=default]"; fi
if [[ $swap_used_percent -ge 87 ]]; then swap_spark="#[fg=red]${spark_percent_87}#[fg=default]"; fi

load_spark="#[fg=green]${load}#[fg=default]"
if [[ $load -ge 1 ]]; then load_spark="#[fg=yellow]${load}#[fg=default]"; fi
if [[ $load -ge 2 ]]; then load_spark="#[fg=yellow]${load}#[fg=default]"; fi
if [[ $load -ge 3 ]]; then load_spark="#[fg=yellow]${load}#[fg=default]"; fi
if [[ $load -ge 4 ]]; then load_spark="#[fg=yellow]${load}#[fg=default]"; fi
if [[ $load -ge 5 ]]; then load_spark="#[fg=red]${load}#[fg=default]"; fi
if [[ $load -ge 6 ]]; then load_spark="#[fg=red]${load}#[fg=default]"; fi
if [[ $load -ge 7 ]]; then load_spark="#[fg=red]${load}#[fg=default]"; fi
if [[ $load -ge 8 ]]; then load_spark="#[fg=red]${load}#[fg=default]"; fi

if ${SHOW_PERCENTS} ; then
  printf "[%s/%s/%s/%s]\n" $cpu_used_percent $mem_used_percent $swap_used_percent $load
fi
if ${SHOW_SPARKS} ; then
  printf "[%s%s%s%s]\n" $cpu_spark $mem_spark $swap_spark $load_spark
fi
