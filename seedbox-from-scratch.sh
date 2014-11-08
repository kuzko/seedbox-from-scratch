#!/bin/bash
#
#
# The Seedbox From Scratch Script
#   By Notos ---> https://github.com/Notos/
#	Modified By imakiro --->https://gitub.com/imakiro/
#
######################################################################
#
#  Copyright (c) 2013 Notos (https://github.com/Notos/) 
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: 
#
#  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. 
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
#  --> Licensed under the MIT license: http://www.opensource.org/licenses/mit-license.php
#
######################################################################
#
#  git clone -b master https://github.com/Notos/seedbox-from-scratch.git /etc/seedbox-from-scratch
#  sudo git stash; sudo git pull
#
#
  SBFSCURRENTVERSION1=2.1.9
  FFMPEGVERSION=2.4.2
  OS1=$(lsb_release -si)
#
# Changelog
#
#  Version 2.1.9 (not stable yet)
#   Dec 26 2012 17:37 GMT-3
#     - RTorrent 0.9.3 support (optionally installed)
#     - New installRTorrent script: move to RTorrent 0.9.3 or back to 0.9.2 at any time
#     - Deluge v1.3.5 multi-user installation script (it will install the last stable version): installDeluge
#     - Optionally install Deluge when you first install your seedbox-from-scratch box
#
#  Version 2.1.8 (stable)
#     - Bug fix release
#
#  Version 2.1.4 (stable)
#   Dec 11 2012 2:34 GMT-3
#     - Debian 6 (Squeeze) Compatibile
#     - Check if user root is running the script
#     - vsftpd - FTP access with SSL (AUTH SSL - Explicit)
#     - vsftpd downgraded on Ubuntu to 2.3.2 (oneiric)
#     - iptables tweaked to make OpenVPN work as it should both on Ubuntu and Debian
#     - SABnzbd is now being installed from sources and works better
#     - New script: changeUserPassword <username> <password> <realm> --- example:  changeUserPassword notos 133t rutorrent
#     - restartSeedbox now kill processes even if there are users attached on screens
#     - Installs rar, unrar and zip separately from main installations to prevent script from breaking on bad sources from non-OVH providers
#
#  Version 2.1.2 (stable)
#   Nov 16 2012 20:48 GMT-3
#     - new upgradeSeedbox script (to download git files for a new version, it will not really upgrade it, at least for now :)
#     - ruTorrent fileshare Plugin (http://forums.rutorrent.org/index.php?topic=705.0)
#     - rapidleech (http://www.rapidleech.com/ - http://www.rapidleech.com/index.php?showtopic=2226|Go ** tutorial: http://www.seedm8.com/members/knowledgebase/24/Installing-Rapidleech-on-your-Seedbox.html
#
#  Version 2.1.1 (stable)
#   Nov 12 2012 20:15
#     - OpenVPN was not working as expected (fixed)
#     - OpenVPN port now is configurable (at main install) and you can change it anytime before reinstalling: /etc/seedbox-from-scratch/openvpn.info
#
#  Version 2.1.0 (not stable yet)
#   Nov 11 2012 20:15
#     - sabnzbd: http://wiki.sabnzbd.org/install-ubuntu-repo
#     - restartSeedbox script for each user
#     - User info files in /etc/seedbox-from-scratch/users
#     - Info about all users in https://hostname.tld/seedboxInfo.php
#     - Password protected webserver Document Root (/var/www/)
#
#  Version 2.0.0 (stable)
#   Oct 31 2012 23:59
#     - chroot jail for users, using JailKit (http://olivier.sessink.nl/jailkit/)
#     - Fail2ban for ssh and apache - it bans IPs that show the malicious signs -- too many password failures, seeking for exploits, etc.
#     - OpenVPN (after install you can download your key from http://<IP address or host name of your box>/rutorrent/vpn.zip)
#     - createSeedboxUser script now asks if you want your user jailed, to have SSH access and if it should be added to sudoers
#     - Optionally install packages JailKit, Webmin, Fail2ban and OpenVPN
#     - Choose between RTorrent 0.8.9 and 0.9.2 (and their respective libtorrent libraries)
#     - Upgrade and downgrade RTorrent at any time
#     - Full automated install, now you just have to download script and run it in your box:
#        > wget -N https://raw.github.com/Notos/seedbox-from-scratch/v2.x.x/seedbox-from-scratch.sh
#        > time bash ~/seedbox-from-scratch.sh
#     - Due to a recent outage of Webmin site and SourceForge's svn repositories, some packages are now in git and will not be downloaded from those sites
#     - Updated list of trackers in Autodl-irssi
#     - vsftpd FTP Server (working in chroot jail)
#     - New ruTorrent default theme: Oblivion
#
#  Version 1.30
#   Oct 23 2012 04:54:29
#     - Scripts now accept a full install without having to create variables and do anything else
#
#  Version 1.20
#   Oct 19 2012 03:24 (by Notos)
#    - Install OpenVPN - (BETA) Still not in the script, just an outside script
#      Tested client: http://openvpn.net/index.php?option=com_content&id=357
#
#  Version 1.11
#   Oct 18 2012 05:13 (by Notos)
#    - Added scripts to downgrade and upgrade RTorrent
#
#    - Added all supported plowshare sites into fileupload plugin: 115, 1fichier, 2shared, 4shared, bayfiles, bitshare, config, cramit, data_hu, dataport_cz,
#      depositfiles, divshare, dl_free_fr, euroshare_eu, extabit, filebox, filemates, filepost, freakshare, go4up, hotfile, mediafire, megashares, mirrorcreator, multiupload, netload_in,
#      oron, putlocker, rapidgator, rapidshare, ryushare, sendspace, shareonline_biz, turbobit, uploaded_net, uploadhero, uploading, uptobox, zalaa, zippyshare
#
#  Version 1.10
#   06/10/2012 14:18 (by Notos)
#    - Added Fileupload plugin
#
#    - Added all supported plowshare sites into fileupload plugin: 115, 1fichier, 2shared, 4shared, bayfiles, bitshare, config, cramit, data_hu, dataport_cz,
#      depositfiles, divshare, dl_free_fr, euroshare_eu, extabit, filebox, filemates, filepost, freakshare, go4up, hotfile, mediafire, megashares, mirrorcreator, multiupload, netload_in,
#      oron, putlocker, rapidgator, rapidshare, ryushare, sendspace, shareonline_biz, turbobit, uploaded_net, uploadhero, uploading, uptobox, zalaa, zippyshare
#
#  Version 1.00
#   30/09/2012 14:18 (by Notos)
#    - Changing some file names and depoying version 1.00
#
#  Version 0.99b
#   27/09/2012 19:39 (by Notos)
#    - Quota for users
#    - Download dir inside user home
#
#  Version 0.99a
#   27/09/2012 19:39 (by Notos)
#    - Quota for users
#    - Download dir inside user home
#
#  Version 0.92a
#   28/08/2012 19:39 (by Notos)
#    - Also working on Debian now
#
#  Version 0.91a
#   24/08/2012 19:39 (by Notos)
#    - First multi-user version sent to public
#
#  Version 0.90a
#   22/08/2012 19:39 (by Notos)
#    - Working version for OVH Kimsufi 2G Server - Ubuntu Based
#
#  Version 0.89a
#   17/08/2012 19:39 (by Notos)
#
function getString
{
  local ISPASSWORD=$1
  local LABEL=$2
  local RETURN=$3
  local DEFAULT=$4
  local NEWVAR1=a
  local NEWVAR2=b
  local YESYES=YESyes
  local NONO=NOno
  local YESNO=$YESYES$NONO

  while [ ! $NEWVAR1 = $NEWVAR2 ] || [ -z "$NEWVAR1" ];
  do
    clear
    echo "#"
    echo "#"
    echo "# The Seedbox From Scratch Script"
    echo "#   By Notos ---> https://github.com/Notos/"
    echo "#  modified by imakiro for debian7"
    echo "#"
    echo "#"
    echo

    if [ "$ISPASSWORD" == "YES" ]; then
      read -s -p "$DEFAULT" -p "$LABEL" NEWVAR1
    else
      read -e -i "$DEFAULT" -p "$LABEL" NEWVAR1
    fi
    if [ -z "$NEWVAR1" ]; then
      NEWVAR1=a
      continue
    fi

    if [ ! -z "$DEFAULT" ]; then
      if grep -q "$DEFAULT" <<< "$YESNO"; then
        if grep -q "$NEWVAR1" <<< "$YESNO"; then
          if grep -q "$NEWVAR1" <<< "$YESYES"; then
            NEWVAR1=YES
          else
            NEWVAR1=NO
          fi
        else
          NEWVAR1=a
        fi
      fi
    fi

    if [ "$NEWVAR1" == "$DEFAULT" ]; then
      NEWVAR2=$NEWVAR1
    else
      if [ "$ISPASSWORD" == "YES" ]; then
        echo
        read -s -p "Retype: " NEWVAR2
      else
        read -p "Retype: " NEWVAR2
      fi
      if [ -z "$NEWVAR2" ]; then
        NEWVAR2=b
        continue
      fi
    fi


    if [ ! -z "$DEFAULT" ]; then
      if grep -q "$DEFAULT" <<< "$YESNO"; then
        if grep -q "$NEWVAR2" <<< "$YESNO"; then
          if grep -q "$NEWVAR2" <<< "$YESYES"; then
            NEWVAR2=YES
          else
            NEWVAR2=NO
          fi
        else
          NEWVAR2=a
        fi
      fi
    fi
    echo "---> $NEWVAR2"

  done
  eval $RETURN=\$NEWVAR1
}
# 0.

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

clear

# 1.
apt-get update
apt-get --yes install aptitude
aptitude install -y lsb-release
locale-gen
#localhost is ok this rtorrent/rutorrent installation
IPADDRESS1=`/sbin/ifconfig eth0 | sed '/inet\ /!d;s/.*r://g;s/\ .*//g'`
CHROOTJAIL1=NO

#those passwords will be changed in the next steps
PASSWORD1=a
PASSWORD2=b

getString NO  "You need to create an user for your seedbox: " NEWUSER1
getString YES "Password for user $NEWUSER1: " PASSWORD1
getString NO  "public IP address of your seedbox: " IPADDRESS1 $IPADDRESS1
getString NO  "SSH port: " NEWSSHPORT1 21976
getString NO  "vsftp port (usually 21): " NEWFTPPORT1 21201
getString NO  "OpenVPN port: " OPENVPNPORT1 31195
#getString NO  "Do you want to have some of your users in a chroot jail? " CHROOTJAIL1 YES
getString NO  "Install Webmin? " INSTALLWEBMIN1 YES
getString NO  "Install Fail2ban? " INSTALLFAIL2BAN1 YES
getString NO  "Install OpenVPN? " INSTALLOPENVPN1 NO
getString NO  "Install SABnzbd? " INSTALLSABNZBD1 NO
getString NO  "Install Bittorent Sync ? " INSTALLBTSYNC YES
getString NO  "Install Rapidleech? " INSTALLRAPIDLEECH1 YES
getString NO  "Install Deluge? " INSTALLDELUGE1 NO
getString NO  "Wich RTorrent version would you like to install, '0.9.3' or '0.9.4' " RTORRENT1 0.9.4

if [ "$RTORRENT1" != "0.9.3" ] && [ "$RTORRENT1" != "0.9.4" ]; then
  echo "$RTORRENT1 typed is not 0.9.3 or 0.9.4 !"
  exit 1
fi

if [ "$INSTALLBTSYNC" = "YES" ]; then
	apt-key adv --keyserver keys.gnupg.net --recv-keys 6BF18B15
	CODENAME=$(lsb_release -cs | sed -n '/lucid\|precise\|quantal\|raring\|saucy\|trusty\|squeeze\|wheezy\|jessie\|sid/p')
	echo "" >> /etc/apt/sources.list
	echo "#### BitTorrent Sync - see: http://forum.bittorrent.com/topic/18974-debian-and-ubuntu-server-packages-for-bittorrent-sync-121-1/" >> /etc/apt/sources.list
	echo "## Run this command: apt-key adv --keyserver keys.gnupg.net --recv-keys 6BF18B15" >> /etc/apt/sources.list
	echo "deb http://debian.yeasoft.net/btsync ${CODENAME:-sid} main" >> /etc/apt/sources.list
	echo "deb-src http://debian.yeasoft.net/btsync ${CODENAME:-sid} main" >> /etc/apt/sources.list
	unset CODENAME
	apt-get update
	apt-get -y install btsync
fi

#preparing script and needed dependencies
echo "" >> /etc/apt/sources.list
echo "deb http://deb-multimedia.org wheezy main non-free" >> /etc/apt/sources.list
echo "deb-src http://deb-multimedia.org wheezy non-free" >> /etc/apt/sources.list
echo "deb http://http.debian.net/debian wheezy-backports main" >> /etc/apt/sources.list
apt-get --yes update
apt-get -y --force-yes install deb-multimedia-keyring
apt-get --yes update
apt-get --yes install whois sudo makepasswd git

rm -f -r /etc/seedbox-from-scratch
git clone -b v$SBFSCURRENTVERSION1 https://github.com/imakiro/seedbox-from-scratch.git /etc/seedbox-from-scratch
mkdir -p cd /etc/seedbox-from-scratch/source
mkdir -p cd /etc/seedbox-from-scratch/users

if [ ! -f /etc/seedbox-from-scratch/seedbox-from-scratch.sh ]; then
  clear
  clear
  echo Looks like somethig is wrong, this script was not able to download its whole git repository.
  set -e
  exit 1
fi

# 3.1

#show all commands
set -x verbose

# 4.
perl -pi -e "s/Port 22/Port $NEWSSHPORT1/g" /etc/ssh/sshd_config
perl -pi -e "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
perl -pi -e "s/#Protocol 2/Protocol 2/g" /etc/ssh/sshd_config
perl -pi -e "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config

groupadd sshdusers
echo "" | tee -a /etc/ssh/sshd_config > /dev/null
echo "UseDNS no" | tee -a /etc/ssh/sshd_config > /dev/null
echo "AllowGroups sshdusers" >> /etc/ssh/sshd_config
mkdir -p /usr/share/terminfo/l/
cp /lib/terminfo/l/linux /usr/share/terminfo/l/

service ssh restart

# 6.
#remove cdrom from apt so it doesn't stop asking for it
perl -pi -e "s/deb cdrom/#deb cdrom/g" /etc/apt/sources.list

#add non-free sources to Debian Squeeze# those two spaces below are on purpose
#perl -pi -e "s/wheezy main/wheezy  main contrib non-free/g" /etc/apt/sources.list
#perl -pi -e "s/wheezy-updates main/wheezy-updates  main contrib non-free/g" /etc/apt/sources.list

#ffmpeg from source dependencies
apt-get --yes install subversion unzip frei0r-plugins-dev aptitude libdc1394-22-dev libfaac-dev libmp3lame-dev libx264-dev libdirac-dev libxvidcore-dev libfreetype6-dev libvorbis-dev libgsm1-dev libopencore-amrnb-dev libopencore-amrwb-dev libopenjpeg-dev librtmp-dev libschroedinger-dev libspeex-dev libtheora-dev libva-dev libvpx-dev libvo-amrwbenc-dev libvo-aacenc-dev libaacplus-dev libbz2-dev libgnutls-dev libssl-dev libopenal-dev libv4l-dev libpulse-dev libmodplug-dev libass-dev libcdio-dev libcdio-cdda-dev libcdio-paranoia-dev libvdpau-dev libxfixes-dev libxext-dev libbluray-dev

# 7.
# update and upgrade packages

apt-get --yes update
apt-get --yes upgrade

# 8.
#install all needed packages


apt-get --yes install apache2 apache2-utils autoconf build-essential ca-certificates comerr-dev curl cfv quota mktorrent dtach htop irssi libapache2-mod-php5 libcloog-ppl-dev libcppunit-dev libcurl3 libcurl4-openssl-dev libncurses5-dev libterm-readline-gnu-perl libsigc++-2.0-dev libperl-dev openvpn libssl-dev libtool libxml2-dev ncurses-base ncurses-term ntp openssl patch libc-ares-dev pkg-config php5 php5-cli php5-dev php5-curl php5-geoip php5-mcrypt php5-gd php5-xmlrpc pkg-config python-scgi screen ssl-cert subversion texinfo unzip zlib1g-dev expect joe automake1.9 flex bison debhelper binutils-gold ffmpeg libarchive-zip-perl libnet-ssleay-perl libhtml-parser-perl libxml-libxml-perl libjson-perl libjson-xs-perl libxml-libxslt-perl libxml-libxml-perl libjson-rpc-perl libarchive-zip-perl tcpdump
cd /tmp/
wget http://znc.in/releases/znc-1.4.tar.gz
tar -xzvf znc*.*gz
cd znc*
./configure
make -j$(grep -c ^processor /proc/cpuinfo)
make install
if [ $? -gt 0 ]; then
  set +x verbose
  echo
  echo
  echo *** ERROR ***
  echo
  echo "Looks like somethig is wrong with apt-get install, aborting."
  echo
  echo
  echo
  set -e
  exit 1
fi
apt-get --yes install zip
apt-get --yes install python-software-properties

apt-get --yes install rar
if [ $? -gt 0 ]; then
 apt-get --yes install rar-free
fi

apt-get --yes install unrar
if [ $? -gt 0 ]; then
  apt-get --yes install unrar-free
fi

apt-get --yes install dnsutils

#ffmpeg from source install (with ALL freaking extensions/codecs, because *EXPLOSION !*
#ffmpeg install
wget http://www.ffmpeg.org/releases/ffmpeg-$FFMPEGVERSION.tar.gz
tar zxf ffmpeg-$FFMPEGVERSION.tar.gz && cd ffmpeg-$FFMPEGVERSION
./configure --enable-gpl --enable-nonfree --enable-postproc --enable-pthreads --enable-x11grab --enable-swscale --enable-version3 --enable-shared --disable-yasm --enable-filter=movie --enable-frei0r --enable-libdc1394 --enable-libfaac --enable-libmp3lame --enable-libx264 --enable-libxvid --enable-libfreetype --enable-libvorbis --enable-libgsm --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libopenjpeg --enable-librtmp \
--enable-libschroedinger --enable-libspeex --enable-libtheora --enable-libvpx \
--enable-libvo-amrwbenc --enable-libvo-aacenc --enable-libaacplus \
--enable-bzlib --enable-openssl --enable-gnutls --enable-openal --enable-libv4l2 \
--enable-libpulse --enable-libmodplug --enable-libass --enable-libcdio --enable-vdpau --enable-libbluray
make -j$(grep -c ^processor /proc/cpuinfo)
make install && ldconfig
#end of ffmpeg install




if [ "$CHROOTJAIL1" = "YES" ]; then
  cd /etc/seedbox-from-scratch
  tar xvfz jailkit-2.17.tar.gz -C /etc/seedbox-from-scratch/source/
  cd source/jailkit-2.17
  ./debian/rules binary
  cd ..
  dpkg -i jailkit_2.17-1_*.deb
fi

# 8.1 additional packages for Ubuntu
# this is better to be apart from the others
apt-get --yes install php5-fpm
apt-get --yes install php5-xcache

#Check if its Debian an do a sysvinit by systemd replacement:

  dpkg --force-remove-essential -r  sysvinit
  apt-get -y --force-yes -t wheezy-backports install systemd systemd-sysv

#apt-get --yes --force-yes install vsftpd
# from now on, vsftpd is build from source... i'm done with debian's 7 packages that are bazillions versions late and debians packet manager shenanigans!
#cd /tmp/
#wget https://security.appspot.com/downloads/vsftpd-3.0.2.tar.gz
#tar xzvf vsftpd-3.0.2.tar.gz
#cd vsftpd-3.0.2/
#echo "#define VSF_BUILD_SSL" >>builddefs.h
#make
#make install

#or maybe direct from debian?
#wget http://ftp.debian.org/debian/pool/main/v/vsftpd/vsftpd_3.0.2-17_amd64.deb
#dpkg -i vsftpd_3.0.2-17_amd64.deb

#BACKPORTS TO THE RESCUE (nope didn't work)
#apt-get -y --force-yes -t wheezy-backports install 

echo "deb http://ftp.cyconet.org/debian wheezy-updates main non-free contrib" >> /etc/apt/sources.list.d/wheezy-updates.cyconet.list
aptitude update
aptitude install -y -o Aptitude::Cmdline::ignore-trust-violations=true -t wheezy-updates debian-cyconet-archive-keyring vsftpd

perl -pi -e "s/anonymous_enable\=YES/\#anonymous_enable\=YES/g" /etc/vsftpd.conf
perl -pi -e "s/connect_from_port_20\=YES/#connect_from_port_20\=YES/g" /etc/vsftpd.conf
echo "listen_port=$NEWFTPPORT1" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_enable=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "allow_anon_ssl=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "force_local_data_ssl=NO" | tee -a /etc/vsftpd.conf >> /dev/null
echo "force_local_logins_ssl=NO" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_tlsv1=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_sslv2=NO" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_sslv3=NO" | tee -a /etc/vsftpd.conf >> /dev/null
echo "require_ssl_reuse=NO" | tee -a /etc/vsftpd.conf >> /dev/null
echo "ssl_ciphers=HIGH" | tee -a /etc/vsftpd.conf >> /dev/null
echo "rsa_cert_file=/etc/ssl/private/vsftpd.pem" | tee -a /etc/vsftpd.conf >> /dev/null
echo "local_enable=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "write_enable=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "local_umask=022" | tee -a /etc/vsftpd.conf >> /dev/null
echo "chroot_local_user=YES" | tee -a /etc/vsftpd.conf >> /dev/null
echo "chroot_list_file=/etc/vsftpd.chroot_list" | tee -a /etc/vsftpd.conf >> /dev/null
echo "passwd_chroot_enable=yes" | tee -a /etc/vsftpd.conf >> /dev/null #added to enable vsftpd to work without filezilla complaining
echo "allow_writeable_chroot=YES" | tee -a /etc/vsftpd.conf >> /dev/null  
  
  
# 8.3 Generate our lists of ports and RPC and create variables

#permanently adding scripts to PATH to all users and root
echo "PATH=$PATH:/etc/seedbox-from-scratch:/sbin" | tee -a /etc/profile > /dev/null
echo "export PATH" | tee -a /etc/profile > /dev/null
echo "PATH=$PATH:/etc/seedbox-from-scratch:/sbin" | tee -a /root/.bashrc > /dev/null
echo "export PATH" | tee -a /root/.bashrc > /dev/null

rm -f /etc/seedbox-from-scratch/ports.txt
for i in $(seq 51101 51999)
do
  echo "$i" | tee -a /etc/seedbox-from-scratch/ports.txt > /dev/null
done

rm -f /etc/seedbox-from-scratch/rpc.txt
for i in $(seq 2 1000)
do
  echo "RPC$i"  | tee -a /etc/seedbox-from-scratch/rpc.txt > /dev/null
done

# 8.4

if [ "$INSTALLWEBMIN1" = "YES" ]; then
  #if webmin isup, download key
  WEBMINDOWN=YES
  ping -c1 -w2 www.webmin.com > /dev/null
  if [ $? = 0 ] ; then
    wget -t 5 http://www.webmin.com/jcameron-key.asc
    apt-key add jcameron-key.asc
    if [ $? = 0 ] ; then
      WEBMINDOWN=NO
    fi
  fi

  if [ "$WEBMINDOWN"="NO" ] ; then
    #add webmin source
    echo "" | tee -a /etc/apt/sources.list > /dev/null
    echo "deb http://download.webmin.com/download/repository sarge contrib" | tee -a /etc/apt/sources.list > /dev/null
    cd /tmp
  fi

  if [ "$WEBMINDOWN" = "NO" ]; then
    apt-get --yes update
    apt-get --yes install webmin
  fi
fi

if [ "$INSTALLFAIL2BAN1" = "YES" ]; then
  apt-get --yes install fail2ban
  cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.conf.original
  cp /etc/seedbox-from-scratch/etc.fail2ban.jail.conf.template /etc/fail2ban/jail.conf
  fail2ban-client reload
fi

# 9.
a2enmod ssl
a2enmod auth_digest
a2enmod reqtimeout
#a2enmod scgi ############### if we cant make python-scgi works

# 10.

#remove timeout if  there are any
perl -pi -e "s/^Timeout [0-9]*$//g" /etc/apache2/apache2.conf

echo "" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "#seedbox values" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "ServerSignature Off" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "ServerTokens Prod" | tee -a /etc/apache2/apache2.conf > /dev/null
echo "Timeout 30" | tee -a /etc/apache2/apache2.conf > /dev/null

service apache2 restart

echo "$IPADDRESS1" > /etc/seedbox-from-scratch/hostname.info

# 11.

export TEMPHOSTNAME1=tsfsSeedBox
export CERTPASS1=@@$TEMPHOSTNAME1.$NEWUSER1.ServerP7s$
export NEWUSER1
export IPADDRESS1

echo "$NEWUSER1" > /etc/seedbox-from-scratch/mainuser.info
echo "$CERTPASS1" > /etc/seedbox-from-scratch/certpass.info

bash /etc/seedbox-from-scratch/createOpenSSLCACertificate

mkdir -p /etc/ssl/private/
openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout /etc/ssl/private/vsftpd.pem -out /etc/ssl/private/vsftpd.pem -config /etc/seedbox-from-scratch/ssl/CA/caconfig.cnf



# 13.
mv /etc/apache2/sites-available/default /etc/apache2/sites-available/default.ORI
rm -f /etc/apache2/sites-available/default

cp /etc/seedbox-from-scratch/etc.apache2.default.template /etc/apache2/sites-available/default
perl -pi -e "s/http\:\/\/.*\/rutorrent/http\:\/\/$IPADDRESS1\/rutorrent/g" /etc/apache2/sites-available/default
perl -pi -e "s/<servername>/$IPADDRESS1/g" /etc/apache2/sites-available/default
perl -pi -e "s/<username>/$NEWUSER1/g" /etc/apache2/sites-available/default

echo "ServerName $IPADDRESS1" | tee -a /etc/apache2/apache2.conf > /dev/null

# 14.
a2ensite default-ssl

#14.1
#ln -s /etc/apache2/mods-available/scgi.load /etc/apache2/mods-enabled/scgi.load
#service apache2 restart
#apt-get --yes install libxmlrpc-core-c3-dev

# 15.
svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/stable
# 16.
cd stable
./configure --prefix=/usr --enable-libxml2-backend --disable-libwww-client --disable-wininet-client --disable-abyss-server --disable-cgi-server
make -j$(grep -c ^processor /proc/cpuinfo)
make install

# 21.

bash /etc/seedbox-from-scratch/installRTorrent $RTORRENT1

# 22.
cd /var/www
rm -f -r rutorrent
svn checkout http://rutorrent.googlecode.com/svn/trunk/rutorrent
svn checkout http://rutorrent.googlecode.com/svn/trunk/plugins
rm -r -f rutorrent/plugins
mv plugins rutorrent/

#setting up mktorrent as default torrent creator
rm /var/www/rutorrent/plugins/create/conf.php
cp /etc/seedbox-from-scratch/conf-create.php /var/www/rutorrent/plugins/create/conf.php


#cp /etc/seedbox-from-scratch/action.php.template /var/www/rutorrent/plugins/diskspace/action.php

groupadd admin

echo "www-data ALL=(root) NOPASSWD: /usr/sbin/repquota" | tee -a /etc/sudoers > /dev/null

cp /etc/seedbox-from-scratch/favicon.ico /var/www/

# 26.
cd /tmp
wget http://downloads.sourceforge.net/mediainfo/MediaInfo_CLI_0.7.69_GNU_FromSource.tar.bz2
tar jxvf MediaInfo_CLI_0.7.69_GNU_FromSource.tar.bz2
cd MediaInfo_CLI_GNU_FromSource/
sh CLI_Compile.sh
cd MediaInfo/Project/GNU/CLI
make -j$(grep -c ^processor /proc/cpuinfo)
make install

cd /var/www/rutorrent/js/
git clone https://github.com/gabceb/jquery-browser-plugin.git
mv jquery-browser-plugin/dist/jquery.browser.js .
rm -r -f jquery-browser-plugin
sed -i '31i\<script type=\"text/javascript\" src=\"./js/jquery.browser.js\"></script> ' /var/www/rutorrent/index.html

cd /var/www/rutorrent/plugins
git clone https://github.com/autodl-community/autodl-rutorrent.git
mv autodl-rutorrent autodl-irssi
cd autodl-irssi

# 30.

cp /etc/jailkit/jk_init.ini /etc/jailkit/jk_init.ini.original
echo "" | tee -a /etc/jailkit/jk_init.ini >> /dev/null
bash /etc/seedbox-from-scratch/updatejkinit

# 31.

#clear
#echo "ZNC Configuration"
#echo ""
#znc --makeconf
#/home/antoniocarlos/.znc/configs/znc.conf

# 32. Adding community trackers
cd ~/.irssi/scripts/AutodlIrssi/trackers/
git clone https://github.com/autodl-community/autodl-trackers.git
mv ./autodl-trackers/* .
rm -rf autodl-trackers

# Installing poweroff button on ruTorrent

cd /var/www/rutorrent/plugins/
wget http://rutorrent-logoff.googlecode.com/files/logoff-1.0.tar.gz
tar -zxf logoff-1.0.tar.gz
rm -f logoff-1.0.tar.gz

# Installing Filemanager and MediaStream

rm -f -R /var/www/rutorrent/plugins/filemanager
rm -f -R /var/www/rutorrent/plugins/fileupload
rm -f -R /var/www/rutorrent/plugins/mediastream
rm -f -R /var/www/stream

cd /var/www/rutorrent/plugins/
svn co http://svn.rutorrent.org/svn/filemanager/trunk/mediastream

cd /var/www/rutorrent/plugins/
svn co http://svn.rutorrent.org/svn/filemanager/trunk/filemanager

cp /etc/seedbox-from-scratch/rutorrent.plugins.filemanager.conf.php.template /var/www/rutorrent/plugins/filemanager/conf.php

mkdir -p /var/www/stream/
ln -s /var/www/rutorrent/plugins/mediastream/view.php /var/www/stream/view.php
chown www-data: /var/www/stream
chown www-data: /var/www/stream/view.php

echo "<?php \$streampath = 'http://$IPADDRESS1/stream/view.php'; ?>" | tee /var/www/rutorrent/plugins/mediastream/conf.php > /dev/null

# 32.2 # FILEUPLOAD
cd /var/www/rutorrent/plugins/
svn co http://svn.rutorrent.org/svn/filemanager/trunk/fileupload
chmod 775 /var/www/rutorrent/plugins/fileupload/scripts/upload
apt-get install spidermonkey-bin
wget -O /tmp/plowshare.deb https://plowshare.googlecode.com/files/plowshare3_1~git20140112.c250e07-1_all.deb
dpkg -i /tmp/plowshare.deb
apt-get --yes -f install

# 32.2
chown -R www-data:www-data /var/www/rutorrent
chmod -R 755 /var/www/rutorrent

#32.3

perl -pi -e "s/\\\$topDirectory\, \\\$fm/\\\$homeDirectory\, \\\$topDirectory\, \\\$fm/g" /var/www/rutorrent/plugins/filemanager/flm.class.php
perl -pi -e "s/\\\$this\-\>userdir \= addslash\(\\\$topDirectory\)\;/\\\$this\-\>userdir \= \\\$homeDirectory \? addslash\(\\\$homeDirectory\) \: addslash\(\\\$topDirectory\)\;/g" /var/www/rutorrent/plugins/filemanager/flm.class.php
perl -pi -e "s/\\\$topDirectory/\\\$homeDirectory/g" /var/www/rutorrent/plugins/filemanager/settings.js.php

#32.4
unzip /etc/seedbox-from-scratch/rutorrent-oblivion.zip -d /var/www/rutorrent/plugins/
echo "" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo "/* for Oblivion */" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo ".meter-value-start-color { background-color: #E05400 }" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo ".meter-value-end-color { background-color: #8FBC00 }" | tee -a /var/www/rutorrent/css/style.css > /dev/null
echo "::-webkit-scrollbar {width:12px;height:12px;padding:0px;margin:0px;}" | tee -a /var/www/rutorrent/css/style.css > /dev/null
perl -pi -e "s/\$defaultTheme \= \"\"\;/\$defaultTheme \= \"Oblivion\"\;/g" /var/www/rutorrent/plugins/theme/conf.php

ln -s /etc/seedbox-from-scratch/seedboxInfo.php.template /var/www/seedboxInfo.php

# 32.5

cd /var/www/rutorrent/plugins/
rm -r /var/www/rutorrent/plugins/fileshare
rm -r /var/www/share
svn co http://svn.rutorrent.org/svn/filemanager/trunk/fileshare
mkdir /var/www/share
ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/share/share.php
ln -s /var/www/rutorrent/plugins/fileshare/share.php /var/www/share/index.php
chown -R www-data:www-data /var/www/share
cp /etc/seedbox-from-scratch/rutorrent.plugins.fileshare.conf.php.template /var/www/rutorrent/plugins/fileshare/conf.php
perl -pi -e "s/<servername>/$IPADDRESS1/g" /var/www/rutorrent/plugins/fileshare/conf.php

# 33.

bash /etc/seedbox-from-scratch/updateExecutables

#34.

echo $SBFSCURRENTVERSION1 > /etc/seedbox-from-scratch/version.info
echo $NEWFTPPORT1 > /etc/seedbox-from-scratch/ftp.info
echo $NEWSSHPORT1 > /etc/seedbox-from-scratch/ssh.info
echo $OPENVPNPORT1 > /etc/seedbox-from-scratch/openvpn.info

# 36.

wget -P /usr/share/ca-certificates/ --no-check-certificate https://certs.godaddy.com/repository/gd_intermediate.crt https://certs.godaddy.com/repository/gd_cross_intermediate.crt
update-ca-certificates
c_rehash

# 96.

if [ "$INSTALLOPENVPN1" = "YES" ]; then
  bash /etc/seedbox-from-scratch/installOpenVPN
fi

if [ "$INSTALLSABNZBD1" = "YES" ]; then
  bash /etc/seedbox-from-scratch/installSABnzbd
fi

if [ "$INSTALLRAPIDLEECH1" = "YES" ]; then
  bash /etc/seedbox-from-scratch/installRapidleech
fi

if [ "$INSTALLDELUGE1" = "YES" ]; then
  bash /etc/seedbox-from-scratch/installDeluge
fi

# 97.

#first user will not be jailed
#  createSeedboxUser <username> <password> <user jailed?> <ssh access?> <?>
bash /etc/seedbox-from-scratch/createSeedboxUser $NEWUSER1 $PASSWORD1 YES YES YES

# 98.

set +x verbose

clear

echo ""
echo "<<< The Seedbox From Scratch Script >>>"
echo ""
echo ""
echo ""
echo "Looks like everything is set."
echo ""
echo "Remember that your SSH port is now ======> $NEWSSHPORT1"
echo ""
echo "System will reboot now, but don't close this window until you take note of the port number: $NEWSSHPORT1"
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""
echo ""

# 99.

reboot
##################### LAST LINE ###########
