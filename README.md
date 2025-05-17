# Born2beRoot

### Notes
- The aim of this project is to teach us how to configure our own Server through a Virtual Machine
- This is just my personal notes on which steps I did to configure my Virtual Machine
- I was doing all the initial config as root, if you don't do it as root, you need to edit sudoers and add yourself to sudo group as one of the first steps

### First things to setup and sudo install

  - `lsblk`on terminal to see partitions
  - `login as root or use 'su -' to enter as root`
  - `apt-get update -y`
  - `apt-get upgrade -y`
  - `apt-get install sudo`
  - `sudo apt-get install git`
  - `sudo apt-get install vim`

---

### Connect to SSH

  - `sudo apt-get install openssh-server`
  - `sudo systemctl status ssh` or `sudo service sshd status` to check status
  - `sudo vim /etc/ssh/sshd_config`
  - Remove comment from `#Port22` and change it to `Port4242`
  - Recome comment from `#PermitRootLogin` and change it to `PermitRootLogin no`
  - `sudo systemctl restart ssh` to restart ssh after the changes

---

### Install UFW (Uncomplicated Firewall)

  - `sudo apt-get install ufw`
  - `sudo ufw enable` (to turn it on)
  - `sudo ufw disable` (to turn if off)
  - `sudo ufw status numbered` (show status of ufw and allowed ports)
  - `sudo ufw allow 4242` (allow port 4242)
  - `sudo ufw delete <port_number>`(to delete an allowed port)
  - `sudo ufw delete allow 8080` delete everything from the allow (both instances)
  - `sudo ufw deny 8080` (deny port 8080)

---

### Connect to the VM via Terminal

  - go to the VM Box, Settings, Network, change NAT to Bridged Adapter
  - `sudo reboot` to reboot the VM
  - in the VM use `hostname -I` to get your IP
  - in the Terminal, type `ssh <username>@<VM IP> -p 4242`

---

### Arranging Groups

  - use `groupadd user42` (to create a group named "user42")
  - `sudo usermod -aG sudo,user42 <username>` (to add your user to both groups)
  - `getent group sudo` or `getent group user42` (to check who is in the group)

---

### Creating sudo.log

  - `cd /var/log`
  - `mkdir sudo`
  - `cd sudo`
  - `touch sudo.log`
  - `chmod 644 sudo.log`

---

### Password Max and Min Days

  - `sudo vim /etc/login.defs` go to line 165, or search for PASS_MAX_DAYS
  - set `PASS_MAX_DAYS to 30`
  - set `PASS_MIN_DAYS to 2`
  - use `chage -M 30 <username>` (apply MAX rule to the user)
  - use `chage -m 2 <username>` (apply MIN rule to the user)
  - REMEMBER TO EXECUTE BOTH COMMANDS FOR ROOT AS WELL !
  - use `chage -l <username>` to check if both <username> and root have the 30 MAX and 2 MIN set
  - you can use `passwd <username>` to change your password, if you wish

### Password Quality

  - `sudo apt-get install libpam-pwquality`
  - In `sudo vim /etc/pamn.d/common-password` you need to add a few commands after `retry=3`:
  - `maxrepeat=3` (maximum of 3 characters can be repeated in a row)
  - `minlen=10` (minimum 10 characters on the password)
  - `ucredit=-1 lcredit=-1 dcredit=-1` (to force at least one uppercase, lowercase and digit in password)
  - `difok=7` (password must have at least 7 different characters from last password)
  - `reject_username` (no username allowed on password)
  - `enforce_for_root` (add the rule to root user as well)
  - `sudo reboot` to reboot the VM

--- 

### Sudo Visudo

  - use `sudo visudo`
  - Gotta add a list of things, at the beginning below `Defaults  secure_path`
  - `Defaults  badpass_message="Wrong Password!"`
  - `Defaults  passwd_tries=3`
  - `Defaults  iolog_dir="/var/log/sudo"`
  - `Defaults  logfile="/var/log/sudo/sudo.logs"`
  - `Defaults  log_input`
  - `Defaults  log_output`
  - `Defaults  requiretty`
  - go to the line where there is `root  ALL(ALL:ALL) ALL`
  - put bellow it `<username>  ALL(ALL:ALL) ALL`

---

### Crontab

  - `sudo crontab -e`
  - in the first line of the file, type this: `*/10 * * * * bash <path to your script here>`
  - so for example, in my case `*/10 * * * * bash /usr/local/bin/monitoring.sh | wall`
  - I do pipe it to wall, because I don't have wall in my monitoring script
  - Crontab has 5 fields and they refer to: (minutes) (hour) (days) (month) (day_of_the_week)
  - */10 means in an interval of every 10 minutes. if we placed only 10, if would mean in the 10th minute of every hour
  - This for example: 15,20,35 16 * * 0,6 means: on minute 15, 20 and 35, at 4 PM, only on sunday and saturday

---

### Monitoring script

  - first we need to install two things `sudo apt-get install bc sysstat`
  - the script need to use wall to send it to all terminals, you can use wall in your script, or pipe it to wall in the crontab
  - `cd /usr/local/bin`
  - `vim monitoring.sh`
  - `chmod 755 monitoring.sh`
  - this is my current [monitoring.sh](https://github.com/Chaudbrush/Born2beRoot/blob/main/monitoring.sh)

### Script on Reboot

  - No solution yet
  - `@reboot`on crontab doesn't work
  - [try this](https://bugs.debian.org/cgi-bin/bugreport.cgi?att=0;bug=635473;msg=70)
  - [try this](https://github.com/HEADLIGHTER/Born2BeRoot-42/blob/main/rebootfix.txt)
---

### Signature

  - turn off your VM
  - open your Terminal, go to the VM folder (~/sgoinfre/Born2beRoot)
  - shasum orn2beRoot.vdi
  - copy and save it in a .txt `c9af2694e4bc28d1403e307a3407c47c9f489489`

---

### Best Guide References

  - [lbordonal](https://github.com/lbordonal/01-Born2beroot/wiki)
  - [Thuggonaut](https://github.com/Thuggonaut/42IC_Ring01_Born2beRoot)
  - [chlimous](https://github.com/chlimous/42-born2beroot_guide/tree/main)
  - [yasmineww](https://github.com/yasmineww/Born2beRoot/tree/main)
  - [HEADLIGHTER](https://github.com/HEADLIGHTER/Born2BeRoot-42/tree/main)
  - [Marymota](https://github.com/Marymota/born2beroot/blob/main/born2beroot.png)

### Best Research Reference

  - [miro.com](https://miro.com/app/board/uXjVLzBvyb8=/)
  - [48d31kh413k](https://github.com/48d31kh413k/1337-Born2beRoot-42)
