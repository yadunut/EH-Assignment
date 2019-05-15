# Ethical Hacking Assignment 1

This is a demo of using a malicious openvpn configuration to gain access to a linux system.

In Openvpn configuration files, in the up command, arbitrary code can be run. This is a 'feature' of the software that I will be using maliciously.

## Steps

When the user runs the program, it opens up an OpenVPN connection to the server. The server has a static IP of 10.8.0.1. The up command downloads the script `script.sh` from this github repository.

### The Script

The script checks if it is running as root. If it isn't, It'll check the linux kernel version. If it is within the range for a working dirtycow exploit, it will download, compile and run the exploit to gain root.

If it is not able to attain root, it will continue on with the program.

It checks whether the `shell.elf` executable already exists in the system. If not, it downloads the meterpreter reverse shell executable `shell.elf` from this repo.

It attempts to persist this shell access through init scripts (WIP)

## Issues faced

For some weird reason, I couldn't access the STDIN of the root shell created by the dirtycow exploit. Thus, privilege escalation has to be done manually from the metasploit shell. However, the dirtycow exploit binary should be in the TMP folder of the system
