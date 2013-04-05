
# Backup Plan
==============

## Directories

- documents.iso.gpg
- Coding_dir
- Books_dir

## Conf_files

- .bashrc
- .vim
- .emacs
- startup.sh
- tables.sh
- iptables.conf
- user_chrome.css
- xorg.conf
- synaptics
- wpa_supplicant
- pkeys
- awesome.conf
- awesome / rc.lua
- awesome.theme
- sources.conf

## Lists

- package_list
- services_list
- gem_list
- /usr/local/
- /rc.d/
- ls -la ~

## Environment

- git
- mongodb
- redis
- ruby
- gem
- rake
- bundler
- heroku
- chef

## Applications

- emacs
- firefox
- thunderbird
- transmission
- filezilla
- sakura
- mplayer
- sublime_text
- libreoffice
- geany
- wireshark
- googlechrome
- gnugo, gnushogi
- skype
- gpg, ssh, geniso, ...
- comix
- awesome

## Bookmarks

- bookmarks
- plugin_list
- addon_list
- rss

## Ubuntu :: Installation from Internet

Download the appropriate initrd.gz and linux files for your architecture and distribution from

[netboot](http://cdimage.ubuntu.com/netboot/)
    
Save them somewhere that grub can read from. Inside /boot is a fine place. (These files are quite small, under 10MB for either architecture.) 

Reboot your computer and press ESC if necessary to enter the grub menu (press Shift if you use grub2). Now we will get grub to boot from the files you just downloaded.

Press `c` to get a grub command prompt. Type each of the following lines: 

`root=(hd0,0)`

Replace the root partition with the drive and partition on which your `/boot` is located.

In Grub2, the default for Ubuntu 10.04 LTS and onwards

` linux /boot/path/to/linux`

` initrd /boot/path/to/initrd.gz`

Replace these paths with the actual paths where you saved the files. If you saved them directy in /boot, the paths will be simply kernel /boot/linux and initrd /boot/initrd.gz.

` boot `

Your system should now boot into the Ubuntu installer. Follow the instructions from there. 

## Installation from MinimalCD

[mini.iso](http://archive.ubuntu.com/ubuntu/dists/quantal/main/installer-i386/current/images/netboot/mini.iso)

32-bit PC (x86):

```
    Ubuntu 12.10 "Quantal Quetzal" Minimal CD 28MB (MD5: f79bf7fc8acf1a0d43563c24500a6a07, SHA1: cc5cf5b03e0b82a5e2e8098531ce4943cf7f786b) 
```

.
