#!/bin/bash

arch=$(uname -a)
printf "#Architecture: $arch\n"

pcpu=$(cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l)
printf "#CPU physical: $pcpu\n"

vcpu=$(cat /proc/cpuinfo | grep "processor" | sort | uniq | wc -l)
printf "#vCPU: $vcpu\n"

fram=$(free -m | grep Mem | awk '{print $2}')
uram=$(free -m | grep Mem | awk '{print $3}')
pram=$(free -m | grep Mem | awk '{print $3/$2 * 100}')
printf "#Memory Usage: $uram/$fram%s (%.2f%%)\n" "MB" "$pram"

sdisk=$(df -h --total | awk END'{print $2}' | cut -d G -f1)
udisk=$(df -h --total | awk END'{print $3}' | cut -d G -f1)
pdisk=$(df -h --total | awk END'{print $3/$2 * 100}')
printf "#Disk Usage: %.1f/%.1fGb (%.2f%%)\n" "$udisk" "$sdisk" "$pdisk"

#cmd1=$(mpstat | tail -n 1 | awk '{print $4}')
#cmd2=$(mpstat | tail -n 1 | awk '{print $6}')
#cmd3=$(echo "$cmd1 + $cmd2" | bc)
#printf "#CPU load: $cmd3%%\n"

cpul=$(mpstat | tail -1 | awk '{print $4 + $6}')
printf "#CPU load: %.1f%%\n" "$cpul"

boot=$(who -b | awk '{print $3" "$4}')
printf "#Last boot: $boot\n"

lvm=$(lsblk | grep "lvm" | wc -l)
if [ $lvm -eq 0 ]
then
        printf "#LVM use: no\n"
else
        printf "#LVM use: yes\n"
fi

ctcp=$(ss -t -a | grep -c ESTAB)
printf "#Connections TCP: $ctcp %s\n" "ESTABLISHED"

usr=$(users | wc -w)
printf "#User log: $usr\n"

ip=$(hostname -I | awk '{print $1}')
#ip2=$(ip address | grep "enp" | grep "inet" | awk '{print $2}' | cut -d / -f1)
mac=$(ip address | grep "ether" | awk '{print $2}')
printf "#Network: IP $ip ($mac)\n"

sudo=$(cat /var/log/sudo/sudo.log | grep COMMAND | wc -l)
printf "Sudo: $sudo\n"