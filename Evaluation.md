# Few Evaluation Notes

### User and Group

  - `adduser <new_username>` to create a new user
  - `groupadd evaluation` to create evaluation group
  - `sudo usermod -aG evaluation,user42 <new_username>` to add new user to evaluation and user42
  - `getent group evaluation` or `getent group user42` (to check who is in the group)
  - `groups <new_username>` to check all the groups the user is in

---

### Check SSH

  - `sudo systemctl status ssh` or `sudo service sshd status` to check status

---

### UFW Rules

  - `sudo ufw status numbered` to show ufw status
  - `sudo ufw allow 8080`
  - `sudo ufw status numbered` to show ufw status
  - `sudo ufw delete allow 8080` to delete the port 8080

  - `sudo vim /etc/ssh/sshd_config`
  - Remove comment from `#Port22` and change it to `Port4242`
  - Recome comment from `#PermitRootLogin` and change it to `PermitRootLogin no`
  - `sudo systemctl restart ssh` to restart ssh after the changes

---

### Change the machine hostname

  - `hostname` to check hostname
  - `sudo hostnamectl set-hostname <new_hostname>` to change hostname
  - if also works to edit `/etc/hosts` and `/etc/hostname`, make sure to open the editor with sudo
  - `sudo reboot` for the change to take place

---

### Password

  - `sudo vim /etc/login.defs` go to line 165, or search for PASS_MAX_DAYS
  - use `chage -l <username>` to check if both <username> and root have the 30 MAX and 2 MIN set
  - In `sudo vim /etc/pamn.d/common-password` check show that all the password rules are there
  - `maxrepeat=3` (maximum of 3 characters can be repeated in a row)
  - `minlen=10` (minimum 10 characters on the password)
  - `ucredit=-1 lcredit=-1 dcredit=-1` (to force at least one uppercase, lowercase and digit in password)
  - `difok=7` (password must have at least 7 different characters from last password)
  - `reject_username` (no username allowed on password)
  - `enforce_for_root` (add the rule to root user as well)

--- 

### Sudo Visudo

  - use `sudo visudo`
  - `Defaults  badpass_message="Wrong Password!"`
  - `Defaults  passwd_tries=3`
  - `Defaults  iolog_dir="/var/log/sudo"`
  - `Defaults  logfile="/var/log/sudo/sudo.logs"`
  - `Defaults  log_input`
  - `Defaults  log_output`
  - `Defaults  requiretty`

---

### Crontab

  - `sudo crontab -e` show crontab rule
  - Your crontab will look something like this `*/10 * * * * bash /usr/local/bin/monitoring.sh | wall`
  - Crontab has 5 fields and they refer to: (minutes) (hour) (days) (month) (day_of_the_week)
  - */10 means in an interval of every 10 minutes. if we placed only 10, if would mean in the 10th minute of every hour
  - This for example: 15,20,35 16 * * 0,6 means: on minute 15, 20 and 35, at 4 PM, only on sunday and saturday
  - To change it to 1 min, just change 10 by 1

### Stop Cron

  - `sudo /etc/init.d/cron stop` to stop cron without changing cron configuration
  - `sudo systemctl restart cron.service` to activate cron again

### Quick Monitoring.sh Explanation

  - `uname -a` just prints system information -a mean `--all`
  - `/proc/cpuinfo`has the info for the cpu processors and we're just sorting and selecting the data into lines, and printing line count
  - `free -m` display amount of free and used memory, then qwe simply print the correct collum with awk, -m shows in megabytes
  - `df` df just shows the ammount of space available on the system, -h just parse the information into "human readable", pritns in power of 1024, --total creates a new row with the total amount
  - `mpstat` shows processor related statistics, we take the last line and print the fiels which are being used by us
  - `who -b` who show who is logged in, -b flag is for last system boot
  - `lsblk` shows block devices, then we just check if there is lvm in there
  - `ss` shows socket statistics, we search for tcp connections and print it
  - `users` show users logged to the machine, `wc -w` count words
  - `hostname -I` gives us the IP, and with `ip address` we get the MAC address
  - `cat sudo.log`, grep it to just get the ammount of commands executed and print the line count 
