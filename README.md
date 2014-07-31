## The Seedbox From Scratch Script
#### Current version = 2.1.9
#### Last stable version = 2.1.8

This is a script I've being working for some time now. I decided to share it here because it has some good things to add:

* A multi-user environment, you'll have scripts to add and delete users.
* Linux Quota, to control how much space every user can use in your box.

## Installed software
* ruTorrent 3.4 + official plugins
* rTorrent 0.9.3 or 0.9.4 (you can choose, downgrade and upgrade at any time)
* Deluge 1.3.5 or 0.9.3 (you can choose, downgrade and upgrade at any time)
* libTorrrent 0.13.2 or 0.12.9
* mktorrent
* Fail2ban - to avoid apache and ssh exploits. Fail2ban bans IPs that show malicious signs -- too many password failures, seeking for exploits, etc.
* Apache (SSL)
* OpenVPN
* PHP 5 and PHP-FPM (FastCGI to increase performance)
* Linux Quota
* SSH Server (for SSH terminal and sFTP connections)
* vsftpd (Very Secure FTP Deamon)
* IRSSI
* Webmin (use it to manage your users quota)
* sabnzbd: http://sabnzbd.org/
* Rapidleech (http://www.rapidleech.com)
* Bittorent SYnc (Follow the instructions)

## Main ruTorrent plugins
autotoolscpuload, diskspace, erasedata, extratio, extsearch, feeds, filedrop, filemanager, geoip, history, logoff, mediainfo, mediastream, rss, scheduler, screenshots, theme, trafic and unpack

## Additional ruTorrent plugins
* Autodl-IRSSI (with an updated list of trackers)
* A modified version of Diskpace to support quota (by me)
* Filemanager (modified to handle rar, zip, unzip, tar and bzip)
* Fileupload
* Fileshare Plugin (http://forums.rutorrent.org/index.php?topic=705.0)
* MediaStream (to watch your videos right from your seedbox)
* Logoff
* Theme: Oblivion (_not forced anymore_)

## Before installation
You need to have a "blank" server installation, if you have a Kimsufi, just do a "reinstall" on it, using debian 7 x64, the script is also tested on ramnode VPS's and online.net / oneprovider dedicated servers. 
After that access your box using a SSH client, like PuTTY.

## Warnings

####If you don't know Linux ENOUGH:

DO NOT use capital letters, all your usernames should be written in lowercase.

From NOTOS original script : 
> DO NOT upgrade anything in your box, ask in the thread before even thinking about it.

Well, you normaly should be able to update your packages with a basic 
sudo apt-get update && sudo apt-get upgrade
but if something goes wrong then search for the issue, open an issue here on github or if you have the solution, then request a pull ^^

DO NOT try to reconfigure packages using other tutorials.

## How to install
Just copy and paste those commands on your terminal (!! YOU NEED TO BE ROOT !!):

```
wget -N https://raw.github.com/imakiro/seedbox-from-scratch/v2.1.9/seedbox-from-scratch.sh --no-check-certificate
time bash ./seedbox-from-scratch.sh
```
if you decided to install bittorent Sync, do not forget to use :
```
sudo dpkg-reconfigure btsync
```
to setup bittorent sync as you wish.

####You must be logged as root to run this installation or use sudo on it.

## Commands
After installing you will have access to the following commands to be used directly in terminal
* restartSeedbox

The following commands are in /etc/seedbox-from-scratch/ you can invoke them from there:
* createSeedboxUser
* deleteSeedboxUser
* changeUserPassword
* installRapidleech
* installOpenVPN
* installSABnzbd
* installWebmin
* installDeluge
* updategitRepository
* removeWebmin
* upgradeRTorrent
* installRTorrent
* While executing them, if sudo is needed, they will ask for a password.

## Services
To access services installed on your new server point your browser to the following address:
```
https://<Server IP or Server Name>/seedboxInfo.php
```

####OpenVPN
To use your VPN you will need a VPN client compatible with [OpenVPN](http://openvpn.net/index.php?option=com_content&id=357), necessary files to configure your connection are in this link in your box:
```
http://<Server IP or Server Name>/rutorrent/vpn.zip` and use it in any OpenVPN client.
```

## Supported and tested servers (imakiro's fork)
DEBIAN 7 x64 .... other distros are NOT tested and might not work

## Quota
Quota is disabled by default in your box. To enable and use it, you'll have to open Webmin, using the address you can find in one of the tables box above this. After you sucessfully logged on Webmin, enable it by clicking

System => Disk and Network Filesystems => /home => Use Quotas? => Select "Only User" => Save

Now you'll have to configure quota for each user, doing

System => Disk Quotas => /home => <username> => Configure the "Soft kilobyte limit" => Update

As soon as you save it, your seedbox will also update the available space to all your users.

## Changelog
Take a look at seedbox-from-scratch.sh, it's all there.

## Support

There is no real support for this script, but people is talking a lot about it [here](http://www.torrent-invites.com/seedbox-tutorials/207635-seedbox-scratch-script-multi-user-quota-sabnzbd-deluge.html) and you may find solutions for your problems in the thread.


## License

Copyright (c) 2013 Notos (https://github.com/Notos/) & imakiro (https://github.com/imakiro/)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. 

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--> Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
