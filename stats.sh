#!/bin/bash

SHOW_PERCENTS=false
SHOW_SPARKS=true

# MemTotal:        8052076 kB
# MemFree:         2372916 kB
# MemAvailable:    5687644 kB
# Buffers:            4400 kB
# Cached:          3026332 kB

tput_reset="$(tput sgr0)"
tput_set_bold="$(tput bold)"
tput_set_dim="$(tput dim)"
tput_set_ul="$(tput smul)"
tput_unset_ul="$(tput rmul)"
tput_set_reverse="$(tput rev)"
tput_set_standout="$(tput smso)"
tput_unset_standout="$(tput rmso)"
tput_bg_black="$(tput setab 0)"
tput_bg_red="$(tput setab 1)"
tput_bg_green="$(tput setab 2)"
tput_bg_yellow="$(tput setab 3)"
tput_bg_blue="$(tput setab 4)"
tput_bg_purple="$(tput setab 5)"
tput_bg_cyan="$(tput setab 6)"
tput_bg_white="$(tput setab 7)"
tput_fg_black="$(tput setaf 0)"
tput_fg_red="$(tput setaf 1)"
tput_fg_green="$(tput setaf 2)"
tput_fg_yellow="$(tput setaf 3)"
tput_fg_blue="$(tput setaf 4)"
tput_fg_purple="$(tput setaf 5)"
tput_fg_cyan="$(tput setaf 6)"
tput_fg_white="$(tput setaf 7)"

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

mem_spark=${tput_fg_green}${spark_percent_00}${tput_reset}
if [[ $mem_used_percent -gt 12 ]]; then mem_spark=${tput_fg_green}${spark_percent_12}${tput_reset}; fi
if [[ $mem_used_percent -gt 25 ]]; then mem_spark=${tput_fg_green}${spark_percent_25}${tput_reset}; fi
if [[ $mem_used_percent -gt 37 ]]; then mem_spark=${tput_fg_green}${spark_percent_37}${tput_reset}; fi
if [[ $mem_used_percent -gt 50 ]]; then mem_spark=${tput_fg_yellow}${spark_percent_50}${tput_reset}; fi
if [[ $mem_used_percent -gt 62 ]]; then mem_spark=${tput_fg_yellow}${spark_percent_62}${tput_reset}; fi
if [[ $mem_used_percent -gt 75 ]]; then mem_spark=${tput_fg_yellow}${spark_percent_75}${tput_reset}; fi
if [[ $mem_used_percent -gt 87 ]]; then mem_spark=${tput_fg_red}${spark_percent_87}${tput_reset}; fi

cpu_spark=${tput_fg_green}${spark_percent_00}${tput_reset}
if [[ $cpu_used_percent -gt 12 ]]; then cpu_spark=${tput_fg_green}${spark_percent_12}${tput_reset}; fi
if [[ $cpu_used_percent -gt 25 ]]; then cpu_spark=${tput_fg_green}${spark_percent_25}${tput_reset}; fi
if [[ $cpu_used_percent -gt 37 ]]; then cpu_spark=${tput_fg_green}${spark_percent_37}${tput_reset}; fi
if [[ $cpu_used_percent -gt 50 ]]; then cpu_spark=${tput_fg_yellow}${spark_percent_50}${tput_reset}; fi
if [[ $cpu_used_percent -gt 62 ]]; then cpu_spark=${tput_fg_yellow}${spark_percent_62}${tput_reset}; fi
if [[ $cpu_used_percent -gt 75 ]]; then cpu_spark=${tput_fg_yellow}${spark_percent_75}${tput_reset}; fi
if [[ $cpu_used_percent -gt 87 ]]; then cpu_spark=${tput_fg_red}${spark_percent_87}${tput_reset}; fi

swap_spark=${tput_fg_green}${spark_percent_00}${tput_reset}
if [[ $swap_used_percent -gt 12 ]]; then swap_spark=${tput_fg_green}${spark_percent_12}${tput_reset}; fi
if [[ $swap_used_percent -gt 25 ]]; then swap_spark=${tput_fg_green}${spark_percent_25}${tput_reset}; fi
if [[ $swap_used_percent -gt 37 ]]; then swap_spark=${tput_fg_green}${spark_percent_37}${tput_reset}; fi
if [[ $swap_used_percent -gt 50 ]]; then swap_spark=${tput_fg_yellow}${spark_percent_50}${tput_reset}; fi
if [[ $swap_used_percent -gt 62 ]]; then swap_spark=${tput_fg_yellow}${spark_percent_62}${tput_reset}; fi
if [[ $swap_used_percent -gt 75 ]]; then swap_spark=${tput_fg_yellow}${spark_percent_75}${tput_reset}; fi
if [[ $swap_used_percent -gt 87 ]]; then swap_spark=${tput_fg_red}${spark_percent_87}${tput_reset}; fi

load_spark=${tput_fg_green}${load}${tput_reset}
if [[ $load -gt 0 ]]; then load_spark=${tput_fg_yellow}${load}${tput_reset}; fi
if [[ $load -gt 1 ]]; then load_spark=${tput_fg_yellow}${load}${tput_reset}; fi
if [[ $load -gt 2 ]]; then load_spark=${teut_fg_yellow}${load}${tput_reset}; fi
if [[ $load -gt 3 ]]; then load_spark=${tput_fg_yellow}${load}${tput_reset}; fi
if [[ $load -gt 4 ]]; then load_spark=${tput_fg_red}${load}${tput_reset}; fi
if [[ $load -gt 5 ]]; then load_spark=${tput_fg_red}${load}${tput_reset}; fi
if [[ $load -gt 6 ]]; then load_spark=${tput_fg_red}${load}${tput_reset}; fi
if [[ $load -gt 7 ]]; then load_spark=${tput_fg_red}${load}${tput_reset}; fi

if ${SHOW_PERCENTS} ; then
  printf "[%s/%s/%s/%s]\n" $cpu_used_percent $mem_used_percent $swap_used_percent $load
fi
if ${SHOW_SPARKS} ; then
  printf "[%s%s%s%s]\n" $cpu_spark $mem_spark $swap_spark $load_spark
fi
