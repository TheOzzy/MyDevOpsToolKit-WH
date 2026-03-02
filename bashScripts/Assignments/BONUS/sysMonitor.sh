#!/bin/bash

echo "
Welcome to the System Monitoring Script

Here is where you'll see your all of your core systems in action from disk & memory to CPU usage.
"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
LOG="sys_logfiles/log_$TIMESTAMP.txt"

#CPU Usage Stats
CPU_STAT=$(top -bn1 | grep "Cpu(s)" | awk '{print 100 - $8 "%"}')
echo -e "CPU Usage: $CPU_STAT \n" >> $LOG

#Storage Usage Stats
DISK_STAT=$(df -h)
echo -e "Disk Space available on the machine
$DISK_STAT \n" >> $LOG

#RAM Usage Stats
RAM_STAT=$(free -h)
echo -e "Random Access Memory [R.A.M] Usage" >> $LOG
echo "$RAM_STAT" >> $LOG

#Shows All usages sorted by amount of CPU Usage
echo -e "
Top 5 Resource-Hungry Processes:" >> $LOG
TOP5=$(ps -eo user,pid,pcpu,pmem,comm --sort=-pcpu | head -n 6 | column -t)
echo "$TOP5" >> $LOG

cat $LOG
echo -e "
All logs are saved in the sys_logfiles directory with the approriate time/date of creation"



